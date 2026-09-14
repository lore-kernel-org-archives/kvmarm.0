Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E283E266581;
	Mon, 14 Sep 2026 12:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388076; cv=none; b=ulqv1XoxNDYdN/mhVS7pvDJZJMgqlM/ZDX1+tZoQ2Y72902pF21uuE5zy+TRS7Dvq765Ar1lj7Ztz0iWAMmade3pThp27FDxWYEkzOX7p1O1yh8AcLc/g4JvTNsV//GqIn7isMpEDyveM2s0FofzlG34V9rvbkOGwFrFPIaRWcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388076; c=relaxed/simple;
	bh=Lb2U+Qjg0FOhevP72PEMfWG3oZbrQRvL5HyYRSZ/OMw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=vAxG6AIxM0ouONjVu59RclLYzx0DBFwarFBzLt3BrTQwvS0pwNVJs87J3WtduF3nTKBzOM4HDhf/f6+qrT2T1e3GkjjaCZG915DnpaL5GcL1XKiPyxoFm9Lo/roBt2FmquPMWJZkaBLzYM9sZ6XA8sU8sX5hcSz+lXZVNF0gZAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XLx+f33K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XLx+f33K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CE21F000FF;
	Mon, 14 Sep 2026 12:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789388074;
	bh=Au9nOhJdOpOmK1doC0fKnrZ3TVQV8EGKIlaNxxFqOds=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XLx+f33Kb410TYqG8kpcWC2WM586NfW+ncjLPJKh3khwSu7FzpVKeOUyEy0QkXS49
	 kS3OpdvnFSSxwT16ZRlXJsQXSoY7WCP3CyeMqYTrYY2pEXWMNluTxSKf0LJ7xSfzPC
	 bRxzKHYR6SP644uurxNFbEUN9E5U0Fn7e1YTBjevESBHTxYX/5IB3bDTXR35aoK4y7
	 QxWYCjoryIU+ua9vGu1GIafo48JtTaLjnhpNhsAttHxMoKKBGSqgktUIHhiff6kvDi
	 l3n5jan3QCES60740uEX+8JCHhKqz6uEqQCMnJqRZawJaRWp27vke0SJaEV1azFdnU
	 sF+x7x77teg8Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 07/20] KVM: arm64: PMU: Recreate events after reset
Reply-To: sashiko-reviews@lists.linux.dev
To: "Akihiko Odaki" <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260914-hybrid-v10-7-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
References: <20260914-hybrid-v10-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
 <20260914-hybrid-v10-7-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 12:14:33 +0000
Message-Id: <20260914121433.C4CE21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Deferred PMU event recreation corrupts PMU counter reset values by=
 writing back stale perf_event counts into freshly reset system registers.
--

commit a8710b2a9555c20c3e81b98a0509dda9d3d93f2e
Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

KVM: arm64: PMU: Recreate events after reset

This commit defers the destruction and recreation of PMU events until the
vCPU thread runs, setting a flag during system register reset to stop and
reprogram the backing perf events.

> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index a5ccb6ae44d5f..8530cc907b56c 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
[ ... ]
> @@ -900,7 +906,16 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool p=
mceid1)
> =20
>  void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_pmu *pmu =3D &vcpu->arch.pmu;
>  	u64 mask =3D kvm_pmu_implemented_counter_mask(vcpu);
> +	int i;
> +
> +	if (pmu->events_need_recreate) {
> +		for (i =3D 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++)
> +			kvm_pmu_stop_counter(kvm_vcpu_idx_to_pmc(vcpu, i));

[Severity: High]
Does this corrupt the architectural reset state of the PMU counters?

If a guest VM triggers a warm reset, kvm_reset_sys_regs() resets the PMU
counters to their architectural reset state and then calls
kvm_pmu_request_recreate().

On the next vCPU entry, kvm_vcpu_reload_pmu() iterates over all PMCs and ca=
lls
kvm_pmu_stop_counter(). However, kvm_pmu_stop_counter() is designed for dyn=
amic
disablement. It preserves the counter by reading the current sysreg value,
adding the accumulated perf_event count, and writing the sum back to the
sysreg:

arch/arm64/kvm/pmu-emul.c:kvm_pmu_stop_counter() {
    ...
    val =3D kvm_pmu_get_pmc_value(pmc);
    reg =3D counter_index_to_reg(pmc->idx);
    __vcpu_assign_sys_reg(vcpu, reg, val);
    ...
}

Will this sequence overwrite the freshly reset counter value with the sum of
the reset value and the stale perf_event count from the previous run?

> +
> +		pmu->events_need_recreate =3D false;
> +	}
> =20
>  	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, &=3D, mask);
>  	__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, &=3D, mask);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 42b6705bc21d1..1a57e07cec9a4 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5390,7 +5390,7 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
>  	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
> =20
>  	if (kvm_vcpu_has_pmu(vcpu))
> -		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
> +		kvm_pmu_request_recreate(vcpu);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-hybrid-v10=
-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp?part=3D7
