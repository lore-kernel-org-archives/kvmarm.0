From: Jan Bolke <jan.bolke@synopsys.com>
Subject: RE: Kick cpu when WFI in single-threaded kvm integration
Date: Sat, 16 Mar 2019 09:05:08 +0000
Message-ID: <93B846538060DA46A9945E98A2E521E90142A5F9@de02wembxa.internal.synopsys.com>
References: <93B846538060DA46A9945E98A2E521E901425BA9@DE02WEMBXB.internal.synopsys.com>
 <20190315084311.GA10950@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20C7C4A452
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Mar 2019 05:05:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sC5+P8puzPRX for <kvmarm@lists.cs.columbia.edu>;
 Sat, 16 Mar 2019 05:05:13 -0400 (EDT)
Received: from smtprelay.synopsys.com (smtprelay.synopsys.com [198.182.60.111])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1C1F4A431
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Mar 2019 05:05:13 -0400 (EDT)
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com
 [10.192.0.18])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by smtprelay.synopsys.com (Postfix) with ESMTPS id CD0C110C25A4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Mar 2019 02:05:12 -0700 (PDT)
Received: from US01WEHTC3.internal.synopsys.com
 (us01wehtc3.internal.synopsys.com [10.15.84.232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by mailhost.synopsys.com (Postfix) with ESMTPS id A5970A0093
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Mar 2019 09:05:12 +0000 (UTC)
In-Reply-To: <20190315084311.GA10950@e113682-lin.lund.arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

>Let me see if I understand your question properly; you are running a KVM virtual CPU which executes WFI in the guest, and then you are not >receiving interrupts in the guest nor getting events back from KVM which you somehow use to run a backend simulation in userspace?

You are right!

>KVM/Arm can do two things for WFI: 
> 2. Trap WFI to KVM.  KVM asks Linux to schedule another process until
>    there's a virtual interrupt for the VCPU.  This is what mainline
>    KVM/Arm does.
>
>
>I suspect what's happening is that you are using a normal kernel configured as (2), and therefore you only count cycles for the perf event while the >guest runs the timer ISR which obviously is much much less than if you had a constant running VCPU.  Am I on the right track?

Yes. The only thing which is somewhat strange is that I am using a userspace interrupt controller so my timer interrupt goes its way from the kvm virtual timer into userspace via KVM_ARM_DEV_EL1_VTIMER, through the userspace interrupt controller and back into kvm via KVM_IRQ_LINE. 
This of course means, that as long the vcpu is executing and has not exited to userspace there is no interrupt delivery and thus no timer interrupt service routine. Nevertheless, the counting mechanism increases slowly and eventually the kvm_cpu exits to userspace enabling me to deliver timer/uart interrupts. This leads to a very slow simulation, once linux is completely booted and interrupt-driven. But that just as a sidenote.

>Second, and possibly preferred, you can hook up your simulation event to a timer event in the case of trapping on a WFI.  See kvm_handle_wfx() in >arch/arm64/kvm/handle_exit.c and follow kvm_vcpu_block() from there to see how KVM/Arm handles this event.

That sound like a great plan. I basically want to achieve the following: instead of waiting inside kvm_vcpu_block() for a virtual interrupt I want to exit to userspace and signal that the virtual cpu is waiting for a interrupt. Then I can react inside my simulation via a uart/timer interrupt and enter the guest again. Thanks four your ideas, they gave me a really good starting point.

There is still one thing I do not understand: In the documentation of the kvm api there is the the 'request_interrupt_window' flag in the kvm_run structure. This is a request that kvm_returns when it becomes possible to inject interrupts.
This looked as the thing I want to do/use but did not gave the expected result. Is this flag disabled on kvm/arm?

Thanks again,
Jan
