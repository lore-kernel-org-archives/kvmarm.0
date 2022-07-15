Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B109CC43334
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 16:30:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B5EB4BCDC;
	Fri, 15 Jul 2022 12:30:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8qoJp0kyb3ze; Fri, 15 Jul 2022 12:29:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EAF374BDED;
	Fri, 15 Jul 2022 12:29:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CCC34BCFA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 12:29:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5V8krfiCafAy for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 12:29:56 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E7394BCDC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 12:29:56 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id B4A61621DA;
 Fri, 15 Jul 2022 16:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF5BC34115;
 Fri, 15 Jul 2022 16:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657902595;
 bh=b+jtvTOz7oqT34ApAzNVxtGMJmDAMluL+3xOy4XNbdg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=sFQbcqN+aA4ECw0IOGayRM12VcFpMTk3NRc6xGABBJphOhftRClJt4/lLcNWM6JVY
 oObrPAV6teFFAY/mZBBWOddBr1EbVeOb+8GPLJqoguvW0GvPNc0KS2XTSMqzDiIE5T
 jUXGcURzf4hzjA1iHiZNZomatQbUDBxE9DMPDvifVJjo0dtfVTPaNub+OElB8dLF8K
 2bTNOaNzcvAofgkn7oul+fEo2aaY+rYxYdWrbC6NXGc/fV0MWJJLALBPu1XYuCR/jL
 pkqz4m5zKehuO/kYOAabRCq180Q6zmVQjpFZmdiv4RhcNdPNYY32yXcMBfhgVg/rkp
 dm+E8xWsV5mPA==
Date: Fri, 15 Jul 2022 17:29:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v4 03/18] arm64: stacktrace: Factor out
 unwind_next_common()
Message-ID: <YtGV+uS84iGXiVky@sirena.org.uk>
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-4-kaleshsingh@google.com>
MIME-Version: 1.0
In-Reply-To: <20220715061027.1612149-4-kaleshsingh@google.com>
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
Content-Type: multipart/mixed; boundary="===============1594913874745996079=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============1594913874745996079==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hQRAZMV6dDRdJcTB"
Content-Disposition: inline


--hQRAZMV6dDRdJcTB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 14, 2022 at 11:10:12PM -0700, Kalesh Singh wrote:
> Move common unwind_next logic to stacktrace/common.h. This allows
> reusing the code in the implementation the nVHE hypervisor stack
> unwinder, later in this series.

Reviewed-by: Mark Brown <broonie@kernel.org>

--hQRAZMV6dDRdJcTB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmLRlfkACgkQJNaLcl1U
h9BRdgf/WGznLdXBmkPr3BXfleflXq0WsgCfJAyd1GcJyuDPbIM6UHY07F4799px
Q+6OmFSTkbsc9IbNxNi3Bse6btyrCn6YDytEiNckAybB+71pDwixovWlcV0SigGA
eG1lzgKp7Xhlte0PdzuIsztVOuKvscn6umieTJxPlkwjZ5Uzxo8ryrJb9tgP3ZE5
C9pDGBg/1Y6+sNCA2FbhRaBQwnkCaU6kK+IhdLN24M/wLRhuDDlbmeL4zXZmpdXB
LGSu2Vmvl8XV0rrw0WeUeLsk9sk2zkJ9OAEjOUI2RMCg4A2DeYnyhdMeJF6NtiCS
9n5x8AkhzEeTXjnfvtHapkHs+hpwAQ==
=BScg
-----END PGP SIGNATURE-----

--hQRAZMV6dDRdJcTB--

--===============1594913874745996079==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1594913874745996079==--
