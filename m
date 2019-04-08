Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA8EC282CE
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 09:09:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E5CC120870
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 09:09:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5CC120870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BC5A4A44E;
	Mon,  8 Apr 2019 05:09:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KfoZxjlvRdm6; Mon,  8 Apr 2019 05:09:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E493B4A47B;
	Mon,  8 Apr 2019 05:09:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3B4D4A44E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 05:09:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7zIumBIppm6X for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Apr 2019 05:09:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E73C74A331
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 05:09:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E9EB15AD;
 Mon,  8 Apr 2019 02:09:32 -0700 (PDT)
Received: from [10.1.196.92] (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 12C303F718; Mon,  8 Apr 2019 02:09:27 -0700 (PDT)
Subject: Re: [PATCH V2] KVM: ARM: Remove pgtable page standard functions from
 stage-2 page tables
To: Will Deacon <will.deacon@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>
References: <3be0b7e0-2ef8-babb-88c9-d229e0fdd220@arm.com>
 <1552397145-10665-1-git-send-email-anshuman.khandual@arm.com>
 <20190401161638.GB22092@fuggles.cambridge.arm.com>
From: Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
Organization: ARM Ltd
Message-ID: <77aaaaca-f9fb-cbad-74f6-e3bd159e7b37@arm.com>
Date: Mon, 8 Apr 2019 10:09:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190401161638.GB22092@fuggles.cambridge.arm.com>
Content-Language: en-US
Cc: yuzhao@google.com, catalin.marinas@arm.com, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190408090925.I6iWvUV9z3LTYLYpMBxWdTz7x4sDL0KiZHshLUg_EDg@z>

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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
