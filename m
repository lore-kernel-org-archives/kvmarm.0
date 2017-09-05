From: gengdongjiu <gengdongjiu@huawei.com>
Subject: [PATCH] arm64: KVM: VHE: save and restore some PSTATE bits
Date: Tue, 5 Sep 2017 18:58:42 +0000
Message-ID: <0184EA26B2509940AA629AE1405DD7F2015DF717@DGGEMA503-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
To: "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "vladimir.murzin@arm.com" <vladimir.murzin@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

when exit from guest, some host PSTATE bits may be lost, such as
PSTATE.PAN or PSTATE.UAO. It is because host and hypervisor all run
in the EL2, host PSTATE value cannot be saved and restored via
SPSR_EL2. So if guest has changed the PSTATE, host continues with
a wrong value guest has set.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: Haibin Zhang <zhanghaibin7@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |  8 +++++++
 arch/arm64/include/asm/kvm_hyp.h  |  2 ++
 arch/arm64/include/asm/sysreg.h   | 23 +++++++++++++++++++
 arch/arm64/kvm/hyp/entry.S        |  2 --
 arch/arm64/kvm/hyp/switch.c       | 24 ++++++++++++++++++--
 arch/arm64/kvm/hyp/sysreg-sr.c    | 48 ++++++++++++++++++++++++++++++++++++---
 6 files changed, 100 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e923b58..cba7d3e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -193,6 +193,12 @@ struct kvm_cpu_context {
 	};
 };
 
+struct kvm_cpu_host_pstate {
+	u64 daif;
+	u64 uao;
+	u64 pan;
+};
+
 typedef struct kvm_cpu_context kvm_cpu_context_t;
 
 struct kvm_vcpu_arch {
@@ -227,6 +233,8 @@ struct kvm_vcpu_arch {
 
 	/* Pointer to host CPU context */
 	kvm_cpu_context_t *host_cpu_context;
+	/* Host PSTATE value */
+	struct kvm_cpu_host_pstate host_pstate;
 	struct {
 		/* {Break,watch}point registers */
 		struct kvm_guest_debug_arch regs;
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 4572a9b..a75587a 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -134,6 +134,8 @@
 
 void __sysreg_save_host_state(struct kvm_cpu_context *ctxt);
 void __sysreg_restore_host_state(struct kvm_cpu_context *ctxt);
+void __sysreg_save_host_pstate(struct kvm_vcpu *vcpu);
+void __sysreg_restore_host_pstate(struct kvm_vcpu *vcpu);
 void __sysreg_save_guest_state(struct kvm_cpu_context *ctxt);
 void __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt);
 void __sysreg32_save_state(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 248339e..efdcf40 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -295,6 +295,29 @@
 #define SYS_ICH_LR14_EL2		__SYS__LR8_EL2(6)
 #define SYS_ICH_LR15_EL2		__SYS__LR8_EL2(7)
 
+#define REG_PSTATE_PAN			sys_reg(3, 0, 4, 2, 3)
+#define REG_PSTATE_UAO			sys_reg(3, 0, 4, 2, 4)
+
+#define GET_PSTATE_PAN					\
+	({						\
+		u64 reg;				\
+		asm volatile(ALTERNATIVE("mov %0, #0",	\
+				"mrs_s %0, " __stringify(REG_PSTATE_PAN),\
+				ARM64_HAS_PAN)\
+				: "=r" (reg));\
+		reg;				\
+	})
+
+#define GET_PSTATE_UAO					\
+	({						\
+		u64 reg;					\
+		asm volatile(ALTERNATIVE("mov %0, #0",\
+				"mrs_s %0, " __stringify(REG_PSTATE_UAO),\
+				ARM64_HAS_UAO)\
+				: "=r" (reg));\
+		reg;			\
+	})
+
 /* Common SCTLR_ELx flags. */
 #define SCTLR_ELx_EE    (1 << 25)
 #define SCTLR_ELx_I	(1 << 12)
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 12ee62d..7662ef5 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -96,8 +96,6 @@ ENTRY(__guest_exit)
 
 	add	x1, x1, #VCPU_CONTEXT
 
-	ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
-
 	// Store the guest regs x2 and x3
 	stp	x2, x3,   [x1, #CPU_XREG_OFFSET(2)]
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 945e79c..9b380a1 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -278,6 +278,26 @@ static void __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
 	write_sysreg_el2(*vcpu_pc(vcpu), elr);
 }
 
+static void __hyp_text __save_host_state(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *host_ctxt;
+
+	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+
+	__sysreg_save_host_state(host_ctxt);
+	__sysreg_save_host_pstate(vcpu);
+}
+
+static void __hyp_text __restore_host_state(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *host_ctxt;
+
+	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+
+	__sysreg_restore_host_state(host_ctxt);
+	__sysreg_restore_host_pstate(vcpu);
+}
+
 int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
@@ -291,7 +311,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
 	guest_ctxt = &vcpu->arch.ctxt;
 
-	__sysreg_save_host_state(host_ctxt);
+	__save_host_state(vcpu);
 	__debug_cond_save_host_state(vcpu);
 
 	__activate_traps(vcpu);
@@ -374,7 +394,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__deactivate_traps(vcpu);
 	__deactivate_vm(vcpu);
 
-	__sysreg_restore_host_state(host_ctxt);
+	__restore_host_state(vcpu);
 
 	if (fp_enabled) {
 		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 9341376..ea8f437 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -22,7 +22,11 @@
 #include <asm/kvm_hyp.h>
 
 /* Yes, this does nothing, on purpose */
-static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }
+static void __hyp_text __sysreg_do_nothing_state(struct kvm_cpu_context *ctxt)
+{ }
+static void __hyp_text __sysreg_do_nothing_pstate(struct kvm_vcpu *vcpu)
+{ }
+
 
 /*
  * Non-VHE: Both host and guest must save everything.
@@ -69,7 +73,7 @@ static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
 }
 
 static hyp_alternate_select(__sysreg_call_save_host_state,
-			    __sysreg_save_state, __sysreg_do_nothing,
+			    __sysreg_save_state, __sysreg_do_nothing_state,
 			    ARM64_HAS_VIRT_HOST_EXTN);
 
 void __hyp_text __sysreg_save_host_state(struct kvm_cpu_context *ctxt)
@@ -122,7 +126,7 @@ static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
 }
 
 static hyp_alternate_select(__sysreg_call_restore_host_state,
-			    __sysreg_restore_state, __sysreg_do_nothing,
+			    __sysreg_restore_state, __sysreg_do_nothing_state,
 			    ARM64_HAS_VIRT_HOST_EXTN);
 
 void __hyp_text __sysreg_restore_host_state(struct kvm_cpu_context *ctxt)
@@ -137,6 +141,44 @@ void __hyp_text __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt)
 	__sysreg_restore_common_state(ctxt);
 }
 
+static void __hyp_text __sysreg_save_pstate(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.host_pstate.daif = read_sysreg(daif);
+	vcpu->arch.host_pstate.pan = GET_PSTATE_PAN;
+	vcpu->arch.host_pstate.uao = GET_PSTATE_UAO;
+}
+
+static hyp_alternate_select(__sysreg_call_save_host_pstate,
+			    __sysreg_save_pstate, __sysreg_do_nothing_pstate,
+			    ARM64_HAS_VIRT_HOST_EXTN);
+
+void __hyp_text __sysreg_save_host_pstate(struct kvm_vcpu *vcpu)
+{
+	__sysreg_call_save_host_pstate()(vcpu);
+}
+
+static void __hyp_text __sysreg_restore_pstate(struct kvm_vcpu *vcpu)
+{
+	u8 value = !!(vcpu->arch.host_pstate.pan);
+
+	write_sysreg(vcpu->arch.host_pstate.daif, daif);
+	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(value), ARM64_HAS_PAN,
+			CONFIG_ARM64_PAN));
+
+	value = !!(vcpu->arch.host_pstate.uao);
+	asm(ALTERNATIVE("nop", SET_PSTATE_UAO(value), ARM64_HAS_UAO,
+			CONFIG_ARM64_UAO));
+}
+
+static hyp_alternate_select(__sysreg_call_restore_host_pstate,
+			    __sysreg_restore_pstate, __sysreg_do_nothing_pstate,
+			    ARM64_HAS_VIRT_HOST_EXTN);
+
+void __hyp_text __sysreg_restore_host_pstate(struct kvm_vcpu *vcpu)
+{
+	__sysreg_call_restore_host_pstate()(vcpu);
+}
+
 void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 {
 	u64 *spsr, *sysreg;
-- 
1.9.1
