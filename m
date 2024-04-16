Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5493B763F1
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 10:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713264466; cv=none; b=JlroeXw+UngEpBqpxHNYzJVsG1GA+PlpBhIIorypHtIFhIO9MLOtKpJIOPoWokVgNIOFnOjySH36np/vwUH9aGvtDFfn5uiOBRWbXvGlpNQxjMmUiIQBQ7uJZsJjPzhQRTeAQcGK4P6Y00bw+9lspGRAZpKFRcYWM8q1CPWLt40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713264466; c=relaxed/simple;
	bh=OaBq3MumTW/ITp3j47POlCjtfxB0/YSVkT48PLFIIIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IFu6Ynt5pRXTqXPqLAGjNRzuGl2oDQpP329ECzGluUr5OIjoUfEGSaeTxlYIGT9egoR8bGSTT6HIwFHjLMwu41pbzBsWb/si8dWclp79zGvKm3E64pBhr4AUS9ZTFN2947Ng1qz0CT5XqnHQ7dtLSuI3+2xtgFvdruZZmliFv9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wob1CO2H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wob1CO2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4935EC113CE;
	Tue, 16 Apr 2024 10:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713264465;
	bh=OaBq3MumTW/ITp3j47POlCjtfxB0/YSVkT48PLFIIIY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wob1CO2HIe4A1yRUy+tC+Tsxc9k98nfCEvXd/r0kzgZT8EnnqD68PB87nW4LaVgT6
	 gmJEKwggtEq6apKcDcGqQDTjwEEGD/QPo+qX2/Cq49nvKD7QcFmv1rj/NSAfkKc99z
	 BrKhK9MvFK3OKHCSVs5r7sbQVPqI22CMbJiHSrSEkjLH+6DhCfrgTSADNv9unAHnCo
	 kFuuX6Jcxlhu3tn+OLM7SFxD25KFCVp2NhvUMAkspCwGaCN+93062Z8MfNzjDkiLn6
	 gN8ZlmfDUsp6K6r20g8UqJ4jljMD/n+9Rdo/1MKE34eP8QwbfbplwqntqetRkAwRsm
	 tbGXyozZExPnA==
Date: Tue, 16 Apr 2024 19:47:42 +0900
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	smostafa@google.com
Subject: Re: [PATCH v2 16/47] KVM: arm64: Clarify rationale for ZCR_EL1 value
 restored on guest exit
Message-ID: <Zh5XTuCF/53ImnxM@finisterre.sirena.org.uk>
References: <20240416095638.3620345-1-tabba@google.com>
 <20240416095638.3620345-17-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bo5A4ndBH7+A0aEQ"
Content-Disposition: inline
In-Reply-To: <20240416095638.3620345-17-tabba@google.com>
X-Cookie: You might have mail.


--bo5A4ndBH7+A0aEQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 16, 2024 at 10:56:07AM +0100, Fuad Tabba wrote:
> Expand comment clarifying why the host value representing SVE
> vector length being restored for ZCR_EL1 on guest exit isn't the
> same as it was on guest entry.
>=20
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Mark Brown <broonie@kernel.org>

however if this gets respun:

> +			 * Restoring the VL isn't needed in VHE mode since
> +			 * ZCR_EL1 fulfils the role of ZCR_EL2 when doing the
> +			 * save from EL2.

It might be slighty more clear to say s/of ZCR_EL2/ZCR_EL2 would/ - it's
a very marginal difference though.

--bo5A4ndBH7+A0aEQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYeV00ACgkQJNaLcl1U
h9A1nwf9EknmhDlvj9zCWf8S15/hVLQ/p6Ka/6ZtkJPul+IlijRZEOVdRrj7sk5/
w+b+8WYAG1TFVjXBKHpNFyFPA50Fh1CU3yxgH+XJURzx07jnUMWCnRmyWFtyR5Mc
LO399Ow/Ey5lSXvXxy2cotxXUisxWFeqQsD1gE/Bngf5uWjyZsJIaHOjgB/f7uoE
g76LBcR3/RAvdISdjuTHSEMC7jngPkY/RXIMGajaIMilKKnf2PYPEDFKTmxDALyL
1KtvUpklfXIrqlVJKfR+h/5Z81vetY/vmDLKeKJsqCfvBbuB56nIu8Ku4funmr83
S6ktMP5/hN8A5nYZ2eIsZbvj/ZEcNw==
=7S5k
-----END PGP SIGNATURE-----

--bo5A4ndBH7+A0aEQ--
