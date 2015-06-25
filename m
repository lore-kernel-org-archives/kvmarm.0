From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH 0/3] arm: KVM: VFP lazy switch in KVM Host Mode may save upto
 98%
Date: Wed, 24 Jun 2015 20:30:25 -0700
Message-ID: <1435203028-23142-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, pbonzini@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, Mario Smarduch <m.smarduch@samsung.com>
List-Id: kvmarm@lists.cs.columbia.edu

Currently we do a lazy VFP switch in Hyp mode, but once we exit and re-enter hyp
mode we trap again on VFP access. This mode has shown around 30-50% improvement
running hackbench and lmbench.

This patch series extends lazy VFP switch beyond Hyp mode to KVM host mode.

1 - On guest access we switch from host to guest and set a flag accessible to 
    host
2 - On exit to KVM host, VFP state is restored on vcpu_put if flag is marked (1)
3 - Otherwise guest is resumed and continues to use its VFP registers. 
4 - In case of 2 on VM entry we set VFP trap flag to repeat 1.

If guest does not access VFP registers them implemenation remains the same.

Executing hackbench on Fast Models and Exynos arm32 board shows good
results. Considering all exits 2% of the time KVM host lazy vfp switch is 
invoked.

Howeverr this patch set requires more burn in time and testing under various 
loads.

Currently ARM32 is addressed later ARM64.

Mario Smarduch (3):
  define headers and offsets to mange VFP state
  Implement lazy VFP switching outside of Hyp Mode
  Add VFP lazy switch hooks in Host KVM

 arch/arm/include/asm/kvm_asm.h  |    1 +
 arch/arm/include/asm/kvm_host.h |    3 +++
 arch/arm/kernel/asm-offsets.c   |    1 +
 arch/arm/kvm/arm.c              |   15 ++++++++++++
 arch/arm/kvm/interrupts.S       |   49 +++++++++++++++++++++++++--------------
 5 files changed, 51 insertions(+), 18 deletions(-)

-- 
1.7.9.5

