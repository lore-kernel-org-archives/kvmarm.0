Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2258C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 21 Feb 2022 15:01:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64D244A5A0;
	Mon, 21 Feb 2022 10:01:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZidY-ZQSB6to; Mon, 21 Feb 2022 10:01:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A6114B0DE;
	Mon, 21 Feb 2022 10:01:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CC804A5A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 10:01:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A+wwGl8oyD6F for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Feb 2022 10:01:12 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 904FC4A500
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 10:01:12 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D809BB811F9;
 Mon, 21 Feb 2022 15:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACCAC340EB;
 Mon, 21 Feb 2022 15:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645455669;
 bh=jnZJ8y+l13C39hwchZzvVMT9Z2C5p7ETfSKEehvZz2M=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=kKuHtIMRyLDDmu2pXgkjUvSe3vGz27buYnwjYH6VfqmbZX9oranSrbL0NmuQXo/aq
 BmXFfyrhx4ChiFOIFeX0UaJcTGf4kcvo/F22TthYDnuHTNIPuol3PqiV5kg0vjOMmf
 hpclJiqu3jivn0yJtexNbY9kZZ/pnXIq0SK/KkOi1R05FsGt6GTCqYJiVtZLvEcSCh
 Lu7RjFRDykOgvf24fwWph7jHAuUqqpAZSKRt+uvcUjNVXX9IPB9j8hM/2Y6LohAfEW
 w0LYDfpv2yQutNLK/0eJwU6hp46ej7GleAuVVGfEtD9M7dDnqomNqS3HHoAquznBJw
 Yy8ZsB0Jt2Jdg==
Date: Mon, 21 Feb 2022 15:01:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v11 10/40] arm64/sme: Basic enumeration support
Message-ID: <YhOpL54V9RAthj24@sirena.org.uk>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-11-broonie@kernel.org>
 <YhOihgeVRTztfDqv@arm.com>
MIME-Version: 1.0
In-Reply-To: <YhOihgeVRTztfDqv@arm.com>
X-Cookie: I smell a wumpus.
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>, Marc Zyngier <maz@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Salil Akerkar <Salil.Akerkar@arm.com>
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
Content-Type: multipart/mixed; boundary="===============5236019384099802670=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============5236019384099802670==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cw/YFP2NCLS06rWj"
Content-Disposition: inline


--cw/YFP2NCLS06rWj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 21, 2022 at 02:32:38PM +0000, Catalin Marinas wrote:
> On Mon, Feb 07, 2022 at 03:20:39PM +0000, Mark Brown wrote:

> >  static const struct arm64_ftr_bits ftr_id_aa64pfr1[] =3D {
> > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_SM=
E_SHIFT, 4, 0),

> Shouldn't this field also be visible (if SME is enabled)?

Yes.

> > +/*
> > + * This must be called after sme_kernel_enable(), we rely on the
> > + * feature table being sorted to ensure this.
> > + */
> > +void fa64_kernel_enable(const struct arm64_cpu_capabilities *__always_=
unused p)
> > +{
> > +	/* Allow use of FA64 */
> > +	write_sysreg_s(read_sysreg_s(SYS_SMCR_EL1) | SMCR_ELx_FA64_MASK,
> > +		       SYS_SMCR_EL1);
> > +}
> > +
> > +#endif /* CONFIG_ARM64_SVE */

> I think instead of worrying about the order, we could check the
> sanitised register value in sme_kernel_enable() and set the FA64 bit.

There's going to be a ordering/clarity issue whatever way round we do it
- the FA64 feature bit is in a different feature register to the main
SME feature bitfield and it's not as abundantly clear as might be ideal=20
that it will have been sanitised when we're getting callbacks for the
main SME feature, there's an awful lot of sharp edges with this code.
Having things this way round felt more idiomatic to me.

> Also to me 'fa64_kernel_enable' somehow implies that the kernel cares
> about FA64 for itself but AFAICT we never run the kernel in streaming
> mode.

We do run the kernel in streaming mode - entering the kernel through a
syscall or preemption will not change the streaming mode state, and we
need to be in streaming mode in order to save or restore the register
state for streaming mode.  In particular we need FA64 enabled for EL1 in
order to context switch FFR when in streaming mode, without it we'll
generate an exception when we execute the rdffr or wrffr.  We don't do
any real floating point work in streaming mode but we absolutely need to
run in streaming mode and only exit streaming mode when restoring a
context where it is disabled, when using floating point in the kernel or
when idling the CPU.

--cw/YFP2NCLS06rWj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmITqS4ACgkQJNaLcl1U
h9CqHQf/e7ryknUltIksEcPMHnqwDTzYLcyJ84FWClI2ZwusRfRQgRmcmpEQRh3e
mw1UMAV3gA0w1M30IUApgV31DEH/bpBQQZo4dJqdrF3W5AqLU6kF5bPDGwci7q7Y
rjbUNF1lQS6rj5ba4xNM0xluICOXEzbitbOVB2V7SEn3aEbk17jXZkuaAmLcI9eA
jlXo6YoeKTyfDpw11In3hpb/mAqm0s5ijoKmKm1aBmiHfm3vRgJCdywlZH/xGyWw
qDqhMRCMqn831JKCzR5t6vzFz4TTn8Yd8yV64KgTFOvc20VOKiyhvHfCVkERaSt7
FiNjiJrksKZP4usi1AHoT2WNH99oAA==
=3EGX
-----END PGP SIGNATURE-----

--cw/YFP2NCLS06rWj--

--===============5236019384099802670==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5236019384099802670==--
