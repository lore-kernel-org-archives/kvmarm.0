Return-Path: <SRS0=AgFV=KV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 589BBC4708A
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 08:18:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B941E6143E
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 08:18:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B941E6143E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41383407F1;
	Wed, 26 May 2021 04:18:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G2wq2gRVy+VM; Wed, 26 May 2021 04:18:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 068A14A49C;
	Wed, 26 May 2021 04:18:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B766D4086A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 04:18:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z4S23DXHemsn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 May 2021 04:18:39 -0400 (EDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com
 [209.85.217.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC674407F1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 04:18:39 -0400 (EDT)
Received: by mail-vs1-f54.google.com with SMTP id x13so286566vsh.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 01:18:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=cwJrjJPn4XdJtdaNHc/uwJ41Erytueup9SA7gWbLwLc=;
 b=EELNn7CvM98MfS2xXwWG2eHwN/CS4ViAfyqyHGt0SMz/IfgQPNJmGzy2vnZM7DG30L
 Vmuq7GdJPxAzjxZ9kVVTGR6TGslrRaBf7Wz1a6FNGvYyibc9xMrZVoaKMjI2YOgVdwbG
 X91TqtYWziqnZpQ+d4/Slyj0onm/pkUNj2DoIZsz2A9/DBSeUE4TQR0pJSocDxAria+/
 jiVzdscbmhO1DcE/D1qvrD556IMYt+FJktTtZ5DEHzsTX+Blq1IdbdOUfnbb0HqW+vtx
 GhlNAILfl1zZyju9GnJxA2NYcvrZg3AWA9aHATFbfD/QHBavYTL89er8o5l/qdx1T/YV
 K82g==
X-Gm-Message-State: AOAM530BsTQD2TzIv8U/FvRU5PtrYk9JAvdjPh1fxB2ZJWHP9Gvnl5MZ
 oFnUWSK9Ck6o2SWp3D1hbNE6FDGHi7UizrRgh/o=
X-Google-Smtp-Source: ABdhPJyBP43fy0z/xLr24CBnaFxqMibw4+PtPqA/CPHen7oIzefuWsMGVqm5mGd8u6JPJ0dQP9MmoI2MjgM94cpGp3U=
X-Received: by 2002:a67:3c2:: with SMTP id 185mr30138437vsd.42.1622017119229; 
 Wed, 26 May 2021 01:18:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210330145430.996981-1-maz@kernel.org>
 <20210330145430.996981-8-maz@kernel.org>
 <CAMuHMdWd5261ti-zKsroFLvWs0abaWa7G4DKefgPwFb3rEjnNw@mail.gmail.com>
 <6c522f8116f54fa6f23a2d217d966c5a@kernel.org>
 <CAMuHMdWzBqLVOVn_z8S2H-x-kL+DfOsM5mDb_D8OKsyRJtKpdA@mail.gmail.com>
 <8735u9x6sb.wl-maz@kernel.org>
In-Reply-To: <8735u9x6sb.wl-maz@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 26 May 2021 10:18:27 +0200
Message-ID: <CAMuHMdUBwcB-v0ugCPB3D6dbttiSbqQeHgNrr+r331ntRrfiAw@mail.gmail.com>
Subject: Re: [PATCH v19 7/7] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
To: Marc Zyngier <maz@kernel.org>
Cc: KVM list <kvm@vger.kernel.org>, seanjc@google.com,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, justin.he@arm.com,
 Steven Price <steven.price@arm.com>,
 Android Kernel Team <kernel-team@android.com>,
 Andre Przywara <Andre.Przywara@arm.com>,
 Richard Cochran <richardcochran@gmail.com>, Yangbo Lu <yangbo.lu@nxp.com>,
 John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 netdev <netdev@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Sudeep Holla <sudeep.holla@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
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

Hi Marc,

On Wed, May 26, 2021 at 10:01 AM Marc Zyngier <maz@kernel.org> wrote:
> On Wed, 26 May 2021 08:52:42 +0100,
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Tue, May 11, 2021 at 11:13 AM Marc Zyngier <maz@kernel.org> wrote:
> > > On 2021-05-11 10:07, Geert Uytterhoeven wrote:
> > > > On Tue, Mar 30, 2021 at 4:56 PM Marc Zyngier <maz@kernel.org> wrote:
> > > >> From: Jianyong Wu <jianyong.wu@arm.com>
> > > >
> > > >> --- a/drivers/ptp/Kconfig
> > > >> +++ b/drivers/ptp/Kconfig
> > > >> @@ -108,7 +108,7 @@ config PTP_1588_CLOCK_PCH
> > > >>  config PTP_1588_CLOCK_KVM
> > > >>         tristate "KVM virtual PTP clock"
> > > >>         depends on PTP_1588_CLOCK
> > > >> -       depends on KVM_GUEST && X86
> > > >> +       depends on (KVM_GUEST && X86) || (HAVE_ARM_SMCCC_DISCOVERY &&
> > > >> ARM_ARCH_TIMER)
> > > >
> > > > Why does this not depend on KVM_GUEST on ARM?
> > > > I.e. shouldn't the dependency be:
> > > >
> > > >     KVM_GUEST && (X86 || (HAVE_ARM_SMCCC_DISCOVERY && ARM_ARCH_TIMER))
> > > >
> > > > ?
> > >
> > > arm/arm64 do not select KVM_GUEST. Any kernel can be used for a guest,
> > > and KVM/arm64 doesn't know about this configuration symbol.
> >
> > OK.
> >
> > Does PTP_1588_CLOCK_KVM need to default to yes?
> > Perhaps only on X86, to maintain the status quo?
>
> I think I don't really understand the problem you are trying to
> solve. Is it that 'make oldconfig' now asks you about this new driver?
> Why is that an issue?

My first "problem" was that it asked about this new driver on
arm/arm64, while I assumed there were some missing dependencies
(configuring a kernel should not ask useless questions).  That turned
out to be a wrong assumption, so there is no such problem here.

The second problem is "default y": code that is not critical should
not be enabled by default.  Hence my last question.

Thanks!

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
