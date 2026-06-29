Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A870B34A773;
	Mon, 29 Jun 2026 11:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782733179; cv=none; b=DSv1+eTO4DLx9xFH99ildWUAevmA2tq6NfN51GqWsPJlevCnop2fWeVgVeKqrY2CgFqu6d4/n2zauXhNLLGwd26GuwgQGdwqm/8LOeUw8asL3WXg2fksUOSprolF10JQ4oEKkgXlaJhjQgmjATdvLOWtD0gDRZ3zjMS8PxfvL6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782733179; c=relaxed/simple;
	bh=kXcLntJ/o+ZYne25KiemKGpLEQ1fj9Y4ZkAVpntJpxM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pIt0wDkUeeNKGQiSnzJsQwsLTc2W1alDtDPQxiRWm11/H+ubtBgQG7h7XvjE4Wl2bAPurwqP72WvV1L5z2SmZLgkLP0cKSqQDGqTvKBjQHJDvPY3KphCv1TDXDvhffc1SMpyJQ9jOC41m2gayN9rrdN00xdDI3Fv83HeCj0mzBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hrESZCpc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hrESZCpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405FC1F000E9;
	Mon, 29 Jun 2026 11:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782733178;
	bh=mj5pu1QM5CaTh3kyRn4Fdkyam9s2WOcLfEbQGPLfWf4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hrESZCpcJAKID/vcWQUFOBiQ1eqZ80QaCrxxTFm74xZobELTNbpA0cnaSikWNwtj4
	 DBbdo1Sd5NoZn+vLoiX80Mwe52i0LK1fg9dIl6lCvb3nLk4rYe+X+0B4H4hi+0g+F8
	 kafS2ZjTkUzVmxfySFDVP4GJdBvuJPR374g5oCppTYIqtNUFJLpPfWOCOhJY4BHq4p
	 PL6a7pRGoMdPNeqTLVoYOt/DkWUFfVxKxYa76eTkeFO/KbGs47zDoIpD1Ljk3GwWEr
	 Ek6+Kyw82BoUQZQsu2X+ojSmLOepYEkzHErVPSwUsXK6VBL9suyPALtMLbpKjo936Q
	 G1axt/3bPyzFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 09/13] KVM: arm64: Dirty-bitmap: avoid splitting
 previously split blocks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260629111820.1873540-10-leo.bras@arm.com>
References: <20260629111820.1873540-1-leo.bras@arm.com>
 <20260629111820.1873540-10-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 29 Jun 2026 11:39:37 +0000
Message-Id: <20260629113938.405FC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Incorrect PMD boundary calculation skips huge page splitting for a=
djacent PMDs and causes redundant splitting for the last chunk of each PMD.
- [Low] Variable `split_end` is declared as a Guest Physical Address (`gpa_=
t`) but assigned and compared as a Guest Frame Number (`gfn_t`).
- [Low] The local variables `start` and `end` shadow the outer loop bounds.
--

commit 8863fe6c6c67ca7006255c8805499ac99f887014
Author: Leonardo Bras <leo.bras@arm.com>

KVM: arm64: Dirty-bitmap: avoid splitting previously split blocks

If previous dirty-clean already split a block, then avoid calling the
split helper on that block again.

> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> --- a/arch/arm64/kvm/dirty_bit.c
> +++ b/arch/arm64/kvm/dirty_bit.c
> @@ -160,6 +160,7 @@ int __kvm_arch_dirty_log_clear(struct kvm *kvm,
>  	u64 ttwl;
>  	u64 start, end;
>  	gfn_t base_gfn;
> +	gpa_t split_end =3D 0;

[Severity: Low]
This isn't a bug, but should split_end be declared as a gfn_t?

It is declared as a Guest Physical Address (gpa_t) here, but later receives
a Guest Frame Number (gfn_t) from gpa_to_gfn(). While both compile as u64,
this mixes address types.

[ ... ]

> @@ -204,10 +205,14 @@ int __kvm_arch_dirty_log_clear(struct kvm *kvm,
> =20
>  		offset =3D base_gfn + i * BITS_PER_LONG;
> =20
> -		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> -			kvm_mmu_split_huge_pages(kvm,
> -						 gfn_to_gpa(offset + __ffs(mask)),
> -						 gfn_to_gpa(offset + __fls(mask) + 1));
> +		if (kvm_dirty_log_manual_protect_and_init_set(kvm) &&
> +		    (offset + BITS_PER_LONG > split_end)) {

[Severity: High]
Does this comparison check an exclusive GFN against an inclusive GFN?

The expression offset + BITS_PER_LONG calculates an exclusive boundary,
while split_end is calculated below as an inclusive boundary:

    split_end =3D gpa_to_gfn(ALIGN_DOWN(end, PMD_SIZE) + PMD_SIZE - 1);

Comparing these might cause a redundant split for the last 64-page batch
of an already-split PMD.

> +			gpa_t start =3D gfn_to_gpa(offset + __ffs(mask));
> +			gpa_t end =3D gfn_to_gpa(offset + __fls(mask) + 1);

[Severity: Low]
This isn't a bug, but do these variables shadow the outer loop bounds?

The variables start and end declared here share names with the loop bounds:

    u64 start, end;
    ...
    for (unsigned long i =3D start; i < end; i++) {

While scoping rules use the correct variables, shadowing loop control
variables might make the code prone to subtle bugs during future refactorin=
g.

> +
> +			kvm_mmu_split_huge_pages(kvm, start, end);
> +			split_end =3D gpa_to_gfn(ALIGN_DOWN(end, PMD_SIZE) + PMD_SIZE - 1);

[Severity: High]
Can this alignment skip splitting for the next PMD?

The variable end is an exclusive physical address:

    gpa_t end =3D gfn_to_gpa(offset + __fls(mask) + 1);

If a block of dirty pages ends exactly at a PMD boundary, ALIGN_DOWN() on
the exclusive end address aligns it to that boundary. Adding PMD_SIZE - 1
then advances split_end to the end of the next PMD.

This would skip huge page splitting for the adjacent PMD, breaking dirty
logging and potentially causing data corruption during live migration as
dirty pages would not be tracked at the PTE level.

> +		}
> =20
>  		do {
>  			idx =3D mask_to_hdbss(&mask, hw_entries, offset, ttwl, idx, entries_s=
z);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260629111820.1873=
540-1-leo.bras@arm.com?part=3D9
