Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AF23C8C5E;
	Thu,  2 Jul 2026 16:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010716; cv=none; b=r63lvnQbtlcSc4FZFJhouuhrpuGU5xrdQiJbLRq4F1usP6WfJ78vjabAN7K4gMd+fEcjvFa7IUNv83y6qrkF7YGO+l3G+jRfabsEOX2rG3cYdVFq1kUfUgfonujiL/ed0jtVSRE4V807xGZhYvwh8Gk7D8UxJ3AmyPwNt/MvDKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010716; c=relaxed/simple;
	bh=wtqhFHbSWYNXs87LufFazIu1ej8pq6fWnwK+Ct0hpRw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=g5SyO85/okNRFHHjn4RNTF007hwR3/JxoWDPnW19HqXmJkfLg2Knhh5szju8OAjqjJo/KbCLdZf2+VoaxRZuGP0F9cxdN8asnGcgdcmW5Y1BfxTcYSOxoGAKFZE3SP8/mcO50aaxBvSWUgwoLjzeecSJGUzQX7wjlEAYtZxu73Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YwTqBCii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YwTqBCii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41EF1F00A3D;
	Thu,  2 Jul 2026 16:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783010715;
	bh=HvN6x1ITY10aObCFdpGxrjeRRScH455g5EilQvrdtUM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YwTqBCiiFT90/Ud4Si4y8kNQNEMGwJMO2gXXDLDC3Gz5qxtaWo0H28GQCgI0JUWI2
	 OjvJQloQgHjTsiPQzn8zdnmzxCulbHwnxaCMF6D1CPYzC7QgSEl87Bct5RSVkgtuYG
	 FUwhJB6rSHP4K7OAxJRh3h+8h6jmFBfiuFSQmhJILbj6ZoTjmAaWV53zgWzRN2pNos
	 LbK+wQ0wgOC8wfg0gkosWotWiZPVEl/8n2ergFztOcl08REX0i7sb279jMD27VxL/m
	 ZyuiqC5ZCum3P13ZEqqO5HP7m2f/9+Xux5uDEXUH2gd+1IDN7ep81k7il2bUCaWVbP
	 w4P4Z7eqrlLGg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 25/28] KVM: arm64: Engage NV3 TLBI trap elision
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260702160248.1377250-26-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-26-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 16:45:14 +0000
Message-Id: <20260702164514.C41EF1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [Critical] Enabling FEAT_NV3 TLBI elision (NVnTTLB) breaks KVM's nested S=
2 MMU caching, leaving stale L2 guest S1 TLB entries across cached physical=
 VMIDs.
- [High] TLBI trap elision for NV1 guests is nested inside a check requirin=
g the guest to use VHE, rendering the optimization dead code.
- [Medium] NV3 TLBI trap elision is incomplete because HCRX_EL2_NVnTTLBOS i=
s omitted from the TLBI elision mask.

Pre-existing issues:
- [High] vcpu_set_hcrx() statically evaluates the guest's dynamic HCR_EL2.E=
2H state at boot, permanently disabling HCRX_EL2_NVTGE even if the guest la=
ter enables VHE.
--

commit e34c9c8b4a16d0026abc090c888c49e7f1c66d8a
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Engage NV3 TLBI trap elision

This commit enables FEAT_NV3 TLBI trap elision for guests that are not
NV2-aware. It relaxes TLBI traps to only TGE=3D0 using HCRX_EL2 bits.

> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/as=
m/kvm_emulate.h
> index b32870a5e1236..d6f432b1558f5 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -715,6 +715,15 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vc=
pu)
>  		if (cpus_have_final_cap(ARM64_HAS_NV3) &&
>  		    vcpu_has_nv(vcpu) && vcpu_el2_e2h_is_set(vcpu)) {

[Severity: High]
This isn't a bug introduced by this patch, but because vcpu_set_hcrx is
called once during kvm_calculate_traps at the first VCPU run, the guest
has not yet executed and its virtual HCR_EL2.E2H is 0.=20

Since vcpu_el2_e2h_is_set checks the dynamic HCR_EL2 register, does this
evaluate to false and permanently disable HCRX_EL2_NVTGE even if the guest
later sets HCR_EL2.E2H at runtime?

[Severity: High]
Does checking vcpu_el2_e2h_is_set here prevent the NV1 TLBI elision
optimization from ever being reached?

Since an NV1 guest does not have VHE enabled (E2H=3D0), this outer condition
will evaluate to false, meaning the inner !kvm_has_nv2(vcpu->kvm) block
added below will be skipped.

>  			vcpu->arch.hcrx_el2 |=3D HCRX_EL2_NVTGE;
> +
> +			/*
> +			 * If the guest is NV2-capable, then we need to see
> +			 * all the TLBIs, as configured in HCR_EL2.
> +			 * Otherwise, relax the TLBI traps to only TGE=3D0.
> +			 */
> +			if (!kvm_has_nv2(vcpu->kvm))
> +				vcpu->arch.hcrx_el2 |=3D (HCRX_EL2_NVnTTLB  |
> +							HCRX_EL2_NVnTTLBIS);

[Severity: Medium]
Does this mask omit the Outer Shareable S1 TLBI elision bit
(HCRX_EL2_NVnTTLBOS)?

Without it, will Outer Shareable S1 TLBI instructions continue to
trap to KVM, missing out on the intended performance optimization?

[Severity: Critical]
Does enabling hardware TLBI elision here break KVM's nested S2 MMU
caching?

KVM caches multiple S2 MMU contexts (with distinct physical VMIDs) for
the same virtual VMID, and defers physical VMID switches until guest entry.

If a guest hypervisor writes to VTTBR_EL2 and executes an S1 TLBI natively,
hardware will only invalidate the currently active physical VMID.

Could this cause the hardware to invalidate the wrong context (the
hypervisor's own S1 TLB instead of the L2 guest's) and miss other cached
physical VMIDs sharing the virtual VMID, potentially leading to stale
TLB entries?

>  		}
>  	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702160248.1377=
250-1-maz@kernel.org?part=3D25
