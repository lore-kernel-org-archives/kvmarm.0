Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F012484899
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 11:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789990882; cv=none; b=FlFwY8dO1ma5Ic5nk24lFacKgAi8CRqN23ZXBOakFge6ALPYtlVlw6XIZdPlSi3whuG6fd0zI7J4YTCrGw53obchXKEi5daD/2+FH1XbFFEKGJq4golxAaC/KZx5Bf9yEKLt9zW6eBq7jLeukdz5gE/M6J06depj8Xgy+neaUU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789990882; c=relaxed/simple;
	bh=HQ/26BnZxm9SlPn2dWLSQS0waQAvNtEzClwLnCFc+Tw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=G/rmluHCpmpYThwFkL4VO4f0Jmw9W2Q+fKef2FzgajmSSe+RIsoojkFfjUUI2+hcSd7U1iBcGDMmsOj+nX3no1nIS+st/iValMamA03h6X3o58pqWZqsn8WpPeF2OJ6bzV83Cm614IJk7htZP8w6DhMOBQ+bLRvqBXDOLRX9nPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EcV0GbV1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EcV0GbV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF0C1F000FF;
	Mon, 21 Sep 2026 11:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789990880;
	bh=MT8OtxCpB/CByiLJcwzqolE8dQae/HtnvuAIlT7Hcas=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EcV0GbV1J0/LUiChjNxARw9OiZyXNaiht1zKtTyIhjCTRuG8K3QOqDpCuq8R0GGrb
	 TVjTc5Xv/7qmmkecXtWULG73FvesrfiiLgXG2Kqjtpd+T3q//XL37FTWR9isvS8c/N
	 zQM+8DAshdQ+xCZoMiY4M1fQOpzkzcwIPZ43LWbN4zkFWYyOIAulusZx+gT1PQmyw2
	 E2pRv3rwCw5JtSYxfLwZUnFq/YdgGfpBD27vcRgHUihPZhw0Q+WnTo2UwXtQGwldrw
	 n4c+i789MoGerAT8kWANlqhg7WDeMz4kZI5nrFM58PJpek5XCdSAD0YeszGFWkKcLF
	 QHmJ0PVZgPuxg==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH] KVM: arm64: Restrict CNTP_CVAL/CNTHP_CVAL
 save/reload when ptimer is used
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhou Wang" <wangzhou1@hisilicon.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260921111840.3000905-1-wangzhou1@hisilicon.com>
References: <20260921111840.3000905-1-wangzhou1@hisilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 11:41:20 +0000
Message-Id: <20260921114120.5EF0C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] kvm: arm64: ptimer_used flag breaks physical timer after live migr=
ation
- [High] kvm: arm64: hardcoded cnthctl_el2 write breaks timer traps on NV2p1
--

commit a19fd66b3c0094c0f95419be8e827cd25f55a439
Author: Zhou Wang <wangzhou1@hisilicon.com>

KVM: arm64: Restrict CNTP_CVAL/CNTHP_CVAL save/reload when ptimer is used

This patch introduces a lazy detection mechanism to determine if a
non-nested VHE guest actually uses the physical timer, avoiding useless
timer state saves and reloads. It initially traps CNTP_CTL_EL0 writes
and clears the trap on the first guest enable, granting direct access.

> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 6ac3321f4c575..fcbd1e133ad0d 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
[ ... ]
> @@ -1054,6 +1058,7 @@ void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
>  		offs->vm_offset =3D &vcpu->kvm->arch.timer_data.poffset;
>  	}
> =20
> +	timer->ptimer_used =3D false;
>  	if (timer->enabled) {
>  		for (int i =3D 0; i < nr_timers(vcpu); i++)
>  			kvm_timer_update_irq(vcpu, false,
[ ... ]
> @@ -1270,6 +1275,16 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *v=
cpu,
>  		preempt_disable();
>  		timer_save_state(timer);
>  		kvm_arm_timer_write(vcpu, timer, treg, val);
> +
> +		/* Lazy ptimer detection: catch first CNTP_CTL enable */
> +		if (has_cntpoff() && !vcpu_has_nv(vcpu) &&
> +		    tmr =3D=3D TIMER_PTIMER && treg =3D=3D TIMER_REG_CTL &&
> +		    (val & ARCH_TIMER_CTRL_ENABLE) &&
> +		    !vcpu_timer(vcpu)->ptimer_used) {
> +			vcpu_timer(vcpu)->ptimer_used =3D true;

[Severity: High]
Could this cause the physical timer to break after a live migration?

When a guest enables the physical timer, kvm_arm_timer_write_sysreg()
sets ptimer_used to true. However, during a live migration, userspace
restores state via KVM_SET_ONE_REG, which bypasses this sysreg write
path.

Because kvm_timer_vcpu_reset() initializes ptimer_used to false, it
appears the destination host will permanently leave ptimer_used as
false. Consequently, __activate_traps() in
arch/arm64/kvm/hyp/vhe/switch.c will skip writing the un-offset guest
CVAL to the hardware SYS_CNTP_CVAL. This leaves the hardware retaining
the offset-shifted value, preventing the interrupt from firing at the
correct guest time.

> +			sysreg_clear_set(cnthctl_el2, 0,
> +					 CNTHCTL_EL1PCEN << 10);

[Severity: High]
Does this unconditionally write to the wrong register on hardware with
NV2p1?

If a host is equipped with FEAT_NV2p1 and FEAT_ECV, timer_set_traps() in
arch/arm64/kvm/arch_timer.c correctly checks for ARM64_HAS_NV2P1 and
uses cntkctl_el1 instead of cnthctl_el2 for EL1 trap configuration.

This unconditional write to cnthctl_el2 seems to ignore the NV2p1
hardware requirement. This might fail to clear the trap in hardware
and could potentially corrupt unrelated timer control state in
CNTHCTL_EL2.

> +		}
>  		timer_restore_state(timer);
>  		preempt_enable();
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260921111840.3000=
905-1-wangzhou1@hisilicon.com?part=3D1
