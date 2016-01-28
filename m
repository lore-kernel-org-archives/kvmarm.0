From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 2/5] arm64: KVM: Move vgic-v2 and timer save/restore to virt/kvm/arm/hyp
Date: Thu, 28 Jan 2016 15:56:02 +0000
Message-ID: <1453996565-19666-3-git-send-email-marc.zyngier@arm.com>
References: <1453996565-19666-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1453996565-19666-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

We already have virt/kvm/arm/ containing timer and vgic stuff.
Add yet another subdirectory to contain the hyp-specific files
(timer and vgic again).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/Makefile                       | 7 +++++--
 {arch/arm64/kvm => virt/kvm/arm}/hyp/timer-sr.c   | 0
 {arch/arm64/kvm => virt/kvm/arm}/hyp/vgic-v2-sr.c | 0
 3 files changed, 5 insertions(+), 2 deletions(-)
 rename {arch/arm64/kvm => virt/kvm/arm}/hyp/timer-sr.c (100%)
 rename {arch/arm64/kvm => virt/kvm/arm}/hyp/vgic-v2-sr.c (100%)

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 826032b..5cf4718 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -2,9 +2,12 @@
 # Makefile for Kernel-based Virtual Machine module, HYP part
 #
 
-obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
+KVM=../../../../virt/kvm
+
+obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v2-sr.o
+obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/timer-sr.o
+
 obj-$(CONFIG_KVM_ARM_HOST) += vgic-v3-sr.o
-obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += sysreg-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += debug-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += entry.o
diff --git a/arch/arm64/kvm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
similarity index 100%
rename from arch/arm64/kvm/hyp/timer-sr.c
rename to virt/kvm/arm/hyp/timer-sr.c
diff --git a/arch/arm64/kvm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
similarity index 100%
rename from arch/arm64/kvm/hyp/vgic-v2-sr.c
rename to virt/kvm/arm/hyp/vgic-v2-sr.c
-- 
2.1.4

