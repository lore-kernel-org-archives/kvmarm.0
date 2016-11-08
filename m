From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v3 0/2] arm64: Support systems without FP/ASIMD
Date: Tue,  8 Nov 2016 13:56:19 +0000
Message-ID: <1478613381-5718-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2091402AF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2016 08:56:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q2yW8bIm5nwJ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Nov 2016 08:56:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43BA94019C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2016 08:56:21 -0500 (EST)
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
Cc: ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This series adds supports to the kernel and KVM hyp to handle
systems without FP/ASIMD properly. At the moment the kernel
doesn't check if the FP unit is available before accessing
the registers (e.g during context switch). Also for KVM,
we trap the FP/ASIMD accesses and handle it by injecting an
undefined instruction into the VM on systems without FP.

Tested on a FVP_Base-AEM-v8A model by disabling VFP on at
least one CPU ( -C clusterX.cpuY.vfp-present=0 ).

Changes since V2:
 - Dropped cleanup patch for arm64/crypto/aes-ce-ccm-glue.c
 - Removed static_key check from cpus_have_cap. All users with
   constant caps should use the new API to make use of static_keys.
 - Removed a dedicated static_key used in irqchip-gic-v3.c for
   Cavium errata with the new API.

Applies on v4.9-rc4 + [1] (which is pushed for rc5)

[1] http://marc.info/?l=linux-arm-kernel&m=147819889813214&w=2


Suzuki K Poulose (2):
  arm64: Add hypervisor safe helper for checking constant capabilities
  arm64: Support systems without FP/ASIMD

 arch/arm64/include/asm/cpucaps.h    |  3 ++-
 arch/arm64/include/asm/cpufeature.h | 24 +++++++++++++++++-------
 arch/arm64/include/asm/neon.h       |  3 ++-
 arch/arm64/kernel/cpufeature.c      | 17 ++++++++++++++++-
 arch/arm64/kernel/fpsimd.c          | 14 ++++++++++++++
 arch/arm64/kernel/process.c         |  2 +-
 arch/arm64/kvm/handle_exit.c        | 11 +++++++++++
 arch/arm64/kvm/hyp/hyp-entry.S      |  9 ++++++++-
 arch/arm64/kvm/hyp/switch.c         |  5 ++++-
 drivers/irqchip/irq-gic-v3.c        | 13 +------------
 10 files changed, 76 insertions(+), 25 deletions(-)

-- 
2.7.4
