Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D24CC433C1
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 17:53:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DD50061941
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 17:53:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD50061941
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 576764B36A;
	Fri, 19 Mar 2021 13:53:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KCDq67qEF1L3; Fri, 19 Mar 2021 13:53:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DA824B295;
	Fri, 19 Mar 2021 13:53:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CD6B4B27C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 13:53:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ePY-uPFhymO6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 13:53:55 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D8A54B276
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 13:53:55 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D6BF61941;
 Fri, 19 Mar 2021 17:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1616176433;
 bh=zrcL9MRIFXU8BSdXA3iKVsYRz6r0TE1XU84YXfluHhs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=JleX4Ku9BTUuHpkzuztNMHZyK1I2gm5G53d+jG4H7cBYdMIjEiP67A5Tsti0YJwcE
 +2vFKmppEYuF8Ys8Iedf6E1rDo2tJfOjSGi5f7ZCrbfOLiFmXyU6Rv8lfh100O9cGj
 Y2SU9l+MGa64aSPP03m7Izg/2nj+qrNf9WxtqVA8Rio8bVfL0x2K12RTlSqXFZWYRF
 HgA0Rn+IkXa8HCboaJP1wDgpSdjXAyhh98yyGNOkC7s49JGayvEwdXuUruBs2xxTIi
 w+5zqc9aAFJFDVkhek2UGBZuw7yRknjLO1W7bnmzHcy9ZmjKfeHhBa6mdedqVpSNjw
 mXPZikZXDBn+Q==
Date: Fri, 19 Mar 2021 17:53:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 00/11] KVM: arm64: Enable SVE support on nVHE systems
Message-ID: <20210319175349.GK5619@sirena.org.uk>
References: <20210318122532.505263-1-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20210318122532.505263-1-maz@kernel.org>
X-Cookie: No purchase necessary.
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
 Will Deacon <will@kernel.org>, dave.martin@arm.com,
 linux-arm-kernel@lists.infradead.org, daniel.kiss@arm.com
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
Content-Type: multipart/mixed; boundary="===============7337390302713275998=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============7337390302713275998==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="aqWxf8ydqYKP8htK"
Content-Disposition: inline


--aqWxf8ydqYKP8htK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 18, 2021 at 12:25:21PM +0000, Marc Zyngier wrote:

> Most of this series only repaints things so that VHE and nVHE look as
> similar as possible, the ZCR_EL2 management being the most visible
> exception. This results in a bunch of preparatory patches that aim at
> making the code slightly more readable.

That readability stuff is definitely helping from my PoV.

Reviewed-by: Mark Brown <broonie@kernel.org>

(FWIW, from the SVE side)

> This has been tested on a FVP model with both VHE/nVHE configurations
> using the string tests included with the "optimized-routines"
> library[2].

There's also some tests Dave wrote which got upstreamed in kselftest
now, some normal kselftests and also a stress test that sits and
writes/reads bit patterns into the registers and is pretty good at
picking up any context switch issues.

--aqWxf8ydqYKP8htK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBU5SwACgkQJNaLcl1U
h9AN5wf+P7ae7UEos5cVKTOeBLoAWzSixqcgUVEwBW/KICbwvz0XROUxMt7whp9r
3Tw/PL3WZ4lUkWYFvvB3tVnjQk1JvolP4ZD07/28uKOuokUk1lCitqDpEwpi3y58
TTfo6q89G0Z8n6bMMeRPe1WrajTzkfkGHsScPrOaH2OWWjPwv4YfgtfsLCtXTiWH
XI+Jd6NOtPjSMMSYTnje4qFyPmn9Y7OzkbEXj/3wKP4qBYw4lhQ4pZ4jF38ngSve
SvXbki6zREpP5U4BpqQcMzu1D1/DN/Xz0YeBi2MKNQrIrEVY+z8kQZ1BMSXZ5xi/
sQ3P3aJ6VfsbW0AQmgZoAknknjcdaw==
=Q9m5
-----END PGP SIGNATURE-----

--aqWxf8ydqYKP8htK--

--===============7337390302713275998==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7337390302713275998==--
