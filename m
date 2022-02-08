Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2142CC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 16:29:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91EF64B0E1;
	Tue,  8 Feb 2022 11:29:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PhK7Yd8eyDC7; Tue,  8 Feb 2022 11:29:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1357B4B0BE;
	Tue,  8 Feb 2022 11:29:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8C854B0BE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 11:29:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b53g1rxRmO85 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 11:29:46 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB57A4B08A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 11:29:46 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id F3249616CC;
 Tue,  8 Feb 2022 16:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D110C340E9;
 Tue,  8 Feb 2022 16:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644337785;
 bh=+5Zu36w3Z7l8aK82NgoCsT/t+kuTmdRMQt5D0ZAJBMo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=e4DR/H1wqwak6irFSXmGw+vNSINk7ar41kFh7cZotPij1MMinQNEv8LXyJPxRAScb
 /6myfP0y33b6uDhNjpkORwhUDiZIsD7mPy7E4FAaK5jWwetoC69RztqKaVATftr/P+
 7vGuQke/gzTjfOne0ktSL+M16ufNgFhETvVUI0c9evHXlmT6qPjqbjifokC4Z/mGEC
 kChXNHcr7TRH3dG8drmtjY5e2AxOMdXiHqB5spM43IF1vMYA4d95l8qNcT1kuud9Ph
 ORlU5wDGvwJ8ibuvnozIZEBTKulGk25RpZsIjONZy2iz5ugLeTO10OkM/R5qVTcnRa
 eHo+kt8rAiHgg==
Date: Tue, 8 Feb 2022 16:29:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v11 35/40] kselftest/arm64: signal: Handle ZA signal
 context in core code
Message-ID: <YgKaczaZ0viHb/YN@sirena.org.uk>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-36-broonie@kernel.org>
 <c69632e7-45d1-b29f-79a9-1724cbb0a30b@linuxfoundation.org>
MIME-Version: 1.0
In-Reply-To: <c69632e7-45d1-b29f-79a9-1724cbb0a30b@linuxfoundation.org>
X-Cookie: This is your fortune.
Cc: Marc Zyngier <maz@kernel.org>,
 Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 Alan Hayward <alan.hayward@arm.com>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6472372254254975019=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============6472372254254975019==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hDl71TpnNMq68KTE"
Content-Disposition: inline


--hDl71TpnNMq68KTE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 07, 2022 at 06:01:49PM -0700, Shuah Khan wrote:
> On 2/7/22 8:21 AM, Mark Brown wrote:

> > +		case ZA_MAGIC:
> > +			if (flags & ZA_CTX)
> > +				*err =3D "Multiple ZA_MAGIC";
>=20
> Is this considered an error?

Yes.

> > @@ -165,6 +198,9 @@ bool validate_reserved(ucontext_t *uc, size_t resv_=
sz, char **err)
> >   		if (flags & SVE_CTX)
> >   			if (!validate_sve_context(sve, err))
> >   				return false;
> > +		if (flags & ZA_CTX)
> > +			if (!validate_za_context(za, err))

> If validate_za_context() finds an error, the above "Multiple ZA_MAGIC" wi=
ll
> be overwritten? Is that the intent?

Both are errors.

--hDl71TpnNMq68KTE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmICmnIACgkQJNaLcl1U
h9A89Qf/bcWFc2MLnS6lvBGeighVtkeAqCfWm9YihdqQjIThY5aJ/fW6K8RQY409
QkDbHUYvra9/O4gXHqcsFIYVy3pKSEUa1Kq4FJ0cSbAPEm8q0pF5LHYmjmO7GO0P
W2mTrEAv8pOhTNESQknhFBUWPSX6dlz204grYPCpZcTV6bSyf0YqK7yNcu4eSxY2
Tbfinmr8oigfvgZkXsMxtEvat9XPrWVCdhA63VaN1iPS8UblN7870cqUMziLlcpH
0HFiEE9rz9+5IJPDZ4qL6aAfNRI1iGompzji4fq0J7EA47PuyTk4NdVFoIYM9zN/
rC4/4/JM1h5ZoMejHTJjyZAXiQYtJA==
=XzJM
-----END PGP SIGNATURE-----

--hDl71TpnNMq68KTE--

--===============6472372254254975019==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6472372254254975019==--
