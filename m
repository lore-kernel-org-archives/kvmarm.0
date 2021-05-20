Return-Path: <SRS0=DM5G=KP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B40D7C433B4
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 14:46:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 32DA861184
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 14:46:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32DA861184
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8FA14B3D8;
	Thu, 20 May 2021 10:46:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I7jSZ45U8AKc; Thu, 20 May 2021 10:46:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A55A4B440;
	Thu, 20 May 2021 10:46:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02C654B3D8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 10:46:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JR2QnjOKlHwF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 May 2021 10:46:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BB854B3A3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 10:46:52 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1198DED1;
 Thu, 20 May 2021 07:46:52 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 11D393F73B;
 Thu, 20 May 2021 07:46:47 -0700 (PDT)
Subject: Re: [PATCH v12 4/8] arm64: kvm: Introduce MTE VM feature
To: Marc Zyngier <maz@kernel.org>
References: <20210517123239.8025-1-steven.price@arm.com>
 <20210517123239.8025-5-steven.price@arm.com> <87wnrxtikl.wl-maz@kernel.org>
 <60fc8939-36b7-35ce-837c-b69d0d40c9a4@arm.com> <875yzdvldb.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <e44c7782-bf7a-80f5-a8ae-75bbb44649ae@arm.com>
Date: Thu, 20 May 2021 15:46:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <875yzdvldb.wl-maz@kernel.org>
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

On 20/05/2021 09:51, Marc Zyngier wrote:
> On Wed, 19 May 2021 11:48:21 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> On 17/05/2021 17:45, Marc Zyngier wrote:
>>> On Mon, 17 May 2021 13:32:35 +0100,
>>> Steven Price <steven.price@arm.com> wrote:
[...]
>>>> +		}
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>>  			  struct kvm_memory_slot *memslot, unsigned long hva,
>>>>  			  unsigned long fault_status)
>>>> @@ -971,8 +996,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>>  	if (writable)
>>>>  		prot |= KVM_PGTABLE_PROT_W;
>>>>  
>>>> -	if (fault_status != FSC_PERM && !device)
>>>> +	if (fault_status != FSC_PERM && !device) {
>>>> +		ret = sanitise_mte_tags(kvm, vma_pagesize, pfn);
>>>> +		if (ret)
>>>> +			goto out_unlock;
>>>> +
>>>>  		clean_dcache_guest_page(pfn, vma_pagesize);
>>>> +	}
>>>>  
>>>>  	if (exec_fault) {
>>>>  		prot |= KVM_PGTABLE_PROT_X;
>>>> @@ -1168,12 +1198,17 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>>>>  bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>>>>  {
>>>>  	kvm_pfn_t pfn = pte_pfn(range->pte);
>>>> +	int ret;
>>>>  
>>>>  	if (!kvm->arch.mmu.pgt)
>>>>  		return 0;
>>>>  
>>>>  	WARN_ON(range->end - range->start != 1);
>>>>  
>>>> +	ret = sanitise_mte_tags(kvm, PAGE_SIZE, pfn);
>>>> +	if (ret)
>>>> +		return ret;
>>>
>>> Notice the change in return type?
>>
>> I do now - I was tricked by the use of '0' as false. Looks like false
>> ('0') is actually the correct return here to avoid an unnecessary
>> kvm_flush_remote_tlbs().
> 
> Yup. BTW, the return values have been fixed to proper boolean types in
> the latest set of fixes.

Thanks for the heads up - I'll return 'false' to avoid regressing that.

>>
>>>> +
>>>>  	/*
>>>>  	 * We've moved a page around, probably through CoW, so let's treat it
>>>>  	 * just like a translation fault and clean the cache to the PoC.
>>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>>> index 76ea2800c33e..24a844cb79ca 100644
>>>> --- a/arch/arm64/kvm/sys_regs.c
>>>> +++ b/arch/arm64/kvm/sys_regs.c
>>>> @@ -1047,6 +1047,9 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>>>>  		break;
>>>>  	case SYS_ID_AA64PFR1_EL1:
>>>>  		val &= ~FEATURE(ID_AA64PFR1_MTE);
>>>> +		if (kvm_has_mte(vcpu->kvm))
>>>> +			val |= FIELD_PREP(FEATURE(ID_AA64PFR1_MTE),
>>>> +					  ID_AA64PFR1_MTE);
>>>
>>> Shouldn't this be consistent with what the HW is capable of
>>> (i.e. FEAT_MTE3 if available), and extracted from the sanitised view
>>> of the feature set?
>>
>> Yes - however at the moment our sanitised view is either FEAT_MTE2 or
>> nothing:
>>
>> 	{
>> 		.desc = "Memory Tagging Extension",
>> 		.capability = ARM64_MTE,
>> 		.type = ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE,
>> 		.matches = has_cpuid_feature,
>> 		.sys_reg = SYS_ID_AA64PFR1_EL1,
>> 		.field_pos = ID_AA64PFR1_MTE_SHIFT,
>> 		.min_field_value = ID_AA64PFR1_MTE,
>> 		.sign = FTR_UNSIGNED,
>> 		.cpu_enable = cpu_enable_mte,
>> 	},
>>
>> When host support for FEAT_MTE3 is added then the KVM code will need
>> revisiting to expose that down to the guest safely (AFAICS there's
>> nothing extra to do here, but I haven't tested any of the MTE3
>> features). I don't think we want to expose newer versions to the guest
>> than the host is aware of. (Or indeed expose FEAT_MTE if the host has
>> MTE disabled because Linux requires at least FEAT_MTE2).
> 
> What I was suggesting is to have something like this:
> 
>      pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
>      mte = cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR1_MTE_SHIFT);
>      val |= FIELD_PREP(FEATURE(ID_AA64PFR1_MTE), mte);
> 
> which does the trick nicely, and doesn't expose more than the host
> supports.

Ok, I have to admit to not fully understanding the sanitised register
code - but wouldn't this expose higher MTE values if all CPUs support
it, even though the host doesn't know what a hypothetical 'MTE4' adds?
Or is there some magic in the sanitising that caps the value to what the
host knows about?

Thanks,

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
