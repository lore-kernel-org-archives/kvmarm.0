Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA08C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 17:38:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 291284B190;
	Tue, 19 Apr 2022 13:38:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3Qdfe1Q2VnEF; Tue, 19 Apr 2022 13:38:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0684D4B1FA;
	Tue, 19 Apr 2022 13:38:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 163E94B1AF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 13:38:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GgJnft53ObEd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 13:38:09 -0400 (EDT)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0606F4B190
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 13:38:08 -0400 (EDT)
Received: by mail-wr1-f49.google.com with SMTP id q3so22801138wrj.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 10:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=4Hcnu+Y1xvTQT/d8TtH/DkfZU528Zec6EC6l/WHUGtw=;
 b=CIQjN/Q+4uhjvLGUdKIpDCetpFRAAL1b0jKxHI6pNWCWGj6uodyebfvqMYTJH9JHXZ
 REqxLvl8ztnJYis9WD5FWWeEhOcyDAQQLn1SHMd8KmuTQDoR0imYRPzXRHhWqrmbNH1S
 QyrafESTkKiLUc57QNe1bvNaiDLi5rMGQl1aBjzi1Lqq9xiIXyRoInIF9/N3XLQGtL6+
 3DAfFDiRIZYwqyq8olQkz3ucGHnwIV7yAF8ne+XvwiDO7pTHxn9NC2KIea7xtpNuUzhj
 BPOnr2fxwdBodOYuwTPaW8gRvxdvu9PA2Pn5ijwjgwpAKqtIus+L19F9dim0h2U+bXsp
 sWSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=4Hcnu+Y1xvTQT/d8TtH/DkfZU528Zec6EC6l/WHUGtw=;
 b=6nViZvu8Ogas9bkt2rNfz5f5Mr29dMpFeR0Qr40MYs9OL2cuU3gcCrc+GKqzwxFU6M
 +budVIMhThGiEaRLiBf08Wp5H2m7vKTSP4FjPUSdW6RgP5FxSnl3Yt6hAWh8Rui6GGgh
 7856mUkchHHrgbHIjqc2XLROdWWzDsm6tErkA6RQlqphGGEehlacaz4c2y1ms6MQrW6s
 0saFIjhoieokQnMC3iLQqwwiL3FQAThZyaezhtZ4WibGRltOno8KsC8JOUSNiJwRx67k
 E080+5TrTJCPPro+Rlnf1E+gp9wIQyerrHcrOGdyrIc53+I0nzzdDRjErayky3bd+M3W
 cPiQ==
X-Gm-Message-State: AOAM531SezbvHWk4H07tfCSpaYbke3VIfqD/a1BrvQ9gB4PqYKqZZ17f
 k6H4A/5jf2xTaPAXVVSkEMo+VdNCArNZsFlD2v48Pg==
X-Google-Smtp-Source: ABdhPJzpHnn5Va+Zva11H7oHeOnzsrgG/lcYPxvwzn3M3FVNvkOV1Y1fDhhCyXgdlAWLhZa4n6At69/woFeeGpnw7nU=
X-Received: by 2002:a5d:42cd:0:b0:207:af3f:79c9 with SMTP id
 t13-20020a5d42cd000000b00207af3f79c9mr12547729wrr.577.1650389887738; Tue, 19
 Apr 2022 10:38:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220314200148.2695206-1-kaleshsingh@google.com>
 <20220314200148.2695206-8-kaleshsingh@google.com>
 <CA+EHjTwQRUCjvcMHNe1f0kPBdU=vS+f2+e_eefhnJDR4s73cQA@mail.gmail.com>
 <CAC_TJveNRaDFcQGo9-eqKa3=1DnuVDs4U+ye795VcJ1ozVkMyg@mail.gmail.com>
 <YlbXHg64HK2d3dgm@FVFF77S0Q05N>
In-Reply-To: <YlbXHg64HK2d3dgm@FVFF77S0Q05N>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Tue, 19 Apr 2022 10:37:56 -0700
Message-ID: <CAC_TJveJYFkHPQLYdL8SCEAwMPgwpF_-ctMqKJ9w=eDa_M0u5w@mail.gmail.com>
Subject: Re: [PATCH v6 7/8] KVM: arm64: Unwind and dump nVHE HYP stacktrace
To: Mark Rutland <mark.rutland@arm.com>
Cc: "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Cc: Android Kernel" <kernel-team@android.com>,
 Andrew Walbran <qwandor@google.com>, Will Deacon <will@kernel.org>,
 Peter Collingbourne <pcc@google.com>, Marc Zyngier <maz@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, Stephen Boyd <swboyd@chromium.org>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Suren Baghdasaryan <surenb@google.com>
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

On Wed, Apr 13, 2022 at 6:59 AM Mark Rutland <mark.rutland@arm.com> wrote:
>
> Hi Kalesh,
>
> Sorry for the radiosilence.
>
> I see that in v7 you've dropped the stacktrace bits for now; I'm just
> commenting here fot future reference.
>
> On Thu, Mar 31, 2022 at 12:22:05PM -0700, Kalesh Singh wrote:
> > Hi everyone,
> >
> > There has been expressed interest in having hypervisor stack unwinding
> > in production Android builds.
> >
> > The current design targets NVHE_EL2_DEBUG enabled builds and is not
> > suitable for production environments, since this config disables host
> > stage-2 protection on hyp_panic() which breaks security guarantees.
> > The benefit of this approach is that the stack unwinding can happen at
> > EL1 and allows us to reuse most of the unwinding logic from the host
> > kernel unwinder.
> >
> > Proposal for how this can be done without disabling host stage-2 protection:
> >   - The host allocates a "panic_info" page and shares it with the hypervisor.
> >   - On hyp_panic(), the hypervisor can unwind and dump its stack
> > addresses to the shared page.
> >   - The host can read out this information and symbolize these addresses.
> >
> > This would allow for getting hyp stack traces in production while
> > preserving the security model. The downside being that the core
> > unwinding logic would be duplicated at EL2.
> >
> > Are there any objections to making this change?
>
> I'm fine with the concept of splitting the unwind and logging steps; this is
> akin to doing:
>
>         stack_trace_save_tsk(...);
>         ...
>         stack_trace_print(...);
>
> ... and I'm fine with having a stack_trace_save_hyp(...) variant.
>
> However, I would like to ensure that we're reusing logic rather than
> duplicating it wholesale.

Agreed. Although some reimplementation may be unavoidable, as we can't
safely link against kernel code from the protected KVM hypervisor.
Perhaps we can move some of the common logic to a shared header that
can be included in both places (host, hyp), WDYT?

> There are some changes I would like to make to the
> stacktrace code in the near future that might make that a bit easier, e.g.
> reworking the stack transition checks to be table-driven, and factoring out the
> way we handle return trampolines.

Sounds good to me.

Thanks,
Kalesh
>
> I'll Cc you on changes to the stacktrace code. There are some preparatory
> cleanups I'd like to get out of the way first which I'll send shortly.
>
> Thanks,
> Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
