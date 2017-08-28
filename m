From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v6 7/7] arm64: kvm: handle SEI notification and pass the
 virtual syndrome
Date: Mon, 28 Aug 2017 18:38:21 +0800
Message-ID: <1503916701-13516-8-git-send-email-gengdongjiu@huawei.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, james.morse@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, mst@redhat.com, john.garry@huawei.com, jonathan.cameron@huawei.com, shameerali.kolot
Cc: zhengqiang10@huawei.com, wuquanming@huawei.com, huangshaoyu@huawei.com, linuxarm@huawei.com, gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

After received SError, KVM firstly classified the error.
Not call memory_failure() to handle it. Because the address recorded
by APEI is not accurated, so can not identify the address to hwpoison
memory.

If the SError error come from guest user mode and is not
propagated, then signal user space to handle it, otherwise,
directly injects virtual SError, or panic if the error is fatal.

user space will specify syndrome for the injected virtual SError.
This syndrome value is set to the VSESR_EL2, VSESR_EL2 is a new
ARMv8.2 RAS extensions register which provides the syndrome value
reported to software on taking a virtual SError interrupt exception.

change since v5:
1. not call the memory_failure() to handle the SEI error
2. kvm classify the SError and decide how to do.
3. add code to deliver signal compatible to Non-KVM user.
4. correct some typo errors

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: Quanming Wu <wuquanming@huawei.com>
---
 arch/arm/include/asm/kvm_host.h      |  2 ++
 arch/arm/kvm/guest.c                 |  9 ++++++
 arch/arm64/include/asm/esr.h         | 11 +++++++
 arch/arm64/include/asm/kvm_emulate.h | 10 +++++++
 arch/arm64/include/asm/kvm_host.h    |  2 ++
 arch/arm64/include/asm/sysreg.h      |  3 ++
 arch/arm64/include/asm/system_misc.h |  1 +
 arch/arm64/kvm/guest.c               | 14 +++++++++
 arch/arm64/kvm/handle_exit.c         | 56 ++++++++++++++++++++++++++++++++----
 arch/arm64/kvm/hyp/switch.c          | 14 +++++++++
 arch/arm64/mm/fault.c                | 34 ++++++++++++++++++++++
 include/uapi/linux/kvm.h             |  2 ++
 virt/kvm/arm/arm.c                   |  7 +++++
 13 files changed, 160 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 127e2dd2e21c..bdb6ea690257 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -244,6 +244,8 @@ int kvm_arm_coproc_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *);
 int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		int exception_index);
 
+int kvm_vcpu_ioctl_sei(struct kvm_vcpu *vcpu, u64 *syndrome);
+
 static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 				       unsigned long hyp_stack_ptr,
 				       unsigned long vector_ptr)
diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
index 1e0784ebbfd6..e120e7458c30 100644
--- a/arch/arm/kvm/guest.c
+++ b/arch/arm/kvm/guest.c
@@ -248,6 +248,15 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	return -EINVAL;
 }
 
+/*
+ * we only support SEI injection with specified synchronous
+ * in ARM64, not support it in ARM32.
+ */
+int kvm_vcpu_ioctl_sei(struct kvm_vcpu *vcpu, u64 *syndrome)
+{
+	return -EINVAL;
+}
+
 int __attribute_const__ kvm_target_cpu(void)
 {
 	switch (read_cpuid_part()) {
diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 8cabd57b6348..fe4a543add8f 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -77,6 +77,7 @@
 #define ESR_ELx_EC_MASK		(UL(0x3F) << ESR_ELx_EC_SHIFT)
 #define ESR_ELx_EC(esr)		(((esr) & ESR_ELx_EC_MASK) >> ESR_ELx_EC_SHIFT)
 
+
 #define ESR_ELx_IL		(UL(1) << 25)
 #define ESR_ELx_ISS_MASK	(ESR_ELx_IL - 1)
 
@@ -95,6 +96,7 @@
 #define ESR_ELx_FSC_ACCESS	(0x08)
 #define ESR_ELx_FSC_FAULT	(0x04)
 #define ESR_ELx_FSC_PERM	(0x0C)
+#define ESR_ELx_FSC_SERROR	(0x11)
 
 /* ISS field definitions for Data Aborts */
 #define ESR_ELx_ISV		(UL(1) << 24)
@@ -107,6 +109,15 @@
 #define ESR_ELx_AR 		(UL(1) << 14)
 #define ESR_ELx_CM 		(UL(1) << 8)
 
+/* ISS field definitions for SError interrupt */
+#define ESR_ELx_AET_SHIFT	(10)
+#define ESR_ELx_AET		(UL(0x7) << ESR_ELx_AET_SHIFT)
+#define ESR_ELx_AET_UC		(UL(0) << ESR_ELx_AET_SHIFT)	/* Uncontainable */
+#define ESR_ELx_AET_UEU		(UL(1) << ESR_ELx_AET_SHIFT)	/* Uncorrected Unrecoverable */
+#define ESR_ELx_AET_UEO		(UL(2) << ESR_ELx_AET_SHIFT)	/* Uncorrected Restartable */
+#define ESR_ELx_AET_UER		(UL(3) << ESR_ELx_AET_SHIFT)	/* Uncorrected Recoverable */
+#define ESR_ELx_AET_CE		(UL(6) << ESR_ELx_AET_SHIFT)	/* Corrected */
+
 /* ISS field definitions for exceptions taken in to Hyp */
 #define ESR_ELx_CV		(UL(1) << 24)
 #define ESR_ELx_COND_SHIFT	(20)
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 47983db27de2..74213bd539dc 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -155,6 +155,16 @@ static inline u32 kvm_vcpu_get_hsr(const struct kvm_vcpu *vcpu)
 	return vcpu->arch.fault.esr_el2;
 }
 
+static inline u32 kvm_vcpu_get_vsesr(const struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.fault.vsesr_el2;
+}
+
+static inline void kvm_vcpu_set_vsesr(struct kvm_vcpu *vcpu, unsigned long val)
+{
+	vcpu->arch.fault.vsesr_el2 = val;
+}
+
 static inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
 {
 	u32 esr = kvm_vcpu_get_hsr(vcpu);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d68630007b14..57b011261597 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -88,6 +88,7 @@ struct kvm_vcpu_fault_info {
 	u32 esr_el2;		/* Hyp Syndrom Register */
 	u64 far_el2;		/* Hyp Fault Address Register */
 	u64 hpfar_el2;		/* Hyp IPA Fault Address Register */
+	u32 vsesr_el2;		/* Virtual SError Exception Syndrome Register */
 };
 
 /*
@@ -381,6 +382,7 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
+int kvm_vcpu_ioctl_sei(struct kvm_vcpu *vcpu, u64 *syndrome);
 
 static inline void __cpu_init_stage2(void)
 {
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 35b786b43ee4..06059eef0f5d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -86,6 +86,9 @@
 #define REG_PSTATE_PAN_IMM		sys_reg(0, 0, 4, 0, 4)
 #define REG_PSTATE_UAO_IMM		sys_reg(0, 0, 4, 0, 3)
 
+/* virtual SError exception syndrome register in armv8.2 */
+#define REG_VSESR_EL2			sys_reg(3, 4, 5, 2, 3)
+
 #define SET_PSTATE_PAN(x) __emit_inst(0xd5000000 | REG_PSTATE_PAN_IMM |	\
 				      (!!x)<<8 | 0x1f)
 #define SET_PSTATE_UAO(x) __emit_inst(0xd5000000 | REG_PSTATE_UAO_IMM |	\
diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
index 07aa8e3c5630..90bea60cfca3 100644
--- a/arch/arm64/include/asm/system_misc.h
+++ b/arch/arm64/include/asm/system_misc.h
@@ -57,6 +57,7 @@ extern void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
 })
 
 int handle_guest_sea(phys_addr_t addr, unsigned int esr);
+int handle_guest_sei(unsigned int esr);
 
 #endif	/* __ASSEMBLY__ */
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 020a644b20d7..4e09b6c0d041 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -313,6 +313,20 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	return -EINVAL;
 }
 
+int kvm_vcpu_ioctl_sei(struct kvm_vcpu *vcpu, u64 *syndrome)
+{
+	u64 reg = *syndrome;
+
+	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) && reg)
+		/* set vsesr_el2[24:0] with value that user space specified */
+		kvm_vcpu_set_vsesr(vcpu, reg & ESR_ELx_ISS_MASK);
+
+	/* inject virtual system Error or asynchronous abort */
+	kvm_inject_vabt(vcpu);
+
+	return 0;
+}
+
 int __attribute_const__ kvm_target_cpu(void)
 {
 	unsigned long implementor = read_cpuid_implementor();
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 17d8a1677a0b..bc55666c3c7f 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -28,6 +28,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_psci.h>
+#include <asm/system_misc.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -178,8 +179,55 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
 	return arm_exit_handlers[hsr_ec];
 }
 
+/**
+ * kvm_handle_guest_sei - handles SError interrupt or asynchronous aborts
+ * @vcpu:	the VCPU pointer
+ *
+ * For RAS SError interrupt, if the AET is [ESR_ELx_AET_UEU] and error
+ * is guest user space, then let host user space do the recovery, otherwise,
+ * directly inject virtual SError to guest or panic.
+ */
+static int kvm_handle_guest_sei(struct kvm_vcpu *vcpu)
+{
+	unsigned int esr = kvm_vcpu_get_hsr(vcpu);
+	bool impdef_syndrome =  esr & ESR_ELx_ISV;	/* aka IDS */
+	unsigned int aet = esr & ESR_ELx_AET;
+
+	/*
+	 * In below three conditions, it will directly inject the virtual SError.
+	 * 1. Not support RAS extension; the Syndrome is IMPLEMENTATION DEFINED;
+	 * AET is RES0 if 'the value returned in the DFSC field is not
+	 * [ESR_ELx_FSC_SERROR]'
+	 */
+	if (!cpus_have_const_cap(ARM64_HAS_RAS_EXTN) || impdef_syndrome ||
+			((esr & ESR_ELx_FSC) != ESR_ELx_FSC_SERROR)) {
+		kvm_inject_vabt(vcpu);
+		return 1;
+	}
+
+	switch (aet) {
+	case ESR_ELx_AET_CE:	/* corrected error */
+	case ESR_ELx_AET_UEO:	/* restartable error, not yet consumed */
+		return 0;	/* continue processing the guest exit */
+	case ESR_ELx_AET_UEU:  /* The error has not been propagated */
+	/*
+	 * Only handle the guest user mode SEI if the error has not been propagated
+	 */
+	if ((!vcpu_mode_priv(vcpu)) && !handle_guest_sei(kvm_vcpu_get_hsr(vcpu)))
+		return 1;
+
+	/* If SError handling is failed, continue run */
+	default:
+		/*
+		 * Until now, the CPU supports RAS and SEI is fatal, or user space
+		 * does not support to handle the SError.
+		 */
+		panic("This Asynchronous SError interrupt is dangerous, panic");
+	}
+}
+
 /*
- * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
+ * return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
  * proper exit to userspace.
  */
 int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
@@ -201,8 +249,7 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			*vcpu_pc(vcpu) -= adj;
 		}
 
-		kvm_inject_vabt(vcpu);
-		return 1;
+		return kvm_handle_guest_sei(vcpu);
 	}
 
 	exception_index = ARM_EXCEPTION_CODE(exception_index);
@@ -211,8 +258,7 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	case ARM_EXCEPTION_IRQ:
 		return 1;
 	case ARM_EXCEPTION_EL1_SERROR:
-		kvm_inject_vabt(vcpu);
-		return 1;
+		return kvm_handle_guest_sei(vcpu);
 	case ARM_EXCEPTION_TRAP:
 		/*
 		 * See ARM ARM B1.14.1: "Hyp traps on instructions
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index c6f17c7675ad..a73346141cf3 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -42,6 +42,13 @@ bool __hyp_text __fpsimd_enabled(void)
 	return __fpsimd_is_enabled()();
 }
 
+static void __hyp_text __sysreg_set_vsesr(struct kvm_vcpu *vcpu)
+{
+	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) &&
+			(vcpu->arch.hcr_el2 & HCR_VSE))
+		write_sysreg_s(vcpu->arch.fault.vsesr_el2, REG_VSESR_EL2);
+}
+
 static void __hyp_text __activate_traps_vhe(void)
 {
 	u64 val;
@@ -86,6 +93,13 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 		isb();
 	}
 	write_sysreg(val, hcr_el2);
+
+	/*
+	 * If the virtual SError interrupt is taken to EL1 using AArch64,
+	 * then VSESR_EL2 provides the syndrome value reported in ESR_EL1.
+	 */
+	__sysreg_set_vsesr(vcpu);
+
 	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
 	/*
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 2509e4fe6992..4407ca89d791 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -687,6 +687,40 @@ int handle_guest_sea(phys_addr_t addr, unsigned int esr)
 	return ret;
 }
 
+/*
+ * Handle SError interrupt that occur in guest OS.
+ *
+ * The return value will be zero if the SEI was successfully handled
+ * and non-zero if handling is failed.
+ */
+int handle_guest_sei(unsigned int esr)
+{
+	int ret = 0;
+
+	struct siginfo info;
+
+	pr_alert("Asynchronous SError interrupt detected on CPU: %d, esr: %x\n",
+		smp_processor_id(), esr);
+
+	info.si_signo = SIGBUS;
+	info.si_errno = 0;
+	info.si_code  = BUS_MCEERR_AR;
+	/*
+	 * Because the address is not accurate for Asynchronous Aborts, so set
+	 * NULL for the fault address
+	 */
+	info.si_addr = NULL;
+
+	ret = force_sig_info(SIGBUS, &info, current);
+	if (ret < 0)
+		pr_info("Handle guest SEI: Error sending signal to %s:%d: %d\n",
+			current->comm, current->pid, ret);
+	else
+		ret = 0;
+
+	 return ret;
+}
+
 /*
  * Dispatch a data abort to the relevant handler.
  */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5a2a338cae57..d3fa4c60c9dc 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1356,6 +1356,8 @@ struct kvm_s390_ucas_mapping {
 /* Available with KVM_CAP_S390_CMMA_MIGRATION */
 #define KVM_S390_GET_CMMA_BITS      _IOWR(KVMIO, 0xb8, struct kvm_s390_cmma_log)
 #define KVM_S390_SET_CMMA_BITS      _IOW(KVMIO, 0xb9, struct kvm_s390_cmma_log)
+#define KVM_ARM_SEI		_IO(KVMIO,   0xb10)
+
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index a39a1e161e63..dbaaf206ace2 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1022,6 +1022,13 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			return -EFAULT;
 		return kvm_arm_vcpu_has_attr(vcpu, &attr);
 	}
+	case KVM_ARM_SEI: {
+		u64 syndrome;
+
+		if (copy_from_user(&syndrome, argp, sizeof(syndrome)))
+			return -EFAULT;
+		return kvm_vcpu_ioctl_sei(vcpu, &syndrome);
+	}
 	default:
 		return -EINVAL;
 	}
-- 
2.14.1
