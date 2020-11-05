Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93032C55179
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 13:41:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DEE5A20739
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 13:41:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="j0S+M/t9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEE5A20739
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CC474B672;
	Thu,  5 Nov 2020 08:41:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V0vMxtOes1By; Thu,  5 Nov 2020 08:41:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2A704B682;
	Thu,  5 Nov 2020 08:41:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF2834B672
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 08:41:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DfxpTvR62+vW for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 08:41:54 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C271D4B66C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 08:41:54 -0500 (EST)
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id CBB5F20729;
 Thu,  5 Nov 2020 13:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604583713;
 bh=4w//0GOBcyazzgOmqfL5NKULnMf1kmugV10nGsnPnCM=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=j0S+M/t95EKp2myinviXxYBn/BVNlmZenfledxlLsLuLXYeNEUag6xwL4pHwW23yE
 CKLpj6aYbmL1uY8vflma3+jebsh3Rzddy8UhnShGvtINtt6rQPcSVhZpQYGil8i2uY
 Q20pR7IzGI7f6VesD8+v9DH4vegwrZx4D0ScIsJ8=
Date: Thu, 5 Nov 2020 13:41:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 4/5] arm64: Add support for SMCCC TRNG entropy source
Message-ID: <20201105134142.GA4856@sirena.org.uk>
References: <20201105125656.25259-1-andre.przywara@arm.com>
 <20201105125656.25259-5-andre.przywara@arm.com>
MIME-Version: 1.0
In-Reply-To: <20201105125656.25259-5-andre.przywara@arm.com>
X-Cookie: It's the thought, if any, that counts!
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>, Russell King <linux@armlinux.org.uk>,
 Ard Biesheuvel <ardb@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: multipart/mixed; boundary="===============7997901523637488118=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============7997901523637488118==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 05, 2020 at 12:56:55PM +0000, Andre Przywara wrote:

>  static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
>  {
> +	struct arm_smccc_res res;
>  	unsigned long val;
> -	bool ok =3D arch_get_random_seed_long(&val);
> =20
> -	*v =3D val;
> -	return ok;
> +	if (cpus_have_const_cap(ARM64_HAS_RNG)) {
> +		if (arch_get_random_seed_long(&val)) {
> +			*v =3D val;
> +			return true;
> +		}
> +		return false;
> +	}

It isn't obvious to me why we don't fall through to trying the SMCCC
TRNG here if for some reason the v8.5-RNG didn't give us something.
Definitely an obscure possibility but still...

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl+kARUACgkQJNaLcl1U
h9DYuwf8CUvDX3fgFkHQzB4oHxVc26hBdjs1LMP8HGSRCDcCKTl8g0oPmxO620Eg
Gi7jDuTY0fyXAqxIJY6mqyAxuWwoEhN37zqHBqDKoIIQoqr7S2XenF+4PZauH7A/
3/E8QnNxZCWUCZkgmjwa5GAa5Yt2SHNnZOXe4kx81SHBdMBcMgM4VnVS1eag/Rsu
5PZ/HFJQAB3PQQQ4+MtYkWqfurTTnQruH/sT1CxWa6WHbUWwStSsmtrbjwLx/3nz
SHD1UXnMH5WycZQ55m++AGD9xzSZGFRlbgEcXltNPMg8ern/xeCt5EpCKl262D+I
ujIYv72Mo/6CrpMqQrXsK7jzc5pHHg==
=6PnH
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--

--===============7997901523637488118==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7997901523637488118==--
