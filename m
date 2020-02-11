Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFDBC352A3
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 16:27:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1CB462082F
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 16:27:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zgDrvETe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CB462082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E70C4AE9A;
	Tue, 11 Feb 2020 11:27:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ry3IbDy6zvbd; Tue, 11 Feb 2020 11:27:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DF554A4FF;
	Tue, 11 Feb 2020 11:27:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABDA94A4FF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 11:27:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aCEs2l+4kOJz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 11:27:27 -0500 (EST)
Received: from mail-oi1-f193.google.com (mail-oi1-f193.google.com
 [209.85.167.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B73ED4005D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 11:27:27 -0500 (EST)
Received: by mail-oi1-f193.google.com with SMTP id l136so13357239oig.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 08:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=yVHXsm2IYBbO0NyhRrtnF1/ntngEqGjIm7d0F0XQrvk=;
 b=zgDrvETeZ98ubY0HRNgI2g9jEA8jJoX/ED4+UpFR+atEhYr56+2n8NOg6kMLgv3Rnr
 4n5nnpYPG0cXSdVX49tRS/ufUSm1llmPiSvhrGu+uhyJokufZD0gPCfLV1rN0EjA2/F+
 7ZYg5KHJTUZQRZ0I2+WAKQ1bpvITGMsZmdTRxFkJ0ruKftoWC/OF/JRQjtdOooStvflb
 Ud8hY87RyjXX16e3GoZkH/Og2IFdB+Dd5gxqGkulEj9QE01t0D1HXpJXcvPl+fr/iFhO
 6oK208vi8WL/kuS8J5phalnb6fuMwPpENxZRLIVpeOnZ+hhClUWqo83ltw1HGhGlrqKC
 Yi5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=yVHXsm2IYBbO0NyhRrtnF1/ntngEqGjIm7d0F0XQrvk=;
 b=o/Fmu6y1pod1P4eRGtuA/bXZcx+WCnOzBkEZuA6RxX1SB3LDVjWCjB/BKNEmbezn8r
 e8DzjDKl7qo4c44Jzx31b8KGoO1Grek3Vnr5aT+7bSrgJY9D0VKkDK3n4fXg8ICXuajP
 vh/4kD+ENaATj+P1boHa1NN//Lr2LG9pHpoWdLEqw5rAEFbMrszY32aYYIyWt1oG8RQ4
 Xip870BKx256vvZPaVEGYBADmZBw2BmHBqqlRmKKJk/MCuNmRfttcfVidFqbDIYRjaYR
 tHKrRpTprOTOGeq3CS6E82F0qrS8BdRzh6FRwV3Q/E07G4lafmRgiQ3QskDazSJxDRg4
 VG4g==
X-Gm-Message-State: APjAAAXighhp3FdvLk7KxowdILDQ/OvNgk9cTaZ84zJlgyJiy3bZCvN4
 XjaRhN1Ky9TgDV6zS0d9tgLfSmS6gx7q+HUF0iiJVQ==
X-Google-Smtp-Source: APXvYqxxECM3fLexhrufeAZhTAqwZXYeTdHgsZFsgc6CnwRsYHiLW7ZwJQkutazw5wzjwg+heCPClWtjmUZZrlaigT8=
X-Received: by 2002:aca:3d7:: with SMTP id 206mr3432708oid.98.1581438447073;
 Tue, 11 Feb 2020 08:27:27 -0800 (PST)
MIME-Version: 1.0
References: <20200130112510.15154-1-eric.auger@redhat.com>
 <20200130112510.15154-6-eric.auger@redhat.com>
In-Reply-To: <20200130112510.15154-6-eric.auger@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 11 Feb 2020 16:27:16 +0000
Message-ID: <CAFEAcA9Yc9dKTCcP3fP93tQU62Q=2FYOoYGvUqfiOMY=pYV_RA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 5/9] arm: pmu: Basic event counter Tests
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

On Thu, 30 Jan 2020 at 11:26, Eric Auger <eric.auger@redhat.com> wrote:
>
> Adds the following tests:
> - event-counter-config: test event counter configuration
> - basic-event-count:
>   - programs counters #0 and #1 to count 2 required events
>   (resp. CPU_CYCLES and INST_RETIRED). Counter #0 is preset
>   to a value close enough to the 32b
>   overflow limit so that we check the overflow bit is set
>   after the execution of the asm loop.
> - mem-access: counts MEM_ACCESS event on counters #0 and #1
>   with and without 32-bit overflow.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

> +static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events)
> +{
> +       int i;
> +
> +       if (pmu.nb_implemented_counters < nb_events) {
> +               report_skip("Skip test as number of counters is too small (%d)",
> +                           pmu.nb_implemented_counters);
> +               return false;
> +       }
> +
> +       for (i = 0; i < nb_events; i++) {
> +               if (!is_event_supported(events[i], false)) {
> +                       report_skip("Skip test as event %d is not supported",
> +                                   events[i]);

Event numbers are given in hex in the Arm ARM and also
specified in hex in your test source code. I think it
would be more helpful if the message here used "0x%x", to
save the reader having to do the decimal-to-hex conversion
to find the event in the spec or the test case.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
