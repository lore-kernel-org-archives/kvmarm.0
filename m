Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B49379C4A
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 15:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779810203; cv=none; b=WXS2/3W3xY2CyE2YZp8y4tsc8ElshfU+va3UxPdEZE9BvsoUEuIaJOU+K1cCMwazY4e1l+7hIxT+RhRRsepeYgNWaBf3Jsp/bXRJWnzRywJ598wqXBYIAuHF96AwkE6Neosr9MjNZZ0UJCl4m53aD7ggkNynAuI4agYB7ShVgyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779810203; c=relaxed/simple;
	bh=Jf4NQAkGhKJgxVT/F4O81cCvS4czIC2KTaLQ5XcCvdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FN2DxdhzCPBUfZxkKLpXnpDZnm/4X+6Sq9TzHJ1YIDGtOQgpPFlRaUdiKRePC6iutvbJirMW78dZjsyfU/snvZsRCBHSF3fi8lBnb7PGgr3BiaJQt3jILtrEuawi4kEoj8huwb9j/D8LNxoSuE66NltF8DeYXXDWvAWL6gO0LR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HW+bRRyv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HW+bRRyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E1F1F000E9;
	Tue, 26 May 2026 15:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779810201;
	bh=rxYm5SvTOcVKLkiC72tchyYE0ruvCzdYhMcAjMbKO08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HW+bRRyvwTV6HudGegIlgGBk8E8txzo4s0Q4+4ftbXP3pW1/hGGJqmdi2LL+i8/2v
	 SqqjZ7igTXz0JYuslSztKYEXhb5WSqG1sKk/+LseDp4G3zaFBqSn8XTexpEcxpQrdP
	 o5ezCjhU2tl7g08TERaEC524tphtYmqV7h/QenGPgVXm9hMt34oCSqen3w8p24nCuB
	 EwtQ/U9+3LXVE2PctSWZ/9AaJ19Z5ttNmVjfgRPltstWJE2LHeTrU2aG/yGXjRf+7h
	 Jin4YsmG8eIcu0rGz4YVMH/EnhdVvCprIUcyLVKDmUbO763vFF2y28A2bRDh7mEyE0
	 +BEcxcDQShwbw==
Date: Tue, 26 May 2026 16:43:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 07/18] arm64: fpsimd: Use assembler for SVE instructions
Message-ID: <5918222c-b518-45a9-81f7-53ac7079a0c4@sirena.org.uk>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-8-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ErY8mrnqLWnVZBkw"
Content-Disposition: inline
In-Reply-To: <20260521132556.584676-8-mark.rutland@arm.com>
X-Cookie: You are fairminded, just and loving.


--ErY8mrnqLWnVZBkw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 21, 2026 at 02:25:45PM +0100, Mark Rutland wrote:
> Historically we supported assemblers which could not assemble SVE
> instructions. We dropped support for such assemblers in commit:
>=20
>   118c40b7b503 ("kbuild: require gcc-8 and binutils-2.30")
>=20
> Since that commit, all supported assemblers (binutils and LLVM) are
> capable of assembling SVE instructions, and there's no need for us to
> manually encode SVE instructions.

Oh, finally.  I hadn't checked in a while:

Reviewed-by: Mark Brown <broonie@kernel.org>

--ErY8mrnqLWnVZBkw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoVv5QACgkQJNaLcl1U
h9DIHAf/cI4ULioK4aN2o4Rzo+KZL3f4lNjpzInnpNXeEWBzKED8BXzM2jojAAWk
WT3BhcQKoE+t+93fKkpPP+a6lAG/euPOqjxjvS2h1qgNqqf+nCsTABbe3vK8aiJw
9hm6eORHn6e/PNm6MWPjGk0YuVLvEhICmiI8m7nzhKjSt4bb0rk1iBnP6B26rqlO
VBD4XaDmRKZQhymidHcFefTvn2W7GaMYiRWQ80GTDSlliceAoPVAi9Lq67xFo2Lo
TASLxahZsqNNc4jWkGoL1ATfC93P5Fv+godLu8p/okejkxCzy7NGd+METz0Z6Ufy
GtTSWXZ6l6BatnEzZgGmpUI30JfBUg==
=lht4
-----END PGP SIGNATURE-----

--ErY8mrnqLWnVZBkw--
