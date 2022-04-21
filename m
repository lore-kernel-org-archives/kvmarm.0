Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D980CC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 21 Apr 2022 09:00:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E2FE4B284;
	Thu, 21 Apr 2022 05:00:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AsKQ7tSYRfar; Thu, 21 Apr 2022 05:00:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AF1C4B286;
	Thu, 21 Apr 2022 05:00:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 110194B284
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 05:00:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LXwLycqvQ0kC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2022 05:00:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3A104B280
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 05:00:46 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 256611477;
 Thu, 21 Apr 2022 02:00:46 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.76.146])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD1C03F766;
 Thu, 21 Apr 2022 02:00:42 -0700 (PDT)
Date: Thu, 21 Apr 2022 10:00:36 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v6 7/8] KVM: arm64: Unwind and dump nVHE HYP stacktrace
Message-ID: <YmEdNME45PJr5w+Y@FVFF77S0Q05N>
References: <20220314200148.2695206-1-kaleshsingh@google.com>
 <20220314200148.2695206-8-kaleshsingh@google.com>
 <CA+EHjTwQRUCjvcMHNe1f0kPBdU=vS+f2+e_eefhnJDR4s73cQA@mail.gmail.com>
 <CAC_TJveNRaDFcQGo9-eqKa3=1DnuVDs4U+ye795VcJ1ozVkMyg@mail.gmail.com>
 <YlbXHg64HK2d3dgm@FVFF77S0Q05N>
 <CAC_TJveJYFkHPQLYdL8SCEAwMPgwpF_-ctMqKJ9w=eDa_M0u5w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAC_TJveJYFkHPQLYdL8SCEAwMPgwpF_-ctMqKJ9w=eDa_M0u5w@mail.gmail.com>
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

On Tue, Apr 19, 2022 at 10:37:56AM -0700, Kalesh Singh wrote:
> On Wed, Apr 13, 2022 at 6:59 AM Mark Rutland <mark.rutland@arm.com> wrote:
> > I'm fine with the concept of splitting the unwind and logging steps; this is
> > akin to doing:
> >
> >         stack_trace_save_tsk(...);
> >         ...
> >         stack_trace_print(...);
> >
> > ... and I'm fine with having a stack_trace_save_hyp(...) variant.
> >
> > However, I would like to ensure that we're reusing logic rather than
> > duplicating it wholesale.
> 
> Agreed. Although some reimplementation may be unavoidable, as we can't
> safely link against kernel code from the protected KVM hypervisor.

Sure; I just mean that we have one implementation, even if that gets recompiled
in separate objects for different contexts.

> Perhaps we can move some of the common logic to a shared header that
> can be included in both places (host, hyp), WDYT?

My rough thinking was that we'd build the same stacktrace.c file (reworked from
the current one) as stracktrace.o and stacktrace.nvhe.o, but moving things
around into headers is also an option. Either way will need some
experimentation.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
