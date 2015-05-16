From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH 01/10] KVM: arm: plug guest debug exploit
Date: Sat, 16 May 2015 12:45:42 +0800
Message-ID: <1431751551-4788-2-git-send-email-zhichao.huang@linaro.org>
References: <1431751551-4788-1-git-send-email-zhichao.huang@linaro.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1431751551-4788-1-git-send-email-zhichao.huang@linaro.org>
Sender: stable-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org
Cc: huangzhichao@huawei.com, Zhichao Huang <zhichao.huang@linaro.org>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hardware debugging in guests is not intercepted currently, it means
that a malicious guest can bring down the entire machine by writing
to the debug registers.

This patch enable trapping of all debug registers, preventing the guests
to mess with the host state.

However, it is a precursor for later patches which will need to do
more to world switch debug states while necessary.

Cc: <stable@vger.kernel.org>
Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
---
 arch/arm/include/asm/kvm_coproc.h |  3 +-
 arch/arm/kvm/coproc.c             | 60 +++++++++++++++++++++++++++++++++++----
 arch/arm/kvm/handle_exit.c        |  4 +--
 arch/arm/kvm/interrupts_head.S    |  2 +-
 4 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/kvm_coproc.h b/arch/arm/include/asm/kvm_coproc.h
index 4917c2f..e74ab0f 100644
--- a/arch/arm/include/asm/kvm_coproc.h
+++ b/arch/arm/include/asm/kvm_coproc.h
@@ -31,7 +31,8 @@ void kvm_register_target_coproc_table(struct kvm_coproc_target_table *table);
 int kvm_handle_cp10_id(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp_0_13_access(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run);
-int kvm_handle_cp14_access(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index f3d88dc..2e12760 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -91,12 +91,6 @@ int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 1;
 }
 
-int kvm_handle_cp14_access(struct kvm_vcpu *vcpu, struct kvm_run *run)
-{
-	kvm_inject_undefined(vcpu);
-	return 1;
-}
-
 static void reset_mpidr(struct kvm_vcpu *vcpu, const struct coproc_reg *r)
 {
 	/*
@@ -519,6 +513,60 @@ int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return emulate_cp15(vcpu, &params);
 }
 
+/**
+ * kvm_handle_cp14_64 -- handles a mrrc/mcrr trap on a guest CP14 access
+ * @vcpu: The VCPU pointer
+ * @run:  The kvm_run struct
+ */
+int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	struct coproc_params params;
+
+	params.CRn = (kvm_vcpu_get_hsr(vcpu) >> 1) & 0xf;
+	params.Rt1 = (kvm_vcpu_get_hsr(vcpu) >> 5) & 0xf;
+	params.is_write = ((kvm_vcpu_get_hsr(vcpu) & 1) == 0);
+	params.is_64bit = true;
+
+	params.Op1 = (kvm_vcpu_get_hsr(vcpu) >> 16) & 0xf;
+	params.Op2 = 0;
+	params.Rt2 = (kvm_vcpu_get_hsr(vcpu) >> 10) & 0xf;
+	params.CRm = 0;
+
+	/* raz_wi */
+	(void)pm_fake(vcpu, &params, NULL);
+
+	/* handled */
+	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+	return 1;
+}
+
+/**
+ * kvm_handle_cp14_32 -- handles a mrc/mcr trap on a guest CP14 access
+ * @vcpu: The VCPU pointer
+ * @run:  The kvm_run struct
+ */
+int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	struct coproc_params params;
+
+	params.CRm = (kvm_vcpu_get_hsr(vcpu) >> 1) & 0xf;
+	params.Rt1 = (kvm_vcpu_get_hsr(vcpu) >> 5) & 0xf;
+	params.is_write = ((kvm_vcpu_get_hsr(vcpu) & 1) == 0);
+	params.is_64bit = false;
+
+	params.CRn = (kvm_vcpu_get_hsr(vcpu) >> 10) & 0xf;
+	params.Op1 = (kvm_vcpu_get_hsr(vcpu) >> 14) & 0x7;
+	params.Op2 = (kvm_vcpu_get_hsr(vcpu) >> 17) & 0x7;
+	params.Rt2 = 0;
+
+	/* raz_wi */
+	(void)pm_fake(vcpu, &params, NULL);
+
+	/* handled */
+	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+	return 1;
+}
+
 /******************************************************************************
  * Userspace API
  *****************************************************************************/
diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index 95f12b2..357ad1b 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -104,9 +104,9 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[HSR_EC_WFI]		= kvm_handle_wfx,
 	[HSR_EC_CP15_32]	= kvm_handle_cp15_32,
 	[HSR_EC_CP15_64]	= kvm_handle_cp15_64,
-	[HSR_EC_CP14_MR]	= kvm_handle_cp14_access,
+	[HSR_EC_CP14_MR]	= kvm_handle_cp14_32,
 	[HSR_EC_CP14_LS]	= kvm_handle_cp14_load_store,
-	[HSR_EC_CP14_64]	= kvm_handle_cp14_access,
+	[HSR_EC_CP14_64]	= kvm_handle_cp14_64,
 	[HSR_EC_CP_0_13]	= kvm_handle_cp_0_13_access,
 	[HSR_EC_CP10_ID]	= kvm_handle_cp10_id,
 	[HSR_EC_SVC_HYP]	= handle_svc_hyp,
diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
index 35e4a3a..a9f3a56 100644
--- a/arch/arm/kvm/interrupts_head.S
+++ b/arch/arm/kvm/interrupts_head.S
@@ -607,7 +607,7 @@ ARM_BE8(rev	r6, r6  )
  * (hardware reset value is 0) */
 .macro set_hdcr operation
 	mrc	p15, 4, r2, c1, c1, 1
-	ldr	r3, =(HDCR_TPM|HDCR_TPMCR)
+	ldr	r3, =(HDCR_TPM|HDCR_TPMCR|HDCR_TDRA|HDCR_TDOSA|HDCR_TDA)
 	.if \operation == vmentry
 	orr	r2, r2, r3		@ Trap some perfmon accesses
 	.else
-- 
1.7.12.4
