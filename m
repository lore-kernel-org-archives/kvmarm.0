Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C05B43C7D3;
	Mon, 31 Aug 2026 13:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184644; cv=none; b=Ggw9jnVm3lnGrd1Z8fcN7ZX528fG2AV42OZDCTkOLgvLmXo/S/kWasjtDstSc59yedF7BwZdog4/OaCKp9JUl6cejEEDTiwv5LzUtXtO51W41uVfduCrg6LXt6Vdko5f3rTj1VxtYyHXDr9TgmtABknsyESRQvxZhtTIqau34cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184644; c=relaxed/simple;
	bh=DYy7Yh5VuqJ1tPQ5cWpknZiVqRNrR5tqzqmfJyw4ppI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=dKjjmtCFjoHbvsp2PAOTU+Ks8qX/TeHz1DfCS9dlaql03B7fnL9+GIJyaMhg/qxEsjNQxHYQZY4AjZDbobD4YOSV0818iilDxyJWdli1KVoSTJ6jXZWr2JK9ZknegJj0TEvV/ssIFZ0oaBdtD5H8njr6XlJjdI+xl/x3/hknx5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=tmZnaFti; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="tmZnaFti"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=yJ/L9x3rTRjFD26y3XQs185XmGwXv5WubIyollA9Msw=;
	b=tmZnaFtiFCAbBFLgoaXNhmkgyAZn/eVaaDzcPuviyReaeVQ4TD//qtIEmx0GJiwhGW1k2SCyt
	h8PQASl+cY89VEVoEeuVgvyyp0YRBaHPTBARcK/M0YSRoP6lj4OXBstkdbKE68K+tFgdDzQ8SBr
	JUY+2lNhfV6cP/l4j100xas=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hYVdZ5QqnzRhWS;
	Mon, 31 Aug 2026 21:46:26 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 8CB724057D;
	Mon, 31 Aug 2026 21:57:13 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 31 Aug 2026 21:57:13 +0800
Message-ID: <5f750f14-1b80-49d7-96ec-415eb6457224@huawei.com>
Date: Mon, 31 Aug 2026 21:57:12 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/6] KVM: arm64: Add HDBSS fault handling and buffer
 flush
To: <sashiko-reviews@lists.linux.dev>
CC: Oliver Upton <oupton@kernel.org>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
 <20260709104026.2612599-6-zhengtian10@huawei.com>
 <20260709112655.339D91F000E9@smtp.kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <20260709112655.339D91F000E9@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 7/9/2026 7:26 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 6 potential issue(s) to consider:
> - [Critical] Acquiring `kvm->mmu_lock` inside the preempt notifier (`kvm_sched_out` -> `kvm_arch_vcpu_put`) creates an ABBA deadlock with the runqueue lock.
> - [High] `kvm_flush_hdbss_buffer` calls `kvm_vcpu_mark_page_dirty` without holding `srcu_read_lock(&kvm->srcu)`, leading to Use-After-Free.
> - [High] `kvm_arch_sync_dirty_log` silently misses dirty pages for vCPUs outside guest mode due to `KVM_REQUEST_WAIT` semantics.
> - [High] Flushing the entire HDBSS buffer in a single tight loop can overflow the KVM dirty ring, resulting in dropped dirty pages.
> - [High] Directly accessing the EL2 register `SYS_HDBSSPROD_EL2` from the host kernel will crash in nVHE mode.
> - [Medium] Missing immediate Context Synchronization Event (`isb()`) after writing to control-plane system register `SYS_HDBSSPROD_EL2`.
> --
> 
> --- Patch [5]: [PATCH v4 5/6] KVM: arm64: Add HDBSS fault handling and buffer flush ---
> commit ac61acd739dfa5c2e5304969807c386e60452069
> Author: eillon <yezhenyu2@huawei.com>
> Date:   Thu Jul 9 10:40:25 2026 +0000
> 
>      KVM: arm64: Add HDBSS fault handling and buffer flush
> 
> This patch adds handling for HDBSS (Hardware Dirty Bit State Stream) faults,
> triggering flush requests when the hardware buffer becomes full. It implements
> kvm_flush_hdbss_buffer to sync the hardware buffer to the dirty bitmap, which
> is invoked during vcpu_put, request checks, and dirty log synchronization.
> 
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index bf6688245d83a..566953a4e23a1 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -755,6 +755,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>   		kvm_vcpu_put_hw_mmu(vcpu);
>>   	kvm_arm_vmid_clear_active();
>>   
>> +	if (vcpu->kvm->arch.enable_hdbss)
>> +		kvm_flush_hdbss_buffer(vcpu);
>> +
> 
> [Severity: Critical]
> Could this create an ABBA deadlock with the runqueue lock?
> 
> When the scheduler preempts a vCPU thread, it invokes the KVM preempt
> notifier kvm_sched_out() with the runqueue lock (rq->lock) held and
> interrupts disabled. This calls kvm_arch_vcpu_put(), which in turn
> calls kvm_flush_hdbss_buffer().
> 
> The flush function then acquires vcpu->kvm->mmu_lock. Because other
> standard KVM execution paths acquire mmu_lock and may subsequently
> wake up tasks (which acquires rq->lock), this establishes an unavoidable
> locking inversion between rq->lock and mmu_lock.
> 

v5 uses srcu_read_lock(&kvm->srcu) in the flush path, not mmu_lock. The
flush is also moved from vcpu_put() to the run-loop exit path, so no
lock inversion is possible.

> [Severity: High]
> Is it safe to call kvm_flush_hdbss_buffer() here without holding the
> KVM SRCU read lock?
> 
> The kvm_flush_hdbss_buffer() function calls kvm_vcpu_mark_page_dirty(),
> which dereferences the KVM memslots array via kvm_vcpu_gfn_to_memslot().
> 
> When this flush is invoked from kvm_arch_vcpu_put() during vcpu_put(),
> kvm->srcu is not held. The mmu_lock does not protect the memslots array
> structure itself, which could lead to a use-after-free if memslots are
> concurrently modified.
> 
> [ ... ]
> 
>> @@ -1971,7 +1977,15 @@ long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,
>>   
>>   void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>>   {
>> +	/*
>> +	 * Flush all CPUs' dirty log buffers to the dirty_bitmap.  Called
>> +	 * before reporting dirty_bitmap to userspace. Send a request with
>> +	 * KVM_REQUEST_WAIT to flush buffer synchronously.
>> +	 */
>> +	if (!kvm->arch.enable_hdbss)
>> +		return;
>>   
>> +	kvm_make_all_cpus_request(kvm, KVM_REQ_FLUSH_HDBSS | KVM_REQUEST_WAIT);
>>   }
> 

Fixed in v5. kvm_flush_hdbss_buffer() now holds srcu_read_lock(&kvm-
 >srcu) around memslot lookups.

> [Severity: High]
> Will this wait for vCPUs that have exited to userspace?
> 
> The KVM_REQUEST_WAIT flag causes KVM to wait only for vCPUs that are
> currently executing in guest mode. If a vCPU has exited the guest to host
> userspace, it is not in guest mode, but its HDBSS hardware buffer might
> still contain unflushed dirty pages.
> 
> Since the flush request is pended but not waited for, could this return
> immediately and cause userspace to read an incomplete dirty bitmap during
> live migration?
> 
>> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
>> index 6c7a6ef66b5aa..002366337637c 100644
>> --- a/arch/arm64/kvm/dirty_bit.c
>> +++ b/arch/arm64/kvm/dirty_bit.c
>> @@ -50,3 +50,65 @@ void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
> 
> [ ... ]
> 
>> +void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu)
>> +{
>> +	int idx, curr_idx;
>> +	u64 *hdbss_buf;
>> +	struct kvm *kvm = vcpu->kvm;
>> +
>> +	if (!kvm->arch.enable_hdbss)
>> +		return;
>> +
>> +	curr_idx = HDBSSPROD_IDX(read_sysreg_s(SYS_HDBSSPROD_EL2));
> 

The kvm_vcpu_kick() is indeed asynchronous; it only forces vCPUs
currently in guest mode to exit, where the exit path flushes their HDBSS
buffer.

vCPUs that have already exited to userspace have already flushed the
buffer on their way out, and while parked in userspace they cannot
accumulate new entries. For the racing case where a vCPU is kicked but
still in userspace, it will flush before re-entering the guest, but not
immediately.

This is fine by design: the generic KVM dirty-log API explicitly
documents that concurrent bitmap writes may race with KVM_GET_DIRTY_LOG
(see the comment above kvm_get_dirty_log_protect() in virt/kvm/
kvm_main.c). The GET/CLEAR protocol is self-healing — any bit set after
the snapshot is taken won't be cleared by the matching
KVM_CLEAR_DIRTY_LOG, so it survives to the next iteration. The migration
protocol handles this iteratively, and the final snapshot is taken with
the guest paused, ensuring completeness.

> [Severity: High]
> Can this safely execute in nVHE mode?
> 
> This reads the SYS_HDBSSPROD_EL2 register directly from host context.
> In KVM nVHE mode, the host kernel executes at EL1. Accessing an EL2
> register from EL1 will trigger an undefined instruction exception and
> panic the host.
> 
>> +
>> +	/* Do nothing if HDBSS buffer is empty or br_el2 is NULL */
>> +	if (curr_idx == 0 || vcpu->arch.hdbss.hdbssbr_el2 == 0)
>> +		return;
>> +
>> +	hdbss_buf = page_address(phys_to_page(vcpu->arch.hdbss.base_phys));
>> +	if (!hdbss_buf)
>> +		return;
>> +
>> +	guard(write_lock_irqsave)(&vcpu->kvm->mmu_lock);
>> +	for (idx = 0; idx < curr_idx; idx++) {
>> +		u64 gpa;
>> +
>> +		gpa = hdbss_buf[idx];
>> +		if (!(gpa & HDBSS_ENTRY_VALID))
>> +			continue;
>> +
>> +		gpa &= HDBSS_ENTRY_IPA;
>> +		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
> 

Not an issue. HDBSS is VHE-only. system_supports_hdbss() guards all
register accesses, so nVHE never hits this path.

> [Severity: High]
> Does this tight loop risk overflowing the dirty ring?
> 
> When the KVM dirty ring is enabled, kvm_vcpu_mark_page_dirty() pushes
> entries to the per-vCPU ring. The dirty ring signals userspace
> cooperatively when it reaches its soft limit.
> 
> Because the entire HDBSS buffer is flushed in one tight loop, the soft
> limit signal is ignored until the loop finishes. If the number of HDBSS
> entries exceeds the remaining free slots before the hard limit, could
> the ring push fail and silently drop the dirty pages?
> 
>> +	}
>> +
>> +	/* reset HDBSS index */
>> +	write_sysreg_s(0, SYS_HDBSSPROD_EL2);
>> +	vcpu->arch.hdbss.hdbssprod_el2 = 0;
>> +	isb();
> 

Valid point. It will cause a WARN_ON_ONCE(kvm_dirty_ring_full) during 
live migration with dirty-ring + HDBSS. Fixed in v5 by two changes:

1. The flush now runs on every VM exit before handle_exit(), so
check_vcpu_requests() sees the pushed entries on the next loop iteration
and exits to userspace when soft-full.

2. The dirty ring reservation is wired up via kvm_cpu_dirty_log_size()
so rsvd = 64 + hdbss_entries, guaranteeing room for a full buffer flush
— and in dirty-ring mode the HDBSS buffer is fixed at PAGE_SIZE, which 
maximizes performance by minimizing drain frequency.

> [Severity: Medium]
> Is the context synchronization event misplaced here?
> 
> The architectural rules state that every write to a control-plane system
> register must be followed by an isb() as the very next instruction.
> 
> There is a memory store (vcpu->arch.hdbss.hdbssprod_el2 = 0) placed
> between the write_sysreg_s() and the isb(). Could this leave the CPU
> operating under a stale configuration for several cycles?
> 
>> +}
>> +
>> +int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu)
>> +{
>> +	u64 prod;
>> +	u64 fsc;
>> +
>> +	prod = read_sysreg_s(SYS_HDBSSPROD_EL2);
> 

Same answer as the ISB comment on patch 4.

> [Severity: High]
> Like in kvm_flush_hdbss_buffer() above, does reading SYS_HDBSSPROD_EL2
> from the host kernel risk triggering an undefined instruction exception
> if the system is running in nVHE mode?
> 
>> +	fsc = FIELD_GET(HDBSSPROD_EL2_FSC_MASK, prod);
> 
> [ ... ]
> 

Not an issue. HDBSS is VHE-only. system_supports_hdbss() is false on
nVHE, so the registers are never accessed there. We note this in the
cover letter and leave nVHE for future work.

Thanks!
Tian
