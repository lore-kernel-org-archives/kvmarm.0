From: Andrew Jones <drjones@redhat.com>
Subject: Re: An ode to kvm_arch_vcpu_runnable()
Date: Fri, 29 Sep 2017 13:39:01 +0200
Message-ID: <20170929113901.feec4g54mdbqjjlb@hawk.localdomain>
References: <20170917163210.3m7solx3oqiu6fwf@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE392406BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Sep 2017 07:38:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6HdpFzgDlZrI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Sep 2017 07:38:56 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3924540651
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Sep 2017 07:38:56 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170917163210.3m7solx3oqiu6fwf@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, cdall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Sep 17, 2017 at 06:32:10PM +0200, Andrew Jones wrote:
> Oh, kvm_arch_vcpu_runnable(), how I love thee. Let me count the ways:

I just sent patches for this, as patches speak louder than poetry, but
the series makes a couple changes to the proposal:

> 
> ========
> Proposal
> ========
> 
>  1) Add a VCPU request to be used by KVM_IRQ_LINE to deassert the line.
>     The new VCPU request will be flagged with KVM_REQUEST_NO_WAKEUP, and
>     the IRQ_PENDING request will not be set on deasserts.

This part was dropped. If we did this, then irq-line would behave more
like an edge interrupt than a level, so we need to continue checking
irq_lines in runnable() no matter what.

> 
>  2) Make runnable() more obvious and future proof by adding an explicit
>     check for the 'waiting-for-interrupts' VCPU state. This can be done
>     with a new 'halted' boolean that gets set when emulating WFI.

Rather than introduce yet another boolean, power_off was replaced with
mp_state, allowing KVM_MP_STATE_HALTED to be used.

> 
>  3) Just check the IRQ_PENDING VCPU request for runnable()'s
>     'interrupts-pending' check.
> 
>  4) Clean up all the 'power_off || pause' checks scattered throughout
>     virt/kvm/arm/arm.c by wrapping the condition in a function.
>

Thanks,
drew 
