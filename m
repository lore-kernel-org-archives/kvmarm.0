Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F9BC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jul 2022 14:06:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3303C4D215;
	Mon, 25 Jul 2022 10:06:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vcwm4D97azKm; Mon, 25 Jul 2022 10:06:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A63F4D3A8;
	Mon, 25 Jul 2022 10:06:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F3494D2DC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jul 2022 10:06:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gpLXTzdSHF+d for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jul 2022 10:05:56 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 914294D215
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jul 2022 10:05:56 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id C8584CE1106;
 Mon, 25 Jul 2022 14:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD17C341C6;
 Mon, 25 Jul 2022 14:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658757949;
 bh=wHq74HoEAu9/EWdzqXc5E84wFTNprjsr8E+fC3OLjng=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=UWmPs8J3euf80lZkCgOWi8vY6aiWbg14PduksljpcnL8glDODXZ4g+N5f7RAzZ0xd
 kGp+8B9PpZ8EBGkRsVgCs7ecVlhCt4m/de4HeCbkZ6BI80W6tqSPSqHE1qJUTveO/U
 TL9QLN98srS8fK80vhnuFXqhNZRnhqbFFRsZQaSHxwPrGVxbxVpHc0Ut/rxPQgt1Kx
 bV8MQTtC0QLCPD+gDmpy6xqYanjQjQSmJLXelFq5kzWu9BMHkP2g3kadFwMH8SOMUc
 qYgvUNh1uIxJq+y5Ea0Nec+622Hv28dmmIVT5MVYC+jygzwDO+m3o5wyK3/5ytsP2O
 RvfARjM6Wl8aQ==
Date: Mon, 25 Jul 2022 15:05:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v5 05/17] arm64: stacktrace: Factor out common unwind()
Message-ID: <Yt6jNK17LWJ8IV4o@sirena.org.uk>
References: <20220721055728.718573-1-kaleshsingh@google.com>
 <20220721055728.718573-6-kaleshsingh@google.com>
MIME-Version: 1.0
In-Reply-To: <20220721055728.718573-6-kaleshsingh@google.com>
X-Cookie: We are not a clone.
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, elver@google.com,
 vincenzo.frascino@arm.com, will@kernel.org, android-mm@google.com,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, madvenka@linux.microsoft.com,
 kernel-team@android.com, drjones@redhat.com, ast@kernel.org,
 linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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
Content-Type: multipart/mixed; boundary="===============5650662399888582758=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============5650662399888582758==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XMHcVmXSGernh5QO"
Content-Disposition: inline


--XMHcVmXSGernh5QO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 20, 2022 at 10:57:16PM -0700, Kalesh Singh wrote:
> Move unwind() to stacktrace/common.h, and as a result
> the kernel unwind_next() to asm/stacktrace.h. This allow
> reusing unwind() in the implementation of the nVHE HYP
> stack unwinder, later in the series.

Reviewed-by: Mark Brown <broonie@kernel.org>

--XMHcVmXSGernh5QO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmLeozMACgkQJNaLcl1U
h9AelAf8CN+jflic2RTW4curxqE7B5aE0AKvQRbPZuiX0lCcnOFiF7f897pNSNFy
IozRUQi9IRjVa9vDFgPPBRRHkuFBNhnFnMxl9Gkh1BdyBJsAf8SuapeTFonxIPjh
FCjd7Nq9OcE7oV9bffe4+AyPvlzd6hR49NZUP6ED3hoyFh9P2tTKspVJUE42PLuA
CLFdi0MTHSp4B4KYWSh3TM1RU6bHq6vqRkt03sayLqMct9I0P267iTvTEGUh6Gxa
AHN0CHZ6FMaztObWGtumcqjM6H+o9oD0MeCT537iUwHEzuKKTKivIOtSmljBTqdR
0HfoD/QpY0A9FtKW5SRCCfXWFo5Whw==
=vfZh
-----END PGP SIGNATURE-----

--XMHcVmXSGernh5QO--

--===============5650662399888582758==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5650662399888582758==--
