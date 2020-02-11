Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C16BC352A3
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 16:25:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B8DF320708
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 16:25:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lxQlVmvV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8DF320708
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 203E94A97D;
	Tue, 11 Feb 2020 11:25:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pE+RoTkHSs0Z; Tue, 11 Feb 2020 11:25:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A46D4AE8E;
	Tue, 11 Feb 2020 11:25:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF0AF4A650
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 11:25:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hLSbEuBoWwXy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 11:25:04 -0500 (EST)
Received: from mail-oi1-f195.google.com (mail-oi1-f195.google.com
 [209.85.167.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D374C4A578
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 11:25:04 -0500 (EST)
Received: by mail-oi1-f195.google.com with SMTP id c16so13358340oic.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 08:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=YTN1aAmP6lc4kQg/pEPrAXI0XAGYx4yNSmOlFp4FG4w=;
 b=lxQlVmvVZcKdKIQTir0FJwH3pOsXoSn5/Q4tMLOxZHb6vh+J078303Z8U7gab4r+M/
 u0nOHQOoM55bwBkguDId7rDWaUhv466UTLUufW9bMy1B2UPv0baZR4jth9eVclXQQlwg
 ns/Bj2RA4Mc3yHj7MRF0DLHPNIGqXe1YZu0Bbbq1edR2+mU0MmkhgL1aOcldQsKwV8ed
 sESHd3hfq2IdjbPTIszOs4y0I8vABsJnNUzB0AebGS13LE3Z2FsIDc0KX5fJA00RYefp
 WIzcZYtT0DlJm4TAufNiRZ8Zw0u5RNE3PAR11A/fvqPnpk/HJkWZe4i1Wrf64W3IomhD
 S4Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=YTN1aAmP6lc4kQg/pEPrAXI0XAGYx4yNSmOlFp4FG4w=;
 b=YPZPs+IAiy57EXetGn4TGLVmA8u8wRX2LjEje4pw8NebipTDGHGD74ivLrN/VOj9DO
 kPagoUxVFQwf+BGYdrWoJ6sPTZO3qef/uuT0hRpa7AXwu+CO7DkSAZELt4ZXacdDiZtX
 rNJ9IBexMeQACRE5QrBqDn9VGzVJbDyzpEDpIX9m9htJ84HWt4oBH+ZGo8U+fsQtlfhu
 tkvhXIrLuBiM1f5+1bA9PHlnTpjVUO2IY/W7vmmSwCszgXkZAIJvLUzpUeiild4OHHUC
 dF6nPzojG1NVcCSv6/EIlOJumuHvQsPSB+RJZqJePs1nC4wSh+sHfJEdUwUB98snRMil
 5Q2Q==
X-Gm-Message-State: APjAAAXqbOuWcFKmqZn8n5RVxuM7QPlXxqTv0h6IC+LPVfkDvS3V3c+3
 a4BfC8evWKmpmhgQ4fVfzibfIFlGPwkwkRTsytooCQ==
X-Google-Smtp-Source: APXvYqzv/UP3M8yZMmNDzyJRIaKXistg0kt67KZIdKfe9JVAoy6ZnLkvmh7xAXkvGMtm+bCKNIS/Rzvw8t5EaSXvOXI=
X-Received: by 2002:aca:3d7:: with SMTP id 206mr3426415oid.98.1581438304306;
 Tue, 11 Feb 2020 08:25:04 -0800 (PST)
MIME-Version: 1.0
References: <20200130112510.15154-1-eric.auger@redhat.com>
 <20200130112510.15154-7-eric.auger@redhat.com>
In-Reply-To: <20200130112510.15154-7-eric.auger@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 11 Feb 2020 16:24:52 +0000
Message-ID: <CAFEAcA_jfZKjey8komTt97Mu-oFjWyFNG2cY4-o8yFAP1oGiug@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 6/9] arm: pmu: Test chained counter
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
> Add 2 tests exercising chained counters. The first one uses
> CPU_CYCLES and the second one uses SW_INCR.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> +static void test_chained_sw_incr(void)
> +{
> +       uint32_t events[] = { 0x0 /* SW_INCR */, 0x0 /* SW_INCR */};

Cut-n-paste error? This test relies on the CHAIN event but it
isn't present in this list of events to pass to satisfy_prerequisites(),
so I suspect the second element should be "0x1e /* CHAIN */" ?

(This makes the test fail on QEMU TCG, because we don't implement
CHAIN.)

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
