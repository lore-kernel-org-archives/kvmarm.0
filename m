Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C74F376BEB
	for <kvmarm@lists.linux.dev>; Fri, 16 Jan 2026 14:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768574028; cv=none; b=M8ybFyQPlDQvtOvS84GtqJCmHMxLuYGGj3r/zXyNhOj1oBtTgxkvnaPBXrmd/rzjQWBh3yeLpVxLJhlmC5KsGLU8MM31Fd+GVqYWMOFrjObuOJKHgb/xjUffY9J/SZzfxPUZwgj5ZOb8WqQ5E04S5g9BXmFNYxPYnAOg1RaktFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768574028; c=relaxed/simple;
	bh=4Ffpb8kN0xvYuBYpcHR+RsrxSwzFSesEd+WCEu2bHNc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VQ62HG4z+LtCe6fitnV6jh2yDysIFKWort5txnmVFbtTheh4RgvIvA14lVq6wNg8yI8EFoOUtWCNCklEvTFSUl7KEUGcoL52fx0KDVuMVQK4EWWPIVvcIzIb2fMc2BYkznsAiHSo62QZ0JHVRoLA5Bc2+I1P/Iis3nVTj94wtmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gYqJlgQ7; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gYqJlgQ7"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47ee974e230so19023875e9.2
        for <kvmarm@lists.linux.dev>; Fri, 16 Jan 2026 06:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768574025; x=1769178825; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vJZhOtWSnvNeJfPOYlm5h+k1E6qPCeJAW52vKXZm4D4=;
        b=gYqJlgQ719g0XcVux/o1raiJfhHlGoiIt8mYYhvib7/TV9BM+PWajLHdxxxXKx162H
         OMk7d1tuCepeKPH5s5PcdeDRda6HVZLIAAdS2BLFulYBucxCBn9cbPTnzFC2VQiwq9BI
         cRY1MjWRSUvEi67Hs25+24pOteGeKFURXjsCbK8PIXex8wwqcQKZUlNkh8LolYQuQvWX
         u6vyqPp7CXtoIo34p1KojWCqkZCnOoPs2/t7yaqVKkVyu5SzUxymSaY3AGxpNSHadGWX
         KXev3qriQ9yXF+dRxLmSU/V+/w5206MSqqSdSuqeTWlc0J/QIKqb9C+oAXG2NQXinTtr
         wy8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768574025; x=1769178825;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vJZhOtWSnvNeJfPOYlm5h+k1E6qPCeJAW52vKXZm4D4=;
        b=rNgRpSu2q+3WhAz0ifI0s/vCUlGhbtNzrAoqQbbldRifHZKAw0dyGVwqjxrc/G92Vp
         DQtUWpNE6cWAvosrNNX1I2RU/uk/+bjLyEqeeYicsFNhjWGoWnrfZOwCSENSpQK1P1mj
         G7Skcg9Z1Sa9w3bzMvmI6viJNc69zxgENJ3slRdnarLaEmcZ5M18nq0K6VBPH7eNhMSO
         Ri2JzLbSng6g41mdO2CAQLUm0PhO9H/WLjXvfsL3dN5L/iMrfrpuXLM/AuxiyppErCu2
         zci95AORRbFvEKn6KzJWEH9yv4ZhIpZtOX4Crn3RsqLXGpD0z72h2WcHGJKq2bsUFpuV
         ++2A==
X-Forwarded-Encrypted: i=1; AJvYcCUmmfZJlAoiCsE8Rkr7UgXUoQ2Nsi/U+YAHzBCqWQaSVYjdEW+Xyfker63kflWvv5zsxh73tZg=@lists.linux.dev
X-Gm-Message-State: AOJu0YximI834BtZ3gpIsMdjgwkUweda0cbbyN6VYluZbEmxgXlnGBsg
	HVy/d+o1QFfaeGw9zm+6GY38ar/CqXfo2eI644Rbb9qzpaqLk1KHm3oM
X-Gm-Gg: AY/fxX5XdSmG04ADrWJM4ncTYWESTonHVnSn8GJZH1VqT+SpfdPvBpi3QMVOrS//52y
	QPTtD5ZnzuGjRfmq7Mu9V5AOICUS+58Ta+8W/JU154/Dt889Hw1kkgFsHIgdd8p5gP+N+sTDwMk
	B603ur8ErBuhMWs8rptVXuuzyFYFqeiAjDOGJTJAgnFMDga88X/TLak8LzKaXcNsEv/tTBrVir6
	1qqlDgatWdDZEbp80o9yXw4Dfg160j6Bgv9REgIoyHpBuPoxX2SuonhtRwWKvcluv3chuUWNL/y
	zAniO/w6fp5YJGWyVgMzwGxfIYO8Znjyeqvl95zhjVJjVqWB8HVQOkqQzUpRmYp7FRe0xRvN6NB
	4OxygxOKHNeBfjR3EhNmBaCQFf9x19hf6XmOLlxdt7AfqjiC36rDmvUXWrA1+A2WSyKG4prWRiz
	akVGf3Q3c7kxP+d/T/SC4hk+KxrK5i2/ck
X-Received: by 2002:a05:600c:4e50:b0:47e:e946:3a59 with SMTP id 5b1f17b1804b1-4801e3503fbmr36347905e9.34.1768574024397;
        Fri, 16 Jan 2026 06:33:44 -0800 (PST)
Received: from [10.24.66.74] ([15.248.2.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4801fe6307asm17912065e9.7.2026.01.16.06.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 06:33:44 -0800 (PST)
Message-ID: <ea7786e4-8b67-4a9f-b2c6-c0e4cd325cc3@gmail.com>
Date: Fri, 16 Jan 2026 14:33:42 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] KVM: arm64: Add pre_fault_memory implementation
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, joey.gouly@arm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, shuah@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, isaku.yamahata@intel.com,
 xmarcalx@amazon.co.uk, kalyazin@amazon.co.uk, jackabt@amazon.com,
 Vladimir Murzin <vladimir.murzin@arm.com>
References: <20260113152643.18858-1-jackabt.amazon@gmail.com>
 <20260113152643.18858-2-jackabt.amazon@gmail.com>
 <86jyxjkxus.wl-maz@kernel.org>
Content-Language: en-US
From: "Thomson, Jack" <jackabt.amazon@gmail.com>
In-Reply-To: <86jyxjkxus.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


Hey Marc,

Thanks for the review.

On 15/01/2026 9:51 am, Marc Zyngier wrote:
> [+ Vladimir, who was also looking at this patch]
> 
> On Tue, 13 Jan 2026 15:26:40 +0000,
> Jack Thomson <jackabt.amazon@gmail.com> wrote:
>>
>> From: Jack Thomson <jackabt@amazon.com>
>>
>> Add kvm_arch_vcpu_pre_fault_memory() for arm64. The implementation hands
>> off the stage-2 faulting logic to either gmem_abort() or
>> user_mem_abort().
>>
>> Add an optional page_size output parameter to user_mem_abort() to
>> return the VMA page size, which is needed when pre-faulting.
>>
>> Update the documentation to clarify x86 specific behaviour.
>>
>> Signed-off-by: Jack Thomson <jackabt@amazon.com>
>> ---
>>   Documentation/virt/kvm/api.rst |  3 +-
>>   arch/arm64/kvm/Kconfig         |  1 +
>>   arch/arm64/kvm/arm.c           |  1 +
>>   arch/arm64/kvm/mmu.c           | 79 ++++++++++++++++++++++++++++++++--
>>   4 files changed, 79 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 01a3abef8abb..44cfd9e736bb 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -6493,7 +6493,8 @@ Errors:
>>   KVM_PRE_FAULT_MEMORY populates KVM's stage-2 page tables used to map memory
>>   for the current vCPU state.  KVM maps memory as if the vCPU generated a
>>   stage-2 read page fault, e.g. faults in memory as needed, but doesn't break
>> -CoW.  However, KVM does not mark any newly created stage-2 PTE as Accessed.
>> +CoW.  However, on x86, KVM does not mark any newly created stage-2 PTE as
>> +Accessed.
>>   
>>   In the case of confidential VM types where there is an initial set up of
>>   private guest memory before the guest is 'finalized'/measured, this ioctl
>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>> index 4f803fd1c99a..6872aaabe16c 100644
>> --- a/arch/arm64/kvm/Kconfig
>> +++ b/arch/arm64/kvm/Kconfig
>> @@ -25,6 +25,7 @@ menuconfig KVM
>>   	select HAVE_KVM_CPU_RELAX_INTERCEPT
>>   	select KVM_MMIO
>>   	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>> +	select KVM_GENERIC_PRE_FAULT_MEMORY
>>   	select VIRT_XFER_TO_GUEST_WORK
>>   	select KVM_VFIO
>>   	select HAVE_KVM_DIRTY_RING_ACQ_REL
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 4f80da0c0d1d..19bac68f737f 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -332,6 +332,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>   	case KVM_CAP_COUNTER_OFFSET:
>>   	case KVM_CAP_ARM_WRITABLE_IMP_ID_REGS:
>>   	case KVM_CAP_ARM_SEA_TO_USER:
>> +	case KVM_CAP_PRE_FAULT_MEMORY:
>>   		r = 1;
>>   		break;
>>   	case KVM_CAP_SET_GUEST_DEBUG2:
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 48d7c372a4cd..499b131f794e 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1642,8 +1642,8 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   
>>   static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   			  struct kvm_s2_trans *nested,
>> -			  struct kvm_memory_slot *memslot, unsigned long hva,
>> -			  bool fault_is_perm)
>> +			  struct kvm_memory_slot *memslot, unsigned long *page_size,
>> +			  unsigned long hva, bool fault_is_perm)
>>   {
>>   	int ret = 0;
>>   	bool topup_memcache;
>> @@ -1923,6 +1923,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   	kvm_release_faultin_page(kvm, page, !!ret, writable);
>>   	kvm_fault_unlock(kvm);
>>   
>> +	if (page_size)
>> +		*page_size = vma_pagesize;
>> +
>>   	/* Mark the page dirty only if the fault is handled successfully */
>>   	if (writable && !ret)
>>   		mark_page_dirty_in_slot(kvm, memslot, gfn);
>> @@ -2196,8 +2199,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>   		ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
>>   				 esr_fsc_is_permission_fault(esr));
>>   	else
>> -		ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
>> -				     esr_fsc_is_permission_fault(esr));
>> +		ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, NULL,
>> +				     hva, esr_fsc_is_permission_fault(esr));
>>   	if (ret == 0)
>>   		ret = 1;
>>   out:
>> @@ -2573,3 +2576,71 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
>>   
>>   	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
>>   }
>> +
>> +long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>> +				    struct kvm_pre_fault_memory *range)
>> +{
>> +	struct kvm_vcpu_fault_info *fault_info = &vcpu->arch.fault;
>> +	struct kvm_s2_trans nested_trans, *nested = NULL;
>> +	unsigned long page_size = PAGE_SIZE;
>> +	struct kvm_memory_slot *memslot;
>> +	phys_addr_t ipa = range->gpa;
>> +	phys_addr_t end;
>> +	hva_t hva;
>> +	gfn_t gfn;
>> +	int ret;
>> +
>> +	if (vcpu_is_protected(vcpu))
>> +		return -EOPNOTSUPP;
> 
> This feels pretty odd. If you have advertised the capability, then
> saying "not supported" at this stage is not on.
> 

Thanks good point, I think I can actually just drop this completely since
kvm_pvm_ext_allowed() would already exclude this as a capacility.

>> +
>> +	/*
>> +	 * We may prefault on a shadow stage 2 page table if we are
>> +	 * running a nested guest.  In this case, we have to resolve the L2
>> +	 * IPA to the L1 IPA first, before knowing what kind of memory should
>> +	 * back the L1 IPA.
>> +	 *
>> +	 * If the shadow stage 2 page table walk faults, then we return
>> +	 * -EFAULT
>> +	 */
>> +	if (kvm_is_nested_s2_mmu(vcpu->kvm, vcpu->arch.hw_mmu) &&
>> +	    vcpu->arch.hw_mmu->nested_stage2_enabled) {
>> +		ret = kvm_walk_nested_s2(vcpu, ipa, &nested_trans);
>> +		if (ret)
>> +			return -EFAULT;
> 
> And then what? Userspace is completely screwed here, with no way to
> make any forward progress, because the L1 is in charge of that S2, and
> L1 is not running. What's the outcome? Light a candle and pray?
> 
> Also, the IPA you are passing as a parameter means absolutely nothing
> in the context of L2. Userspace doesn't have the faintest clue about
> the memory map presented to L2, as that's L1 business. L1 can
> absolutely present to L2 a memory map that doesn't have a single
> address in common with its own.
> 
> So this really doesn't work at all.
> 
Would just returning -EOPNOTSUPP in this case like:

   if (kvm_is_nested_s2_mmu(vcpu->kvm, vcpu->arch.hw_mmu) &&
       vcpu->arch.hw_mmu->nested_stage2_enabled)
     return -EOPNOTSUPP;

be the best way to continue for now?
>> +
>> +		ipa = kvm_s2_trans_output(&nested_trans);
>> +		nested = &nested_trans;
>> +	}
>> +
>> +	if (ipa >= kvm_phys_size(vcpu->arch.hw_mmu))
>> +		return -ENOENT;
>> +
>> +	/* Generate a synthetic abort for the pre-fault address */
>> +	fault_info->esr_el2 = (ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT) |
>> +		ESR_ELx_FSC_FAULT_L(KVM_PGTABLE_LAST_LEVEL);
> 
> Why level 3? You must present a fault that matches the level at which
> the emulated fault would actually occur, because the rest of the
> infrastructure relies on that (at least on the permission path, and
> more to come).
> 

Ack, thanks I was relying on the fact `fault_is_perm` was hardcoded to
false. I'll replace with something like:

   pgt = vcpu->arch.hw_mmu->pgt;
   ret = kvm_pgtable_get_leaf(pgt, gpa, &pte, &level);
   if (ret)
     return ret;

   fault_info->esr_el2 = (ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT) |
     ESR_ELx_FSC_FAULT_L(level);
   fault_info->hpfar_el2 = HPFAR_EL2_NS |
     FIELD_PREP(HPFAR_EL2_FIPA, gpa >> 12);

> Taking a step back on all this, 90% of the problems are there because
> you are trying to support prefaulting a guest that is already running.
> If you limited this to actually *pre*-faulting the guest, it would be
> the easiest thing ever, and wouldn't suffer from any of the above (you
> can't be in a nested context if you haven't run).
> 
> What prevents you from doing so? I'm perfectly happy to make this a
> separate API if this contradicts other implementations. Or are you
> relying on other side effects of the "already running" state?

We would need this to work on an already running guest.

> 
> Thanks,
> 
> 	M.

Thanks again for taking a look!

-- 
Thanks,
Jack
