Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309383EBF04;
	Thu, 13 Aug 2026 22:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786659876; cv=none; b=AxY3LEWSFEiTFM8Lvwzk6MPSzCQ0CXAcuJ0gcP6plXpLEfxD4gvoB7KpdVWJ86OFpNnNukCBgn74F4LH447CNVSH7dVSLwVvd5dMt2Na5GhIif4XFpt4U4jD+za4lkbSwkQdjsUgUrVcIeQtP2ovYyxI4AW8M8lKRByfpn2LSHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786659876; c=relaxed/simple;
	bh=v1x3C/+kg7Wz4S0Emcr0WQBe6ClLjp19NRub9nlx3rg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bfv5kWZWYp5bSnnwZF9MFPN4c3FOnPt229HXYsAFU1lDf+qYIqUHm0z5lvV4bB/LbuYu4H55JgyHk5oUPp2c2w6ed6mb7vDESfwYRtlPMnQlRSedYisPzltOgovNz1963LwGE0OsM9cIIUICBbq7AWRSbEWaVwJSTEg5x1Ete6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BjJzET22; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BjJzET22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2426E1F000E9;
	Thu, 13 Aug 2026 22:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786659874;
	bh=58KI8Yhze0SAPukjZ6oRBx+ZLCrw+I0NvuuQzpyhMyY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BjJzET22B6w07LMKzU89aLGi0aQ6NqPar8eNAfds6mQ9fP9VIUf8bbalVy24B9/K+
	 WCWy0g9u2sRt/Snr7VTFQRBxMjVUWm9SbQtWXx5XO4WXJhrbasAbYqD76kgDgwNapx
	 Ud5JSBPmtNVDgij8Icg2n9RG8uMT11vEwYYKmmJM2XZsW0SEtT7lQQS6q9ZG1hjBFN
	 bw65pTeTihUYR8Mf4UB4FlmTeL+cRqci7m54tZbvnf2eO9SkpYXqYrrpSo7zTqKsB+
	 D+x/v+e2auO+oYnJWnG2f/hmmpzfzXqXbSNfPbHyMwuTa0rOuS43TZ8m83tXKfTiBf
	 0sWdi6ela/d+w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 29/39] KVM: arm64: gic-v5: Enlighten arch timer for
 GICv5
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260317113949.2548118-30-sascha.bischoff@arm.com>
References: <20260317113949.2548118-30-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 13 Aug 2026 22:24:33 +0000
Message-Id: <20260813222434.2426E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Guest-driven 100% host CPU soft lockup due to unconditional timer =
polling bypassing VGIC mask state on WFI.
- [High] `KVM_SET_DEVICE_ATTR` for timer IRQs unconditionally fails for GIC=
v5 due to a mismatch between raw and internal bit-packed INTIDs, breaking V=
M initialization.
--

--- Patch [29]: [PATCH v6 29/39] KVM: arm64: gic-v5: Enlighten arch timer f=
or GICv5 ---
commit f6d424766abc019a2ae7837f0e736e6af4c5961c
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Enlighten arch timer for GICv5

This commit updates the KVM architectural timer to support GICv5 features,
including direct virtual interrupt (DVI) injection for mapped timers and
mandatory architected PPI assignments. It modifies how interrupts are queue=
d,
masked, and validated to align with GICv5 requirements.

> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 53312b88c342d..4575c36cae537 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c

[ ... ]

> @@ -396,7 +406,11 @@ static bool kvm_timer_should_fire(struct arch_timer_=
context *timer_ctx)
> =20
>  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
>  {
> -	return vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) =3D=3D 0;
> +	struct arch_timer_context *vtimer =3D vcpu_vtimer(vcpu);
> +	struct arch_timer_context *ptimer =3D vcpu_ptimer(vcpu);
> +
> +	return kvm_timer_should_fire(vtimer) || kvm_timer_should_fire(ptimer) ||
> +	       (vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) =3D=3D 0);
>  }

[Severity: High]
Can this cause a host soft lockup if the guest executes a WFI?

If a guest masks the timer interrupt in the VGIC but leaves it enabled in t=
he
timer's control register, kvm_timer_should_fire() will still return true si=
nce
it only checks the timer's internal state. When the guest then executes WFI,
kvm_vcpu_block() will see a pending timer via kvm_cpu_has_pending_timer() a=
nd
refuse to block, immediately resuming the guest. The guest will then re-exe=
cute
WFI, resulting in an infinite tight loop.

[ ... ]

> @@ -1634,10 +1700,16 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu,=
 struct kvm_device_attr *attr)
>  		idx =3D TIMER_HPTIMER;
>  		break;
>  	default:
> -		ret =3D -ENXIO;
> -		goto out;
> +		return -ENXIO;
>  	}
> =20
> +	/*
> +	 * The PPIs for the Arch Timers are architecturally defined for
> +	 * GICv5. Reject anything that changes them from the specified value.
> +	 */
> +	if (vgic_is_v5(vcpu->kvm) && vcpu->kvm->arch.timer_data.ppi[idx] !=3D i=
rq)
> +		return -EINVAL;
> +

[Severity: High]
Does this unconditionally fail for GICv5 guests?

Userspace passes a standard raw PPI ID (e.g., 27) for the irq value.
However, for GICv5, kvm_timer_init_vm() initializes
vcpu->kvm->arch.timer_data.ppi[idx] using get_vgic_ppi(), which packs
GICV5_HWIRQ_TYPE_PPI into the upper bits of the integer. Comparing this
bit-packed internal representation directly against the raw userspace
irq value will always result in a mismatch and return -EINVAL, breaking
VM initialization.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260317113949.2548=
118-1-sascha.bischoff@arm.com?part=3D29
