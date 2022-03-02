Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 978FEC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 13:03:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 100E149E36;
	Wed,  2 Mar 2022 08:03:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YFOWCWJ31KXL; Wed,  2 Mar 2022 08:03:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C092949EDE;
	Wed,  2 Mar 2022 08:03:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B684949E36
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 08:03:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TvWdhen0yoy0 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 08:03:06 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BBA554141A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 08:03:06 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 27A07B81FE8;
 Wed,  2 Mar 2022 13:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453D8C004E1;
 Wed,  2 Mar 2022 13:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1646226183;
 bh=ibmXcOSmeHL09sRVILi0Er6msdkw98p2iNvq4Z+J6RE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=rUZPBKvf3WuH9rU5+3WcDt2MLzqRo7s8K9YuGgWUUh0gwAdA1HOjR+B7T5Ha6Sb+h
 lYGoTuu0kwBU9TJcgM1vZ9B/Ee4qpLqk1cPlLvHQjOvrBIqgjy8LkQDqNwVqURl1wT
 mCIcBSGA4s/RMbbGQJCF5gwdVxTJND2tr0iI8JRVZgtGLNtC2L5zYEGU62+92Uaz13
 UsdnFPvHKrpuyO0+z6jxSyFHEQMN7/FXTIoe9UErNSz/BneTtzr5oW0RMmhW5+NDep
 FMwAcLsTIJ420VL53bBVokT5GIzQ0vUcnCe5bzT4wHILRJmEVgVivv7RrztPx5ENL/
 SqD3tf0bpPdyg==
Date: Wed, 2 Mar 2022 13:02:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v11 03/40] arm64: cpufeature: Always specify and use a
 field width for capabilities
Message-ID: <Yh9rAZjmmqjCAGZ3@sirena.org.uk>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-4-broonie@kernel.org>
 <Yh6kqaR9FQXg8Q4w@qian> <878rts3bpi.wl-maz@kernel.org>
 <Yh9akZaM+qeWPgEz@arm.com>
MIME-Version: 1.0
In-Reply-To: <Yh9akZaM+qeWPgEz@arm.com>
X-Cookie: The sheep died in the wool.
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>, Marc Zyngier <maz@kernel.org>,
 Alan Hayward <alan.hayward@arm.com>, Qian Cai <quic_qiancai@quicinc.com>,
 Salil Akerkar <Salil.Akerkar@arm.com>, linux-kselftest@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Type: multipart/mixed; boundary="===============0697648048012469519=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============0697648048012469519==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7loqhh/QB0lB0Fcr"
Content-Disposition: inline


--7loqhh/QB0lB0Fcr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 02, 2022 at 11:52:49AM +0000, Catalin Marinas wrote:
> On Wed, Mar 02, 2022 at 10:12:09AM +0000, Marc Zyngier wrote:

> > I don't think that's on purpose, and we should definitely address
> > this. Maybe we should have a warning if we spot an occurrence of
> > .width being 0.

> We should indeed have a check. Alternatively, assume the default to be 4
> and convert all 0s to 4 during boot (less patch churn).

That's got the issue that it becomes very easy to end up defaulting to
a width of 4 in the case where the field is narrower which isn't going
to be easily visible in testing until it encounters a system where it
misfires in a way that breaks things.

--7loqhh/QB0lB0Fcr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIfawAACgkQJNaLcl1U
h9CL0Af+LMYSxGux9+H2KZiS3uH6kguND2mecwSS/f7SK6AC7kMkLZcfz/72uoT3
NtscTwK9k8C/lBWsab8WWTEcAhNBUTc+KSeYbnUQmw29oNO30VT3NjkRe6l4xdjW
gmUHWfwDN/hl/DViKzHbswYgVNaUZck5vwUonMuQyAM0PtJYoerOVpcavgd/9u7F
6jI4E7ZeIOS4AX0XUkJpRDZxykF/NsPJvadKvEP60UOrYiJ54vVHSewrqshd6cgA
g2lSQW+XeibnhLFTEsNiIGtpxCdnQBOkA7562cREw9f6BttWsHsJoklRs+c19WiV
7sCyOIXcLXhJIm39SdLzJjHuXKK7fQ==
=vfZs
-----END PGP SIGNATURE-----

--7loqhh/QB0lB0Fcr--

--===============0697648048012469519==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============0697648048012469519==--
