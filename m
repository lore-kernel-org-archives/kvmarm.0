From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 7/8] KVM: arm64: Save host SVE context as appropriate
Date: Fri, 20 Apr 2018 17:46:41 +0100
Message-ID: <1524242802-21163-8-git-send-email-Dave.Martin@arm.com>
References: <1524242802-21163-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7DD249FAC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Apr 2018 12:38:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VAX4aqxoe61C for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Apr 2018 12:37:59 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2FBF4A084
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Apr 2018 12:37:44 -0400 (EDT)
In-Reply-To: <1524242802-21163-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
this situation is detected this patch warns and refuses to create a
VM.  Doing this check at VM creation time avoids race issues
between KVM and SVE initialisation.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/Kconfig          |  7 +++++++
 arch/arm64/kvm/fpsimd.c     |  1 -
 arch/arm64/kvm/hyp/switch.c | 21 +++++++++++++++++++--
 virt/kvm/arm/arm.c          | 18 ++++++++++++++++++
 4 files changed, 44 insertions(+), 3 deletions(-)

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
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index cc7a068..c166954 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -59,7 +59,6 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
  */
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 {
-	BUG_ON(system_supports_sve());
 	BUG_ON(!current->mm);
 
 	vcpu->arch.fp_enabled = false;
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 0900c2a..959d634 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -21,12 +21,14 @@
 
 #include <kvm/arm_psci.h>
 
+#include <asm/cpufeature.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
+#include <asm/processor.h>
 #include <asm/thread_info.h>
 
 static bool __hyp_text update_fp_enabled(struct kvm_vcpu *vcpu)
@@ -497,6 +499,8 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
 				    struct kvm_vcpu *vcpu)
 {
+	struct user_fpsimd_state *host_fpsimd = vcpu->arch.host_fpsimd_state;
+
 	if (has_vhe())
 		write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_FPEN,
 			     cpacr_el1);
@@ -506,8 +510,21 @@ void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
 
 	isb();
 
-	if (vcpu->arch.host_fpsimd_state) {
-		__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
+	if (host_fpsimd) {
+		/*
+		 * In the SVE case, VHE is assumed: it is enforced by
+		 * Kconfig and kvm_arch_init_vm().
+		 */
+		if (system_supports_sve() && vcpu->arch.host_sve_in_use) {
+			struct thread_struct *thread = container_of(
+				host_fpsimd,
+				struct thread_struct, uw.fpsimd_state);
+
+			sve_save_state(sve_pffr(thread), &host_fpsimd->fpsr);
+		} else {
+			__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
+		}
+
 		vcpu->arch.host_fpsimd_state = NULL;
 	}
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 4fcf6fe..147d9d9 100644
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
@@ -120,6 +122,22 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (type)
 		return -EINVAL;
 
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
+		kvm_pr_unimpl("Cannot create VMs on SVE system without VHE.  Broken cpu?");
+		return -ENXIO;
+	}
+
 	kvm->arch.last_vcpu_ran = alloc_percpu(typeof(*kvm->arch.last_vcpu_ran));
 	if (!kvm->arch.last_vcpu_ran)
 		return -ENOMEM;
-- 
2.1.4
