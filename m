Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18D036A34D
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785754131; cv=none; b=eN0g3rp1blfA1oPUKAz2EiZ0EYYqEgNL1S9l+VpDa3ibz2V5GgqKmYf0Y6v2/rRnKnbBojTcUxBkPTDHFXTR3hQR96w3S+3vY8RDKa5zQFsppwmY1NU628F7r6FfyFTl/vtPwu7fbVjoKlsBmRUF8jp2kD0yecdVskG9EgUrT6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785754131; c=relaxed/simple;
	bh=gUMjniiyde6k9hmlGbiXo+fXV3njWQjqHPxyrZsEOpE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qfA62/LNGKTSEbTKVq4hPsToi0IEQUCPbI/fRNjSB3c8qu84tMUYmHqIUdzJf5MgBqKdErEv2AtIz8a8sfmcQTxUd3AnY0NWBXCKHJk0LcJJ5kps/9xZgLvgYMtRYZQitWtYejX0Ue/l9/FKFRf8POMf295/ssf1airQEbhmlrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V1qBPN4r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V1qBPN4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8BC1F000E9;
	Mon,  3 Aug 2026 10:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785754129;
	bh=rXXwkXgMcyIhS3W8HVXrXVbD8XdfYxJyHkFyU6vzqd4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V1qBPN4rIvkDGNRybRhFNs1SZmdiGfnE1cn60QGcKQVeKoTK1xl1BQJ3pQYYhuM3b
	 LLAYIW1ifgnSeqwy199LUwKFGlWbR4Afza//6Ob7NBr/Qbmf/G/af0RuTaEW/nDclL
	 gQONp2vK7AuuPx//1Sl5LtwW2pvnmfJN76zz0+Ryrxo4uMqX0ZpyXswxTWgwphrBiy
	 XmjQgcUL8V5iBq9X3ZpD2ERfT0imks1fgAYs9j3kHxcV8iARZ1/E31I0t27VRD8f44
	 vIJKHJbmgn7fgO4dYFnvUiVES1L1dTwY4RNbS0EPlwF3JetnWFuVIf20LxGxmJuQIY
	 yEus9Vzjaxreg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/20] KVM: arm64: Add a range to pKVM ownership
 selftest
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260803100904.3563942-12-vdonnefort@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-12-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 10:48:48 +0000
Message-Id: <20260803104848.EF8BC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The pKVM ownership selftest crashes the hypervisor during boot whe=
n testing block-granular ranges.
--

--- Patch [11]: [PATCH 11/20] KVM: arm64: Add a range to pKVM ownership sel=
ftest ---
commit e6586b2867cba4559d50173770f2de71da4f2380
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add a range to pKVM ownership selftest

Extends pkvm_ownership_selftest() with a nr_pages argument to test state
transitions with both page-granular and block-granular ranges.

> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/n=
vhe/mem_protect.c
> index a53600c853d4f..d5ee079a5d70d 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
[ ... ]
> @@ -1894,10 +1901,10 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtabl=
e_pfn, unsigned long pgtable_nr
> =20
>  	selftest_state.host =3D PKVM_PAGE_OWNED;
>  	selftest_state.guest[0] =3D PKVM_POISON;
>  	assert_transition_res(0,	__pkvm_host_force_reclaim_page_guest, phys);

[Severity: High]
Will this crash the hypervisor during boot when testing block-granular rang=
es?

When the selftest executes with a block-level range via PMD_ORDER, this
assertion expects __pkvm_host_force_reclaim_page_guest() to return 0. Howev=
er,
__pkvm_host_force_reclaim_page_guest() hardcodes PAGE_SIZE internally:

arch/arm64/kvm/hyp/nvhe/mem_protect.c:__pkvm_host_force_reclaim_page_guest(=
) {
    ...
    ret =3D get_valid_guest_pte(vm, ipa, PAGE_SIZE, &pte, &pa);
    ...
}

Because the mapping installed for this run is block-granular,
get_valid_guest_pte() will return -E2BIG. This causes assert_transition_res=
()
to fail, which triggers a WARN_ON at EL2. Since WARN_ON expands to a fatal
BRK instruction at EL2, this results in a hypervisor panic during boot.

[ ... ]
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index a9645480d1648..4d41a16cd5962 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
[ ... ]
> @@ -274,17 +283,9 @@ void __init pkvm_ownership_selftest(void)
>  	/* Memory for the VM page-table */
>  	pgtable =3D __get_free_pages(GFP_KERNEL, pgtable_order);
>  	if (!pgtable)
> -		goto out;
> -
> -	/* Page whose ownership will be tested */
> -	page =3D __get_free_page(GFP_KERNEL);
> -	if (!page)
> -		goto out;
> +		return;
> =20
> -	ret =3D kvm_call_hyp_nvhe(__pkvm_ownership_selftest, virt_to_pfn((void =
*)page),
> -				virt_to_pfn((void *)pgtable), 1 << pgtable_order);
> -out:
> -	if (ret)
> -		kvm_err("Failed to run %s (%ld)\n", __func__, ret);
> +	__pkvm_ownership_selftest(0, pgtable, pgtable_order);
> +	__pkvm_ownership_selftest(PMD_ORDER, pgtable, pgtable_order);
> =20
>  	free_pages(pgtable, pgtable_order);
> -	free_page(page);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803100904.3563=
942-1-vdonnefort@google.com?part=3D11
