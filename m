From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 30/41] KVM: arm64: Prepare to handle deferred save/restore
 of 32-bit registers
Date: Fri, 12 Jan 2018 13:07:36 +0100
Message-ID: <20180112120747.27999-31-christoffer.dall@linaro.org>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C61349E12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4RrxHOTxDqjj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jan 2018 07:03:51 -0500 (EST)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5261949E18
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:47 -0500 (EST)
Received: by mail-wm0-f67.google.com with SMTP id i186so11589006wmi.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 04:08:37 -0800 (PST)
In-Reply-To: <20180112120747.27999-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

32-bit registers are not used by a 64-bit host kernel and can be
deferred, but we need to rework the accesses to this register to access
the latest value depending on whether or not guest system registers are
loaded on the CPU or only reside in memory.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 32 +++++-------------
 arch/arm64/kvm/regmap.c              | 65 ++++++++++++++++++++++++++----------
 arch/arm64/kvm/sys_regs.c            |  6 ++--
 3 files changed, 60 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index c9ca2dc579c7..a27610185906 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -33,7 +33,8 @@
 #include <asm/virt.h>
 
 unsigned long *vcpu_reg32(const struct kvm_vcpu *vcpu, u8 reg_num);
-unsigned long *vcpu_spsr32(const struct kvm_vcpu *vcpu);
+unsigned long vcpu_read_spsr32(const struct kvm_vcpu *vcpu);
+void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v);
 
 bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
 void kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr);
@@ -150,41 +151,26 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
 
 static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
 {
-	unsigned long *p = (unsigned long *)&vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1];
-
-	if (vcpu_mode_is_32bit(vcpu)) {
-		unsigned long *p_32bit = vcpu_spsr32(vcpu);
-
-		/* KVM_SPSR_SVC aliases KVM_SPSR_EL1 */
-		if (p_32bit != (unsigned long *)p)
-			return *p_32bit;
-	}
+	if (vcpu_mode_is_32bit(vcpu))
+		return vcpu_read_spsr32(vcpu);
 
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		return read_sysreg_el1(spsr);
 	else
-		return *p;
+		return vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1];
 }
 
-static inline void vcpu_write_spsr(const struct kvm_vcpu *vcpu, unsigned long v)
+static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
 {
-	unsigned long *p = (unsigned long *)&vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1];
-
-	/* KVM_SPSR_SVC aliases KVM_SPSR_EL1 */
 	if (vcpu_mode_is_32bit(vcpu)) {
-		unsigned long *p_32bit = vcpu_spsr32(vcpu);
-
-		/* KVM_SPSR_SVC aliases KVM_SPSR_EL1 */
-		if (p_32bit != (unsigned long *)p) {
-			*p_32bit = v;
-			return;
-		}
+		vcpu_write_spsr32(vcpu, v);
+		return;
 	}
 
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		write_sysreg_el1(v, spsr);
 	else
-		*p = v;
+		vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1] = v;
 }
 
 static inline bool vcpu_mode_priv(const struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/regmap.c b/arch/arm64/kvm/regmap.c
index bbc6ae32e4af..3f65098aff8d 100644
--- a/arch/arm64/kvm/regmap.c
+++ b/arch/arm64/kvm/regmap.c
@@ -141,28 +141,59 @@ unsigned long *vcpu_reg32(const struct kvm_vcpu *vcpu, u8 reg_num)
 /*
  * Return the SPSR for the current mode of the virtual CPU.
  */
-unsigned long *vcpu_spsr32(const struct kvm_vcpu *vcpu)
+static int vcpu_spsr32_mode(const struct kvm_vcpu *vcpu)
 {
 	unsigned long mode = *vcpu_cpsr(vcpu) & COMPAT_PSR_MODE_MASK;
 	switch (mode) {
-	case COMPAT_PSR_MODE_SVC:
-		mode = KVM_SPSR_SVC;
-		break;
-	case COMPAT_PSR_MODE_ABT:
-		mode = KVM_SPSR_ABT;
-		break;
-	case COMPAT_PSR_MODE_UND:
-		mode = KVM_SPSR_UND;
-		break;
-	case COMPAT_PSR_MODE_IRQ:
-		mode = KVM_SPSR_IRQ;
-		break;
-	case COMPAT_PSR_MODE_FIQ:
-		mode = KVM_SPSR_FIQ;
-		break;
+	case COMPAT_PSR_MODE_SVC: return KVM_SPSR_SVC;
+	case COMPAT_PSR_MODE_ABT: return KVM_SPSR_ABT;
+	case COMPAT_PSR_MODE_UND: return KVM_SPSR_UND;
+	case COMPAT_PSR_MODE_IRQ: return KVM_SPSR_IRQ;
+	case COMPAT_PSR_MODE_FIQ: return KVM_SPSR_FIQ;
+	default: BUG();
+	}
+}
+
+unsigned long vcpu_read_spsr32(const struct kvm_vcpu *vcpu)
+{
+	int spsr_idx = vcpu_spsr32_mode(vcpu);
+
+	if (!vcpu->arch.sysregs_loaded_on_cpu)
+		return vcpu_gp_regs(vcpu)->spsr[spsr_idx];
+
+	switch (spsr_idx) {
+	case KVM_SPSR_SVC:
+		return read_sysreg_el1(spsr);
+	case KVM_SPSR_ABT:
+		return read_sysreg(spsr_abt);
+	case KVM_SPSR_UND:
+		return read_sysreg(spsr_und);
+	case KVM_SPSR_IRQ:
+		return read_sysreg(spsr_irq);
+	case KVM_SPSR_FIQ:
+		return read_sysreg(spsr_fiq);
 	default:
 		BUG();
 	}
+}
 
-	return (unsigned long *)&vcpu_gp_regs(vcpu)->spsr[mode];
+void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v)
+{
+	int spsr_idx = vcpu_spsr32_mode(vcpu);
+
+	if (!vcpu->arch.sysregs_loaded_on_cpu)
+		vcpu_gp_regs(vcpu)->spsr[spsr_idx] = v;
+
+	switch (spsr_idx) {
+	case KVM_SPSR_SVC:
+		write_sysreg_el1(v, spsr);
+	case KVM_SPSR_ABT:
+		write_sysreg(v, spsr_abt);
+	case KVM_SPSR_UND:
+		write_sysreg(v, spsr_und);
+	case KVM_SPSR_IRQ:
+		write_sysreg(v, spsr_irq);
+	case KVM_SPSR_FIQ:
+		write_sysreg(v, spsr_fiq);
+	}
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8df651a8a36c..096ac84c9bbd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -175,10 +175,10 @@ DECLARE_IMMEDIATE_SR(PMINTENSET_EL1);
 DECLARE_IMMEDIATE_SR(PMOVSSET_EL0);
 DECLARE_IMMEDIATE_SR(PMSWINC_EL0);
 DECLARE_IMMEDIATE_SR(PMUSERENR_EL0);
-DECLARE_IMMEDIATE_SR(DACR32_EL2);
-DECLARE_IMMEDIATE_SR(IFSR32_EL2);
+DECLARE_DEFERRABLE_SR(DACR32_EL2,	SYS_DACR32_EL2);
+DECLARE_DEFERRABLE_SR(IFSR32_EL2,	SYS_IFSR32_EL2);
 DECLARE_IMMEDIATE_SR(FPEXC32_EL2);
-DECLARE_IMMEDIATE_SR(DBGVCR32_EL2);
+DECLARE_DEFERRABLE_SR(DBGVCR32_EL2,	SYS_DBGVCR32_EL2);
 
 static const struct sys_reg_accessor sys_reg_accessors[NR_SYS_REGS] = {
 	[0 ... NR_SYS_REGS - 1] = {
-- 
2.14.2
