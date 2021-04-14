Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF52C43461
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 19:10:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AB34A61220
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 19:10:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB34A61220
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 096484B42F;
	Wed, 14 Apr 2021 15:10:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MubKdHMoOvyX; Wed, 14 Apr 2021 15:10:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D452C4B57B;
	Wed, 14 Apr 2021 15:10:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 896544B565
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 15:10:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tqzu8m8eIgyr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Apr 2021 15:10:02 -0400 (EDT)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com
 [209.85.217.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 606CB4B561
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 15:10:02 -0400 (EDT)
Received: by mail-vs1-f51.google.com with SMTP id l11so2392967vsr.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 12:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Z3hnQcI7xgmsUuxItoue27NrG4aaS9+tEraOADPkosg=;
 b=rJvYS+J2i2EDB7+H0ar79/9KmvFBlEX/IteDQrq+hZvhQqQReOy1b+AADr0cQalQxY
 PxnhJnEF2atVxze7tpA6bACUW9pw9VVOCHRRhz5BJb1yW+aY21NQry/q3kTxxwBWOzms
 y5vFPGI4/LGO9wgquxgyA27xGNGjlIIsn+cBDwPDh1hcXIYAfq5qWtwTT+8KqKflfFR/
 CLLqjSXNtF7wdbN6jEpBsSy7ahEsP9/U7049YzltFMONQlC+zFXcsIU6KTKDs+G00RiT
 wIeQzKiJjw0OQUptaVIE3tuO2vK8+DVBLQqoyO1FWW50Y1Gxna9hoMsvIl0t9Lao3JZF
 7SQA==
X-Gm-Message-State: AOAM53015/2X5gQVDMgNmS/xw5uZU1PmiAm9TIpVEjxZOe4ojjTLjuEC
 Z1qMg3JVzf3urGS/whyddinR3PC5V4hAClSUjSg=
X-Google-Smtp-Source: ABdhPJxJbGWB0l+pI+e+zsAVHVBLwrtdJbfPrWC2SKJve8ijlw7H6jw/dP0+aFP/QglhH1BBHAHmIOlyMsd9AxB04yU=
X-Received: by 2002:a67:80c4:: with SMTP id b187mr29948111vsd.42.1618427401975; 
 Wed, 14 Apr 2021 12:10:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210414134409.1266357-1-maz@kernel.org>
 <20210414134409.1266357-5-maz@kernel.org>
In-Reply-To: <20210414134409.1266357-5-maz@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 14 Apr 2021 21:09:50 +0200
Message-ID: <CAMuHMdVfwRv_66mMz79rvszdgXnovrS_FZzPRK9fqOMH5Npu5A@mail.gmail.com>
Subject: Re: [PATCH 4/5] sh: Get rid of oprofile leftovers
To: Marc Zyngier <maz@kernel.org>
Cc: linux-s390 <linux-s390@vger.kernel.org>, Rich Felker <dalias@libc.org>,
 Yoshinori Sato <ysato@users.sourceforge.jp>, KVM list <kvm@vger.kernel.org>,
 Linux-sh list <linux-sh@vger.kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Viresh Kumar <viresh.kumar@linaro.org>,
 Heiko Carstens <hca@linux.ibm.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, nathan@kernel.org,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Android Kernel Team <kernel-team@android.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Wed, Apr 14, 2021 at 3:53 PM Marc Zyngier <maz@kernel.org> wrote:
> perf_pmu_name() and perf_num_counters() are unused. Drop them.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
