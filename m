From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v9 12/16] KVM: arm64: Save host SVE context as appropriate
Date: Mon, 21 May 2018 15:17:13 +0100
Message-ID: <1526912237-25308-13-git-send-email-Dave.Martin@arm.com>
References: <1526912237-25308-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1526912237-25308-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds SVE context saving to the hyp FPSIMD context switch
path.  This means that it is no longer necessary to save the host
SVE state in advance of entering the guest, when in use.

In order to avoid adding pointless complexity to the code, VHE is
assumed if SVE is in use.  VHE is an architectural prerequisite for
SVE, so there is no good reason to turn CONFIG_ARM64_VHE off in
kernels that support both SVE and KVM.

Historically, software models exist that can expose the
architecturally invalid configuration of SVE without VHE, so if
this situation is detected at kvm_init() time then KVM will be
disabled.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

 * Stripped the following tags, reviewers please reconfirm:

Formerly-Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Formerly-Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Formerly-Acked-by: Catalin Marinas <catalin.marinas@arm.com>

(Creation of a new file for this one change may be deemed undesirable,
but there didn't seem to be a correct place to put it.  There may also
be a way around the circular include problem that I missed.)

Changes since v8:

 * Add kvm_arch_check_supported() hook, and move arm64-specific check
   for SVE-implies-VHE into arch/arm64/.

   Due to circular header dependency problems, it is difficult to get
   the prototype for kvm_pr_*() functions in <asm/kvm_host.h>, so this
   patch puts arm64's kvm_arch_check_supported() hook out of line.
   This is not a hot function.
---
 arch/arm/include/asm/kvm_host.h   |  1 +
 arch/arm64/Kconfig                |  7 +++++++
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/Makefile           |  2 +-
 arch/arm64/kvm/fpsimd.c           |  1 -
 arch/arm64/kvm/hyp/switch.c       | 20 +++++++++++++++++++-
 arch/arm64/kvm/init.c             | 33 +++++++++++++++++++++++++++++++++
 virt/kvm/arm/arm.c                |  6 ++++++
 8 files changed, 68 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm64/kvm/init.c

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index ac870b2..e627ef8 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -280,6 +280,7 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
+static inline int kvm_arch_check_supported(void) { return 0; }
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index eb2cf49..b0d3820 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1130,6 +1130,7 @@ endmenu
 config ARM64_SVE
 	bool "ARM Scalable Vector Extension support"
 	default y
+	depends on !KVM || ARM64_VHE
 	help
 	  The Scalable Vector Extension (SVE) is an extension to the AArch64
 	  execution state which complements and extends the SIMD functionality
@@ -1155,6 +1156,12 @@ config ARM64_SVE
 	  booting the kernel.  If unsure and you are not observing these
 	  symptoms, you should assume that it is safe to say Y.
 
+	  CPUs that support SVE are architecturally required to support the
+	  Virtualization Host Extensions (VHE), so the kernel makes no
+	  provision for supporting SVE alongside KVM without VHE enabled.
+	  Thus, you will need to enable CONFIG_ARM64_VHE if you want to support
+	  KVM in the same kernel image.
+
 config ARM64_MODULE_PLTS
 	bool
 	select HAVE_MOD_ARCH_SPECIFIC
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b3fe730..80f3985 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -405,6 +405,7 @@ static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 	kvm_call_hyp(__kvm_set_tpidr_el2, tpidr_el2);
 }
 
+int kvm_arch_check_supported(void);
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 0f2a135..5e66afe 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -17,7 +17,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arm.o $(KVM)/arm/mmu.o $(KVM)/arm/mmio.
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
 
 kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o va_layout.o
-kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
+kvm-$(CONFIG_KVM_ARM_HOST) += init.o hyp.o hyp-init.o handle_exit.o
 kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
 kvm-$(CONFIG_KVM_ARM_HOST) += vgic-sys-reg-v3.o fpsimd.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/aarch32.o
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index d9b5f73..52185ec 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -59,7 +59,6 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
  */
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 {
-	BUG_ON(system_supports_sve());
 	BUG_ON(!current->mm);
 
 	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED | KVM_ARM64_HOST_SVE_IN_USE);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 118f300..a6a8c7d 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -21,6 +21,7 @@
 
 #include <kvm/arm_psci.h>
 
+#include <asm/cpufeature.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
@@ -28,6 +29,7 @@
 #include <asm/kvm_mmu.h>
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
+#include <asm/processor.h>
 #include <asm/thread_info.h>
 
 /* Check whether the FP regs were dirtied while in the host-side run loop: */
@@ -329,6 +331,8 @@ static bool __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
 void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
 				    struct kvm_vcpu *vcpu)
 {
+	struct user_fpsimd_state *host_fpsimd = vcpu->arch.host_fpsimd_state;
+
 	if (has_vhe())
 		write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_FPEN,
 			     cpacr_el1);
@@ -339,7 +343,21 @@ void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
 	isb();
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_HOST) {
-		__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
+		/*
+		 * In the SVE case, VHE is assumed: it is enforced by
+		 * Kconfig and kvm_arch_init().
+		 */
+		if (system_supports_sve() &&
+		    (vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE)) {
+			struct thread_struct *thread = container_of(
+				host_fpsimd,
+				struct thread_struct, uw.fpsimd_state);
+
+			sve_save_state(sve_pffr(thread), &host_fpsimd->fpsr);
+		} else {
+			__fpsimd_save_state(host_fpsimd);
+		}
+
 		vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
 	}
 
diff --git a/arch/arm64/kvm/init.c b/arch/arm64/kvm/init.c
new file mode 100644
index 0000000..3b6e730
--- /dev/null
+++ b/arch/arm64/kvm/init.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * arch/arm64/kvm/init.c: KVM initialisation support
+ *
+ * Copyright 2018 Arm Limited
+ * Author: Dave Martin <Dave.Martin@arm.com>
+ */
+#include <linux/errno.h>
+#include <linux/kvm_host.h>
+#include <asm/cpufeature.h>
+#include <asm/kvm_host.h>
+
+/* Additional arch-dependent checks for KVM usability */
+int kvm_arch_check_supported(void)
+{
+	/*
+	 * VHE is a prerequisite for SVE in the Arm architecture, and
+	 * Kconfig ensures that if system_supports_sve() here then
+	 * CONFIG_ARM64_VHE is enabled, so if VHE support wasn't already
+	 * detected and enabled, the CPU is architecturally
+	 * noncompliant.
+	 *
+	 * Just in case this mismatch is seen, detect it, warn and give
+	 * up.  Supporting this forbidden configuration in Hyp would be
+	 * pointless.
+	 */
+	if (system_supports_sve() && !has_vhe()) {
+		kvm_pr_unimpl("SVE system without VHE unsupported.  Broken cpu?");
+		return -ENODEV;
+	}
+
+	return 0;
+}
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index bee226c..8518df0 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -16,6 +16,7 @@
  * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
  */
 
+#include <linux/bug.h>
 #include <linux/cpu_pm.h>
 #include <linux/errno.h>
 #include <linux/err.h>
@@ -41,6 +42,7 @@
 #include <asm/mman.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
+#include <asm/cpufeature.h>
 #include <asm/virt.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
@@ -1574,6 +1576,10 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
 
+	err = kvm_arch_check_supported();
+	if (err)
+		return err;
+
 	for_each_online_cpu(cpu) {
 		smp_call_function_single(cpu, check_kvm_target_cpu, &ret, 1);
 		if (ret < 0) {
-- 
2.1.4
