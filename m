From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 0/2] kvm/arm: make singlestep behaviour consistent
Date: Fri,  9 Nov 2018 15:07:09 +0000
Message-ID: <20181109150711.45864-1-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F192C4A34C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Nov 2018 10:07:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8D7oo5M7g12Z for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Nov 2018 10:07:20 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC7944A34B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Nov 2018 10:07:20 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

We don't consistently advance the singlestep state machine when emulating
instructions. We attempt to bodge around this when the host is stepping a
guest, and fake a debug exception, but we don't always get this right.
Additionally, we don't try to fix this up at all when a guest is stepping
itself, so guests cannot single-step emulated instructions reliably.

In both cases we're usually reliant on the HW singlestep state machine, so
let's have our instruction emulation consistently advance that. Thus, when we
return to a guest after emulating an instruction, the HW will generate the step
exception for us, routed to host or guest appropriately.

So far I have only compile-tested these patches. YMMV.

These patches do not ensure that guest-stepping is reliable in the presence of
host-stepping. We might need to say that it's userspace's responsibility to
virtualize the guest singlestep state machine when stepping the guest.
Otherwise, it's not clear to me if we can shadow this correctly within the
kernel.

Thanks,
Mark.

Mark Rutland (2):
  kvm/arm: skip MMIO insn after emulation
  kvm/arm: consistently advance singlestep when emulating instructions

 arch/arm/include/asm/kvm_host.h          |  5 ----
 arch/arm64/include/asm/kvm_emulate.h     | 35 ++++++++++++++++++++------
 arch/arm64/include/asm/kvm_host.h        |  1 -
 arch/arm64/kvm/debug.c                   | 21 ----------------
 arch/arm64/kvm/handle_exit.c             | 14 +----------
 arch/arm64/kvm/hyp/switch.c              | 43 +++-----------------------------
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c | 12 ++++++---
 virt/kvm/arm/arm.c                       |  2 --
 virt/kvm/arm/hyp/vgic-v3-sr.c            |  6 ++++-
 virt/kvm/arm/mmio.c                      | 11 ++++----
 10 files changed, 52 insertions(+), 98 deletions(-)

-- 
2.11.0
