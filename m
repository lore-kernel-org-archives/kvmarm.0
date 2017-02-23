From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 00/22] arm/arm64: KVM: Rework the hyp-stub API
Date: Thu, 23 Feb 2017 10:26:35 +0000
Message-ID: <20170223102657.23100-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
- Add some API documentation that covers the above
- Some general cleanup as a result of these changes.

Patches 9 to 11 would be better squashed into 7 and 8, but I've kept
separate so that I can take the blame for everything I've broken.

This has been tested on arm (Cubietruck, Jetson TK1) and arm64
(Seattle), both as host and guest.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-December/473472.html

* From v1:
  - Fixed some glaring bugs (reported by Ard and James)
  - Tidy up stub vector export on 32bit (Ard)
  - Nicer VA/PA conversion on 32bit (Ard)
  - Updated cpu_v7_reset documentation
  - Cleaned up HYP reset on PM events
  - Minor stub documentation update

Marc Zyngier (20):
  arm64: hyp-stub: Implement HVC_RESET_VECTORS stub hypercall
  arm64: KVM: Implement HVC_RESET_VECTORS stub hypercall
  arm64: KVM: Implement HVC_GET_VECTORS in the init code
  arm64: KVM: Allow the main HYP code to use the init hyp stub
    implementation
  arm64: KVM: Convert __cpu_reset_hyp_mode to using __hyp_reset_vectors
  arm64: KVM: Implement HVC_SOFT_RESTART in the init code
  ARM: KVM: Convert KVM to use HVC_GET_VECTORS
  ARM: Update cpu_v7_reset documentation
  ARM: hyp-stub: Use r1 for the soft-restart address
  ARM: Expose the VA/IDMAP offset
  ARM: hyp-stub: Implement HVC_RESET_VECTORS stub hypercall
  ARM: KVM: Implement HVC_RESET_VECTORS stub hypercall
  ARM: KVM: Implement HVC_GET_VECTORS in the init code
  ARM: KVM: Allow the main HYP code to use the init hyp stub
    implementation
  ARM: KVM: Convert __cpu_reset_hyp_mode to using __hyp_reset_vectors
  ARM: KVM: Implement HVC_SOFT_RESTART in the init code
  arm/arm64: KVM: Use __hyp_reset_vectors() directly
  arm/arm64: KVM: Remove kvm_get_idmap_start
  arm/arm64: KVM: Use HVC_RESET_VECTORS to reinit HYP mode
  arm/arm64: Add hyp-stub API documentation

Russell King (2):
  ARM: hyp-stub: improve ABI
  ARM: soft-reboot into same mode that we entered the kernel

 Documentation/virtual/kvm/arm/hyp-abi.txt | 49 ++++++++++++++++++++++++++++
 arch/arm/include/asm/kvm_asm.h            |  2 --
 arch/arm/include/asm/kvm_host.h           |  6 ----
 arch/arm/include/asm/kvm_mmu.h            |  1 -
 arch/arm/include/asm/proc-fns.h           |  4 +--
 arch/arm/include/asm/virt.h               | 12 +++++++
 arch/arm/kernel/hyp-stub.S                | 46 ++++++++++++++++++++++----
 arch/arm/kernel/reboot.c                  |  7 ++--
 arch/arm/kvm/arm.c                        | 25 ++++++--------
 arch/arm/kvm/hyp/hyp-entry.S              | 29 ++++++++++++++---
 arch/arm/kvm/init.S                       | 54 ++++++++++++++++++++++++++-----
 arch/arm/kvm/mmu.c                        |  5 ---
 arch/arm/mm/mmu.c                         |  5 +++
 arch/arm/mm/proc-v7.S                     | 15 ++++++---
 arch/arm64/include/asm/kvm_asm.h          |  1 -
 arch/arm64/include/asm/kvm_host.h         |  7 ----
 arch/arm64/include/asm/kvm_mmu.h          |  1 -
 arch/arm64/include/asm/virt.h             |  9 ++++++
 arch/arm64/kernel/hyp-stub.S              | 13 +++++++-
 arch/arm64/kvm/hyp-init.S                 | 50 ++++++++++++++++++++++------
 arch/arm64/kvm/hyp/hyp-entry.S            | 39 +++++++++++-----------
 21 files changed, 282 insertions(+), 98 deletions(-)
 create mode 100644 Documentation/virtual/kvm/arm/hyp-abi.txt

-- 
2.11.0
