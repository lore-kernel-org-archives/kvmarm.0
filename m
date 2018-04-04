From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: Re: [RFC PATCH v2 13/15] khwasan: add hooks implementation
Date: Wed, 4 Apr 2018 15:39:50 +0300
Message-ID: <0c4397da-e231-0044-986f-b8468314be76@virtuozzo.com>
References: <cover.1521828273.git.andreyknvl@google.com>
 <ba4a74ba1bc48dd66a3831143c3119d13c291fe3.1521828274.git.andreyknvl@google.com>
 <805d1e85-2d3c-2327-6e6c-f14a56dc0b67@virtuozzo.com>
 <CAAeHK+yg5ODeDy7k9fako5mcCLLnBrO729Zp_-UtDuzh3hZgZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFBDD4029E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Apr 2018 08:31:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id inqVEaQ8u5G9 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Apr 2018 08:30:39 -0400 (EDT)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01on0093.outbound.protection.outlook.com [104.47.0.93])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D05B401CD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Apr 2018 08:30:39 -0400 (EDT)
In-Reply-To: <CAAeHK+yg5ODeDy7k9fako5mcCLLnBrO729Zp_-UtDuzh3hZgZA@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Julien Thierry <julien.thierry@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christopher Li <sparse@chrisli.org>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Paul Lawrence <paullawrence@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Yury Norov <ynorov@caviumnetworks.com>, Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Michael Weiser <michael.weiser@gmx.de>, Ingo Molnar <mingo@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, Mark Brand <markbrand@google.com>, kasan-dev <kasan-dev@googlegroups.com>, kvmarm@lists.cs.columbia.edu, linux-sparse@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, David Rientjes <rientjes@google.com>, Ramana Radhakrishnan <Ramana.Radhakrishna>
List-Id: kvmarm@lists.cs.columbia.edu

On 04/03/2018 05:59 PM, Andrey Konovalov wrote:

>>
>>
>>>  void check_memory_region(unsigned long addr, size_t size, bool write,
>>>                               unsigned long ret_ip)
>>>  {
>>> +     u8 tag;
>>> +     u8 *shadow_first, *shadow_last, *shadow;
>>> +     void *untagged_addr;
>>> +
>>> +     tag = get_tag((const void *)addr);
>>> +
>>> +     /* Ignore accesses for pointers tagged with 0xff (native kernel
>>> +      * pointer tag) to suppress false positives caused by kmap.
>>> +      *
>>> +      * Some kernel code was written to account for archs that don't keep
>>> +      * high memory mapped all the time, but rather map and unmap particular
>>> +      * pages when needed. Instead of storing a pointer to the kernel memory,
>>> +      * this code saves the address of the page structure and offset within
>>> +      * that page for later use. Those pages are then mapped and unmapped
>>> +      * with kmap/kunmap when necessary and virt_to_page is used to get the
>>> +      * virtual address of the page. For arm64 (that keeps the high memory
>>> +      * mapped all the time), kmap is turned into a page_address call.
>>> +
>>> +      * The issue is that with use of the page_address + virt_to_page
>>> +      * sequence the top byte value of the original pointer gets lost (gets
>>> +      * set to 0xff.
>>> +      */
>>> +     if (tag == 0xff)
>>> +             return;
>>
>> You can save tag somewhere in page struct and make page_address() return tagged address.
>>
>> I'm not sure it might be even possible to squeeze the tag into page->flags on some configurations,
>> see include/linux/page-flags-layout.h
> 
> One page can contain multiple objects with different tags, so we would
> need to save the tag for each of them.

What do you mean? Slab page? The per-page tag is needed only for !PageSlab pages.
For slab pages we have kmalloc/kmem_cache_alloc() which already return properly tagged address.

But the page allocator returns a pointer to struct page. One has to call page_address(page)
to use that page. Returning 'ignore-me'-tagged address from page_address() makes the whole
class of bugs invisible to KHWASAN. This is a serious downside comparing to classic KASAN which can
detect missuses of page allocator API.



>>
>>
>>>  void *kasan_slab_alloc(struct kmem_cache *cache, void *object, gfp_t flags)
>>>  {
>>> +     if (!READ_ONCE(khwasan_enabled))
>>> +             return object;
>>
>> ...
>>
>>>  void *kasan_kmalloc(struct kmem_cache *cache, const void *object,
>>>                       size_t size, gfp_t flags)
>>>  {
>>
>>> +     if (!READ_ONCE(khwasan_enabled))
>>> +             return (void *)object;
>>> +
>>
>> ...
>>
>>>  void *kasan_kmalloc_large(const void *ptr, size_t size, gfp_t flags)
>>>  {
>>
>> ...
>>
>>> +
>>> +     if (!READ_ONCE(khwasan_enabled))
>>> +             return (void *)ptr;
>>> +
>>
>> I don't see any possible way of khwasan_enabled being 0 here.
> 
> Can't kmem_cache_alloc be called for the temporary caches that are
> used before the slab allocator and kasan are initialized?

kasan_init() runs before allocators are initialized.
slab allocator obviously has to be initialized before it can be used.
