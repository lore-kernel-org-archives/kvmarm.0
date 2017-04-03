From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 00/34] arm/arm64: KVM: Rework the hyp-stub API
Date: Mon,  3 Apr 2017 19:37:33 +0100
Message-ID: <20170403183807.1620-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDB3540190
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:36:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8vEqWgvifoN3 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Apr 2017 14:36:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09BC440017
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:36:20 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Keerthy <j-keerthy@ti.com>
List-Id: kvmarm@lists.cs.columbia.edu

As noticed by RMK in this thread[1], the hyp-stub API on 32bit ARM
could do with some TLC (it cannot perform a soft-restart at HYP, and
has holes in the hyp-stub support in a number of places). In general,
it would be desirable for the 32bit behaviour to align on 64bit, if
only to ease maintenance.

This series implements the following:
- Add HVC_[GS]ET_VECTORS and HVC_SOFT_RESTART to the 32bit code
- Add HVC_RESET_VECTORS to both arm and arm64, removing the need for
  __hyp_reset_vectors
- Implement add the stub entry points in the KVM init code, which
  didn't implement any so far
- Convert the HYP code to use the init code stubs directly
- Some general cleanup as a result of these changes (which includes
  killing HVC_GET_VECTORS)
- Add some API documentation that covers the above

Patches 14 to 16 would be better squashed into 12 and 13, but I've
kept them separate so that I can take the blame for everything I've
broken.

I've tested this on arm (Cubietruck, Jetson TK1) and arm64 (Seattle),
both as host and guest. Keerthy has been kind enough to test the 32bit
code on DRA7-EVM, AM57XX-EVM and KEYSTONE-K2E-EVM.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-December/473472.html

* From v4:
  - Added a standard return value on stub hypercall failure
  - Zero r0/x0 on successful hypercall
  - Make 32bit ARM resistant to kvm_reboot while executing a guest
  - Update documentation to reflect the calling convention expectations
  - Added Acks from Catalin
  - Rebased on 4.11-rc5

* From v3:
  - Reworked the way we save/restore lr on arm64, making it EL2's job
  in a consistent way (these are the three initial patches)
  - Collected RBs, TBs and Acks from James, Keerthy and Russell
  - Rebased on 4.11-rc3

* From v2:
  - Kill HVC_GET_VECTORS and the corresponding __hyp_get_vectors

* From v1:
  - Fixed some glaring bugs (reported by Ard and James)
  - Tidy up stub vector export on 32bit (Ard)
  - Nicer VA/PA conversion on 32bit (Ard)
  - Updated cpu_v7_reset documentation
  - Cleaned up HYP reset on PM events
  - Minor stub documentation update

Marc Zyngier (32):
  arm64: hyp-stub: Stop pointlessly clobbering lr
  arm64: KVM: Move lr save/restore to do_el2_call
  arm64: hyp-stub: Don't save lr in the EL1 code
  arm64: hyp-stub: Define a return value for failed stub calls
  arm64: hyp-stub: Update documentation in asm/virt.h
  arm64: hyp-stub: Implement HVC_RESET_VECTORS stub hypercall
  arm64: KVM: Implement HVC_RESET_VECTORS stub hypercall in the init
    code
  arm64: KVM: Implement HVC_GET_VECTORS in the init code
  arm64: KVM: Allow the main HYP code to use the init hyp stub
    implementation
  arm64: KVM: Convert __cpu_reset_hyp_mode to using __hyp_reset_vectors
  arm64: KVM: Implement HVC_SOFT_RESTART in the init code
  ARM: KVM: Convert KVM to use HVC_GET_VECTORS
  ARM: Update cpu_v7_reset documentation
  ARM: hyp-stub: Use r1 for the soft-restart address
  ARM: Expose the VA/IDMAP offset
  ARM: hyp-stub: Define a return value for failed stub calls
  ARM: hyp-stub: Implement HVC_RESET_VECTORS stub hypercall
  ARM: KVM: Implement HVC_RESET_VECTORS stub hypercall in the init code
  ARM: KVM: Implement HVC_GET_VECTORS in the init code
  ARM: KVM: Allow the main HYP code to use the init hyp stub
    implementation
  ARM: KVM: Convert __cpu_reset_hyp_mode to using __hyp_reset_vectors
  ARM: KVM: Implement HVC_SOFT_RESTART in the init code
  ARM: KVM: Gracefully handle hyp-stubs being restored from under our
    feet
  arm/arm64: KVM: Use __hyp_reset_vectors() directly
  arm/arm64: KVM: Remove kvm_get_idmap_start
  arm/arm64: KVM: Use HVC_RESET_VECTORS to reinit HYP mode
  ARM: decompressor: Remove __hyp_get_vectors usage
  ARM: hyp-stub/KVM: Kill __hyp_get_vectors
  arm64: hyp-stub/KVM: Kill __hyp_get_vectors
  arm64: hyp-stub: Zero x0 on successful stub handling
  ARM: hyp-stub: Zero r0 on successful stub handling
  arm/arm64: Add hyp-stub API documentation

Russell King (2):
  ARM: hyp-stub: improve ABI
  ARM: soft-reboot into same mode that we entered the kernel

 Documentation/virtual/kvm/arm/hyp-abi.txt | 53 +++++++++++++++++++++++++++++++
 arch/arm/boot/compressed/head.S           | 12 ++++++-
 arch/arm/include/asm/kvm_asm.h            |  4 +--
 arch/arm/include/asm/kvm_host.h           |  6 ----
 arch/arm/include/asm/kvm_mmu.h            |  1 -
 arch/arm/include/asm/proc-fns.h           |  4 +--
 arch/arm/include/asm/virt.h               | 14 +++++++-
 arch/arm/kernel/hyp-stub.S                | 41 +++++++++++++++++++-----
 arch/arm/kernel/reboot.c                  |  7 ++--
 arch/arm/kvm/arm.c                        | 25 ++++++---------
 arch/arm/kvm/handle_exit.c                |  8 +++++
 arch/arm/kvm/hyp/hyp-entry.S              | 29 ++++++++++++++---
 arch/arm/kvm/init.S                       | 51 ++++++++++++++++++++++++-----
 arch/arm/kvm/interrupts.S                 |  4 ---
 arch/arm/kvm/mmu.c                        |  5 ---
 arch/arm/mm/mmu.c                         |  5 +++
 arch/arm/mm/proc-v7.S                     | 15 ++++++---
 arch/arm64/include/asm/kvm_asm.h          |  3 +-
 arch/arm64/include/asm/kvm_host.h         |  7 ----
 arch/arm64/include/asm/kvm_mmu.h          |  1 -
 arch/arm64/include/asm/virt.h             | 31 ++++++++++++------
 arch/arm64/kernel/hyp-stub.S              | 38 ++++++++--------------
 arch/arm64/kvm/hyp-init.S                 | 46 +++++++++++++++++++++------
 arch/arm64/kvm/hyp.S                      |  5 +--
 arch/arm64/kvm/hyp/hyp-entry.S            | 43 ++++++++++++-------------
 25 files changed, 312 insertions(+), 146 deletions(-)
 create mode 100644 Documentation/virtual/kvm/arm/hyp-abi.txt

-- 
2.11.0
