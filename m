Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859C535208A;
	Fri,  5 Sep 2025 13:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757079528; cv=none; b=k1M2xfCRhbU9smknKlme+pecHD19SI+Yx8nBP0HrElNespKZWm5eby0Gp4izy8jkre8MuzvXvKxVYY0y2AP2sCj4ewyrGt49BDKdDF3tMttAG4qj6r99LhQ6/Nxxc1BPxVU6HbkzCK3vQ9ZfPFky9eAOZXPh6VV7zAfjT0nllXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757079528; c=relaxed/simple;
	bh=+RfIeCiYHGfOQAYZpOBH5xFxrQIjFV5rbqolCOJUiVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LVgq8ij0+NGbBuhU3JB2Cvk6bPAyiR8TLT/XdJOSG2NoRl/5CCb/jOszc7zif+KM9Qlla36kbzhJxyzPp1x5rIwQ00LNmRJ/hmgLqaFYeXPHZTZV6gbyXXqu+r56gtQPE4SyjRI4zC7GYt67YD7iC0HWHNH43E8sEAT8CkXwyFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=goqvWAlu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="goqvWAlu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B7FC4CEF1;
	Fri,  5 Sep 2025 13:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757079528;
	bh=+RfIeCiYHGfOQAYZpOBH5xFxrQIjFV5rbqolCOJUiVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=goqvWAluxfzf8BkxFwUH6Ln7miVt6sUnhYEjzlJ0bfEm6Z+hkN7Vbm+5YeSyn4CZq
	 nfc/ZWNn4ruTbxMbNZUqC/HtAnC6ie9u7NgP+pl4PTtHfQIkHasEbxJQCEIuZG7c6G
	 3YJH26/oE9qL2Xkghwa6/0lf4A3/FEFYpnEgDsQvJkjT2T2ftwdCzOHTphbw1NRKn8
	 HV1egnOIdjeyvJpeDSdBn/jomeNlNAN6ZnNGOsiwu7EutupADa1bHHpkcN4zKF34qr
	 Xi/Xfb07GAaelXX5R9irbB92nla6CsdO+hpRpj2iAnhtRUIGi52egIr9m97RUdDx7h
	 3YfsrU1YqhEGA==
Date: Fri, 5 Sep 2025 14:38:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, kvmarm@lists.linux.dev,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	open list <linux-kernel@vger.kernel.org>,
	lkft-triage@lists.linaro.org,
	Linux Regressions <regressions@lists.linux.dev>,
	Fuad Tabba <tabba@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Anders Roxell <anders.roxell@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ben Copeland <benjamin.copeland@linaro.org>,
	Aishwarya TCV <Aishwarya.TCV@arm.com>
Subject: Re: kvm-unit-tests hang on Arm FVP with protected mode
Message-ID: <345e42db-eabd-4e34-abf5-d9974dfe55d1@sirena.org.uk>
References: <CA+G9fYsT3b3Qd-m6tSDOgAXpgLPWz0QD_Z6a+_ff4oTecA85PQ@mail.gmail.com>
 <87ms79ystc.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ftKo7STfvoWEjFz0"
Content-Disposition: inline
In-Reply-To: <87ms79ystc.wl-maz@kernel.org>
X-Cookie: He who laughs, lasts.


--ftKo7STfvoWEjFz0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 05, 2025 at 01:42:07PM +0100, Marc Zyngier wrote:
> Naresh Kamboju <naresh.kamboju@linaro.org> wrote:

> > INFO: running kvm unit tests ...
> > + [ True = false ]
> > + ./run_tests.sh -a -t -v
> > + tee -a /lava-1/0/tests/0_kvm-unit-tests/automated/linux/kvm-unit-tests/output/result_log.txt
> > TAP version 13

> What do you expect us to do with such a non-report? Can you please, at
> the very least, identify which test in that test suite triggers the
> failure?

Looking at the log file that isn't password protected that's the last
line of output so it'll have hung trying to do the first test, based on
the log from another machine:

   https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250905/testrun/29777055/suite/kvm-unit-tests/test/debug-bp-migration-timeout-duration90s/log

it seems that should be

   ok 1 - selftest-setup: selftest: setup: smp: number of CPUs matches expectation

that's died for the version they're using.

> > Links:
> > https://regressions.linaro.org/lkft/linux-mainline-master/v6.17-rc4/lava/kvm-unit-tests/history/?page=1

> What is there? This link requires a login, and goes to 11 on the
> scale of being useless.

My Linaro account appears to have been disabled at some point so I
can't access it either.  If this is affecting mainline presumably it's
been an issue in at least -next for a while.

--ftKo7STfvoWEjFz0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmi65+AACgkQJNaLcl1U
h9DLewf+Ls/00LL8UkAstP2PfYnm8MYv7sEGvfU6pcxX76rmhhoo+wHh/P4hYxIc
GnEmWTawHaooNeTHseqYhjmZExdIu4kjBFLylfnR0kl70I7Z9fj2lNke/I5l6esd
y6+T8DWSATVhQTebL9S/tmeQ223uLeJxoWU3o2Cex5787ehN5TMly7bqCBleQNrE
C6WrgNNVDCffoSsFFv+CCCRtptBgSIUmJTox4dxFIAvmJ3NLhe9yB2SCvQGGWIRr
mp9DPS9eygW3mJsa3IWwmUhpA1nVrUbcmI+KFXgTdDwP36xjlLGj0E0o41TL8NiJ
O1/Rrzn/W690wZtEzwjotbV4+hBASg==
=/HVR
-----END PGP SIGNATURE-----

--ftKo7STfvoWEjFz0--
