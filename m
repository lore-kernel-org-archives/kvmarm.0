Return-Path: <SRS0=M1+/=KO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D44BC433ED
	for <kvmarm@archiver.kernel.org>; Wed, 19 May 2021 10:48:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9DD1B61355
	for <kvmarm@archiver.kernel.org>; Wed, 19 May 2021 10:48:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DD1B61355
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AB594B768;
	Wed, 19 May 2021 06:48:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ezTt-MAZnkoD; Wed, 19 May 2021 06:48:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45ED54B850;
	Wed, 19 May 2021 06:48:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E560A4B84E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 May 2021 06:48:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7WBXZ6ZocQ-F for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 May 2021 06:48:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B970F4B768
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 May 2021 06:48:29 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9114101E;
 Wed, 19 May 2021 03:48:28 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 729253F719;
 Wed, 19 May 2021 03:48:26 -0700 (PDT)
Subject: Re: [PATCH v12 4/8] arm64: kvm: Introduce MTE VM feature
To: Marc Zyngier <maz@kernel.org>
References: <20210517123239.8025-1-steven.price@arm.com>
 <20210517123239.8025-5-steven.price@arm.com> <87wnrxtikl.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <60fc8939-36b7-35ce-837c-b69d0d40c9a4@arm.com>
Date: Wed, 19 May 2021 11:48:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87wnrxtikl.wl-maz@kernel.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 17/05/2021 17:45, Marc Zyngier wrote:
> On Mon, 17 May 2021 13:32:35 +0100,
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
> 
> uber nit in $SUBJECT: "KVM: arm64:" is the preferred prefix (just like
> patches 7 and 8).

Good spot - I obviously got carried away with the "arm64:" prefix ;)

>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_emulate.h |  3 +++
>>  arch/arm64/include/asm/kvm_host.h    |  3 +++
>>  arch/arm64/kvm/hyp/exception.c       |  3 ++-
>>  arch/arm64/kvm/mmu.c                 | 37 +++++++++++++++++++++++++++-
>>  arch/arm64/kvm/sys_regs.c            |  3 +++
>>  include/uapi/linux/kvm.h             |  1 +
>>  6 files changed, 48 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index f612c090f2e4..6bf776c2399c 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -84,6 +84,9 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>>  	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
>>  	    vcpu_el1_is_32bit(vcpu))
>>  		vcpu->arch.hcr_el2 |= HCR_TID2;
>> +
>> +	if (kvm_has_mte(vcpu->kvm))
>> +		vcpu->arch.hcr_el2 |= HCR_ATA;
>>  }
>>  
>>  static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 7cd7d5c8c4bc..afaa5333f0e4 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -132,6 +132,8 @@ struct kvm_arch {
>>  
>>  	u8 pfr0_csv2;
>>  	u8 pfr0_csv3;
>> +	/* Memory Tagging Extension enabled for the guest */
>> +	bool mte_enabled;
>>  };
>>  
>>  struct kvm_vcpu_fault_info {
>> @@ -769,6 +771,7 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>>  #define kvm_arm_vcpu_sve_finalized(vcpu) \
>>  	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
>>  
>> +#define kvm_has_mte(kvm) (system_supports_mte() && (kvm)->arch.mte_enabled)
>>  #define kvm_vcpu_has_pmu(vcpu)					\
>>  	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
>>  
>> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
>> index 73629094f903..56426565600c 100644
>> --- a/arch/arm64/kvm/hyp/exception.c
>> +++ b/arch/arm64/kvm/hyp/exception.c
>> @@ -112,7 +112,8 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
>>  	new |= (old & PSR_C_BIT);
>>  	new |= (old & PSR_V_BIT);
>>  
>> -	// TODO: TCO (if/when ARMv8.5-MemTag is exposed to guests)
>> +	if (kvm_has_mte(vcpu->kvm))
>> +		new |= PSR_TCO_BIT;
>>  
>>  	new |= (old & PSR_DIT_BIT);
>>  
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index c5d1f3c87dbd..8660f6a03f51 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -822,6 +822,31 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
>>  	return PAGE_SIZE;
>>  }
>>  
>> +static int sanitise_mte_tags(struct kvm *kvm, unsigned long size,
>> +			     kvm_pfn_t pfn)
> 
> Nit: please order the parameters as address, then size.

Sure

>> +{
>> +	if (kvm_has_mte(kvm)) {
>> +		/*
>> +		 * The page will be mapped in stage 2 as Normal Cacheable, so
>> +		 * the VM will be able to see the page's tags and therefore
>> +		 * they must be initialised first. If PG_mte_tagged is set,
>> +		 * tags have already been initialised.
>> +		 */
>> +		unsigned long i, nr_pages = size >> PAGE_SHIFT;
>> +		struct page *page = pfn_to_online_page(pfn);
>> +
>> +		if (!page)
>> +			return -EFAULT;
> 
> Under which circumstances can this happen? We already have done a GUP
> on the page, so I really can't see how the page can vanish from under
> our feet.

It's less about the page vanishing and more that pfn_to_online_page()
will reject some pages. Specifically in this case we want to reject any
sort of device memory (e.g. graphics card memory or other memory on the
end of a bus like PCIe) as it is unlikely to support MTE.

>> +
>> +		for (i = 0; i < nr_pages; i++, page++) {
>> +			if (!test_and_set_bit(PG_mte_tagged, &page->flags))
>> +				mte_clear_page_tags(page_address(page));
> 
> You seem to be doing this irrespective of the VMA being created with
> PROT_MTE. This is fine form a guest perspective (all its memory should
> be MTE capable). However, I can't see any guarantee that the VMM will
> actually allocate memslots with PROT_MTE.
> 
> Aren't we missing some sanity checks at memslot registration time?

I've taken the decision not to require that the VMM allocates with
PROT_MTE, there are two main reasons for this:

 1. The VMM generally doesn't actually want a PROT_MTE mapping as the
tags from the guest are almost certainly wrong for most usages (e.g.
device emulation). So a PROT_MTE mapping actively gets in the way of the
VMM using MTE for it's own purposes. However this then leads to the
requirement for the new ioctl in patch 7.

 2. Because the VMM can change the pages in a memslot at any time and
KVM relies on mmu notifiers to spot the change it's hard and ugly to
enforce that the memslot VMAs keep having the PROT_MTE flag. When I
tried this it meant we've discover that a page doesn't have the MTE flag
at fault time and have no other option that to kill the VM at that time.

So the model is that non-PROT_MTE memory can be supplied to the memslots
and KVM will automatically upgrade it to PG_mte_tagged if you supply it
to a VM with MTE enabled. This makes the VMM implementation easier for
most cases, and the new ioctl helps for migration. I think the kernel
code is tidier too.

Of course even better would be a stage 2 flag to control MTE
availability on a page-by-page basis, but that doesn't exist in the
architecture at the moment.

>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  			  struct kvm_memory_slot *memslot, unsigned long hva,
>>  			  unsigned long fault_status)
>> @@ -971,8 +996,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	if (writable)
>>  		prot |= KVM_PGTABLE_PROT_W;
>>  
>> -	if (fault_status != FSC_PERM && !device)
>> +	if (fault_status != FSC_PERM && !device) {
>> +		ret = sanitise_mte_tags(kvm, vma_pagesize, pfn);
>> +		if (ret)
>> +			goto out_unlock;
>> +
>>  		clean_dcache_guest_page(pfn, vma_pagesize);
>> +	}
>>  
>>  	if (exec_fault) {
>>  		prot |= KVM_PGTABLE_PROT_X;
>> @@ -1168,12 +1198,17 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>>  bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>>  {
>>  	kvm_pfn_t pfn = pte_pfn(range->pte);
>> +	int ret;
>>  
>>  	if (!kvm->arch.mmu.pgt)
>>  		return 0;
>>  
>>  	WARN_ON(range->end - range->start != 1);
>>  
>> +	ret = sanitise_mte_tags(kvm, PAGE_SIZE, pfn);
>> +	if (ret)
>> +		return ret;
> 
> Notice the change in return type?

I do now - I was tricked by the use of '0' as false. Looks like false
('0') is actually the correct return here to avoid an unnecessary
kvm_flush_remote_tlbs().

>> +
>>  	/*
>>  	 * We've moved a page around, probably through CoW, so let's treat it
>>  	 * just like a translation fault and clean the cache to the PoC.
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 76ea2800c33e..24a844cb79ca 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1047,6 +1047,9 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>>  		break;
>>  	case SYS_ID_AA64PFR1_EL1:
>>  		val &= ~FEATURE(ID_AA64PFR1_MTE);
>> +		if (kvm_has_mte(vcpu->kvm))
>> +			val |= FIELD_PREP(FEATURE(ID_AA64PFR1_MTE),
>> +					  ID_AA64PFR1_MTE);
> 
> Shouldn't this be consistent with what the HW is capable of
> (i.e. FEAT_MTE3 if available), and extracted from the sanitised view
> of the feature set?

Yes - however at the moment our sanitised view is either FEAT_MTE2 or
nothing:

	{
		.desc = "Memory Tagging Extension",
		.capability = ARM64_MTE,
		.type = ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE,
		.matches = has_cpuid_feature,
		.sys_reg = SYS_ID_AA64PFR1_EL1,
		.field_pos = ID_AA64PFR1_MTE_SHIFT,
		.min_field_value = ID_AA64PFR1_MTE,
		.sign = FTR_UNSIGNED,
		.cpu_enable = cpu_enable_mte,
	},

When host support for FEAT_MTE3 is added then the KVM code will need
revisiting to expose that down to the guest safely (AFAICS there's
nothing extra to do here, but I haven't tested any of the MTE3
features). I don't think we want to expose newer versions to the guest
than the host is aware of. (Or indeed expose FEAT_MTE if the host has
MTE disabled because Linux requires at least FEAT_MTE2).

Thanks,

Steve

>>  		break;
>>  	case SYS_ID_AA64ISAR1_EL1:
>>  		if (!vcpu_has_ptrauth(vcpu))
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 3fd9a7e9d90c..8c95ba0fadda 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1082,6 +1082,7 @@ struct kvm_ppc_resize_hpt {
>>  #define KVM_CAP_SGX_ATTRIBUTE 196
>>  #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
>>  #define KVM_CAP_PTP_KVM 198
>> +#define KVM_CAP_ARM_MTE 199
>>  
>>  #ifdef KVM_CAP_IRQ_ROUTING
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
