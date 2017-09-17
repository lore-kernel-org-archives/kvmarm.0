From: Andrew Jones <drjones@redhat.com>
Subject: An ode to kvm_arch_vcpu_runnable()
Date: Sun, 17 Sep 2017 18:32:10 +0200
Message-ID: <20170917163210.3m7solx3oqiu6fwf@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C96D649C2B
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Sep 2017 12:29:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DAg4vop14fSb for <kvmarm@lists.cs.columbia.edu>;
 Sun, 17 Sep 2017 12:29:28 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 67A2B49C29
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Sep 2017 12:29:28 -0400 (EDT)
Content-Disposition: inline
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

Oh, kvm_arch_vcpu_runnable(), how I love thee. Let me count the ways:

 1) We must confirm the observability of the loads of 'power_off',
    'pause', and 'irq_lines', as they are used in the condition to stop
    waiting.

    They're OK, because the check is done after prepare_to_swait(), which
    calls set_current_state(), and all wakers do swake_up(). swake_up()
    results in a try_to_wake_up(), which is designed to pair with
    set_current_state(). Actually, the smp_mb() in kvm_psci_vcpu_on()
    is not even necessary. Note, 'irq_lines' is awaken through a VCPU
    kick, which calls kvm_vcpu_wake_up(). kvm_vcpu_wake_up() uses barriers
    correctly since 5e0018b3e39e "kvm: Serialize wq active checks in
    kvm_vcpu_wake_up()".

 2) We should consider replacing the check of 'irq_lines' with a check of
    the VCPU request, IRQ_PENDING.

    VCPU request IRQ_PENDING and 'irq_lines' are not equivalent. While
    IRQ_PENDING is always set when 'irq_lines' changes, runnable() only
    checks if 'irq_lines' is nonzero, meaning a change from nonzero to
    zero will not awaken a VCPU. This makes sense, because 'level=1' for
    KVM_IRQ_LINE always means the IRQ is asserted, and 'level=0' always
    means deasserted.

    If we intend to check IRQ_PENDING in runnable() at all, then we need
    to stop making the IRQ_PENDING request when KVM_IRQ_LINE is used to
    deassert an IRQ. If we stop making the request on deassert, and start
    checking IRQ_PENDING in runnable(), then the 'irq_lines' check may be
    removed.

 3) We should consider replacing the call of kvm_vgic_vcpu_pending_irq()
    with a check of the VCPU request, IRQ_PENDING.

    kvm_vgic_vcpu_pending_irq() iterates the VCPU's "Active or Pending
    IRQ" list, looking for any pending and enabled IRQ, returning true
    if it finds one. So, the questions are if every time there is at least
    one pending and enabled IRQ on the VCPU's list, the VCPU will also
    have its IRQ_PENDING request bit set, and, conversely, if IRQ_PENDING
    will ever be set even when there are no pending and enabled IRQs.

    It appears IRQ_PENDING will be set every time an IRQ is added to
    the list, thanks to vgic_queue_irq_unlock(), however, while IRQs may
    be dropped or migrated from the VCPU's list, the IRQ_PENDING request
    would remain. That said, it's of little consequence for the VCPU to
    wake up due to an IRQ_PENDING request when there are no longer pending
    IRQs. Indeed, the same race of a pending IRQ being dropped/migrated
    immediately prior to the VCPU flushing it's VGIC hardware state is
    present with the kvm_vgic_vcpu_pending_irq() check as well.

    Now, if a host IRQ handler sets IRQ_PENDING to inform the guest to
    wake up and inject an IRQ, then on wake up, while IRQ_PENDING will be
    set, the IRQ will not yet be in the list. This means
    kvm_vgic_vcpu_pending_irq(), alone, may not be sufficient to determine
    when to wake up. It can be fixed, though, by either checking specific
    pending state in runnable(), like 'irq_lines', or by adding the state
    to the checks done in kvm_vgic_vcpu_pending_irq() - as is proposed in
    the patch "KVM: arm/arm64: GICv4: Use pending_last as a scheduling
    hint". The barrier analysis done for (1) would apply to either fix, as
    long as the IRQ handler wakes up the VCPU with kvm_vcpu_wake_up() or
    kvm_vcpu_kick(), which calls kvm_vcpu_wake_up().

 4) We must confirm the compound condition sufficiently determines when
    a VCPU should be considered runnable.

    It does, but it's not obvious, as it depends on the contexts of the
    two callers.

    Conceptually, runnable() should be "not waiting, or waiting for
    interrupts and interrupts are pending":

     !waiting-uninterruptable &&
     (!waiting-for-interrupts || interrupts-pending)

    More concisely

     !W_u && (!W_i || I)

    But, the implementation is only

     !W_u && I

    Context1: Called from kvm_vcpu_block() we know W_i=1

        !W_u && (!W_i || I)
     => !W_u && (!(1) || I)
     => !W_u && I

    Context2: Called from kvm_vcpu_on_spin() we know (W_u || W_i) = 1,
    which implies W_i=1 if W_u=0

        !W_u && (!W_i || I)
     => !(0) && (!(1) || I) = I, W_u=0
        !(1) && (!W_i || I) = 0, W_u=1
     => !W_u && I

 5) We must confirm the compound condition is not missing any conditions;
    all conditions for waiting-uninterruptable and for interrupts-pending
    must be present.

    waiting-uninterruptable is

     power_off || pause

    which is correct, as there is currently no other way to request
    uninterruptable waiting, a.k.a sleep.

    interrupts-pending is

     !!irq_lines || kvm_vgic_vcpu_pending_irq()

    which is mostly correct. It is not correct regarding the vPMU. If
    a VCPU's perf event overflow handler were to fire after the VCPU
    started waiting, then the wake up done by the kvm_vcpu_kick() call
    in the handler would do nothing, as no "pmu overflow" state is
    checked in runnable().

    We can fix this by adding and checking pending state, as described
    in (3), or by deciding to just check IRQ_PENDING in runnable(), and
    then fix 'irq_lines' instead, as described in (2).

========
Proposal
========

 1) Add a VCPU request to be used by KVM_IRQ_LINE to deassert the line.
    The new VCPU request will be flagged with KVM_REQUEST_NO_WAKEUP, and
    the IRQ_PENDING request will not be set on deasserts.

 2) Make runnable() more obvious and future proof by adding an explicit
    check for the 'waiting-for-interrupts' VCPU state. This can be done
    with a new 'halted' boolean that gets set when emulating WFI.

 3) Just check the IRQ_PENDING VCPU request for runnable()'s
    'interrupts-pending' check.

 4) Clean up all the 'power_off || pause' checks scattered throughout
    virt/kvm/arm/arm.c by wrapping the condition in a function.

===

Sorry for TL;DR mail. If the analysis and proposal look reasonable, then
I'll send patches.

Thanks,
drew
