Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3603FC5BE;
	Thu,  9 Jul 2026 11:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783596417; cv=none; b=qHLvmATMEGcrvKaTmiGj+XNxY3MvIiih3MYpqseWra3bEZ6u3INx3d0++LezjhzZ4eM+XiGwEgxiiClwh8vRCNDTKb4gfcMSVdsh9fKYHsFtdC1pocteP5wo4+WIH/EibwvHW4PuZzUvhl/MoWIX38+PgQ8qTfYnnBThcRKuCPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783596417; c=relaxed/simple;
	bh=Yhhgl/QQDWFXmOnsr6X7VELFEWpDqqrTNCZRCArAJ5I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rdyoIHIKf77Yt8qXCL1EVGnb2Q3rqKkoztyS4qGJi9G/9R0ItJ+cdf1Y3Gg22rU5KjZ2wSMOh3CBWGFIgEZdMG2Zs39bY481YikxKSXABp3ZB2nuW2Mc8Lbuf45OrS2ihnbq56VHLCcUS1tBy3/Gp0iqir6Af2qwDY91tn/mqPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A0/yPiAy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A0/yPiAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339D91F000E9;
	Thu,  9 Jul 2026 11:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783596416;
	bh=97UZqGGniZtEGn6wutJHBs7RSgYHH7kmeqOHWwRS4g0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A0/yPiAyYcM3OrufJg8xXgxLwcK1BOMVevchRzreugC6vLkMlIsqXoOr6LayNbGDG
	 dFkXNlhN8J9RdcIyMwxYdY5SrS6Oj5wT4TDcZS2ox2Dc3bJUa0fkblg83u039zQNCX
	 cCFrcTNbtpzBsO8cnMJ8Ndn6va8oa83Q+C/UA6E2F/rfVv4PMKUqvqT2M6y4tMiY/s
	 cdaGo0ML/5p4aaHg5FNolHOnwtI4kykSR9hGx3kb8QViWb/yfoWyqkTgBmr0mLNLFp
	 ceuggefGsRdgBhRJvf2kL4PogzA8O6vkZUZkyo1AInRL7osOyJvPsTIdX++hm4cTnb
	 ffsOiJlslTDsw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 5/6] KVM: arm64: Add HDBSS fault handling and buffer
 flush
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tian Zheng" <zhengtian10@huawei.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260709104026.2612599-6-zhengtian10@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
 <20260709104026.2612599-6-zhengtian10@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 09 Jul 2026 11:26:54 +0000
Message-Id: <20260709112655.339D91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [Critical] Acquiring `kvm->mmu_lock` inside the preempt notifier (`kvm_sc=
hed_out` -> `kvm_arch_vcpu_put`) creates an ABBA deadlock with the runqueue=
 lock.
- [High] `kvm_flush_hdbss_buffer` calls `kvm_vcpu_mark_page_dirty` without =
holding `srcu_read_lock(&kvm->srcu)`, leading to Use-After-Free.
- [High] `kvm_arch_sync_dirty_log` silently misses dirty pages for vCPUs ou=
tside guest mode due to `KVM_REQUEST_WAIT` semantics.
- [High] Flushing the entire HDBSS buffer in a single tight loop can overfl=
ow the KVM dirty ring, resulting in dropped dirty pages.
- [High] Directly accessing the EL2 register `SYS_HDBSSPROD_EL2` from the h=
ost kernel will crash in nVHE mode.
- [Medium] Missing immediate Context Synchronization Event (`isb()`) after =
writing to control-plane system register `SYS_HDBSSPROD_EL2`.
--

--- Patch [5]: [PATCH v4 5/6] KVM: arm64: Add HDBSS fault handling and buff=
er flush ---
commit ac61acd739dfa5c2e5304969807c386e60452069
Author: eillon <yezhenyu2@huawei.com>
Date:   Thu Jul 9 10:40:25 2026 +0000

    KVM: arm64: Add HDBSS fault handling and buffer flush

This patch adds handling for HDBSS (Hardware Dirty Bit State Stream) faults,
triggering flush requests when the hardware buffer becomes full. It impleme=
nts
kvm_flush_hdbss_buffer to sync the hardware buffer to the dirty bitmap, whi=
ch
is invoked during vcpu_put, request checks, and dirty log synchronization.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index bf6688245d83a..566953a4e23a1 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -755,6 +755,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  		kvm_vcpu_put_hw_mmu(vcpu);
>  	kvm_arm_vmid_clear_active();
> =20
> +	if (vcpu->kvm->arch.enable_hdbss)
> +		kvm_flush_hdbss_buffer(vcpu);
> +

[Severity: Critical]
Could this create an ABBA deadlock with the runqueue lock?

When the scheduler preempts a vCPU thread, it invokes the KVM preempt
notifier kvm_sched_out() with the runqueue lock (rq->lock) held and
interrupts disabled. This calls kvm_arch_vcpu_put(), which in turn
calls kvm_flush_hdbss_buffer().

The flush function then acquires vcpu->kvm->mmu_lock. Because other
standard KVM execution paths acquire mmu_lock and may subsequently
wake up tasks (which acquires rq->lock), this establishes an unavoidable
locking inversion between rq->lock and mmu_lock.

[Severity: High]
Is it safe to call kvm_flush_hdbss_buffer() here without holding the
KVM SRCU read lock?

The kvm_flush_hdbss_buffer() function calls kvm_vcpu_mark_page_dirty(),
which dereferences the KVM memslots array via kvm_vcpu_gfn_to_memslot().

When this flush is invoked from kvm_arch_vcpu_put() during vcpu_put(),
kvm->srcu is not held. The mmu_lock does not protect the memslots array
structure itself, which could lead to a use-after-free if memslots are
concurrently modified.

[ ... ]

> @@ -1971,7 +1977,15 @@ long kvm_arch_vcpu_unlocked_ioctl(struct file *fil=
p, unsigned int ioctl,
> =20
>  void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *me=
mslot)
>  {
> +	/*
> +	 * Flush all CPUs' dirty log buffers to the dirty_bitmap.  Called
> +	 * before reporting dirty_bitmap to userspace. Send a request with
> +	 * KVM_REQUEST_WAIT to flush buffer synchronously.
> +	 */
> +	if (!kvm->arch.enable_hdbss)
> +		return;
> =20
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_FLUSH_HDBSS | KVM_REQUEST_WAIT);
>  }

[Severity: High]
Will this wait for vCPUs that have exited to userspace?

The KVM_REQUEST_WAIT flag causes KVM to wait only for vCPUs that are
currently executing in guest mode. If a vCPU has exited the guest to host
userspace, it is not in guest mode, but its HDBSS hardware buffer might
still contain unflushed dirty pages.

Since the flush request is pended but not waited for, could this return
immediately and cause userspace to read an incomplete dirty bitmap during
live migration?

> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> index 6c7a6ef66b5aa..002366337637c 100644
> --- a/arch/arm64/kvm/dirty_bit.c
> +++ b/arch/arm64/kvm/dirty_bit.c
> @@ -50,3 +50,65 @@ void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)

[ ... ]

> +void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu)
> +{
> +	int idx, curr_idx;
> +	u64 *hdbss_buf;
> +	struct kvm *kvm =3D vcpu->kvm;
> +
> +	if (!kvm->arch.enable_hdbss)
> +		return;
> +
> +	curr_idx =3D HDBSSPROD_IDX(read_sysreg_s(SYS_HDBSSPROD_EL2));

[Severity: High]
Can this safely execute in nVHE mode?

This reads the SYS_HDBSSPROD_EL2 register directly from host context.
In KVM nVHE mode, the host kernel executes at EL1. Accessing an EL2
register from EL1 will trigger an undefined instruction exception and
panic the host.

> +
> +	/* Do nothing if HDBSS buffer is empty or br_el2 is NULL */
> +	if (curr_idx =3D=3D 0 || vcpu->arch.hdbss.hdbssbr_el2 =3D=3D 0)
> +		return;
> +
> +	hdbss_buf =3D page_address(phys_to_page(vcpu->arch.hdbss.base_phys));
> +	if (!hdbss_buf)
> +		return;
> +
> +	guard(write_lock_irqsave)(&vcpu->kvm->mmu_lock);
> +	for (idx =3D 0; idx < curr_idx; idx++) {
> +		u64 gpa;
> +
> +		gpa =3D hdbss_buf[idx];
> +		if (!(gpa & HDBSS_ENTRY_VALID))
> +			continue;
> +
> +		gpa &=3D HDBSS_ENTRY_IPA;
> +		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);

[Severity: High]
Does this tight loop risk overflowing the dirty ring?

When the KVM dirty ring is enabled, kvm_vcpu_mark_page_dirty() pushes
entries to the per-vCPU ring. The dirty ring signals userspace
cooperatively when it reaches its soft limit.

Because the entire HDBSS buffer is flushed in one tight loop, the soft
limit signal is ignored until the loop finishes. If the number of HDBSS
entries exceeds the remaining free slots before the hard limit, could
the ring push fail and silently drop the dirty pages?

> +	}
> +
> +	/* reset HDBSS index */
> +	write_sysreg_s(0, SYS_HDBSSPROD_EL2);
> +	vcpu->arch.hdbss.hdbssprod_el2 =3D 0;
> +	isb();

[Severity: Medium]
Is the context synchronization event misplaced here?

The architectural rules state that every write to a control-plane system
register must be followed by an isb() as the very next instruction.

There is a memory store (vcpu->arch.hdbss.hdbssprod_el2 =3D 0) placed
between the write_sysreg_s() and the isb(). Could this leave the CPU
operating under a stale configuration for several cycles?

> +}
> +
> +int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu)
> +{
> +	u64 prod;
> +	u64 fsc;
> +
> +	prod =3D read_sysreg_s(SYS_HDBSSPROD_EL2);

[Severity: High]
Like in kvm_flush_hdbss_buffer() above, does reading SYS_HDBSSPROD_EL2
from the host kernel risk triggering an undefined instruction exception
if the system is running in nVHE mode?

> +	fsc =3D FIELD_GET(HDBSSPROD_EL2_FSC_MASK, prod);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260709104026.2612=
599-1-zhengtian10@huawei.com?part=3D5
