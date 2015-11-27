From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 00/21] arm64: KVM: world switch in C
Date: Fri, 27 Nov 2015 18:49:54 +0000
Message-ID: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BF4D411BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2015 13:49:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8vHF6s-7Yewg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Nov 2015 13:49:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EDB3409A2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2015 13:49:17 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Once upon a time, the KVM/arm64 world switch was a nice, clean, lean
and mean piece of hand-crafted assembly code. Over time, features have
crept in, the code has become harder to maintain, and the smallest
change is a pain to introduce. The VHE patches are a prime example of
why this doesn't work anymore.

This series rewrites most of the existing assembly code in C, but keeps
the existing code structure in place (most function names will look
familiar to the reader). The biggest change is that we don't have to
deal with a static register allocation (the compiler does it for us),
we can easily follow structure and pointers, and only the lowest level
is still in assembly code. Oh, and a negative diffstat.

There is still a healthy dose of inline assembly (system register
accessors, runtime code patching), but I've tried not to make it too
invasive. The generated code, while not exactly brilliant, doesn't
look too shaby. I do expect a small performance degradation, but I
believe this is something we can improve over time (my initial
measurements don't show any obvious regression though).

Eventually (and assuming people are happy with the general approach
taken here), it should be possible to make the 32bit converge with
this and reuse some parts of the code.

Patches are against 4.4-rc2 (mostly), and I've pushed a branch out
(kvm-arm64/wsinc). This has been tested on Juno, Seattle and the FVP
model. I also have pushed out kvm-arm64/vhe-wsinc that implements VHE
on top of these patches.

* From v1:
  - A number of bugs have been squashed: vgic, FP/SIMD, debug, panic
    (thanks to Mark, Steve, Ard and Alex for their reviews)
  - Rebased on 4.4-rc2 plus KVM fixes aimed at -rc3 plus a couple
    of gic-v3 fixes

Marc Zyngier (20):
  arm64: KVM: Add a HYP-specific header file
  arm64: KVM: Implement vgic-v2 save/restore
  arm64: KVM: Implement vgic-v3 save/restore
  arm64: KVM: Implement timer save/restore
  arm64: KVM: Implement system register save/restore
  arm64: KVM: Implement 32bit system register save/restore
  arm64: KVM: Implement debug save/restore
  arm64: KVM: Implement guest entry
  arm64: KVM: Add patchable function selector
  arm64: KVM: Implement the core world switch
  arm64: KVM: Implement fpsimd save/restore
  arm64: KVM: Implement TLB handling
  arm64: KVM: HYP mode entry points
  arm64: KVM: Add panic handling
  arm64: KVM: Add compatibility aliases
  arm64: KVM: Map the kernel RO section into HYP
  arm64: KVM: Move away from the assembly version of the world switch
  arm64: KVM: Turn system register numbers to an enum
  arm64: KVM: Cleanup asm-offset.c
  arm64: KVM: Remove weak attributes

Mark Rutland (1):
  arm64: Add macros to read/write system registers

 arch/arm/kvm/arm.c                   |    7 +
 arch/arm64/include/asm/kvm_asm.h     |   76 ---
 arch/arm64/include/asm/kvm_emulate.h |    1 -
 arch/arm64/include/asm/kvm_host.h    |   81 ++-
 arch/arm64/include/asm/kvm_mmio.h    |    1 -
 arch/arm64/include/asm/sysreg.h      |   17 +
 arch/arm64/kernel/asm-offsets.c      |   40 +-
 arch/arm64/kvm/Makefile              |    3 +-
 arch/arm64/kvm/guest.c               |    1 -
 arch/arm64/kvm/handle_exit.c         |    1 +
 arch/arm64/kvm/hyp.S                 | 1081 +---------------------------------
 arch/arm64/kvm/hyp/Makefile          |   14 +
 arch/arm64/kvm/hyp/debug-sr.c        |  133 +++++
 arch/arm64/kvm/hyp/entry.S           |  184 ++++++
 arch/arm64/kvm/hyp/fpsimd.S          |   33 ++
 arch/arm64/kvm/hyp/hyp-entry.S       |  207 +++++++
 arch/arm64/kvm/hyp/hyp.h             |   80 +++
 arch/arm64/kvm/hyp/switch.c          |  174 ++++++
 arch/arm64/kvm/hyp/sysreg-sr.c       |  132 +++++
 arch/arm64/kvm/hyp/timer-sr.c        |   71 +++
 arch/arm64/kvm/hyp/tlb.c             |   79 +++
 arch/arm64/kvm/hyp/vgic-v2-sr.c      |   89 +++
 arch/arm64/kvm/hyp/vgic-v3-sr.c      |  224 +++++++
 arch/arm64/kvm/sys_regs.c            |    1 +
 arch/arm64/kvm/vgic-v2-switch.S      |  134 -----
 arch/arm64/kvm/vgic-v3-switch.S      |  269 ---------
 include/clocksource/arm_arch_timer.h |    6 +
 virt/kvm/arm/vgic-v3.c               |    1 +
 28 files changed, 1536 insertions(+), 1604 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/Makefile
 create mode 100644 arch/arm64/kvm/hyp/debug-sr.c
 create mode 100644 arch/arm64/kvm/hyp/entry.S
 create mode 100644 arch/arm64/kvm/hyp/fpsimd.S
 create mode 100644 arch/arm64/kvm/hyp/hyp-entry.S
 create mode 100644 arch/arm64/kvm/hyp/hyp.h
 create mode 100644 arch/arm64/kvm/hyp/switch.c
 create mode 100644 arch/arm64/kvm/hyp/sysreg-sr.c
 create mode 100644 arch/arm64/kvm/hyp/timer-sr.c
 create mode 100644 arch/arm64/kvm/hyp/tlb.c
 create mode 100644 arch/arm64/kvm/hyp/vgic-v2-sr.c
 create mode 100644 arch/arm64/kvm/hyp/vgic-v3-sr.c
 delete mode 100644 arch/arm64/kvm/vgic-v2-switch.S
 delete mode 100644 arch/arm64/kvm/vgic-v3-switch.S

-- 
2.1.4
