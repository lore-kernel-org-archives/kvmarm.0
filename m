Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C285527587D
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 23:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784073022; cv=none; b=qlWaiZVK9W7KW7o/8MhDS7drDqO22t9q1l1UQaWQSS/Ybk9HMfM282T9gF4nKNwd67bRFuGeHA1cAxBWavtBEBb8/G7DcqVED/28TFtIOMjp3njDanMQnuDrXtukWyUKRWnomUcvhRiAFCPug9eY2T4+tSS26vq2HQRvMpfufU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784073022; c=relaxed/simple;
	bh=BP8XtrmKbhXPwLmB59MjQ26J3MuQf8QXDFm1DhgRPKs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XN61Kf3ABiK9njeTdP6senm8I3Gws31OTand10eJ0BUmgk+Th+VvB6BsQSW6D87wSNoIfhPqoU9QTC3C4dmjHN556n+1w51mxK7vKiCmnA7xhK2jHz9bBXNP1lOZAjwLP6w4QB338SUqo/V+V5sQWjwHvM+zC0uW7gACgQUQ3P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dHZtj/zp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHZtj/zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4151F000E9;
	Tue, 14 Jul 2026 23:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784073020;
	bh=Xe1sowKFNzfz1bY6XXjXz6HUgbPL2qtb1rtC3896b+E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dHZtj/zpAVVRoFmzzFz49Ntddw6l7OkDJJxds8fMMr+Pp/T5j2OPaBOHzpwQmgtQ5
	 vrPkgIg+Yp6YebqwnfKQBTW4l+7m3sbJ4Q2CH/WERRfEP+YS4D5AVa+nqJQ5MkisOX
	 HfmUbYxdtXBr+3XpRMJi4KI8AaXM3VdzokqiRBZ1M2DVav5fOKECRJ7ur9OlYvSwf1
	 fDBWcznwKmIYgKOBHXbq2LPoqB3wSsCX69BxU8X5aei9eXSZKd1gVVApydeQ+PKZ1z
	 lg8xz/O9pRAI74FrlBsDzwV7QQA4PcD//cg37Qkm7h9V0fOKPxLLoqcU8ubILc9qDK
	 2wRpV+j8tSA5w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] KVM: arm64: vgic: Avoid double-deactivate of IRQs in
 the nested context.
Reply-To: sashiko-reviews@lists.linux.dev
To: "D Scott Phillips" <scott@os.amperecomputing.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260714231158.496808-1-scott@os.amperecomputing.com>
References: <20260714231158.496808-1-scott@os.amperecomputing.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 23:50:19 +0000
Message-Id: <20260714235020.2F4151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The patch skips `vgic_v3_deactivate_phys()` unconditionally when `=
vgic_state_is_nested(vcpu)` is true, which leaves physical interrupts perma=
nently active if the deactivation was triggered via a sysreg trap rather th=
an an LR hardware sync.

Pre-existing issues:
- [High] KVM natively processes trapped L2 `SYS_ICC_DIR_EL1` accesses using=
 L1's virtual interrupt state, resulting in corruption of L1's VGIC state.
- [High] A malicious nested guest hypervisor (L1) can trigger a host `WARN_=
ONCE` by configuring mismatched virtual IMO and FMO bits.
--

--- Patch [1]: [PATCH v2] KVM: arm64: vgic: Avoid double-deactivate of IRQs=
 in the nested context. ---
commit 4b2bb201a4176459b35d819c32daab08bb5354bf
Author: D Scott Phillips <scott@os.amperecomputing.com>

KVM: arm64: vgic: Avoid double-deactivate of IRQs in the nested context.

In the nested state, the physical interrupt has already been deactivated
through the HW bit in the LR. The extra deactivation would be harmless but
can hit an errata case on AmpereOne, so avoid it here.

Link: https://lore.kernel.org/linux-arm-kernel/20260710222128.416581-1-scot=
t@os.amperecomputing.com/

> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 9e841e7afd4a7..7aa417440f6a2 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -275,7 +275,13 @@ void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 v=
al)
>  		lr =3D vgic_v3_compute_lr(vcpu, irq) & ~ICH_LR_ACTIVE_BIT;
>  	}
> =20
> -	if (lr & ICH_LR_HW)
> +	/*
> +	 * In the nested state, the irq has already been deactivated via the HW
> +	 * bit in the LR. Deactivating again would be harmless except AmpereOne
> +	 * errata AC03_CPU_57, AC04_CPU_29 could cause irq delivery to break if
> +	 * the deactivation hits the highest priority pending irq.
> +	 */
> +	if ((lr & ICH_LR_HW) && !vgic_state_is_nested(vcpu))
>  		vgic_v3_deactivate_phys(FIELD_GET(ICH_LR_PHYS_ID_MASK, lr));

[Severity: High]
Does skipping the physical deactivation here leave the physical interrupt
permanently active if the deactivation was triggered via a sysreg trap
rather than an LR hardware sync?

If an untrusted L2 nested guest executes SYS_ICC_DIR_EL1 for a hardware-bac=
ked
virtual interrupt, and this traps to L0 (for instance, due to an L0-level
erratum workaround like vgic_v3_broken_seis() that sets TDIR=3D1), L0's nat=
ive
sysreg handler access_gic_dir() will call vgic_v3_deactivate().

Since the access was trapped, the hardware did not execute it, so the physi=
cal
interrupt was never deactivated. However, vgic_state_is_nested(vcpu) evalua=
tes
to true, causing vgic_v3_deactivate_phys() to be unconditionally skipped.

Could this prevent future interrupts of equal or lower priority from being
delivered, potentially hanging the associated physical device or host timer?


[Severity: High]
This isn't a bug introduced by this patch, but does KVM natively process
trapped L2 SYS_ICC_DIR_EL1 accesses using L1's virtual interrupt state,
resulting in corruption of L1's VGIC state?

If L0 forces DIR to trap, but L1 did not set ICH_HCR_EL2.TDIR, L2's DIR acc=
ess
traps to L0. sysreg_emulate_nested() checks L1's TDIR and returns false:

arch/arm64/kvm/emulate-nested.c:sysreg_emulate_nested() {
    ...
    case CGT_ICH_HCR_TC_TDIR:
        if (!__forward_traps(vcpu, ICH_HCR_EL2, tc.mask))
            goto emul;
    ...
}

This causes KVM to fall back to native emulation via access_gic_dir(), which
calls vgic_v3_deactivate() using L2's virtual INTID:

arch/arm64/kvm/sys_regs.c:access_gic_dir() {
    ...
    vgic_v3_deactivate(vcpu, p->regval);
    ...
}

Since KVM mistakenly looks up this INTID in vcpu->arch.vgic_cpu (representi=
ng
L1's virtual interrupt state), could a malicious L2 guest arbitrarily execu=
te
SYS_ICC_DIR_EL1 to modify the active state of L1's virtual interrupts and
disrupt the L1 hypervisor?


[Severity: High]
This is a pre-existing issue, but can a malicious nested guest hypervisor (=
L1)
trigger a host kernel panic by configuring mismatched virtual IMO and FMO
bits?

When vgic_state_is_nested() is called, it evaluates the guest's virtual
HCR_EL2 and triggers a WARN_ONCE if HCR_IMO is set without HCR_FMO (or vice
versa):

arch/arm64/kvm/vgic/vgic-v3-nested.c:vgic_state_is_nested() {
    ...
    if (is_nested_ctxt(vcpu)) {
        xmo =3D __vcpu_sys_reg(vcpu, HCR_EL2) & (HCR_IMO | HCR_FMO);
        WARN_ONCE(xmo && xmo !=3D (HCR_IMO | HCR_FMO),
                  "Separate virtual IRQ/FIQ settings not supported\n");
    ...
}

A malicious L1 hypervisor can trivially reach this by writing to its virtual
HCR_EL2 sysreg and executing an ERET to L2. When KVM L0 processes any exit
from L2, it calls kvm_vgic_sync_hwstate(), which evaluates
vgic_state_is_nested().

If panic_on_warn is enabled, would this allow an unprivileged guest to crash
the host?

> =20
>  	vgic_v3_fold_lr(vcpu, lr);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714231158.4968=
08-1-scott@os.amperecomputing.com?part=3D1
