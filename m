Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B9021638D
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 15:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779809305; cv=none; b=Vkm842kEkpnMYFcmIGX6xIz+W+4OMPNxRK3BwewEGc/kTijc6YbT3Z1EIHZ5O2CWhcxt3xq8FesaJO/gxaiAGKZPyt+zfPqzwB+bqzgVnUjvN5eMQNrNJ9MR3WyhVeXFLpLwJ5Ba3rxKeXCk0WJVwXi+jlA3QJpDho94Z6eH5Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779809305; c=relaxed/simple;
	bh=FIMivEV3Nh2W0oxYrCsqbjYYz+Sf2wo8HQGyWhokcaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iraXYPDy0W/JizDOIA/rkQ6Hw5/HsfkdL3i42BsuddkfE1sU1ay09MQlrDCYJaR9Zw/sXJNNYKsy0Pk1Aja2UCJ4M9wvLwy08+8uv/uFk3dr5dr3UwTPa/GO4QLB911hJw0elC9RWWWR/ENYd5lFKKv9s/FAdBRtf3Z3SRobGhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JXyk0oSZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JXyk0oSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C8D1F000E9;
	Tue, 26 May 2026 15:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779809304;
	bh=FIMivEV3Nh2W0oxYrCsqbjYYz+Sf2wo8HQGyWhokcaU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JXyk0oSZqNpatobm0MR5n54JsEdstKnh9wO70R33+NJzlEo2MlVLc9VT9BH1qnjH2
	 5AeckJc2Hbj28J6Frq9aqiUmHtASf2aUeXGNac6xBMeI3fXNyN7BJFAxg81lI4fNVA
	 YgMzLqgjSfa8y088FwNcTw8uLDB628jN9xtJUunBX+eao2Z7IBnpjLkr1baXanhRzi
	 ejGcAZQ91yaQHvQcXBFRFFOwZpIs0+7P+nZc9a5HXajtfXm9cZ+Ye4X2MlbYa8Q3HW
	 NyybykrnAai9bV76BjXF//WBdmbn2UaGctr80bmQ6J6vETrn3XIUeDD5Lv4NVm/VdL
	 jnfVgSYBF/TAQ==
Date: Tue, 26 May 2026 16:28:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 05/18] arm64: fpsimd: Fold sve_init_regs() into
 do_sve_acc()
Message-ID: <82fb3210-b31f-434c-b356-5248336cec36@sirena.org.uk>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-6-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="JGsvmQUd9gsf9JMd"
Content-Disposition: inline
In-Reply-To: <20260521132556.584676-6-mark.rutland@arm.com>
X-Cookie: You are fairminded, just and loving.


--JGsvmQUd9gsf9JMd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 21, 2026 at 02:25:43PM +0100, Mark Rutland wrote:
> For historical reasons, do_sve_acc() is structurally different from
> do_sme_acc(), and the logic to convert the task from FPSIMD to SVE is
> out-of-line in sve_init_regs(). We only use sve_init_regs() within
> do_sme_acc(), so it's not necessary for this to be a separate function.

Reviewed-by: Mark Brown <broonie@kernel.org>

--JGsvmQUd9gsf9JMd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoVvBMACgkQJNaLcl1U
h9A5KQf7BZyrT+StkmsDpxntAFs4jlvLSYIE6E90OSbtpEsaDQtC1fBac43iZG7d
6xT1M/y7huO3SbduOP7Ww2nBZgNoEoRw6ezdI8wBwuMc34E0Ug6Xg8XnhaWxRtiR
6MCxLVZpvU3BR4Yuz4j85N+qVlTAkbuXWkm1B3/2C+FuK9ZPuUngIwR7688CjzPh
xFOnY1HEahmsssFXEtzgzEzjWY/P5pfsiVqzzDKJiw1Lo0zoD6Uk+hOq2uy3GWhM
DF4Jgnag4wCVZhGHMRggtFZTevGFAuvHqhdKR/TPVZC625ZbYeaac/g2/Ipvr+lI
s7JrjyHUIZZc8xeMP4UZUUDK7+12Dw==
=DpaJ
-----END PGP SIGNATURE-----

--JGsvmQUd9gsf9JMd--
