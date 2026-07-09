Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A46377EB0;
	Thu,  9 Jul 2026 11:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783596880; cv=none; b=RZtqdEqyrMwzwSSdbW8pQkLwgZbO2ji+CEik+wbFef2ak98xAQaXZD5u9DEeJygF4xodDCrLxewR5WOy42Lo9s7aDlOuufUcSrFPfAIADKEY5qSpA4Tf96mqSv+AgCfJAWfPwW22obJG2D1eKPuoexVaOw4YME6fwp78q1pXOTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783596880; c=relaxed/simple;
	bh=0DgU8nSUzuh7seiSQfdsTqIZmeO7w2A+x2yFCcVfHTk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BAVZd+VxcHy3y5iyJ25JqHLz+wYH2wBp1URwH0xgpH1UHCC+PFF1qcJ+F24sO0sWj3d1Vv+HarRMiTyWjM8IlZeQIbZ/8/1N3zU8fA4ldrImBsNz2st379LWi+k9vXvHmqVVUTUIVU6UwL+qdykqrOOdmqQ4JJn7DUTaAT0h2dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hltU2Hhy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hltU2Hhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951C81F000E9;
	Thu,  9 Jul 2026 11:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783596876;
	bh=fmn14wJir933jVT1nI75/QtO1LPl1Dtrh02i7Nq7xZE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hltU2HhyBdZiIclsgR78rvLHgQ8wkRzJKHcyb62bYh7OP77gscEY51GS+1kkjTiti
	 YcZ5ZxJSZ1A+YDMtn2Rnx86gSuQZp2kwMnj68uBmWQ9GXwBIDaa4g8KNFNqlZ38wel
	 XuILBxFCn/Je7UvyXp1MR3Eg/YE0QnUFcm5YTwEx/vNfF3p2xiLmwSfttXSgJVkYFn
	 8UNuiQ1VbM9BInxDgwKh0k7lMdUOyyETgISKij5qW6GskgYGNkwd56UAnAAj7YzLlp
	 PMm3kJhd2QbqcYx7wnSsQr0O0V9uGzylAnLyDUzCFCeCzgnosUsMQ7GnfQyNJpci7g
	 r74hqy9Xzcplw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 6/6] KVM: arm64: Add auto HDBSS enable/disable on
 dirty logging change
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tian Zheng" <zhengtian10@huawei.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260709104026.2612599-7-zhengtian10@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
 <20260709104026.2612599-7-zhengtian10@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 09 Jul 2026 11:34:35 +0000
Message-Id: <20260709113436.951C81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:
- [Critical] Freeing HDBSS buffers synchronously in `kvm_arm_disable_hdbss_=
global()` without kicking vCPUs causes a hardware Use-After-Free and host m=
emory corruption.
- [High] The patch fails to enforce eager page table splitting when `KVM_DI=
RTY_LOG_INITIALLY_SET` is used, violating the HDBSS requirement.
- [High] Global enable/disable functions mutate per-vCPU HDBSS state across=
 all vCPUs without proper locking or KVM request mechanisms.
- [High] Missing `kvm_unshare_hyp()` on the vCPU creation error path breaks=
 pKVM memory ownership.
- [High] Memslots are accessed without SRCU protection when flushing the HD=
BSS buffer.
- [Medium] The dynamically calculated HDBSS buffer order is never saved, ca=
using newly created vCPUs to allocate incorrect 1-page buffers.
- [Medium] A conditional check in `kvm_arm_vcpu_destroy` leaks HDBSS buffer=
s if a TOCTOU race left a vCPU with an allocated buffer while `enable_hdbss=
` is false.
- [Medium] Missing immediate Context Synchronization Events (ISB) for contr=
ol-plane system registers.
--

--- Patch [6]: [PATCH v4 6/6] KVM: arm64: Add auto HDBSS enable/disable on =
dirty logging change ---
commit c993a05c79f4338df277681c6534d32f65490e56
Author: eillon <yezhenyu2@huawei.com>

KVM: arm64: Add auto HDBSS enable/disable on dirty logging change

This commit adds VM-level HDBSS enable/disable support tied to dirty logging
changes. It automatically enables HDBSS when dirty logging starts and disab=
les
it when all memslots stop dirty logging.

> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> index 002366337637c..c5bf866c23ef2 100644
> --- a/arch/arm64/kvm/dirty_bit.c
> +++ b/arch/arm64/kvm/dirty_bit.c
[ ... ]
> +static int kvm_arm_enable_hdbss_global(struct kvm *kvm)
> +{
> +	int err;
> +	unsigned long i;
> +	unsigned int order;
> +	struct kvm_vcpu *vcpu;
[ ... ]
> +	/* Turn it on */
> +	order =3D hdbss_auto_select_order(kvm);
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		err =3D kvm_arm_vcpu_alloc_hdbss(vcpu, order);

[Severity: Medium]
Will newly created vCPUs allocate buffers of the correct size?

The optimal HDBSS buffer order is calculated here based on memslot sizes and
used to allocate buffers for currently online vCPUs, but the value doesn't
seem to be saved to kvm->arch.hdbss_order.

When a new vCPU is created later, it appears kvm_arch_vcpu_create() allocat=
es
its buffer using the uninitialized kvm->arch.hdbss_order:

arch/arm64/kvm/arm.c:kvm_arch_vcpu_create() {
    ...
    err =3D kvm_arm_vcpu_alloc_hdbss(vcpu, vcpu->kvm->arch.hdbss_order);
    ...
}

Could this cause new vCPUs to receive order-0 buffers instead of the
dynamically selected size, leading to mismatched sizes and excessive
buffer-full exits?

[Severity: High]
Is it safe to directly mutate per-vCPU HDBSS state across all vCPUs from the
thread handling the memslot ioctl?

This loop directly calls kvm_arm_vcpu_alloc_hdbss() to mutate vcpu->arch.hd=
bss
without holding vcpu->mutex or using the KVM vCPU requests framework.

Could concurrently running vCPUs undergoing a context switch (like
__load_hdbss) or fault path read partially updated, torn, or freed state,
leading to unpredictable hardware register programming?

> +		if (err)
> +			goto error_alloc;
> +	}
[ ... ]
> +void kvm_arm_disable_hdbss_global(struct kvm *kvm)
> +{
> +	unsigned long i;
> +	struct kvm_vcpu *vcpu;
> +
> +	if (!kvm->arch.enable_hdbss) /* Already Off */
> +		return;
> +
> +	/* Turn it off */
> +	kvm->arch.mmu.vtcr &=3D ~(VTCR_EL2_HD | VTCR_EL2_HDBSS | VTCR_EL2_HA);
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		kvm_arm_vcpu_free_hdbss(vcpu);

[Severity: Critical]
Does this code risk hardware use-after-free and host memory corruption?

When dirty logging is disabled, the enable_hdbss flag and VTCR_EL2 bits are
cleared, and the physical pages are immediately freed. Since this occurs un=
der
kvm->slots_lock, which does not prevent vCPUs from executing in guest mode,
running vCPUs could continue executing with their hardware VTCR_EL2 and
HDBSSBR_EL2 registers still active.

Should this function force running vCPUs to exit (e.g., via kvm_vcpu_kick()=
 or
a KVM request) before freeing the physical pages to prevent the hardware MMU
from asynchronously writing dirty page records into newly freed memory?

> +
> +	kvm->arch.enable_hdbss =3D false;
> +}
[ ... ]
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 949fb895add6a..484f48dae0003 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2588,6 +2588,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  {
>  	bool log_dirty_pages =3D new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
[ ... ]
>  	if (log_dirty_pages) {
> =20
>  		if (change =3D=3D KVM_MR_DELETE)
>  			return;
> =20
>  		/*
>  		 * Huge and normal pages are write-protected and split
>  		 * on either of these two cases:
>  		 *
>  		 * 1. with initial-all-set: gradually with CLEAR ioctls,
>  		 */
>  		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
>  			return;

[Severity: High]
Does this early return violate the HDBSS requirement for eager page table
splitting?

The commit message states that enabling HDBSS requires disabling lazy split=
 so
that all block mappings are eagerly broken down before the buffer starts
recording. However, if userspace utilizes KVM_DIRTY_LOG_INITIALLY_SET, this
path returns early without calling kvm_mmu_split_memory_region().

Since HDBSS was already globally enabled earlier in this function, could it
now operate on block mappings instead of page-granularity tables, defeating
the hardware expectation and corrupting the dirty log state?

[Severity: Medium]
Can a Time-of-Check to Time-of-Use (TOCTOU) race leak HDBSS buffers during
vCPU destruction?

Looking at kvm_arm_vcpu_destroy() in arch/arm64/kvm/reset.c:

kvm_arm_vcpu_destroy() {
    ...
    if (vcpu->kvm->arch.enable_hdbss)
        kvm_arm_vcpu_free_hdbss(vcpu);
    ...
}

If KVM_CREATE_VCPU allocates an HDBSS buffer but kvm_arm_disable_hdbss_glob=
al()
runs before the vCPU is added to online_vcpus, the global disable loop would
miss the vCPU and clear enable_hdbss. When the VM is destroyed, the conditi=
on
would evaluate to false, skipping the cleanup.

Since kvm_arm_vcpu_free_hdbss() natively checks for the existence of the
buffer, is the outer check against enable_hdbss necessary?

[Severity: High]
Does the vCPU creation error path break pKVM memory ownership by missing a
call to kvm_unshare_hyp()?

In arch/arm64/kvm/arm.c, kvm_arch_vcpu_create() shares the vCPU struct memo=
ry
with the hypervisor. If the new allocation fails, the function cleans up and
returns the error:

kvm_arch_vcpu_create() {
    ...
    if (vcpu->kvm->arch.enable_hdbss) {
        err =3D kvm_arm_vcpu_alloc_hdbss(vcpu, vcpu->kvm->arch.hdbss_order);
        if (err)
            kvm_vgic_vcpu_destroy(vcpu);
    }

    return err;
}

Could the memory for the vcpu struct be subsequently freed back to the host
allocator while still marked as shared with the hypervisor, violating pKVM
trust boundaries and triggering a hypervisor panic upon reuse?

[Severity: High]
Does flushing the HDBSS buffer access memslots without SRCU protection?

kvm_flush_hdbss_buffer() processes dirty pages by resolving GFNs via
kvm_vcpu_mark_page_dirty():

arch/arm64/kvm/dirty_bit.c:kvm_flush_hdbss_buffer() {
    ...
    kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
    ...
}

This internal function requires srcu_read_lock(&kvm->srcu) to safely access
the KVM memslots array. However, kvm_flush_hdbss_buffer() is invoked from
kvm_arch_vcpu_put() and check_vcpu_requests(), neither of which hold the SR=
CU
read lock.

Could this create a use-after-free risk when memslots are concurrently
modified?

[Severity: Medium]
Are immediate Context Synchronization Events (ISB) missing for control-plane
system registers?

The ARM64 subsystem rules require that every write to a control-plane system
register must be followed by an isb() as the very next instruction.

In arch/arm64/kvm/dirty_bit.c, a memory store executes between the write and
the isb():

kvm_flush_hdbss_buffer() {
    ...
    write_sysreg_s(0, SYS_HDBSSPROD_EL2);
    vcpu->arch.hdbss.hdbssprod_el2 =3D 0;
    isb();
    ...
}

Similarly, in arch/arm64/kvm/hyp/vhe/switch.c, two sysreg writes occur
back-to-back without an intervening isb():

__load_hdbss() {
    ...
    write_sysreg_s(vcpu->arch.hdbss.hdbssbr_el2, SYS_HDBSSBR_EL2);
    write_sysreg_s(vcpu->arch.hdbss.hdbssprod_el2, SYS_HDBSSPROD_EL2);
    ...
}

Could these patterns risk observing undefined pipeline state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260709104026.2612=
599-1-zhengtian10@huawei.com?part=3D6
