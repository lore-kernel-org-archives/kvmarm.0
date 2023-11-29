Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176B53AC19;
	Wed, 29 Nov 2023 16:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="acJpDzkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9248DC433C8;
	Wed, 29 Nov 2023 16:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701275227;
	bh=GwC4XY5uvJk/yRp22B+OakqJ33CPv5WWStiKtTgdZ1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=acJpDzkvFaC19Wixe4FsPIxaEbIQ/rGiElA1YztWdmEvhOA2ka9rKnCZu+rlzKh+R
	 JAXiIlVjd6f4Z4FR5+Exz2sdIQHl+AL8xEf9XHwnCWamnUT6LbJbmyNV1R1rwmU0gB
	 //CqOlc7T8G65thnCQIp2WWMnD3+tOh1eMtnFLRYi+YZoh9H0w78ypEWPsnzT9XRhH
	 E1q/YHbHckcwGFB2FBvff4KIDW5AFdsh23S3Cc3gTCy31Rj4pPiNmGDVAiZJ0Pn1ht
	 D14SePrMXtxnZAYx98l8eb7QlDMCzeHMEMqRVeqjRGgTI9Kyfy2EIO71baTC/Jzgit
	 5d2SL5x2C98Qw==
Date: Wed, 29 Nov 2023 16:27:01 +0000
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
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/2] perf build: Ensure sysreg-defs Makefile respects
 output dir
Message-ID: <c701bf6b-0ff0-44a0-9d1d-84e8515d077c@sirena.org.uk>
References: <20231121192956.919380-1-oliver.upton@linux.dev>
 <20231121192956.919380-3-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mCUpdAwQuB6wbXWa"
Content-Disposition: inline
In-Reply-To: <20231121192956.919380-3-oliver.upton@linux.dev>
X-Cookie: Jesus is my POSTMASTER GENERAL ...


--mCUpdAwQuB6wbXWa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 21, 2023 at 07:29:56PM +0000, Oliver Upton wrote:

> Currently the sysreg-defs are written out to the source tree
> unconditionally, ignoring the specified output directory. Correct the
> build rule to emit the header to the output directory. Opportunistically
> reorganize the rules to avoid interleaving with the set of beauty make
> rules.

This breaks some build configurations:

Running:

make --silent --keep-going --jobs=3D56 O=3D/home/broonie/.cache/tuxmake/bui=
lds/16/build ARCH=3Darm64 CROSS_COMPILE=3Daarch64-linux-gnu- LLVM=3D1 defco=
nfig
make --silent --keep-going --jobs=3D56 O=3D/home/broonie/.cache/tuxmake/bui=
lds/16/bu
ild INSTALL_PATH=3D/home/broonie/.cache/tuxmake/builds/16/build/kselftest_i=
nstall=20
ARCH=3Darm64 CROSS_COMPILE=3Daarch64-linux-gnu- LLVM=3D1 kselftest-install

gives:

make[4]: Leaving directory '/home/broonie/git/bisect/tools/testing/selftest=
s/kex
ec'
make[4]: Entering directory '/home/broonie/git/bisect/tools/testing/selftes=
ts/kvm'
Makefile:270: warning: overriding recipe for target '/home/broonie/.cache/t=
uxmake/builds/16/build/kselftest/kvm/get-reg-list'
Makefile:265: warning: ignoring old recipe for target '/home/broonie/.cache=
/tuxmake/builds/16/build/kselftest/kvm/get-reg-list'
make -C ../../../../tools/arch/arm64/tools/ O=3D../../../../tools
make[5]: Entering directory '/home/broonie/git/bisect/tools/arch/arm64/tool=
s'
/home/broonie/git/bisect/tools/scripts/Makefile.include:4: *** O=3D../../..=
/../tools does not exist.  Stop.

I'm using tuxmake with:

    tuxmake -a arm64 -k defconfig -r docker -t llvm-17 kselftest

to invoke the build.

Bisection log identifying the commit that failed:

git bisect start
# bad: [1f5c003694fab4b1ba6cbdcc417488b975c088d0] Add linux-next specific f=
iles for 20231129
git bisect bad 1f5c003694fab4b1ba6cbdcc417488b975c088d0
# bad: [1618cb8f574175a196b0e8926c62efc45760e856] Merge branch 'for-linux-n=
ext-fixes' of git://anongit.freedesktop.org/drm/drm-misc
git bisect bad 1618cb8f574175a196b0e8926c62efc45760e856
# good: [18d46e76d7c2eedd8577fae67e3f1d4db25018b0] Merge tag 'for-6.7-rc3-t=
ag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux
git bisect good 18d46e76d7c2eedd8577fae67e3f1d4db25018b0
# good: [c33497720d50d39a9f3918975ee691ad570b77a6] Merge branch 'for-linus'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git
git bisect good c33497720d50d39a9f3918975ee691ad570b77a6
# good: [35fb33a953396cae852e18a316173f5a2887bb0a] Merge branch 'fixes' of =
git://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git
git bisect good 35fb33a953396cae852e18a316173f5a2887bb0a
# good: [09a2ad2501da54228679dd21aaef72e783034a4e] Merge branch 'kunit-fixe=
s' of git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.g=
it
git bisect good 09a2ad2501da54228679dd21aaef72e783034a4e
# bad: [a29ee6aea7030786a63fde0d6d83a8f477b060fb] perf build: Ensure sysreg=
-defs Makefile respects output dir
git bisect bad a29ee6aea7030786a63fde0d6d83a8f477b060fb
# good: [fd2ddee727d1ae9296b3875087410cc3698885f0] tools headers: Update to=
ols's copy of socket.h header
git bisect good fd2ddee727d1ae9296b3875087410cc3698885f0
# good: [b3b11aed147af8f7c3d79c5b0b7474505d1dde7b] tools/perf: Update tools=
's copy of x86 syscall table
git bisect good b3b11aed147af8f7c3d79c5b0b7474505d1dde7b
# good: [d3968c974a2453de9289bdb9d34130b2ce323628] tools/perf: Update tools=
's copy of s390 syscall table
git bisect good d3968c974a2453de9289bdb9d34130b2ce323628
# good: [ef5c958090a909c9f2ab717ba6abb86869e42da7] tools perf: Add arm64 sy=
sreg files to MANIFEST
git bisect good ef5c958090a909c9f2ab717ba6abb86869e42da7
# first bad commit: [a29ee6aea7030786a63fde0d6d83a8f477b060fb] perf build: =
Ensure sysreg-defs Makefile respects output dir

--mCUpdAwQuB6wbXWa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmVnZlQACgkQJNaLcl1U
h9CyQAf+O203S5VakDekJEwudWmw65mzZ6ucKwQ0lZmDZRJXrSXdhI4cYCa6mKcy
YIVfj1IpfhjYA1WQ8noc7+gnCNglSXkr1h9tGvQMRTyI9F5af2ShDLSAp5S5iCAA
STjTL5KArB6Y86qJYIpfgu7g7rYiWYKhH0v7hSrojlUGxONnDAbUvFncXsa21o9h
CJLdkko4ZD75fm813Qow1dSQkoUlKrkQjWxkW8VQ1S0boV3u/atduQngBxvpv8iu
9kqSPCMBEh2H5+dS302xwJR8LYWTTtVTRUYgIPJIlE5u1QmHrArV7bsT2evrYLLA
l8RJr+j+ZEl92E24gVIWZWtcE8cMdw==
=G/h/
-----END PGP SIGNATURE-----

--mCUpdAwQuB6wbXWa--
