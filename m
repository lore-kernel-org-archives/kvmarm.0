Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F95AC43334
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 16:28:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D23A24BF2B;
	Fri, 15 Jul 2022 12:28:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1A6FJaqyvm9k; Fri, 15 Jul 2022 12:28:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C978E4BEDE;
	Fri, 15 Jul 2022 12:28:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73D2B4BE03
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 12:28:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kMZxZNDLCsYL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 12:28:30 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6AC9A4BE01
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 12:28:30 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1D271621D2;
 Fri, 15 Jul 2022 16:28:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F61C34115;
 Fri, 15 Jul 2022 16:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657902508;
 bh=BgkSm8ui6rjbUv6iNSa5punER/Qz+CqOKXdmy3/Q5Xw=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=bS63rWU0NNEq8GgAhPoUTIF4TaSeMLUPtMXX4Q5TcPwIwpcfjJnoGXbTIRH9dvpDo
 ONX1Mi6klhF31IXgT2IpZ4syjjBi5aB2NTgRoLHOEIOd4Pim4WkoEWED70jBBmuPT5
 D860o6Ehy0W6StTs7IzaqiUb/y4AEuHEu4h3Nlaj1DrxKPWeoyin6uZT/kE9nv4Ygs
 etDSueGf5tmYiDu5O3C8byoBKkZrFzy6YGs+YScWCxpW88h/5j8rzeUKMoUZuZgokl
 bdiYOr27R1isPI28rh9Jrn/PBTZmLLkL3WJT2IJBKhJea+gpOXmumgYlbwkWWwdXD6
 0MC7+081vYyzA==
Date: Fri, 15 Jul 2022 17:28:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v4 02/18] arm64: stacktrace: Factor out
 on_accessible_stack_common()
Message-ID: <YtGVo8yNHmwdAvnC@sirena.org.uk>
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-3-kaleshsingh@google.com>
MIME-Version: 1.0
In-Reply-To: <20220715061027.1612149-3-kaleshsingh@google.com>
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
Content-Type: multipart/mixed; boundary="===============9158194137702163839=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============9158194137702163839==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jo+NRiUeE5EvKTfv"
Content-Disposition: inline


--jo+NRiUeE5EvKTfv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 14, 2022 at 11:10:11PM -0700, Kalesh Singh wrote:

> @@ -56,7 +56,6 @@ static inline bool on_overflow_stack(unsigned long sp, =
unsigned long size,
>  			struct stack_info *info) { return false; }
>  #endif
> =20
> -
>  /*
>   * We can only safely access per-cpu stacks from current in a non-preemp=
tible
>   * context.

Random perfectly fine but unrelated whitespace change here.  Otherwise

Reviewed-by: Mark Brown <broonie@kernel.org>

--jo+NRiUeE5EvKTfv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmLRlaMACgkQJNaLcl1U
h9CDzQf9EKWHL6a0nLbiAdh1O+G742JT9aXWLoDUXGo6+8nJQIAum9G4ur5zJ8KK
iUdKSLtS+9JOT0VxYqKyDN3wIcTeGSJTFDtVwJcHPZG3gxHHOlC4ab6I2e7jJyVO
4qK2hnz477HSGecXoIvLTKj6odbzX7u5kgkH7BaAJ7HkB3Mqjw4lK0PpmuC9B79T
93RlV4yaoo9muDvYXxQJLFCLcSZo9zQhBxZj22jujagqeeQnhMWvHPEt5Nyicqcu
8S4NQvuCihHUr7azWql8GmkQIwZK7TDG+NjR0qv4Hu6aMqW374I6fm78A8dG3+i5
Gk8IemJTPZfQeZ6AKfuDq1emsbl4BA==
=E0Ab
-----END PGP SIGNATURE-----

--jo+NRiUeE5EvKTfv--

--===============9158194137702163839==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============9158194137702163839==--
