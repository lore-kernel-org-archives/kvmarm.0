Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FBC3F7A93
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 14:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779805649; cv=none; b=e5X586dfvuJviUc8GRQfi4vFFrPfWkg2l0XASESoNU8c7gW71pgdg40xjY5BQ1m0aFwFMmIs/M4YSMBqrr5bmONtEs1EdZilhGlqjG15cENdFQW9gSYp1QY/j9OKFGAGmvQLZc1WQ2qskcotkYazXauOiof6byj9FalfvLsbnKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779805649; c=relaxed/simple;
	bh=0lrIS1mRLdvFOvur2TxaaWhBItiwLy6nmSCpDteM1L0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=krn6Xo3YJ46oAaAKXeOhj83w4vO2rkqdJJryQ670wCl7OEQIE64DRvqAcgq763CnmITOUSBWK7qm0qPWBNX9J2s6Alp30+G/zLtEcCBNd/uo+I9E1VNyvLb6a7t0Sajp1GpN64bMMPp9yxZumYBnKVV31zKjWmb4jhZ1qgoMJn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F1qbmWBq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F1qbmWBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A990D1F000E9;
	Tue, 26 May 2026 14:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779805647;
	bh=0lrIS1mRLdvFOvur2TxaaWhBItiwLy6nmSCpDteM1L0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F1qbmWBqi8QdQfecBmVVoj1yXGvGKR3Z0oej2cUc8452a4NQeeHDomd/K4qToK3os
	 ZlxZJ1qmqtlnA/10L5YWJVEmGpolDQbDy6tMyJhonsJh7zV1z1qT7Dl0ruBtvI0IO3
	 IZmsxQ03jzNuBxSiWXE+dyOcuk6vWdqPWc2t98Y3cKh0zW1xgWhlX/JH9jPpgF3fKa
	 hFDzx+7OCHcvgU6Vx8+hE5dLGbUvbBLKpF9HsniHHw6SNlPRaaWxC9UjQCWBPktmNi
	 ZqeN3jcbPSSygJBp6hDxfTLtAd4/Xb2zcHV1w9R6a72KSJ3kGkHxJ/v7WHJqFAvg8j
	 YgtTV9zl1IwxQ==
Date: Tue, 26 May 2026 15:27:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 02/18] KVM: arm64: Don't override FFR save/restore
 argument
Message-ID: <5274350b-b136-45e4-9648-55c5a9212207@sirena.org.uk>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-3-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pWo1D6sXPeUbvLUB"
Content-Disposition: inline
In-Reply-To: <20260521132556.584676-3-mark.rutland@arm.com>
X-Cookie: You are fairminded, just and loving.


--pWo1D6sXPeUbvLUB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 21, 2026 at 02:25:40PM +0100, Mark Rutland wrote:
> The __sve_save_state() and __sve_restore_state() functions take a
> parameter describing whether to save/restore the FFR, but both functions
> silently override this with '1'. This has always been benign (and
> callers have all passed 'true' since the parameter was introduced), but
> clearly this is not intentional.

Reviewed-by: Mark Brown <broonie@kernel.org>

--pWo1D6sXPeUbvLUB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoVrcoACgkQJNaLcl1U
h9AqyAf7BV3cLAqlBPywTUOcOoFp5aEiVNwBvAEfl+xrgLAJcVBYp011Et5Kt331
nISXXs/a2XDHvPA1q+IwJiZX+6vMZ/ecvLBVOUmPGIJEnJXUaoB0EPg+cjRTTts6
SqPVyfSIHc+QR+ZpVA7XoBFrW9DiYGMhVNVXXL4/9NMDU9QX2ARhnHEdhWHqNCrq
ks318ToGqqkGHA2T0E4Qi/OylF8myn5eeRHWubmTIvdgSEFdyp7V4ystYp8+13Eo
fjemEycDOhcItHxBXMSUI3qQNR1cA15M+mT2IQTXVtKq+GwnpXK92wdUmp1Euc17
8KIRLIet9b73FsuvVvwXPDBCZwb1NQ==
=y1bp
-----END PGP SIGNATURE-----

--pWo1D6sXPeUbvLUB--
