Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A37C04A68
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 15:30:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A43B4C687;
	Tue, 26 Jul 2022 11:30:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 74q1W2twon0F; Tue, 26 Jul 2022 11:30:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50B0C4C691;
	Tue, 26 Jul 2022 11:30:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7063F4C680
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 11:30:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rh56ySj+LP7c for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 11:30:25 -0400 (EDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 34BE24C63B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 11:30:25 -0400 (EDT)
Received: by mail-wr1-f47.google.com with SMTP id q18so10249403wrx.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 08:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=h0wgweyi5NGRv+HE2MTaBWrplm2EHlyiIAxkkqIQSs0=;
 b=X47KxyizSGoS2M4kT8l3dojbBsx8AlSGEk/cpikgOxJynDa/Y5++hdo0KEAxdqBZMw
 SyXwpOijT0+YR5+VNyj5Er+GLUFDxf3oOutcVSwsJudhHX+45ov34VH+/yEvyjbvE8OE
 J/EFnpOl9nJGfEPyWu+AOV5EfDpSl/ROMPUnOAE39kCW9HcAIfrNVEJPbYmzGJv6u3fo
 shx9bLD+thS2W6D2iiGNBW/5/NgufOiCpSr/QOMU5h3KjQtCEiPeMliB/NdB3fhWZCYA
 Kw2/wCpm0xIephjsdP0ShBZ2PdbKM3zzjT1FtA6vcdwADBxizYVd8YY3CBuSJYnZk34O
 MEZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=h0wgweyi5NGRv+HE2MTaBWrplm2EHlyiIAxkkqIQSs0=;
 b=Fo5O0ZsNtVvV+paaWsf2YnepVWAgEjYXTYiJzlA9sza39zPtUsyDu0t7UvHpYn7o49
 wk9nU8mgbobU9O9cFYvYYXDv2EX4MLKyriGlJv9k1IW1RvQA5cFNOUaMw8I//c0yM2wl
 WfKYlxe1dUY5I0QEt5SUcjJf2/ZMmKIbFY0cNeq2b84Xk6k2RINf9IpIatwtqkkAq1No
 tQCV1Ly2aKpg9gME1yVLx3K3GlzBchRalwYSzeJN8DCHjXJAywSC2nYlMJXNeqenNWCV
 p/7gNk8NybyylhM1LSmvXVVPg65Yxh8sah0J9fbVgUFMHGPuP2xas4UtlaKNpRhLUDzd
 +LSw==
X-Gm-Message-State: AJIora+zXkCLQ+3x/0symUgvgPdhoD3mXr5ZPQxmOdx5b5loOL02wN4o
 DPl3eR3sf61krf76RJ71R6U5pOEbOWpG/49+VUXNXw==
X-Google-Smtp-Source: AGRyM1uqZdO2rcSVp/+TPJN7QEyIEDvp460BhjWSnS8sTm4VBrNNvBNfn82pg1xgJHAV0aUyNeV626vcuz4oZvZTUiI=
X-Received: by 2002:a05:6000:508:b0:21d:4105:caf9 with SMTP id
 a8-20020a056000050800b0021d4105caf9mr11603813wrf.699.1658849423820; Tue, 26
 Jul 2022 08:30:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220726073750.3219117-1-kaleshsingh@google.com>
 <20220726073750.3219117-5-kaleshsingh@google.com>
 <Yt/7WzuBzc1m/6JU@sirena.org.uk>
In-Reply-To: <Yt/7WzuBzc1m/6JU@sirena.org.uk>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Tue, 26 Jul 2022 08:30:12 -0700
Message-ID: <CAC_TJveY_pk6AaMuRASy8UmhHvk2Du6A9VbuwrJ50Sw1RAPBMg@mail.gmail.com>
Subject: Re: [PATCH v6 04/17] arm64: stacktrace: Handle frame pointer from
 different address spaces
To: Mark Brown <broonie@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 vincenzo.frascino@arm.com, Will Deacon <will@kernel.org>,
 android-mm@google.com, Marc Zyngier <maz@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 "Cc: Android Kernel" <kernel-team@android.com>, Marco Elver <elver@google.com>,
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

On Tue, Jul 26, 2022 at 7:34 AM Mark Brown <broonie@kernel.org> wrote:
>
> On Tue, Jul 26, 2022 at 12:37:37AM -0700, Kalesh Singh wrote:
> > The unwinder code is made reusable so that it can be used to
> > unwind various types of stacks. One usecase is unwinding the
> > nVHE hyp stack from the host (EL1) in non-protected mode. This
> > means that the unwinder must be able to translate HYP stack
> > addresses to kernel addresses.
> >
> > Add a callback (stack_trace_translate_fp_fn) to allow specifying
> > the translation function.
>
> Reviewed-by: Mark Brown <broonie@kernel.org>
>
> with or without one very minor thing:
>
> >  static inline int unwind_next_common(struct unwind_state *state,
> > -                                  struct stack_info *info)
> > +                                  struct stack_info *info,
> > +                                  stack_trace_translate_fp_fn translate_fp)
> >  {
> > +     unsigned long fp = state->fp, kern_fp = fp;
>
> As a coding style nit I don't love having multiple assignments on a
> single line especially as part of declarations.

Hi Mark,

Thanks for the reviews. I'll update this if a respin is needed.

--Kalesh
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
