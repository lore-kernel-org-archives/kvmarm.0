Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D822218EBA;
	Thu, 30 Jul 2026 08:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785399142; cv=none; b=K/QQajlnbuyHveu/h/NDpJ60GSf6MPzN2DTIrrL5jtgkNyXMDOvD+C6KfK8dLkMWUXmwbvN2MKjy1LeHCO1nGk6qiyE8tf1UK2v4TkPmSIJuy+HzvUfx4739Iab8nZBZFwnqR/ZLugm8Fc0gP6WH7HA2QYPUhXEkhYV8VIklhsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785399142; c=relaxed/simple;
	bh=+DJEii80HDI2j5X1S2dZsqOy7kKVF7UNKa5BccaSIe4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VZSkBVmOps+T3xfqd0LZNOrZ7bChES+YaH80ULvwHH+TMD1NiX3DqjytmvE4r87D1P4AFH0bMw3i0GMGf3ybFQrfnpCmcj3cl0ZQK0MS1ClAAVfZbyp/VA7ZrXcuK7B+Lnura8bbnzF+ohdAPRG78d4cCiHVbmv1ehyF+gWvG9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a5lzAGPF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a5lzAGPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C490A1F00A3A;
	Thu, 30 Jul 2026 08:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785399141;
	bh=RN8hQRSRK9YNOZUOY6bK/8BtpFk4WFPrIkGWyHimyXY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a5lzAGPF71E0SPbQN1N1ZMDyTlPcbhr4PzDGGc/zry+aoeJ3Xv8KjNHWTTGIrpMpM
	 fKcnwxiYSzVn2qM+ldOM+v0Yk0BPEPKUTpnOMn48p4m088VTkjsmaI56BoMxBU7upu
	 gqMT+ozHywR6+viTJVon28cB95gUdMDDvB2aMYMZ0sC+iG5C8DjKyYzIMlmIoxERq0
	 A68imnLm+D2GZwWpfLBMupH1c6FiA+SP6Z4CDXflVMroOqtiqFEnx4xj/oE/KzpPgN
	 Ehlv/exr62JRNH6myJpIJZsVypRrFyVDGVlVhdH1ES8v69r76NNKeSY4wRN6aOlBVm
	 Yh6Wtt9uIUu3Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 22/29] KVM: arm64: Add routing for NVHCR_EL2 trap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260730071022.296811-23-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
 <20260730071022.296811-23-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 08:12:20 +0000
Message-Id: <20260730081220.C490A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The evaluation of HCRX_EL2.NVTGE ignores its architectural depende=
ncy on HCR_EL2.E2H, leading to incorrect trap routing for non-VHE guest hyp=
ervisors.
--

--- Patch [22]: [PATCH v4 22/29] KVM: arm64: Add routing for NVHCR_EL2 trap=
 ---
commit 007c598e0e2ba89316901f92f901362aec3f3a5b
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Add routing for NVHCR_EL2 trap
   =20
This commit describes the exception routing tables for NVHCR_EL2 accesses
from EL1, taking them to EL2 when HCRX_EL2.NVTGE=3D=3D0 and HCR_EL2.NV=3D=
=3D1.

> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index a6d1a265841f2..ffe307f222e66 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c

[ ... ]

> @@ -588,6 +590,15 @@ static enum trap_behaviour check_mdcr_hpmn(struct kv=
m_vcpu *vcpu)
>  	return BEHAVE_HANDLE_LOCALLY;
>  }
> =20
> +static enum trap_behaviour check_hcr_nv_hcrx_nnvtge(struct kvm_vcpu *vcp=
u)
> +{
> +	if ((__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_EL2_NV) &&
> +	    !(__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_NVTGE))

[Severity: High]
According to the ARM Architecture Reference Manual, the HCRX_EL2.NVTGE bit
behaves as 0 for all purposes other than reading the value of the bit when
HCR_EL2.E2H is 0.

Does this raw check of HCRX_EL2_NVTGE need to account for the HCR_EL2.E2H
dependency?

If a non-VHE guest hypervisor sets HCR_EL2.E2H =3D 0, HCR_EL2.NV =3D 1, and
HCRX_EL2.NVTGE =3D 1 (which is architecturally valid), it appears KVM might
falsely conclude the trap shouldn't be forwarded. It would then handle it
locally in L0, which injects an UNDEF exception into the L2 guest.

There appears to be a similar pattern in is_nested_nv3_ctxt() in=20
arch/arm64/include/asm/kvm_emulate.h where the raw NVTGE bit is evaluated
without factoring in the E2H dependency.

> +		return BEHAVE_FORWARD_RW;
> +
> +	return BEHAVE_HANDLE_LOCALLY;
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730071022.2968=
11-1-maz@kernel.org?part=3D22
