Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E0A44AB82
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790114493; cv=none; b=SHDJ5HMmfz9UV4zR0tu5GCOzgA1XX21YrVyB2uJrbbBLOSXdlp7ar5jD5Z3pLca2Qh8O2Ubbv0FMWkYoMk+rAKEj/7Qn6YSKXQYoTtO2r92QBAAwyc6MXg5VkqlBdtlhOtQNh3oAGX51FDVztVBs1tcOohMu1gllhGMzLdviBgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790114493; c=relaxed/simple;
	bh=xzz/7RpLGNvy+d/LoMdg0MdbRE4abERBR8GhHaN1YXc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Bg8p6TJNlOfMXH7iu2l7ZeEzZ1i5jRHA1AFPjlrtTyO0RumnTkhNvH6Fspr43g6xhBmFDAAYJwKd6I+44NauwKESM/fz3oGQtzAhnz0rjBgdgGzsDhUUGYGw7rKXy4OYAuHT9So7kI5CXkuYrMeoIVys5FRyw6cd1funzcbfS24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dyRCLsDy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dyRCLsDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CC01F000FF;
	Tue, 22 Sep 2026 22:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790114485;
	bh=m67M8/VrlC8kuuUWywaLZOHOLyElKT7uuhfib8m9lDA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dyRCLsDyMtna1NQjp11z0SBhp5IcdlkiBS2osUxVB8ROD6JHDE06rGxetccaOCqxB
	 buWrD7DPbxVc3MyJTzvHg05RluDXWlNxotDd8rOukTduFoWyaahrGdn5HYig2fIiFC
	 rAJSu4RfYWQVZ7rT1IPTAqo8y7LnaBanC11QTnKNcxXVgdyrrUnp3Syj/7+LnKy4d5
	 6L/pViQ9DqsdT9ZVm5sUxKizb16VBmQTKPWOIPfn0nSUD3/Jn6wqtc4dwXDGkI0x5U
	 8p2tD3UAnmaaBOuG93lPlhb5cQJ6Myl5vs9uSDkUuUh1hynn1PgB0X49QwIG+QzKni
	 V0vVc7nnOqNwQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] KVM: arm64: vgic: Stop the VM when disabling LPIs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260922214212.3327146-4-maz@kernel.org>
References: <20260922214212.3327146-1-maz@kernel.org>
 <20260922214212.3327146-4-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 22:01:25 +0000
Message-Id: <20260922220125.91CC01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] kvm: arm64: vgic: race in vcpu->arch.pause unpause due to missing =
VM lock
- [High] kvm: arm64: vgic: stale LR state during vgic_flush_pending_lpis()
--

commit 81f0f5ee375a1e011fabe86a70b81c8175c5fd88
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: vgic: Stop the VM when disabling LPIs

Disabling LPIs modifies the AP list of the affected CPU, which could be
running. This commit aims to safely manipulate the state by pausing all
vCPUs so they are in a quiescent state when disabling LPIs.

> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgi=
c-mmio-v3.c
> index 5913a20d83019..adefc42964732 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -303,9 +303,19 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu=
 *vcpu,
>  		if (ctlr !=3D GICR_CTLR_ENABLE_LPIS)
>  			return;
> =20
> +		/*
> +		 * Yes, disabling LPIs is painful, since it can be done from
> +		 * a *remote* vcpu! So let's not take any chance, and make
> +		 * sure that everybody has written their LRs back to the irq
> +		 * structures, and release any reference they would have.
> +		 *
> +		 * If it hurts, don't do it.
> +		 */
> +		kvm_arm_halt_guest(vcpu->kvm);
>  		vgic_flush_pending_lpis(vcpu);

[Severity: High]
Does the asynchronous halt ensure the target vCPU has fully synchronized its
hardware state back to software state before proceeding to flush?

kvm_arm_halt_guest() uses kvm_make_all_cpus_request(kvm, KVM_REQ_SLEEP).
If the target vCPU has exited guest mode and set vcpu->mode =3D OUTSIDE_GUE=
ST_MODE
but has not yet executed kvm_vgic_sync_hwstate() to fold its LRs,
kvm_make_all_cpus_request() will skip waiting for it:

virt/kvm/kvm_main.c:kvm_request_needs_ipi() {
    ...
	if (req & KVM_REQUEST_WAIT)
		return mode !=3D OUTSIDE_GUEST_MODE;
    ...
}

If the wait is skipped, could the flushing vCPU clear the ap_list in
vgic_flush_pending_lpis() just before the target vCPU folds its LRs?=20
Would this incorrectly resurrect the deleted LPI state and cause ghost
interrupts?

>  		vgic_its_invalidate_all_caches(vcpu->kvm);
>  		atomic_set_release(&vgic_cpu->ctlr, 0);
> +		kvm_arm_resume_guest(vcpu->kvm);

[Severity: High]
Does this block need to hold a VM-wide lock?

Since vgic_mmio_write_v3r_ctlr() only synchronizes locally using an atomic
cmpxchg on the target vgic_cpu->ctlr, multiple vCPUs could concurrently
write to different VGIC redistributors to disable their LPIs.

If this happens, multiple vCPUs will concurrently call kvm_arm_halt_guest()
and race to set vcpu->arch.pause =3D true:

arch/arm64/kvm/arm.c:kvm_arm_halt_guest() {
    ...
	kvm_for_each_vcpu(i, vcpu, kvm)
		vcpu->arch.pause =3D true;
    ...
}

The first vCPU to finish flushing will call kvm_arm_resume_guest() which
unconditionally clears the pause boolean:

arch/arm64/kvm/arm.c:kvm_arm_resume_guest() {
    ...
	kvm_for_each_vcpu(i, vcpu, kvm) {
		vcpu->arch.pause =3D false;
		__kvm_vcpu_wake_up(vcpu);
	}
    ...
}

Could this unpause the VM prematurely while another vCPU is still tearing
down VGIC state in vgic_flush_pending_lpis(), allowing guests to run and
modify their VGIC state concurrently?

>  	} else {
>  		ctlr =3D atomic_cmpxchg_acquire(&vgic_cpu->ctlr, 0,
>  					      GICR_CTLR_ENABLE_LPIS);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922214212.3327=
146-1-maz@kernel.org?part=3D3
