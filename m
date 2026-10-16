Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796F93E717A;
	Fri, 16 Oct 2026 10:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792145802; cv=none; b=G1BKPBIF8F9e7cgqvyDHyMHphN6OnXpTEqlwBwmRKAzIwyfImRHN2srwqEtyaJXFmkDz2wDlX0wXCWceLRkr7Wr0tF1pl83qV/tj+2172baaOO7DEUfdSDlnvBLhxo9s2ogprzrR2g1KqveTStMCUGt2NG3GMDS/IApin1xEARg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792145802; c=relaxed/simple;
	bh=bukFjyUDAS8w3bfcUuEoOPmGSr7vtKSdlr/2yLqWGl4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=LLCtry/M2OBU7nq14V0UapGqp5hsO8t8WWCV7PmcNDdIvg62gMO/uRPR8O5s4LO0zds5xUtigsq+/n6tclVFLW6SDlalZOjbUu4tBffqxwqYZHV0XUZAId8NxldTi5S9ID3zk6SPdeVxJLf0MHNbHgrGscMmG//zxXfZ61v5O4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BqNqg7Kk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BqNqg7Kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27881F000C4;
	Fri, 16 Oct 2026 10:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792145801;
	bh=wiprSAgtO9o/sDEd18PczQdNBJ6iix2zGRXQtEeQuDo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BqNqg7Kk4Vh6X5oUvg0DXsJr+epgTZPZpYX/Vq0VVymb+If1TIHuYOg38dRTiC6ig
	 Oef8F19O0esEJFWdnPuay1TQyDirZKJzelKW1ZNUWZ+Mfsyd9y9XTZbuMuIskhvFMq
	 aLiW9BvFcx9vQlIV1++bGK5F+HyH6Z0kGAAW2cVMFHb/CSBOWxuNCZtmjWOchesItu
	 CCbH5gTrYlYuMKpJ0VotWj5QnHaVOjrVrLLMMD+AwP7Vx5TN/k0OzHB3rRBXDAucqC
	 2tEbjwmq3tfWlt6u0VPJtxuXpOdwpbNDAh80ydeyF/YxNKdRxC8Mhn/V0UG6cxyQyT
	 DDAyzB06RCPfA==
Message-ID: <sashiko-outbox-174139@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/4] arm64: tlb: Add tlbi workaround for
 FUJITSU-MONAKA Erratum E#030001
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tomohiro Misono" <misono.tomohiro@fujitsu.com>
Cc: linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261016-monaka-fix-for-upstream-v2-2-fc7ede7f9f48@fujitsu.com>
References: <20261016-monaka-fix-for-upstream-v2-0-fc7ede7f9f48@fujitsu.com>
 <20261016-monaka-fix-for-upstream-v2-2-fc7ede7f9f48@fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 10:16:40 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] kvm: arm64: erratum workaround injects host translation granule in=
to guest TLBI
- [Medium] kvm: arm64: erratum workaround loop bypassed on address space wr=
ap-around
--

commit bd446dc250f0ed99bcd777fad354a7212578bba8
Author: Tomohiro Misono <misono.tomohiro@fujitsu.com>

arm64: tlb: Add tlbi workaround for FUJITSU-MONAKA Erratum E#030001

This commit adds a workaround for FUJITSU-MONAKA Erratum E#030001, where
range-based TLBI operations targeting a VA or IPA may fail to invalidate
TLB entries for 512MB mappings. It works around the erratum by issuing
additional non-range TLBI instructions corresponding to the affected VA or
IPA range-based TLBI operations.

> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/t=
lbflush.h
> index 14a78ac0f8009..2636c273b8111 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h

[ ... ]

> @@ -487,6 +487,39 @@ static __always_inline void __tlbi_range(tlbi_op op,=
 u64 addr,
>  	op(arg);
>  }
> =20
> +#ifdef CONFIG_FUJITSU_ERRATUM_030001
> +static __always_inline void fujitsu_erratum_wa(tlbi_op lop, u64 start, u=
64 end, u16 asid)
> +{
> +	u64 addr;
> +
> +	if (!alternative_has_cap_unlikely(ARM64_WORKAROUND_FUJITSU_030001))
> +		return;
> +
> +	/*
> +	 * The erratum fails to invalidate TLBI entries in the range when
> +	 * addr[34:29] =3D=3D all 1 && addr[28:0] =3D=3D all 0 for 512M hugepag=
e.
> +	 * This affects both on S1 and S2 tables and 4k guest may be affected
> +	 * if host uses 64k page size. Therefore it cannot be determined
> +	 * reliably if the target entry is affected or not here. So, always
> +	 * assume hugepage is used.
> +	 * The workaround is to issue extra non-range TLBI ops corresponding
> +	 * to the affected VA or IPA range-based ops in the range.
> +	 */
> +	addr =3D (start & GENMASK_ULL(63, 35)) | GENMASK_ULL(34, 29);
> +	while (addr < end) {
> +		__tlbi_level_asid(lop, addr, TLBI_TTL_UNKNOWN, asid);

[Severity: High]
Can this inject the host's translation granule into a guest TLBI?

When KVM handles a nested guest's range TLB invalidation, it calls
__fujitsu_erratum_wa(), which invokes this fujitsu_erratum_wa() helper. The
loop here calls __tlbi_level_asid(lop, addr, TLBI_TTL_UNKNOWN, asid).

Looking at __tlbi_level_asid():

static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 lev=
el,
                                              u16 asid)
{
        ...
        if (alternative_has_cap_unlikely(ARM64_HAS_ARMv8_4_TTL) && level <=
=3D 3) {
                u64 ttl =3D level | (get_trans_granule() << 2);
                FIELD_MODIFY(TLBI_TTL_MASK, &arg, ttl);
        }
        op(arg);
}

Since TLBI_TTL_UNKNOWN is 0 and 0 <=3D 3, __tlbi_level_asid() unconditional=
ly
sets the TTL field using get_trans_granule(). However, get_trans_granule()
returns the host kernel's compile-time page size. If the guest is operating
with a different translation granule (e.g., 4K pages in the guest while the
host is configured for 64K), the invalidation is issued with a mismatched TG
hint.

According to the ARM Architecture Reference Manual, a TLBI with a TTL field
that does not match the actual translation regime's granule may fail to
invalidate any entries. Does this leave stale TLB entries in the guest
context?

> +		if (addr + BIT_ULL(35) < addr)
> +			/* overflow */
> +			break;
> +		addr +=3D BIT_ULL(35);
> +	}
> +}

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
> index c386d9f1c1016..2f1a7fab5eb97 100644
> --- a/arch/arm64/kvm/hyp/vhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/vhe/tlb.c

[ ... ]

> @@ -218,6 +219,45 @@ void __kvm_flush_vm_context(void)
>  	__tlbi_sync_s1ish_hyp();
>  }
> =20
> +#ifdef CONFIG_FUJITSU_ERRATUM_030001
> +static __always_inline void __vae1is(u64 arg)
> +{
> +	__tlbi(vae1is, arg);
> +}
> +static __always_inline void __vale1is(u64 arg)
> +{
> +	__tlbi(vale1is, arg);
> +}
> +static __always_inline void __vaae1is(u64 arg)
> +{
> +	__tlbi(vaae1is, arg);
> +}
> +static __always_inline void __fujitsu_erratum_wa(tlbi_op op, u64 va)
> +{
> +	u64 start, size;
> +	u16 asid;
> +
> +	if (!alternative_has_cap_unlikely(ARM64_WORKAROUND_FUJITSU_030001))
> +		return;
> +
> +	start =3D decode_range_tlbi(va, &size, &asid);
> +	fujitsu_erratum_wa(op, start, start + size, asid);

[Severity: Medium]
Does this bypass the erratum workaround if the address space wraps around?

When KVM emulates a guest range TLBI instruction, it decodes the range via
decode_range_tlbi(). If the guest specifies a range that spans to the very =
end
of the 64-bit address space, decode_range_tlbi() caps size such that
start + size exactly overflows to 0.

Passing start + size as the end argument makes end =3D 0. Inside
fujitsu_erratum_wa(), the workaround loop uses the condition:

while (addr < end) {
        ...
}

Because addr is an unsigned 64-bit integer pointing to the upper half of the
address space, addr < 0 immediately evaluates to false, skipping the
workaround entirely.

> +}
> +#else
> +static __always_inline void __vae1is(u64 arg)
> +{
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016-monaka-fix=
-for-upstream-v2-0-fc7ede7f9f48@fujitsu.com?part=3D2
