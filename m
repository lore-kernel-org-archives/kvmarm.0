Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AAB2BEC3F;
	Thu,  3 Sep 2026 02:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788403652; cv=none; b=hdYGMJUwA7UzIcFpDwqxJR5l7SRKQYLBFUu4ousIqa9+OjKpqEkzrXss5sy0ysdoKmoqPJSSldU3z+ZEV9URNawfntnf2khDwJ+Snxp7Dt5QRNCcMpepjf+CmwYayrFyXp1HT5sVCM66UeSRl432KWqc/PVm29TkiGt3Xtnhce4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788403652; c=relaxed/simple;
	bh=OpnKdou88+IcZqqSW3W3biDL5UzOku5KKwGdke/LAYI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XE8B+7OPj73Q5tz3LcpYpuKtQTzYHGaWNAjnzMI7xgQ5uCNpC4+FYrnS1tdqMgGEfgcly6pkZ/bQyapzZCd/9U/uC2AqZ4Pv3DoxRJSTlDFQCol0CkpqY+wgPWCwqgh06TKwXZz7FWtDmXfUKbBxjaMMdQhr0Lp6/mqOf5F9zbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dcRzfJjJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dcRzfJjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC4C1F000E9;
	Thu,  3 Sep 2026 02:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788403651;
	bh=P8rMMcvXoxipWRMWO0eHlgg0VXiHJSCe3OnoD0Y6Pmk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dcRzfJjJ5wWAKwEt+PgrI6gm+lO6sJjOprjBFPADnB/eNLgnGIQRp/0G+RJi5HZ55
	 BJRHox0xcgmElBs6DNFwKvXwawTFZcrqdWNv3JOG9oKKaJ6o24KVqH9RcF4fTxVpqf
	 AASLOjXrmO/dj6Kmo7MCf7see78/l7niXP6LooixIkmhWYLUnnx9zL1egGiJquC43C
	 IaxXAMBsuseCYW4Bn1HknJ1dPCboGi0Vrl5YEv0jOrH63fItNJQt2XKab+9DvcNpxr
	 C6d8A6MKwq68tOewmjFW80NvlO78aNDlHAq79oYoZ4HMoAEX17z8CVXnCtkxAT2+B9
	 G21wCa8yNUAsw==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 3/3] luo: memfd: Move to feature flags instead of
 compatibility strings
Reply-To: sashiko-reviews@lists.linux.dev
To: "Logan Odell" <loganodell@google.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, linux-pci@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260903023452.721732-4-loganodell@google.com>
References: <20260903023452.721732-1-loganodell@google.com>
 <20260903023452.721732-4-loganodell@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 02:47:30 +0000
Message-Id: <20260903024730.BDC4C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Permanent memory leak of preserved KHO vmalloc block and physical =
folios when memfd_luo_retrieve() fails on early error paths.
--

commit 5ce2719ae4caecc0b1ca1429438f4dfe06609564
Author: Logan Odell <loganodell@google.com>

luo: memfd: Move to feature flags instead of compatibility strings

This commit updates the memfd liveupdate serialization structure to use
feature flags instead of compatibility strings. It introduces granular
compatibility checking by validating required features and active flags
during deserialization to prevent unsupported states from being restored.

> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 59de210bee5f9..36ee503672a23 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
[ ... ]
> @@ -526,12 +531,21 @@ static int memfd_luo_retrieve(struct liveupdate_fil=
e_op_args *args)
>  	if (!ser)
>  		return -EINVAL;
> =20
> -	/* Make sure the file only has seals supported by this version. */
> -	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
> +	if (ser->features.req & ~MEMFD_LUO_FEATURES_SUPP) {
> +		pr_err("Unsupported required memfd feature (req: 0x%llx, supp: 0x%llx)=
\n",
> +		       ser->features.req, (u64)MEMFD_LUO_FEATURES_SUPP);
>  		err =3D -EOPNOTSUPP;
>  		goto free_ser;
>  	}
> =20
> +	if (LUO_FEATURE_IS_ACTIVE(ser, MEMFD_LUO_FEATURE_SEALS)) {
> +		/* Make sure the file only has seals supported by this version. */
> +		if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
> +			err =3D -EOPNOTSUPP;
> +			goto free_ser;
> +		}
> +	}
> +

[Severity: High]
This is a pre-existing issue, but does this early error path permanently le=
ak
the preserved KHO vmalloc block and physical folios?

When memfd_luo_retrieve() in mm/memfd_luo.c fails here and jumps to the
free_ser label:

free_ser:
	kho_restore_free(ser);
	return err;

It abruptly frees the serialization struct. Bypassing the restoration of the
vmalloc array and physical folios leaves them locked in memblock indefinite=
ly.

Furthermore, any fallback cleanup is skipped because the finalizer
memfd_luo_finish() returns immediately if args->retrieve_status is set:

mm/memfd_luo.c:memfd_luo_finish() {
    ...
	if (args->retrieve_status)
		return;
    ...
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903023452.7217=
32-1-loganodell@google.com?part=3D3
