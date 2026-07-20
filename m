Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889023AF643;
	Mon, 20 Jul 2026 05:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784526821; cv=none; b=eiYImsKnuyURjGyAAURrOzlontoS5wFDcD0PYOg8idQqJX21r6JhwkqmRmg+oiUUcxsRqP3scZv7CeHzKcSs/q/Mq2kA+pEyilmYn9tqIIdQwJAILDcrcXGG2kvCTfsxxEZhTL7WxRnot2df7eWc9mjGCVtSF+y8LWVSCW+RDLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784526821; c=relaxed/simple;
	bh=mvgM2NTubSW76ycs2uDyLvS4G5plMApRTmYGpHCtsJ0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qWBkBpifgfJdwGag4N1lYvy3/V1nos4GRlFsB8qa7N67c34mzxmsv2+Iph24s4Je4EDNqV3WXfA8NR+v044hLcJnw3TvloEIdFBs3sGyXu11nNbHZTPbiGXjrR2D110K8o6UyYU6C8URARipytRJD/3ECnuZGXs9bG4RsIsjPbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rpfd2wV8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rpfd2wV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149651F000E9;
	Mon, 20 Jul 2026 05:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784526804;
	bh=ODQTyfYeq150iikzNWLWVFlInu0bdz7W3QU8HxjSmKg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Rpfd2wV8trdkebHJAlZ7XbDxE0/xrbxemYEHXqsqv7re7qWYFQKueFeImcK4MAO8W
	 S4eaOnXVWG2+/6SYQC5atZaou8SlqjImHrSJLWc+dXi2pd8l5gGJ5E7SZSxLdgkrqd
	 xNVr9qU1y48jFPGvu68elYY3albvT6/e8sUv1P6btYl/psDKU7Vbt9GWQpSWSPbChe
	 qhj7s808G102x8vUwlUyzZgUZsktXNJCs7UYkueasbaekMQsRWqCtN1wyZFYFZ7cFm
	 iu4YqiZQEColD35ZjB8Nfsj+Hg9mCxMFsS6Fv44hICMnKRpn00bliknwQ5zQ7psIaW
	 2FVLZzqy1qNqQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 05/16] KVM: arm64: PMU: Keep implemented counter mask
 EL-independent
Reply-To: sashiko-reviews@lists.linux.dev
To: "Akihiko Odaki" <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260720-hybrid-v9-5-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
 <20260720-hybrid-v9-5-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 05:53:23 +0000
Message-Id: <20260720055324.149651F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] State loss of EL2-reserved PMU counters during live migration.
--

--- Patch [5]: [PATCH v9 05/16] KVM: arm64: PMU: Keep implemented counter m=
ask EL-independent ---
commit 0e1ed9d5217011f901071c9f1da4dcee65204dd7
Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

KVM: arm64: PMU: Keep implemented counter mask EL-independent
   =20
This commit changes kvm_pmu_implemented_counter_mask() to build the
implemented counter mask from nr_pmu_counters instead of PMCR_EL0.N. This
prevents EL2 counter state from being lost during PMU reloads when the
saved context is outside EL2.

> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index b4b877f31097f..5281d37634a06 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -317,12 +317,12 @@ u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu=
 *vcpu)
> =20
>  u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
>  {
> -	u64 val =3D FIELD_GET(ARMV8_PMU_PMCR_N, kvm_vcpu_read_pmcr(vcpu));
> +	u64 n =3D vcpu->kvm->arch.nr_pmu_counters;
> =20
> -	if (val =3D=3D 0)
> +	if (n =3D=3D 0)
>  		return BIT(ARMV8_PMU_CYCLE_IDX);
>  	else
> -		return GENMASK(val - 1, 0) | BIT(ARMV8_PMU_CYCLE_IDX);
> +		return GENMASK(n - 1, 0) | BIT(ARMV8_PMU_CYCLE_IDX);
>  }

[Severity: High]
This is a pre-existing issue, but does restricting guest access via
kvm_pmu_accessible_counter_mask() also inadvertently drop EL2 state during
live migration?

Looking at get_pmreg() in arch/arm64/kvm/sys_regs.c, when userspace invokes
KVM_GET_ONE_REG to save PMU registers like PMCNTENSET_EL0:

arch/arm64/kvm/sys_regs.c:get_pmreg() {
    ...
    u64 mask =3D kvm_pmu_accessible_counter_mask(vcpu);

    *val =3D __vcpu_sys_reg(vcpu, r->reg) & mask;
    ...
}

And similarly when restoring in set_pmreg():

arch/arm64/kvm/sys_regs.c:set_pmreg() {
    ...
    u64 mask =3D kvm_pmu_accessible_counter_mask(vcpu);

    __vcpu_assign_sys_reg(vcpu, r->reg, val & mask);
    ...
}

If a nested VM is migrated while its vCPU is executing in EL1/EL0,
kvm_pmu_accessible_counter_mask() strips out the EL2 counters because
vcpu_is_el2() is false. Could this cause KVM to silently discard the
EL2-reserved counter state on the source and fail to restore it on the
target?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720-hybrid-v9-=
0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp?part=3D5
