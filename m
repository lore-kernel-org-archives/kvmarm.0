Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C425FC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jan 2022 13:24:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 376B44089E;
	Tue,  4 Jan 2022 08:24:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uCXSA23DnFH1; Tue,  4 Jan 2022 08:24:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF4A349E43;
	Tue,  4 Jan 2022 08:24:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4979C40C1B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 08:24:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GVHdipyA3x7i for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jan 2022 08:24:10 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F176349EC5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 08:24:09 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3304C1FB;
 Tue,  4 Jan 2022 05:24:09 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.9.1])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 91CD63F774;
 Tue,  4 Jan 2022 05:24:07 -0800 (PST)
Date: Tue, 4 Jan 2022 13:24:02 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Frederic Weisbecker <frederic@kernel.org>
Subject: Re: Possible nohz-full/RCU issue in arm64 KVM
Message-ID: <YdRJA79bs1Im7h01@FVFF77S0Q05N>
References: <d80e440375896f75d45e227d40af60ca7ba24ceb.camel@redhat.com>
 <YbyO40zDW/kvUHEE@FVFF77S0Q05N>
 <20211220161014.GC918551@lothringen>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211220161014.GC918551@lothringen>
Cc: paulmck <paulmck@kernel.org>, maz <maz@kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
 rcu <rcu@vger.kernel.org>, Nicolas Saenz Julienne <nsaenzju@redhat.com>,
 Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
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

On Mon, Dec 20, 2021 at 05:10:14PM +0100, Frederic Weisbecker wrote:
> On Fri, Dec 17, 2021 at 01:21:39PM +0000, Mark Rutland wrote:
> > On Fri, Dec 17, 2021 at 12:51:57PM +0100, Nicolas Saenz Julienne wrote:
> > > Hi All,
> > 
> > Hi,
> > 
> > > arm64's guest entry code does the following:
> > > 
> > > int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> > > {
> > > 	[...]
> > > 
> > > 	guest_enter_irqoff();
> > > 
> > > 	ret = kvm_call_hyp_ret(__kvm_vcpu_run, vcpu);
> > > 
> > > 	[...]
> > > 
> > > 	local_irq_enable();
> > > 
> > > 	/*
> > > 	 * We do local_irq_enable() before calling guest_exit() so
> > > 	 * that if a timer interrupt hits while running the guest we
> > > 	 * account that tick as being spent in the guest.  We enable
> > > 	 * preemption after calling guest_exit() so that if we get
> > > 	 * preempted we make sure ticks after that is not counted as
> > > 	 * guest time.
> > > 	 */
> > > 	guest_exit();
> > > 	[...]
> > > }
> > > 
> > > 
> > > On a nohz-full CPU, guest_{enter,exit}() delimit an RCU extended quiescent
> > > state (EQS). Any interrupt happening between local_irq_enable() and
> > > guest_exit() should disable that EQS. Now, AFAICT all el0 interrupt handlers
> > > do the right thing if trggered in this context, but el1's won't. Is it
> > > possible to hit an el1 handler (for example __el1_irq()) there?
> > 
> > I think you're right that the EL1 handlers can trigger here and won't exit the
> > EQS.
> > 
> > I'm not immediately sure what we *should* do here. What does x86 do for an IRQ
> > taken from a guest mode? I couldn't spot any handling of that case, but I'm not
> > familiar enough with the x86 exception model to know if I'm looking in the
> > right place.
> 
> This is one of the purposes of rcu_irq_enter(). el1 handlers don't call irq_enter()?

Due to lockep/tracing/etc ordering, we don't use irq_enter() directly and
instead call rcu_irq_enter() and irq_enter_rcu() separately. Critically we only
call rcu_irq_enter() for IRQs taken from the idle thread, as this was
previously thought to be the only place where we could take an IRQ from an EL1
EQS.

See __el1_irq(), __enter_from_kernel_mode(), and __exit_to_kernel_mode() in
arch/arm64/kernel/entry-common.c. The latter two are largely analogous to the
common irqentry_enter9) and irqentry_exit() helpers in kernel/entry/common.c.

We need to either rework the KVM code or that entry code. I'll dig into this a
bit more...

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
