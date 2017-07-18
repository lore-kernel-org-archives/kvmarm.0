From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH kvm-unit-tests 0/3] Add physical timer test
Date: Tue, 18 Jul 2017 12:42:26 +0200
Message-ID: <20170718104226.GC14069@cbox>
References: <20170713192009.10069-1-cdall@linaro.org>
 <20170718101707.54zw5jbonyfaqadx@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB26B40D29
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 06:41:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b+HCTM8T+wp1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 06:41:42 -0400 (EDT)
Received: from mail-lf0-f49.google.com (mail-lf0-f49.google.com
 [209.85.215.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B308C40A80
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 06:41:42 -0400 (EDT)
Received: by mail-lf0-f49.google.com with SMTP id w198so10148267lff.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 03:42:30 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170718101707.54zw5jbonyfaqadx@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 18, 2017 at 12:17:07PM +0200, Andrew Jones wrote:
> On Thu, Jul 13, 2017 at 09:20:06PM +0200, Christoffer Dall wrote:
> > Add a test for the vtimer. I've tested on
> >  accel=tcg
> >  accel=kvm                     : on seattle, and mustang
> >  accel=kvm,kernel-irqchip=off  : on mustang
> > 
> > I first fix two issues I had running the basic timer test on APM mustang
> > on using TCG.  I wonder why the vtimer tests worked using TCG for Drew,
> > since they didn't work for me, and I don't see how they would have
> > without patch 1.
> 
> That's weird. I just tested again with a latest qemu master pull and it
> still works for me without patch 1. However, as you and Marc discussed,
> it's the right thing to do with regards to the spec.
> 

What is the command line you use to test this?

By looking at the code in QEMU, I see this:

target/arm/helper.c:gt_recalc_timer()

    if (gt->ctl & 1) {
        ...
    } else {
        gt->ctl &= ~4;
        qemu_set_irq(cpu->gt_timer_outputs[timeridx], 0);
        timer_del(cpu->gt_timer[timeridx]);
        trace_arm_gt_recalc_disabled(timeridx);
    }

So bits 1 and 2 (IMASK and ISTATUS, respectively) are cleared.

I instrumented the code and verified this.

Confusing.

> > 
> > Then I introduce a test for the physical timer.  If you run the ptimer
> > test on a kernel before support for the physical timers was added you
> > get a nice error message plus some spamming in your kernel log.
> 
> Thanks for contributing to kvm-unit-tests!
> 

Thanks for maintaining kvm-unit-tests!

It has actually been incredibly useful for developing my timer patches.

-Christoffer
