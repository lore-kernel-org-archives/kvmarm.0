Return-Path: <SRS0=IXmk=NP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C9CC4338F
	for <kvmarm@archiver.kernel.org>; Tue, 24 Aug 2021 15:53:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 16B2F611C9
	for <kvmarm@archiver.kernel.org>; Tue, 24 Aug 2021 15:53:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 16B2F611C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93A8F4B12A;
	Tue, 24 Aug 2021 11:53:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xcYuUgRG-U40; Tue, 24 Aug 2021 11:53:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7FAD4B1C1;
	Tue, 24 Aug 2021 11:53:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 846224B102
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Aug 2021 11:53:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vjilKjbRDcAO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Aug 2021 11:53:40 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 623E540573
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Aug 2021 11:53:40 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD745611C8;
 Tue, 24 Aug 2021 15:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1629820419;
 bh=S/+dn5ZBf/rML65m4XV8wU/VMONHlR/+MQQqXYZkqgU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=KfeVCFFuBeoTUCsw1Kix4Dpc+24YZ5NVlYR4yZmIinQnDASuOVIebwHtoHFWpQUua
 7FDKLN5cH+BfWhcZhUfdQs5D6iJbwxoUG0Hm3NMJ9NWDOffP6TFS3QCmjNlKjF/Txa
 AQYc0JOG1uNyumVsXjynz9dRpi3yPM8UFp/y2bcUnNbeCxxmN3e92Rsmzd82ip1FkT
 qjxctXTRKKRsSHnGgJ1o+Oxgq21ggtz99A1CSUx2Oz93ju7y8aRymaulMgFe69CAGv
 4PB/FpmIR3cCiM5OMxBZg4tewwZXZ3dT6sAmSXbJvvzyktqRGvzmKYATQvVkdF4YJs
 7/NggtmaC1K1w==
Date: Tue, 24 Aug 2021 16:53:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v2] arm64: Do not trap PMSNEVFR_EL1
Message-ID: <20210824155312.GD4393@sirena.org.uk>
References: <20210824154523.906270-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20210824154523.906270-1-alexandru.elisei@arm.com>
X-Cookie: Sentient plasmoids are a gas.
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: catalin.marinas@arm.com, maz@kernel.org, will@kernel.org,
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
Content-Type: multipart/mixed; boundary="===============5568593222932336109=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============5568593222932336109==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GyRA7555PLgSTuth"
Content-Disposition: inline


--GyRA7555PLgSTuth
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 24, 2021 at 04:45:23PM +0100, Alexandru Elisei wrote:

> Commit 31c00d2aeaa2 ("arm64: Disable fine grained traps on boot") zeroed
> the fine grained trap registers to prevent unwanted register traps from
> occuring. However, for the PMSNEVFR_EL1 register, the corresponding
> HDFG{R,W}TR_EL2.nPMSNEVFR_EL1 fields must be 1 to disable trapping. Set
> both fields to 1 if FEAT_SPEv1p2 is detected to disable read and write
> traps.

Reviewed-by: Mark Brown <broonie@kernel.org>

--GyRA7555PLgSTuth
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmElFecACgkQJNaLcl1U
h9CEkAf/aKONR9MrgUCx5/TwTo/XLS84ZwikykFHKlvZAE7ttsl0qmqxnOMkW8E3
DACgUHB+eqDA9eXbF0KDo3fj9T12aBKRm4NafiepudpKpPKyP5D/2YACB4jbUAP/
Ov+nLv2IzSd8VmqTjzX70C81XFzsAh9pbkdLJp3qPOCSX30b0Zg1J07TfCOUiPH0
yIJjlcqEsPcq+eRJT3AHaik017fbSjl9Kk+mV/BEz1m+hfaexCcXR8poNQFmxghp
KIsdEW8M25qW+JKbFU1+WQIIh8dAPWl8R1rzZWbY7YOO+2ExawRZ3PjedYoAgpOb
Zzkh8t0pygHbOgfPYr+hpNwrbn3ZfA==
=cXNj
-----END PGP SIGNATURE-----

--GyRA7555PLgSTuth--

--===============5568593222932336109==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5568593222932336109==--
