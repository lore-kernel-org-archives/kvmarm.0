Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AD71A38F9;
	Sat,  1 Aug 2026 13:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785589419; cv=none; b=egoRh2C3KbSglamDSlVMz+UCikqEdaxWRCqJ8B0tEiDCLY7pP7VY8O/frRAyHRHbOQh6TQgzuDB7MchBqv6eu4YsX2ZHOkBAFEaU+iR7cl3FGb+1P6eE2W6DkogfA6biWmXf4L1UwLg4euzG30GOfsJq0jVQvnh4pZl5bgX2YFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785589419; c=relaxed/simple;
	bh=uajvz+X5N2Ziw7d4Hh1KIyX3AVfGYDHzCeFrVroqE5k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dew0s61F4Xv2x1wo7O+hZ4ryovxq9JcWCdbLPFiLi6CwoCVwcA9VgZVLwqfEYoRZw242zmZgDduBgaihI2JC7Q7HYJVSA1edJ0K5/AU+9yA+4tPWquSVxqeoLXelTK052EOjODETqPLRnI5e1pASJyTjbCYx6fMtlRSOzqHDdKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IstBHYVR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IstBHYVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2BA1F00AC4;
	Sat,  1 Aug 2026 13:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785589418;
	bh=dcQ8q1DIC26P1aByNPIfx6FMjt1Vne8oCBgTvjpu9J8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IstBHYVRGwyTPnK4WLh5T6jAqC0sbOY8j/snuReeWG4OaRyl4J+31T9+IZnLN6XZ9
	 vIc12tIZstWZuJEFJDVdQbpzc+EQq6a2esOxaeoQe8sWRchcG8MOO8jBrkoNdouTlS
	 i65XrPnYeg2n/pln1T7VWR43eV56RnWjjkXVKdE0puB/BWUuyxCfQGx+BytreMHNPy
	 eYzpPoQ0nxFCcJgEU4NMxrm8+dSVi2uloocKV5a6wwzq1EFJbYjaxH0l/OOkK4PYhT
	 Mph1GPZMfT6RsBOvn5F2mWCJXEBXGdng5fd3qzb3QlWNuriyxUQy67c9R/9RIiyKGv
	 7qMgvlDCfStZQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/6] KVM: arm64: Correctly handle end of VA space TLBI
 invalidation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260801124818.366274-5-maz@kernel.org>
References: <20260801124818.366274-1-maz@kernel.org>
 <20260801124818.366274-5-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 13:03:37 +0000
Message-Id: <20260801130337.EB2BA1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing sign-extension in `decode_range_tlbi()` breaks Stage-1 ran=
ge TLB invalidations (e.g., `TLBI RVAE1`) for TTBR1 addresses.
--

--- Patch [4]: [PATCH 4/6] KVM: arm64: Correctly handle end of VA space TLB=
I invalidation ---
commit 33057eee0c17792f671722b92173b4f67ff0fde6
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Correctly handle end of VA space TLBI invalidation

This patch corrects the overlap check for TLB invalidations by modifying the
comparison logic to be inclusive rather than exclusive. This fixes an issue
where the invalidation would fail if the range ended exactly at the boundar=
y of
the TTBR1 VA space due to address rollover.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 711c0d0ff8339..69a4652f39336 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c

[ ... ]

> @@ -1060,28 +1064,19 @@ static void invalidate_vncr_va(struct kvm *kvm,
>  	lockdep_assert_held_write(&kvm->mmu_lock);
> =20
>  	kvm_for_each_vncr_tlb(i, vcpu, vt, kvm) {
[ ... ]
>  		switch (scope->type) {
>  		case TLBI_ALL:
>  			break;
> =20
>  		case TLBI_VA:
> -			if (va_end <=3D scope->va ||
> -			    va_start >=3D (scope->va + scope->size))
> +			if (!vncr_tlb_intersects(vt, vt->gva, scope->va, scope->size))

[Severity: High]
This is a pre-existing issue, but does scope->va fail to match TTBR1 addres=
ses
because it is not properly sign-extended?

Looking at compute_s1_tlbi_range() which populates scope->va using
decode_range_tlbi(val, &scope->size, &scope->asid), the base address is
extracted in arch/arm64/include/asm/kvm_nested.h:

	base =3D (val & GENMASK(36, 0)) << shift;

Because this shifts the bits without sign-extending them to 64 bits, TTBR1
addresses are zero-extended. When vncr_tlb_intersects() compares this posit=
ive
scope_start against a correctly sign-extended, negative vt->gva (mapped to
tlb_start), the unsigned comparison (tlb_start > scope_end) evaluates to tr=
ue.

Could this cause Stage-1 range TLB invalidations (like TLBI RVAE1) to silen=
tly
fail for kernel space addresses, leaving stale translations in the nested
guest's TLB?

>  				continue;
>  			if (vt->wr.nG && vt->wr.asid !=3D scope->asid)
>  				continue;
>  			break;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801124818.3662=
74-1-maz@kernel.org?part=3D4
