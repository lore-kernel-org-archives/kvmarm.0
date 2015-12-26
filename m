From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v6 0/6] arm/arm64: KVM: Enhance armv7/8 fp/simd lazy switch
Date: Sat, 26 Dec 2015 13:54:54 -0800
Message-ID: <1451166900-3711-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Mario Smarduch <m.smarduch@samsung.com>
List-Id: kvmarm@lists.cs.columbia.edu

Current lazy fp/simd implementation switches hardware context on guest access 
and again on exit to host, otherwise context switch is skipped. This patch 
set builds on that functionality and executes a hardware context switch on 
first time access and when vCPU is scheduled out or returns to user space (on 
vcpu_put).

For an FP and lmbench load it reduces fp/simd context switch from 30-50% down
to near 0%. Results will vary with load but is no worse then current
approach.

Running floating point application on nearly idle system:
./tst-float 100000uS - (sleep for .1s) fp/simd switch reduced by 99%+
./tst-float 10000uS -  (sleep for 10 ms)              reduced by 98%+
./tst-float 1000uS -   (sleep for 1ms)                reduced by ~98%
...
./tst-float 1uS -                                     reduced by  2%+

Tested on Juno, Foundation Model, and Fast Models. 

Test Details:
-------------
armv7 - with CONFIG_VFP, CONFIG_NEON, CONFIG_KERNEL_MODE_NEON options enabled:

- On host executed 12 fp applications - with ranging sleep intervals
- Two guests - with 12 fp processes  - with ranging sleep intervals

armv8 
- Similar to armv7, with mix of 32 and 64 bit guests - on Juno ran 2-32bit and
  2-64 bit guests.

These patches are based on earlier arm64 fp/simd optimization work -
https://lists.cs.columbia.edu/pipermail/kvmarm/2015-July/015748.html

And subsequent fixes by Marc and Christoffer at KVM Forum hackathon to handle
32-bit guest on 64 bit host - 
https://lists.cs.columbia.edu/pipermail/kvmarm/2015-August/016128.html

Changes since v5->v6:
- Followed up on Christoffers comments
  o armv7 - replaced fp/simd asm with supported function calls 
  o armv7 - save hcptr once on access instead of every exit
  o armv7 - removed hcptr macro
  o armv7 - fixed twisted boolean return logic
  o armv7 - removed isb after setting fpexec32 since its followed with a 
            hyp call
  o armv8 - rebased to 4.4-rc5 - wsinc
  o armv8 - as with hpctpr save cptr_el2 on access instead of every exit
  o armv7/armv8 - restructured patch series to simplify review 

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

Mario Smarduch (6):
  Introduce armv7 fp/simd vcpu fields and helpers
  Introduce host fp/simd context switch function
  Enable armv7 fp/simd enhanced context switch
  Deleted unused macros
  Introduce armv8 fp/simd vcpu fields and helpers
  Enable armv8 fp/simd enhanced context switch

 arch/arm/include/asm/kvm_emulate.h   | 54 ++++++++++++++++++++++++++++++++++++
 arch/arm/include/asm/kvm_host.h      |  8 ++++++
 arch/arm/kernel/asm-offsets.c        |  1 +
 arch/arm/kvm/Makefile                |  2 +-
 arch/arm/kvm/arm.c                   | 19 +++++++++++++
 arch/arm/kvm/fpsimd_switch.S         | 47 +++++++++++++++++++++++++++++++
 arch/arm/kvm/interrupts.S            | 43 ++++++++++------------------
 arch/arm/kvm/interrupts_head.S       | 29 -------------------
 arch/arm64/include/asm/kvm_asm.h     |  5 ++++
 arch/arm64/include/asm/kvm_emulate.h | 30 ++++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h    | 12 ++++++++
 arch/arm64/kernel/asm-offsets.c      |  1 +
 arch/arm64/kvm/hyp/entry.S           |  1 +
 arch/arm64/kvm/hyp/hyp-entry.S       | 26 +++++++++++++++++
 arch/arm64/kvm/hyp/switch.c          | 26 ++---------------
 15 files changed, 222 insertions(+), 82 deletions(-)
 create mode 100644 arch/arm/kvm/fpsimd_switch.S

-- 
1.9.1

