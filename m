Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F72DC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jan 2022 16:39:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8284049EF2;
	Tue,  4 Jan 2022 11:39:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rfeY4MK1ytvD; Tue,  4 Jan 2022 11:39:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F4B949F14;
	Tue,  4 Jan 2022 11:39:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C586349F14
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 11:39:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H0dJXZ4XGUxF for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jan 2022 11:39:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75BB340414
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 11:39:28 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5941113A1;
 Tue,  4 Jan 2022 08:39:27 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.9.1])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 638603F774;
 Tue,  4 Jan 2022 08:39:25 -0800 (PST)
Date: Tue, 4 Jan 2022 16:39:19 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Possible nohz-full/RCU issue in arm64 KVM
Message-ID: <YdR4N9QVYOzjowAb@FVFF77S0Q05N>
References: <d80e440375896f75d45e227d40af60ca7ba24ceb.camel@redhat.com>
 <YbyO40zDW/kvUHEE@FVFF77S0Q05N>
 <70f112072d9496d21901946ea82832d3ed3a8cb2.camel@redhat.com>
 <Ybyg1r/Q6EfeuXGV@FVFF77S0Q05N>
 <9ab8107f-ff41-6a9e-57e1-a261bea93aca@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9ab8107f-ff41-6a9e-57e1-a261bea93aca@redhat.com>
Cc: paulmck <paulmck@kernel.org>, maz <maz@kernel.org>,
 frederic <frederic@kernel.org>, Anup Patel <Anup.Patel@wdc.com>,
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

On Fri, Dec 17, 2021 at 04:54:22PM +0100, Paolo Bonzini wrote:
> On 12/17/21 15:38, Mark Rutland wrote:
> > For example kvm_guest_enter_irqoff() calls guest_enter_irq_off() which calls
> > vtime_account_guest_enter(), but kvm_guest_exit_irqoff() doesn't call
> > guest_exit_irq_off() and the call to vtime_account_guest_exit() is open-coded
> > elsewhere. Also, guest_enter_irq_off() conditionally calls
> > rcu_virt_note_context_switch(), but I can't immediately spot anything on the
> > exit side that corresponded with that, which looks suspicious.
> 
> rcu_note_context_switch() is a point-in-time notification; it's not strictly
> necessary, but it may improve performance a bit by avoiding unnecessary IPIs
> from the RCU subsystem.
> 
> There's no benefit from doing it when you're back from the guest, because at
> that point the CPU is just running normal kernel code.

I see.

My main issue here was just that it's really difficult to see how the
entry/exit logic is balanced, and I reckon we can solve that by splitting
guest_{enter,exit}_irqoff() into helper functions to handle the vtime
accounting separately from the context tracking, so that arch code can do
something like:

  guest_timing_enter_irqoff();
  
  guest_eqs_enter_irqoff();
  < actually run vCPU here >
  guest_eqs_exit_irqoff();
  
  < handle pending IRQs here >
  
  guest_timing_exit_irqoff();

... which I hope should work for RISC-V too.

I've had a go, and I've pushed out a WIP to:

  https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/kvm/rcu

I also see we'll need to add some lockdep/irq-tracing management to arm64, and
it probably makes sense to fold that into common helpers, so I'll have a play
with that tomorrow.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
