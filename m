Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE4B8C4741F
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 14:30:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E18D520786
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 14:30:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="AyqaZINU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E18D520786
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F0AC4B805;
	Thu,  5 Nov 2020 09:30:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cOSNkaEf5lM7; Thu,  5 Nov 2020 09:30:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20C084B772;
	Thu,  5 Nov 2020 09:30:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A08304B7B9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 09:30:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lLz07j0lyS9B for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 09:30:02 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 751C64B78C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 09:30:02 -0500 (EST)
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A5F992078E;
 Thu,  5 Nov 2020 14:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604586601;
 bh=7Cpc7oTk9waps+0sn1Z129Z3jSrH4E4ebAchcTAYVZo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=AyqaZINUxyFkyzMBgavBB8W7enAKYN679T/uskcZreZ/usqQGL/BnUfmhSVI7ngY8
 vS2fVGjT5idF2Pk1fQPKPzqMz4p+9gZncgpg8W0iR6e1ilgbn2By0Cb9x0JqK2QlBx
 ABz21xTbYfH9fTLS7WIui1kyeav9pBNyVBeeNHQA=
Date: Thu, 5 Nov 2020 14:29:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 4/5] arm64: Add support for SMCCC TRNG entropy source
Message-ID: <20201105142949.GB4856@sirena.org.uk>
References: <20201105125656.25259-1-andre.przywara@arm.com>
 <20201105125656.25259-5-andre.przywara@arm.com>
 <20201105134142.GA4856@sirena.org.uk>
 <20201105140322.GH82102@C02TD0UTHF1T.local>
MIME-Version: 1.0
In-Reply-To: <20201105140322.GH82102@C02TD0UTHF1T.local>
X-Cookie: It's the thought, if any, that counts!
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, linux-kernel@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>, Sudeep Holla <sudeep.holla@arm.com>,
 Russell King <linux@armlinux.org.uk>, kvmarm@lists.cs.columbia.edu,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org
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
Content-Type: multipart/mixed; boundary="===============1882368171717553693=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============1882368171717553693==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 05, 2020 at 02:03:22PM +0000, Mark Rutland wrote:
> On Thu, Nov 05, 2020 at 01:41:42PM +0000, Mark Brown wrote:

> > It isn't obvious to me why we don't fall through to trying the SMCCC
> > TRNG here if for some reason the v8.5-RNG didn't give us something.
> > Definitely an obscure possibility but still...

> I think it's better to assume that if we have a HW RNG and it's not
> giving us entropy, it's not worthwhile trapping to the host, which might
> encounter the exact same issue.

There's definitely a good argument for that, but OTOH it's possible the
SMCCC implementation is doing something else (it'd be an interesting
implementation decision but...).  That said I don't really mind, I think
my comment was more that if we're doing this the code should be explicit
about what the intent is since right now it isn't obvious.  Either a
comment or having an explicit "what method are we choosing" thing.

> That said, I'm not sure it's great to plumb this under the
> arch_get_random*() interfaces, e.g. given this measn that
> add_interrupt_randomness() will end up trapping to the host all the time
> when it calls arch_get_random_seed_long().

> Is there an existing interface for "slow" runtime entropy that we can
> plumb this into instead?

Yeah, I was wondering about this myself - it seems like a better fit for
hwrng rather than the arch interfaces but that's not used until
userspace comes up, the arch stuff is all expected to be quick.  I
suppose we could implement the SMCCC stuff for the early variants of the
API you added so it gets used for bootstrapping purposes and then we
rely on userspace keeping things topped up by fetching entropy through
hwrng or otherwise but that feels confused so I have a hard time getting
enthusiastic about it.

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl+kDFwACgkQJNaLcl1U
h9ApKAf+L+RsRcER02kUvtZaA3aURIv7gEO9F8JuiH9/H3k1obk5bhnah70SMZfH
7DAuojVb0QQPx47KtqF//t8Zf0NBRcbzOH8tdcT9dra1LeCyeFWX/aTR5jjxPECj
qHsdK0a8Cp73kXJpz83zbCuZcxzDVXIJkQZs+9OAAFVH/l5kriIcsT2DDXbA/gJN
45gX+XnMHGRoDoiMu5LfRGA4YFqWYqiJtTau2Njm203qFQL1de4sD5VGpaLM+IXk
bOVcl9wuMwxWRy7b7JRaJ1m5lE7kXVG/RKYeZUoCekZtDAqYdcU5t7n7QrNKJAJW
xIIvhhLZjhtp/RhDtiI0lL4B0ENuhg==
=hyQv
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--

--===============1882368171717553693==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1882368171717553693==--
