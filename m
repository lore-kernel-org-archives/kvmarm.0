From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 02/95] ARM: KVM: Move the  HYP code to its own section
Date: Wed,  9 Mar 2016 07:29:56 +0000
Message-ID: <1457508689-19672-3-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In order to be able to spread the HYP code into multiple compilation
units, adopt a layout similar to that of arm64:
- the HYP text is emited in its own section (.hyp.text)
- two linker generated symbols are use to identify the boundaries
  of that section

No functionnal change.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_asm.h |  6 ++++--
 arch/arm/include/asm/virt.h    |  4 ++++
 arch/arm/kernel/vmlinux.lds.S  |  6 ++++++
 arch/arm/kvm/interrupts.S      | 13 +++++--------
 4 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 194c91b..fa2fd25 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -19,6 +19,8 @@
 #ifndef __ARM_KVM_ASM_H__
 #define __ARM_KVM_ASM_H__
 
+#include <asm/virt.h>
+
 /* 0 is reserved as an invalid value. */
 #define c0_MPIDR	1	/* MultiProcessor ID Register */
 #define c0_CSSELR	2	/* Cache Size Selection Register */
@@ -91,8 +93,8 @@ extern char __kvm_hyp_exit_end[];
 
 extern char __kvm_hyp_vector[];
 
-extern char __kvm_hyp_code_start[];
-extern char __kvm_hyp_code_end[];
+#define	__kvm_hyp_code_start	__hyp_text_start
+#define __kvm_hyp_code_end	__hyp_text_end
 
 extern void __kvm_flush_vm_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
diff --git a/arch/arm/include/asm/virt.h b/arch/arm/include/asm/virt.h
index 4371f45..5fdbfea 100644
--- a/arch/arm/include/asm/virt.h
+++ b/arch/arm/include/asm/virt.h
@@ -74,6 +74,10 @@ static inline bool is_hyp_mode_mismatched(void)
 {
 	return !!(__boot_cpu_mode & BOOT_CPU_MODE_MISMATCH);
 }
+
+/* The section containing the hypervisor text */
+extern char __hyp_text_start[];
+extern char __hyp_text_end[];
 #endif
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 8b60fde..b4139cb 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -18,6 +18,11 @@
 	*(.proc.info.init)						\
 	VMLINUX_SYMBOL(__proc_info_end) = .;
 
+#define HYPERVISOR_TEXT							\
+	VMLINUX_SYMBOL(__hyp_text_start) = .;				\
+	*(.hyp.text)							\
+	VMLINUX_SYMBOL(__hyp_text_end) = .;
+
 #define IDMAP_TEXT							\
 	ALIGN_FUNCTION();						\
 	VMLINUX_SYMBOL(__idmap_text_start) = .;				\
@@ -108,6 +113,7 @@ SECTIONS
 			TEXT_TEXT
 			SCHED_TEXT
 			LOCK_TEXT
+			HYPERVISOR_TEXT
 			KPROBES_TEXT
 			*(.gnu.warning)
 			*(.glue_7)
diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
index 900ef6d..9d9cb71 100644
--- a/arch/arm/kvm/interrupts.S
+++ b/arch/arm/kvm/interrupts.S
@@ -28,9 +28,7 @@
 #include "interrupts_head.S"
 
 	.text
-
-__kvm_hyp_code_start:
-	.globl __kvm_hyp_code_start
+	.pushsection	.hyp.text, "ax"
 
 /********************************************************************
  * Flush per-VMID TLBs
@@ -314,8 +312,6 @@ THUMB(	orr	r2, r2, #PSR_T_BIT	)
 	eret
 .endm
 
-	.text
-
 	.align 5
 __kvm_hyp_vector:
 	.globl __kvm_hyp_vector
@@ -511,10 +507,9 @@ hyp_fiq:
 
 	.ltorg
 
-__kvm_hyp_code_end:
-	.globl	__kvm_hyp_code_end
+	.popsection
 
-	.section ".rodata"
+	.pushsection ".rodata"
 
 und_die_str:
 	.ascii	"unexpected undefined exception in Hyp mode at: %#08x\n"
@@ -524,3 +519,5 @@ dabt_die_str:
 	.ascii	"unexpected data abort in Hyp mode at: %#08x\n"
 svc_die_str:
 	.ascii	"unexpected HVC/SVC trap in Hyp mode at: %#08x\n"
+
+	.popsection
-- 
2.1.4

