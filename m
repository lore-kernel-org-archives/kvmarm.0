Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0693D412B;
	Thu,  6 Aug 2026 09:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786008632; cv=none; b=TyqqR9cGtJADTMS46FnPUxPRThRmfLtPMyhDYYFn5oKW0cXXj0p7KkOuDyL+ZUv6pouKIfEDaPRylea583fLIR1HXK0iSegBZPJ09Px/v+I9LtSBga2b0xm2rytUsei9SvtUD6Phe1MlC1MGeLcctli59u6V8kdN40yKBVSaQ/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786008632; c=relaxed/simple;
	bh=3XDPiyItPIlcaueivEnzk48I0rBARbkQv9gbF5oTI8M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ensGqWVeqq4uc3V853tFKhR3F8I42q9cvgS+3r3hl9XQYh7h2unY2x87bzdx6YkyXNdIfVsid6j2jx/jG87OPTGed9DKVsFpkg0fVUCvccRx3k91uO/f1mgeTf4MvrQtspTed5sb7Ct859QU9iOOGdewBzeeDdVt2Ny4YDRvwWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=llIw9OeL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="llIw9OeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863F31F000E9;
	Thu,  6 Aug 2026 09:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786008630;
	bh=3MF3dF0umWTVzYgzLfMg2ehZhqxUobJVGacxbJD1ITI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=llIw9OeL0NaWQfOSABvFlkz1qYVjtHusg+RkawrcwObMTx+n9ZYjpUn+9SWwp6/DU
	 WDZXPbKtmbHB6Q4bS8yzbPtgK+wogWmFEuzWw5mIgYPWrl4llODwz8ZnU6duvX2JET
	 aSvTO/3bRKgOWo41VAuKCqI3ESihaq4zzPIjurPCRA3gD4edGpO4Kdl961D/Z3agco
	 Mo3e1jk1HNZymi4WQlMhXDMvvWbt5qxx5upcnrOeA4ewnx1aV16ksPAtphAlWT8vO9
	 WaH+W89kPddnU1MSCl/sGiws5hvWzrkg6Pa++U0wV8pYbEtC2gx5xEEFR6Hfk0BVLP
	 3vmCtqNcEK0+g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/8] KVM: arm64: Correctly handle end of VA space
 TLBI invalidation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260806091026.620700-5-maz@kernel.org>
References: <20260806091026.620700-1-maz@kernel.org>
 <20260806091026.620700-5-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 09:30:29 +0000
Message-Id: <20260806093030.863F31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Range TLBI instructions for Stage-1 TTBR1 addresses silently fail =
to invalidate VNCR entries because the base address is not sign-extended.
- [High] The `tlbi_va_s1_to_va` macro and `read_vncr_el2` sign-extend from =
bit 48, which corrupts 52-bit Virtual Addresses (LVA).
--

--- Patch [4]: [PATCH v2 4/8] KVM: arm64: Correctly handle end of VA space =
TLBI invalidation ---
commit 0f00ac726029153c77159941056d984a8dc753cf
Author: Marc Zyngier <maz@kernel.org>
Subject: KVM: arm64: Correctly handle end of VA space TLBI invalidation

This commit fixes an issue with TLB invalidation by VA where address rollov=
er
at the end of the TTBR1 VA space caused invalidations to fail. It introduces
a common helper, vncr_tlb_intersects(), which uses inclusive end addresses
to prevent this issue for both VA and IPA invalidations.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 939813aebaafa..67cc5b6d80705 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1000,6 +1000,20 @@ static void invalidate_vncr(struct vncr_tlb *vt)
[ ... ]
> +static bool vncr_tlb_intersects(struct vncr_tlb *vt, u64 addr,
> +				u64 scope_start, u64 scope_size)
> +{
> +	u64 tlb_size, tlb_start, tlb_end, scope_end;
> +
> +	tlb_size =3D ttl_to_size(pgshift_level_to_ttl(vt->wi.pgshift, vt->wr.le=
vel));
> +
> +	tlb_start =3D addr & ~(tlb_size - 1);
> +	tlb_end =3D tlb_start + tlb_size - 1;
> +	scope_end =3D scope_start + scope_size - 1;
> +
> +	return !(tlb_end < scope_start || tlb_start > scope_end);

[Severity: High]
This is a pre-existing issue, but could this intersection check fail for
Stage-1 TTBR1 Range TLBIs due to a missing sign extension?

When a guest issues a Range TLBI for a TTBR1 virtual address,
decode_range_tlbi() zero-extends the base address:

arch/arm64/include/asm/kvm_nested.h:decode_range_tlbi() {
    ...
    base =3D (val & GENMASK(36, 0)) << shift;
    ...
}

In compute_s1_tlbi_range(), this is directly assigned to scope->va.

Since scope->va is passed as scope_start here and is zero-extended (a large
positive unsigned number), won't it fail to intersect with vt->gva, which
is sign-extended (a negative number for TTBR1)?

> +}
> +
>  /*
>   * VNCR TLB invalidation occurs from MMU notifiers or TLBI instructions,=
 and
>   * either can race against a vcpu not being onlined yet (no pseudo-TLB
[ ... ]
> @@ -1060,28 +1064,19 @@ static void invalidate_vncr_va(struct kvm *kvm,
>  	lockdep_assert_held_write(&kvm->mmu_lock);
> =20
>  	kvm_for_each_vncr_tlb(i, vcpu, vt, kvm) {
>  		switch (scope->type) {
>  		case TLBI_ALL:
>  			break;
> =20
>  		case TLBI_VA:
> -			if (va_end <=3D scope->va ||
> -			    va_start >=3D (scope->va + scope->size))
> +			if (!vncr_tlb_intersects(vt, vt->gva, scope->va, scope->size))

[Severity: High]
This isn't a bug introduced by this patch, but does KVM incorrectly truncate
52-bit Virtual Addresses (LVA) to 48 bits when constructing these VAs?

The tlbi_va_s1_to_va() macro and read_vncr_el2() both hardcode a 48-bit sign
extension:

arch/arm64/kvm/nested.c:read_vncr_el2() {
    ...
    return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 48);
}

If a guest uses 52-bit VAs (FEAT_LVA) and places the VNCR page at a TTBR1
address where bit 48 is 0, wouldn't the upper bits (49-63) be zero-extended
instead of sign-extended?

This seems like it would corrupt the VA into a TTBR0 address, and Range TLB=
Is
(which preserve bits up to 53 in decode_range_tlbi) would fail to intersect
with the corrupted 48-bit vt->gva.

>  				continue;
>  			if (vt->wr.nG && vt->wr.asid !=3D scope->asid)
>  				continue;
>  			break;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806091026.6207=
00-1-maz@kernel.org?part=3D4
