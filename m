Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DBA36A03F
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782241049; cv=none; b=LaIYPBJPhN2X/UJ0gPYPIULk1E1LyrbCEalnJ5t9aSuXH9nleBpuXRUlTMGPU3eG9M8cIzOu/GPGu5prN91nvuWSbANA3xFUHZT8JU5e55hBlmLZm6eB6sL3ys+fQQioso9WwcAmaMl/RaZM+VFmfWbhfTY8S/ged4D3dDKlVGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782241049; c=relaxed/simple;
	bh=ELKXqPtZHMOH89ZckgIAmCZL0vUecOk9moDiiy7dSys=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=d284vkuXmpCXXd93tqPlgXuW6mzEtxL4yFwdNrWTM1tx7j8/nqieMl01JWX9aXC+CZZpVXYDb0nqRY38TKjr6ObeWtBXNpvXG6VIun8VS8VTnRHtZ06wFNXWhkv2mADov8z+KCf+N6pAttEYgnPI1if8ewOXweJajp4TAinfP/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BdAk9cs0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BdAk9cs0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB82D1F000E9;
	Tue, 23 Jun 2026 18:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782241048;
	bh=whStJizdjzXcBqOQwjn64toKshHyuUeKRgpCvH9G0D0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BdAk9cs0JAkOHaXrfw0vb/jWyZql0zWTULVaBBRAg5aqbSCa/CW7n2aCK/kn40hi/
	 Ku3D7L/JIJfoDA0pReUpWsMxyJp97emMPsVPWzU+4uuxe3ChflhHqOp1utzk1+P7ba
	 XDmhrXwr6ZG7Q/j578pV8x0RtP9Lrx2iQCxSw/CUj4StvfNXwLfkU+miHRWZaMzWzv
	 AogqIP91J75TNQNTWud8z/1NgcI/Eha6UQfb/Txo9m2YYWjIIiMe61U6jAOvjNverp
	 aq4Y001n+OLdeZ78RVGzqfG/CHRyk2m0aXOnNyTQCsCKhrs5A65SOXvcPZeHLZhWl8
	 FmAI4ehTRd5Aw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/22] KVM: arm64: nv: Consolidate computation of
 stage-2 permissions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20260623184201.1518871-3-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-3-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 18:57:27 +0000
Message-Id: <20260623185727.DB82D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] This problem wasn't introduced by this patch, but this patch s=
ilently fixes a critical pre-existing security vulnerability in nested KVM =
where stage-2 Execute-Never (XN) restrictions were ignored when the host la=
cks FEAT_XNX. The bug should be explicitly noted and split into a separate =
fix for stable backporting.
--

commit 60a1129130ae1d928ae1a5f97eb06ae059dacb1a
Author: Oliver Upton <oupton@kernel.org>
Subject: KVM: arm64: nv: Consolidate computation of stage-2 permissions

This commit centralizes the computation of stage-2 permissions within the
table walk rather than inspecting the descriptor directly for execution
permissions.

> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm=
/kvm_nested.h
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -129,34 +131,12 @@ static inline bool kvm_has_xnx(struct kvm *kvm)
> =20
>  static inline bool kvm_s2_trans_exec_el0(struct kvm *kvm, struct kvm_s2_=
trans *trans)
>  {
> -	u8 xn =3D FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, trans->desc);
> -
> -	if (!kvm_has_xnx(kvm))
> -		xn &=3D FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b10);

[ ... ]

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -241,6 +241,36 @@ static int swap_guest_s2_desc(struct kvm_vcpu *vcpu,=
 phys_addr_t pa, u64 old, u6
>  	return __kvm_at_swap_desc(vcpu->kvm, pa, old, new);
>  }
> =20
> +static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk=
_info *wi,
> +				   struct s2_walk_step *ws, struct kvm_s2_trans *trans)
> +{
> +	u8 s2ap =3D FIELD_GET(KVM_PTE_LEAF_ATTR_LO_S2_S2AP, ws->desc);
> +	u8 xn =3D FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, ws->desc);
> +
> +	if (!kvm_has_xnx(vcpu->kvm))
> +		xn &=3D 0b10;

[Severity: Critical]
This is a pre-existing issue, but this change silently fixes a regression
in nested virtualization isolation.

In the old code for kvm_s2_trans_exec_el0 and kvm_s2_trans_exec_el1, the
masking was done using FIELD_PREP. Because xn was a u8 and FIELD_PREP=20
returned a 64-bit value shifted by 53 bits, the bitwise AND always=20
evaluated to 0.=20

As a result, the check bypassed the L1 hypervisor's Execute-Never
restrictions entirely when the host lacked the hardware feature.

Since xn &=3D 0b10 correctly resolves this in the new compute_s2_permissions
function, does it make sense to split this specific correction into a
separate commit so it can be easily backported to stable trees?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623184201.1518=
871-1-oupton@kernel.org?part=3D2
