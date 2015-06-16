From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v2 0/2] arm/arm64: KVM: Optimize arm64 fp/simd,
 saves 30-50% on exits
Date: Tue, 16 Jun 2015 14:50:50 -0700
Message-ID: <1434491452-19177-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, Mario Smarduch <m.smarduch@samsung.com>
List-Id: kvmarm@lists.cs.columbia.edu

Currently we save/restore fp/simd on each exit. Fist  patch optimizes arm64 
save/restore, we only do so on Guest access. hackbench and
several lmbench tests show anywhere from 30% to above 50% optimzation
achieved.

In second patch 32-bit handler is updated to keep exit handling consistent 
with 64-bit code.

Changes since v1:
- Addressed Marcs comments
- Verified optimization improvements with lmbench and hackbench, updated 
  commit message

Mario Smarduch (2):
  Optimize arm64 skip 30-50% vfp/simd save/restore on exits
  keep arm vfp/simd exit handling in sync with arm64

 arch/arm/kvm/interrupts.S        |   12 +++++-----
 arch/arm64/include/asm/kvm_arm.h |    5 ++++-
 arch/arm64/kvm/hyp.S             |   46 +++++++++++++++++++++++++++++++++++---
 3 files changed, 54 insertions(+), 9 deletions(-)

-- 
1.7.9.5

