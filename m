Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8503AEF5F
	for <kvmarm@lists.linux.dev>; Tue, 13 Oct 2026 08:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791881453; cv=none; b=d6gqR6uIf2WWIIGq7P8jDoSRph4gUxNWeeuVMrZxeuwFJ9uEJU8KefKf9whAdujWAV+mOAQKBzxYV7CCcE6ySDUj6E9OLd2ldkQ3ylxeHo2JAi0zNW0kSEu/IPe9eI7IqFKSC1eOSDKJUBxpmEYjZeGcEzlgZzNS50JsDT9Y0go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791881453; c=relaxed/simple;
	bh=mY7wWFwqV/tYUkujAfXj3LzTbT2dXUljdzHarDcCBlA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=tMWfiq8opwtotmXrOlnNk6PuaQsce/m5vtexHMoVatGqH0ESI+D8Exqk2DjA9iMGnV72+eymlLPs0Uk7nTnVj/EQXQPk5rzugdDGp7nquyKHB5kcdnZm8krQRvsXv7WKzYkHBHREAA7u+XT/Nh/PDJlG1+co6RtRVW2HozC7TOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ma/UYR64; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ma/UYR64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35841F00893;
	Tue, 13 Oct 2026 08:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791881452;
	bh=ljEXd8WFnlqbVQ2QxECKp6gjbMNskbI6S3A2tDXHw7s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ma/UYR64FKRLjjPc53f89XxwTAHtgYXZU6MeMAVpkMQNWJhUz+gXTQQf5EHNWWb45
	 49bBaz1nkt8L4TOkaoe86G+DNAJApBNbJJiBGADFtpqlJGz5s9/OlVraCFmL/Lan39
	 CGxVgk9Kl2Zd+Z9SAawRUBE9sDxu3QumnhyANx8Rq7u1Hhl43eKIyYO0tvoqL2bsOS
	 1jO7HR4ORyobAPvjbNELJRidwtwSXEYQvbJzv6c39H+Ml6cBsTvAiHNSWvcUUpd6BX
	 7wFyx+NKgj2eI8SoqZ3hEoqUuiveqEPdi9AzA5dMGrxcUQIhQ7fIIOXN2HYiTwEkUD
	 GVlIJKs5MFo0g==
Message-ID: <sashiko-outbox-169278@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] KVM: arm64: vgic-its: Remove the pending state
 of a discarded LPI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261013081646.933312-3-fuad.tabba@linux.dev>
References: <20261013081646.933312-1-fuad.tabba@linux.dev>
 <20261013081646.933312-3-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 08:50:51 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] kvm: arm64: vgic-its: TOCTOU race resurrects discarded LPI due to =
IPI skip
- [High] kvm: arm64: vgic-its: Race on vcpu->arch.pause breaks mutual exclu=
sion
- [Medium] kvm: arm64: vgic-its: Global VM halt on DISCARD causes Denial of=
 Service
--

commit 4bb7971d12d2fa6f1083c9f2ddc383b8d63483fb
Author: Fuad Tabba <fuad.tabba@linux.dev>
KVM: arm64: vgic-its: Remove the pending state of a discarded LPI

This commit ensures the pending state of a queued LPI is cleared when handl=
ing
an ITS DISCARD command. It halts the guest before clearing the pending stat=
e if
the LPI is queued on a running vCPU.

> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-it=
s.c
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -829,12 +829,26 @@ static int vgic_its_cmd_handle_discard(struct kvm *=
kvm, struct vgic_its *its,
>  		struct its_device *device =3D find_its_device(its, device_id);
>  		int ite_esz =3D vgic_its_get_abi(its)->ite_esz;
>  		gpa_t gpa =3D device->itt_addr + ite->event_id * ite_esz;
> +		struct vgic_irq *irq =3D ite->irq;
> +		bool queued;
> +
> +		vgic_its_invalidate_cache(its);
> +
>  		/*
> -		 * Though the spec talks about removing the pending state, we
> -		 * don't bother here since we clear the ITTE anyway and the
> -		 * pending state is a property of the ITTE struct.
> +		 * A queued LPI can be pending in a running vCPU's list register,
> +		 * which the exit path folds back: halt the guest before clearing.
>  		 */
> -		vgic_its_invalidate_cache(its);
> +		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
> +			queued =3D irq->vcpu;
> +
> +		if (queued)
> +			kvm_arm_halt_guest(kvm);

[Severity: Medium]
Does this introduce a denial of service if a guest spams DISCARD commands?

Because kvm_arm_halt_guest() forces all vCPUs in the VM to exit, a guest
rapidly issuing DISCARD commands for a single vCPU's LPI could repeatedly
lock up the entire VM and cause host starvation. Could we restrict the
synchronization strictly to the target irq->vcpu where the LPI is queued?

> +
> +		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
> +			irq->pending_latch =3D false;

[Severity: High]
Is there a window here where an exiting vCPU might overwrite the cleared
latch and resurrect the LPI?

If the target vCPU is just exiting when kvm_arm_halt_guest() broadcasts
KVM_REQ_SLEEP, the vCPU sets vcpu->mode =3D OUTSIDE_GUEST_MODE before foldi=
ng
its hardware state in kvm_arch_vcpu_ioctl_run().

Because kvm_request_needs_ipi() checks:

virt/kvm/kvm_main.c:kvm_request_needs_ipi() {
    if (req & KVM_REQUEST_WAIT)
        return mode !=3D OUTSIDE_GUEST_MODE;
}

The IPI is skipped and kvm_arm_halt_guest() returns immediately without
waiting for the vCPU to sync. The DISCARD thread then clears
irq->pending_latch =3D false.

Concurrently, the exiting vCPU executes kvm_vgic_sync_hwstate(), reads the
still-pending state from the hardware LR, and unconditionally overwrites the
cleared latch back to true:

arch/arm64/kvm/vgic/vgic-v3.c:vgic_v3_fold_lr() {
    if (irq->config =3D=3D VGIC_CONFIG_EDGE && (val & ICH_LR_PENDING_BIT))
        irq->pending_latch =3D true;
}

Could we coordinate with the vCPU's state folding sequence to ensure the
discard isn't lost?

> +
> +		if (queued)
> +			kvm_arm_resume_guest(kvm);

[Severity: High]
Can concurrent DISCARD commands on different ITS instances break the mutual
exclusion of vcpu->arch.pause?

vgic_its_cmd_handle_discard() executes holding the per-ITS its->its_lock.
If a VM has multiple ITS devices, two DISCARD commands could run concurrent=
ly
and both call kvm_arm_halt_guest(), which sets vcpu->arch.pause to true
across all vCPUs.

The first thread to finish will call kvm_arm_resume_guest(), which does:

arch/arm64/kvm/arm.c:kvm_arm_resume_guest() {
    kvm_for_each_vcpu(i, vcpu, kvm) {
        vcpu->arch.pause =3D false;
        __kvm_vcpu_wake_up(vcpu);
    }
}

This unconditionally clears the pause flag and wakes up all vCPUs while the
second thread is still modifying VGIC state assuming the guest is fully
halted.

> =20
>  		its_free_ite(kvm, ite);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013081646.9333=
12-1-fuad.tabba@linux.dev?part=3D2
