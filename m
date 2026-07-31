Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140DC439F94;
	Fri, 31 Jul 2026 15:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785511579; cv=none; b=o4mSCV+U7rc2d8Nm6dW6Tgf35Vt2JPViwcRgx1sYbuFFWFo+F5DEqaT2EQkVwPzMkDL84yEEl9E7rQdD1sbEoCflAVnPZmkkIFt7E3JDKNqPYOfLcfCguEKTvSNKzpVd4JtZtgvwVA0cwFKtAhTqEOzLweiBD3oHmZ+4QgFj2vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785511579; c=relaxed/simple;
	bh=rgLjxUjNCOG/yZS3/F1cSvxy+hMAauTMwJ4Htm++otE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bjXlEDVShPNFQvNG8uvfWy/mtxO/uYzL0nfrHmzU9WdfDt3MVOLLvzu2v212qLvNZMQksTL/LAG10JR5UUKKkqThdq/pkxuiCriM9gzZh/s/stLhMzJFkmzZfIZ2qlR8GU6SSm2qHjkwZELGc/tLF6/0HNmmWIUwN6DZnNGbGEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mN6wMkFy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mN6wMkFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F025D1F000E9;
	Fri, 31 Jul 2026 15:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785511576;
	bh=rgLjxUjNCOG/yZS3/F1cSvxy+hMAauTMwJ4Htm++otE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mN6wMkFykMHHLty86efwRSLhzGCxqqgEMJVYkDppQdNUYnnhMi+4G7mbPD8/ci1KX
	 2P/S6l7zhCOLEWYkyrRoCHJ3GKCfrPdLSExBIHE2nWabGBmviIYjFgdBJj5mBzw9jK
	 Ar/DP1LFqd7mUV0lNnj754r6G+Zj+fl2S5pPI461tDUcNhZWWq5aMxXtQ1MsXdq0hg
	 LiRyHQm0E8SDulKiUP1euQth1w/yWsplAUmtIvBUMb3DNaDUnxCLRhk94opPNaYVkH
	 XaaupodCtV6oZzJ2V14t0zAb20MZq1tK1OcdzU+stH0LXSMgwXaXPO2WQoWAqQc0Y8
	 W4d3BZ0/zhH8g==
Date: Fri, 31 Jul 2026 16:26:13 +0100
From: Mark Brown <broonie@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v17 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Message-ID: <36d6d5c1-4db1-4b6f-a49a-8181a233a07a@sirena.org.uk>
References: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
 <20260731-arm64-gcs-v17-3-5e39ca01b14e@kernel.org>
 <20260731125604.CF4B31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MgGWOou14h2mwOt0"
Content-Disposition: inline
In-Reply-To: <20260731125604.CF4B31F000E9@smtp.kernel.org>
X-Cookie: No shirt, no shoes, no service.


--MgGWOou14h2mwOt0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 31, 2026 at 12:56:04PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] GCS register context switch routines are incorrectly nested inside independent CPU feature checks (S1PIE and TCR2/TCRX), causing state corruption.

This was specifically requested by Marc on prior versions as GCS
architecturally depends on these features and it may improve code
generation.

> Is the GCS feature bit still explicitly masked out of the ID_AA64PFR1_EL1
> register limit?

> Looking at sanitise_id_aa64pfr1_el1() in arch/arm64/kvm/sys_regs.c, it appears
> the GCS bit is unconditionally cleared. If so, when the VMM tries to enable
> GCS via KVM_SET_ONE_REG, arm64_check_features() will validate against a limit
> of 0 and reject it with -E2BIG, making it impossible to expose GCS to guests.

This change is in the following enablement patch.

--MgGWOou14h2mwOt0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpsvpQACgkQJNaLcl1U
h9D4DQf/RZLYi1M2kH9mqhRQuQZZsMuP6/nM+q2GwXMKIiYqekuu9cGnSbzj5em+
98EMlgO6DCzrO8dgby25rqrXF64D2NTJzsltMi3c3GKUaBEt/z2Ud8x72zSFSHpA
99NX2+rDIO5Lh5qXdWZAk+iyjuhRmn8acI7AITHqanoYBl63p0Us/6qFKX6uCzu3
gMJImEZh9FEfiMidHlfdMO6Hp0Xa7AmyQBNRlrFPkCm36lEyWKmAPBE5iyFsuCPs
vgSahIirRrgpTpPFh2r2q6gLNNC4bhDwG7Ptm+Eetxtv6KuQHc3sqgevbi7zfisf
/V2p8awwVaRg1gyB+VU7/FU1PUBuGg==
=R1lN
-----END PGP SIGNATURE-----

--MgGWOou14h2mwOt0--
