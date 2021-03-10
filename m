Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A06C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 14:52:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5D61B64F0B
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 14:52:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D61B64F0B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A80974B1E9;
	Wed, 10 Mar 2021 09:52:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p0ySgm3qh4lT; Wed, 10 Mar 2021 09:52:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18D7F4B425;
	Wed, 10 Mar 2021 09:52:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD70A4B413
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:52:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CPKz7gaBJAtF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 09:52:04 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A8844B34F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:52:04 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E28E731B;
 Wed, 10 Mar 2021 06:52:03 -0800 (PST)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 43E663F793;
 Wed, 10 Mar 2021 06:52:01 -0800 (PST)
Subject: Re: [PATCH v9 2/6] arm64: kvm: Introduce MTE VM feature
To: Marc Zyngier <maz@kernel.org>
References: <20210301142315.30920-1-steven.price@arm.com>
 <20210301142315.30920-3-steven.price@arm.com> <87im60xnn4.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <c8478448-7717-d9ac-de0f-e9574f0c7006@arm.com>
Date: Wed, 10 Mar 2021 14:52:49 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87im60xnn4.wl-maz@kernel.org>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 09/03/2021 17:06, Marc Zyngier wrote:
> On Mon, 01 Mar 2021 14:23:11 +0000,
> Steven Price <steven.price@arm.com> wrote:
>>
>> Add a new VM feature 'KVM_ARM_CAP_MTE' which enables memory tagging
>> for a VM. This will expose the feature to the guest and automatically
>> tag memory pages touched by the VM as PG_mte_tagged (and clear the tag
>> storage) to ensure that the guest cannot see stale tags, and so that
>> the tags are correctly saved/restored across swap.
>>
>> Actually exposing the new capability to user space happens in a later
>> patch.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_emulate.h |  3 +++
>>   arch/arm64/include/asm/kvm_host.h    |  3 +++
>>   arch/arm64/kvm/hyp/exception.c       |  3 ++-
>>   arch/arm64/kvm/mmu.c                 | 16 ++++++++++++++++
>>   arch/arm64/kvm/sys_regs.c            |  3 ++-
>>   include/uapi/linux/kvm.h             |  1 +
>>   6 files changed, 27 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index f612c090f2e4..6bf776c2399c 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -84,6 +84,9 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>>   	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
>>   	    vcpu_el1_is_32bit(vcpu))
>>   		vcpu->arch.hcr_el2 |= HCR_TID2;
>> +
>> +	if (kvm_has_mte(vcpu->kvm))
>> +		vcpu->arch.hcr_el2 |= HCR_ATA;
>>   }
>>   
>>   static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 3d10e6527f7d..1170ee137096 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -132,6 +132,8 @@ struct kvm_arch {
>>   
>>   	u8 pfr0_csv2;
>>   	u8 pfr0_csv3;
>> +	/* Memory Tagging Extension enabled for the guest */
>> +	bool mte_enabled;
>>   };
>>   
>>   struct kvm_vcpu_fault_info {
>> @@ -767,6 +769,7 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>>   #define kvm_arm_vcpu_sve_finalized(vcpu) \
>>   	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
>>   
>> +#define kvm_has_mte(kvm) (system_supports_mte() && (kvm)->arch.mte_enabled)
>>   #define kvm_vcpu_has_pmu(vcpu)					\
>>   	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
>>   
>> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
>> index 73629094f903..56426565600c 100644
>> --- a/arch/arm64/kvm/hyp/exception.c
>> +++ b/arch/arm64/kvm/hyp/exception.c
>> @@ -112,7 +112,8 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
>>   	new |= (old & PSR_C_BIT);
>>   	new |= (old & PSR_V_BIT);
>>   
>> -	// TODO: TCO (if/when ARMv8.5-MemTag is exposed to guests)
>> +	if (kvm_has_mte(vcpu->kvm))
>> +		new |= PSR_TCO_BIT;
>>   
>>   	new |= (old & PSR_DIT_BIT);
>>   
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 77cb2d28f2a4..fdb6ab604fd0 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -879,6 +879,22 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   	if (vma_pagesize == PAGE_SIZE && !force_pte)
>>   		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
>>   							   &pfn, &fault_ipa);
>> +
>> +	if (kvm_has_mte(kvm) && pfn_valid(pfn)) {
>> +		/*
>> +		 * VM will be able to see the page's tags, so we must ensure
>> +		 * they have been initialised. if PG_mte_tagged is set, tags
>> +		 * have already been initialised.
>> +		 */
>> +		struct page *page = pfn_to_page(pfn);
>> +		unsigned long i, nr_pages = vma_pagesize >> PAGE_SHIFT;
>> +
>> +		for (i = 0; i < nr_pages; i++, page++) {
>> +			if (!test_and_set_bit(PG_mte_tagged, &page->flags))
>> +				mte_clear_page_tags(page_address(page));
>> +		}
>> +	}
> 
> Is there any reason to do this dance for anything but a translation
> fault?

Good point I guess this should have a (fault_status != FSC_PERM) in the 
test to match the other paths.

>> +
>>   	if (writable)
>>   		prot |= KVM_PGTABLE_PROT_W;
>>   
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 4f2f1e3145de..e09dbc00b0a2 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1046,7 +1046,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>>   		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
>>   		break;
>>   	case SYS_ID_AA64PFR1_EL1:
>> -		val &= ~FEATURE(ID_AA64PFR1_MTE);
>> +		if (!kvm_has_mte(vcpu->kvm))
>> +			val &= ~FEATURE(ID_AA64PFR1_MTE);
> 
> Are we happy to expose *any* of the MTE flavours? Or should we
> restrict it in any way?

Another good point - it would make sense to restrict this in case 
another MTE flavour is invented.

Thanks,

Steve

>>   		break;
>>   	case SYS_ID_AA64ISAR1_EL1:
>>   		if (!vcpu_has_ptrauth(vcpu))
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 8b281f722e5b..05618a4abf7e 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1078,6 +1078,7 @@ struct kvm_ppc_resize_hpt {
>>   #define KVM_CAP_DIRTY_LOG_RING 192
>>   #define KVM_CAP_X86_BUS_LOCK_EXIT 193
>>   #define KVM_CAP_PPC_DAWR1 194
>> +#define KVM_CAP_ARM_MTE 195
>>   
>>   #ifdef KVM_CAP_IRQ_ROUTING
>>   
>> -- 
>> 2.20.1
>>
>>
> 
> Thanks,
> 
> 	M.
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
