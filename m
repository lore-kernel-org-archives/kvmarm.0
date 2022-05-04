Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B61AC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 14:17:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DADD4B15C;
	Wed,  4 May 2022 10:17:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y3WX9tb2z1w0; Wed,  4 May 2022 10:17:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 516B34B105;
	Wed,  4 May 2022 10:17:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0B6F4B092
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 10:17:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3lHTbTgCvbFH for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 May 2022 10:17:07 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 266594B11A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 10:17:07 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id A206561A60;
 Wed,  4 May 2022 14:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5928DC385A5;
 Wed,  4 May 2022 14:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651673825;
 bh=bILCd1sxeIvbA+5tD85VdyDhv+PjR1QceeyC4i77F7s=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=PLaT0ROECinBJfleAOFsjO8U4x0scBFNpxF4+15z0Su2w/B7oQ2INoyEjMXkuYAx3
 T6aZVqJIMp3545+ISNDEKzwef3R0jQu2UIQ+SFoR2onOzlfgD+XwyuFB+mq5lnX1Zd
 QCnAuTM3BrtCryngmeJs8xrx8xnq+2qre5Ng9L8uFNExQKjA+VYesn4luSRw6BBOE/
 dJCm9vXCVDiFq4yxNIhYWsot7K+7+/3ZqfZSlW66Gu8GfLrH5F/CTf9d50xAfc5N4h
 ISyZ5JMtDV2R7x1gI2gs5eNItXAGhDGGNkvxXRu9NZfFwWA39X+eNQarV01lyJKmR5
 VBoZ6TItaJNTw==
Date: Wed, 4 May 2022 15:16:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v2 2/5] KVM: arm64: Compile stacktrace.nvhe.o
Message-ID: <YnKK2IxdbVvcsOC2@sirena.org.uk>
References: <20220502191222.4192768-1-kaleshsingh@google.com>
 <20220502191222.4192768-3-kaleshsingh@google.com>
MIME-Version: 1.0
In-Reply-To: <20220502191222.4192768-3-kaleshsingh@google.com>
X-Cookie: Mother is the invention of necessity.
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Marco Elver <elver@google.com>,
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
Content-Type: multipart/mixed; boundary="===============5024681354878769829=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============5024681354878769829==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/Hx6xiGRCvg0C4uF"
Content-Disposition: inline


--/Hx6xiGRCvg0C4uF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 02, 2022 at 12:12:02PM -0700, Kalesh Singh wrote:

> Recompile stack unwinding code for use with the nVHE hypervisor. This is
> a preparatory patch that will allow reusing most of the kernel unwinding
> logic in the nVHE hypervisor.

>  enum stack_type {
> -	STACK_TYPE_UNKNOWN,
> +#ifndef __KVM_NVHE_HYPERVISOR__
>  	STACK_TYPE_TASK,
>  	STACK_TYPE_IRQ,
>  	STACK_TYPE_OVERFLOW,
>  	STACK_TYPE_SDEI_NORMAL,
>  	STACK_TYPE_SDEI_CRITICAL,
> +#endif /* !__KVM_NVHE_HYPERVISOR__ */
> +	STACK_TYPE_UNKNOWN,
>  	__NR_STACK_TYPES
>  };

I don't immediately see a problem with it but I'm curious as to why
STACK_TYPE_UNKNOWN got moved to the end of the list here?  It does mean
that zeroed memory will default to STACK_TYPE_TASK but we're not
actually relying on that.  Otherwise

Reviwed-by: Mark Brown <broonie@kernel.org>

--/Hx6xiGRCvg0C4uF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJyitgACgkQJNaLcl1U
h9B05gf9He8i0lJSgnAoCwOnWz42y8l46CHTUSZJK53nFwnevW7nvl0Xdf1Rajhv
b1dBcynlwm2uAAHoeGen9HfX4sL0uj5e+mrg9IzoKq6GbqZfv9J2LNrCnI479gAU
GURaSasiSq3bEyxogf1eMsH2G4Kkams6LtgdSI7fr/P1JHIU+KItROmRh2zNC2jS
obAW/wC6HUJfsz1moQrO9/W1VLT8DeqBuYmTOIDZsiyJ3IKQhkZeQb2ztDU/TWeO
AUvI14Z1BWGgEisgaJx06/Y9x6nlayfkC1kEc2kMcOVPjWqqAoeHEWsL1ZmfLs9U
wlE20k5QYG+a2rgiqCSjVBtRSExj6Q==
=JjBs
-----END PGP SIGNATURE-----

--/Hx6xiGRCvg0C4uF--

--===============5024681354878769829==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5024681354878769829==--
