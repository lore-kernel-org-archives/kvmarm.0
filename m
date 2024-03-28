Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF14A1DDE9
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 18:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711652244; cv=none; b=Fi142vsWq7QpKqfCcllhNx9/+PIA0l03Sb73BWBBvWPI7ZT29m6mSruAUR2vvX2vDT8Qs4ikeDxrM65tRBsuu8r9FZXSJYtMi+N7tj61abi5ygo2dqO1ullAcXcyfXtms47Tck96xXhFSjbfLx4Kje9upRyzUEInKhM6tzIDEH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711652244; c=relaxed/simple;
	bh=lbN8U3fjm2/GJ9okpK9OYj8qXg4lVdwVqF+Ycfb2bXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kR5ZNf7lY3vnScpXpvteLG3qJiQ1aoC6pEC4V7Zxyi54Jgf0JhFn/atbOpLvS1AIejElTgQ9iI1CVA4YRzhr5JSQOIjbUcgSzv8LjjUpotmDmoNTRF5kuMoaMUs/C2aCPCMSFgmRGfA0/dNn+dcBd/0i3pfsc8GB6gdwRU3BKAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uyXkglNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uyXkglNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3867CC433C7;
	Thu, 28 Mar 2024 18:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711652244;
	bh=lbN8U3fjm2/GJ9okpK9OYj8qXg4lVdwVqF+Ycfb2bXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uyXkglNVpNEDaQ48X6u8wUcMAVhdTMfQI0ar+uiqtKrYICXzRF6w38s8kpREplGDX
	 F6apY2Pkx8ioPPr5w+SqsrxTWZmioGYGKiez32m58kWBk46firp485QRW3iq7B6Rgz
	 ReMEJsvagag6O/Sat4TKkwz7uKyvLUao+RnZJZtYUInVg9E0e1OinufDTRXKL6Tkju
	 3Wb0LUf6Yb2IMdFkCMoj1yeVLD/L935CIIjhCpk6wPytWc6zCSoIgddntC3lXhuYwD
	 dB1W88W3ebRyvyXBf1l9HKTHYidqMKzhPGUttd5zi63cqMOTlHwlyL9EO8WW1Q3RNd
	 bK06Nr6dIVf2Q==
Date: Thu, 28 Mar 2024 18:57:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com
Subject: Re: [PATCH v1 14/44] KVM: arm64: Refactor calculating SVE state size
 to use helpers
Message-ID: <cd642d56-7445-4716-a2ab-1624df9137e4@sirena.org.uk>
References: <20240327173531.1379685-1-tabba@google.com>
 <20240327173531.1379685-15-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ueaMATM0BxOwhcxb"
Content-Disposition: inline
In-Reply-To: <20240327173531.1379685-15-tabba@google.com>
X-Cookie: Yes, but which self do you want to be?


--ueaMATM0BxOwhcxb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 27, 2024 at 05:35:01PM +0000, Fuad Tabba wrote:
> The main factor for determining the SVE state size is the vector
> length, and future patches will need to calculate it without
> necessarily having a vcpu as a reference.

> -#define vcpu_sve_max_vq(vcpu)	sve_vq_from_vl((vcpu)->arch.sve_max_vl)
> -
> -#define vcpu_sve_state_size(vcpu) ({					\
> +#define _vcpu_sve_state_size(sve_max_vl) ({				\

If we're trying to make this a vCPU independent thing (which is fair
enough) shouldn't we also remove the vcpu from the name?
_sve_state_size() for example?  It feels like this might want sharing
with the host too but that could be done incrementally.

--ueaMATM0BxOwhcxb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYFvY0ACgkQJNaLcl1U
h9B85gf+K4Fys2nKOpVDeRRDd6V8iJ9Gdr3vboLsY1ynxK6PLnETst1oTSEK3fQo
IsY+H2V70QuJJcrrM8tdzwNSEPVBpXW6ejzW0VG6etYi/vTxldC+H/wfnNYJw8Oa
ZrISm0yTIEVnpM3IN25NjGDVvFM6ksgwDVKcvMVy/0MFF8kw54cNXUsaCKEnnjfa
TFpSFiPonJiENyUEOKtaByP2BqcsfqbQtcTJsWHwo4+4lR7B+uYjcHk3mNXvk8/t
9QhaKcCGBeOW4vSF/7I9EkeXBDZvgBHOizBAyMg156/1H3PK9m/kO5LuAIwZkSoG
rXJyrjkvhVhcAMcdzce1HWinVg7Iyg==
=dhdw
-----END PGP SIGNATURE-----

--ueaMATM0BxOwhcxb--
