Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A32C63697
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 21:07:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0648424199
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 21:07:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MkMcaVbT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0648424199
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F8A14B789;
	Tue, 17 Nov 2020 16:07:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cpG9FyBD60Fp; Tue, 17 Nov 2020 16:07:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 438754B70B;
	Tue, 17 Nov 2020 16:07:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52DBF4B6FB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 16:07:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9F575x5BvBZd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 16:07:34 -0500 (EST)
Received: from mail-lj1-f193.google.com (mail-lj1-f193.google.com
 [209.85.208.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4865B4B6BC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 16:07:34 -0500 (EST)
Received: by mail-lj1-f193.google.com with SMTP id o24so25916627ljj.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=CU3SArao2TWZ4ftpyPtxC+WfyQlzJupBDnVENNWncwk=;
 b=MkMcaVbTxLTZpAT/mEkoIWFl6DigDOHiaDGRkju6/uwWFrBPkoFW8dE+HcjteM0p2u
 m+Nw4OK1do4dVQdQfbJEZJJ/8c6tyOhrf3Vn6V2ijRtDw0AkkXb88yCcxv3IG2fquPCk
 jTQMga6bREVPOmcycJ6xsqiQtbrYme2RskC6WoJ4BAI60dq/t/HGKnUFtyQZEvWQ57Xd
 AJrl6iO9BnyzTT3mOzOAA8uhVvZmT8aXGY05nL+hh2ZD0aMC+4MVKPMAzg4UaDWbQx32
 fdwgv/IxCxbM6+QQFVXHLlJ+EN/arExeCuBIk6eT68SSzVmKVhTeAyOTeEvGtw8KFP4V
 CqWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=CU3SArao2TWZ4ftpyPtxC+WfyQlzJupBDnVENNWncwk=;
 b=HKI86xyyzQy3e2q/LYxsXkZf+Bzj2EXZXsnUpmvluubMktvjubbrcIFE/7DbknmxAJ
 EOIW/qfN3l+aOJJmTHlnB/088h7B5YwlzCOYS3v92GObwm4yVS7teLDUQxayqJ4RKCm/
 M5cVvLqnDBAhWOBDk7z9RBD9B59zDYmQqXy/Ml6BEmB0bjMwndUO8fddclNMnR24vn1d
 PnMDnXl1hHrN5wyE/V+lYosultdLM19+LfV3qzavihrwWczt1ht6tT28e+BvWUYqS+Kd
 rien7ytcKZkz2TMGwAUtDfGE12gbs4W2w0mZeHr4tmIYzMdx35PhwADJzbyfBnUszxa9
 CoVA==
X-Gm-Message-State: AOAM533hxTbJuuNQ4Ty/2SN/9leqRhvzwels9cYgV88FrxpkFeZYgw9w
 11d571e+J2t3qdlrbDa2m1PYrf6eMmxPmgneMxwWiQ==
X-Google-Smtp-Source: ABdhPJzlSZ6Y0i6Nud9rh7/3FWNWHGInbx9dQe+T9a6EcffyyxO2OhLCKTS0pCIyAgcI2wFON95YKUYHAdi4nA5NKxA=
X-Received: by 2002:a2e:321a:: with SMTP id y26mr2894523ljy.293.1605647252847; 
 Tue, 17 Nov 2020 13:07:32 -0800 (PST)
MIME-Version: 1.0
References: <20201113182435.64015-1-andre.przywara@arm.com>
 <20201113182435.64015-2-andre.przywara@arm.com>
In-Reply-To: <20201113182435.64015-2-andre.przywara@arm.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 17 Nov 2020 22:07:21 +0100
Message-ID: <CACRpkdZ6ufvhUXci=64sXq=7LTW0SJ-Mb-YyhpCBPQhttSRpEA@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] firmware: smccc: Add SMCCC TRNG function call IDs
To: Andre Przywara <andre.przywara@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Theodore Ts'o <tytso@mit.edu>, Catalin Marinas <catalin.marinas@arm.com>,
 Sudeep Holla <sudeep.holla@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Russell King <linux@armlinux.org.uk>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Nov 13, 2020 at 7:24 PM Andre Przywara <andre.przywara@arm.com> wrote:

> From: Ard Biesheuvel <ardb@kernel.org>
>
> The ARM architected TRNG firmware interface, described in ARM spec
> DEN0098, define an ARM SMCCC based interface to a true random number
> generator, provided by firmware.
>
> Add the definitions of the SMCCC functions as defined by the spec.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
