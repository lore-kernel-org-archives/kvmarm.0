From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v5 0/3] KVM/arm/arm64: enhance armv7/8 fp/simd lazy switch
Date: Sun, 06 Dec 2015 17:07:11 -0800
Message-ID: <1449450434-2929-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Mario Smarduch <m.smarduch@samsung.com>
List-Id: kvmarm@lists.cs.columbia.edu

This patch series combines the previous armv7 and armv8 versions.
For an FP and lmbench load it reduces fp/simd context switch from 30-50% down
to near 0%. Results will vary with load but is no worse then current
approach.

In summary current lazy vfp/simd implementation switches hardware context only
on guest access and again on exit to host, otherwise hardware context is
skipped. This patch set builds on that functionality and executes a hardware
context switch only when  vCPU is scheduled out or returns to user space.

Running floating point app on nearly idle system:
./tst-float 100000uS - (sleep for .1s) fp/simd switch reduced by 99%+
./tst-float 10000uS -  (sleep for .01s)               reduced by 98%+
./tst-float 1000uS -   (sleep for 1ms)                reduced by ~98%
...
./tst-float 1uS -                                     reduced by  2%+

Tested on FastModels and Foundation Model (need to test on Juno)

Tests Ran:
----------
armv7 - with CONFIG_VFP, CONFIG_NEON, CONFIG_KERNEL_MODE_NEON options enabled:

- On host executed 12 fp applications - evenly pinned to cpus
- Two guests - with 12 fp processes - also pinned to vpus.
- Executing with various sleep intervals to measure ration between exits
  and fp/simd switch

armv8:
-  added mix of armv7 and armv8 guests.

These patches are based on earlier arm64 fp/simd optimization work -
https://lists.cs.columbia.edu/pipermail/kvmarm/2015-July/015748.html

And subsequent fixes by Marc and Christoffer at KVM Forum hackathon to handle
32-bit guest on 64 bit host - 
https://lists.cs.columbia.edu/pipermail/kvmarm/2015-August/016128.html

Chances since v4->v5:
- Followed up on Marcs comments
  - Removed dirty flag, and used trap bits to check for dirty fp/simd
  - Seperated host form hyp code
  - As a consequence for arm64 added a commend assember header file
  - Fixed up critical accesses to fpexec, and added isb
  - Converted defines to inline functions

Changes since v3->v4:
- Followup on Christoffers comments 
  - Move fpexc handling to vcpu_load and vcpu_put
  - Enable and restore fpexc in EL2 mode when running a 32 bit guest on
    64bit EL2
  - rework hcptr handling

Changes since v2->v3:
- combined arm v7 and v8 into one short patch series
- moved access to fpexec_el2 back to EL2
- Move host restore to EL1 from EL2 and call directly from host
- optimize trap enable code 
- renamed some variables to match usage

Changes since v1->v2:
- Fixed vfp/simd trap configuration to enable trace trapping
- Removed set_hcptr branch label
- Fixed handling of FPEXC to restore guest and host versions on vcpu_put
- Tested arm32/arm64
- rebased to 4.3-rc2
- changed a couple register accesses from 64 to 32 bit


Mario Smarduch (3):
  add hooks for armv7 fp/simd lazy switch support
  enable enhanced armv7 fp/simd lazy switch
  enable enhanced armv8 fp/simd lazy switch

 arch/arm/include/asm/kvm_emulate.h   |  55 ++++++++++++++++++
 arch/arm/include/asm/kvm_host.h      |   9 +++
 arch/arm/kernel/asm-offsets.c        |   2 +
 arch/arm/kvm/Makefile                |   2 +-
 arch/arm/kvm/arm.c                   |  25 ++++++++
 arch/arm/kvm/fpsimd_switch.S         |  46 +++++++++++++++
 arch/arm/kvm/interrupts.S            |  32 +++--------
 arch/arm/kvm/interrupts_head.S       |  33 +++++------
 arch/arm64/include/asm/kvm_asm.h     |   2 +
 arch/arm64/include/asm/kvm_emulate.h |  16 ++++++
 arch/arm64/include/asm/kvm_host.h    |  15 +++++
 arch/arm64/kernel/asm-offsets.c      |   1 +
 arch/arm64/kvm/Makefile              |   3 +-
 arch/arm64/kvm/fpsimd_switch.S       |  38 ++++++++++++
 arch/arm64/kvm/hyp.S                 | 108 +++++++++++++----------------------
 arch/arm64/kvm/hyp_head.S            |  48 ++++++++++++++++
 16 files changed, 322 insertions(+), 113 deletions(-)
 create mode 100644 arch/arm/kvm/fpsimd_switch.S
 create mode 100644 arch/arm64/kvm/fpsimd_switch.S
 create mode 100644 arch/arm64/kvm/hyp_head.S

-- 
1.9.1

