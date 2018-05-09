From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v7 12/16] KVM: arm64: Save host SVE context as appropriate
Date: Wed,  9 May 2018 17:13:01 +0100
Message-ID: <1525882385-29181-13-git-send-email-Dave.Martin@arm.com>
References: <1525882385-29181-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17165401CD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 May 2018 12:04:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id heE7dyoUH7OI for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 May 2018 12:04:20 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3043D49F8C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 May 2018 12:04:07 -0400 (EDT)
In-Reply-To: <1525882385-29181-1-git-send-email-Dave.Martin@arm.com>
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
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/Kconfig          |  7 +++++++
 arch/arm64/kvm/fpsimd.c     |  1 -
 arch/arm64/kvm/hyp/switch.c | 20 +++++++++++++++++++-
 virt/kvm/arm/arm.c          | 18 ++++++++++++++++++
 4 files changed, 44 insertions(+), 2 deletions(-)

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
index cdd78a77..c50a8e9 100644
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
index bee226c..379e8a9 100644
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
@@ -1582,6 +1584,22 @@ int kvm_arch_init(void *opaque)
 		}
 	}
 
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
 	err = init_common_resources();
 	if (err)
 		return err;
-- 
2.1.4
