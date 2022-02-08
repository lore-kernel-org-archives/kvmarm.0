Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D885CC433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 15:51:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 427274B19F;
	Tue,  8 Feb 2022 10:51:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CXfoH9PXnPvt; Tue,  8 Feb 2022 10:51:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4FB54B0FB;
	Tue,  8 Feb 2022 10:51:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABB0A4B0FB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 10:51:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QydGV3l8jt+v for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 10:51:25 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 29CE04B0F4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 10:51:25 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id A80CCB81BD5;
 Tue,  8 Feb 2022 15:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99237C004E1;
 Tue,  8 Feb 2022 15:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644335482;
 bh=DSOFycgVws+h7T5ENa5P5jIRcXzog0itQ+h++u6TjH0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=dogQ23AhWv2Y0LrO2Cl35x8z6FXBbSq4wthKej4k6KB7wax5fJe2keAcarhYKQqBw
 IzQGNcJ21is1nsHelHv+A4A0j0tf3x6JaT500m7vR8LTG6sL6qFDIq2J/INSWalb52
 ESa/zzjlXbxUc+qMOOuhozOslqZZ0mI2M3nJ3ROBhICoO+SJkKmddzf+7MFvBSKh+f
 JenKAQLSokwnNtRC2qCz2o2nkY8yap5crdOWwJWYrRdNfjWA5O2MTQ+MBMSNkRyyMx
 9zwoOLeiK8G3RXorwgnpaR/BTptr4MCIHfGj9soANbcYtH+MntBxxXuJ8TOG1fc65p
 qqH7DuzIKu13w==
Date: Tue, 8 Feb 2022 15:51:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v11 31/40] kselftest/arm64: sme: Add SME support to vlset
Message-ID: <YgKRcQaZ4QUh6pIH@sirena.org.uk>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-32-broonie@kernel.org>
 <fc0d4407-8124-2040-41f5-5de091de588f@linuxfoundation.org>
MIME-Version: 1.0
In-Reply-To: <fc0d4407-8124-2040-41f5-5de091de588f@linuxfoundation.org>
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
Content-Type: multipart/mixed; boundary="===============2801780187383808255=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============2801780187383808255==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="LIHuwwmGP+ni8Amn"
Content-Disposition: inline


--LIHuwwmGP+ni8Amn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 07, 2022 at 05:15:39PM -0700, Shuah Khan wrote:
> On 2/7/22 8:21 AM, Mark Brown wrote:
> > The Scalable Matrix Extenions (SME) introduces additional register state
> > with configurable vector lengths, similar to SVE but configured separately.
> > Extend vlset to support configuring this state with a --sme or -s command
> > line option.

> It would be useful to add a -g command to get the current value.
> -g would just do PR_SVE_GET_VL and print the value perhaps?

We already have the rdvl helper programs which can be used to read the
actual vector length from a shell command.  I'm not sure there's a
particular use case for adding something to to this program, and I'm not
sure the complexity is worth it especially given that we've got both the
actual and to be inherited vector lengths to be considered in the UI.
This program exists to allow you to configure vector lengths for the
stress tests without having to write UI code in assembler.

--LIHuwwmGP+ni8Amn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmICkXAACgkQJNaLcl1U
h9Anuwf/WxDpOe84TNruqv39PFD5VFS/cb4p8TQEQxT1+nkW22u+hCuxurJNpVX2
ZL5O0o0z+SJU2W/tCGZWZpAh2jQ7L2nqzBFtCh3m4Cc6DhmEDl6sFEpCP4wjAI0f
RWSmKXv+tLqJslbxR+w4CMgQJWzlIEjit5uB3cq5htTg9uIA2NkT6lB2JbxG/qBj
XycZmOCPB8Ld6nOSGEyyIhilUTlDBlGyyCLtFXyYyFs6WnXPqTJTCVOGimwYLW5V
Q06Mxdi/6bUe4rjvy8rP2tgknMggTa316VnuG2okcWtyjouDTzk/BwAj+KLD4NLB
zccWP1a30jM7JLQV0e+dkvOZesvlRA==
=5yEu
-----END PGP SIGNATURE-----

--LIHuwwmGP+ni8Amn--

--===============2801780187383808255==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2801780187383808255==--
