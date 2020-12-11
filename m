Return-Path: <SRS0=r53t=FP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA76BC4167B
	for <kvmarm@archiver.kernel.org>; Fri, 11 Dec 2020 16:26:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DDE2623E26
	for <kvmarm@archiver.kernel.org>; Fri, 11 Dec 2020 16:26:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDE2623E26
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4289B4B1F5;
	Fri, 11 Dec 2020 11:26:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jeg9qbWt64n2; Fri, 11 Dec 2020 11:26:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62B5D4B2E6;
	Fri, 11 Dec 2020 11:26:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ADAA4B236
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Dec 2020 11:26:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pADWYur3dbTQ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Dec 2020 11:26:22 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F40F4B1F5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Dec 2020 11:26:21 -0500 (EST)
Date: Fri, 11 Dec 2020 16:26:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1607703980;
 bh=D6PkJnLwPkrx/3nU/EoMY178LXorbA8/thVLoD5x+gg=;
 h=From:To:Cc:Subject:References:In-Reply-To:From;
 b=sSToW0aVjFM7A46kyj5fNwO6lsvjA8fH1bSfIe2FIt27w1A/uLILWKHpwANn0GkYm
 m8YSK4wkUsGMLzthrzLiuMX962yLju3OOZvdAJ/KTbDGqmwjlY3gIvFIVm229KHcZ8
 5Xbc4KHrmdfwsJ133V83EWMsvcx5PCQp8FpT2FYJDEcHZnMcWrtkohxJUby53gdsyV
 hmkH9SZfdSs/tc6Nh16K2pBfjwxqu+MQzSiE4ZJeCNtRA2v+f+ncQKBbigjS2eskVv
 cHP+pNiFeCSwwFDoGatvDwXRzbcwVCGb6FnmaEXCkrk1FzBg4DRElKivXnMIkoflvb
 Je8MPbDrjFPIw==
From: Mark Brown <broonie@kernel.org>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v4 4/5] arm64: Add support for SMCCC TRNG entropy source
Message-ID: <20201211162612.GF4929@sirena.org.uk>
References: <20201211160005.187336-1-andre.przywara@arm.com>
 <20201211160005.187336-5-andre.przywara@arm.com>
MIME-Version: 1.0
In-Reply-To: <20201211160005.187336-5-andre.przywara@arm.com>
X-Cookie: Nostalgia isn't what it used to be.
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
Content-Type: multipart/mixed; boundary="===============6933052992164378853=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============6933052992164378853==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dWYAkE0V1FpFQHQ3"
Content-Disposition: inline


--dWYAkE0V1FpFQHQ3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 11, 2020 at 04:00:04PM +0000, Andre Przywara wrote:

>  static inline bool __must_check arch_get_random_seed_long(unsigned long =
*v)
>  {
> +	struct arm_smccc_res res;
> +
> +	/*
> +	 * We prefer the SMCCC call, since its semantics (return actual
> +	 * hardware backed entropy) is closer to the idea behind this
> +	 * function here than what even the RNDRSS register provides
> +	 * (the output of a pseudo RNG freshly seeded by a TRNG).
> +	 */

This logic...

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
> =20
> -	return __arm64_rndr(v);
> +		arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_RND64, 64, &res);
> +		if ((int)res.a0 >=3D 0) {
> +			*v =3D res.a3;
> +			return true;
> +		}
> +	}
> +
> +	return false;

=2E..seems to also apply here but we prefer the RNDR instead of the SMCC.
We probably want to either do the same thing or add a comment saying
what's going on.

--dWYAkE0V1FpFQHQ3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl/TnaQACgkQJNaLcl1U
h9A37gf/YcdpiwbfAu6XhOilbKoh0HHz40BryiT+RzRxWBTZRHBqVwt49G6le4SV
pqInBtPCBnSGvT05jK0C8hSzEU6LKN0OrRToGzUJqsMi1Kf7rDwCs6gA6CVURIwY
wSXxNuGD3c9dGXCtip4pRhY4qB5PZ9FcVbgWVu84CnrCX6efa7DbDMBLdX7S03g4
NWvYxTwnoVswk5CeltpcHx3xzvY4IH73h5UNycV6UEYj0AiNrKf9YIfIqtk55uLh
x+GtUS8mlxj9FDrhW7J2z/+EgDjZ06XF4yP/iVLSDmCaFOwrck0Mi/6ypeF59nMz
w2FoqjLlhrzqojVUxLk/SEg4y5jECA==
=0YV1
-----END PGP SIGNATURE-----

--dWYAkE0V1FpFQHQ3--

--===============6933052992164378853==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6933052992164378853==--
