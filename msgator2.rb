# 20161013 schmutzro@post.ch
#

class FastLevenshtein
   def initialize(a, b)
      @a = a
      @b = b
   end
 
   def match
      # FIXME: insert trivial cases where one string is empty, etc (emptyness isn't handled properly below :) )
      a_endindex = @a.length-1
      b_endindex = @b.length-1
      q = Array.new # subtree-queue
      r = Array.new # results
      q_next = Array.new
      q << [0, 0, 0] # tuples of i, j, cost
      while q.length>0
         (i, j, cost) = q.shift

         # terminating cases:
         if (i==a_endindex) || (j==b_endindex) # either one at end, beeing a bit cautious about counting-to-infinity :)
            cost += (@a[i]==@b[j]) ? 0 : 1;
            if (i==a_endindex) && (j==b_endindex)
               r << cost # seemingly perfect match :)
            elsif (j==a_endindex)
               r << cost+(b_endindex-j) # at-end of a
            elsif (i==b_endindex)
               r << cost+(a_endindex-i) # at-end of b
            end
            break
         end

         # non-terminating cases: feed queue with possible advances in tree
         if (@a[i]==@b[j])
            q_next << [i+1, j+1, cost] # equal, zero-cost step
         else # no-match at this character-tuple -> split tree
            q_next << [i, j+1, cost+1]  # insertion
            q_next << [i+1, j, cost+1]  # deletion
            q_next << [i+1,j+1,cost+1]  # substitution
         end
         if q.length == 0
            q = q_next.uniq.sort {|a,b| a[2]<=>b[2]} # FIXME: sort shouldn't be neccessary... somehow the last element gets lost?
            q_next.clear
         end
         # puts "queue: #{q}"
      end
      r.min
   end
end

oldline = ""
(File.open("messages").readlines.sort.collect { |line| (line.split(/\t/))[8] }).each do |line|
   # puts "#{levenshtein(oldline, line)}\t#{oldline}\t#{line}"
   puts "#{FastLevenshtein.new(oldline, line).match}\t#{oldline}\t#{line}"
   oldline = line
end
