From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] arm/arm64: KVM: Properly account for guest CPU time
Date: Tue, 2 Jun 2015 13:55:37 +0200
Message-ID: <20150602115537.GA12347@cbox>
References: <1432838950-28774-1-git-send-email-christoffer.dall@linaro.org>
 <5568E987.5010702@samsung.com> <20150531065923.GB763@cbox>
 <556C7EC6.3010105@samsung.com> <20150602092759.GA7783@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24DB652CA4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jun 2015 07:45:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BL56wxagFZeW for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Jun 2015 07:45:02 -0400 (EDT)
Received: from mail-la0-f54.google.com (mail-la0-f54.google.com
 [209.85.215.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0794052BE9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jun 2015 07:45:01 -0400 (EDT)
Received: by labpy14 with SMTP id py14so111622890lab.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Jun 2015 04:54:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150602092759.GA7783@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, borntraeger@de.ibm.com, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

[replying to myself]

On Tue, Jun 02, 2015 at 11:27:59AM +0200, Christoffer Dall wrote:

[..]

> > > 
> > > If this patch is incorrect, then how does it work on x86, where
> > > handle_external_intr() is called (with a barrier in between) before
> > > kvm_guest_exit(), and where handle_external_intr() is simply
> > > local_irq_enable() on SVM and something more complicated on VMX ?
> > > 
> > > Finally, how exactly is preemption latency added here?   Won't IRQ
> > > processing run with higher priority than any task on your system, so the
> > > order of (1) process pending IRQs (2) call schedule if needed is still
> > > preserved here, but we call kvm_guest_exit() between (1) and (2) instead
> > > of before (1).
> > 
> > I may be missing something, but on return from interrupt with preempt
> > disabled we can't take the need resched path. And need to return
> > to KVM no?
> 
> preempt_enable() will call __preempt_schedule() and cause preemption
> there, so you're talking about adding these lines of latency:
> 
> 	kvm_guest_exit();
> 	trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> 
> And these were called with interrupts disabled before, so I don't see
> the issue??
> 
> However, your question is making me think whether we have a race in the
> current code on fully preemptible kernels, if we get preempted before
> calling kvm_timer_sync_hwstate() and kvm_vgic_sync_hwstate(), then we
> could potentially schedule another vcpu on this core and loose/corrupt
> state, can we not?  We probably need to check for this in
> kvm_vcpu_load/kvm_vcpu_put.  I need to think more about if this is a
> real issue or if I'm seeing ghosts.
> 
I've thought about it and I don't think there's a race because those
functions don't access the hardware directly, but only manipulate
per-vcpu data structures.

-Christoffer
