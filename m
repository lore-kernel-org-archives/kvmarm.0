Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCAE2C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 15:32:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B76E4B1AD;
	Tue,  8 Feb 2022 10:32:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vwQP84hg09aA; Tue,  8 Feb 2022 10:32:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 526314B0DB;
	Tue,  8 Feb 2022 10:32:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 368104B08B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 10:32:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dMi17v6PtuGq for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 10:32:45 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB1254B08A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 10:32:45 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 3F534B81B9A;
 Tue,  8 Feb 2022 15:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E3EC004E1;
 Tue,  8 Feb 2022 15:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644334363;
 bh=xkCl46PxIRqJOyLnKnXeEbrwIR9VZcGvqu20AX+stiw=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=RBOazE6zLv/3hLMyJSCZD8cd2X4UXB3kotQ2i1oU0JqdeXdvNwJr6IbAhyB8FqLaT
 pjkfzs/UVkwd7STsDa9c/GnqcRDuP01FnTwbvVwbAgWQO16fs4b/Iwvkpodwqbs/JV
 BztzYXnRm7n2U7czRNBZAB5LULrWy4TxIzu83s+buC4vNDMFK/DXgouVnUtbJvVLON
 S0Ra+nQ6FWqg5M0nJQqpVYwP7egbpZub23iXAiIS799OzTo3ARMgf5YhpSh6dY9Y/v
 B4o6RZmGHuL1YJZQ7Cj6skVuCnQZMHhEZdarxyohIlk5rsOVMz/Hg5BlWC537XILBb
 w6fFYHE8R+w6A==
Date: Tue, 8 Feb 2022 15:32:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v11 05/40] kselftest/arm64: signal: Allow tests to be
 incompatible with features
Message-ID: <YgKNFHzeBdq0J77j@sirena.org.uk>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-6-broonie@kernel.org>
 <10072dd0-8853-81fe-0c94-a00638b12f9a@linuxfoundation.org>
MIME-Version: 1.0
In-Reply-To: <10072dd0-8853-81fe-0c94-a00638b12f9a@linuxfoundation.org>
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
Content-Type: multipart/mixed; boundary="===============3684756266146634669=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============3684756266146634669==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="z8ks9/oFG0GDDgkd"
Content-Disposition: inline


--z8ks9/oFG0GDDgkd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 07, 2022 at 04:54:31PM -0700, Shuah Khan wrote:

> Assuming default_handler() will skip test and return skip test when
> feature is unsupported?

Yes.

--z8ks9/oFG0GDDgkd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmICjRMACgkQJNaLcl1U
h9CO6QgAhqg+JBvQZ/3fZt76+A70JOOev3FnXbKIFWDN4T6WPi6WUg8VX1yQ/MRU
NQxZ2+E9xcMAGlz2DBiUkyEBypJS48Qv+xITa7HLpqQ6Lz+qu3HRk76BhHUkGbiq
X01XiZHgS0ehDkVLqo5RhuUxvXLTBUKxXurlxVxuPTE1jWKz3s5hrjstv2AD164o
1e1mJ9BnmyjyCpzW2hJN3ZssaxreQMhUvmIfHyH8C0zsaR7EBwSg/rmSjvl7KRH6
9MxB8LFBA58w+GtbBcRn8XarugENsVq5EzOaC6QpI5CQuxJ6lYKUc5/3hNoeU+nP
TMe4bM4HmJbRNc8Lii4pII/aoqBSAQ==
=QONM
-----END PGP SIGNATURE-----

--z8ks9/oFG0GDDgkd--

--===============3684756266146634669==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============3684756266146634669==--
