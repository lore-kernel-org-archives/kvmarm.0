Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F5712F363
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 14:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714573046; cv=none; b=JoXdKXmYknNMTW0DTCx0H8+oyoIdoVxuEX/RZv5AYGK1veHZKTRc3NxqwoaXQK5ijLvR5jl18JQKlB922jOAirqmFQHuYShPOvNzBnODtTRexd3ZFM/QGGYgrTYJxm81hrz36l9Rsza0/Vds6WbmA13TsfmE9+wpXUhgHsmv/oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714573046; c=relaxed/simple;
	bh=L7VXmmd6EEz8g93sN6wFZj2/vQDRADor+63AUF2e8yg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EzTX4pI+KCFCPPb18376p4AntVX1INArUJzOqfg06bFTuqwfrXiKrHkZdOcGlgDZGaKWEM5ELC0AGKSE/bMlIYCG20RXo5PJTcHm2RwqcLzXdYH0QqtTHKc68CnCdr8TRtD0cHIPqNQ6W04NhFrkCCQN/1usH4zKU82g/1j+YgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HAZtvk+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HAZtvk+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7EDC072AA;
	Wed,  1 May 2024 14:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714573046;
	bh=L7VXmmd6EEz8g93sN6wFZj2/vQDRADor+63AUF2e8yg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HAZtvk+nl0hj0DHH0mQKNwLq+iyGsaEytLb1o6oYdc3NoqCepEnz4nZwEI7nlH8x8
	 p5Y7LxFlEoOYewwnWJuwIjUucx+bn071oDSXDdmcY/sRXxGQsTGqnD/gug97P8NwtA
	 wpVnB7LTnxGN3/NDnwH0Eves7RBQ6hUQTCeb4kpvMbepH5UOhENTvmhjjF0ybmpG51
	 ASCENAjST89/Hj/HcSg5khaEWS000nUz4ceH2HLnj3WGn//LBjU+jmrNU3+I8M6MMl
	 d3VXtWA7RaBET5NvZwcanJ6SZZRdYRtJmhAxADRDlS/UKtJXpRI+fRgK5s0L4Pj2aZ
	 9gxxx+RDvypUg==
Date: Wed, 1 May 2024 23:17:23 +0900
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	smostafa@google.com
Subject: Re: [PATCH v4 03/30] KVM: arm64: Refactor checks for FP state
 ownership
Message-ID: <ZjJO8w9cb16jbPTR@finisterre.sirena.org.uk>
References: <20240423150538.2103045-1-tabba@google.com>
 <20240423150538.2103045-4-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="alt7K0rLx52aGVWz"
Content-Disposition: inline
In-Reply-To: <20240423150538.2103045-4-tabba@google.com>
X-Cookie: lisp, v.:


--alt7K0rLx52aGVWz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 23, 2024 at 04:05:11PM +0100, Fuad Tabba wrote:
> To avoid direct comparison against the fp_owner enum, add a new
> function that performs the check, host_owns_fp_regs(), to
> complement the existing guest_owns_fp_regs().

Reviewed-by: Mark Brown <broonie@kernel.org>

--alt7K0rLx52aGVWz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYyTvIACgkQJNaLcl1U
h9CJmwf+Kb7vG98BWF+GWaSmpwiY2mDtl1VQoVQU6qck7ldWXQpBLc5xkS82rQo6
QXxWFe6ky7qhV6XrqPRVIe+6mP37UYFBI2xz6jRZEih7Ysi7/TLNqEjVUe08J6ov
w/UNUv3DX6Ikwa4J4h8YummoJP7wr4E3WhF7gvrSbApHkExo6chQIlgcnZPjrN9V
IMiiY0vLrXgl0glfxHTZ1Q5qf3yKJ+YZBV3c6RSAaGnXMBCuBCkTeh1iCyOhNeO1
+mAqUk5neWdK0x/UW8B5FrAmkX+f+sumZtDmwK2rBlX16IE8cX5YiqtJp8V7+B+k
Z5sRiC+17+X8Zf3ytkJHYndJhN9Z6A==
=Mb24
-----END PGP SIGNATURE-----

--alt7K0rLx52aGVWz--
