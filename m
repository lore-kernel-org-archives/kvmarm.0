Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C17C2C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 12:58:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25D0649EF3;
	Wed,  2 Mar 2022 07:58:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BBnYbJB4DxF4; Wed,  2 Mar 2022 07:58:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 125A349E2B;
	Wed,  2 Mar 2022 07:58:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C6E649E2B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 07:58:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J2xTFrA7p7uW for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 07:58:28 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33D5A4141A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 07:58:28 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 86EAC61938;
 Wed,  2 Mar 2022 12:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DAAC004E1;
 Wed,  2 Mar 2022 12:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1646225907;
 bh=LosMea2p7TimEumkKgBbuDQpRFN6vS+YPd2axvQzG6A=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=e/B7wUcsV7VRFuaBavVxMvlLX9Gl48ULu5N/NiWRRzIjOqfCoWHw5PZWHtLf69Nix
 aS1WVHeY5yNQfxe4OySY6mcvUJfrDuVvCYimEXqrKCMQCyKTiF/xW9ZVcm5Bw7+jwV
 JBgUIRqBGPhHABLys81oc2aBgXcSY+Kp4aBWn0xcraW5KACbw6FKlSKvRrEwPVJuWb
 NRxc3rizhfSsjBH3ZrpKO/YeTCC/W9Z90BsUjt7yTL+ojubU/w0/BnD663p362KLM9
 EbHzbKa+NpYNleLnOk5+uHh+lY6XL9lxUGURaDsOSlWhMRrp58mJqqGu2Mqa/HLbKP
 0b3mfoGPx72rQ==
Date: Wed, 2 Mar 2022 12:58:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Qian Cai <quic_qiancai@quicinc.com>
Subject: Re: [PATCH v11 03/40] arm64: cpufeature: Always specify and use a
 field width for capabilities
Message-ID: <Yh9p6s6iZg489U+2@sirena.org.uk>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-4-broonie@kernel.org>
 <Yh6kqaR9FQXg8Q4w@qian>
MIME-Version: 1.0
In-Reply-To: <Yh6kqaR9FQXg8Q4w@qian>
X-Cookie: The sheep died in the wool.
Cc: Marc Zyngier <maz@kernel.org>,
 Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alan Hayward <alan.hayward@arm.com>,
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
Content-Type: multipart/mixed; boundary="===============5139838553467279890=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============5139838553467279890==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OcHL1zhRmZwbvB0Q"
Content-Disposition: inline


--OcHL1zhRmZwbvB0Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 01, 2022 at 05:56:41PM -0500, Qian Cai wrote:
> On Mon, Feb 07, 2022 at 03:20:32PM +0000, Mark Brown wrote:
> > Since all the fields in the main ID registers are 4 bits wide we have up
> > until now not bothered specifying the width in the code. Since we now

> Do we leave this one alone on purpose?

>                 .desc = "GIC system register CPU interface",
>                 .capability = ARM64_HAS_SYSREG_GIC_CPUIF,
>                 .type = ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE,
>                 .matches = has_useable_gicv3_cpuif,
>                 .sys_reg = SYS_ID_AA64PFR0_EL1,
>                 .field_pos = ID_AA64PFR0_GIC_SHIFT,
>                 .sign = FTR_UNSIGNED,
>                 .min_field_value = 1,

No, that's just an oversight.

--OcHL1zhRmZwbvB0Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIfaekACgkQJNaLcl1U
h9CS3wf/f2m0xewYcmqZmPopGs54aBgCAog0anEB6iHaydYBxYysrufPJ/lpopIp
V+SKVUcxQiaiKNAQR3cMvt9ij8dh8aeRd9aSq7LGviM7ewR9+LQmEIKb2NCpidq0
AoAtXn9BZcShTs1E2Foy6jf+KjybFbJQQm0+gKIPwOzhOZ3HB3+q7gBEWQD9vuhc
qjYIleeNSEkI4JlZWxIVagxEKOLt+v5XDqEE23zK7mpOfCpRtlyAZS6kHA9ZBvkk
FHs8wq0JdvzJ8fh2oLkoq0JRF20uQXR6dbTkDg5HZCqln3ZBeYjhrV42r2kieFqJ
wm0lyXja3v08bVgxgPVib/iK0komlw==
=ukOI
-----END PGP SIGNATURE-----

--OcHL1zhRmZwbvB0Q--

--===============5139838553467279890==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5139838553467279890==--
