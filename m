Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A0BCCA473
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jun 2022 09:10:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 132434B24A;
	Fri,  3 Jun 2022 05:10:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2+MznZVCv+kh; Fri,  3 Jun 2022 05:09:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C15124B21A;
	Fri,  3 Jun 2022 05:09:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7348D4B21A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2022 05:09:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4bx-fZ9BzdK8 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jun 2022 05:09:57 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F1F94B1F7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2022 05:09:57 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id C4796B821BE;
 Fri,  3 Jun 2022 09:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D524C34114;
 Fri,  3 Jun 2022 09:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654247394;
 bh=ThbjYz1VPOOCZfSoMHKCJNv4joGtIlV2WQb/q8/byg4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Wap4azFylQ7sCs9bHodMhU5wB5uu7VhLym04W5LB2XPgE73S4hLf0udyQbXdbqlEF
 FilarPxtS83HopuDpZjr+LRLtPdFsx3Czz+heE8chmikDy0xsoqVR9DsmvljYAgCBs
 l6y6keqAMCLG6oI3LAVD7c+QxFHbwjL3DUef/iQbjo8w2ILNG8qFxo8GZyJzi53Tm5
 EvSBl3JGsvX5/zuWWOW7dBl6nTtuhy2MzJZ4w+Cqpk7axIPjIny4ce59dFFx7W0ypq
 fyDNQEV21kiGLwL5OeFy9Zipojo6q/mkzWOKOi0lZEo6PlHtOO5vmYHrok3xVNiAdG
 C2fb6v2oPKQlQ==
Date: Fri, 3 Jun 2022 11:09:51 +0200
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 03/18] KVM: arm64: Drop FP_FOREIGN_STATE from the
 hypervisor code
Message-ID: <YpnP35rl40rDakgb@sirena.org.uk>
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-4-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20220528113829.1043361-4-maz@kernel.org>
X-Cookie: May your camel be as swift as the wind.
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
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
Content-Type: multipart/mixed; boundary="===============5515562124285146974=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============5515562124285146974==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MU9Z6LR9WcUWlxk3"
Content-Disposition: inline


--MU9Z6LR9WcUWlxk3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 28, 2022 at 12:38:13PM +0100, Marc Zyngier wrote:
> The vcpu KVM_ARM64_FP_FOREIGN_FPSTATE flag tracks the thread's own
> TIF_FOREIGN_FPSTATE so that we can evaluate just before running
> the vcpu whether it the FP regs contain something that is owned
> by the vcpu or not by updating the rest of the FP flags.

Reviewed-by: Mark Brown <broonie@kernel.org>

--MU9Z6LR9WcUWlxk3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKZz98ACgkQJNaLcl1U
h9DAAwgAgtdvhf759AQPe2iS/1hVc6SW/WgwQC00F9zMxyXtlXa85GYzI4HO0P+w
ndPvA6eGVF3vnN53rzjUdHWhej2h6JOEHFigz5/hLCQrm64n8JpCRH82ijtP9MN+
Xl6uKP7M17DRCzicD5Gr/lbVPQDIpuyLuiaoWfulT3e5piXWdNoNB3z8FHLMUhMW
+1PAc1xPv7+kZl7W8k6InJCfQT46niP1JJ6YBI3FSJifFZUSV5CuxlyvWsfOsB54
zqK1wUgbjzV8cbZvlkOIe0d5pIWG2e3YOic4Zumyqak06cwgaayUP9lPep5C35vY
Kyheo2OW0eqx+5mIlY8y61BFeimR+Q==
=amiN
-----END PGP SIGNATURE-----

--MU9Z6LR9WcUWlxk3--

--===============5515562124285146974==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5515562124285146974==--
