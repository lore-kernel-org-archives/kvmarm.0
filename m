Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794838001;
	b=aQWDxBWy0+SiAZk1DFaJR0yf8c6kNsswmPkNq4GrfSUwIlBpQ8wWqRC2gUWuwik61G+g
	 41OEYPp4/w4s42yCjhzZShlu7AjpuEhNtPm6yVsFzMP8C/BrJILLtGSZoCL4UWtImO5ia
	 NhiwsuKCYn43tZVlDTu0DNV69K7vcfU95RgQMU+mFjI2TH38huuYIFp3BwSGM9UYnhZ5/
	 SaaN+6xyY+nwduD1sZLSc2q+8pH1JxEtGbPw/dwcAamHlJdr3VXCvPuj7tpVfnM5ClVF3
	 Cv9AR8UdmTq8w8VT8mkTn+vi8RxZ9hezx10/7ZYsshEBZRPcEnbq3FCgsWH32znwHXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794838001;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=m/HyeUXYh0w1dEeZG21NLs2HymAP5ME2rXx+zB9OAeI=;
	b=IEa1h8wKPDvg5/t4nQg30Oj+gep/9+llV7Ut7VZ2+/kDDpm1ep07XRqWxPvqwsebnz+b
	 cS73TtVX6Nlls+NrNPIUUnFUPCyY0Kt1rcmDC+APOND68AUwFt60CvyVj5HJ24TCB+ei1
	 G+9f6P3ZM/Ku1bLRZVcmYpIMcrnQmq4lZnH8PFGJHoPOyjf47nIWeUczkY/8pctmCXPcb
	 5MSAiV8gsoOdIj7mizdjDo++JbifS5y5xCRtqkWK2gZEuJSA1RmWdHi2HU3grznZpdjE+
	 zLL2Ai4eJriNOQj7jZ5vRZ4j75KZVc/wblWfYeNagOFKDHmmkr7dC94MPQzrgzyIBmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ic12xE3t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B16606A323
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 14:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ic12xE3t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB98F1F000C5;
	Mon, 16 Nov 2026 14:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794838001;
	bh=m/HyeUXYh0w1dEeZG21NLs2HymAP5ME2rXx+zB9OAeI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ic12xE3t6kX4KEeWCcGa7lykb6ikFCisffgB6qawdJ/VETPOKoS6C7ZXZHPhrO8uF
	 URdv+BN84wygp6x3J9bL7873sjIacpdQ3TNagwN0/Zj7mRnZDq1xNkqfWZYZRvzG43
	 +BRA9arBtyYLeXIDnV5g2g+Ox/zWeXMxYUBdmdHGLrSA1+gCuGIJo5+HXXPx88fiEn
	 A0p2VWg1OYQ3wihtP/KZ6Zx6L5lt3FdAywHQM28tnvRiKlkPWsa6UZjDCic6s1oc0P
	 vKLB7NUuZmsomp/Qfi/l7chEREZhE5orFQPo1AKienVwpDgVgMLUhGkcKGDyQKgKo1
	 4HWx3qCWNpkCA==
Message-ID: <sashiko-outbox-217134@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: nv: Fix NULL dereference in
 kvm_inject_nested()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dan Carpenter" <dan@pereq.eu>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <avsH0lxpLIF2Ug64@stanley.mountain>
References: <avsH0lxpLIF2Ug64@stanley.mountain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 14:06:38 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] KVM: arm64: nv: unguarded kvm_pmu_nested_transition() in
  kvm_inject_nested()
--

commit 7702078604222808ef62a9f6855a5c6c2add9d59
Author: Dan Carpenter <dan@pereq.eu>

KVM: arm64: nv: Fix NULL dereference in kvm_inject_nested()

This commit guards the kvm_arch_vcpu_put() and kvm_arch_vcpu_load() calls
in kvm_inject_nested() with a check that the vCPU is currently loaded.

> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index 2bec816683614..22ca735a34f69 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2862,7 +2862,7 @@ static int kvm_inject_nested(struct kvm_vcpu *vcpu,=
 u64 esr_el2,
>  			     enum exception_type type)
>  {
>  	u64 pstate, mode;
> -	bool direct_inject;
> +	bool direct_inject, loaded;
> =20
>  	if (!vcpu_has_nv(vcpu)) {
>  		kvm_err("Unexpected call to %s for the non-nesting configuration\n",
> @@ -2891,6 +2891,7 @@ static int kvm_inject_nested(struct kvm_vcpu *vcpu,=
 u64 esr_el2,
>  	}
> =20
>  	preempt_disable();
> +	loaded =3D (vcpu->cpu !=3D -1);
> =20
>  	vcpu_set_flag(vcpu, IN_NESTED_EXCEPTION);
> =20
> @@ -2900,7 +2901,8 @@ static int kvm_inject_nested(struct kvm_vcpu *vcpu,=
 u64 esr_el2,
>  	 */
>  	__kvm_adjust_pc(vcpu);
> =20
> -	kvm_arch_vcpu_put(vcpu);
> +	if (loaded)
> +		kvm_arch_vcpu_put(vcpu);
> =20
>  	kvm_inject_el2_exception(vcpu, esr_el2, type);
> =20
> @@ -2915,7 +2917,8 @@ static int kvm_inject_nested(struct kvm_vcpu *vcpu,=
 u64 esr_el2,
>  	 */
>  	__kvm_adjust_pc(vcpu);
> =20
> -	kvm_arch_vcpu_load(vcpu, smp_processor_id());
> +	if (loaded)
> +		kvm_arch_vcpu_load(vcpu, smp_processor_id());
>  	vcpu_clear_flag(vcpu, IN_NESTED_EXCEPTION);
> =20
>  	preempt_enable();

[Severity: High]
Can kvm_pmu_nested_transition() at the end of kvm_inject_nested() still
run when the vCPU is not loaded?

Right below preempt_enable(), kvm_inject_nested() unconditionally calls
kvm_pmu_nested_transition():

arch/arm64/kvm/emulate-nested.c:kvm_inject_nested() {
    ...
	preempt_enable();

	if (kvm_vcpu_has_pmu(vcpu))
		kvm_pmu_nested_transition(vcpu);
}

When KVM_SET_VCPU_EVENTS reaches kvm_inject_nested() on an unloaded vCPU,
kvm_pmu_nested_transition() calls kvm_pmu_create_perf_event() and
kvm_vcpu_pmu_restore_guest().  If the vCPU was created with
KVM_ARM_VCPU_PMU_V3_STRICT before KVM_ARM_VCPU_PMU_V3_SET_PMU is called,
kvm_pmu_create_perf_event() -> kvm_map_pmu_event() dereferences a NULL
vcpu->kvm->arch.arm_pmu.  If called before KVM_ARM_VCPU_PMU_V3_INIT, it
can also queue an uninitialized vcpu->arch.pmu.overflow_work.

Even on an initialized PMU, running kvm_pmu_nested_transition() while
unloaded binds the new perf_event to current (which may be a VMM control
thread rather than the vCPU thread) and programs the physical CPU's PMU
EL0 filters via kvm_vcpu_pmu_restore_guest() without a matching
kvm_vcpu_pmu_restore_host() before returning to userspace.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/avsH0lxpLIF2Ug64@st=
anley.mountain?part=3D1
