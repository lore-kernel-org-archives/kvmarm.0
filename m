Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCE63CF1F6
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 13:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784294939; cv=none; b=CJxB9CgDgulI96ORY5Axjl34qGGoviK9IdwUekf2vNiJuxBMaYqf/fcWPnXwVL9wEV2NQuZVN3A+lvicEidvuuujSI4Y1SrjFLA5yq2xBlBN/pNdO1yZd2sgIpseFeW11jsaZJYgeUfHZQg0AzPHJSCdKUG+SLjbGs5yP/a3qEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784294939; c=relaxed/simple;
	bh=D7PM/ZzBAS9t9HD80CKRfuPk9Uslcgx8iEYHjqSDAdk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=E5RzwUt6MIbAiokfB7eZ+/1MLdaeiFhQbcOxpnjl8JOKOyX7gmNcPqNgQCTUf9U1DzmI7jHs/NHFCVL6s3AVrQm3xMkZWYm/mvM0IxqTBqSg89ES47cjoFg8IlhMeqPm8vtNu9sNhVLZfOtefpvX9wo7rm0J+heI70i6hqg8/o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FCBm5Ai6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FCBm5Ai6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC30A1F00A3A;
	Fri, 17 Jul 2026 13:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784294937;
	bh=c6mKG2ts+um8cgAdlZAQhhvJZnKwix90IvV4LuoKtzs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FCBm5Ai6d7+B/gfWFLrhU5Cj9xAGDxaDTjD86yoKI11mYu2mlYXIObdZLUIg4Jxqk
	 1Aa5aaV2K9zSo/KRL7LOjWLro+YqbdMt3RhT0P7SLqrvqOUm0mYr7z/zXMZgbejHKq
	 ffgqZ/nO+oX5B4F06JVBOhihkz+55K3Ykz7j9fhKqyFZY9vyyoXvauWmTIUFhUwEXx
	 qtlGSVIzjS8no/XlMUkUN61dBhjVvTjHmuO8IVpaTv+rck7A12/HeYG5Cu9cvTSaLO
	 X/NuPuLhumOzoC2tOFOwgP0QWJzj8Dg78keHJ8eeIvWa6UxWxzF1Kf8DWvBPIBOHNs
	 j6iGN3l8Gz/6w==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 2/2] KVM: arm64: Support BBM level 3
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260717130901.2239134-3-smostafa@google.com>
References: <20260717130901.2239134-1-smostafa@google.com>
 <20260717130901.2239134-3-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 13:28:57 +0000
Message-Id: <20260717132857.AC30A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Replacing a block mapping with an empty table mapping using BB=
ML3 violates architectural requirements and causes TLB conflict aborts.
--

--- Patch [2]: [RFC PATCH 2/2] KVM: arm64: Support BBM level 3 ---
commit ea79cffc563af3beac80c1a139cbab5674ecb7f0
Author: Mostafa Saleh <smostafa@google.com>

KVM: arm64: Support BBM level 3

This patch introduces support for hardware Break-Before-Make (BBM) level 3
to replace stage-2 PTEs directly instead of using the software sequence.
It atomically updates the PTE and relies on hardware features to handle
the transition.

> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c

[ ... ]

> @@ -1069,7 +1102,10 @@ static int stage2_map_walk_leaf(const struct kvm_p=
gtable_visit_ctx *ctx,
>  	 * will be mapped lazily.
>  	 */
>  	new =3D kvm_init_table_pte(childp, mm_ops);
> -	stage2_make_pte(ctx, new);
> +	if (!stage2_make_pte(ctx, data->mmu, new)) {
> +		mm_ops->put_page(childp);
> +		return -EAGAIN;
> +	}
> =20
>  	return 0;
>  }

[Severity: Critical]
Does using BBML3 to replace a block mapping with an empty table mapping risk
a TLB conflict abort?

In stage2_map_walk_leaf(), the code allocates a zeroed page for the new
table and installs it. With BBML3, stage2_make_pte() atomically overwrites
the valid block PTE with the new empty table PTE, bypassing the software
break step.

Because the new table is unpopulated, if another CPU takes a stage-2 fault
on this range before the TLBI completes, it can populate a 4KB page in the
new table. That CPU will then cache the new 4KB mapping while still holding
the old 2MB block mapping in its TLB. The overlapping entries will trigger
a fatal TLB Conflict Abort, panicking the host.

Would it be necessary to either fall back to the software break-before-make
sequence when splitting a block, or ensure the new table is populated with
equivalent translations before the atomic swap?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717130901.2239=
134-1-smostafa@google.com?part=3D2
