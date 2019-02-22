From: Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v1 0/4] ARM64/KVM: Minor cleanup and refactoring
Date: Fri, 22 Feb 2019 16:23:22 +0800
Message-ID: <20190222082327.3312-1-leo.yan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Andre Przywara <andre.przywara@arm.com>, Jun Yao <yaojun8558363@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Cc: Leo Yan <leo.yan@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

When I read KVM/ARM64 related code I cannot find any issue or something
could be improved for performance; so this patch series is only for
minor cleaning up and refactoring code.

Hope this is helpful and can be picked up into mainline kernel,
otherwise it's also fine for me if the maintainer or main developers
could note these points and fix them in appropriate time.


Leo Yan (4):
  KVM: arm64: Use macro to replace hard number
  KVM: arm/arm64: vgic: Improve comment on kvm_vgic_inject_irq
  KVM: arm/arm64: Define TCR_EL2_T0SZ_MASK as TCR_T0SZ_MASK
  KVM: arm/arm64: Fix comment on create_hyp_mappings()

 arch/arm64/include/asm/kvm_arm.h | 2 +-
 arch/arm64/kernel/head.S         | 2 +-
 virt/kvm/arm/mmu.c               | 2 +-
 virt/kvm/arm/vgic/vgic.c         | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.17.1
