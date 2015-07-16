From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v4 0/2] arm/arm64: KVM: Optimize arm64 fp/simd,
 saves 30-50% on exits
Date: Thu, 16 Jul 2015 14:29:36 -0700
Message-ID: <1437082178-11039-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Mario Smarduch <m.smarduch@samsung.com>
List-Id: kvmarm@lists.cs.columbia.edu

Currently we save/restore fp/simd on each exit. The first patch optimizes arm64
save/restore, we only do so on Guest access. hackbench and several lmbench
tests show anywhere from 30% to 50% of exits don't context switch the vfp/simd
registers.

For second patch 32-bit handler is updated to keep exit handling consistent
with 64-bit code.

Changes since v3:
- Per Christoffers comment - changed comment for skip fp/simd in patch 1/2
- Changed cover text, clarify optimization in the context of this patch 

Changes since v2:
- Only for patch 2/2
  - Removed load_vcpu in switch_to_guest_vfp per Marcs comment
  - Got another chance to replace an unreferenced label with a comment

Changes since v1:
- only for patch 2/2
  - Reworked trapping to vfp access handler

Changes since inital version:
- Addressed Marcs comments
- Verified optimization improvements with lmbench and hackbench, updated
  commit message


Mario Smarduch (2):
  Optimize arm64 skip 30-50% vfp/simd save/restore on exits
  keep arm vfp/simd exit handling consistent with arm64

 arch/arm/kvm/interrupts.S        | 14 +++++++------
 arch/arm64/include/asm/kvm_arm.h |  5 ++++-
 arch/arm64/kvm/hyp.S             | 45 +++++++++++++++++++++++++++++++++++++---
 3 files changed, 54 insertions(+), 10 deletions(-)

-- 
1.9.1

