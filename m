Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D1E29420
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 14:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CSocTLgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277F7C433CD;
	Thu,  5 Oct 2023 14:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696516478;
	bh=sQ2srEi0b2XH8T1sYR7jgmvL2WfJodHJQZXAgnuxNlM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CSocTLgAY5/6Phamzxi50ZG69HrdvxXYLUCOkXzzv969cuIpUoa488qW98qkEqIt1
	 8K0bnrqi7NWlNFF09BJz4bzpPpbEd6gGABgST0YTq5DADx8YpMtwES3oL0t+Js1DT1
	 MCVPm5L/3lfwRZYMKkbQuYdPLEnrqhM8wgEcSLzwJdOAL28yYk2oGRKOfT5GWB4Lyo
	 DtS+dtpH2RUSipWw7t+DI8/cENPOJcioVn0eMjn3if7NQPblwbCb3ZGOatzJj5WjQN
	 xF1A6vpkwi8SE2EbllhcwDIwE77aPnugShuoOWh09sF7TNhDpc3HsphMpUaZKa0G+/
	 WKMetUX+Sq0Rw==
Date: Thu, 5 Oct 2023 15:34:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, nd@arm.com,
	akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
	catalin.marinas@arm.com, dave.hansen@linux.intel.com,
	maz@kernel.org, oliver.upton@linux.dev, shuah@kernel.org,
	will@kernel.org, kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 15/20] arm64: add POE signal support
Message-ID: <a6e6c8a3-15b1-48e3-84fa-810ce575c09a@sirena.org.uk>
References: <20230927140123.5283-1-joey.gouly@arm.com>
 <20230927140123.5283-16-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WLRKWcscLabNT1/4"
Content-Disposition: inline
In-Reply-To: <20230927140123.5283-16-joey.gouly@arm.com>
X-Cookie: Avoid contact with eyes.


--WLRKWcscLabNT1/4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 27, 2023 at 03:01:18PM +0100, Joey Gouly wrote:
> Add PKEY support to signals, by saving and restoring POR_EL0 from the stackframe.

It'd be nice to have at least a basic test that validates that we
generate a POE signal frame when expected, though that should be a very
minor thing which is unlikely to ever actually spot anything.

I'd also expect to see matching support added to ptrace.

--WLRKWcscLabNT1/4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmUeyXUACgkQJNaLcl1U
h9CUZQf8CN1ssSeTf7ufoOpnpdNpmJE+IVKzV0EWSfKUEpdlxUMVi4w10Q0mNZ9V
dG+lgaoo635yb2x02jONm0bcFCd7863DRJW4HQDoyAVCD88mKwT0jq4ym/o5soqM
OpGH3vfAWG588p9vFah3crvcyvfeiM7AruYNMbls4pD8Zv1wDdDhLy7XwW4D4STu
IGMwXbyfNRsgOxPXwdWk8NX9wHmxB/nK39z6oKVc6pf3Cx3u1HqFPfFd0iGUj8Mf
rRyRDFmTA1/Q5MsbqqejgvE3SUwz1nCkfa7DuvNlSMMRB/+EZ/yQfHvmu5DrfIfs
uKVBL31MMTcpyFgBVMLFIR/z1VXCgA==
=mhPy
-----END PGP SIGNATURE-----

--WLRKWcscLabNT1/4--
