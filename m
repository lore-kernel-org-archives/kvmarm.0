Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83D627A107
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 20:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781123444; cv=none; b=LO+u75R0U3s41Z3oSjBVM1Vy5qQjUUmEQIICfPRF0v+89M1cDbnvIaA5TF2+2vIZiMO8RjLBEB9t83MX1Ay0gqMp5yeiUnut813ARigEqCL8kDp7cawQWf0K8KTxHl6SxKAk+8+O2Smtp9qbKTAI/nowGJhbdBGAjuKaBVWcivU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781123444; c=relaxed/simple;
	bh=io4DErpT7j9FBKPlgB16R1dMXi36i7ZZuaof+7Ag4sk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HfknPNRXR4Po75m0rSn3b0e+1c/lnN29nNF9lmvHgNfj/tD2ztndNiS81xho9S4Cw7OwRNY+RO7+p3nLDdRvPC/kc5Yd6AsidRu4dslX9J/jisiEUAUmA4BXLp1+o93GuuyWjOC9QVrnbyaN4oUQvtQhb9+auhGPiD97qVkc2kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L8elpGTf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L8elpGTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A771F00893;
	Wed, 10 Jun 2026 20:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781123443;
	bh=HkfGUPH2y/I7/TGAcTLb+4qwkQpyWfSkLKBwO8SpGso=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L8elpGTfW/4w+Rbpzw7cYccc1UakhnGErqAMoF99eCI9mgr1Hjrb5S5Zm3nu6o58n
	 P08SOUvVswWdnmgQITNWAn3Nscw134VYon5S266yppOmkiDrD2BgCxAnA9rC/habGH
	 nws9aIPxhfDoHEXashOc7DbSeIre7Jot7w+8QEkrTvBzPoq0a2TPnnyinnOtbuqHJD
	 wU+GsD46aGVFeYLwuqHP6q9EXIzRrTd9hT3X1iRDgkb7JHBxmrtn0lo+FBxemnTZNO
	 cFmxkNgZsGe2WQ/84dp+wof1ZUsHl4GWrImNGuS0zFHcnnvAywnTRJ7xXfaPEzdk+L
	 fRmiBgGOEXHHg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 1/2] KVM: arm64: Introduce
 KVM_PGTABLE_WALK_SKIP_LEVEL* walk flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260610202112.2695205-3-leo.bras@arm.com>
References: <20260610202112.2695205-3-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 10 Jun 2026 20:30:42 +0000
Message-Id: <20260610203043.25A771F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] Combining skip flags causes the walker to ignore the more restri=
ctive skip levels due to fls() usage.
- [Medium] Skipping a page table level bypasses the KVM_PGTABLE_WALK_TABLE_=
POST callback, breaking PRE/POST callback symmetry.
- [Low] The skip logic cannot prevent the root level from being visited, ma=
king SKIP_LEVEL0 ineffective when start_level =3D=3D 0.
--

commit 4e6415e54e22d985a0c97622b8e8b28b4c84b54b
Author: Leonardo Bras <leo.bras@arm.com>

KVM: arm64: Introduce KVM_PGTABLE_WALK_SKIP_LEVEL* walk flags

Add the new walking flags that tell kvm_pgtable_walk() to skip lower levels
when walking the pagetables.

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 91a7dfad66866..48d88a290a538 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c

[ ... ]

> @@ -144,6 +144,19 @@ static bool kvm_pgtable_walk_continue(const struct k=
vm_pgtable_walker *walker,
>  	return !r;
>  }
> =20
> +static __always_inline bool kvm_pgtable_skip_level(s8 level, enum kvm_pg=
table_walk_flags flags)
> +{
> +	flags &=3D KVM_PGTABLE_WALK_SKIP_LEVELS;
> +
> +	if (likely(!flags))
> +		return false;
> +
> +	if (level >=3D (fls(flags) - ffs(KVM_PGTABLE_WALK_SKIP_LEVELS)))

[Severity: Medium]
Will this evaluate to the highest level if multiple skip flags are ORed
together?

If a caller combines flags like KVM_PGTABLE_WALK_SKIP_LEVEL1 and
KVM_PGTABLE_WALK_SKIP_LEVEL2, fls() will select the highest set bit. This
means the threshold evaluates to level 2, effectively ignoring the more
restrictive SKIP_LEVEL1 flag and incorrectly descending into levels the
caller requested to skip.

Should kvm_pgtable_skip_level() use ffs() instead of fls() to select the
lowest requested level as the definitive stopping point?

> +		return true;
> +
> +	return false;
> +}

[ ... ]

> @@ -192,7 +205,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgta=
ble_walk_data *data,
>  	if (!kvm_pgtable_walk_continue(data->walker, ret))
>  		goto out;
> =20
> -	if (!table) {
> +	if (!table || kvm_pgtable_skip_level(level + 1, ctx.flags)) {

[Severity: Medium]
Does skipping the level here bypass the KVM_PGTABLE_WALK_TABLE_POST callbac=
k?

If the current entry is a table, the KVM_PGTABLE_WALK_TABLE_PRE callback is
executed earlier in __kvm_pgtable_visit(). If kvm_pgtable_skip_level() then
evaluates to true, the code executes an early exit via goto out.

This completely bypasses the KVM_PGTABLE_WALK_TABLE_POST callback at the
end of the function, leaving the TABLE_PRE call unbalanced. If a walker
relies on symmetric PRE and POST callbacks to clean up resources or track
traversal depth, could this asymmetric execution flow lead to resource leaks
or state inconsistency?

[Severity: Low]
Does checking level + 1 prevent the root level from being skipped?

The walker unconditionally calls __kvm_pgtable_visit() for entries at the
root page table (start_level). Because the skip evaluation checks level + 1,
it only governs whether the walker descends into the children of the current
level.

If start_level =3D=3D 0 and the walker requests SKIP_LEVEL0, won't the walk=
er
still visit level 0 and invoke its callbacks, making SKIP_LEVEL0 functional=
ly
identical to SKIP_LEVEL1 in this case?

>  		data->addr =3D ALIGN_DOWN(data->addr, kvm_granule_size(level));
>  		data->addr +=3D kvm_granule_size(level);
>  		goto out;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260610202112.2695=
205-2-leo.bras@arm.com?part=3D1
