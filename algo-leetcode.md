
### 优质代码收藏

- [判断异位词](https://leetcode-cn.com/problems/valid-anagram)

```java
public class Solution {
    // 非常简洁的实现，s 增加频次，t 减少频次
    public boolean isAnagram(String s, String t) {
        int[] alphabet = new int[26];
        for (int i = 0; i < s.length(); i++) alphabet[s.charAt(i) - 'a']++;
        for (int i = 0; i < t.length(); i++) alphabet[t.charAt(i) - 'a']--;
        for (int i : alphabet) if (i != 0) return false;
        return true;
    }
}
```
