Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A0EBC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 17:18:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D432F61179
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 17:18:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D432F61179
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7465D4B0FC;
	Thu,  9 Sep 2021 13:18:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BFbIlW-sPa8b; Thu,  9 Sep 2021 13:18:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D7914B121;
	Thu,  9 Sep 2021 13:18:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F15E24B105
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 13:18:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zylMnj5C-WuB for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 13:18:33 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C934E4B0FC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 13:18:33 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31294610CE;
 Thu,  9 Sep 2021 17:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1631207912;
 bh=Vzgjd07EtEWqLqFdwBwVXT6tQoiq5L9fl/NNb92VUM0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=nKvpjWDLmIbAiqGD25fjLhXyoOHGOY/R1rU7sbr7K5iSlc0NvQko/e83vdDFjGY3z
 QQ92yGJODGkgiQ9O0jQCl6i3wM774ALW3WLH7Z3ANlpWUA3pyDBzqScfnmsj1ZcSs0
 YPj5B3tTj7hvaICEUW+9tZsxestBaWh5yjts6EPsopIOe7yjxYbGCU2ZR8LMaWlaQM
 5SdhaWr6qX31BN3PPVJQHBV+JvH3bm0z5+oX8HUtJp8IZvMeak66N9FzwRHOd2gZ0N
 MRpQQEzCf8LYoSV5vKZgtnlfZB6ZazozaGmx8OhCoR/2S6hH8lrHPrE8sUOFZdvKeT
 bxxhE0qzdFjOg==
Date: Thu, 9 Sep 2021 18:17:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 02/18] KVM: arm64: selftests: Add sysreg.h
Message-ID: <20210909171755.GF5176@sirena.org.uk>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-3-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210909013818.1191270-3-rananta@google.com>
X-Cookie: I have become me without my consent.
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: multipart/mixed; boundary="===============6489602642896998982=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============6489602642896998982==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="aZoGpuMECXJckB41"
Content-Disposition: inline


--aZoGpuMECXJckB41
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 09, 2021 at 01:38:02AM +0000, Raghavendra Rao Ananta wrote:
> Bring-in the kernel's arch/arm64/include/asm/sysreg.h
> into selftests to make use of all the standard
> register definitions in consistence with the kernel.

> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/include/aarch64/sysreg.h    | 1278 +++++++++++++++++
>  1 file changed, 1278 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/sysreg.h

Can we arrange to copy this at build time rather than having a duplicate
copy we need to keep in sync?  We have some stuff to do this for uapi
headers already.

--aZoGpuMECXJckB41
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmE6QcIACgkQJNaLcl1U
h9CAPAf+MQBjgDWR7i61DAYpl8mThqlPrRcYiztJRwtYDtMw4tnFmF/r7HCTXxTD
hznDPxnOmwaOTRqfL/fx7iIeBQGrVFlGdS+RPZcs2MGi9kasXOy0osmAAVC8xYi9
jawBd/Rb6MMxWin+UYNbKmqfUmXwWuOB8Jgo7Q03+Ef02u5H2YX4uhc2G7zpjzLS
TgXJBJVGsAzktFvAux/uM6ohHahk/pvvVKV9WmTmQS0Q/irfGevkwOCSExfKHVCS
LJN2eeZxmILmdc6FMEHqvi+p5YHyilJJdMFStqXBKSRSjMkx2S0AY46vHD6JNMaX
eqb+UAF2bjsjsvUxjZ2m7wHOdCTYUg==
=sR7c
-----END PGP SIGNATURE-----

--aZoGpuMECXJckB41--

--===============6489602642896998982==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6489602642896998982==--
