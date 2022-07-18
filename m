Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC802C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 17:03:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65BA74D34B;
	Mon, 18 Jul 2022 13:03:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WE7m8tITIOIZ; Mon, 18 Jul 2022 13:03:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5500B4D226;
	Mon, 18 Jul 2022 13:03:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80B934D1A9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 13:03:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2swJv9UwR343 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 13:03:42 -0400 (EDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
 [209.85.221.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 271374C215
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 13:03:42 -0400 (EDT)
Received: by mail-wr1-f46.google.com with SMTP id e15so12733913wro.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 10:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ptpv3NcLhPJ5VpMsedGx3eHo8WBrGWeiJ8cSXNWgb/4=;
 b=Y27goTNXBKsu4vXtC3nlibmjnNVCjFjxgrfZOUL3Ap/c/Z9hKcBh9MXJapW2dE/VGL
 zGB+Km7EbYr2JLZ/Umr+CyDsylc+Ozgpz8HXgQVktSWZBG+ePuMVsRSambf7XYAkLr2q
 G8uYaCvUMOUFNw3/CxkfVF9vhXvy3F5YH6Pc72LoEJY/ARsAHUDLO5VUbZIHkc7q/GPe
 NHEa9wQ91BDV7GXM8x6IJoWwH7AJMFgu3X5WLZfHe54yqwpjdzLS43rClGvkl65FIzUe
 ObeGb/YOiGjljF3iTaqMM9VkqWsl2svmq8XWIhAiIZkrrh/cA87qbXoooknYGFCg3QD1
 28oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ptpv3NcLhPJ5VpMsedGx3eHo8WBrGWeiJ8cSXNWgb/4=;
 b=MRuA0k1bL87uFLS+I1h4i5lDFUb1Ior+NCFa/X+SVydoHOVjoBMmn1xAwpKF1g5Bov
 L4+iJuH9+E2M91h4cGwmvCVHWZxvrQCGSs2pRU7AgGZLApWACh96kWWXt2EzFx4JyIV6
 TzCg40nVvgqQknNcjy9bS2t6sIL+hvancX8+rJz7DwkNwaxBidLiFSu/fi3JRjnPL5QB
 J3vI8T8Yx4m7KVSQM1Y9kfpXlZCvtFdnRR4H5eb50AHV3NkT9zV9ARxA+ReXLDmEoCpV
 +VCu+CaerQTW9YVhbASUFVp2mvYs+hTnrj15jk7TGm/ipuv5GYXYiAqFrrOF6NWC13yW
 c/xQ==
X-Gm-Message-State: AJIora+q6hwgmrZm+wDcWKDonj3YShHXwwcvccOvecWtMw7aECpnvSxb
 sjZ79tw0AXqwEuLBZ4V8EC+lTfm8MIbUSNgCKMnYcA==
X-Google-Smtp-Source: AGRyM1tO6ZIAXpTKNUvMA5ZeA43y9QffvRUOq+TtCJgH/I6iDOQtfKW5JykSasnWKD0SGHfcPw9GImSjVDEvNipho2s=
X-Received: by 2002:a05:6000:508:b0:21d:4105:caf9 with SMTP id
 a8-20020a056000050800b0021d4105caf9mr24289854wrf.699.1658163820965; Mon, 18
 Jul 2022 10:03:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-9-kaleshsingh@google.com>
 <87cze252q7.wl-maz@kernel.org>
In-Reply-To: <87cze252q7.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 18 Jul 2022 10:03:30 -0700
Message-ID: <CAC_TJvcyb6xQhvuoSHpC6+LmeSAqbDk9Fnb=x-bB7UxxMek3EA@mail.gmail.com>
Subject: Re: [PATCH v4 08/18] KVM: arm64: Add PROTECTED_NVHE_STACKTRACE Kconfig
To: Marc Zyngier <maz@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 vincenzo.frascino@arm.com, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 andreyknvl@gmail.com, "Cc: Android Kernel" <kernel-team@android.com>,
 Marco Elver <elver@google.com>, Mark Brown <broonie@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, russell.king@oracle.com,
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

On Sun, Jul 17, 2022 at 11:56 PM Marc Zyngier <maz@kernel.org> wrote:
>
> [- Drew and android-mm, as both addresses bounce]
>
> On Fri, 15 Jul 2022 07:10:17 +0100,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > This can be used to disable stacktrace for the protected KVM
> > nVHE hypervisor, in order to save on the associated memory usage.
> >
> > This option is disabled by default, since protected KVM is not widely
> > used on platforms other than Android currently.
> >
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >  arch/arm64/kvm/Kconfig | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index 8a5fbbf084df..1edab6f8a3b8 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -46,6 +46,21 @@ menuconfig KVM
> >
> >         If unsure, say N.
> >
> > +config PROTECTED_NVHE_STACKTRACE
> > +     bool "Protected KVM hypervisor stacktraces"
> > +     depends on KVM
> > +     default n
> > +     help
> > +       Say Y here to enable pKVM hypervisor stacktraces on hyp_panic()
> > +
> > +       If you are not using protected nVHE (pKVM), say N.
> > +
> > +       If using protected nVHE mode, but cannot afford the associated
> > +       memory cost (less than 0.75 page per CPU) of pKVM stacktraces,
> > +       say N.
> > +
> > +       If unsure, say N.
> > +
>
> Can we make this depend on NVHE_EL2_DEBUG instead? I'd like to keep
> the disclosing of EL2 information in protected mode a strict debug
> feature.

Hi Marc,

An earlier version was similar to what you propose. The unwinding
depended on NVHE_EL2_DEBUG and all unwinding was done from EL1 with
host stage 2 being disabled. The reason the design was changed is
because Android expressed the need for pKVM hyp stacktraces in
production environments. [1]

[1] https://lore.kernel.org/all/CAC_TJveNRaDFcQGo9-eqKa3=1DnuVDs4U+ye795VcJ1ozVkMyg@mail.gmail.com/

--Kalesh

>
> >  config NVHE_EL2_DEBUG
> >       bool "Debug mode for non-VHE EL2 object"
> >       depends on KVM
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
