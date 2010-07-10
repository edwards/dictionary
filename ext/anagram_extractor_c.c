#include "ruby.h"
#include "version.h"
#include "string.h"

VALUE rb_mAnagramExtractorC;

VALUE rb_mAnagramExtractorC_anagrams(VALUE rb_module, VALUE rb_first_word, VALUE rb_second_word)
{
	char *first_word  = STR2CSTR(rb_first_word);
	char *second_word = STR2CSTR(rb_second_word);
	int occurrences[26] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}; // So it doesn't have trash inside of the positions of the Array.

	if(strlen(first_word) != strlen(second_word))
	{
		return Qfalse;
	}

	int length = strlen(first_word);
	int i;

	for(i = 0; i < length; ++i)
	{
		if(first_word[i] >= 'a' && first_word[i] <= 'z')
		{
			occurrences[first_word[i]-'a']++;
		} else if(first_word[i] >= 'A' && first_word[i] <= 'Z')
		{
			occurrences[first_word[i]-'A']++;
		} else {
			return Qfalse;
		}
	}

	for(i = 0; i < length; ++i)
	{
		if(second_word[i] >= 'a' && second_word[i] <= 'z')
		{
			if(--occurrences[second_word[i]-'a'] < 0)
				return Qfalse;
		} else if(second_word[i] >= 'A' && second_word[i] <= 'Z')
		{
			if(--occurrences[second_word[i]-'A'] < 0)
				return Qfalse;
		} else {
			return Qfalse;
		}
	}

	for(i = 0; i < 26; ++i) 
		if(occurrences[i] != 0)
			return Qfalse;	


	return Qtrue;
}

void Init_anagram_extractor_c()
{
	VALUE rb_mDictionary = rb_const_get(rb_cObject, rb_intern("Dictionary"));
	rb_mAnagramExtractorC = rb_define_module_under(rb_mDictionary, "AnagramExtractorC");

	rb_define_method(rb_mAnagramExtractorC, "anagrams?", rb_mAnagramExtractorC_anagrams, 2);
}
