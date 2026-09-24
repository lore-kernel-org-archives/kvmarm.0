Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C5D41D123;
	Thu, 24 Sep 2026 17:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790272640; cv=none; b=oWGFezvOunKpw0b+shfydjaVLaUPFXjw23YfA8F/fynEvk2IUNDJBuZLudmUucq4lghEzUjcDAAELMqVEh7ZevVRLFtkLex4/+5tIdx/Wptz/94BKqw9DBWHPTpQmR3T1GQd5O8CgAoUY2qQv50W/eddyUXxZ+gaMYuxTwbQb6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790272640; c=relaxed/simple;
	bh=3VAlqzQuzZWfBgiUeb7nQGDzHp/BIaYrBLhN0sKWBq8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cB1WM9yNT5P/w9+8/vK+Y/idwWRHt72q8/YE7Q3V/O0cIKI2NCO/wv+E3iJvqwc19fMdS4HPrqmtG4IEF7ny4G3NRzGTT7JDorgX4+DvYNQnns8WdDDweA9B0Hiv0aRz2KVrNIbqZsNewPShZhzFJVHFPp+fga4pVdrkYDa18CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IoJAdnbX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IoJAdnbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8531F000FF;
	Thu, 24 Sep 2026 17:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790272639;
	bh=UULohrnjbNERGWV5ZJQglQCTj277GJNSDJh6ouL0i+U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IoJAdnbXdd+WSS4ahJfK9ZDYyNmtFmRQoVsWaLuSbqCQNt0zP7JvyGBYzKNyVFzPl
	 TUbVo6TB8xz1g7KnYSjsRx9E0jY0cKqVoKLvIhw7txquq/CnDfB0mwmMOimqfg4sHk
	 G6NHzROIpUTDiEX4OnHOPEn/pPM+bbLV/XAV1rBg7imrQF5b+CA5I371AUEnFlsmZ+
	 IVuX+Nr/XFGlAxUSvsJxtwipiH/SlaioTzFm2LBd67IA38PZbpYaljcpG0Q/Pai+AJ
	 vyPjTgOsBgew1ggzeUbN+NL+vaVlZp0GAjDcENQXNZ8C9m968gkpPpMsIFsSCLGmnO
	 qgeQ2DfpcqzKg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 16/22] KVM: arm64: Apply dynamic guest counter
 reservations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: linux-perf-users@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260924172928.2110956-17-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-17-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:57:18 +0000
Message-Id: <20260924175718.AB8531F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kvm: arm64: guest PMU overflow state lost on partition without FEA=
T_FGT
--

commit 59a912c6296a832c23a72990ddffa47591b8277e
Author: Colton Lewis <coltonlewis@google.com>

KVM: arm64: Apply dynamic guest counter reservations

Reserve and release guest PMU counters dynamically during vCPU load and
put rather than statically at VM creation.

> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
> index a22c9258c2452..31d5afc44f36e 100644
> --- a/arch/arm64/kvm/pmu-direct.c
> +++ b/arch/arm64/kvm/pmu-direct.c
[ ... ]
> @@ -269,7 +341,9 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
> =20
>  	preempt_disable();
> =20
> +	pmu =3D vcpu->kvm->arch.arm_pmu;
>  	guest_counters =3D kvm_vcpu_pmu_guest_counter_mask(vcpu);
> +	kvm_pmu_set_guest_counters(pmu, guest_counters);
>  	kvm_pmu_apply_event_filter(vcpu);
> =20
>  	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {

[Severity: High]
Can this result in silently dropped guest overflow interrupts when partitio=
ning
is enabled on hardware without fine-grained traps?

Further down in kvm_pmu_load(), the physical hardware overflow register is
cleared unconditionally:

	/* Clear the hardware overflow flags so there is no chance of
	 * creating spurious interrupts. The hardware here is never
	 * the canonical version anyway.
	 */
	write_sysreg(mask, pmovsclr_el0);

	val =3D __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);

However, there is no corresponding write to pmovsset_el0 to restore the
guest's accumulated overflow state from
vcpu->arch.ctxt.sys_regs[PMOVSSET_EL0] before entering the guest.=20

When trap bits are cleared to allow untrapped guest register accesses, and
fine-grained traps are not available to intercept pmovsset_el0, the guest's
interrupt handler will read this cleared hardware register directly. It will
observe 0 instead of the actual overflow state, causing the interrupt to be
dropped without processing.

Should the guest's saved overflow bits be restored here so the untrapped re=
ads
observe the correct state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D16
