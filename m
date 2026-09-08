Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A2D3BE63F;
	Tue,  8 Sep 2026 20:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900933; cv=none; b=rKw03OeHXR58rZCaP5gZ6TsXFMe6d+iVKJ5y/kk+nttxD1NwaMF9XF71aAJCTY/fWMNU7XpTya2kJGIgM1LGAvlwgYZTXV0WGV8SOQmj7ydaBr7U7vxCxC1Z4Yya/6mpfEwYsT7jV/TtaChME7AUZpAk+OwS5k2FgF4m4l3pN/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900933; c=relaxed/simple;
	bh=toPQwwfV7kExNIA7hPDUbKJWuQC5GHRKZSUYt5snD7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DwozxVv6yNAsgyhX8tLt5RgBdbkhaGf/Cmh77ZaN/JMHcQENcK95MJB2nLUV7rDVKP/dNHWOFud3Ug+msAsm98EusDPX/I4ATgvjn0VdxGvXVfAwz/ZrWR8rvc9ZHDB/+O/jf5lp+7cZFEbZ3eeCXawxqofaytfmTWG8m3DltiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bH432aN9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bH432aN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874821F00A3D;
	Tue,  8 Sep 2026 20:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900931;
	bh=1uibw2TfiC6HvFhUFm+IAjNAm8mfOIU1JNvWdlbkxPM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bH432aN9Ku9p+MHpYzOcN9kJiqYoB6N0GR5WaCaABlRZurI8oD9dEZJL//xCzvevE
	 kbU5I/dvqhKampcmVdFBn/yST50K1WgWzL+TNLm/yWXXMbnq4fJ98pcpWq0vLMxCLT
	 bI33PPQfD14jkayWmljlqlSRTrFm7JCgNUJ17wmIA/UeqjvA6qFU7MnvrxnPK5wIf+
	 6QhjdiQgmNmXalsoYEguKf9CjX2eXwSMIKYWj4qqTMBMbvpDjNn6sbbeuTwaf/4OkP
	 jVWRPujL51Za1FiNlCBzUlZEmFaRUFLjEjaY+PeXrIJSugth6y2tL7KO+VSnOEmQQp
	 JBrhSnsYmqrlQ==
Date: Tue, 8 Sep 2026 21:55:27 +0100
From: Mark Brown <broonie@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2] KVM: arm64: Enable S1PIE for hVHE
Message-ID: <009c4b0a-ee2f-4d0f-8525-3b09c7a36a5d@sirena.org.uk>
References: <20260908-kvm-arm64-nvhe-pie-v2-1-79e42d28cc08@kernel.org>
 <20260908203145.B735E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="stSNjZ1uV2JeIt9k"
Content-Disposition: inline
In-Reply-To: <20260908203145.B735E1F00A3A@smtp.kernel.org>
X-Cookie: The world is not octal despite DEC.


--stSNjZ1uV2JeIt9k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 08, 2026 at 08:31:45PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:

> > +	/* S1PIE is only enabled with TCR2_EL2.PIE if we are running hVHE */
> > +	mov_q	x1, KVM_HVHE_PIR_EL2
> > +	msr	REG_PIR_EL2, x1
> > +	msr	REG_PIRE0_EL2, xzr

> Does this initialization swap the target registers? Since hVHE uses TTBR0_EL2
> for its translation regime, permission indirection for this space is governed
> by PIRE0_EL2. By zeroing PIRE0_EL2 and writing the valid permissions to
> PIR_EL2, won't this cause the CPU to evaluate execution permissions as No
> Access and immediately trigger a Permission Fault when the MMU is enabled?

This has been doing remarkably well in testing...

--stSNjZ1uV2JeIt9k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqgdj8ACgkQJNaLcl1U
h9AYxAf/Sug1t39pN0qQ0Z+d1SM6srXjocEHsy8V5bY8UfqmlEGF8DaEjfI+vdtX
H2SrgbiLfm+j0V50FA/Ey6PKvKlWAu94oOOe6Bdeo3RHK3HFV8salC5f86EUYs3w
rGFSRbS//jdIlEr3L0MOCQEcAOQIcPvCcrZYVXbKCpXY5Wp6fICv4JAEobc+Tjg4
dOygQBeDgnas8TpGcvTMkrdOOjvdxu25lZ+eyEABU7rGVDzzyrPvRTnubdiKW9YR
YxpCl8Qp3vtmevtfvcsv93HeNGRntx6HAPRDPQD6YiEVndwLLGmYtSphymtjGZGl
/zcdHwU2ZbVEE3fGo/3iTNb5udwFXw==
=14Up
-----END PGP SIGNATURE-----

--stSNjZ1uV2JeIt9k--
