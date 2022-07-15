Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8028C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 12:37:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15AE54BE09;
	Fri, 15 Jul 2022 08:37:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kgQ9t1zm-NI3; Fri, 15 Jul 2022 08:37:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6E724BECB;
	Fri, 15 Jul 2022 08:37:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A514A4BE07
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 08:37:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 74OiVVURVJ4f for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 08:37:15 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D47C4BE06
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 08:37:15 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1B0B962354;
 Fri, 15 Jul 2022 12:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343D6C34115;
 Fri, 15 Jul 2022 12:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657888633;
 bh=nAEOH0Vx7WLWFiSQ+URXsr8ICrc+WJkk0tMki0ehFdE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=sxHS+//ProyW3VmElxOlZxXusWlbOSps2YzEaKxCP0/tPcyq74VALg3YU8raJpoxD
 dBNgx0wY5nGjX0e+oTsvzjrcoJ6DNcdI3d78nsvPKGXnK+0ezB/ayE9T/1i/VL2uOU
 TouEjWC1koOjT/VsqFH1ZinWTF8sxdKU592mowGzWf+MVkjn8GzsfQXZs0Kl8fQk9Q
 +evfkfVqsztQSZxY+jbYVJs/Qns1R7uiXT5mZHduk/rMrYnEGf0Q1PapR9/21VV8c7
 cK++XF02i0MOE97a4PIvQvn3n9tzojtRc3f+6UkV+/pwZ9gxWCqN3L8l8GT9MZbcmg
 SLpfhtbKj0/sA==
Date: Fri, 15 Jul 2022 13:37:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v4 01/18] arm64: stacktrace: Add shared header for common
 stack unwinding code
Message-ID: <YtFfcLD4Gj9xFk2B@sirena.org.uk>
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-2-kaleshsingh@google.com>
MIME-Version: 1.0
In-Reply-To: <20220715061027.1612149-2-kaleshsingh@google.com>
X-Cookie: You dialed 5483.
Cc: wangkefeng.wang@huawei.com, elver@google.com, catalin.marinas@arm.com,
 ast@kernel.org, vincenzo.frascino@arm.com, will@kernel.org,
 android-mm@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
 madvenka@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
 andreyknvl@gmail.com, kernel-team@android.com, drjones@redhat.com,
 russell.king@oracle.com, linux-kernel@vger.kernel.org, mhiramat@kernel.org
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
Content-Type: multipart/mixed; boundary="===============8523249641512195158=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============8523249641512195158==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2+hyWNvuSRJtqBHc"
Content-Disposition: inline


--2+hyWNvuSRJtqBHc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 14, 2022 at 11:10:10PM -0700, Kalesh Singh wrote:
> In order to reuse the arm64 stack unwinding logic for the nVHE
> hypervisor stack, move the common code to a shared header
> (arch/arm64/include/asm/stacktrace/common.h).
>=20
> The nVHE hypervisor cannot safely link against kernel code, so we
> make use of the shared header to avoid duplicated logic later in
> this series.

Reviewed-by: Mark Brown <broonie@kernel.org>

--2+hyWNvuSRJtqBHc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmLRX3AACgkQJNaLcl1U
h9BVZQf9Gh9p8FOQCvidAwUkm4bCEP9LkLi2Gz/z9ntsnTSvkw2yP2NjlxWBBNY+
U6N+yQtcjQBz1taXq3g+d6mcxkSGHAhKMd4OvF/VqBUUX4vf5oaYHmsfvKukOu9Z
ZUHQAE/o/cYg0kAvwcMjlG55m82YtkRkdc6VgdZQSbvmauSFRIhamDv+Fizlubab
eWoO1h5asWZKw6c/ih0jTHIxvNKsf4CmIj407zUnIlC2Z8psya13VuXLWTOBEvfT
K2ECgj2yxg9HNtNxMpTDBQqMGO6zEjASSh6Cmuga9xgsFFFp04YWXg2a+EzBz+wS
Sm5qFShdBLDGtU0YgbhW2DXzTLEV5w==
=54bK
-----END PGP SIGNATURE-----

--2+hyWNvuSRJtqBHc--

--===============8523249641512195158==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8523249641512195158==--
