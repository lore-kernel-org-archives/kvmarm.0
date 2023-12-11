Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12823D96A;
	Mon, 11 Dec 2023 13:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MAbgVEYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0D8C433C7;
	Mon, 11 Dec 2023 13:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702300748;
	bh=0LICz3NV/b1yKNhgHKoBINohXbnmCyWLb6rLf1p46DE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MAbgVEYjCDCSAQJg0EIlhnV+3IKTMnFUfGsLXXm1FQ4tiPKzqRmYKKZZc+xFdxwPo
	 4XbRZ35O0AdHrBBzEA9geLfY07FnX7mX93hpAN4pcHE2SB5Vvz1rX8i25PCRQBSQy2
	 Z7yqSXMmk+lAdkivDkXT3cvjo0ROdbjgf5WPbGWxh7wVX3dH3KcatO2PMJsIfq5Cr3
	 DgCdhccwing4T+GqCiiwLju4S0y6va6QQG5j4VxtuR7gbRiMpft91c8KGRB4i0r+i1
	 aFz1U9tsMCIl6Mx3JHRzjD8CpRvU2aSptItxK/eRHLatfpE0Udu/0ABzl84w3V+87z
	 hsLk+/P0Iw0vQ==
Date: Mon, 11 Dec 2023 13:19:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Marc Zyngier <maz@kernel.org>, torvalds@linux-foundation.org
Subject: Re: [PATCH 2/2] perf build: Ensure sysreg-defs Makefile respects
 output dir
Message-ID: <bec12895-38d0-46d3-8031-53c55f88f3a7@sirena.org.uk>
References: <20231121192956.919380-1-oliver.upton@linux.dev>
 <20231121192956.919380-3-oliver.upton@linux.dev>
 <c701bf6b-0ff0-44a0-9d1d-84e8515d077c@sirena.org.uk>
 <ZWui3KxloT5tcIsJ@thinky-boi>
 <80ff02a5-8355-437d-b844-3de9fe182518@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8arJGlBOO+Ld09B2"
Content-Disposition: inline
In-Reply-To: <80ff02a5-8355-437d-b844-3de9fe182518@sirena.org.uk>
X-Cookie: Paul Revere was a tattle-tale.


--8arJGlBOO+Ld09B2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 06, 2023 at 01:45:56PM +0000, Mark Brown wrote:
> On Sat, Dec 02, 2023 at 01:34:20PM -0800, Oliver Upton wrote:
> > Thanks for the bug report. Apologies for the latency on my end, I've had
> > a mountain of non-upstream stuff to wade through.
> > On Wed, Nov 29, 2023 at 04:27:01PM +0000, Mark Brown wrote:

> > > This breaks some build configurations:

> > > make[5]: Entering directory '/home/broonie/git/bisect/tools/arch/arm64/tools'
> > > /home/broonie/git/bisect/tools/scripts/Makefile.include:4: *** O=../../../../tools does not exist.  Stop.

> > Looks like its because $(PWD) is tools/testing/selftests/ when building
> > from the top level makefile. I'll get a fix out in the next couple days
> > after I find my Make dunce cap :)

> This issue is now in Linus' tree.

Any news on this, the problem remains in -rc5?

--8arJGlBOO+Ld09B2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmV3DEUACgkQJNaLcl1U
h9CmPwf/c2i6pCa5H4N6bRabFihpQNKAH5Pgz0AsaID7Va83Qdzs12K3zYjy7nqy
dMsnFR0OkGVwEYowQhG4Y23CDsY+bcOogK6yrNctC6VQnuB6Bl+7tta3+gBR1iV1
wQYi8u4HVt+ubufg6stBbd7132LQnHQYc9iR8uw/yy2UTdS9updwmg5Lcluog8/C
/06Bb/Ozu6mBdtTNk5ZhEE1j+5jMmo6B/9WNzQYcyLDwaM+pLAwmf1yDZ5+St6Do
fFyjM5erpQVodqjvyhfjtXSlR7CTQ0hS5PdIdyoTA0mfoQ8IlDd/Mrh9BaNcNxuA
wlWc2OIGp2Azte5G0cSkwj9jJ/toyQ==
=pyQ3
-----END PGP SIGNATURE-----

--8arJGlBOO+Ld09B2--
