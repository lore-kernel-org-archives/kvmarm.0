From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 34/38] KVM: arm64: Respect the virtual HCR_EL2.NV bit
 setting
Date: Tue, 18 Jul 2017 11:59:00 -0500
Message-ID: <1500397144-16232-35-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31B5B49C7B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EyVrWvH3bJf0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:59:53 -0400 (EDT)
Received: from mail-it0-f45.google.com (mail-it0-f45.google.com
 [209.85.214.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 166F249C86
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:52 -0400 (EDT)
Received: by mail-it0-f45.google.com with SMTP id a62so23805870itd.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 10:00:41 -0700 (PDT)
In-Reply-To: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, will.deacon@arm.com, stefan@hello-penguin.com, corbet@lwn.net, daniel.lezcano@linaro.org, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andy.gross@linaro.org, cov@codeaurora.org, wcohen@redhat.com, mchehab@kernel.org, ard.biesheuvel@linaro.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

Forward traps due to HCR_EL2.NV bit to the virtual EL2 if they are not
coming from the virtual EL2 and the virtual HCR_EL2.NV bit is set.

This is for recursive nested virtualization.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/include/asm/kvm_arm.h    |  1 +
 arch/arm64/include/asm/kvm_coproc.h |  1 +
 arch/arm64/kvm/handle_exit.c        | 13 +++++++++++++
 arch/arm64/kvm/sys_regs.c           | 22 ++++++++++++++++++++++
 4 files changed, 37 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 6e99978..aeaac4e 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -23,6 +23,7 @@
 #include <asm/types.h>
 
 /* Hyp Configuration Register (HCR) bits */
+#define HCR_NV		(UL(1) << 42)
 #define HCR_E2H		(UL(1) << 34)
 #define HCR_ID		(UL(1) << 33)
 #define HCR_CD		(UL(1) << 32)
diff --git a/arch/arm64/include/asm/kvm_coproc.h b/arch/arm64/include/asm/kvm_coproc.h
index 1b3d21b..6223df6 100644
--- a/arch/arm64/include/asm/kvm_coproc.h
+++ b/arch/arm64/include/asm/kvm_coproc.h
@@ -44,6 +44,7 @@ void kvm_register_target_sys_reg_table(unsigned int target,
 int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_sys(struct kvm_vcpu *vcpu, struct kvm_run *run);
+bool forward_nv_traps(struct kvm_vcpu *vcpu);
 
 #define kvm_coproc_table_init kvm_sys_reg_table_init
 void kvm_sys_reg_table_init(void);
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index d4e7b2b..fccd9d6 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -61,6 +61,12 @@ static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	int ret;
 
+	/*
+	 * Forward this trapped smc instruction to the virtual EL2.
+	 */
+	if (forward_nv_traps(vcpu) && (vcpu_sys_reg(vcpu, HCR_EL2) & HCR_TSC))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+
 	/* If imm is non-zero, it's not defined */
 	if (kvm_vcpu_hvc_get_imm(vcpu)) {
 		kvm_inject_undefined(vcpu);
@@ -197,6 +203,13 @@ static int kvm_handle_eret(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			      vcpu_el2_sreg(vcpu, SPSR_EL2));
 
 	/*
+	 * Forward this trap to the virtual EL2 if the virtual HCR_EL2.NV
+	 * bit is set.
+	 */
+	if (forward_nv_traps(vcpu))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+
+	/*
 	 * Note that the current exception level is always the virtual EL2,
 	 * since we set HCR_EL2.NV bit only when entering the virtual EL2.
 	 */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 910b50d..4fd7090 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -939,6 +939,14 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/* This function is to support the recursive nested virtualization */
+bool forward_nv_traps(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu_mode_el2(vcpu) && (vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV))
+		return true;
+	return false;
+}
+
 static inline void access_rw(struct sys_reg_params *p, u64 *sysreg)
 {
 	if (!p->is_write)
@@ -977,6 +985,13 @@ static bool trap_el2_regs(struct kvm_vcpu *vcpu,
 {
 	u64 *sys_reg;
 
+	/*
+	 * Forward this trap to the virtual EL2 if the virtual HCR_EL2.NV
+	 * bit is set.
+	 */
+	if (forward_nv_traps(vcpu))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+
 	sys_reg = get_special_reg(vcpu, p);
 	if (!sys_reg)
 		sys_reg = &vcpu_sys_reg(vcpu, r->reg);
@@ -1914,6 +1929,13 @@ static int emulate_sys_instr(struct kvm_vcpu *vcpu,
 {
 	int ret = 0;
 
+	/*
+	 * Forward this trap to the virtual EL2 if the virtual HCR_EL2.NV
+	 * bit is set.
+	 */
+	if (forward_nv_traps(vcpu))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+
 	/* TLB maintenance instructions*/
 	if (params->CRn == 0b1000)
 		ret = emulate_tlbi(vcpu, params);
-- 
1.9.1
