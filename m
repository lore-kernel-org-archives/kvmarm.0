Return-Path: <SRS0=T+on=IV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50FCBC433C1
	for <kvmarm@archiver.kernel.org>; Tue, 23 Mar 2021 14:28:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 805E0619B2
	for <kvmarm@archiver.kernel.org>; Tue, 23 Mar 2021 14:28:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 805E0619B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE3524B23E;
	Tue, 23 Mar 2021 10:28:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id It2Ecy-tYGpV; Tue, 23 Mar 2021 10:28:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 780D44B2EE;
	Tue, 23 Mar 2021 10:28:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D8284B294
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Mar 2021 10:28:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LAugibTQqlhL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Mar 2021 10:28:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 566564B23E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Mar 2021 10:28:37 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C09DDD6E;
 Tue, 23 Mar 2021 07:28:36 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A49F53F719;
 Tue, 23 Mar 2021 07:28:35 -0700 (PDT)
Subject: Re: [RFC PATCH v3 10/16] KVM: arm64: Add a new VM device control
 group for SPE
To: James Morse <james.morse@arm.com>
References: <20201027172705.15181-1-alexandru.elisei@arm.com>
 <20201027172705.15181-11-alexandru.elisei@arm.com>
 <6e972fc8-438c-847b-f5a4-7903093a7057@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <364c21d8-e0f2-a939-1d5d-7dcf3cebb2eb@arm.com>
Date: Tue, 23 Mar 2021 14:27:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <6e972fc8-438c-847b-f5a4-7903093a7057@arm.com>
Content-Language: en-US
Cc: maz@kernel.org, linux-arm-kernel@lists.infradead.org, will@kernel.org,
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

Hi James,

Sorry for taking so long to reply to this, been busy with other things, but your
comments have been very helpful and they gave me a lot to think about. For the
next iteration of the series I've decided to use pin_user_pages with the
FOLL_LONGTERM flags, similar to how vfio_iommu_type1 does the memory pinning. I
believe that this approach matches the semantics of the flag, since SPE
practically functions like a device that can do DMA to guest memory at any time,
with the difference being that it uses the CPU translation tables instead of the
IOMMU tables. This will also remove the burden on userspace to call mlock()
beforehand, and the distinction between hugetlbfs and regular pages will be
removed from KVM, as those are handled internally by pin_user_pages.

I will try to answer those comments where I think a more elaborate explanation
will be helpful; regardless or my reply, all comments have been taken on board for
the next iteration.

On 11/19/20 4:59 PM, James Morse wrote:
> Hi Alex,
>
> On 27/10/2020 17:26, Alexandru Elisei wrote:
>> Stage 2 faults triggered by the profiling buffer attempting to write to
>> memory are reported by the SPE hardware by asserting a buffer management
>> event interrupt. Interrupts are by their nature asynchronous, which means
>> that the guest might have changed its stage 1 translation tables since the
>> attempted write. SPE reports the guest virtual address that caused the data
>> abort, but not the IPA, which means that KVM would have to walk the guest's
>> stage 1 tables to find the IPA; using the AT instruction to walk the
>> guest's tables in hardware is not an option because it doesn't report the
>> IPA in the case of a stage 2 fault on a stage 1 table walk.
> Great detailed description, I think a summary helps identify 'both' problems:
> | To work reliably, both the profiling buffer and the page tables to reach it must not
> | fault at stage2.
>
>> Fix both problems by pre-mapping the guest's memory at stage 2 with write
>> permissions to avoid any faults. Userspace calls mlock() on the VMAs that
>> back the guest's memory, pinning the pages in memory, then tells KVM to map
>> the memory at stage 2 by using the VM control group KVM_ARM_VM_SPE_CTRL
>> with the attribute KVM_ARM_VM_SPE_FINALIZE.
> The reason to have this feature is SPE, but is there anything SPE specific in the feature?
>
> I can imagine this being useful on its own if I wanted to reduce guest-exits for
> quasi-real-time reasons, and had memory to burn!
>
> (as an independent feature, it might be useful on other architectures too...)
>
>
> Would it make sense to add this as a flag to KVM_SET_USER_MEMORY_REGION? That is the point
> that the userspace_addr is provided to KVM, this would allow us to fail the call if a
> KVM_MEM_LOCKED memslot can't be created because the underlying VMA aren't VM_LOCKED.
>
> (it also makes it easy to catch incompatible changes of flags in the future)
>
> /me wanders off musing if this can then be combined with VM_PFNMAP in
> kvm_arch_prepare_memory_region()....
>
>
>> KVM will map all writable VMAs which have the VM_LOCKED flag set.
>> Hugetlb VMAs are practically pinned in
>> memory after they are faulted in and mlock() doesn't set the VM_LOCKED
>> flag, and just faults the pages in;
> Ugh. It would be nice to avoid special casing this. KVM shouldn't have to care about the
> difference between a hugetlbfs PMD and a THP PMD.
>
> From mlock_fixup(), it looks like this is because these VMA can't be split.
> Is it possible to change this if mlock() is called for the whole range? (user-space must
> know its hugetlbfs!)
>
> Alternatively, it would good if mm can tell us when a page is locked (and/or special
> cased). That way dax does the right thing too, without having extra special casing in KVM.
> This would also catch VM_PFNMAP if mm knows its effectively the same as VM_LOCKED...
>
>
>> KVM will treat hugetlb VMAs like they
>> have the VM_LOCKED flag and will also map them, faulting them in if
>> necessary, when handling the ioctl.
> Surely user-space should call mlock() to do the faulting in? (and do that before handing
> the memory over to KVM)
>
> Getting KVM to do it will create a loop via the mmu_notifier if this touches a COW page,
> which in turn bumps the sequence counter causing us to bomb out with -EAGAIN.
> (it looks like wp_page_copy() is the only case that calls set_pte_at_notify())
>
>
>> VM live migration relies on a bitmap of dirty pages. This bitmap is created
>> by write-protecting a memslot and updating it as KVM handles stage 2 write
>> faults. Because KVM cannot handle stage 2 faults reported by the profiling
>> buffer, it will not pre-map a logging memslot. This effectively means that
>> profiling is not available when the VM is configured for live migration.
> Yeah ... that sucks. Have any of the Qemu folk said what they'd like to see here?
>
> I can imagine making the logging-enable call fail if any CPU has SPE profiling enabled, as
> the logging will change the results of SPE... We'd then need an exit to user-space to say
> that the vcpu tried to enable SPE while logging was active. Qemu can then decide whether
> to block that vcpu until migration completes, or abort migration.
> But: I've no idea how Qemu manages migration, so it may not be able to do irregular things
> like this.
>
> As a short cut, can we let the arch code fail calls that make problematic changes. (e.g.
> setting KVM_MEM_LOG_DIRTY_PAGES or KVM_MEM_READONLY). It looks like you currently document
> these as silently breaking something else... (an invitation to debug a subtle interaction
> in the future!)

The solution I am considering implementing is to have userspace do an ioctl to
stop guest SPE before turning on dirty logging. This ioctl will have to specify
how KVM should behave when guest is profiling. I can see two useful behaviours:

- If guest profiling is enabled or becomes enabled, KVM_RUN will return to
userspace with a description of why it returned.

- If guest profiling is enabled or becomes enabled, KVM will trap the SPE
registers and it will disable profiling when the guest is running.

The two options can be changed while the profiling is stopped, and hopefully this
will be enough to let userspace implement whatever policy they want when migrating
a VM. Obviously, there will also be an ioctl to let KVM know that guest profiling
can be re-enabled.

Thanks,

Alex

>
> ~
>
> How does this interact with KSM?
> I can see its try_to_merge_one_page() calling write_protect_page() before testing the
> vm_flags for VM_LOCKED ... so it doesn't look like mlock() stop KSM from doing its work -
> which in turn will cause stage2 faults.
>
> It looks like this is all hinged on VM_MERGEABLE, which can be cleared with an madvise()
> call using MADV_UNMERGEABLE ... but from the man page at least this is to undo a previous
> hint.
>
> I can't find what sets this for regular vma, so presumably its not... see what you think,
> I reckon we need to add "no madvise() MADV_MERGEABLE" to the documentation, and get KVM to
> check the corresponding vma flag when it looks for VM_LOCKED regions.
>
> I think the 'testing flags' is justified, even though we can't enforce they don't change,
> as we can catch a stage2 fault that shouldn't have happened.
>
>
>> diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
>> index 0aa5b1cfd700..b70798a72d8a 100644
>> --- a/Documentation/virt/kvm/devices/vm.rst
>> +++ b/Documentation/virt/kvm/devices/vm.rst
>> @@ -314,3 +314,31 @@ Allows userspace to query the status of migration mode.
>>  	     if it is enabled
>>  :Returns:   -EFAULT if the given address is not accessible from kernel space;
>>  	    0 in case of success.
>> +
>> +6. GROUP: KVM_ARM_VM_SPE_CTRL
>> +===============================
>> +
>> +:Architectures: arm64
>> +
>> +6.1. ATTRIBUTE: KVM_ARM_VM_SPE_FINALIZE
>> +-----------------------------------------
>> +
>> +Finalizes the creation of the SPE feature by mapping the guest memory in the
>> +stage 2 table. Guest memory must be readable, writable and pinned in RAM, which
>> +is achieved with an mlock() system call;
> (I first read this as mlock() makes memory writeable...)
>
>
>> the memory can be backed by a hugetlbfs
>> +file. Memory regions from read-only or dirty page logging enabled memslots will
>> +be ignored. After the call, no changes to the guest memory,
>> including to its contents, are permitted.
> If guest memory is pinned as writeable, why can't the VMM write to it? Doesn't this
> requirement preclude virtio?
>
> Is 'no messing with the memslots' enforced in any way?
>
>
>> +Subsequent KVM_ARM_VCPU_INIT calls will cause the memory to become unmapped and
>> +the feature must be finalized again before any VCPU can run.
>> +
>> +If any VCPUs are run before finalizing the feature, KVM_RUN will return -EPERM.
>> +
>> +:Parameters: none
>> +:Returns:   -EAGAIN if guest memory has been modified while the call was
>> +            executing
>> +            -EBUSY if the feature is already initialized
>> +            -EFAULT if an address backing the guest memory is invalid
>> +            -ENXIO if SPE is not supported or not properly configured
>> +            0 in case of success
> If we need a one-shot finalise call that sets up stage2, is there any mileage in KVM
> reporting how much memory it pinned to stage2? This is so that the VMM can know it got the
> mmap()/mlock() setup correct? Otherwise we depend on noticing silent failures some time
> later... (I prefer the 'all or nothing' for a memslot though.)
>
>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index e51d8f328c7e..2d98248f2c66 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -41,6 +41,7 @@
>>  #include <kvm/arm_hypercalls.h>
>>  #include <kvm/arm_pmu.h>
>>  #include <kvm/arm_psci.h>
>> +#include <kvm/arm_spe.h>
>>  
>>  #ifdef REQUIRES_VIRT
>>  __asm__(".arch_extension	virt");
>> @@ -653,6 +654,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>  	if (unlikely(!kvm_vcpu_initialized(vcpu)))
>>  		return -ENOEXEC;
>>  
>> +	if (vcpu_has_spe(vcpu) && unlikely(!kvm_arm_spe_finalized(vcpu->kvm)))
>> +		return -EPERM;
> (does the unlikely() make a difference here?)
>
>
>>  	ret = kvm_vcpu_first_run_init(vcpu);
>>  	if (ret)
>>  		return ret;
>> @@ -982,12 +986,22 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
>>  	 * ensuring that the data side is always coherent. We still
>>  	 * need to invalidate the I-cache though, as FWB does *not*
>>  	 * imply CTR_EL0.DIC.
>> +	 *
>> +	 * If the guest has SPE, we need to unmap the entire address space to
>> +	 * allow for any changes to the VM memory made by userspace to propagate
>> +	 * to the stage 2 tables when SPE is re-finalized;
> This is about the layout of memory (instead of the contents)? Doesn't this get
> synchronised by the mmu_notifier?
>
> This is registered during kvm_create_vm(), and unregistered during kvm_destroy_vm()... so
> it will see any changeseither side of this call...
>
>
> (the existing call is about cleaning the initial state that the VMM re-wrote to the PoC. I
> can't see how SPE or memory pinning fit in here)
>
>
>>          this also makes sure
>> +	 * we keep the userspace and the guest's view of the memory contents
>> +	 * synchronized.
>>  	 */
>>  	if (vcpu->arch.has_run_once) {
>> -		if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
>> +		if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB) ||
>> +		    vcpu_has_spe(vcpu)) {
>>  			stage2_unmap_vm(vcpu->kvm);
>> -		else
>> +			if (vcpu_has_spe(vcpu))
>> +				kvm_arm_spe_notify_vcpu_init(vcpu);
>> +		} else {
>>  			__flush_icache_all();
>> +		}
>>  	}
>>  
>>  	vcpu_reset_hcr(vcpu);
>
> From here...
>
>> @@ -1045,6 +1059,45 @@ static int kvm_arm_vcpu_has_attr(struct kvm_vcpu *vcpu,
>>  	return ret;
>>  }
>>  
>> +static int kvm_arm_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +	int ret = -ENXIO;
>> +
>> +	switch (attr->group) {
>> +	default:
>> +		ret = kvm_arm_vm_arch_set_attr(kvm, attr);
>> +		break;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int kvm_arm_vm_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +	int ret = -ENXIO;
>> +
>> +	switch (attr->group) {
>> +	default:
>> +		ret = kvm_arm_vm_arch_get_attr(kvm, attr);
>> +		break;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int kvm_arm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +	int ret = -ENXIO;
>> +
>> +	switch (attr->group) {
>> +	default:
>> +		ret = kvm_arm_vm_arch_has_attr(kvm, attr);
>> +		break;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>>  static int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
>>  				   struct kvm_vcpu_events *events)
>>  {
>> @@ -1259,6 +1312,27 @@ long kvm_arch_vm_ioctl(struct file *filp,
>>  
>>  		return 0;
>>  	}
>> +	case KVM_SET_DEVICE_ATTR: {
>> +		struct kvm_device_attr attr;
>> +
>> +		if (copy_from_user(&attr, argp, sizeof(attr)))
>> +			return -EFAULT;
>> +		return kvm_arm_vm_set_attr(kvm, &attr);
>> +	}
>> +	case KVM_GET_DEVICE_ATTR: {
>> +		struct kvm_device_attr attr;
>> +
>> +		if (copy_from_user(&attr, argp, sizeof(attr)))
>> +			return -EFAULT;
>> +		return kvm_arm_vm_get_attr(kvm, &attr);
>> +	}
>> +	case KVM_HAS_DEVICE_ATTR: {
>> +		struct kvm_device_attr attr;
>> +
>> +		if (copy_from_user(&attr, argp, sizeof(attr)))
>> +			return -EFAULT;
>> +		return kvm_arm_vm_has_attr(kvm, &attr);
>> +	}
>>  	default:
>>  		return -EINVAL;
>>  	}> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> index 2ba790eeb782..d0dc4bdb8b4a 100644
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
>> @@ -988,3 +988,51 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>>  
>>  	return ret;
>>  }
>> +
>> +int kvm_arm_vm_arch_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +	int ret;
>> +
>> +	switch (attr->group) {
>> +	case KVM_ARM_VM_SPE_CTRL:
>> +		ret = kvm_arm_vm_spe_set_attr(kvm, attr);
>> +		break;
>> +	default:
>> +		ret = -ENXIO;
>> +		break;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +int kvm_arm_vm_arch_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +	int ret;
>> +
>> +	switch (attr->group) {
>> +	case KVM_ARM_VM_SPE_CTRL:
>> +		ret = kvm_arm_vm_spe_get_attr(kvm, attr);
>> +		break;
>> +	default:
>> +		ret = -ENXIO;
>> +		break;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +int kvm_arm_vm_arch_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +	int ret;
>> +
>> +	switch (attr->group) {
>> +	case KVM_ARM_VM_SPE_CTRL:
>> +		ret = kvm_arm_vm_spe_has_attr(kvm, attr);
>> +		break;
>> +	default:
>> +		ret = -ENXIO;
>> +		break;
>> +	}
>> +
>> +	return ret;
>> +}
> ... to here, is almost entirely boiler plate for supporting 0-or-more vm ioctl. Could this
> be a separate preparatory patch, just so it isn't wrapped up in the SPE/memory-pinning
> specifics?
>
>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index c3c43555490d..31b2216a5881 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1365,6 +1365,175 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>  	return ret;
>>  }
>>  
>> +static int stage2_map_vma(struct kvm *kvm,
>> +			  struct kvm_memory_slot *memslot,
>> +			  struct vm_area_struct *vma,
>> +			  enum kvm_pgtable_prot prot,
>> +			  unsigned long mmu_seq, hva_t *hvap,
>> +			  struct kvm_mmu_memory_cache *cache)
>> +{
>> +	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
>> +	unsigned long stage2_pagesize, remaining;
>> +	bool force_pte, writable;
>> +	hva_t hva, hva_end;
>> +	kvm_pfn_t pfn;
>> +	gpa_t gpa;
>> +	gfn_t gfn;
>> +	int ret;
>> +
>> +	hva = max(memslot->userspace_addr, vma->vm_start);
>> +	hva_end = min(vma->vm_end, memslot->userspace_addr +
>> +			(memslot->npages << PAGE_SHIFT));
>> +
>> +	gpa = (memslot->base_gfn << PAGE_SHIFT) + hva - memslot->userspace_addr;
>> +	gfn = gpa >> PAGE_SHIFT;
>> +
>> +	stage2_pagesize = 1UL << stage2_max_pageshift(memslot, vma, hva, &force_pte);
>> +
>> +	while (hva < hva_end) {
>> +		ret = kvm_mmu_topup_memory_cache(cache,
>> +						 kvm_mmu_cache_min_pages(kvm));
>> +		if (ret)
>> +			return ret;
>> +
>> +		/*
>> +		 * We start mapping with the highest possible page size, so the
>> +		 * gpa and gfn will always be properly aligned to the current
>> +		 * page size.
>> +		 */
>> +		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL, true, &writable);
> Heh, if this causes the stage1 page tables to be changed, it will invoke the mmu notifier,
> which will cause us to fail with -EAGAIN afterwards. User-space could keep retrying, and
> it would fix a page at a time...
>
> Passing atomic here would stop this, as we don't want to update the stage1 tables. If they
> haven't been setup as needed, then this should fail early, with the finger pointing at
> stage1. This way we don't mask a bug in user-space, and get caught out by 'this used to work'.
>
> (or is this what prevents access-flag faults at stage1?)
>
>
>> +		if (pfn == KVM_PFN_ERR_HWPOISON)
>> +			return -EFAULT;> +		if (is_error_noslot_pfn(pfn))
> Doesn't is_error_noslot_pfn() cover KVM_PFN_ERR_HWPOISON?
>
>
>> +			return -EFAULT;
>> +		/* Can only happen if naughty userspace changed the VMA. */
>> +		if (kvm_is_device_pfn(pfn) || !writable)
>> +			return -EAGAIN;
> kvm_release_pfn_(*cough*)() ?
>
> My reading is __gfn_to_pfn_memslot() calls gup, which takes a reference you release (or
> adjust) at the end of the loop.
>
>
>> +		spin_lock(&kvm->mmu_lock);
>> +		if (mmu_notifier_retry(kvm, mmu_seq)) {
>> +			spin_unlock(&kvm->mmu_lock);
>> +			return -EAGAIN;
> (same again)
>
>
>> +		}
>> +
>> +		remaining = hva_end - hva;
>> +		if (stage2_pagesize == PUD_SIZE && remaining < PUD_SIZE)
>> +			stage2_pagesize = PMD_SIZE;
>> +		if (stage2_pagesize == PMD_SIZE && remaining < PMD_SIZE) {
>> +			force_pte = true;
> I had to sleep on this one: You're forced to put down a PTE because of the remaining size
> in the memslot? This is to prevent rolling back up to a THP size if that is what stage1 is
> using?
>
>
>> +			stage2_pagesize = PAGE_SIZE;
>> +		}
>> +
>> +		if (!force_pte && stage2_pagesize == PAGE_SIZE)
>> +			/*
>> +			 * The hva and gpa will always be PMD aligned if
>> +			 * hva is backed by a transparent huge page.
> because you walk through the vma in order... but what about the first page?
>
> What stops me starting my memslot on a 1MB boundary, which is half way through a 2MB THP?
> Doesn't the 'hva=max()' align hva up to the memslot boundary?
>
>
>
>>                          gpa will
>> +			 * not be modified and it's not necessary to recompute
>> +			 * hva.
>> +			 */
>> +			stage2_pagesize = transparent_hugepage_adjust(memslot, hva, &pfn, &gpa);
>> +
>> +		ret = kvm_pgtable_stage2_map(pgt, gpa, stage2_pagesize,
>> +					     __pfn_to_phys(pfn), prot, cache);
>> +		spin_unlock(&kvm->mmu_lock);
>
>> +		kvm_set_pfn_accessed(pfn);
> This leads into mark_page_accessed(), which has:
> |		 * Unevictable pages are on the "LRU_UNEVICTABLE" list. But,
> |		 * this list is never rotated or maintained, so marking an
> |		 * evictable page accessed has no effect.
>
> This is to tell swap 'not yet'? ... Isn't that impossible by this point?
>
>
>
>> +		kvm_release_pfn_dirty(pfn);
>> +		if (ret)
>> +			return ret;
>> +		else if (hva < hva_end)
>> +			cond_resched();
> (we do this even for the last time round the loop as hva hasn't been updated yet)
>
>
>> +		hva += stage2_pagesize;
>> +		gpa += stage2_pagesize;
>> +		gfn = gpa >> PAGE_SHIFT;
>> +	}
>> +
>> +	*hvap = hva;
>> +	return 0;
>> +}
>
>
>> +int kvm_map_locked_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot,
>> +			   enum kvm_pgtable_prot prot)
>> +{
>> +	struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
>> +	struct vm_area_struct *vma;
>> +	unsigned long mmu_seq;
>> +	hva_t hva, hva_memslot_end;
>> +	int ret;
>> +
>> +	lockdep_assert_held(&kvm->slots_lock);
>> +	if (!(prot & KVM_PGTABLE_PROT_R))
>> +		return -EPERM;
>> +	if ((prot & KVM_PGTABLE_PROT_W) && (memslot->flags & KVM_MEM_READONLY))
>> +		return -EPERM;
> This is checking the static value from kvm_arm_spe_finalize()?
>
>
>> +	hva = memslot->userspace_addr;
>> +	hva_memslot_end = memslot->userspace_addr + (memslot->npages << PAGE_SHIFT);
>> +
>> +	/*
>> +	 * Be extra careful here in case userspace is messing with the VMAs
>> +	 * backing the memslot.
>> +	 */
> If we held mmap_read_lock() for the duration, wouldn't that be impossible?
> (and after that point we can scream from the mmu_notifier if a memslot is changed...)
>
>
>> +	mmu_seq = kvm->mmu_notifier_seq;
>> +	smp_rmb();
>> +
>> +	/*
>> +	 * A memslot might span multiple VMAs and any holes between them, while
>> +	 * a VMA might span multiple memslots (see
>> +	 * kvm_arch_prepare_memory_region()). Take the intersection of the VMAs
>> +	 * with the memslot.
>> +	 */
>> +	do {
>> +		mmap_read_lock(current->mm);
>> +		vma = find_vma(current->mm, hva);
>> +		/*
>> +		 * find_vma() returns first VMA with hva < vma->vm_end, which
>> +		 * means that it is possible for the VMA to start *after* the
>> +		 * end of the memslot.
>> +		 */
>> +		if (!vma || vma->vm_start >= hva_memslot_end) {
>> +			mmap_read_unlock(current->mm);
>> +			return 0;
>> +		}
>> +
>> +		/*
>> +		 * VM_LOCKED pages are put in the unevictable LRU list and
>> +		 * hugetlb pages are not put in any LRU list; both will stay
>> +		 * pinned in memory.
>> +		 */
>> +		if (!(vma->vm_flags & VM_LOCKED) && !is_vm_hugetlb_page(vma)) {
>> +			/* Go to next VMA. */
>> +			hva = vma->vm_end;
>> +			mmap_read_unlock(current->mm);
>> +			continue;
>> +		}
>> +		if (!(vma->vm_flags & VM_READ) ||
>> +		    ((prot & KVM_PGTABLE_PROT_W) && !(vma->vm_flags & VM_WRITE))) {
>> +			/* Go to next VMA. */
>> +			hva = vma->vm_end;
>> +			mmap_read_unlock(current->mm);
>> +			continue;
>> +		}
>> +		mmap_read_unlock(current->mm);
> Can't a writer now come in and remove vma?, which you pass to:
>
>> +		ret = stage2_map_vma(kvm, memslot, vma, prot, mmu_seq, &hva, &cache);
> As this only reads from the stage1 entries, I think you may be able to hold a read lock
> for the duration of the loop. (if we tell gup not to write new entries)
>
>
>> +		if (ret)
>> +			return ret;
>> +	} while (hva < hva_memslot_end);
>> +
>> +	if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB)) {
>> +		spin_lock(&kvm->mmu_lock);
>> +		stage2_flush_memslot(kvm, memslot);
>> +		spin_unlock(&kvm->mmu_lock);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +
>>  void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
>>  {
>>  }
>> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
>> index f91a52cd7cd3..316ff8dfed5b 100644
>> --- a/arch/arm64/kvm/spe.c
>> +++ b/arch/arm64/kvm/spe.c
>> @@ -10,6 +10,13 @@
>>  #include <kvm/arm_spe.h>
>>  #include <kvm/arm_vgic.h>
>>  
>> +#include <asm/kvm_mmu.h>
>> +
>> +void kvm_arm_spe_notify_vcpu_init(struct kvm_vcpu *vcpu)
>> +{
>> +	vcpu->kvm->arch.spe.finalized = false;
>> +}
>> +
>>  static bool kvm_arm_vcpu_supports_spe(struct kvm_vcpu *vcpu)
>>  {
>>  	if (!vcpu_has_spe(vcpu))
>> @@ -115,6 +122,50 @@ int kvm_arm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>>  	return -ENXIO;
>>  }
>>  
>> +static int kvm_arm_spe_finalize(struct kvm *kvm)
>> +{
>> +	struct kvm_memory_slot *memslot;
>> +	enum kvm_pgtable_prot prot;
>> +	struct kvm_vcpu *vcpu;
>> +	int i, ret;
>> +
>> +	kvm_for_each_vcpu(i, vcpu, kvm) {
>> +		if (!kvm_arm_spe_vcpu_initialized(vcpu))
>> +			return -ENXIO;
>> +	}
>> +
>> +	mutex_unlock(&kvm->slots_lock);
> Typo?
>
>
>> +	if (kvm_arm_spe_finalized(kvm)) {
>> +		mutex_unlock(&kvm->slots_lock);
>> +		return -EBUSY;
>> +	}
>> +
>> +	prot = KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W;
>> +	kvm_for_each_memslot(memslot, kvm_memslots(kvm)) {
>> +		/* Only map memory that SPE can write to. */
>> +		if (memslot->flags & KVM_MEM_READONLY)
>> +			continue;
>> +		 /*
>> +		  * Dirty page logging will write-protect pages, which breaks
>> +		  * SPE.
>> +		  */
>> +		if (memslot->dirty_bitmap)
>> +			continue;
> This silently skips regions that set KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE, which should be
> harmless until KVM_CLEAR_DIRTY_LOG clears the bitmap bits, and makes them write-protect
> (the runtime update ends in kvm_mmu_write_protect_pt_masked())
>
> It's the silent bit that bothers me. If this were done as a memslot flag, we could tell
> the VMM whether its the mm flags on the vma we can't cope with, or the KVM flag on the
> memslot.
>
>
>> +		ret = kvm_map_locked_memslot(kvm, memslot, prot);
>> +		if (ret)
>> +			break;
>> +	}
>> +
>> +	if (!ret)
>> +		kvm->arch.spe.finalized = true;
>> +	mutex_unlock(&kvm->slots_lock);
>> +
>> +	if (ret)
>> +		stage2_unmap_vm(kvm);
> We haven't put in any invalid mappings, is this needed?
>
>
>
>> +
>> +	return ret;
>> +}
>
> I think separating the boiler plate, and SPE bits from the stage2/mm code would make this
> patch simpler.
>
>
> Thanks,
>
> James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
