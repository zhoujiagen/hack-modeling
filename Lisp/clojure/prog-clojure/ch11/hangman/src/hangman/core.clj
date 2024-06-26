(ns hangman.core
  (:require [clojure.java.io :as jio]
            [clojure.string :as str]))

; 猜单词游戏: https://zh.wikipedia.org/wiki/%E7%8C%9C%E5%96%AE%E8%A9%9E%E9%81%8A%E6%88%B2

;;; letter

(defonce letters (mapv char (range (int \a) (inc (int \z)))))

(defn rand-letter []
  (rand-nth letters))

;;; word

(defn valid-letter? [c]
  (<= (int \a) (int c) (int \z)))

(defonce available-words
  (with-open [r (jio/reader "words.txt")]
    (->> (line-seq r)
         (filter #(every? valid-letter? %))
         vec)))

(defn rand-word []
  (rand-nth available-words))

;;; player

(defprotocol Player
  (next-guess [player progress]))

(def random-player
  (reify Player
    (next-guess [_ progress] (rand-letter))))

(defrecord ChoicesPlayer [choices]
  Player
  (next-guess [_ progress]
    (let [guess (first @choices)]
      (swap! choices rest)
      guess)))

(defn choices-player [choices]
  (->ChoicesPlayer (atom choices)))

(defn shuffled-player []
  (choices-player (shuffle letters)))

(defn alpha-player []
  (choices-player letters))

(defn freq-player []
  (choices-player (seq "etaoinshrdlcumwfgypbvkjxqz")))

(defn take-guess []
  (println)
  (print "Enter a letter: ")
  (flush)
  (let [input (.readLine *in*)
        line (str/trim input)]
    (cond
      (str/blank? line) (recur)
      (valid-letter? (first line)) (first line)
      :else (do
              (println "That is not a valid letter!")
              (recur)))))

(def interactive-player
  (reify Player
    (next-guess [_ progress] (take-guess))))


;;; game

; word: a string, treated as a sequence of characters
; progress: a sequence of characters, either the actual character or a blank

(defn new-progress [word]
  (repeat (count word) \_))

(defn update-progress [progress word guess]
  (map #(if (= %1 guess) guess %2) word progress))

(defn complete? [progress word]
  (= progress (seq word)))

(defn report [begin-progress guess end-progress]
  (println)
  (println "You gueesed:" guess)
  (if (= begin-progress end-progress)
    (if (some #{guess} end-progress)
      (println "Sorry, you already guessed:" guess)
      (println "Sorry, the word does not contain:" guess))
    (println "The letter" guess "is in the word!"))
  (println "Progress so far:" (apply str end-progress)))

(defn game [word player & {:keys [verbose] :or {verbose false}}]
  (when verbose
    (println "You are guessing a word with" (count word) "letters"))
  (loop [progress (new-progress word)
         guesses 1]
    (let [guess (next-guess player progress)
          progress' (update-progress progress word guess)]
      (when verbose (report progress guess progress'))
      (if (complete? progress' word)
        guesses
        (recur progress' (inc guesses))))))

;;; main
(defn -main [& args]
  (game (rand-word) interactive-player :verbose true))
