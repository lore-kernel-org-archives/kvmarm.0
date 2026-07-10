Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F3137CD3A
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 22:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723039; cv=none; b=XjOKafXVvJOQoyyJpsL5JOw98mj1pWtrIAVB0W+5RLpTgGAllzwDkZ2QrIq5wP+0xf5Ag1huDUK29yhF7FmSzmfZqlbaMYSxn+SYXY3FGWqVOoBwiVpLxnEtCIV6bZlPQSMxEv6RsCTlK0HPtejlRsTUB/VnK7NiOLkzIHZcJYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723039; c=relaxed/simple;
	bh=jsAccQQAHCfDuWmJZaDxbg1DbjhVBnAConRKpZQGpZg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QgLgymQ7hykKZvsaVNwYqSIOKPR2cpVTbwDIGzcPN+mgRQZ541MIL0qBfmlINtWnSh3k69sdTYkL9L9EE0vdB8kNlX1cnd0ZjcrxSNRsMWC75fm7utPBbgLQHKDuRji0SPFJ1c2WoEO4g2M+9N8IsjwWLP4JYGWtqwWov/CFM80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h4Y9iM/j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h4Y9iM/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C85B1F000E9;
	Fri, 10 Jul 2026 22:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783723038;
	bh=ozgC1ZRn2YYImhCsuzRNV1wQ6E7lv1uRQnOwlTsCBy4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h4Y9iM/jZYC/dSrCxq8UHt09Mqfh2oj7dV9sd94bOWtiseKqcLJtVcI3DTzqUEnGS
	 igWmRseGhrpJ5KBa2NwV4l+yMvgUVVW7bSUv1iLpKyAUnIewwZl3yZOkPOzccmsylm
	 7CxEmeZ185Vv7nbp/6QQJrleKukgWIDj4DU+97M6iMCsboXQFNqtW4vE1lmNvozKM5
	 XhImPsNdg17EXRolLUmxf7tGTgtjkwiB3iUKchvcD4larBBG/fLYUA4zu8RcfNfGFR
	 aG3jsznzmKSvfbFNAeY+NBj+S/9O2STYr1gPG3e724N/veRqBB/p+u9z/1rW/K4lnD
	 mka370ZEEnQwQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] arm64: errata: Mitigate AmpereOne erratum AC03_CPU_57
 and AC04_CPU_29
Reply-To: sashiko-reviews@lists.linux.dev
To: "D Scott Phillips" <scott@os.amperecomputing.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260710222128.416581-1-scott@os.amperecomputing.com>
References: <20260710222128.416581-1-scott@os.amperecomputing.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 22:37:17 +0000
Message-Id: <20260710223718.2C85B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The AmpereOne erratum workaround unconditionally skips deactivatin=
g physical interrupts for all nested VMs, causing a physical interrupt stat=
e leak.

Pre-existing issues:
- [Critical] The AmpereOne erratum workaround fails to mitigate a Guest-to-=
Host Denial of Service vector for non-nested (L1) guests.
- [High] Dropping `irq->irq_lock` between computing the LR snapshot and fol=
ding it creates a race condition that loses concurrent virtual interrupts.
--

--- Patch [1]: [PATCH] arm64: errata: Mitigate AmpereOne erratum AC03_CPU_5=
7 and AC04_CPU_29 ---
commit d1d195cfc998f3f14be1b81eaa8484fcb7eb08f8
Author: D Scott Phillips <scott@os.amperecomputing.com>

arm64: errata: Mitigate AmpereOne erratum AC03_CPU_57 and AC04_CPU_29

This commit introduces a workaround for an AmpereOne CPU erratum where
deactivating a non-active physical interrupt that is the highest priority
pending interrupt hangs the CPU. The mitigation avoids physical deactivatio=
ns
when KVM handles a nested VM context.

Link: https://lore.kernel.org/linux-arm-kernel/87ecjybz30.wl-maz@kernel.org/
Link: https://amperecomputing.com/products/developer-errata

[ ... ]

> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 9e841e7afd4a7..8f1d10872360c 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -275,7 +275,9 @@ void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 va=
l)
>  		lr =3D vgic_v3_compute_lr(vcpu, irq) & ~ICH_LR_ACTIVE_BIT;
>  	}
> =20
> -	if (lr & ICH_LR_HW)
> +	if ((lr & ICH_LR_HW) &&
> +	    !(cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_57) &&
> +	      vgic_state_is_nested(vcpu)))

[Severity: Critical]
This is a pre-existing issue, but does the system remain vulnerable to the
erratum for L1 guests?

Because vgic_state_is_nested(vcpu) evaluates to false for an L1 guest, KVM
bypasses the workaround and still calls vgic_v3_deactivate_phys(). If an
unprivileged guest operating in GICv2 mode on a GICv3 host writes the INTID=
 of
a hardware-backed interrupt to the GICC_DIR MMIO register while it is inact=
ive,
can this directly trigger the host CPU hang?

[Severity: High]
Does unconditionally bypassing the physical deactivation for nested VMs cau=
se
a physical interrupt state leak?

When an L2 guest legitimately deactivates an active hardware-backed
interrupt and it traps to KVM, vgic_v3_deactivate() is called. Since
vgic_state_is_nested(vcpu) evaluates to true, it successfully updates the
virtual state via vgic_v3_fold_lr() but unconditionally skips calling
vgic_v3_deactivate_phys().

Could this leave hardware-backed interrupts, such as the physical timer,
permanently active in the physical GIC distributor and block future timer
interrupts?

>  		vgic_v3_deactivate_phys(FIELD_GET(ICH_LR_PHYS_ID_MASK, lr));
> =20
>  	vgic_v3_fold_lr(vcpu, lr);

[Severity: High]
This isn't a bug introduced by this patch, but does dropping irq->irq_lock
between computing the LR snapshot and folding it create a race condition th=
at
loses concurrent virtual interrupts?

vgic_v3_deactivate() takes the lock, computes the snapshot, and then the
scoped_guard ends:

scoped_guard(raw_spinlock, &irq->irq_lock) {
    ...
    lr =3D vgic_v3_compute_lr(vcpu, irq) & ~ICH_LR_ACTIVE_BIT;
}

If a concurrent device injects an interrupt here via vgic_inject_irq() and
sets irq->pending_latch =3D true, won't the subsequent call to
vgic_v3_fold_lr(vcpu, lr) re-acquire the lock and evaluate the stale snapsh=
ot?

vgic_v3_fold_lr() would see !(val & ICH_LR_STATE) is true and execute:

if (irq->config =3D=3D VGIC_CONFIG_LEVEL && !(val & ICH_LR_STATE))
    irq->pending_latch =3D false;

Could this wipe out the newly arrived interrupt and cause guest devices to
stall?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710222128.4165=
81-1-scott@os.amperecomputing.com?part=3D1
