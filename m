From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 0/3] kvm: arm/arm64: Fixes for use after free problems
Date: Thu, 16 Mar 2017 18:20:48 +0000
Message-ID: <1489688451-17520-1-git-send-email-suzuki.poulose@arm.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, andreyknvl@google.com
Cc: dvyukov@google.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kcc@google.com, syzkaller@googlegroups.com, will.deacon@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, mark.rutland@arm.com, suzuki.poulose@arm.com, ard.biesheuvel@linaro.org, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This series contains potential fixes for problems reported by [0] & [1].

[0] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-March/492944.html
[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-March/492943.html

Changes since V1:
 - Yield the kvm->mmu_lock if necessary in unmap_stage2_range to prevent
   vCPU starvation and lockup detector warnings.

Marc Zyngier (2):
  kvm: arm/arm64: Take mmap_sem in stage2_unmap_vm
  kvm: arm/arm64: Take mmap_sem in kvm_arch_prepare_memory_region

Suzuki K Poulose (1):
  kvm: arm/arm64: Fix locking for kvm_free_stage2_pgd

 arch/arm/kvm/mmu.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

-- 
2.7.4
