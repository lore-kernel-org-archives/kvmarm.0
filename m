Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDF63F58FE;
	Mon, 31 Aug 2026 12:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788179016; cv=none; b=bBRnEPWpXcpNRi3Wzn+Tg28eunQXqQzjtyCWAt+I5mDt3lgBBehtUQ/tyMonV9xk4TuY0jfKSpOupMMyxjarjtyonqRHX/tpFl/BMCiBgbh1pL7cPPoEwMgiQUi7wmHGNP0QerJ+S5yTTnDxmZWUMClveoraFwi9n/SEv02jLuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788179016; c=relaxed/simple;
	bh=K7lYS7+eiBdH4SFRMzi07LtPoeALTT7nKyau2FxTa2I=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=vAA2iLlXnwDT6TFRvr1QVWD19rWzE2OJWCp/UqhO6eBEuswSqEasOPu1bPzOX5SHMA0WT8Fw0cyp/ZZpqKPI/MxC/Btji+TtUyKhgCJZuz+rd7ql6ioqNCGht19C1HO4XeSWjunC+i0+6+V8c/r4STWPeiUm1MNkcUZ2WBaJHUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=dP74fKIJ; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="dP74fKIJ"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Cuh/1B82iF/ngnjO4OCGUJIoo5abhoSYv5LIeH6KToU=;
	b=dP74fKIJHRNy/3yksVERoCDFyJRzf0yMRPSgASCSECCRuNWmNut9BdSmBTfXsc7K1r10XqJ7R
	9IXZLS2Cd9vyb78zc6hYkvIi/vb9hxa9/9W7vm/y8FuGZ582/vBztnw0HmOR+l5TOPRg3eUKgkH
	d6ll7j5RCtAdthtlEJg6ldU=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hYSYT4Mx2zcb0T;
	Mon, 31 Aug 2026 20:12:45 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id D01784058C;
	Mon, 31 Aug 2026 20:23:27 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 31 Aug 2026 20:23:27 +0800
Message-ID: <8a593c94-3fa5-4504-bbd3-4f9bbaf78264@huawei.com>
Date: Mon, 31 Aug 2026 20:23:26 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] KVM: arm64: Add auto HDBSS enable/disable on dirty
 logging change
To: <sashiko-reviews@lists.linux.dev>
CC: <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>, Oliver Upton
	<oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
 <20260709104026.2612599-7-zhengtian10@huawei.com>
 <20260709113436.951C81F000E9@smtp.kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <20260709113436.951C81F000E9@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 7/9/2026 7:34 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 8 potential issue(s) to consider:
> - [Critical] Freeing HDBSS buffers synchronously in `kvm_arm_disable_hdbss_global()` without kicking vCPUs causes a hardware Use-After-Free and host memory corruption.
> - [High] The patch fails to enforce eager page table splitting when `KVM_DIRTY_LOG_INITIALLY_SET` is used, violating the HDBSS requirement.
> - [High] Global enable/disable functions mutate per-vCPU HDBSS state across all vCPUs without proper locking or KVM request mechanisms.
> - [High] Missing `kvm_unshare_hyp()` on the vCPU creation error path breaks pKVM memory ownership.
> - [High] Memslots are accessed without SRCU protection when flushing the HDBSS buffer.
> - [Medium] The dynamically calculated HDBSS buffer order is never saved, causing newly created vCPUs to allocate incorrect 1-page buffers.
> - [Medium] A conditional check in `kvm_arm_vcpu_destroy` leaks HDBSS buffers if a TOCTOU race left a vCPU with an allocated buffer while `enable_hdbss` is false.
> - [Medium] Missing immediate Context Synchronization Events (ISB) for control-plane system registers.
> --
> 
> --- Patch [6]: [PATCH v4 6/6] KVM: arm64: Add auto HDBSS enable/disable on dirty logging change ---
> commit c993a05c79f4338df277681c6534d32f65490e56
> Author: eillon <yezhenyu2@huawei.com>
> 
> KVM: arm64: Add auto HDBSS enable/disable on dirty logging change
> 
> This commit adds VM-level HDBSS enable/disable support tied to dirty logging
> changes. It automatically enables HDBSS when dirty logging starts and disables
> it when all memslots stop dirty logging.
> 
>> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
>> index 002366337637c..c5bf866c23ef2 100644
>> --- a/arch/arm64/kvm/dirty_bit.c
>> +++ b/arch/arm64/kvm/dirty_bit.c
> [ ... ]
>> +static int kvm_arm_enable_hdbss_global(struct kvm *kvm)
>> +{
>> +	int err;
>> +	unsigned long i;
>> +	unsigned int order;
>> +	struct kvm_vcpu *vcpu;
> [ ... ]
>> +	/* Turn it on */
>> +	order = hdbss_auto_select_order(kvm);
>> +	kvm_for_each_vcpu(i, vcpu, kvm) {
>> +		err = kvm_arm_vcpu_alloc_hdbss(vcpu, order);
> 
> [Severity: Medium]
> Will newly created vCPUs allocate buffers of the correct size?
> 
> The optimal HDBSS buffer order is calculated here based on memslot sizes and
> used to allocate buffers for currently online vCPUs, but the value doesn't
> seem to be saved to kvm->arch.hdbss_order.
> 
> When a new vCPU is created later, it appears kvm_arch_vcpu_create() allocates
> its buffer using the uninitialized kvm->arch.hdbss_order:
> 
> arch/arm64/kvm/arm.c:kvm_arch_vcpu_create() {
>      ...
>      err = kvm_arm_vcpu_alloc_hdbss(vcpu, vcpu->kvm->arch.hdbss_order);
>      ...
> }
> 
> Could this cause new vCPUs to receive order-0 buffers instead of the
> dynamically selected size, leading to mismatched sizes and excessive
> buffer-full exits?
> 

Addressed by redesign in v5. The dynamic order calculation is removed.
The buffer size is now stored in kvm->arch.hdbss_buffer_size (bytes),
set either by the user via KVM_CAP_ARM_HDBSS_BUFFER_SIZE (before vCPU
creation), or by kvm_arch_dirty_ring_size_updated() when dirty-ring is
configured, or defaults to PAGE_SIZE. Since it is stored in kvm->arch
before any vCPU exists, all vCPUs — including later-created ones —
allocate a consistent size.

> [Severity: High]
> Is it safe to directly mutate per-vCPU HDBSS state across all vCPUs from the
> thread handling the memslot ioctl?
> 
> This loop directly calls kvm_arm_vcpu_alloc_hdbss() to mutate vcpu->arch.hdbss
> without holding vcpu->mutex or using the KVM vCPU requests framework.
> 
> Could concurrently running vCPUs undergoing a context switch (like
> __load_hdbss) or fault path read partially updated, torn, or freed state,
> leading to unpredictable hardware register programming?
> 
>> +		if (err)
>> +			goto error_alloc;
>> +	}
> [ ... ]
>> +void kvm_arm_disable_hdbss_global(struct kvm *kvm)
>> +{
>> +	unsigned long i;
>> +	struct kvm_vcpu *vcpu;
>> +
>> +	if (!kvm->arch.enable_hdbss) /* Already Off */
>> +		return;
>> +
>> +	/* Turn it off */
>> +	kvm->arch.mmu.vtcr &= ~(VTCR_EL2_HD | VTCR_EL2_HDBSS | VTCR_EL2_HA);
>> +
>> +	kvm_for_each_vcpu(i, vcpu, kvm)
>> +		kvm_arm_vcpu_free_hdbss(vcpu);
> 

Addressed by redesign in v5. Enable/disable no longer touch any per-vCPU 
state. Buffers are pre-allocated at vCPU creation, and enable/disable 
only flips VTCR bits in kvm->arch.mmu.vtcr (a VM-level field written 
only from the memslot-ioctl path under slots_lock) followed by a kick. 
vCPUs pick up the new VTCR when __load_stage2() reprograms vtcr_el2 on 
re-entry.


> [Severity: Critical]
> Does this code risk hardware use-after-free and host memory corruption?
> 
> When dirty logging is disabled, the enable_hdbss flag and VTCR_EL2 bits are
> cleared, and the physical pages are immediately freed. Since this occurs under
> kvm->slots_lock, which does not prevent vCPUs from executing in guest mode,
> running vCPUs could continue executing with their hardware VTCR_EL2 and
> HDBSSBR_EL2 registers still active.
> 
> Should this function force running vCPUs to exit (e.g., via kvm_vcpu_kick() or
> a KVM request) before freeing the physical pages to prevent the hardware MMU
> from asynchronously writing dirty page records into newly freed memory?
> 
>> +
>> +	kvm->arch.enable_hdbss = false;
>> +}
> [ ... ]
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 949fb895add6a..484f48dae0003 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -2588,6 +2588,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>>   {
>>   	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
> [ ... ]
>>   	if (log_dirty_pages) {
>>   
>>   		if (change == KVM_MR_DELETE)
>>   			return;
>>   
>>   		/*
>>   		 * Huge and normal pages are write-protected and split
>>   		 * on either of these two cases:
>>   		 *
>>   		 * 1. with initial-all-set: gradually with CLEAR ioctls,
>>   		 */
>>   		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
>>   			return;
> 

Valid point, addressed by redesign in v5. kvm_arm_disable_hdbss_global() 
no longer frees buffers at all — it only clears the VTCR HDBSS bits and 
kicks vCPUs out of guest mode via KVM_REQ_OUTSIDE_GUEST_MODE. Buffers 
are allocated at vCPU creation and freed only at vCPU destruction 
(PML-style), so there is no window where the MMU can write into freed 
memory.

> [Severity: High]
> Does this early return violate the HDBSS requirement for eager page table
> splitting?
> 
> The commit message states that enabling HDBSS requires disabling lazy split so
> that all block mappings are eagerly broken down before the buffer starts
> recording. However, if userspace utilizes KVM_DIRTY_LOG_INITIALLY_SET, this
> path returns early without calling kvm_mmu_split_memory_region().
> 
> Since HDBSS was already globally enabled earlier in this function, could it
> now operate on block mappings instead of page-granularity tables, defeating
> the hardware expectation and corrupting the dirty log state?
> 

Not an issue in the v5 design. With KVM_DIRTY_LOG_INITIALLY_SET, 
userspace clears the bitmap via CLEAR ioctls; the clear path 
write-protects, and v5's wrprotect strips DBM from blocks (->RO) so the 
first write faults and triggers the split, while level-3 pages go WC 
(DBM=1, S2AP_W=0) and are re-tracked by HDBSS. Since v5 supports lazy 
split in the HDBSS flow, the early return on INITIALLY_SET does not 
break dirty tracking.


> [Severity: Medium]
> Can a Time-of-Check to Time-of-Use (TOCTOU) race leak HDBSS buffers during
> vCPU destruction?
> 
> Looking at kvm_arm_vcpu_destroy() in arch/arm64/kvm/reset.c:
> 
> kvm_arm_vcpu_destroy() {
>      ...
>      if (vcpu->kvm->arch.enable_hdbss)
>          kvm_arm_vcpu_free_hdbss(vcpu);
>      ...
> }
> 
> If KVM_CREATE_VCPU allocates an HDBSS buffer but kvm_arm_disable_hdbss_global()
> runs before the vCPU is added to online_vcpus, the global disable loop would
> miss the vCPU and clear enable_hdbss. When the VM is destroyed, the condition
> would evaluate to false, skipping the cleanup.
> 
> Since kvm_arm_vcpu_free_hdbss() natively checks for the existence of the
> buffer, is the outer check against enable_hdbss necessary?
> 

Addressed in v5. kvm_arm_vcpu_destroy() calls kvm_arm_vcpu_free_hdbss() 
unconditionally (the function itself checks for buffer existence), and 
the enable_hdbss conditional — along with the flag itself — no longer 
exists.

> [Severity: High]
> Does the vCPU creation error path break pKVM memory ownership by missing a
> call to kvm_unshare_hyp()?
> 
> In arch/arm64/kvm/arm.c, kvm_arch_vcpu_create() shares the vCPU struct memory
> with the hypervisor. If the new allocation fails, the function cleans up and
> returns the error:
> 
> kvm_arch_vcpu_create() {
>      ...
>      if (vcpu->kvm->arch.enable_hdbss) {
>          err = kvm_arm_vcpu_alloc_hdbss(vcpu, vcpu->kvm->arch.hdbss_order);
>          if (err)
>              kvm_vgic_vcpu_destroy(vcpu);
>      }
> 
>      return err;
> }
> 
> Could the memory for the vcpu struct be subsequently freed back to the host
> allocator while still marked as shared with the hypervisor, violating pKVM
> trust boundaries and triggering a hypervisor panic upon reuse?
> 

Not applicable. HDBSS is VHE-only. The error path does not touch pKVM 
ownership — it simply cleans up the local allocation. pKVM support is 
explicitly out of scope and left as future work.

> [Severity: High]
> Does flushing the HDBSS buffer access memslots without SRCU protection?
> 
> kvm_flush_hdbss_buffer() processes dirty pages by resolving GFNs via
> kvm_vcpu_mark_page_dirty():
> 
> arch/arm64/kvm/dirty_bit.c:kvm_flush_hdbss_buffer() {
>      ...
>      kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
>      ...
> }
> 
> This internal function requires srcu_read_lock(&kvm->srcu) to safely access
> the KVM memslots array. However, kvm_flush_hdbss_buffer() is invoked from
> kvm_arch_vcpu_put() and check_vcpu_requests(), neither of which hold the SRCU
> read lock.
> 
> Could this create a use-after-free risk when memslots are concurrently
> modified?
> 

Valid point, addressed in v5. kvm_flush_hdbss_buffer() now holds 
srcu_read_lock(&kvm->srcu) around the loop that resolves GFNs through 
the memslots, and releases it before resetting HDBSSPROD_EL2.

> [Severity: Medium]
> Are immediate Context Synchronization Events (ISB) missing for control-plane
> system registers?
> 
> The ARM64 subsystem rules require that every write to a control-plane system
> register must be followed by an isb() as the very next instruction.
> 
> In arch/arm64/kvm/dirty_bit.c, a memory store executes between the write and
> the isb():
> 
> kvm_flush_hdbss_buffer() {
>      ...
>      write_sysreg_s(0, SYS_HDBSSPROD_EL2);
>      vcpu->arch.hdbss.hdbssprod_el2 = 0;
>      isb();
>      ...
> }
> 
> Similarly, in arch/arm64/kvm/hyp/vhe/switch.c, two sysreg writes occur
> back-to-back without an intervening isb():
> 
> __load_hdbss() {
>      ...
>      write_sysreg_s(vcpu->arch.hdbss.hdbssbr_el2, SYS_HDBSSBR_EL2);
>      write_sysreg_s(vcpu->arch.hdbss.hdbssprod_el2, SYS_HDBSSPROD_EL2);
>      ...
> }
> 
> Could these patterns risk observing undefined pipeline state?
>


Duplicate of the ISB comments on patches 4/5.

Thanks!
Tian


