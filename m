From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 37/40] KVM: arm/arm64: Move arm64-only vgic-v2-sr.c file to arm64
Date: Thu, 15 Feb 2018 22:03:29 +0100
Message-ID: <20180215210332.8648-38-christoffer.dall@linaro.org>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180215210332.8648-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Dave Martin <Dave.Martin@arm.com>, Julien Grall <julien.grall@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Yury Norov <ynorov@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

The vgic-v2-sr.c file now only contains the logic to replay unaligned
accesses to the virtual CPU interface on 16K and 64K page systems, which
is only relevant on 64-bit platforms.  Therefore move this file to the
arm64 KVM tree, remove the compile directive from the 32-bit side
makefile, and remove the ifdef in the C file.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/hyp/Makefile                         | 1 -
 arch/arm64/kvm/hyp/Makefile                       | 2 +-
 {virt/kvm/arm => arch/arm64/kvm}/hyp/vgic-v2-sr.c | 2 --
 3 files changed, 1 insertion(+), 4 deletions(-)
 rename {virt/kvm/arm => arch/arm64/kvm}/hyp/vgic-v2-sr.c (98%)

diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
index 5638ce0c9524..1964111c984a 100644
--- a/arch/arm/kvm/hyp/Makefile
+++ b/arch/arm/kvm/hyp/Makefile
@@ -7,7 +7,6 @@ ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING
 
 KVM=../../../../virt/kvm
 
-obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v2-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v3-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/timer-sr.o
 
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index f04400d494b7..7e8d41210288 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -7,10 +7,10 @@ ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING
 
 KVM=../../../../virt/kvm
 
-obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v2-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v3-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/timer-sr.o
 
+obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += sysreg-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += debug-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += entry.o
diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/arch/arm64/kvm/hyp/vgic-v2-sr.c
similarity index 98%
rename from virt/kvm/arm/hyp/vgic-v2-sr.c
rename to arch/arm64/kvm/hyp/vgic-v2-sr.c
index 0bbafdfd4adb..97f357ea9c72 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-sr.c
@@ -23,7 +23,6 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
-#ifdef CONFIG_ARM64
 /*
  * __vgic_v2_perform_cpuif_access -- perform a GICV access on behalf of the
  *				     guest.
@@ -77,4 +76,3 @@ int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 
 	return 1;
 }
-#endif
-- 
2.14.2
