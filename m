From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] ARM/arm64: KVM: test properly for a PTE's uncachedness
Date: Mon, 9 Nov 2015 17:27:40 +0100
Message-ID: <CAKv+Gu9RkX1A4rLvTbgkhTQxcVnLjc1tHRaMAOq0cgcpGvkpRg@mail.gmail.com>
References: <1446810188-13727-1-git-send-email-ard.biesheuvel@linaro.org>
 <20151109162159.GA12968@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FC4441294
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2015 11:27:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qwz4dIozvlRu for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2015 11:27:38 -0500 (EST)
Received: from mail-ig0-f182.google.com (mail-ig0-f182.google.com
 [209.85.213.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED6C141278
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2015 11:27:37 -0500 (EST)
Received: by igbhv6 with SMTP id hv6so78789868igb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2015 08:27:40 -0800 (PST)
In-Reply-To: <20151109162159.GA12968@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 9 November 2015 at 17:21, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> On Fri, Nov 06, 2015 at 12:43:08PM +0100, Ard Biesheuvel wrote:
>> The open coded tests for checking whether a PTE maps a page as
>> uncached use a flawed 'pte_val(xxx) & CONST != CONST' pattern,
>> which is not guaranteed to work since the type of a mapping is an
>> index into the MAIR table, not a set of mutually exclusive bits.
>>
>> Considering that, on arm64, the S2 type definitions use the following
>> MAIR indexes
>>
>>     #define MT_S2_NORMAL            0xf
>>     #define MT_S2_DEVICE_nGnRE      0x1
>>
>> we have been getting lucky merely because the S2 device mappings also
>> have the PTE_UXN bit set, which means that a device PTE still does not
>> equal a normal PTE after masking with the former type.
>>
>> Instead, implement proper checking against the MAIR indexes that are
>> known to define uncached memory attributes.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  arch/arm/include/asm/kvm_mmu.h   | 11 +++++++++++
>>  arch/arm/kvm/mmu.c               |  5 ++---
>>  arch/arm64/include/asm/kvm_mmu.h | 12 ++++++++++++
>>  3 files changed, 25 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
>> index 405aa1883307..422973835d41 100644
>> --- a/arch/arm/include/asm/kvm_mmu.h
>> +++ b/arch/arm/include/asm/kvm_mmu.h
>> @@ -279,6 +279,17 @@ static inline void __kvm_extend_hypmap(pgd_t *boot_hyp_pgd,
>>                                      pgd_t *merged_hyp_pgd,
>>                                      unsigned long hyp_idmap_start) { }
>>
>> +static inline bool __kvm_pte_is_uncached(pte_t pte)
>> +{
>> +     switch (pte_val(pte) & L_PTE_MT_MASK) {
>> +     case L_PTE_MT_UNCACHED:
>> +     case L_PTE_MT_BUFFERABLE:
>> +     case L_PTE_MT_DEV_SHARED:
>> +             return true;
>> +     }
>
> so PTEs created by setting PAGE_S2_DEVICE will end up hitting in one of
> these because L_PTE_S2_MT_DEV_SHARED is the same as L_PTE_MT_BUFFERABLE
> for stage-2 mappings and PAGE_HYP_DEVICE end up using
> L_PTE_MT_DEV_SHARED.
>
> Totally obvious.
>

Hmm, perhaps not. Would you prefer all aliases of the L_PTE_MT_xx
constants that map to device permissions to be listed here?

>> +     return false;
>> +}
>> +
>>  #endif       /* !__ASSEMBLY__ */
>>
>>  #endif /* __ARM_KVM_MMU_H__ */
>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>> index 6984342da13d..eb9a06e3dbee 100644
>> --- a/arch/arm/kvm/mmu.c
>> +++ b/arch/arm/kvm/mmu.c
>> @@ -213,7 +213,7 @@ static void unmap_ptes(struct kvm *kvm, pmd_t *pmd,
>>                       kvm_tlb_flush_vmid_ipa(kvm, addr);
>>
>>                       /* No need to invalidate the cache for device mappings */
>> -                     if ((pte_val(old_pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
>> +                     if (!__kvm_pte_is_uncached(old_pte))
>>                               kvm_flush_dcache_pte(old_pte);
>>
>>                       put_page(virt_to_page(pte));
>> @@ -305,8 +305,7 @@ static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
>>
>>       pte = pte_offset_kernel(pmd, addr);
>>       do {
>> -             if (!pte_none(*pte) &&
>> -                 (pte_val(*pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
>> +             if (!pte_none(*pte) && !__kvm_pte_is_uncached(*pte))
>>                       kvm_flush_dcache_pte(*pte);
>>       } while (pte++, addr += PAGE_SIZE, addr != end);
>>  }
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index 61505676d085..5806f412a47a 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -302,5 +302,17 @@ static inline void __kvm_extend_hypmap(pgd_t *boot_hyp_pgd,
>>       merged_hyp_pgd[idmap_idx] = __pgd(__pa(boot_hyp_pgd) | PMD_TYPE_TABLE);
>>  }
>>
>> +static inline bool __kvm_pte_is_uncached(pte_t pte)
>> +{
>> +     switch (pte_val(pte) & PTE_ATTRINDX_MASK) {
>> +     case PTE_ATTRINDX(MT_DEVICE_nGnRnE):
>> +     case PTE_ATTRINDX(MT_DEVICE_nGnRE):
>> +     case PTE_ATTRINDX(MT_DEVICE_GRE):
>> +     case PTE_ATTRINDX(MT_NORMAL_NC):
>> +             return true;
>> +     }
>> +     return false;
>> +}
>> +
>>  #endif /* __ASSEMBLY__ */
>>  #endif /* __ARM64_KVM_MMU_H__ */
>> --
>> 1.9.1
>>
>
> Thanks for this patch, I'll queue it.
>
> -Christoffer
