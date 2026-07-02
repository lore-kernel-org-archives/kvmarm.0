Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EB9348C46;
	Thu,  2 Jul 2026 16:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010345; cv=none; b=uZmmTrSYOVrtWTUkpLNeKC079S8J2/7sZBL6T2fGlqko9mAmrMVOcYgnAC2bA8D+Xe7irDGv4dxSYSHWf3OKliAYjyN6WTCeFqEuKJiDGH+9GOwJmZYtRVhGzCoZpMP2CoVYcsXXDzLlo/EJMTjjjLiv5R5iVvXvtZtGqNC6cpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010345; c=relaxed/simple;
	bh=2z1VY96osTDhHJX2J9ub6YbTD/BOjoI3qUmEJJbEKKU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cvJu9maiQydpufjLzR9DGK3uD1p4HF2ChUvTNiAr4J2lOJhbTXXto9U07Ue6bwV18zm5VOXcJy9g1bY4k6a7NwNXiBeJXP+eJM8bu3uu7nIP0gae/Oxc6L9+uBs29WAedYluuHcAV6Mm2BlykRAkazrHD614xVRonEu2JwOnJrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kn1sScWE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kn1sScWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852691F00A3E;
	Thu,  2 Jul 2026 16:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783010343;
	bh=+QnIW91nhV5FpjJv8LaeAD3BRLrsj0ok4T78KPwH0gc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kn1sScWEB0Mfj9ni79ZVRLvsvyoqvf58iPdjoZ946+4n0Npic3mH/rK4kEGGfMMNa
	 7J3AYLeaEtpoOaDmmFwNdVeNZKR/DGSB77jEYbOBDrlUQeCn6rHvSFY2rgPIRXeOsm
	 p+Q+pyHtvO5bbG49KKuGRj/y8qpe6uINkihmRnoN4UUhh8DpWqHqeiqTnv425hKITf
	 9K81IFcs1S9go/ZtHf6A+P7qkO/g7II90dkdL98Tq7QxoolZ6ZXTV73qtSLRHz56RK
	 cIA8Q9o2pRjDTCFYPGa1jhuNhv9iP30PPY04YFSmVHWG1Ho8cBsZRDOnIBtyUx7a3d
	 Jqx9b/8vx2IxA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 27/28] KVM: arm64: Expose FEAT_NV3 to guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260702160248.1377250-28-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-28-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 16:39:02 +0000
Message-Id: <20260702163903.852691F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] A maliciously or incorrectly configured vCPU can trigger a hos=
t NULL pointer dereference by requesting an ID register configuration where=
 NV_frac =3D 0, causing KVM to skip VNCR TLB allocation while still trappin=
g VNCR accesses.
--

commit ca23c995d48d1c5c8370918930aa81e2eeb147ab
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Expose FEAT_NV3 to guests

Further enable FEAT_NV3 by making it visible to NV guests.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index c9bf04944f9cb..64c8fb82fadf6 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1728,7 +1728,7 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 v=
al)
>  		 * You get EITHER
>  		 *
>  		 * - FEAT_VHE without FEAT_E2H0
> -		 * - FEAT_NV limited to FEAT_NV2(p1)
> +		 * - FEAT_NV limited to FEAT_NV2(p1)/NV3
>  		 * - HCR_EL2.NV1 being RES0
>  		 *
>  		 * OR
> @@ -1740,7 +1740,9 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 v=
al)
>  		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features)) {
>  			val =3D 0;

[Severity: Critical]
This is a pre-existing issue, but could this cause a host NULL pointer
dereference?

If userspace configures a vCPU with KVM_ARM_VCPU_HAS_EL2_E2H0, this branch
forces the entire ID_AA64MMFR4_EL1 register to 0. This includes the NV_frac
field. Alternatively, userspace could explicitly set ID_AA64MMFR4_EL1.NV_fr=
ac
to 0 via KVM's ID register UAPI.

When KVM initializes the nested vCPU, it calls kvm_vcpu_allocate_vncr_tlb()
which checks NV_frac:

arch/arm64/kvm/nested.c:kvm_vcpu_allocate_vncr_tlb() {
        if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY))
                return 0;
        ...
}

Because NV_frac is 0, the check evaluates to false and the function silently
returns success without allocating vcpu->arch.vncr_tlb.

Since vcpu_has_nv() only checks for KVM_ARM_VCPU_HAS_EL2, the vCPU is allow=
ed
to run. If the guest then accesses a VNCR-trapped register or sets HCR_EL2.=
NV,
the host exit handler calls kvm_translate_vncr() or kvm_map_l1_vncr(). Both
functions unconditionally dereference the unallocated vncr_tlb:

arch/arm64/kvm/nested.c:kvm_translate_vncr() {
        struct vncr_tlb *vt =3D vcpu->arch.vncr_tlb;
        ...
        vt->valid =3D false;
        ...
}

Will this lead to a kernel panic when unprivileged userspace configures a
vCPU this way?

>  		} else {
> -			if (cpus_have_final_cap(ARM64_HAS_NV2P1))
> +			if (cpus_have_final_cap(ARM64_HAS_NV3))
> +				val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV3);
> +			else if (cpus_have_final_cap(ARM64_HAS_NV2P1))
>  				val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV2P=
1);
>  			else
>  				val =3D SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702160248.1377=
250-1-maz@kernel.org?part=3D27
