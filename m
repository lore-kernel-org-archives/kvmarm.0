From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 0/2] arm64: Support systems without FP/ASIMD
Date: Tue, 25 Oct 2016 14:50:31 +0100
Message-ID: <1477403433-2279-1-git-send-email-suzuki.poulose@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, ard.biesheuvel@linaro.org, mark.rutland@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This series adds supports to the kernel and KVM hyp to handle
systems without FP/ASIMD properly. At the moment the kernel
doesn't check if the FP unit is available before accessing
the registers (e.g during context switch). Also for KVM,
we trap the FP/ASIMD accesses and handle it by injecting an
undefined instruction into the VM on systems without FP.

Tested on a FVP_Base-AEM-v8A model by disabling VFP on at
least one CPU ( -C clusterX.cpuY.vfp-present=0 ).

Suzuki K Poulose (2):
  arm64: Add hypervisor safe helper for checking constant capabilities
  arm64: Support systems without FP/ASIMD

 arch/arm64/crypto/aes-ce-ccm-glue.c |  2 +-
 arch/arm64/crypto/aes-ce-cipher.c   |  2 ++
 arch/arm64/crypto/ghash-ce-glue.c   |  2 ++
 arch/arm64/crypto/sha1-ce-glue.c    |  2 ++
 arch/arm64/include/asm/cpufeature.h | 24 ++++++++++++++++++++----
 arch/arm64/include/asm/neon.h       |  3 ++-
 arch/arm64/kernel/cpufeature.c      | 15 +++++++++++++++
 arch/arm64/kernel/fpsimd.c          | 14 ++++++++++++++
 arch/arm64/kvm/handle_exit.c        | 11 +++++++++++
 arch/arm64/kvm/hyp/hyp-entry.S      |  9 ++++++++-
 arch/arm64/kvm/hyp/switch.c         |  5 ++++-
 11 files changed, 81 insertions(+), 8 deletions(-)

-- 
2.7.4
