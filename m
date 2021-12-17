Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F32C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 17 Dec 2021 13:21:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61D474B32A;
	Fri, 17 Dec 2021 08:21:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A3zlyVEjf9v3; Fri, 17 Dec 2021 08:21:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A88E4B32B;
	Fri, 17 Dec 2021 08:21:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38BE74B329
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 08:21:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M284vA6wIIbP for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Dec 2021 08:21:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA1054B325
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 08:21:50 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3844A12FC;
 Fri, 17 Dec 2021 05:21:50 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.67.184])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 972613F5A1;
 Fri, 17 Dec 2021 05:21:48 -0800 (PST)
Date: Fri, 17 Dec 2021 13:21:39 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Subject: Re: Possible nohz-full/RCU issue in arm64 KVM
Message-ID: <YbyO40zDW/kvUHEE@FVFF77S0Q05N>
References: <d80e440375896f75d45e227d40af60ca7ba24ceb.camel@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d80e440375896f75d45e227d40af60ca7ba24ceb.camel@redhat.com>
Cc: paulmck <paulmck@kernel.org>, maz <maz@kernel.org>,
 frederic <frederic@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
 rcu <rcu@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Fri, Dec 17, 2021 at 12:51:57PM +0100, Nicolas Saenz Julienne wrote:
> Hi All,

Hi,

> arm64's guest entry code does the following:
> 
> int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> {
> 	[...]
> 
> 	guest_enter_irqoff();
> 
> 	ret = kvm_call_hyp_ret(__kvm_vcpu_run, vcpu);
> 
> 	[...]
> 
> 	local_irq_enable();
> 
> 	/*
> 	 * We do local_irq_enable() before calling guest_exit() so
> 	 * that if a timer interrupt hits while running the guest we
> 	 * account that tick as being spent in the guest.  We enable
> 	 * preemption after calling guest_exit() so that if we get
> 	 * preempted we make sure ticks after that is not counted as
> 	 * guest time.
> 	 */
> 	guest_exit();
> 	[...]
> }
> 
> 
> On a nohz-full CPU, guest_{enter,exit}() delimit an RCU extended quiescent
> state (EQS). Any interrupt happening between local_irq_enable() and
> guest_exit() should disable that EQS. Now, AFAICT all el0 interrupt handlers
> do the right thing if trggered in this context, but el1's won't. Is it
> possible to hit an el1 handler (for example __el1_irq()) there?

I think you're right that the EL1 handlers can trigger here and won't exit the
EQS.

I'm not immediately sure what we *should* do here. What does x86 do for an IRQ
taken from a guest mode? I couldn't spot any handling of that case, but I'm not
familiar enough with the x86 exception model to know if I'm looking in the
right place.

Note that the EL0 handlers *cannot* trigger for an exception taken from a
guest. We use separate vectors while running a guest (for both VHE and nVHE
modes), and from the main kernel's PoV we return from kvm_call_hyp_ret(). We
can ony take IRQ from EL1 *after* that returns.

We *might* need to audit the KVM vector handlers to make sure they're not
dependent on RCU protection (I assume they're not, but it's possible something
has leaked into the VHE code).

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
