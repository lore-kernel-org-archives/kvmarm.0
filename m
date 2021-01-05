Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9281BC433E0
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 17:00:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 29B7022CE3
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 17:00:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29B7022CE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AB174B30D;
	Tue,  5 Jan 2021 12:00:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R9bkmd1ijMIV; Tue,  5 Jan 2021 12:00:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74DA34B345;
	Tue,  5 Jan 2021 12:00:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 038EA4B30D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 12:00:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OFKu-lwRoMg5 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 12:00:43 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 09FB54B2DD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 12:00:43 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B1D622CB9;
 Tue,  5 Jan 2021 17:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1609866042;
 bh=K8rAAgbvgJOrltjvqkkg0lKreghPjvGcwr3u28D1o1g=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=f2e3w+dPlvG0kpAb41jDf4ut+9Cjd3hvHKHLzFAQA7synFGutVGBDDCc7CBTfoBlY
 SuT3hxxP+KHcPF1mPpnQphr528eXRg/yqECTmmyOyeSMMP30in6a9A9qC+D8KvjDo3
 h8LBLezI2sikU00ALAIDmChhSk9yW9s3yudCv/IIEvQyvJeJoXUMyKSCwTmmuhC5GK
 pupZVtUjmjE8XqvV+9xPbxE8LokyQOp7pHhu9kgHT1nbCsiw+bdo/+K+kCb3EnUG98
 QjJRmHCiDGJ+BOSowS11T/j0hBIqbMDTLnWPETcwKvfUqwzuRLSOMoqd76TEZjf1oh
 vOdpYEAN/jabg==
Date: Tue, 5 Jan 2021 17:00:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v5 4/5] arm64: Add support for SMCCC TRNG entropy source
Message-ID: <20210105170014.GG4487@sirena.org.uk>
References: <20210105163652.23646-1-andre.przywara@arm.com>
 <20210105163652.23646-5-andre.przywara@arm.com>
MIME-Version: 1.0
In-Reply-To: <20210105163652.23646-5-andre.przywara@arm.com>
X-Cookie: I'm ANN LANDERS!!  I can SHOPLIFT!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Theodore Ts'o <tytso@mit.edu>, Catalin Marinas <catalin.marinas@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>, Sudeep Holla <sudeep.holla@arm.com>,
 linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: multipart/mixed; boundary="===============1574196057476124372=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============1574196057476124372==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Y+xroYBkGM9OatJL"
Content-Disposition: inline


--Y+xroYBkGM9OatJL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 05, 2021 at 04:36:51PM +0000, Andre Przywara wrote:

> @@ -77,10 +117,20 @@ arch_get_random_seed_long_early(unsigned long *v)
>  {
>  	WARN_ON(system_state !=3D SYSTEM_BOOTING);
> =20
> -	if (!__early_cpu_has_rndr())
> -		return false;
> +	if (__early_cpu_has_rndr())
> +		return __arm64_rndr(v);
> +
> +	if (smccc_trng_available) {
> +		struct arm_smccc_res res;

This still seems to be preferring RNDR over SMCCC for the early seed
unless I'm misreading the diff?

--Y+xroYBkGM9OatJL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl/0mx0ACgkQJNaLcl1U
h9BbEQf/UEKW05M2JoVuTX8s89SZjgXY0yURCLUGmFG3oR3xya0eOY6+tciI5z+h
6tNafYEkfQZGH4c77s1utt4oz1TSvE9tlaCycjwtdJSFy7wzcnRLsqhHwK2/Gi6F
pFbVgbcLLIEUzxZ2EwOK0RsDPp49N2bGA2r1KD4EpLwagHXBZ9YTu+2fm01HyFUY
SXDH/wiiVXzDS9N8v/r/GIHZr+DAsnUj3Qt2Z4/08PeaRF7FSkPU+5KysKg/XOWK
O1kQQiRiHrPq/Eu88Woo2xbF+zUs5RH1NQ/DRejwJv90kRN9M/YzY4M2WzuX1azR
uRVPqPzk5c5tt5jx6FR+vrMx4XgIAg==
=8VqE
-----END PGP SIGNATURE-----

--Y+xroYBkGM9OatJL--

--===============1574196057476124372==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1574196057476124372==--
