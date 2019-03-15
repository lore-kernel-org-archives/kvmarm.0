From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: Kick cpu when WFI in single-threaded kvm integration
Date: Fri, 15 Mar 2019 09:43:11 +0100
Message-ID: <20190315084311.GA10950@e113682-lin.lund.arm.com>
References: <93B846538060DA46A9945E98A2E521E901425BA9@DE02WEMBXB.internal.synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEBAD4A430
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Mar 2019 04:43:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mLNDsxSpVnH2 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Mar 2019 04:43:14 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DD2C4A382
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Mar 2019 04:43:14 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <93B846538060DA46A9945E98A2E521E901425BA9@DE02WEMBXB.internal.synopsys.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jan Bolke <jan.bolke@synopsys.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jan,

On Thu, Mar 14, 2019 at 12:19:02PM +0000, Jan Bolke wrote:
> Hi all,
> 
> Currently I am working on a SystemC integration of kvm on arm.
> Therefore, I use the kvm api and of course SystemC (library to simulate hardware platforms with C++).
> 
> As I need the virtual cpu to interrupt its execution loop from time to time to let the rest of the SystemC simulation execute,
> I use a perf_event and let the kernel send a signal on overflow to the simulation thread which kicks the virtual cpu (suggested by this mailing list, thanks again).
> Thus I am able to simulate a quantum mechanism for the virtual cpu.
> 
> As I am running benchmarks (e.g. Coremark) on my virtual platform this works fine.
> 
> I also get to boot Linux until it spawns the terminal and then wait for interrupts from my virtual uart.
> Here comes the problem:
> The perf event counting mechanism does increment its counted instructions very very slowly when the virtual cpu executes wfi.
> Thus my whole simulation starts to hang.
> As my simulation is single threaded I need the signal from the kernel to kick my cpu to let the virtual uart deliver its interrupt to react to my input.
> I tried to use the request_interrupt_window flag but this does not seem to work.
> 
> Is there a way to kick the virtual cpu when it is waiting for interrupts? Or do I have to patch my kvm code?
> 

Let me see if I understand your question properly; you are running a KVM
virtual CPU which executes WFI in the guest, and then you are not
receiving interrupts in the guest nor getting events back from KVM which
you somehow use to run a backend simulation in userspace?

KVM/Arm can do two things for WFI:

 1. Let the guest directly execute it without trapping to the hypervisor
    (the physical CPU will NOT exit the guest until there's a physical
    interrupt on the CPU).

 2. Trap WFI to KVM.  KVM asks Linux to schedule another process until
    there's a virtual interrupt for the VCPU.  This is what mainline
    KVM/Arm does.


I suspect what's happening is that you are using a normal kernel
configured as (2), and therefore you only count cycles for the perf
event while the guest runs the timer ISR which obviously is much much
less than if you had a constant running VCPU.  Am I on the right track?

If so, there are a couple of things you could try.

First, you can try disabling the trap on WFI (note that this changes
pretty fundamental behavior of KVM, and this is not recommended for
production use or for systems level performance investigations where
more than one workload contends for a single physical CPU):

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 7f9d2bfcf82e..b38a5a134fef 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -84,7 +84,7 @@
  * FMO:		Override CPSR.F and enable signaling with VF
  * SWIO:	Turn set/way invalidates into set/way clean+invalidate
  */
-#define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
+#define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_VM | \
 			 HCR_TVM | HCR_BSU_IS | HCR_FB | HCR_TAC | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
 			 HCR_FMO | HCR_IMO)


Note that I'm not sure how the performance counter counts on your
particular platform when the CPU is in WFI, so this may not help at all.


Second, and possibly preferred, you can hook up your simulation event to
a timer event in the case of trapping on a WFI.  See kvm_handle_wfx() in
arch/arm64/kvm/handle_exit.c and follow kvm_vcpu_block() from there to
see how KVM/Arm handles this event.


Hope this helps,

    Christoffer
