Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A50EC352A3
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 15:34:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E6F822082F
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 15:34:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TCk96Zrv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6F822082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79A9C4AC88;
	Tue, 11 Feb 2020 10:34:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g9B+Q4zk1aZ4; Tue, 11 Feb 2020 10:34:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6975E4AEA4;
	Tue, 11 Feb 2020 10:34:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 346474AE9E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 10:34:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ed3NR8MAR1wD for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 10:34:11 -0500 (EST)
Received: from mail-ot1-f68.google.com (mail-ot1-f68.google.com
 [209.85.210.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3EB114A955
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 10:34:11 -0500 (EST)
Received: by mail-ot1-f68.google.com with SMTP id r27so10474995otc.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 07:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=SC8tyGtOpHm57sc5gE2Q5QspKh0iTcK1s5Xp662IVFM=;
 b=TCk96ZrvyLxBaska0vmDd8zhDDHL32wBx+GpxMYTZh8GrXAN9fDOQBd1PEOty+f6T1
 vfDUvSX7ZHSIiW/dbUiu5BMA8AsYLDvPMAl3KLhhnRuE1TYR3JUUyzsXs9/FERrXgIQ0
 /h6Pefrk7ao03J/OG9iA2qBYvgOMpcFGgqXYgfHA21BfmH6nNBBSJsupWnyc35MF4cQt
 I8R7/t3gExWR92oy3Iq+GfwPHqZcUaB5OKtpOO6IHn8eA5fvKa05yhOpYh2QwK871uvQ
 /kYmRzNk5o1EnbkPGwBpLr5Rl4nVsGM4Zwf9kXtwvubhbFB1qChTuxErjCDDkSUp6RrX
 pe5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=SC8tyGtOpHm57sc5gE2Q5QspKh0iTcK1s5Xp662IVFM=;
 b=bLmIw/Dnp013bTJh5nqjQINRo7akkL9LicewuIwLUsYv+Jbri8tEVWP/88P+t505GH
 fcaG5L9nF+Jso/8/ee4Ltn38BzkjX7t6ZqDFUmCkb+igbnH9+O0Oibpolp26L26jeyhH
 deR+A8Q5heuPemDX7qoK8+mGuCJt/2WFx/nDL1i2G95nmeeDHYoQOCfLtvU8FcQXFOah
 CRFvz1099Ai9qEGXC4wTF7XljMx8idtMbETfsWFIOD3OGAMCntpl2fkKBHlJtTIC1s+8
 XLq19iIp7SMlcfxGTnXltiasHa30ZcSh8Y/Bm/j9aHHCu/m7JW1H/+Qw952g82q8kGaV
 yZ9w==
X-Gm-Message-State: APjAAAU0SznfqrwEHGf/gDlrk/MzNDXDe1QxB/dHiR4+l02f4LVqbWKy
 6L25Jb0Kqp42v1+UhTxa9lVNnYnp/9kmQCo2MY5feQ==
X-Google-Smtp-Source: APXvYqxhAKVjdI+Q5/kjVBzMiDyMQfHBUGw1YvkgVaqNl4hsrZJ80QL4YuEgtGr+aDxrHsLz9SA+9eBupzonnI/zSlM=
X-Received: by 2002:a05:6830:184:: with SMTP id
 q4mr5759307ota.232.1581435250516; 
 Tue, 11 Feb 2020 07:34:10 -0800 (PST)
MIME-Version: 1.0
References: <20200130112510.15154-1-eric.auger@redhat.com>
 <20200130112510.15154-5-eric.auger@redhat.com>
In-Reply-To: <20200130112510.15154-5-eric.auger@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 11 Feb 2020 15:33:59 +0000
Message-ID: <CAFEAcA9rsncts+s4tVn4tY4zaMHKeqyJj1O4J=Ufx33fb=Nrcg@mail.gmail.com>
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
> ---
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

"respectively"

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
> +       return supported;
> +}
> +
> +static void test_event_introspection(void)
> +{
> +       bool required_events;
> +
> +       if (!pmu.nb_implemented_counters) {
> +               report_skip("No event counter, skip ...");
> +               return;
> +       }
> +
> +       /* PMUv3 requires an implementation includes some common events */
> +       required_events = is_event_supported(0x0, true) /* SW_INCR */ &&
> +                         is_event_supported(0x11, true) /* CPU_CYCLES */ &&
> +                         (is_event_supported(0x8, true) /* INST_RETIRED */ ||
> +                          is_event_supported(0x1B, true) /* INST_PREC */);
> +
> +       if (pmu.version == 0x4) {

This condition will only test for v8.1-required events if the PMU
is exactly 8.1, so you lose coverage if the implementation happens
to support ARMv8.4-PMU. Hopefully you have already bailed out
for "ID_AA64DFR0_EL1.PMUVer == 0xf" which means "non-standard IMPDEF
PMU", in which case you can just check >= 0x4.

> +               /* ARMv8.1 PMU: STALL_FRONTEND and STALL_BACKEND are required */
> +               required_events = required_events &&
> +                                 is_event_supported(0x23, true) &&
> +                                 is_event_supported(0x24, true);
> +       }
> +
> +       report(required_events, "Check required events are implemented");
> +}
> +
>  #endif

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
