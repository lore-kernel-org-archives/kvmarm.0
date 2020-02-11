Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0932C352A3
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 16:28:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3986B20708
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 16:28:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SoHdSL0v"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3986B20708
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A96DA4AEB2;
	Tue, 11 Feb 2020 11:28:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NVcU3dqSdPjc; Tue, 11 Feb 2020 11:28:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAD8C4A4FF;
	Tue, 11 Feb 2020 11:28:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70BAA4A4FF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 11:28:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cMDQd4U1Pdji for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 11:28:43 -0500 (EST)
Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com
 [209.85.210.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 707064005D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 11:28:43 -0500 (EST)
Received: by mail-ot1-f65.google.com with SMTP id h9so10655367otj.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 08:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=sBL1pdvCcbU5vh2MRuYeHAqsYDWdsnFmPWD7z1MAFS8=;
 b=SoHdSL0v6iKBaL8zgd+lCUElYoaXsAfUEXa9LewiooAA5sfD7WLzJr/zUAq9inb3HN
 g9KiANDepXgVQcQML6UQoWdxX/zCH7k5u/cQJb++myJJll2u1soQx+bX3bgsEogEyYwT
 o98FqckKC1IhQGCE3z3WZHOMPuGB8UU2meAF8cGqSkqAshTrVWdNtyg65J2bHeD0z3AG
 LH8pUj+bixTPli6OWfF6iNF+dspoPIks04pG2OV9Re/uPltKscvyX9FfW6qXZfK/hE4Q
 DwsGFLAMTwyXlci8q0KGniQs9daCRGj+ie2k3v81msJ7xmG5YCS5YkqCUHbx8lobeQuZ
 r3fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=sBL1pdvCcbU5vh2MRuYeHAqsYDWdsnFmPWD7z1MAFS8=;
 b=jDq1Sm39KXdRCJCJxZ0G6PiIxGfLjr+bRPSksLQ6LOOJcsr2Fw6qMJejTSiO/Y/Dg0
 MQKF40jTT/MkXXpy1KlJ6xqWJViGKIM+OtG4tQys20/2snEtwEGZoZpMjdoLl1NPzrcO
 U2YO/mpQ6GpieZQH4bJVQhFXJ5gkFO8OM43mSbPBnS1yF3lCmlP0/EmYlee4GgVl4PHQ
 HQi0qy5oYc4U97yxNP9rKbYW4BjQWOFJIqLaeSJw+Ceb3HQpLjELd+SO+PWdrI89jZR1
 MuBVy/oxTNj4nV55DTtym4dk7zEeqcZn4mY/G6cp+hQ37a4gC1csThtBOvuYCp9S0kw7
 V4Sg==
X-Gm-Message-State: APjAAAX7sKYjIzoKIGCohHX6HQp/C5outfcokGnz98lNZudW6Vtt7TqY
 LmuwjCY8IFuhmEQU5QaoXVpCfas/7nba7ERRo7Y+Zg==
X-Google-Smtp-Source: APXvYqwMDFOjjhVbQZtRmwikjYOZ3DieS0MB81Yf/FbcjGebMqahe3qweuGumfab9jxqW2C9ue8obJUgmNf0Y4w4xC8=
X-Received: by 2002:a05:6830:4a4:: with SMTP id
 l4mr5921019otd.91.1581438522842; 
 Tue, 11 Feb 2020 08:28:42 -0800 (PST)
MIME-Version: 1.0
References: <20200130112510.15154-1-eric.auger@redhat.com>
 <20200130112510.15154-5-eric.auger@redhat.com>
In-Reply-To: <20200130112510.15154-5-eric.auger@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 11 Feb 2020 16:28:32 +0000
Message-ID: <CAFEAcA_V3rT+C1FCPPyjmQ8svxF1tMWWOLgZ1Vn_CNQ3N0x-KA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 4/9] arm: pmu: Check Required Event
 Support
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 QEMU Developers <qemu-devel@nongnu.org>, qemu-arm <qemu-arm@nongnu.org>,
 Andre Przywara <andre.przywara@arm.com>, Andrew Murray <andrew.murray@arm.com>,
 kvmarm@lists.cs.columbia.edu, Eric Auger <eric.auger.pro@gmail.com>
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

On Thu, 30 Jan 2020 at 11:25, Eric Auger <eric.auger@redhat.com> wrote:
>
> If event counters are implemented check the common events
> required by the PMUv3 are implemented.
>
> Some are unconditionally required (SW_INCR, CPU_CYCLES,
> either INST_RETIRED or INST_SPEC). Some others only are
> required if the implementation implements some other features.
>
> Check those wich are unconditionally required.
>
> This test currently fails on TCG as neither INST_RETIRED
> or INST_SPEC are supported.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>

> +static bool is_event_supported(uint32_t n, bool warn)
> +{
> +       uint64_t pmceid0 = read_sysreg(pmceid0_el0);
> +       uint64_t pmceid1 = read_sysreg_s(PMCEID1_EL0);
> +       bool supported;
> +       uint64_t reg;
> +
> +       /*
> +        * The low 32-bits of PMCEID0/1 respectly describe
> +        * event support for events 0-31/32-63. Their High
> +        * 32-bits describe support for extended events
> +        * starting at 0x4000, using the same split.
> +        */
> +       if (n >= 0x0  && n <= 0x3F)
> +               reg = (pmceid0 & 0xFFFFFFFF) | ((pmceid1 & 0xFFFFFFFF) << 32);
> +       else if  (n >= 0x4000 && n <= 0x403F)
> +               reg = (pmceid0 >> 32) | ((pmceid1 >> 32) << 32);
> +       else
> +               abort();
> +
> +       supported =  reg & (1UL << (n & 0x3F));
> +
> +       if (!supported && warn)
> +               report_info("event %d is not supported", n);

As with satisfy_prerequisites(), printing this with "0x%x"
would probably be more helpful to most users.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
