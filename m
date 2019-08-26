Return-Path: <SRS0=oEtv=WW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77437C3A59F
	for <kvmarm@archiver.kernel.org>; Mon, 26 Aug 2019 12:00:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E2DF12070B
	for <kvmarm@archiver.kernel.org>; Mon, 26 Aug 2019 12:00:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C3CIXYqg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E2DF12070B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E5D64A369;
	Mon, 26 Aug 2019 08:00:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xDXEePSJ2U80; Mon, 26 Aug 2019 08:00:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B0F04A5A8;
	Mon, 26 Aug 2019 08:00:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B1194A594
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Aug 2019 08:00:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gGuktF+xvyig for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Aug 2019 08:00:14 -0400 (EDT)
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com
 [209.85.167.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A2F944A592
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Aug 2019 08:00:14 -0400 (EDT)
Received: by mail-oi1-f169.google.com with SMTP id v12so11851762oic.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Aug 2019 05:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=SdfQ2/ZiXA4SobFkMH75D5kQJweG7eEDOUjmz6EtaQw=;
 b=C3CIXYqgt/x1iuJpoA5Lc5ckpFWRGFrU1aJfpYupHRh6f4CjaFi8Rpj32tmfteZZg3
 J1icu/Ng3guq1UjfOQ5frV+kwOApx8tvymyNMH14DzgKLrRvUjl7mnhBX40tBnKPfkSj
 7RcdVmOXb+VbZS6wW0417B6B/GLheBjtz6RszI1lCzUWWGgL73egpSqNrYOx8mnVrJWD
 LnvRERiNMJPYwo0y5G8pCtQGVS2QdbraOLjvjz9nj2rG37gOOeO3of+81MYiYsMIEajH
 8udVuZKBCl5g84SHHZ28Dxe6g4GVOknpYYx4CqAIFRj7E7izVDiNwNgAMNhs811q7gUM
 wgAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=SdfQ2/ZiXA4SobFkMH75D5kQJweG7eEDOUjmz6EtaQw=;
 b=h6bP/VpIh1Mt2XYUBQdHSdpj7xMjE/1h9oSVQG9ZhCtb72stL7PU88ZxLp3j0IPvtQ
 o/3SBOhG3/QVq8IhN9hvFuBkWPsueHpv3dZuYkKRj8CDn6y7SKtdqkFWEhy/U4qeE37Y
 CKoJ4J4kLHVYerOZ7Becz9NYWaussu+C0NrrG2UQTE/+hEI6gwgy2+s19ZAkWJw+Pq+O
 hx6Q5p50raspcKMRNSfDmsnW09415+khS/2oLOjQcV4gW5W7MLkCESnct3F15hvmqGgb
 br0TAP3EPpaOkIIAsE7a5nCF7iK/nO/mQWQM9JRLnA4cfDVwkciFDNIqswyuiW+Vt4xz
 X18w==
X-Gm-Message-State: APjAAAXJaO1dY001oTv8/CNkW4m1ZsVy4EUu7s8QqiAmvzolS05H0Z6X
 PZ5CrEpXfz6DgVrqdTzrO5imSteSpa5puY4km8trxg==
X-Google-Smtp-Source: APXvYqwLked0T5pqTrSBL7PmdICrZaA/CS6ycR/k0FpWc871ogXXJKjUSOPrHE9nXYjPm34iAtYF+Xe96bO/Y7f8cDw=
X-Received: by 2002:aca:4814:: with SMTP id v20mr12134850oia.98.1566820814025; 
 Mon, 26 Aug 2019 05:00:14 -0700 (PDT)
MIME-Version: 1.0
References: <1d1198c2-f362-840d-cb14-9a6d74da745c@web.de>
 <20190629234232.484ca3c0@why>
 <9fa56744-9925-6f49-b2a4-368e13fbbc41@web.de>
 <3f6ea07b-975b-3d66-e12d-f0a9cadb83a9@web.de>
 <20190826083806.GA12352@e113682-lin.lund.arm.com>
In-Reply-To: <20190826083806.GA12352@e113682-lin.lund.arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 26 Aug 2019 13:00:02 +0100
Message-ID: <CAFEAcA-eshVRaAMpdNkjbBXtiwHpkjVgUbnH5mkoXqTCkFD-FA@mail.gmail.com>
Subject: Re: KVM works on RPi4
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Jan Kiszka <jan.kiszka@web.de>,
 kvmarm@lists.cs.columbia.edu, kvm <kvm@vger.kernel.org>
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

On Mon, 26 Aug 2019 at 09:38, Christoffer Dall <christoffer.dall@arm.com> wrote:
> On Sun, Jun 30, 2019 at 12:18:59PM +0200, Jan Kiszka wrote:
> > Hmm, looking at what KVM_ARM_TARGET_CORTEX_A7 and ..._A15 differentiates, I
> > found nothing so far:
> >
> > kvm_reset_vcpu:
> >         switch (vcpu->arch.target) {
> >         case KVM_ARM_TARGET_CORTEX_A7:
> >         case KVM_ARM_TARGET_CORTEX_A15:
> >                 reset_regs = &cortexa_regs_reset;
> >                 vcpu->arch.midr = read_cpuid_id();
> >                 break;
> >
> > And arch/arm/kvm/coproc_a15.c looks like a copy of coproc_a7.c, just with some
> > symbols renamed.
> >
> > What's the purpose of all that? Planned for something bigger but never
> > implemented? From that perspective, there seems to be no need to arch.target and
> > kvm_coproc_target_table at all.
> >
>
> There was some speculation involved here, and we needed to figure out
> how we would deal with implementation defined behavior, so we built this
> support for each type of CPU etc.
>
> In reality, most CPUs that we support are pretty similar and that's why
> we did the generic CPU type instead.  In practice, there might be a more
> light-weight appraoch to handling the minor differences between CPU
> implementations than what we have here.

The other future-direction I think we were thinking about was that
one day we'd want to support showing the guest a CPU other than
what the host is, at which point you would want to be able to
say specifically "give me a Cortex-A7" and have it work even if the
host was a Cortex-A15. But there are significant unresolved design
issues if we ever did want to go in that direction...

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
