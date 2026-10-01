Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48852515983;
	Thu,  1 Oct 2026 17:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790875684; cv=none; b=LrPZF0m0DJnUb+ZvaZUDmdVwCBEMyrg1iHhXDiDbOiGlRYCA0tkTE9AqSqDzSHgjfLd9NkadsUC/Qx2iszhALXcxKcY0R1zS9Jw/tRAbCe2JaEI1Gwvvxfzxn1/tpXhRJqtaWcJ6CaB2sE4VvsVc5mPpzm4+7PsEd7kgAcDPW4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790875684; c=relaxed/simple;
	bh=2WHrAWI44umCgo5dA1afQgqYa6TJwqxBCWXf73OqFms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J7DU6J68Vz47BX5lVuHhXQowhVee6LG0e5qEbrnZuwuFpBjzS6cmjqcjFfHrpRsouadzHNN0PAjPNQWGXfnvGeJSiNPTatpf7fxbjqm4eD9DTBGwrLdbUoeoAwmrJ0eJgw9sz49XgeitpI0CdpXBSvDViau9Gou6K56mQcBq71Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cAb0Gw1r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cAb0Gw1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E73A1F000FF;
	Thu,  1 Oct 2026 17:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790875682;
	bh=W58m5D1Qq04GgCBROcqOqYr4uS4iCeytTxLxmDkHG/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cAb0Gw1rbEm2vy6R+OXcDxHJqLX/4dmDQcOkQOkVwveQJWdcaZ0N+F15BE8YTm4YT
	 Glf9iGP+lxwwQvq2jxCl/Xx+TtkSIDjhxy3CWeps7DVPvQnVIkrw1dIX0PZp2jdx9g
	 RV4fjje8yt90XBnu1P22JXo9aeoHjNVm3vQEcRyCCrsqXztIEXx5icf/ale1T762W9
	 +xDyp/LZ8MZvXK4IxwhmPwNTpdX8IAeLDRAVm8OMhLHBV382GYG6E9I4QOx1gQPqMd
	 v/S3bGMoYpHgkjPJH6gb6IjI4bzYgbRaCjS1BqiwFat+FHnNVGtxua0wZzNV7WzK7M
	 R2RC6kyZdJcvg==
Date: Thu, 1 Oct 2026 18:27:56 +0100
From: Mark Brown <broonie@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	Leonardo Bras <leo.bras@arm.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v21 14/15] tools: Synchronise the kernel esr.h
Message-ID: <680fe21e-beca-4056-84e3-f501fdfed902@sirena.org.uk>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-14-3556644cd927@kernel.org>
 <ar6NXWzQ1rMb1aId@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DprvDADVm2j3tP+g"
Content-Disposition: inline
In-Reply-To: <ar6NXWzQ1rMb1aId@gremlin>
X-Cookie: Do not stamp.


--DprvDADVm2j3tP+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 01, 2026 at 05:47:42PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 30, 2026 at 10:48:24PM +0100, Mark Brown wrote:
> > To pick up definitions for GCS.
> >
> > Reviewed-by: Leonardo Bras <leo.bras@arm.com>
> > Signed-off-by: Mark Brown <broonie@kernel.org>
>=20
> This seems to be out of date, with your series applied to next:

Yeah, though some of those are changes that are in -next only so
possibly slightly premature.  I'll resync with mainline, really this
shouldn't be a manual sync :/

--DprvDADVm2j3tP+g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmq+mBsACgkQJNaLcl1U
h9AFugf+Psag1H7XxGuG3D4J0/kGv/EHHZDmwkNPNqHh4/wspf175JUlhs6i7NeS
Y38pNSWL3cKJn0FLw7hI+vi4i92gbgTQSVVa3kaJlydpTYpyotb22WgoU73NchNL
yTTVA7wbyAC1doxMCSTTuYweTipV+TMrZMlDJ+D7S+0vCYG23NrQgPo6rbB+LCDw
Fqq9aZEcGFOEDcIR+FNSw+jDD2lGg3xv+fngs/LBmUmIXPFA7wdZPXSyNie2S7QB
6eTPT6HOtTcY6lxfDAsuqvuW+f/O9v3pC5ITzRFuEqKEODOBbtBADTITjuF6osqd
pfVyCXWgX4SyvytiMyoI1EYtFdIT6w==
=lSPU
-----END PGP SIGNATURE-----

--DprvDADVm2j3tP+g--
