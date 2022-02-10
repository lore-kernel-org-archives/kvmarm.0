Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC271C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 10 Feb 2022 16:19:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B13949F46;
	Thu, 10 Feb 2022 11:19:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2wkafvr5TwtQ; Thu, 10 Feb 2022 11:19:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C814649F2A;
	Thu, 10 Feb 2022 11:19:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA0A949EEF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 11:19:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mL-G+iHFzbCh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 11:19:00 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 76C8540F9C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 11:19:00 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id B2955B806A0;
 Thu, 10 Feb 2022 16:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9EFC004E1;
 Thu, 10 Feb 2022 16:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644509937;
 bh=mE84CfkELN0c9QW331zz8GqcAyg9pAb8AMkwuNJ/wAo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=kBzfe+whiU8VkD4nnORvwXkJN8aVak97dv2TTsubkTsnNIVCNC/uzO1fIGIaoeQvp
 7dG6zzaZ5tBMf7/WFGwormiSNi5N8C6pa+WdE2ZNNUek3CibRw7WDKQWyRgw6UOrnA
 LIEjwM0WF2rVJOpf7kz8DwkQTKLpj591RU9ZKhnsd1aUJPPEIQUo8uGy5+qf/9fSIu
 DWsoOLKMks7BYOFTJ/xF4asIUwLuiWkmxjoNVsfMc6kn8omtqzWuckOs51E5Tvvsdl
 tvNbYEbcx4IprVlXrVSzphSQHcQdCOePTm8B6O1WgQ4d5HVYyyTlAq5lHtWzhqwXDl
 9DWLNIrz1Ad9A==
Date: Thu, 10 Feb 2022 16:18:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v11 06/40] arm64/sme: Provide ABI documentation for SME
Message-ID: <YgU66pT3efqwwn7U@sirena.org.uk>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-7-broonie@kernel.org>
 <49da0f58-7a20-e557-54c3-34bd7074f711@linuxfoundation.org>
 <YgKQTLwW+ha5XNx8@sirena.org.uk> <YgK4kKrSs6e9seG8@sirena.org.uk>
 <e6d76104-b7f6-1588-d734-1a09c2990299@linuxfoundation.org>
 <YgK9v7u+FcBTB1ur@sirena.org.uk>
 <d41ec776-5bd0-438f-0ab3-6eb1891e7fdc@linuxfoundation.org>
MIME-Version: 1.0
In-Reply-To: <d41ec776-5bd0-438f-0ab3-6eb1891e7fdc@linuxfoundation.org>
X-Cookie: Only God can make random selections.
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
Content-Type: multipart/mixed; boundary="===============6648562463102305009=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============6648562463102305009==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="E6HfXQqv4dHcMRh/"
Content-Disposition: inline


--E6HfXQqv4dHcMRh/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 10, 2022 at 08:12:44AM -0700, Shuah Khan wrote:
> On 2/8/22 12:00 PM, Mark Brown wrote:

> > Sure, there are lots of structured files in there like .rst ones which
> > have SPDX headers but this is just a free format text file so it's not
> > clear what if any format to use.

> I think SPDX is applicable to all files free format or not. Are you seeing
> any build warns during doc build on this?

No, but I'm not exactly going out of my way to do anything with them.
As far as I know these files don't get touched during builds, they just
exist in the kernel tree.  If there is some way of generating warnings
=66rom them there are quite a lot of other such files already there and
doing so.  Like I say I can't find any evidence that anyone has looked
at adding SPDX to these files, as far as I know the long term plan such
as it is is to convert to other formats and I can't immediately think
how one would do it otherwise in a way that works well.

I'm sure the license compliance people would find adding annotations
useful but working out how to do that sensibly for these files seems
beyond the scope of this series.

--E6HfXQqv4dHcMRh/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIFOuoACgkQJNaLcl1U
h9A10Af9HttlrltFQQbCvNVwAOt31oIw1I7NKyD4F2QPCnbjirxGPF9FhoQCKxlh
/4VLdkvuPNogggtjy9M2yHjmRN4rix4RlhVTd2L4gyPaixsNDSyn8Qu77x4jq6iP
d2qsu+w8J8Fzg4bq7oRPMHPa/kEJXwq02NiVZMzcxHU0kuBue5qJEpU8HRGnRwDV
3ZaWQOYl0zRojYCYWz4a/FGdPVGyhvA0Giet2iYRFJ4c4UHOReS65y7w49dzDsqZ
sgK2ZbwLIpZGqiiCjC+hdYqbRHebJpMsJSQekJLKEYeI5Az1VktNXPnAzTOGiqYY
34BmoPSY/6gjss5tsCgqNbkF8N/D9Q==
=kc0B
-----END PGP SIGNATURE-----

--E6HfXQqv4dHcMRh/--

--===============6648562463102305009==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6648562463102305009==--
