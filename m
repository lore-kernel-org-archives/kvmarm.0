Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E362C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 13 Apr 2022 13:59:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 220D64018D;
	Wed, 13 Apr 2022 09:59:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9iutjbCekLrT; Wed, 13 Apr 2022 09:59:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C049E4B1D3;
	Wed, 13 Apr 2022 09:59:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DD134B15C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 09:59:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 90vV42De4yqz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Apr 2022 09:59:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A5D54B092
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 09:59:04 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 797E31595;
 Wed, 13 Apr 2022 06:59:04 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.75.153])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 435003F5A1;
 Wed, 13 Apr 2022 06:59:01 -0700 (PDT)
Date: Wed, 13 Apr 2022 14:58:54 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v6 7/8] KVM: arm64: Unwind and dump nVHE HYP stacktrace
Message-ID: <YlbXHg64HK2d3dgm@FVFF77S0Q05N>
References: <20220314200148.2695206-1-kaleshsingh@google.com>
 <20220314200148.2695206-8-kaleshsingh@google.com>
 <CA+EHjTwQRUCjvcMHNe1f0kPBdU=vS+f2+e_eefhnJDR4s73cQA@mail.gmail.com>
 <CAC_TJveNRaDFcQGo9-eqKa3=1DnuVDs4U+ye795VcJ1ozVkMyg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAC_TJveNRaDFcQGo9-eqKa3=1DnuVDs4U+ye795VcJ1ozVkMyg@mail.gmail.com>
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

Hi Kalesh,

Sorry for the radiosilence.

I see that in v7 you've dropped the stacktrace bits for now; I'm just
commenting here fot future reference.

On Thu, Mar 31, 2022 at 12:22:05PM -0700, Kalesh Singh wrote:
> Hi everyone,
> 
> There has been expressed interest in having hypervisor stack unwinding
> in production Android builds.
> 
> The current design targets NVHE_EL2_DEBUG enabled builds and is not
> suitable for production environments, since this config disables host
> stage-2 protection on hyp_panic() which breaks security guarantees.
> The benefit of this approach is that the stack unwinding can happen at
> EL1 and allows us to reuse most of the unwinding logic from the host
> kernel unwinder.
> 
> Proposal for how this can be done without disabling host stage-2 protection:
>   - The host allocates a "panic_info" page and shares it with the hypervisor.
>   - On hyp_panic(), the hypervisor can unwind and dump its stack
> addresses to the shared page.
>   - The host can read out this information and symbolize these addresses.
> 
> This would allow for getting hyp stack traces in production while
> preserving the security model. The downside being that the core
> unwinding logic would be duplicated at EL2.
> 
> Are there any objections to making this change?

I'm fine with the concept of splitting the unwind and logging steps; this is
akin to doing:

	stack_trace_save_tsk(...);
	...
	stack_trace_print(...);

... and I'm fine with having a stack_trace_save_hyp(...) variant.

However, I would like to ensure that we're reusing logic rather than
duplicating it wholesale. There are some changes I would like to make to the
stacktrace code in the near future that might make that a bit easier, e.g.
reworking the stack transition checks to be table-driven, and factoring out the
way we handle return trampolines.

I'll Cc you on changes to the stacktrace code. There are some preparatory
cleanups I'd like to get out of the way first which I'll send shortly.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
