Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630BDC433EF
	for <kvmarm@archiver.kernel.org>; Sun,  6 Feb 2022 13:08:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 953D340B80;
	Sun,  6 Feb 2022 08:08:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MUqjSMsTZmAU; Sun,  6 Feb 2022 08:08:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88A2F408B3;
	Sun,  6 Feb 2022 08:08:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6F9C408B3
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Feb 2022 08:08:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id It02NpMczBiF for <kvmarm@lists.cs.columbia.edu>;
 Sun,  6 Feb 2022 08:08:39 -0500 (EST)
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4430A404CD
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Feb 2022 08:08:39 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=r+gFF/vh5cSrP7KvoK/nIgqjizm6gE7sf4GkpA389wU=; b=BxgIxsrU2QJcX39YxBcIRdWY9m
 1InCvuuhaZSBAHPDyxkW4kpQEW0PNI5OxHuRe2VyAKR+rsthjZyBtDoLV9v7P5gRABQlP+rDck/2T
 0Eum8llSq5MxbwmLQpdYtcwBE5lCjmmPWl/g3fZasID1Jm2FK8DaxmlkyVaAq7eksYG4vwOFtylsF
 ByER5B38SETjK5k2BRG8SlZO3f49/oYQqWjBa94ODbHh0LFJZkMFeF/tx37n3wBcNQiV2YbfXfJZ7
 empLcdFZ4dEfuW7xG5uJjCMhH1bF6ec2hmMvDRlW5hjO4ndYT9fBGOZQcYkdr18YfQKWXiF6erKkV
 wpLVj/lA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100]
 helo=worktop.programming.kicks-ass.net)
 by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1nGhHM-007QNp-1l; Sun, 06 Feb 2022 13:08:32 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
 id 9E68198622D; Sun,  6 Feb 2022 14:08:30 +0100 (CET)
Date: Sun, 6 Feb 2022 14:08:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v4 09/17] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <20220206130830.GC23216@worktop.programming.kicks-ass.net>
References: <20211111020738.2512932-1-seanjc@google.com>
 <20211111020738.2512932-10-seanjc@google.com>
 <YfrQzoIWyv9lNljh@google.com>
 <CABCJKufg=ONNOvF8+BRXfLoTUfeiZZsdd8TnpV-GaNK_o-HuaA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABCJKufg=ONNOvF8+BRXfLoTUfeiZZsdd8TnpV-GaNK_o-HuaA@mail.gmail.com>
Cc: Will McVicker <willmcvicker@google.com>, Kees Cook <keescook@chromium.org>,
 kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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

On Fri, Feb 04, 2022 at 09:35:49AM -0800, Sami Tolvanen wrote:
> On Wed, Feb 2, 2022 at 10:43 AM Sean Christopherson <seanjc@google.com> wrote:
> > > +DEFINE_STATIC_CALL_RET0(__perf_guest_state, *perf_guest_cbs->state);
> > > +DEFINE_STATIC_CALL_RET0(__perf_guest_get_ip, *perf_guest_cbs->get_ip);
> > > +DEFINE_STATIC_CALL_RET0(__perf_guest_handle_intel_pt_intr, *perf_guest_cbs->handle_intel_pt_intr);
> >
> > Using __static_call_return0() makes clang's CFI sad on arm64 due to the resulting
> > function prototype mistmatch, which IIUC, is verified by clang's __cfi_check()
> > for indirect calls, i.e. architectures without CONFIG_HAVE_STATIC_CALL.
> >
> > We could fudge around the issue by using stubs, massaging prototypes, etc..., but
> > that means doing that for every arch-agnostic user of __static_call_return0().
> >
> > Any clever ideas?  Can we do something like generate a unique function for every
> > DEFINE_STATIC_CALL_RET0 for CONFIG_HAVE_STATIC_CALL=n, e.g. using typeof() to
> > get the prototype?
> 
> I'm not sure there's a clever fix for this. On architectures without
> HAVE_STATIC_CALL, this is an indirect call to a function with a
> mismatching type, which CFI is intended to catch.
> 
> The obvious way to solve the problem would be to use a stub function
> with the correct type, which I agree, isn't going to scale. You can
> alternatively check if .func points to __static_call_return0 and not
> make the indirect call if it does. If neither of these options are
> feasible, you can disable CFI checking in the functions that have
> these static calls using the __nocfi attribute.

There's also the tp_stub_func() thing that does basically the same
thing.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
