From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v10 14/18] KVM: arm64: Save host SVE context as appropriate
Date: Tue, 22 May 2018 17:05:15 +0100
Message-ID: <1527005119-6842-15-git-send-email-Dave.Martin@arm.com>
References: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
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

 * Tags stripped since v8, please reconfirm if possible:

Formerly-Reviewed-by: Christoffer Dall <christoffer.dall at arm.com>
Formerly-Acked-by: Marc Zyngier <marc.zyngier at arm.com>
Formerly-Acked-by: Catalin Marinas <catalin.marinas at arm.com>

Changes since v9:

Requested by Marc Zyngier:

 * Inline check for VHE if SVE is present into kvm_host.h.

   The check has been renamed to the more specific
   kvm_arch_check_sve_has_vhe(), and the kvm_pr_unimpl() moved back to
   arm.c (to avoid circular include issues).

   arm.c is not single-arch code, but it is all Arm-specific, so
   adding a hook like this doesn't seem too unreasonable.

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
 arch/arm64/include/asm/kvm_host.h | 13 +++++++++++++
 arch/arm64/kvm/fpsimd.c           |  1 -
 arch/arm64/kvm/hyp/switch.c       | 20 +++++++++++++++++++-
 virt/kvm/arm/arm.c                |  7 +++++++
 6 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index ac870b2..3b85bbb 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -280,6 +280,7 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
+static inline bool kvm_arch_check_sve_has_vhe(void) { return true; }
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
index b3fe730..06d5a61 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -405,6 +405,19 @@ static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 	kvm_call_hyp(__kvm_set_tpidr_el2, tpidr_el2);
 }
 
+static inline bool kvm_arch_check_sve_has_vhe(void)
+{
+	/*
+	 * The Arm architecture specifies that imlpementation of SVE
+	 * requires VHE also to be implemented.  The KVM code for arm64
+	 * relies on this when SVE is present:
+	 */
+	if (system_supports_sve())
+		return has_vhe();
+	else
+		return true;
+}
+
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 365933a..dc6ecfa 100644
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
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index bee226c..ce7c6f3 100644
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
@@ -1574,6 +1576,11 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
 
+	if (!kvm_arch_check_sve_has_vhe()) {
+		kvm_pr_unimpl("SVE system without VHE unsupported.  Broken cpu?");
+		return -ENODEV;
+	}
+
 	for_each_online_cpu(cpu) {
 		smp_call_function_single(cpu, check_kvm_target_cpu, &ret, 1);
 		if (ret < 0) {
-- 
2.1.4
