Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFC917C2
	for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 02:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714097163; cv=none; b=TqIMcbCtCqHZvV/gRpvTaqyaKaAEN53anNrJHZDmVdbDnW39VCZ4jwrrDfotfPoHRcwdD8iFKa9qWt9FRP8ffryU49zyNyx3RhepHG1J6wAZY0UX7KIwmW5cpl+VajE87s60/GDWCmuFML3mOKmiQeM7ippMjQZ9ti3e4o7QyXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714097163; c=relaxed/simple;
	bh=6IWTg8OC/PHl39hJe0tBgHAogr9U+ZgQjm4aEu92Q+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UK8bcnEIThtTY325BbdikeOVcL+5e59qACpJ3N9m6Xc800RoNFxUoEZFuAmNo8RJQLb/Q5xKmk4G9OMJ/6Uwimrwp6RITOCyoSMKMfLPM3KmOTmp240jGcn5bR+u7XfhG6Bg6FVBOeOTvGgWjTWbBwFfHyNGebP3L2bIMMyPVVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uDJdwLaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uDJdwLaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB52C113CC;
	Fri, 26 Apr 2024 02:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714097163;
	bh=6IWTg8OC/PHl39hJe0tBgHAogr9U+ZgQjm4aEu92Q+4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uDJdwLaW4ytlGW6qnm8KDLbNKq5/kwV97CWAt1MgCX/LnUqebX5+jt7WWuH7+OxEN
	 j8Le+n+T64WZvZpXVQtRi6Ak/ea2PQYkHEpPKBPKMOz8Icwhai+PGJZnU216I/QjcQ
	 eEn8QTrjAWCla7teJd3E1d/i1uL4wxp0KTBidHAF4HnDP6MXH7U0/kHzZ6h2oYNebl
	 B2A6qA6wHgFcVdxgFiewz1r+WqsmYJuiLroy32PBwqTpfddslNmjkUm9muuPxeVlHh
	 pC8UVhmaje3w31CFQW4uU35tDrLS7iF0dkN3tT4SwV29GMg6kcZteSRU5NntApBbrG
	 NU4NTAk2hBciA==
Date: Fri, 26 Apr 2024 11:05:59 +0900
From: Mark Brown <broonie@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, qperret@google.com, seanjc@google.com,
	alexandru.elisei@arm.com, catalin.marinas@arm.com,
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	smostafa@google.com
Subject: Re: [PATCH v4 21/30] KVM: arm64: Refactor calculating SVE state size
 to use helpers
Message-ID: <ZisMB6ZLmCY-nfbc@finisterre.sirena.org.uk>
References: <20240423150538.2103045-1-tabba@google.com>
 <20240423150538.2103045-22-tabba@google.com>
 <ZirfWVZ-PsET5Aii@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2GBAtnVooPK82Vv8"
Content-Disposition: inline
In-Reply-To: <ZirfWVZ-PsET5Aii@linux.dev>
X-Cookie: TANSTAAFL


--2GBAtnVooPK82Vv8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 25, 2024 at 10:55:21PM +0000, Oliver Upton wrote:
> On Tue, Apr 23, 2024 at 04:05:29PM +0100, Fuad Tabba wrote:

> > The main factor for determining the SVE state size is the vector
> > length, and future patches will need to calculate it without
> > necessarily having a vcpu as a reference.

> Unless I'm missing something (which happens a lot), I don't see any
> users for sve_state_size() in this series. The refactoring looks
> fine, but let's only do it when there's users for it.

Right, there was a patch using it in earlier versions of the series but
that got dropped on review.

--2GBAtnVooPK82Vv8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYrDAYACgkQJNaLcl1U
h9AQEQf9EQm7eKihAqyl7OJzztOIYvBqINeyNsd9LRiKBPKBHcnPgmr1WS5zYF9O
qkStU6/k8PBvqdWq7/UaGPhuUx9E5wbnp7fuF85viUuowtlVa9Llfca3zH/pLnD0
pECqmhG5O5O7Ym2Dw+1CYZnh1l6tmJ93AIpAbuAiGy8x2JIcHDf4qNp6XTNTjdFu
WTRMuL+sV+uXiXF5hlmHJaWG2oDuCHNuMXmnSsgEVT1qAobUkZcjBp2fXzMsltmO
5eUr1yUSVcMfOn3ObmB2oIOmrnrKvSwTj2VAl5ClUEqwQSElR+Pt5AXVPRFGnfSN
QVy1gpcTgaF9JNdB+Rf0B4EkEpaQJQ==
=F/OI
-----END PGP SIGNATURE-----

--2GBAtnVooPK82Vv8--
