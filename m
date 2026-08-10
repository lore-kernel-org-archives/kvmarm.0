Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB14D431A4C
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 17:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786383791; cv=none; b=hMMLic9n7zrKdV2OAUbzofeZwtQxQdP635pmkkUpQWTVzZ/iu2Lmlr6LdfVVAZxXSDxQjr4MbxgZjEitpHgp3PZcJDBN9CgdqbTJezwm45W7DxpzuKix1589SHBLwnRNz/wD3mcNbHb6ehO+QU15zI/nGwTTGaBzcoCx18RIJ8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786383791; c=relaxed/simple;
	bh=TUQpseQRTonLTdk/1DS3RLF6IYz8ALRifK/SoKSqb3A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Gh83tK6Ap+E8DT24lnPvTmjS0oqonM3ZxCew5CUqp8dyFGMCPOsaGwBA4sdV4G0vcnmJEtXRt6MSUI5zFzfxvB6TZLjxnKEZEUIttahnNWak5iclvKgz+Ygbsxl9SwXq+assIG14uxe/+SeLE3TKRoACQVZgPzyRfUNFDNRPG0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k549jCVw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k549jCVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D041F000E9;
	Mon, 10 Aug 2026 17:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786383789;
	bh=1M7Dedp6di4GEIN3gytdr14KngBXfmJWeXyYy28Em70=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k549jCVw+aJPdFgw6ImD0/K34Dk/gP+ExLplQbmE1gk3FfATK/UhfjZ5CPx0AAcMs
	 esKw435RdaOeNmLWQa2uGXu9JfsaGcswC/GAcOFyqErZWmfrjHlcwSL6TaNBPy2dzh
	 23hF2QJWka5JxZsmlklrBhD6sGcUW9FTnySI01CLA+crjHVr1E9VH5iOZEFeigoBO7
	 6+Sg+Uq5hKVyI8w4xhCA12SLQuTRdIT5caCN/LyK/DtN9b7Gp9mJxK74/VpDG9nsMj
	 +qQPrG6IBzHaT2DvCQ6nYUwVd0QBhOdFzkhRRVtAdMwSdjpmjd2IUtce2ns0YJD19I
	 Sfk6n3C7jfp/A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: Correctly cap TLBI Range to the architural
 limit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260810170616.746100-1-maz@kernel.org>
References: <20260810170616.746100-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 10 Aug 2026 17:43:08 +0000
Message-Id: <20260810174309.52D041F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Hardcoded BIT(48) cap truncates valid 52-bit IPAs and underflows f=
or higher addresses
- [High] Upper-half range cap `~base + 1` is completely ineffective due to =
missing sign-extension

Pre-existing issues:
- [High] Range TLB invalidations for upper-half VAs silently fail to invali=
date the VNCR cache
- [High] Malicious guests can still trigger a host WARN_ON because the BIT(=
48) cap ignores smaller VM ia_bits
--

--- Patch [1]: [PATCH] KVM: arm64: Correctly cap TLBI Range to the architur=
al limit ---
commit 09ab12a5dd613f7e322a9123897db5c50369508d
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Correctly cap TLBI Range to the architural limit

This commit caps the range of a TLB invalidation based on the base address
to prevent guests from triggering an overflow when the hypervisor adds the
range to the base address.

Link: https://lore.kernel.org/r/yifz3wn5gk5sr6mapi32trgk5m5kp33bquctsjmkife=
bnsnndt@fix6u4rthx4g

> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm=
/kvm_nested.h
> index cdf3e8422ea12..b68806b3bd6e5 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -298,6 +298,12 @@ static inline u64 decode_range_tlbi(u64 val, u64 *ra=
nge, u16 *asid)
>  	num	=3D FIELD_GET(GENMASK(43, 39), val);
>  	*range	=3D __TLBI_RANGE_PAGES(num, scale) << shift;

[Severity: High]
This isn't a bug introduced by this patch, but earlier in
decode_range_tlbi(), base is extracted without sign-extension:

	base =3D (val & GENMASK(36, 0)) << shift;

For upper-half kernel virtual addresses, base will be zero-extended. When
invalidate_vncr_va() in arch/arm64/kvm/nested.c checks if this invalidation
intersects with a cached VNCR TLB (vt->gva), the cached TLB is correctly
sign-extended. The bounds check incorrectly fails due to comparing a
sign-extended gva against a zero-extended scope->va:

	if (va_end <=3D scope->va ||
	    va_start >=3D (scope->va + scope->size))
		continue;

Does this leave stale entries in the VNCR cache and break memory isolation
for nested guests when they invalidate an upper-half VA range via
TLBI RVAE1*?

> +
> +	/* Cap the range to the correct half of the address space */
> +	if (!(base & BIT(48)))
> +		*range =3D min(*range, (BIT(48) - base));

[Severity: High]
Does this hardcoded BIT(48) cap incorrectly truncate valid 52-bit IPAs?

For guests with a 52-bit IPA space (FEAT_LPA), a valid TLB invalidation over
the entire address space (base=3D0, range=3DBIT(52)) appears to be truncate=
d to
BIT(48), potentially leaving stale mappings in the upper 48-52 bits.

Additionally, if the base address exceeds BIT(48) but has bit 48 cleared
(for example, base=3DBIT(49)), won't (BIT(48) - base) underflow to a massive
unsigned value, bypassing the cap and failing to prevent the overflow?

[Severity: High]
This is a pre-existing issue, but since this cap uses BIT(48), can a nested
guest still trigger the host WARN_ON in __unmap_stage2_range() if the VM's
configured PARange (ia_bits) is smaller than 48?

If a guest supplies a base and range that stays below BIT(48) but exceeds
the VM's actual limit (for example, BIT(40)), it seems _kvm_pgtable_walk() =
in
arch/arm64/kvm/hyp/pgtable.c will still return -ERANGE:

	if (data->addr > limit || data->end > limit)
		return -ERANGE;

This bypasses the new cap and can trigger the warning, which could act as a
Denial of Service if panic_on_warn is set.

> +	else
> +		*range =3D min(*range, ~base + 1);

[Severity: High]
Is this upper-half range cap mathematically effective without base being
sign-extended?

Since decode_range_tlbi() leaves base as a positive unsigned 64-bit integer,
~base + 1 evaluates to an extremely large positive value near 2^64. Will
min(*range, ~base + 1) always evaluate to *range, leaving the range uncapped
and still vulnerable to the overflow for upper-half virtual addresses?

> +
>  	return base;
>  }
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260810170616.7461=
00-1-maz@kernel.org?part=3D1
