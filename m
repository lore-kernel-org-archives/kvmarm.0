Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22963C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 29 Apr 2022 12:47:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91B654B1F2;
	Fri, 29 Apr 2022 08:47:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e83TCvjmM-eX; Fri, 29 Apr 2022 08:47:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75F864B202;
	Fri, 29 Apr 2022 08:47:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 763A64B1F2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 08:47:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mvD1KZi-UAMk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Apr 2022 08:47:37 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D7AB4B119
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 08:47:37 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 98608B8350C;
 Fri, 29 Apr 2022 12:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44F5C385A7;
 Fri, 29 Apr 2022 12:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651236454;
 bh=l/ZXIC0BCgutI+C22NZVWcDfaMSWrQgzViGseNxj74A=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=PqBY/U2kPgctQjMbW7NYk09e+E6gjTLk27xNt9PBseyjFJEBFaYP693SiHoDnTu13
 CojqRn0cz2h4rZiomocJVYg38i4Ls2QLCIPWtRF5Hqj0AxzWLY27VT2x8jIs04Xroe
 7LIXp6SUXjLUwi2HP6m0Rxf56oZ+SaFA6/wSIFd5YzGjG6Oxi6p2XBPLERnZchCyWS
 BT8wYrRCMWw1TC/c4gtD6gmJKznP7rfbOrUC+Y7xX6tDm+ZKi1omHOhlOfXXYloM2Z
 oaSfy5cXhTzG7Qp/P1VeLqlalcSRjwPmP5i6NJmW5Jsx2JnZmIZjrA+ov1Fz1+tlz0
 1mEumpFxTP/vA==
Date: Fri, 29 Apr 2022 13:47:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH 1/4] KVM: arm64: Compile stacktrace.nvhe.o
Message-ID: <YmveXly9117jbWKr@sirena.org.uk>
References: <20220427184716.1949239-1-kaleshsingh@google.com>
 <20220427184716.1949239-2-kaleshsingh@google.com>
MIME-Version: 1.0
In-Reply-To: <20220427184716.1949239-2-kaleshsingh@google.com>
X-Cookie: Are you still an ALCOHOLIC?
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 surenb@google.com, Peter Collingbourne <pcc@google.com>,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
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
Content-Type: multipart/mixed; boundary="===============5250749274581553776=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============5250749274581553776==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Y3YSke25lSrZY+/w"
Content-Disposition: inline


--Y3YSke25lSrZY+/w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 27, 2022 at 11:46:56AM -0700, Kalesh Singh wrote:

> Recompile stack unwinding code for use with the nVHE hypervisor. This is
> a preparatory patch that will allow reusing most of the kernel unwinding
> logic in the nVHE hypervisor.

This is substantially more than just the build change that the changelog
would seem to indicate...  it would I think be clearer to split this up
further with the code changes separated out and explained a bit more.
It's not just recompling the code for nVHE, there's also refactoring to
split out changes that don't apply in nVHE hypervisor like all the task
related code which is needed but not mentioned in the changlog at all.
Possibly a patch or two for the code motion then a separate patch for
the ifdefs and build changes?

I *think* the code is all fine but I'd need to go through it a few more
times to be sure I didn't miss anything.

--Y3YSke25lSrZY+/w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJr3l0ACgkQJNaLcl1U
h9DBXAf/cLhAZeKbkJs3LEkvnKGiulU0FIY+O9WBWvNL1mfn2AlN4TJrfv6vBsg9
DvcKZBSqLs1cPow78FoQoKxyhXLW93diLBiFnHQbRSpxTRDJNv5dln5BApd/rX1x
UGKUFo2BXhBdes9xUpXQcnbVp3uLHWA7T3kzsr9yz5idTnhWd+51DLQYLHvJRo/n
byZODs7JPbiSyB/28DKkQy+/gVSj9vP+gOsXDRBNDECWr19FDcbXje2TYWfV6aUK
3COthbPNESl1tPvLfUuDTCjPTOhaKCAkIIXt7uDk5ofr74AHqR2r05Tfz+R0o6SB
OMVfgIypmtPQ2B246uUEOGwDwJAJYQ==
=vcwd
-----END PGP SIGNATURE-----

--Y3YSke25lSrZY+/w--

--===============5250749274581553776==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5250749274581553776==--
