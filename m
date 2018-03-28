From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 42/85] KVM: arm64: Prepare to handle deferred save/restore of
 32-bit registers
Date: Wed, 28 Mar 2018 13:52:11 +0100
Message-ID: <20180328125254.31380-43-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 604BA4A083
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:51:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T7wahIAOrrN9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:50:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EA534A01E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:47:50 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

32-bit registers are not used by a 64-bit host kernel and can be
deferred, but we need to rework the accesses to these register to access
the latest values depending on whether or not guest system registers are
loaded on the CPU or only reside in memory.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 32 +++++------------
 arch/arm64/kvm/regmap.c              | 67 +++++++++++++++++++++++++++---------
 2 files changed, 59 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 6ed18ce0d638..23b33e8ea03a 100644
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
@@ -162,41 +163,26 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
 
 static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
 {
-	unsigned long *p = (unsigned long *)&vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1];
-
-	if (vcpu_mode_is_32bit(vcpu)) {
-		unsigned long *p_32bit = vcpu_spsr32(vcpu);
-
-		/* KVM_SPSR_SVC aliases KVM_SPSR_EL1 */
-		if (p_32bit != p)
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
-		if (p_32bit != p) {
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
index bbc6ae32e4af..eefe403a2e63 100644
--- a/arch/arm64/kvm/regmap.c
+++ b/arch/arm64/kvm/regmap.c
@@ -141,28 +141,61 @@ unsigned long *vcpu_reg32(const struct kvm_vcpu *vcpu, u8 reg_num)
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
+
+void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v)
+{
+	int spsr_idx = vcpu_spsr32_mode(vcpu);
+
+	if (!vcpu->arch.sysregs_loaded_on_cpu) {
+		vcpu_gp_regs(vcpu)->spsr[spsr_idx] = v;
+		return;
+	}
 
-	return (unsigned long *)&vcpu_gp_regs(vcpu)->spsr[mode];
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
-- 
2.14.2
