Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F72C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jul 2022 18:23:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FDC04C0A4;
	Tue, 19 Jul 2022 14:23:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iMQb78APIG6j; Tue, 19 Jul 2022 14:23:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 273734B177;
	Tue, 19 Jul 2022 14:23:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70CB34D2A9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 14:23:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F2TZL4iBHpd8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2022 14:23:28 -0400 (EDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
 [209.85.128.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D2E04D2A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 14:23:28 -0400 (EDT)
Received: by mail-wm1-f48.google.com with SMTP id c22so1286217wmr.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 11:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=NQRCSR2WG8er1FhdGOfttemdCe3XEsMa8dXWlWjyNw8=;
 b=Dev7X87CB5SrU1paX0aLZ1+Gcz3wYUyDgf/zZsSA+oLuRySUD7tRDvnFp9di/5e4vX
 sKqRbC371IPytuLFhWEqjWgmzGFGwA4yw6VGH1Nod0pyDgOLFE7F/P7FECTNwT5oiTV7
 Sd5cwBi0uhQ0KbLzBm1rbHDI3KKPw9HXCKIIu06+MxM0cE7KVMDeolPT4ZPjPHjE/DYD
 qB8WBoteOxI+Eg8BbfsSaxyg1aPAZjnHl88qURuXDtzwgXIyzzS3KQLWmtWIf5QaYa5W
 ZGlyfciWywxwsYPW1iA7dvcLLFDZZe2Q4CV9MTwIC73lzWaoxtGbou4nMfOV2cMUH6W/
 4S3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=NQRCSR2WG8er1FhdGOfttemdCe3XEsMa8dXWlWjyNw8=;
 b=pk3wxLnBDAIyb5pG+z26jWTdTUVZzUBKxE9vV2STIXrUFMRrTRZqT/msXrri/qkGwF
 g5RRXRGqg+PW6YtDQFlSIXyS6a90MBTtw/+rWBdIYZeSgdDul4IQy/UaB4RZL6MfTj9U
 bvAy2lnBKuwGXINJcwf/XQzJYczelEoMZQbcRoMzgL1EBwj43dYX3YwY2wQZusDLBji/
 e84Zn3wPkYcBFQOsA13k9U8/Gi3U4rqem7o2ld+S5jADnESLqDMvET2zDn7/vJndc65w
 vdvSQd73lF2vs48BGfkOK6oqzFvmo6oqlOG5lcvvkLhHxdKJBfW0M8g+lhio0fP/RMoK
 YVFA==
X-Gm-Message-State: AJIora+T79kJIPIzDlqygTG5Vh9vsFZbnqyOQO3hFa0U6z6feTgGEDg0
 s4sPP1YI9A7boppnJR6+H4257vNZFGnsB0pA7YRFYw==
X-Google-Smtp-Source: AGRyM1vSoSJtrZoPCR2Oh4eOeW/iTiccKQ3ClVq/gcCjafcraFgfslE49RLCAuKSpVUs2OkXwkAEMR3ln5pMXC3ZnlE=
X-Received: by 2002:a05:600c:3554:b0:3a3:1d70:9101 with SMTP id
 i20-20020a05600c355400b003a31d709101mr501679wmq.61.1658255006954; Tue, 19 Jul
 2022 11:23:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-9-kaleshsingh@google.com>
 <87cze252q7.wl-maz@kernel.org>
 <CAC_TJvcyb6xQhvuoSHpC6+LmeSAqbDk9Fnb=x-bB7UxxMek3EA@mail.gmail.com>
 <87ilntz8yh.wl-maz@kernel.org>
In-Reply-To: <87ilntz8yh.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Tue, 19 Jul 2022 11:23:16 -0700
Message-ID: <CAC_TJvc7_dKUhkHUHx8-bBC+-RPPasw1vTdjZwvVAGcUTQUnTg@mail.gmail.com>
Subject: Re: [PATCH v4 08/18] KVM: arm64: Add PROTECTED_NVHE_STACKTRACE Kconfig
To: Marc Zyngier <maz@kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 vincenzo.frascino@arm.com, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 "Cc: Android Kernel" <kernel-team@android.com>, Marco Elver <elver@google.com>,
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

On Tue, Jul 19, 2022 at 3:35 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 18 Jul 2022 18:03:30 +0100,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > On Sun, Jul 17, 2022 at 11:56 PM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > [- Drew and android-mm, as both addresses bounce]
> > >
> > > On Fri, 15 Jul 2022 07:10:17 +0100,
> > > Kalesh Singh <kaleshsingh@google.com> wrote:
> > > >
> > > > This can be used to disable stacktrace for the protected KVM
> > > > nVHE hypervisor, in order to save on the associated memory usage.
> > > >
> > > > This option is disabled by default, since protected KVM is not widely
> > > > used on platforms other than Android currently.
> > > >
> > > > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > > > ---
> > > >  arch/arm64/kvm/Kconfig | 15 +++++++++++++++
> > > >  1 file changed, 15 insertions(+)
> > > >
> > > > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > > > index 8a5fbbf084df..1edab6f8a3b8 100644
> > > > --- a/arch/arm64/kvm/Kconfig
> > > > +++ b/arch/arm64/kvm/Kconfig
> > > > @@ -46,6 +46,21 @@ menuconfig KVM
> > > >
> > > >         If unsure, say N.
> > > >
> > > > +config PROTECTED_NVHE_STACKTRACE
> > > > +     bool "Protected KVM hypervisor stacktraces"
> > > > +     depends on KVM
> > > > +     default n
> > > > +     help
> > > > +       Say Y here to enable pKVM hypervisor stacktraces on hyp_panic()
> > > > +
> > > > +       If you are not using protected nVHE (pKVM), say N.
> > > > +
> > > > +       If using protected nVHE mode, but cannot afford the associated
> > > > +       memory cost (less than 0.75 page per CPU) of pKVM stacktraces,
> > > > +       say N.
> > > > +
> > > > +       If unsure, say N.
> > > > +
> > >
> > > Can we make this depend on NVHE_EL2_DEBUG instead? I'd like to keep
> > > the disclosing of EL2 information in protected mode a strict debug
> > > feature.
> >
> > Hi Marc,
> >
> > An earlier version was similar to what you propose. The unwinding
> > depended on NVHE_EL2_DEBUG and all unwinding was done from EL1 with
> > host stage 2 being disabled. The reason the design was changed is
> > because Android expressed the need for pKVM hyp stacktraces in
> > production environments. [1]
>
> I think that's an Android-specific requirement that doesn't apply to
> upstream. If Android wants to enable this in production (and
> potentially leak details of the hypervisor address space), that's
> Android's business, and they can carry a patch for that.  Upstream
> shouldn't have to cater for such a thing.

Hi Marc,

For android it's important to be able to debug issues from the field.
But I agree no need to subject upstream to the same requirements. I'll
guard this with the NVHE_EL2_DEBUG config in the next version.

Thanks,
Kalesh

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
