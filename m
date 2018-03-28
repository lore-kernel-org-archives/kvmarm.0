From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 50/85] KVM: arm/arm64: Move arm64-only vgic-v2-sr.c file to
 arm64
Date: Wed, 28 Mar 2018 13:52:19 +0100
Message-ID: <20180328125254.31380-51-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 264FD40683
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:53:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OkH+uFLsBSeK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:52:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB0A649EA2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:48:23 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

The vgic-v2-sr.c file now only contains the logic to replay unaligned
accesses to the virtual CPU interface on 16K and 64K page systems, which
is only relevant on 64-bit platforms.  Therefore move this file to the
arm64 KVM tree, remove the compile directive from the 32-bit side
makefile, and remove the ifdef in the C file.

Since this file also no longer saves/restores anything, rename the file
to vgic-v2-cpuif-proxy.c to more accurately describe the logic in this
file.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/hyp/Makefile                                               | 1 -
 arch/arm64/kvm/hyp/Makefile                                             | 2 +-
 .../arm/hyp/vgic-v2-sr.c => arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c    | 2 --
 3 files changed, 1 insertion(+), 4 deletions(-)
 rename virt/kvm/arm/hyp/vgic-v2-sr.c => arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c (98%)

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
index f04400d494b7..4313f7475333 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -7,10 +7,10 @@ ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING
 
 KVM=../../../../virt/kvm
 
-obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v2-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v3-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/timer-sr.o
 
+obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-cpuif-proxy.o
 obj-$(CONFIG_KVM_ARM_HOST) += sysreg-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += debug-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += entry.o
diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
similarity index 98%
rename from virt/kvm/arm/hyp/vgic-v2-sr.c
rename to arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 0bbafdfd4adb..97f357ea9c72 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
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
