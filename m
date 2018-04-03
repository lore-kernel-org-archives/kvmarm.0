From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: [RFC PATCH v2 05/15] khwasan: initialize shadow to 0xff
Date: Tue, 3 Apr 2018 16:43:10 +0200
Message-ID: <CAAeHK+z37yRzK1Q6F32G=eB6_k+s_YQOoR8LLqNppxZsKMWiZg@mail.gmail.com>
References: <cover.1521828273.git.andreyknvl@google.com>
 <774016f707e494da419a2d0d8a03409e6befcaf8.1521828274.git.andreyknvl@google.com>
 <2ab69c9c-6e80-ea79-e72e-012753ed3db0@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8CE349F88
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Apr 2018 10:35:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q4pE6xe7-Cbt for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Apr 2018 10:34:47 -0400 (EDT)
Received: from mail-io0-f194.google.com (mail-io0-f194.google.com
 [209.85.223.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 31060402E7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Apr 2018 10:34:47 -0400 (EDT)
Received: by mail-io0-f194.google.com with SMTP id m83so22297862ioi.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Apr 2018 07:43:13 -0700 (PDT)
In-Reply-To: <2ab69c9c-6e80-ea79-e72e-012753ed3db0@virtuozzo.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Julien Thierry <julien.thierry@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christopher Li <sparse@chrisli.org>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Paul Lawrence <paullawrence@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Yury Norov <ynorov@caviumnetworks.com>, Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Michael Weiser <michael.weiser@gmx.de>, Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@google.com>, Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, Mark Brand <markbrand@google.com>, kasan-dev <kasan-dev@googlegroups.com>, kvmarm@lists.cs.columbia.edu, linux-sparse@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, David Rientjes <rientjes@google.com>, Ramana
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 30, 2018 at 6:07 PM, Andrey Ryabinin
<aryabinin@virtuozzo.com> wrote:
> On 03/23/2018 09:05 PM, Andrey Konovalov wrote:
>> A KHWASAN shadow memory cell contains a memory tag, that corresponds to
>> the tag in the top byte of the pointer, that points to that memory. The
>> native top byte value of kernel pointers is 0xff, so with KHWASAN we
>> need to initialize shadow memory to 0xff. This commit does that.
>>
>> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
>> ---
>>  arch/arm64/mm/kasan_init.c | 11 ++++++++++-
>>  include/linux/kasan.h      |  8 ++++++++
>>  mm/kasan/common.c          |  7 +++++++
>>  3 files changed, 25 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
>> index dabfc1ecda3d..d4bceba60010 100644
>> --- a/arch/arm64/mm/kasan_init.c
>> +++ b/arch/arm64/mm/kasan_init.c
>> @@ -90,6 +90,10 @@ static void __init kasan_pte_populate(pmd_t *pmdp, unsigned long addr,
>>       do {
>>               phys_addr_t page_phys = early ? __pa_symbol(kasan_zero_page)
>>                                             : kasan_alloc_zeroed_page(node);
>> +#if KASAN_SHADOW_INIT != 0
>> +             if (!early)
>> +                     memset(__va(page_phys), KASAN_SHADOW_INIT, PAGE_SIZE);
>> +#endif
>
> Less ugly way to do the same:
>         if (KASAN_SHADOW_INIT != 0 && !early)
>                 memset(__va(page_phys), KASAN_SHADOW_INIT, PAGE_SIZE);
>
>
> But the right approach here would be allocating uninitialized memory (see memblock_virt_alloc_try_nid_raw())
> and do "if (!early) memset(.., KASAN_SHADOW_INIT, ..)" afterwards.

Will do!

>
>
>>               next = addr + PAGE_SIZE;
>>               set_pte(ptep, pfn_pte(__phys_to_pfn(page_phys), PAGE_KERNEL));
>>       } while (ptep++, addr = next, addr != end && pte_none(READ_ONCE(*ptep)));
>> @@ -139,6 +143,11 @@ asmlinkage void __init kasan_early_init(void)
>>               KASAN_SHADOW_END - (1UL << (64 - KASAN_SHADOW_SCALE_SHIFT)));
>>       BUILD_BUG_ON(!IS_ALIGNED(KASAN_SHADOW_START, PGDIR_SIZE));
>>       BUILD_BUG_ON(!IS_ALIGNED(KASAN_SHADOW_END, PGDIR_SIZE));
>> +
>> +#if KASAN_SHADOW_INIT != 0
>> +     memset(kasan_zero_page, KASAN_SHADOW_INIT, PAGE_SIZE);
>> +#endif
>> +
>
>  if (KASAN_SHADOW_INIT)
>         memset(...)
>
> Note that, if poisoning of stack variables will work in the same fashion as classic
> KASAN (compiler generated code writes to shadow in function prologue) than content
> of this page will be ruined very fast. Which makes this initialization questionable.

I think I agree with you on this. Since this page immediately gets
dirty and we ignore all reports until proper shadow is set up anyway,
there's no need to initialize it.

>
>
>
>>       kasan_pgd_populate(KASAN_SHADOW_START, KASAN_SHADOW_END, NUMA_NO_NODE,
>>                          true);
>>  }
>> @@ -235,7 +244,7 @@ void __init kasan_init(void)
>>               set_pte(&kasan_zero_pte[i],
>>                       pfn_pte(sym_to_pfn(kasan_zero_page), PAGE_KERNEL_RO));
>>
>> -     memset(kasan_zero_page, 0, PAGE_SIZE);
>> +     memset(kasan_zero_page, KASAN_SHADOW_INIT, PAGE_SIZE);
>>       cpu_replace_ttbr1(lm_alias(swapper_pg_dir));
>>
>>       /* At this point kasan is fully initialized. Enable error messages */
>> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
>> index 3c45e273a936..700734dff218 100644
>> --- a/include/linux/kasan.h
>> +++ b/include/linux/kasan.h
>> @@ -139,6 +139,8 @@ static inline size_t kasan_metadata_size(struct kmem_cache *cache) { return 0; }
>>
>>  #ifdef CONFIG_KASAN_CLASSIC
>>
>> +#define KASAN_SHADOW_INIT 0
>> +
>>  void kasan_cache_shrink(struct kmem_cache *cache);
>>  void kasan_cache_shutdown(struct kmem_cache *cache);
>>
>> @@ -149,4 +151,10 @@ static inline void kasan_cache_shutdown(struct kmem_cache *cache) {}
>>
>>  #endif /* CONFIG_KASAN_CLASSIC */
>>
>> +#ifdef CONFIG_KASAN_TAGS
>> +
>> +#define KASAN_SHADOW_INIT 0xFF
>> +
>> +#endif /* CONFIG_KASAN_TAGS */
>> +
>>  #endif /* LINUX_KASAN_H */
>> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
>> index 08f6c8cb9f84..f4ccb9425655 100644
>> --- a/mm/kasan/common.c
>> +++ b/mm/kasan/common.c
>> @@ -253,6 +253,9 @@ int kasan_module_alloc(void *addr, size_t size)
>>                       __builtin_return_address(0));
>>
>>       if (ret) {
>> +#if KASAN_SHADOW_INIT != 0
>> +             __memset(ret, KASAN_SHADOW_INIT, shadow_size);
>> +#endif
>
> Drop __GFP_ZERO from above and remove this #if/#endif.

Will do!

>
>
>>               find_vm_area(addr)->flags |= VM_KASAN;
>>               kmemleak_ignore(ret);
>>               return 0;
>> @@ -297,6 +300,10 @@ static int __meminit kasan_mem_notifier(struct notifier_block *nb,
>>               if (!ret)
>>                       return NOTIFY_BAD;
>>
>> +#if KASAN_SHADOW_INIT != 0
>> +             __memset(ret, KASAN_SHADOW_INIT, shadow_end - shadow_start);
>> +#endif
>> +
>
> No need to initialize anything here, kasan_free_pages() will do this later.

OK, will fix this!

>
>
>>               kmemleak_ignore(ret);
>>               return NOTIFY_OK;
>>       }
>>

Thanks!
