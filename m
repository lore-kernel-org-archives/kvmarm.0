From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 09/10] KVM: arm/arm64: Detangle kvm_mmu.h from kvm_hyp.h
Date: Mon,  9 Oct 2017 16:20:31 +0100
Message-ID: <20171009152032.27804-10-marc.zyngier@arm.com>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171009152032.27804-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

kvm_hyp.h has an odd dependency on kvm_mmu.h, which makes the
opposite inclusion impossible. Let's start with breaking that
useless dependency.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_hyp.h   | 1 -
 arch/arm/kvm/hyp/switch.c        | 1 +
 arch/arm/kvm/hyp/tlb.c           | 1 +
 arch/arm64/include/asm/kvm_hyp.h | 1 -
 arch/arm64/kvm/hyp/debug-sr.c    | 1 +
 arch/arm64/kvm/hyp/switch.c      | 1 +
 arch/arm64/kvm/hyp/tlb.c         | 1 +
 virt/kvm/arm/hyp/vgic-v2-sr.c    | 1 +
 8 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
index ad541f9ecc78..8b29faa119ba 100644
--- a/arch/arm/include/asm/kvm_hyp.h
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -21,7 +21,6 @@
 #include <linux/compiler.h>
 #include <linux/kvm_host.h>
 #include <asm/cp15.h>
-#include <asm/kvm_mmu.h>
 #include <asm/vfp.h>
 
 #define __hyp_text __section(.hyp.text) notrace
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index ebd2dd46adf7..67e0a689c4b5 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -18,6 +18,7 @@
 
 #include <asm/kvm_asm.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
 
 __asm__(".arch_extension     virt");
 
diff --git a/arch/arm/kvm/hyp/tlb.c b/arch/arm/kvm/hyp/tlb.c
index 6d810af2d9fd..c0edd450e104 100644
--- a/arch/arm/kvm/hyp/tlb.c
+++ b/arch/arm/kvm/hyp/tlb.c
@@ -19,6 +19,7 @@
  */
 
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
 
 /**
  * Flush per-VMID TLBs
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 4572a9b560fa..afbfbe0c12c5 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -20,7 +20,6 @@
 
 #include <linux/compiler.h>
 #include <linux/kvm_host.h>
-#include <asm/kvm_mmu.h>
 #include <asm/sysreg.h>
 
 #define __hyp_text __section(.hyp.text) notrace
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index f5154ed3da6c..d3a13d57f2c5 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -21,6 +21,7 @@
 #include <asm/debug-monitors.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
 
 #define read_debug(r,n)		read_sysreg(r##n##_el1)
 #define write_debug(v,r,n)	write_sysreg(v, r##n##_el1)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 945e79c641c4..c52f7094122f 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -21,6 +21,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
 #include <asm/fpsimd.h>
 
 static bool __hyp_text __fpsimd_enabled_nvhe(void)
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 73464a96c365..131c7772703c 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -16,6 +16,7 @@
  */
 
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
 #include <asm/tlbflush.h>
 
 static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm)
diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index a3f18d362366..77ccd8e2090b 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -21,6 +21,7 @@
 
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
 
 static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
 {
-- 
2.14.1
