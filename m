Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F516519D
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 18:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711652034; cv=none; b=moAaBlTjCGLiSqTAYoiOSo8Oj1VuOnsWCz7rRR065+divsM6kORHrT17TnwqcufYT6n7rnzULEJl17JJo0ztG1qGMOhcaaLJNKRxQKoA0hNeeWoPs0vNfQDn+YjiQug1FQLmvfNqa5sw78mKEzVoBL0mGIAmeeXQrB7l9m+TWig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711652034; c=relaxed/simple;
	bh=tDpNimz2tLrqc7Rb9s6vLaOw9QeYS9jpNbYqOOgZNtk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XdhFNVAqvIXJB2nWfV657Sp4oFvxfCAOkOklddOQQ9tD40rcnZxqe5Muu6QJxShUfyA4yRGxhKQJdrbcH6rqdRn3IyL6HwK8222R0yci62IxcFwoq2G4dy+jfiWn+iZ4kqtAe/eqXxYGXzr4FarMGPRG+xiQ0Wn7RQzB1feQvn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n77lL6JD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n77lL6JD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26ED7C433F1;
	Thu, 28 Mar 2024 18:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711652034;
	bh=tDpNimz2tLrqc7Rb9s6vLaOw9QeYS9jpNbYqOOgZNtk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n77lL6JDZko3Q7cNI3P9LBMvYQwfjt36UmHaK7HgEymUlr94SB5HRdftAiOvZtyeD
	 18Cr1U2mydbr5zmiGgrCkRNd+74TDgOL2aSakDIvN+ZfHw8MjpgjkwlJ4StzAj2V3r
	 GdtfQxqCgQrF5XCgQ962mWvmJQew5Nox2M7BTz0RNYDPcn2L4hKOHWhyHqQmxDphyz
	 U3mAFYVPrA66NP9OQ8PO6ZSsH8Ag2DMG+H2uvpCSX6Xq2xLO9jeU4MDU0ebCI+La02
	 hICoNhSHgfAyIFEEHJ9br1DqGiwlQFWS1D4VGcPmO4zly/8fSnwQ9VBn3rUkM13xE7
	 IFubN0TB4mwkw==
Date: Thu, 28 Mar 2024 18:53:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com
Subject: Re: [PATCH v1 13/44] KVM: arm64: Clarify rationale for ZCR_EL1 value
 restored on guest exit
Message-ID: <8de8e62d-b7fa-482d-adde-7f90467d8a51@sirena.org.uk>
References: <20240327173531.1379685-1-tabba@google.com>
 <20240327173531.1379685-14-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XZ9GQOPbjHbRrHuz"
Content-Disposition: inline
In-Reply-To: <20240327173531.1379685-14-tabba@google.com>
X-Cookie: Yes, but which self do you want to be?


--XZ9GQOPbjHbRrHuz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 27, 2024 at 05:35:00PM +0000, Fuad Tabba wrote:

> Expand comment clarifying why the host value representing SVE
> vector length being restored for ZCR_EL1 on guest exit isn't the
> same as it was on guest entry.

> -			/* Restore the VL that was saved when bound to the CPU */
> +			/*
> +			 * Restore the VL that was saved when bound to the CPU,
> +			 * which is the maximum VL for the guest. Because
> +			 * the layout of the data when saving the sve state
> +			 * depends on the VL, we need to use a consistent VL.
> +			 * Note that this means that at guest exit ZCR_EL1 is
> +			 * not necessarily the same as on guest entry.

I don't know if a reference to the ZCR_EL1 fulfilling the role of
ZCR_EL2 when doing the save from EL2 in VHE mode, that's potentially a
bit more architecture to know but explains why we only need this for
nVHE.

> +			 * Flushing the cpu state sets the TIF_FOREIGN_FPSTATE
> +			 * bit for the context, which lets the kernel restore
> +			 * the sve state, including ZCR_EL1 later.
> +			 */

The bit about flushing probably wants to be commented on the flush
itself which is done unconditionally rather than only in the nVHE case,
put something in there about how we need to save and invalidate the
state so that if the host tries to use floating point it's not using
stale data from the guest.

>  			if (!has_vhe())
>  				sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1,
>  						       SYS_ZCR_EL1);
> --=20
> 2.44.0.478.gd926399ef9-goog
>=20

--XZ9GQOPbjHbRrHuz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYFvLsACgkQJNaLcl1U
h9B6Fwf+L3/qELWchsvOhe0A7ENgSdfrKayzuLmPgJONQ6MXv7v7uiOpP6M5Z/uc
GV9TmnUUVLmViA61cVcpIWARYD5/hiOXnHRNCElTla8xGTih9QEG4fITJS/Vx7Cb
ZvjLjQr6+GFZTO3Fq8dWP4cTFOss0WKD2gzodO4bmphSxBzMAOOS/c5pj+woYu5Y
O665sFcuEDFqNx/PancyS9VTtdEeUMdKR8+nfABP2oDx+s9/xemFVUiMDzQYPTqj
GQ88FkTlLZqzGtlNprKoQOh4ZOd/RIGpXLMXXe9KsGUEwhnWEcUrPiHfNkznKhxO
K2HvQ5J8B3VgfahQkrM5nQo07X1X7Q==
=ucGN
-----END PGP SIGNATURE-----

--XZ9GQOPbjHbRrHuz--
