Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BED3603DF;
	Thu,  3 Sep 2026 02:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788403400; cv=none; b=uOBjInLxj8BxZffHoGcQonKdH0n1VrqM8eeNcqB+JWmWr89GIRzLH4WMoGOMA/4a36/sF/rH5CnV9MXnnDd6WffGg3NkdBRdsS6eINwNV0gbtXCqNjIbxNzBXlnhqUvtG6hsPQvfWNzW+USWKQynPstRtZCllWT7LiNkgB2GEMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788403400; c=relaxed/simple;
	bh=AasAC1gxzv4J5euJBthw2qlwrGJ/HW/z3+aHvYL5dr0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WnrK7T2pO/IgAk8BqYzJ07JnElZKXO8RozS564jI05/7RukkDRfz+MVxkaGulpyRGG+9OwzR2Uznb1Bh6xmPEatCB0iC0siXMGst1mU52626EtVKD/Z0qx8ucICLwMnt0WgpZeqRxqhFy9Yd5U3NZfwwCY25rCZigNaXnj1Vu9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GGkcmAIK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GGkcmAIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE041F000E9;
	Thu,  3 Sep 2026 02:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788403398;
	bh=AWzC9HaHKHX91r9aWxxVIw3eOC137V5YmrW8ADBkFtA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GGkcmAIKxK92EciGhI7uSlYlRY+arDpHRWC/0rigWOIlY7bnWSoAQEB1MSebq5MVl
	 208cEyXNPb8j9N14LDAYoqI2P7LLr8RjopkrKSabJoQ/NNQtdzJ2z3QDDZdYTzv+yS
	 CwmNChUreHz/Gb6vE5cuMGAHQfmK+yamXTTQxodPt5n45ygAwVjDlAfiek0x0W5JOc
	 3hz62Cj9tfQIqeVDajIfKbj0ShOy6PKvdxTMq8YEFExjgZn2kBkpYe1R+Ropz+pdn1
	 +eD1Nn6Hj6wXtXe2UlsXNjVjj7+ganhE1Y9L3ODjGRkxNU6sas+cO1Pi7KRHT/F5AG
	 vY78stuT2tcCA==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 1/3] luo: Move to feature flags instead of
 compatibility strings
Reply-To: sashiko-reviews@lists.linux.dev
To: "Logan Odell" <loganodell@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-pci@vger.kernel.org
In-Reply-To: <20260903023452.721732-2-loganodell@google.com>
References: <20260903023452.721732-1-loganodell@google.com>
 <20260903023452.721732-2-loganodell@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 02:43:17 +0000
Message-Id: <20260903024317.AFE041F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing payload length validation before accessing feature-depende=
nt fields in `luo_ser`, leading to out-of-bounds reads.
--

commit 8e63def24ae09c6e2674a2bd48e32ef12916dd48
Author: Logan Odell <loganodell@google.com>

luo: Move to feature flags instead of compatibility strings

This commit replaces the compatibility string check with a 128-byte feature
header in the live update serialization structure. It introduces flags for
supported, required, and active features to allow for more flexible structu=
re
evolution.

> diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
> --- a/kernel/liveupdate/luo_core.c
> +++ b/kernel/liveupdate/luo_core.c
> @@ -107,26 +107,37 @@ static int __init luo_early_startup(void)
>  		return 0;
>  	}
> =20
> -	if (len < sizeof(*luo_ser)) {
> -		pr_err("LUO state is too small (%zu < %zu)\n", len, sizeof(*luo_ser));
> -		return -EINVAL;
> +	luo_ser =3D phys_to_virt(luo_ser_phys);
> +
> +	if (len < sizeof(struct luo_feature_hdr)) {

[Severity: High]
In luo_early_startup() in kernel/liveupdate/luo_core.c, does this code
sufficiently validate the payload length?

Since len is only checked against the size of struct luo_feature_hdr, it se=
ems
the check for the full struct luo_ser size has been removed.

> +		pr_err("LUO state is too small (%zu < %zu)\n",
> +		       len, sizeof(struct luo_feature_hdr));
> +		err =3D -EINVAL;
> +		goto out_free_ser;
>  	}

[ ... ]

> +	if (LUO_FEATURE_IS_ACTIVE(luo_ser, LUO_FEATURE_NUMBER)) {
> +		luo_global.liveupdate_num =3D luo_ser->liveupdate_num;

[Severity: High]
Can this access memory out of bounds?

If the payload length from KHO is large enough to pass the header check but
smaller than the full structure size, this will read luo_ser->liveupdate_num
beyond the validated length.

> +		pr_info("Retrieved live update data, liveupdate number: %lld\n",
> +			luo_global.liveupdate_num);
> +	}
> =20
> -	err =3D luo_session_setup_incoming(luo_ser->sessions_pa);
> -	if (err)
> -		goto out_free_ser;
> =20
> -	luo_flb_setup_incoming(luo_ser->flbs_pa);
> +	if (LUO_FEATURE_IS_ACTIVE(luo_ser, LUO_FEATURE_SESSIONS)) {
> +		err =3D luo_session_setup_incoming(luo_ser->sessions_pa);

[Severity: High]
Can this result in the use of uninitialized or garbage data?

If len does not cover the sessions_pa field, reading it could yield a garba=
ge
physical address that luo_session_setup_incoming() might then dereference,
leading to a panic or state corruption during boot.

> +		if (err)
> +			goto out_free_ser;
> +	}
> +
> +	if (LUO_FEATURE_IS_ACTIVE(luo_ser, LUO_FEATURE_FLBS))
> +		luo_flb_setup_incoming(luo_ser->flbs_pa);

[Severity: High]
Does this code pass a garbage address to luo_flb_setup_incoming()?

Accessing luo_ser->flbs_pa could read beyond the payload if len is smaller
than the full struct luo_ser size.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903023452.7217=
32-1-loganodell@google.com?part=3D1
