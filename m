From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH V2] KVM: ARM: Remove pgtable page standard functions from
 stage-2 page tables
Date: Mon, 8 Apr 2019 10:09:25 +0100
Message-ID: <77aaaaca-f9fb-cbad-74f6-e3bd159e7b37@arm.com>
References: <3be0b7e0-2ef8-babb-88c9-d229e0fdd220@arm.com>
 <1552397145-10665-1-git-send-email-anshuman.khandual@arm.com>
 <20190401161638.GB22092@fuggles.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3B4D4A44E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 05:09:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7zIumBIppm6X for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Apr 2019 05:09:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E73C74A331
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 05:09:32 -0400 (EDT)
In-Reply-To: <20190401161638.GB22092@fuggles.cambridge.arm.com>
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
To: Will Deacon <will.deacon@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>
Cc: yuzhao@google.com, catalin.marinas@arm.com, linux-mm@kvack.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 01/04/2019 17:16, Will Deacon wrote:
> [+KVM/ARM folks, since I can't take this without an Ack in place from them]
> 
> My understanding is that this patch is intended to replace patch 3/4 in
> this series:
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2019-March/638083.html
> 
> On Tue, Mar 12, 2019 at 06:55:45PM +0530, Anshuman Khandual wrote:
>> ARM64 standard pgtable functions are going to use pgtable_page_[ctor|dtor]
>> or pgtable_pmd_page_[ctor|dtor] constructs. At present KVM guest stage-2
>> PUD|PMD|PTE level page tabe pages are allocated with __get_free_page()
>> via mmu_memory_cache_alloc() but released with standard pud|pmd_free() or
>> pte_free_kernel(). These will fail once they start calling into pgtable_
>> [pmd]_page_dtor() for pages which never originally went through respective
>> constructor functions. Hence convert all stage-2 page table page release
>> functions to call buddy directly while freeing pages.
>>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Acked-by: Yu Zhao <yuzhao@google.com>
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>> Changes in V2:
>>
>> - Updated stage2_pud_free() with NOP as per Suzuki
>> - s/__free_page/free_page/ in clear_stage2_pmd_entry() for uniformity
>>
>>  arch/arm/include/asm/stage2_pgtable.h   | 4 ++--
>>  arch/arm64/include/asm/stage2_pgtable.h | 4 ++--
>>  virt/kvm/arm/mmu.c                      | 2 +-
>>  3 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/stage2_pgtable.h b/arch/arm/include/asm/stage2_pgtable.h
>> index de2089501b8b..fed02c3b4600 100644
>> --- a/arch/arm/include/asm/stage2_pgtable.h
>> +++ b/arch/arm/include/asm/stage2_pgtable.h
>> @@ -32,14 +32,14 @@
>>  #define stage2_pgd_present(kvm, pgd)		pgd_present(pgd)
>>  #define stage2_pgd_populate(kvm, pgd, pud)	pgd_populate(NULL, pgd, pud)
>>  #define stage2_pud_offset(kvm, pgd, address)	pud_offset(pgd, address)
>> -#define stage2_pud_free(kvm, pud)		pud_free(NULL, pud)
>> +#define stage2_pud_free(kvm, pud)		do { } while (0)
>>  
>>  #define stage2_pud_none(kvm, pud)		pud_none(pud)
>>  #define stage2_pud_clear(kvm, pud)		pud_clear(pud)
>>  #define stage2_pud_present(kvm, pud)		pud_present(pud)
>>  #define stage2_pud_populate(kvm, pud, pmd)	pud_populate(NULL, pud, pmd)
>>  #define stage2_pmd_offset(kvm, pud, address)	pmd_offset(pud, address)
>> -#define stage2_pmd_free(kvm, pmd)		pmd_free(NULL, pmd)
>> +#define stage2_pmd_free(kvm, pmd)		free_page((unsigned long)pmd)
>>  
>>  #define stage2_pud_huge(kvm, pud)		pud_huge(pud)
>>  
>> diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
>> index 5412fa40825e..915809e4ac32 100644
>> --- a/arch/arm64/include/asm/stage2_pgtable.h
>> +++ b/arch/arm64/include/asm/stage2_pgtable.h
>> @@ -119,7 +119,7 @@ static inline pud_t *stage2_pud_offset(struct kvm *kvm,
>>  static inline void stage2_pud_free(struct kvm *kvm, pud_t *pud)
>>  {
>>  	if (kvm_stage2_has_pud(kvm))
>> -		pud_free(NULL, pud);
>> +		free_page((unsigned long)pud);
>>  }
>>  
>>  static inline bool stage2_pud_table_empty(struct kvm *kvm, pud_t *pudp)
>> @@ -192,7 +192,7 @@ static inline pmd_t *stage2_pmd_offset(struct kvm *kvm,
>>  static inline void stage2_pmd_free(struct kvm *kvm, pmd_t *pmd)
>>  {
>>  	if (kvm_stage2_has_pmd(kvm))
>> -		pmd_free(NULL, pmd);
>> +		free_page((unsigned long)pmd);
>>  }
>>  
>>  static inline bool stage2_pud_huge(struct kvm *kvm, pud_t pud)
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index e9d28a7ca673..cbfbdadca8a5 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -191,7 +191,7 @@ static void clear_stage2_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr
>>  	VM_BUG_ON(pmd_thp_or_huge(*pmd));
>>  	pmd_clear(pmd);
>>  	kvm_tlb_flush_vmid_ipa(kvm, addr);
>> -	pte_free_kernel(NULL, pte_table);
>> +	free_page((unsigned long)pte_table);
>>  	put_page(virt_to_page(pmd));
>>  }
>>  
>> -- 
>> 2.20.1
>>

Looks good to me, please take it via the arm64 tree with my

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
