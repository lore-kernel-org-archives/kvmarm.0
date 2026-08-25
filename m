Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E710223DCE;
	Tue, 25 Aug 2026 21:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787693735; cv=none; b=ucAWh4Ot4PBVGX07+i7bPrn4e0X7hBNaOUT97QkhMF4xThPMHHppuIMugx+bV4joAJ7aSJyuSBdV8kU9JiWaTEFhLVCgcqQG4m8vLck1gQEtTxhlpiJMoBYIa3nQmJdaredmu1dylfCAdS6uJtP1nUfm4oNXYRuO0xPKzsHFbeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787693735; c=relaxed/simple;
	bh=NqrMOfghVkNplVUEoZ5Q1ymaYD69QuEHLz/4UF2Klis=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=q3yQ5fqV2B4atR5mcUTUGpH8eqH9Sn9J6NUL4eqUS6t9LZ7akUzQqjsPBZJA5M2thXZI0OJDTGQIXJW74/t1CQwPVvM53T9o1Yl5YCli6n2fWDH2y9gRe1Y3SkIiEj105znFsi36aUPZ0BTOrqU71xX3LpUWEfr+CmNTT1JPhnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oQpES3dg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oQpES3dg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4A41F000E9;
	Tue, 25 Aug 2026 21:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787693734;
	bh=Q1eluOI9pIfzpYEWXuxjUMf31Wo2OrrIg3ILpE7Fc9M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oQpES3dgb6GMzsVvoLTJMG2ry7SW3CVLAtAdnoxzljd6rV6jpKztSJMsK1gKlE3Eu
	 WVvwfW1ESawRmv2EZKw/ptDP0tGOy5UJ/JXLciGa9zuJhWWbXBMhz7D+/vMu6vGO4H
	 vuqU2tl9V5kRCoJPjNrUlqRGeapu11zxL3lwQj81F8a0NWWQfrAn2GC5htQP2+bbMK
	 zgHyCg/BP9L68pv7E3t4vtkU8uuCASQ50dBJuCJ983fhobeNwDjFrkf2ddmTaLfQsZ
	 Grz9Hfg/alrDBD52uEo6Tr6QN7uCZ+3wisqjy39c0lT0S96ZhS7vQHUYx/0GR09Hrl
	 R4Jgu0BkF74oA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] KVM: selftest: arm64: Support 5-level paging in
 stage 1 translation table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Itaru Kitayama" <itaru.kitayama@fujitsu.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260826-arm64-52bit-va-v1-1-14ec98211363@fujitsu.com>
References: <20260826-arm64-52bit-va-v1-0-14ec98211363@fujitsu.com>
 <20260826-arm64-52bit-va-v1-1-14ec98211363@fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 21:35:33 +0000
Message-Id: <20260825213534.0D4A41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The page table dump function `pte_dump()` is missing the 'p4d' stri=
ng for 5-level paging.
--

commit a04aa92b1663291806024b3dd2c32f253a43baf3
Author: Itaru Kitayama <itaru.kitayama@fujitsu.com>

KVM: selftest: arm64: Support 5-level paging in stage 1 translation table

Add p4d_index() for when 5-level paging required, i.e., V52 guest mode
IDs. With the index helper function, _virt_pg_map() handles 5-level
paging case, and aarch64_vcpu_setup() now is aware of the new V52 guest
mode IDs.

> diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/te=
sting/selftests/kvm/lib/arm64/processor.c
> index 01325bf4d36fc..9108e14a9b5be 100644
> --- a/tools/testing/selftests/kvm/lib/arm64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
[ ... ]
> @@ -182,18 +200,35 @@ void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva,=
 gpa_t gpa)
> =20
>  u64 *virt_get_pte_hva_at_level(struct kvm_vm *vm, gva_t gva, int level)
>  {
> +	int start_level =3D 4 - vm->mmu.pgtable_levels;
>  	u64 *ptep;
> =20
> +	TEST_ASSERT(level >=3D start_level && level <=3D 3,
> +		    "Invalid translation level %d, valid range is %d-3",
> +		    level, start_level);
> +
>  	if (!vm->mmu.pgd_created)
>  		goto unmapped_gva;
> =20
>  	ptep =3D addr_gpa2hva(vm, vm->mmu.pgd) + pgd_index(vm, gva) * 8;
>  	if (!ptep)
>  		goto unmapped_gva;
> -	if (level =3D=3D 0)
> +	/*
> +	 * Stage-1 translation starts at level -1 for a five-level page
> +	 * table, and at levels 0, 1, or 2 for four-, three-, or two-level
> +	 * page tables, respectively.
> +	 */
> +	if (level =3D=3D start_level)
>  		return ptep;
> =20
>  	switch (vm->mmu.pgtable_levels) {
> +	case 5:
> +		ptep =3D addr_gpa2hva(vm, pte_addr(vm, *ptep)) + p4d_index(vm, gva) * =
8;
> +		if (!ptep)
> +			goto unmapped_gva;
> +		if (level =3D=3D 0)
> +			break;
> +		/* fall through */
>  	case 4:

[Severity: Low]
Does pte_dump() also need to be updated to handle the new p4d level?

In tools/testing/selftests/kvm/lib/arm64/processor.c:pte_dump():

	static const char * const type[] =3D { "", "pud", "pmd", "pte" };

With 5-level paging enabled, virt_arch_dump() starts with level 0. The
pte_dump() function will access index 0 and print an empty string instead
of "p4d".

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260826-arm64-52bi=
t-va-v1-0-14ec98211363@fujitsu.com?part=3D1
