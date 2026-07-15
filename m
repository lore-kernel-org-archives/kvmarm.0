Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0677339526F;
	Wed, 15 Jul 2026 14:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784126957; cv=none; b=Ypgcff/cQYjS0LdIDTuJ9IV4z15m3eGMn6WMn9r10AJBNb/6HIyn0aLIDLY9a/NAqAMW6a8AR3sEPvAlBrN6MI6/QF9D8nC2j/X+03+rvVFCMr0ktNmgDlvebtfb26Y+rVwGT1hn52axOpPAsf+SNO6NP1oRy+3rrwIG/AAKHYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784126957; c=relaxed/simple;
	bh=yyGJ4DrZgOe2iZnefaTsnMU0pVUwSGK+yQmYFfCItcU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bCewCuao6K7kibRXsavNO6IZJiCsbkRqPph8nZg6bNgaxL4TH9UhPD1BvPSEREJ/doVJXcuqFuZDBzA/b3eBiP6I6dKW/154DVhQjbXmXJPbQV8s6ird4lhtcXK5wo20fe8vrT/OvMD9gntygVH6CZ+elupqg9dmQJc5i1XVt5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HYJhWCvy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HYJhWCvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5771F1F000E9;
	Wed, 15 Jul 2026 14:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784126955;
	bh=KMiJdsxzj84vOmNmZPgPOYwSNU5OsjN9G9d+G1VDAuM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HYJhWCvyTv+dzYGhD0GsXsJl4HnT7UtIqu5X03RgenLiaBGkXoYUCpfKG75YSlVh5
	 mMnOBwnq6xhfLc8tz51UoYNmMGtPEsOiROQhR2dv2y4CordB4VKrk4SoIB9TMGJcLE
	 GS5QaMv3j0eEgwiZdWN6D7CTjoXJ9/uWzf2ZPZrCEON+EE3Ip/bUkZdUAgc5vtDr56
	 GYI/P49cGKbq9ljrLiKnnsR9jgVaLmCwgAkbKi4tcysXzHvF/9U/OaYLyQOmjRovXt
	 kwiMbWb9UF/XK/NlNCLlHQ5jUObHvhwumUl4XohbzW/ABstbYWLeh22DGAIhH4x+73
	 CotOh1rzYbaXg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/6] firmware: arm_rmm: Add wrappers for direct RMI
 calls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260715142739.80398-3-steven.price@arm.com>
References: <20260715142739.80398-1-steven.price@arm.com>
 <20260715142739.80398-3-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 14:49:14 +0000
Message-Id: <20260715144915.5771F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Uninitialized stack variable read in `rmi_granule_tracking_get` =
and `rmi_features` on systems without SMCCC conduit.
--

--- Patch [2]: [PATCH 2/6] firmware: arm_rmm: Add wrappers for direct RMI c=
alls ---
commit 429eeeda61aa453a82790a92c189fa7325a46943
Author: Steven Price <steven.price@arm.com>

firmware: arm_rmm: Add wrappers for direct RMI calls

This commit adds inline wrapper functions for direct RMI calls to the Realm
Management Monitor (RMM) via SMCCC, dealing with boilerplate and return cod=
es.

> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
> new file mode 100644
> index 0000000000000..c038c1d685fad
> --- /dev/null
> +++ b/include/linux/arm-rmi-cmds.h

[ ... ]

> +static inline int rmi_granule_tracking_get(unsigned long start,
> +					   unsigned long end,
> +					   unsigned long *out_category,
> +					   unsigned long *out_state,
> +					   unsigned long *out_top)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_GRANULE_TRACKING_GET, start, end, &res);
> +
> +	if (out_category)
> +		*out_category =3D res.a1;
> +	if (out_state)
> +		*out_state =3D res.a2;
> +	if (out_top)
> +		*out_top =3D res.a3;

[Severity: Medium]
Could this copy uninitialized stack memory into the caller's output pointers
if the SMCCC conduit is unavailable?

When arm_smccc_1_1_invoke is executed on a platform without an active
conduit, it falls back to __fail_smccc_1_1():

include/linux/arm-smccc.h:arm_smccc_1_1_invoke() {
        ...
        default:
                __fail_smccc_1_1(__VA_ARGS__);
                method =3D SMCCC_CONDUIT_NONE;
                break;
        ...
}

This fallback only initializes res.a0 to SMCCC_RET_NOT_SUPPORTED, leaving
res.a1, res.a2, and res.a3 completely uninitialized.

Because these values are read unconditionally here, this could trigger KMSAN
warnings or leak stack garbage into the output pointers. Should these
assignments be gated behind a check that res.a0 =3D=3D RMI_SUCCESS?

> +
> +	return res.a0;
> +}

[ ... ]

> +static inline int rmi_features(unsigned long index, unsigned long *out)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_FEATURES, index, &res);
> +
> +	if (out)
> +		*out =3D res.a1;

[Severity: Medium]
Does this have the same uninitialized memory read issue when the SMCCC
conduit is not supported?

> +	return res.a0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715142739.8039=
8-1-steven.price@arm.com?part=3D2
