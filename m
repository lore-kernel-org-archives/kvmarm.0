Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D406C43334
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 16:54:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D7E24D47B;
	Mon, 18 Jul 2022 12:54:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Nqsws980AuHX; Mon, 18 Jul 2022 12:53:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98BBD4D45B;
	Mon, 18 Jul 2022 12:53:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 165474D45B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 12:53:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZyZ9AIZSoewV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 12:53:57 -0400 (EDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com
 [209.85.128.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F3F1D4D458
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 12:53:56 -0400 (EDT)
Received: by mail-wm1-f51.google.com with SMTP id
 p26-20020a1c545a000000b003a2fb7c1274so5654403wmi.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 09:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=PFgEFsfl8rKJs7ra2dHHZoS/sWYcHlxBizMiDuSMBHs=;
 b=mKTwFX9DcjFSbsWZCVza9QbOzZMgaViFHpyhezP8skfw9OhFHOtxe7Coa9eHKiupWf
 GVN5yHFqjF5RvR4cUnCT5TeYNNGH16qQTQo1324kdB32i+xK1jhd92eVU0UxcAZ1VJl+
 YCFlHbbXFyJy8vOlddVjkGKOTQ/m/QSiyBzHwmTC5yTtRUwcf7Uvc6jPR9g4q/bJhb7J
 0l7QCOPJacqQKytb6294d+jLYTpGkqKCr9Rhiqu6KsMCbZfa8rkADp06Jt0BTjfPbpq6
 bKh2lRVqkB/XiLnFVspPNZtdu2+PyjKIBF3giMevCtYzSqa8goeqyMShrFPusWEqeYPO
 hhSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=PFgEFsfl8rKJs7ra2dHHZoS/sWYcHlxBizMiDuSMBHs=;
 b=Gfskyf9AWsYkbqTfWTzjDxV3rTGT7B5+vMiwmdpZggJziLY94L+H3b0ARbkxFtkT56
 JVcGHzFj8kaMDUMLMWHC9h2+kGgu5PJGVs4P+i1iHraEifviHH36+CoGC3arf7glF95p
 yjwTQgkX4W1okrXI33icDmGHldtAA9Odv/Vi1z+8mzH7qavbKk3dGEXtNyMZ7PBw248x
 8Szukjo6Gl/GmH90eRiej3ua41rKzbPtyevzWfPwyxnJxXZGm/tUJhTXh4OgtyO+7jAQ
 CgQGbiqWqgU2qVXfd52qhPxLeHhcgUXbv3KxohV3sPADaw3tAQUUGjueOYAvuc3tbDf/
 +JCQ==
X-Gm-Message-State: AJIora+y4aOE36Vq7waYZYZRc056q5BzTNo+cLTP1/ERZcLExHDro8uZ
 DPiNa+6RfMtLKRYjF+8AWYh1bLAFAo+hOd6W6E08MQ==
X-Google-Smtp-Source: AGRyM1vVZb4Aon6v5ILgG/Iyd1Sfx4G+07cbbi2sRUeRYV96oOPEBR88UX4fRnJ/EZaOzI28tw0KmqafYPKa3sfBzio=
X-Received: by 2002:a05:600c:a146:b0:3a3:1e79:4446 with SMTP id
 ib6-20020a05600ca14600b003a31e794446mr3231430wmb.158.1658163235828; Mon, 18
 Jul 2022 09:53:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-7-kaleshsingh@google.com>
 <87k08c3vtw.wl-maz@kernel.org>
In-Reply-To: <87k08c3vtw.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 18 Jul 2022 09:53:44 -0700
Message-ID: <CAC_TJvcxPCWXq_dViN09c5eyd0N_TdfOmOgExaiO+ugfeTuN6g@mail.gmail.com>
Subject: Re: [PATCH v4 06/18] arm64: stacktrace: Add description of
 stacktrace/common.h
To: Marc Zyngier <maz@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marco Elver <elver@google.com>,
 vincenzo.frascino@arm.com, Will Deacon <will@kernel.org>,
 android-mm@google.com, "Russell King \(Oracle\)" <linux@armlinux.org.uk>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 "Cc: Android Kernel" <kernel-team@android.com>,
 Andrew Jones <drjones@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
 Mark Brown <broonie@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, andreyknvl@gmail.com,
 LKML <linux-kernel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>
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

On Sun, Jul 17, 2022 at 2:58 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 15 Jul 2022 07:10:15 +0100,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > Add brief description on how to use stacktrace/common.h to implement
> > a stack unwinder.
> >
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >  arch/arm64/include/asm/stacktrace/common.h | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
> > index f86efe71479d..b362086f4c70 100644
> > --- a/arch/arm64/include/asm/stacktrace/common.h
> > +++ b/arch/arm64/include/asm/stacktrace/common.h
> > @@ -2,6 +2,14 @@
> >  /*
> >   * Common arm64 stack unwinder code.
> >   *
> > + * To implement a new arm64 stack unwinder:
> > + *     1) Include this header
> > + *
> > + *     2) Provide implementations for the following functions:
> > + *            - on_overflow_stack()
> > + *            - on_accessible_stack()
> > + *            - unwind_next()
>
> A short description of what these helpers are supposed to do would
> also be helpful.

Thanks Fuad, Marc. I'll add descriptions in the next version.

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
