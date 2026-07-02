Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1336533B969;
	Thu,  2 Jul 2026 16:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009525; cv=none; b=dGVlS5bYhw1B5QyLQbDSyoH6fSG1yp1qwa9oOudtoqu+qWGcrFNoFgirrqmDQTgjAy06YpJ93Q2idJ91AKNG9zbOShAsLxTAAfN+y01VO/7kdGRbunnC6vNQE7GRHVvvnaQmFcaaW5M+3knuZJz61/VgbBbby4psH5/uGmQOmYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009525; c=relaxed/simple;
	bh=rlzqigyWzAX7NoNzxTFVJhVGoBhss0V+xnmh+w/7IhU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JZCRWAT+iaK2SW4krFLaAt5LcrydL85knsPaQ9QTpzUxklFXex/yGwkYUzF6OOHUOdUNcwi+4ApkK1I7en8pKhUnCJeW10nwTasp9hm0HyFlogMQL7zJlX6RNNpUXmW2SslLtGIYVupnTwjQBOiuvjfZj/MvM5ffV/A9naa36VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WQ+4uOEz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WQ+4uOEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACF11F00A3F;
	Thu,  2 Jul 2026 16:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783009518;
	bh=Q+gH6B+e/e+r50L1zWjvhjsC5PS1j7Za5/XQLPi7wlM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WQ+4uOEzlEaMDHSUFqLVCwka8dHbeKrKPaY0yzSBhB2XRE3sDugIRToD8B9idWTcU
	 TuugsVKblhFhN/qQoswlvpwTVuivWXiCnpAOXzmiDrxKGB9pSIJwcFLcf6XFA+JvAR
	 umclmVGZSdOtfLQuJ5Oc7Dnm+l+cn3ADBgdcrpebh+27rrIUrBC5eKOr+kHixBOd4Y
	 xz4UFHOntW5EWIdemQHgrltkGINPzqIaQZeuRoARjBtb9Af2hOkRP0TRfmGsefHsT/
	 HDTrZiVEO9slPNPNJ8Y+EO3BI0eylo4PQcH8efgxz8CtwzzkOT5Ug1XHO/lvISptDv
	 enoJjQZWBYiAQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 18/28] KVM: arm64: Add kvm_has_nv{2,3}() predicates
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260702160248.1377250-19-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-19-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 16:25:17 +0000
Message-Id: <20260702162518.0ACF11F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] `is_nested_nv3_ctxt()` incorrectly identifies NV3 context when the=
 guest clears `HCR_EL2.E2H`, diverging from hardware execution semantics.
--

commit c75857355bb73ff60c1d0206705bb863784f8183
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Add kvm_has_nv{2,3}() predicates

Add a new set of predicates indicating whether VM is capable of
NV2, NV3, and is in a nested NV3 context. This is going to become
useful as we start dealing with a mix of behaviours.

> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/as=
m/kvm_emulate.h
> index 9831166695186..c562d8171d5e1 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h

[ ... ]

> +static inline bool kvm_has_nv3(struct kvm *kvm)
> +{
> +	return (cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) &&
> +		cpus_have_final_cap(ARM64_HAS_NV3) &&
> +		kvm_has_feat(kvm, ID_AA64MMFR4_EL1, NV_frac, NV3));
> +}
> +
> +static inline bool is_nested_nv3_ctxt(struct kvm_vcpu *vcpu)
> +{
> +	return (has_vhe() && kvm_has_nv3(vcpu->kvm) && is_nested_ctxt(vcpu) &&
> +		(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_EL2_NV) &&
> +		(__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_NVTGE));
> +}

[Severity: High]
Does this predicate miss a mandatory check for HCR_EL2.E2H?

Architecturally, NVTGE is RES0 when E2H is 0. If a guest sets HCR_EL2.NV =
=3D 1
and HCRX_EL2.NVTGE =3D 1, but leaves HCR_EL2.E2H =3D 0, the hardware will n=
ot
execute the guest under NV3 semantics.

If is_nested_nv3_ctxt() evaluates to true in this scenario, could it lead to
KVM state desynchronization?

For example, KVM might unconditionally save SYS_NVHCR_EL2 to the software
context during exit handling. Since the hardware wasn't actually using NV3,
SYS_NVHCR_EL2 wouldn't be updated with guest writes and would contain stale
data.

Would this result in KVM later loading that stale value into the guest's
HCR_EL2 when context switching back, clobbering the guest's register? Should
this include a check for vcpu_el2_e2h_is_set(vcpu)?

>  /*
>   * The layout of SPSR for an AArch32 state is different when observed fr=
om an
>   * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AA=
rch32

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702160248.1377=
250-1-maz@kernel.org?part=3D18
