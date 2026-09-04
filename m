Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2CC48987B;
	Fri,  4 Sep 2026 12:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788526254; cv=none; b=oDEupd5OiXXGbaNo/fFYrUN2Kc+vzt5ifvghWhiFW0wocYXNwSahlopn+zC8Fn2f9QIxPLR6YIHQWp01WiPxM+0SamKFOeyfT2g5KM94zuUNGs2yt7UCRHYevh/UAk656b3cQ5e5hKTsYxoKoXMlXEbTYD31i3KWP5k6Dc2kLZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788526254; c=relaxed/simple;
	bh=iIiKoaCB+UhasDvwCBoituzWTM3Iy85/DuAIaOfidoU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Kemh1NTPhXp9EYgT/TQeVDY7OoxoqBzOsM9v1xtzB7MqJN1m5KYGcF2L+2lBrLTuCgKGH9vww4uzybTwbxR+OhGDAV5okvhc3xn0u+SPeKD+iSbeTaVXDobMi/OsoedaO/Q6TPG211f4LL3rZHCO7VV7u7WY4Dkb2/BC/fnzjB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f67fPuif; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f67fPuif"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4795B1F00A3D;
	Fri,  4 Sep 2026 12:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788526252;
	bh=TBbORKReER/1p0BUAlr1R7MM2dQJ91HXXrcH7eAwwTk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f67fPuifYLs/gUA25nWqn4FnW5IebFY3rfJ7SCReq8OuUkDvIPhRXaye5Su+mloPf
	 lWB2pynSrlXBuICE5d5OgN1IVkvkGad15b5qQtscV+ifL+xljJ8AZvSbHLxOaLGmQP
	 pcAopd+X+eBj+GGu3oztWdN+eGIlQevIn/Ig48Qz4M7b3UhQcK64qQmOLe4MqqIHWy
	 w1KXZrx71Ig914FAxoJuq+QNkrqW7HutQ46Qzk08e9MmRIbFFYMaJUfYAKrmTkw2cA
	 JXR+BUCPAtLTEMDQPPCIRXvEeU608AvfRXSu2K8mHXJis/KwmQjBlpUJo0NJoZCHOi
	 TnM7yrVw+rY0g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 14/49] KVM: arm64: gic-v5: Set up VMTEs and VPE
 doorbells
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260904113404.4051341-15-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-15-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 12:50:51 +0000
Message-Id: <20260904125052.4795B1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Guest/Userspace-reachable WARN_ON() in vgic_v5_reset() allows unpr=
ivileged Denial of Service
- [High] Concurrent vCPU creation during vgic_v5_init() leads to out-of-bou=
nds IRQ free
- [High] Doorbell LPIs are freed and can be reallocated while still in use =
by unresponsive hardware
--

commit 44d8f1c654ba05556ff20d22e8e4b8b74f493342
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
KVM: arm64: gic-v5: Set up VMTEs and VPE doorbells

This commit sets up GICv5 VM table entries and VPE doorbells by allocating
a VM ID and creating a per-VM VPE doorbell IRQ domain. It also provides the
initialization and teardown paths to manage this state.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 455161e52f81b..5b599821b2da2 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
[ ... ]
> @@ -562,33 +580,122 @@ void vgic_v5_reset(struct kvm_vcpu *vcpu)
>  	 * CPUIF (but potentially fewer in the IRS).
>  	 */
>  	vcpu->arch.vgic_cpu.num_pri_bits =3D 5;
> +
> +	/* Make the VPE valid in the VPET */
> +	if (WARN_ON(vgic_v5_send_command(vcpu, VPE_MAKE_VALID)))
> +		return;
> +}

[Severity: High]
Can this WARN_ON be triggered by unprivileged userspace, potentially leading
to a host panic if panic_on_warn is enabled?

If userspace calls KVM_ARM_VCPU_INIT before KVM_DEV_ARM_VGIC_CTRL_INIT has
successfully completed, the reset path reaches vgic_v5_reset() and attempts
to send VPE_MAKE_VALID. Because the VGIC has not been initialized, the
doorbell IRQ is still uninitialized (0). This causes vgic_v5_send_command()
to return -ENXIO, directly hitting this warning.

The KVM subsystem guidelines suggest that userspace-reachable warnings shou=
ld
be converted to normal error handling or rate-limited prints to avoid a
denial of service.

> +
> +static void vgic_v5_free_doorbells(struct kvm *kvm, unsigned int nr_dbs)
> +{
> +	struct vgic_v5_vm *vm =3D &kvm->arch.vgic.gicv5_vm;
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
> +	int db;
> +
> +	for (i =3D 0; i < nr_dbs; i++) {
> +		vcpu =3D kvm_get_vcpu(kvm, i);
> +		db =3D vgic_v5_vpe_db(vcpu);
> +		if (!db)
> +			continue;
> +
> +		free_irq(db, vcpu);
> +		vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db =3D 0;
> +	}
> +
> +	if (vm->vpe_db_base) {
> +		irq_domain_free_irqs(vm->vpe_db_base,
> +				     atomic_read(&kvm->online_vcpus));

[Severity: High]
Does this free more descriptors than were originally allocated if a vCPU is
created concurrently?

During vgic_v5_init(), the doorbell domain is sized based on a snapshot of
atomic_read(&kvm->online_vcpus). If a userspace thread calls KVM_CREATE_VCPU
concurrently, it increments created_vcpus and blocks on the config_lock.
Initialization then proceeds with the older, smaller online_vcpus count.
Once the vCPU creation completes, online_vcpus is incremented.

When the VM is torn down, this code uses the new, larger online_vcpus count
to free the domain interrupts, which results in an out-of-bounds free that
could corrupt the LPI domain.

> +		vm->vpe_db_base =3D 0;
> +	}
> +}
> +
> +void vgic_v5_teardown(struct kvm *kvm)
> +{
> +	struct vgic_dist *dist =3D &kvm->arch.vgic;
> +	struct kvm_vcpu *vcpu, *vcpu0;
> +	bool release_vm_id =3D true;
> +	unsigned long i;
> +	int rc;
> +
> +	lockdep_assert_held(&kvm->arch.config_lock);
> +
> +	/*
> +	 * If the VM's ID isn't valid, then we either failed init very early or
> +	 * we've been called a second time. Nothing to do here in either case.
> +	 */
> +	if (kvm->arch.vgic.gicv5_vm.vm_id =3D=3D VGIC_V5_VM_ID_INVAL)
> +		return;
> +
> +	if (kvm->arch.vgic.gicv5_vm.vmte_allocated) {
> +		/* Make the VM invalid  */
> +		vcpu0 =3D kvm_get_vcpu(kvm, 0);
> +		rc =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_INVALID);
> +		if (rc) {
> +			kvm_err("could not make VMTE invalid\n");
> +			release_vm_id =3D false;
> +			goto out_free_doorbells;

[Severity: High]
If the IRS hardware is wedged and VMTE_MAKE_INVALID fails, does jumping
straight to out_free_doorbells cause a use-after-free of the LPIs?

The error path correctly quarantines the VM ID by clearing release_vm_id to
prevent immediate reuse. However, unconditionally branching to
out_free_doorbells returns the doorbell IRQs to the global allocator. Since
the wedged hardware still considers the VMTE valid, it could continue firing
interrupts using the freed LPI numbers, potentially corrupting state if
those LPIs are reallocated to other devices or VMs.

> +		}
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D14
