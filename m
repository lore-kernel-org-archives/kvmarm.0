Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7DDDF44
	for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 11:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cFRk+rVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24079C433CA;
	Tue, 10 Oct 2023 11:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696938996;
	bh=0AsCbMCrI7tvcpSVF4Jgy/rDJw8pbCcpiPc+/XLXw0Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cFRk+rVPpc3FOAiT8Od45wyxyPPnbtz6S5U823POW2R56qGu9e5slu/QdzGo7C0yk
	 HzIqkLZiq0iLFTmVAoQd2fjlG4KUg6hDtcsj+Au2jf+fj7jGWREV83JqoBAbb1Mx6O
	 LdWAD542yHPL097UbVE19BP0g4frWS6u2Yv7SlTZJ6zQFVWPnVuotU9R9DBTh2HtxX
	 1O9AOOKrdUENiTO+CmeKJiCvYXEgTBI8SYyzFDG021IGOu9VK1c22yWoy/fqVaZt+x
	 VT16pRttM5pCyAD719k+ohC3ndo2qph8Ziy23+LMwk3w9jQnoq63rzplfWD9784xzA
	 KghZr/QCYAsTQ==
Date: Tue, 10 Oct 2023 12:56:30 +0100
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
Message-ID: <88728437-2486-43c3-9fdb-fcd14ff39f11@sirena.org.uk>
References: <20230927140123.5283-1-joey.gouly@arm.com>
 <20230927140123.5283-16-joey.gouly@arm.com>
 <a6e6c8a3-15b1-48e3-84fa-810ce575c09a@sirena.org.uk>
 <20231010095702.GB2098677@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="L3OvJ2NHt06D34tb"
Content-Disposition: inline
In-Reply-To: <20231010095702.GB2098677@e124191.cambridge.arm.com>
X-Cookie: I feel partially hydrogenated!


--L3OvJ2NHt06D34tb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 10, 2023 at 10:57:02AM +0100, Joey Gouly wrote:
> On Thu, Oct 05, 2023 at 03:34:29PM +0100, Mark Brown wrote:
> > On Wed, Sep 27, 2023 at 03:01:18PM +0100, Joey Gouly wrote:

> > > Add PKEY support to signals, by saving and restoring POR_EL0 from the stackframe.

> > It'd be nice to have at least a basic test that validates that we
> > generate a POE signal frame when expected, though that should be a very
> > minor thing which is unlikely to ever actually spot anything.

> The selftests/mm/protection_keys.c looks for the POE signal frame, do you think
> we need a separate test?

Like I say it'd be a very minor thing to have one - it is more just a
thing you'd go looking for in the signals tests rather than something
that's absolutely essential.  For trivial things like TPIDR2 I've just
added a trivial thing that verifies that the frame is present iff the
matching HWCAP is set.  Having the test in the mm tests is probably fine
though.

--L3OvJ2NHt06D34tb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmUlO+0ACgkQJNaLcl1U
h9ALhQf+MAF7Qb061DA3jMKL8gAGgi2jobi8C9/WrJz95wSSl4KzgskqrM2Kxh8d
ZLh0UpnLrsEk9Qze9IOzzdnbbn/VD6ENZ/vDRlWzvih8xVZxpoL1MiLqBSRsU78W
WANs6c4fPBTQMLGlFEzz3YwYXcwQEqUyY4xmp8O8jbCzu1GYU29kafcXb6aypmgT
YIPw2K8RecnKlhbjZRULjPa1TPZrGiq0/6zR1BhauqiJmVoYwcpvqc+WK4ZBSb+w
5Td1tJT8KYSK43lBFqHY8gUk2s6M+BtANBsGCgyDjGlPjsvgusWNevKkaZ/l9mRO
M9fyqG5gtyPbIU7dRP51Mnw19dgsxw==
=hd/I
-----END PGP SIGNATURE-----

--L3OvJ2NHt06D34tb--
