Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73FE1E87F
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 10:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713264927; cv=none; b=VdG3stRJEpOwTvMLxjATsS0D5HOYBeXiM3Whr5fQ1T6ZNk6GrgLBBNen2g/ckKRyqDBxtyNsqzb4MClmuDh3mTzpWvFQl/5Uama7qjR8QUVZtCihbfbY90I8JT5MCnTSJFO4kuJMzF6rB/yqo8p4JiWgeROYp163qedvdqk2fJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713264927; c=relaxed/simple;
	bh=TMW7TNhgABqbRnOdH/lzbnr5ls9abeZnVGQYTwShLW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gLU2C+agBtdYwHONy87ciGe0EjXRzduhdNbM0shZKmxjkVyNUwhVkRnYgg/nv+p3AFUNglsGpc6Y8RrjkTBGSL0SMrAFbnixIlNqJsD7MFiGEwbf6mvQYAr1oc0QJ+5QwAb7VGPCAQsuK9SWNXyhG6qvi7KOdTi2wqGlsiLk0so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nhDhnynl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhDhnynl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095A6C3277B;
	Tue, 16 Apr 2024 10:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713264927;
	bh=TMW7TNhgABqbRnOdH/lzbnr5ls9abeZnVGQYTwShLW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nhDhnynlpTjiX8e4Td/j0Nin8fcFJ2vmrLdavAKlSi9g2TiPB80b8kFL0hlxtkpJF
	 WjeCQBANTGzYHCMHM2XsGcJrayGgQGb1RB89867pq7i7X9mjvst5Ec+erCAVUXVBr4
	 vFTXBM0ymiQ2v2yMFXoDbEPF+OZXofs3Vm7Jw5Ph6WNiNatw650GJPFmyqDXJKDjJh
	 7P6TtemsqydvHY4caPxiAYlnGqLszqe26+S3iAyFDHJ8vP8IM7l7A7g3PK57GWkbu0
	 fz1p02b7oMQrDi4XmU4OzaUnRLyt5MKmyVCEs0MIfDer6Hlj/i5zNBS8U5JmUu4+do
	 iRwEtY3lpTSXA==
Date: Tue, 16 Apr 2024 19:55:24 +0900
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	smostafa@google.com
Subject: Re: [PATCH v2 47/47] KVM: arm64: Refactor checks for FP state
 ownership
Message-ID: <Zh5ZHLN4Dn8W+xaS@finisterre.sirena.org.uk>
References: <20240416095638.3620345-1-tabba@google.com>
 <20240416095638.3620345-48-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YtLGBtofU8oIUISB"
Content-Disposition: inline
In-Reply-To: <20240416095638.3620345-48-tabba@google.com>
X-Cookie: You might have mail.


--YtLGBtofU8oIUISB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 16, 2024 at 10:56:38AM +0100, Fuad Tabba wrote:
> To check for fpsimd state ownership, use the helpers
> host_owns_fp_regs() and guest_owns_fp_regs() instead of directly
> using the enums.

Reviewed-by: Mark Brown <broonie@kernel.org>

It does occur to me that there's probably enough FP changes in this
series to warrant a separate series, there didn't look to be much
overlap, they look good and as you say in the cover letter this is a
rather large grab bag so splitting out should make things a bit more
digestable.

--YtLGBtofU8oIUISB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYeWRsACgkQJNaLcl1U
h9AQ4Af+O4WCapne7GlaxNoCENkI1E1e3vTqV6iLMp/bXgwVSFcaAmWRYdFp9II/
PtNlEp45tM3f24Gg41ma7JwEMrFdsqhiog00lWvN3W8Kr4OeYzF1DXkrIDBBTioP
0xvpPqR5APYV7DqOZ5lek4ONxU46Vp+sBy5dhHPE9ufVc/KXJR2pBp65+Nq77v3j
dEXp19G79nRuZ0EoXHbTs4QQMcKTlvmbvhmyU2RkEyDj4c77DQrV124bwRZ8H9qw
JukKSWr29ucyK43Iu015qOf/bBrshwV9a8Pn7QiBmJV2FiWglwIpsu3TdKArU69U
fVqENOCfy0GCYEWyjOo3ZKFOu53QeA==
=hR/c
-----END PGP SIGNATURE-----

--YtLGBtofU8oIUISB--
