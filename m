Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3493822A6
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 13:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783518614; cv=none; b=OHRI7fLf280Vz0SGxFK060ILMAPMAlW59sHYK5YOGeB0dcERKvgDiyl35pQZKM2772fmMDdpruSZ7HOauJ0r0e0Tf/wSRM7fqVHbBKGBldbWwmjnAWbcfFh4Wtz/2CHI4/ZwdIIoTEgtNzEhUD48IdHxQMr2iqo+SleRsNbyj5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783518614; c=relaxed/simple;
	bh=NdtvlDHhVoj+GEBoivRewltS3/8ML2WhEd2DeXFekHc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mR7wnPBeeszOQ03L7Es3RuGdsxuxAowyrblTiDww0X0cjb/YgFb+PzSxYG13dCXn1mGJ/INmlarB/vSG76VpKiK4S5fL6jzvlWRT1XqTubD8CJVs7iovYaKm12jDi7kAAJS1NaphwvIYIWPmBd9OkaTRPWOU5ImmhRZQq21p83A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+ti0UO+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+ti0UO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B21A1F000E9;
	Wed,  8 Jul 2026 13:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783518612;
	bh=yfnnuXgTfosh8s6hZgitwKpSAbQ8wwLi/t85YcCkBPM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D+ti0UO++sQMk46Zd9yuiMjfYySMf1uadh3zka6Qk5u6f8IMl1ofSB35hE/ljVwOy
	 YT9S9cS6/SgihVs8k2RoBQBCZhyBDT3rFTXvSexHYfM8PSwH51ia9GvTgjyEHd/qXi
	 B+dXlS6lSSQf7ItFQGfO9ALAmTzXcQVACw72aXyw6Lx5gk++6CXKf4G+xn1sUVKq13
	 96uGTJY9Vr2u/YgotxL82thtKUbsqyYAgCJksFbQquTviBUr3zg6s/5S0iJ7BrCNdW
	 6giKNvXSRWKOt3sjKnxBlJlSQbdyD/c6Fo8aDT2MqwB9nkDmOgi12PinHWzEY+Tmu7
	 KIbjz7YDRoxHg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/3] KVM: arm64: Introduce
 KVM_PGTABLE_WALK_SKIP_LEVEL* walk flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260708134101.2514759-3-leo.bras@arm.com>
References: <20260708134101.2514759-1-leo.bras@arm.com>
 <20260708134101.2514759-3-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 13:50:11 +0000
Message-Id: <20260708135012.3B21A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] KVM_PGTABLE_WALK_SKIP_LEVEL* flags fail to skip the starting roo=
t level of the page table walk.
--

--- Patch [2]: [PATCH v3 2/3] KVM: arm64: Introduce KVM_PGTABLE_WALK_SKIP_L=
EVEL* walk flags ---
commit 5ddf63ba492be8c2a84af0b81cf00790fc72767a
Author: Leonardo Bras <leo.bras@arm.com>

KVM: arm64: Introduce KVM_PGTABLE_WALK_SKIP_LEVEL* walk flags

This commit adds new walking flags that tell kvm_pgtable_walk() to skip
lower levels when traversing page tables.

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 4be1d51a6ac58..b9a2078efc519 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c

[ ... ]

> @@ -192,7 +205,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgta=
ble_walk_data *data,
>  	if (!kvm_pgtable_walk_continue(data->walker, ret))
>  		return ret;
> =20
> -	if (!table) {
> +	if (!table || kvm_pgtable_skip_level(level + 1, ctx.flags)) {

[Severity: Medium]
Does this fail to skip the starting level of the page table walk if that
initial level matches the skip criteria?

Looking at __kvm_pgtable_visit() in arch/arm64/kvm/hyp/pgtable.c, the visit=
or
callbacks are executed unconditionally for the current level before we reach
this skip check:

	if (table && (ctx.flags & KVM_PGTABLE_WALK_TABLE_PRE)) {
		ret =3D kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_TABLE_PRE);
		reload =3D true;
	}

	if (!table && (ctx.flags & KVM_PGTABLE_WALK_LEAF)) {
		ret =3D kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_LEAF);
		reload =3D true;
	}

Since the skip condition here only evaluates level + 1 to prevent descending
further, if a caller begins a walk at a level that should be skipped (for
example, starting at level 2 with KVM_PGTABLE_WALK_SKIP_LEVEL2), the callba=
cks
for that root level will still execute.=20

Should the current level also be checked against the skip flags before
executing the pre-table or leaf visitor callbacks?

>  		data->addr =3D ALIGN_DOWN(data->addr, kvm_granule_size(level));
>  		data->addr +=3D kvm_granule_size(level);
>  		goto out;

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708134101.2514=
759-1-leo.bras@arm.com?part=3D2
