Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C92131E51
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 16:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711642798; cv=none; b=oMAeB06Qee7ommoT2f+32QGx87TJbdzKxypoej+hbaArhum0nF3g5iBENQxJBk0iv7T77AH89dDNNvSHRoZADIvtulaYh03BKnfc8k9MjiwbccEvapc6ZWM7OPe68I2nathPmqKG5zSH8QKKUOH/PPJbhK85e697TYcTQnX9V1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711642798; c=relaxed/simple;
	bh=tzB3gCV3GAmycRmk7KBoXhD75Eh7BQ8JSJL4EsS+iK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DwmyiWhqhYo55MSM9am7woYYAWi0AkTUtO9AFA6bJLvpjNiefxofYC+YxN3Hmn+QeqhqJJIussuh/ZuaFF2VroqRnEdWDKJiWCaNWYadAaroR+l+CQinky0aBo/9G8PkCV3ZCp2aTOWeomX9EcBzmVrxWwGnzLIYe0TQKrJlbRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7ny+CY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7ny+CY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7DBC43399;
	Thu, 28 Mar 2024 16:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711642798;
	bh=tzB3gCV3GAmycRmk7KBoXhD75Eh7BQ8JSJL4EsS+iK4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b7ny+CY+RxfhTdVuiGmrvbvMTt6tSakNPmnmsK7cRnp2WUe/StLgYUFReSQc4xlLK
	 uVb4TUByVQRx9gnVlGfxZ56uu9Pe0VAMzF8wTpb3i3s3e3H+WEjbszwDIA3lt+W/t1
	 OwmD01fEmwwteWx/vliWMx9U4c04ZjF/xmq41tRzpT7nI7Yb8jpEj5dpbgFKppbFxH
	 +BaZVlaAkw8MgkmQVaWA00vgaVo8jdwQDZoUq3N/aqWIXlxYkuvIDWmvWqusuUDGLv
	 +SU0dWu89YFgOi2uql+zI7ovVpj78OUflvCn5e6Gen85NUexVg+tYRcKEGLhHsyOCL
	 JWt6mS9/jyoZA==
Date: Thu, 28 Mar 2024 16:19:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com
Subject: Re: [PATCH v1 02/44] KVM: arm64: Use enum instead of helper for
 checking FP-state
Message-ID: <45204460-828b-4f06-9d1b-0faa355fbfdf@sirena.org.uk>
References: <20240327173531.1379685-1-tabba@google.com>
 <20240327173531.1379685-3-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PEHlsddrpoNP21F1"
Content-Disposition: inline
In-Reply-To: <20240327173531.1379685-3-tabba@google.com>
X-Cookie: Yes, but which self do you want to be?


--PEHlsddrpoNP21F1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 27, 2024 at 05:34:49PM +0000, Fuad Tabba wrote:
> Before the conversion of the various FP-state booleans into an
> enum representing the state, this helper may have clarified
> things. Since the introduction of the enum, the helper obfuscates
> rather than clarifies. This also makes the code consistent with
> other parts that check the FP-state.

Reviewed-by: Mark Brown <broonie@kernel.org>

--PEHlsddrpoNP21F1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYFmKcACgkQJNaLcl1U
h9DJhQf8Cp2qUZ/xcagLrW+3gyD36Ux9jUEjYflx2LxMlEDSXgLmaETFvmETG16o
vkIDS5SR/ryWLBwvNClEQZXWND+Fp5Nsbde+FbwoX9KPXoYeohGYre34lYpBCSE1
ZQPRt9zOcKvsm3aUM/RlSARFJI15fuFBbaneQEYhuNWg/973T6EwqObQcshx4MPL
XC1gqoHIy3UbQ37KL3Hvo7+MFzqdznQEPhZxjNynMwm3O7kDo0m4YJfsTzWJxjq9
2AR38KrTRWgwvDNu4B7kOqTuQwR9EzopIUmMvj643mOpmmFeixBpZeRC5XtIaACB
YCTQumzR6UpAiBTlyd3P8A5C79qUag==
=/CHS
-----END PGP SIGNATURE-----

--PEHlsddrpoNP21F1--
