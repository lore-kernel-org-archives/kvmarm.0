Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1D3184E;
	Fri, 23 May 2025 15:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748013325; cv=none; b=fYCTMXvypmQCv7kWy0fAjNoZJV4l3cAhzYRjf/cMF5dv8SjSZWheWw5KGvLjmNDFwtfyQ8YSWRNKf+VpQSKcQ67g814RDOxuxRQTe0gqhUqRKxL1FDDu+RVjuTv74lQ9tPgRIOZAlhi1PG3buWdAHXsUqMYlOAYMhpMWDvZPXvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748013325; c=relaxed/simple;
	bh=8VAZ+KkDBpgajXwea43E3Jxb6kQkvjoqXTpZNv0Qq/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qoocdpi1T2eQ3gI+I1KLIb9ICi7CVWyPtwcAq2DfpFUXniW4rhxEQnoz/f1QLPgOSAT1g+btRcomoFzEqXncyPF4G2DKpYXyXWngCu6jkvqjg0LmtNUz59FNkP+Xopeg4iBi2Tc0V5nHydm7ALWwrhkuOlHZVI0NdP9esaQTFRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pGQkJ1lC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pGQkJ1lC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A632BC4CEE9;
	Fri, 23 May 2025 15:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748013324;
	bh=8VAZ+KkDBpgajXwea43E3Jxb6kQkvjoqXTpZNv0Qq/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pGQkJ1lC2/A+T2pz2yWocsEtvsiqUZZrEeNtanIv8DT3RFBAWPuP02jbRJFNFDE48
	 GPc9LopvR4eQb5iPOTsgmVrNhJK5RNWA8Z+yd3hTrF2m77McGnQ9/5QuxbMW/FxrNc
	 2ZDgRw10qC8TiiQmZtLDUdSWao72gM270Um0KAHv07hw3TbFOx+Savswqx7MRCqSDy
	 3mDPWLDYDimovIXkUlDJBztZv9zymx/F2+r48fjhnLX8OBeQYHYG7IlKluNy/IOgAJ
	 uJUPEJSPOS0ilK4HrOdJghDxRLydoNNXRPPxayHHhOTb8qNjaIDMdAAW1Es2AxqUGS
	 x37eWYDlYP0ag==
Date: Fri, 23 May 2025 16:15:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: D Scott Phillips <scott@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Clark <james.clark@linaro.org>,
	James Morse <james.morse@arm.com>, Joey Gouly <joey.gouly@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	"Rob Herring  (Arm)" <robh@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>, Will Deacon <will@kernel.org>,
	Yicong Yang <yangyicong@hisilicon.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] arm64: errata: Work around AmpereOne's erratum
 AC04_CPU_23
Message-ID: <aDCRCOSB287IafJL@finisterre.sirena.org.uk>
References: <20250513184514.2678288-1-scott@os.amperecomputing.com>
 <aDCDGZ-G-nCP3hJI@finisterre.sirena.org.uk>
 <87wma7e5jd.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+Yyr2O7xEu/r8n9d"
Content-Disposition: inline
In-Reply-To: <87wma7e5jd.wl-maz@kernel.org>
X-Cookie: Well begun is half done.


--+Yyr2O7xEu/r8n9d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 23, 2025 at 04:00:06PM +0100, Marc Zyngier wrote:
> On Fri, 23 May 2025 15:15:53 +0100,
> Mark Brown <broonie@kernel.org> wrote:
> > On Tue, May 13, 2025 at 11:45:14AM -0700, D Scott Phillips wrote:

> > > On AmpereOne AC04, updates to HCR_EL2 can rarely corrupt simultaneous
> > > translations for data addresses initiated by load/store instructions.

> > This patch, which is in -next as fed55f49fad181be9dfb93c0, breaks the
> > build of at least the vDSO selftests:

> > $ make -C tools/testing/selftests ARCH=arm64 LLVM=1 TARGETS=vDSO

> >   CC       vdso_test_chacha
> > In file included from vgetrandom-chacha.S:9:
> > In file included from ./../../../../arch/arm64/kernel/vdso/vgetrandom-chacha.S:5:
> > In file included from /home/broonie/git/bisect/tools/testing/selftests/../../../arch/arm64/include/asm/assembler.h:21:
> > In file included from /home/broonie/git/bisect/tools/testing/selftests/../../../arch/arm64/include/asm/cpufeature.h:13:
> > /home/broonie/git/bisect/tools/testing/selftests/../../../arch/arm64/include/asm/sysreg.h:1097:5: error: function-like macro 'IS_ENABLED' is not defined
> >  1097 | #if IS_ENABLED(CONFIG_AMPERE_ERRATUM_AC04_CPU_23)
> >       |     ^
> > 1 error generated.

> This:

...

> should solve it.

Yes, that works.

Tested-by: Mark Brown <broonie@kernel.org>

> But it also outlines that the vdso is getting built using stuff that
> is not meant for userspace code.

Indeed, adding Jason for that.  It's the same for all architectures.

--+Yyr2O7xEu/r8n9d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgwkQUACgkQJNaLcl1U
h9BDdAf5AeNkCRljY3IolOsbcV9AvHe7eansIWFCvJ6HxTOQqQmsS6T+op6eJZ4a
0N8yNPVxuuydStcSR1kFeoTrr1eYs6hQYMeU4oEidizB9l2d9pxxD9dpZN4eW0jf
JFwE9/4NsSn2IP1XC729xvE+FYZdkkD+u8R72XlUN1z6DNkqPv+Sm/UVgmTnpFKl
PRJ6dD0yPP0uhpa8cfWkB9lkNtwzGFnqiznOSALxyZfEymhH8v3SVu3Vi+6mXApd
V6LBBs9lr3K+V8rUmpM8KfcQj1UoQC2tMNhZq0LyHLkAJUlwkfQnU/HFaC5WJZOb
mhSFdprkC8hgYBfU0eRXxq1KmCOiVw==
=BxGU
-----END PGP SIGNATURE-----

--+Yyr2O7xEu/r8n9d--
