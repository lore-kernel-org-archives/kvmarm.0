Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CDCDC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 17:28:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5D144B0F4;
	Tue,  8 Feb 2022 12:28:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LoCA1ik3Uwwb; Tue,  8 Feb 2022 12:28:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D97404B0ED;
	Tue,  8 Feb 2022 12:28:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1F604B0ED
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 12:28:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y6xdxXy43OXA for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 12:28:05 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D4F94B0EC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 12:28:05 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 79A23617C1;
 Tue,  8 Feb 2022 17:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BABC004E1;
 Tue,  8 Feb 2022 17:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644341283;
 bh=7M78n2BSeNntKAqSjER5zwyE9f1sv8EH5+w1mbaj1iA=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=YMEYLluKyfi9s/rlUd1EMng/q2lXe2UFdyG0sIWAjFnBs8rTKalB/U3N1P1zRwL5Y
 VruEK7BthjSGMnzmRj5WVyBx5S2t2dw57lFDHMt3NcZ+Y+Vw5xW5iiUazWx3WnZ4JC
 2Bctbc9ObaXbCoH+26iwm+RA0F4F8ePiNqFITnPcTIdXJOkY1GKNylegYbOrCZRl/x
 SdNChP335kkTVVOhfve0qX07LJafF/mVJSnmbR6srER1ENuoTwr09AXpK8O3K+XMAm
 7zJ6dIyeVG48mOZT8qdnbouIh1GtRKkaUj/E2+hVLNDZXaMfkvSmWvUlPFP87GTSNe
 IygPTNraLyqaQ==
Date: Tue, 8 Feb 2022 17:27:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v11 37/40] kselftest/arm64: signal: Add SME signal
 handling tests
Message-ID: <YgKoHQYJUugKuVpA@sirena.org.uk>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-38-broonie@kernel.org>
 <07428054-99b5-1bc7-ca7f-938d7c2198f0@linuxfoundation.org>
MIME-Version: 1.0
In-Reply-To: <07428054-99b5-1bc7-ca7f-938d7c2198f0@linuxfoundation.org>
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
Content-Type: multipart/mixed; boundary="===============6831435112799017457=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============6831435112799017457==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BMjsxloECH/PlBMs"
Content-Disposition: inline


--BMjsxloECH/PlBMs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 07, 2022 at 06:08:06PM -0700, Shuah Khan wrote:
> On 2/7/22 8:21 AM, Mark Brown wrote:

> > +static int sme_regs(struct tdescr *td, siginfo_t *si, ucontext_t *uc)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < nvls; i++) {
> > +		/*
> > +		 * TODO: the signal test helpers can't currently cope
> > +		 * with signal frames bigger than struct sigcontext,
> > +		 * skip VLs that will trigger that.
> > +		 */
> > +		if (vls[i] > 64)
> > +			continue;

> Count the skipped VLs and print counts - helps see how many are
> skipped.

I'll print a message when we skip an individual VL for this reason.
Note that it is hardware dependent what vector lengths exist in a system
and that it is expected that many possible vector lengths will be
skipped - the enumeration algorithm means that we don't explicitly step
through most vector lengths but rather have the enumeration done for us.

Please delete unneeded context from mails when replying.  Doing this
makes it much easier to find your reply in the message, helping ensure
it won't be missed by people scrolling through the irrelevant quoted
material.

--BMjsxloECH/PlBMs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmICqBwACgkQJNaLcl1U
h9AUlAf+IM5Fo2PWtTTieplDrXQsJPA6dNg4eg+Q7C74WKURE4LlXnTPeU19LiN5
v4NAL96nBsSu9Y6QfNBbxU0ebTyL7fCPlbXJTlZKqFd5aTBZRLcHXGQL70Cj+OlT
trKqYnzlwYyag7gFp3O+ptXl63pejSw+xe0GrSG47HsulTwCEOg6BdjsTAK/KIme
10ZAaxK0Zky+mulGwZrd8DVuu8ZccaYzL98z72b7ZapfEC3R0b3EnHqp7mAfUw6k
eAAl9OR+WV0ZzklgyAJjBw6HWWckzoPD2fl7H55JHxKzWPZFK8Yn3LjZo1TINerG
qStj1dko+Iw36iXGVEwjMbVeBkyxCA==
=X9it
-----END PGP SIGNATURE-----

--BMjsxloECH/PlBMs--

--===============6831435112799017457==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6831435112799017457==--
