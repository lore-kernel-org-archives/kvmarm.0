Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7923FF5;
	Wed,  6 Dec 2023 13:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QycYwDeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A860DC433C8;
	Wed,  6 Dec 2023 13:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701870356;
	bh=o60Oft731GDlPA7XOV56bwxMYcQyff+R3jG4W2ccIdM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QycYwDeEO+hyNopx5ULqCTQl1DrbXyObDcvORW+tf+GnRwDgMe0uMPuk1bgtSfJAa
	 KxyVa98cBOMUtJo+LdzjqImkqyOiVUOxY3K8OQYoHk8Eoj/crA7I4vOdV6lWKxaips
	 9sN4WP54z+bpD/88mOt5haSwnqf7VsHF85u11S31GqC5o2EvpaSYvMnjOT+G2Ypwte
	 5D83QarI1hYxpD8xJ6GDfLPRM/6f5XFUPj8DR+X3IyhzibA/snYPr6JhLyipqVYg6y
	 TM8Z13piESaIerJGyU88Id5IUGirzWE8GO5yNMTJmBimqB8YJyHh590R7rk6PPY5eI
	 FYF73kOXcu9vA==
Date: Wed, 6 Dec 2023 13:45:49 +0000
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
Message-ID: <80ff02a5-8355-437d-b844-3de9fe182518@sirena.org.uk>
References: <20231121192956.919380-1-oliver.upton@linux.dev>
 <20231121192956.919380-3-oliver.upton@linux.dev>
 <c701bf6b-0ff0-44a0-9d1d-84e8515d077c@sirena.org.uk>
 <ZWui3KxloT5tcIsJ@thinky-boi>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/TeW1QSbBaDFi117"
Content-Disposition: inline
In-Reply-To: <ZWui3KxloT5tcIsJ@thinky-boi>
X-Cookie: From concentrate.


--/TeW1QSbBaDFi117
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 02, 2023 at 01:34:20PM -0800, Oliver Upton wrote:
> Thanks for the bug report. Apologies for the latency on my end, I've had
> a mountain of non-upstream stuff to wade through.

> On Wed, Nov 29, 2023 at 04:27:01PM +0000, Mark Brown wrote:
> > On Tue, Nov 21, 2023 at 07:29:56PM +0000, Oliver Upton wrote:

> > > Currently the sysreg-defs are written out to the source tree
> > > unconditionally, ignoring the specified output directory. Correct the
> > > build rule to emit the header to the output directory. Opportunistically
> > > reorganize the rules to avoid interleaving with the set of beauty make
> > > rules.

> > This breaks some build configurations:

> > make[4]: Entering directory '/home/broonie/git/bisect/tools/testing/selftests/kvm'
> > Makefile:270: warning: overriding recipe for target '/home/broonie/.cache/tuxmake/builds/16/build/kselftest/kvm/get-reg-list'
> > Makefile:265: warning: ignoring old recipe for target '/home/broonie/.cache/tuxmake/builds/16/build/kselftest/kvm/get-reg-list'
> > make -C ../../../../tools/arch/arm64/tools/ O=../../../../tools
> > make[5]: Entering directory '/home/broonie/git/bisect/tools/arch/arm64/tools'
> > /home/broonie/git/bisect/tools/scripts/Makefile.include:4: *** O=../../../../tools does not exist.  Stop.

> Looks like its because $(PWD) is tools/testing/selftests/ when building
> from the top level makefile. I'll get a fix out in the next couple days
> after I find my Make dunce cap :)

This issue is now in Linus' tree.

--/TeW1QSbBaDFi117
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmVwew0ACgkQJNaLcl1U
h9BwZQf+MW73pdSRu957upgido7PqkFuckEEkq3GeUe10nElFaTybG6lb9NpMfPP
T9d0yc1idw3fiEf/IIYVcImkZ+MXFJlSIYlhG2zXl45px2VH1LZL6/Nyek38erXe
iLFi10eNreV3v86sUP4jd0lrbojzFbJp6gnm1vMb/D60bUiaZTa8lT2Y1fZjtvS2
IYQbnTBgmBwS8DdJYfMz2HRswL0DIQAkHWY/6Ke5bhmlgyhwGQ02SAhe+oY6LxrZ
29oRVWGxtdSyclwtyJPRYBP0094/0g9lKGg/mRot5gVula4tBgoELStW6l9GyUkl
kAYbW2ef0u0tGWdTU14Bs7TWgiFjgw==
=yyfo
-----END PGP SIGNATURE-----

--/TeW1QSbBaDFi117--
