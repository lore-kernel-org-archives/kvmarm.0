From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 27/41] KVM: arm/arm64: Prepare to handle deferred
 save/restore of SPSR_EL1
Date: Fri, 12 Jan 2018 13:07:33 +0100
Message-ID: <20180112120747.27999-28-christoffer.dall@linaro.org>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E32949DF2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d69coRIE2G37 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jan 2018 07:03:44 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C66B49E09
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:43 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id b141so11740910wme.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 04:08:33 -0800 (PST)
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

SPSR_EL1 is not used by a VHE host kernel and can be deferred, but we
need to rework the accesses to this register to access the latest value
depending on whether or not guest system registers are loaded on the CPU
or only reside in memory.

The handling of accessing the various banked SPSRs for 32-bit VMs is a
bit clunky, but this will be improved in following patches which will
first prepare and subsequently implement deferred save/restore of the
32-bit registers, including the 32-bit SPSRs.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_emulate.h   | 12 ++++++++++-
 arch/arm/kvm/emulate.c               |  2 +-
 arch/arm64/include/asm/kvm_emulate.h | 41 +++++++++++++++++++++++++++++++-----
 arch/arm64/kvm/inject_fault.c        |  4 ++--
 virt/kvm/arm/aarch32.c               |  2 +-
 5 files changed, 51 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index d5e1b8bf6422..db8a09e9a16f 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -41,7 +41,17 @@ static inline unsigned long *vcpu_reg32(struct kvm_vcpu *vcpu, u8 reg_num)
 	return vcpu_reg(vcpu, reg_num);
 }
 
-unsigned long *vcpu_spsr(struct kvm_vcpu *vcpu);
+unsigned long *__vcpu_spsr(struct kvm_vcpu *vcpu);
+
+static inline unsigned long vpcu_read_spsr(struct kvm_vcpu *vcpu)
+{
+	return *__vcpu_spsr(vcpu);
+}
+
+static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
+{
+	*__vcpu_spsr(vcpu) = v;
+}
 
 static inline unsigned long vcpu_get_reg(struct kvm_vcpu *vcpu,
 					 u8 reg_num)
diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
index fa501bf437f3..9046b53d87c1 100644
--- a/arch/arm/kvm/emulate.c
+++ b/arch/arm/kvm/emulate.c
@@ -142,7 +142,7 @@ unsigned long *vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num)
 /*
  * Return the SPSR for the current mode of the virtual CPU.
  */
-unsigned long *vcpu_spsr(struct kvm_vcpu *vcpu)
+unsigned long *__vcpu_spsr(struct kvm_vcpu *vcpu)
 {
 	unsigned long mode = *vcpu_cpsr(vcpu) & MODE_MASK;
 	switch (mode) {
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index df1cb146750d..f0bc7c096fdc 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -26,6 +26,7 @@
 
 #include <asm/esr.h>
 #include <asm/kvm_arm.h>
+#include <asm/kvm_hyp.h>
 #include <asm/kvm_mmio.h>
 #include <asm/ptrace.h>
 #include <asm/cputype.h>
@@ -131,13 +132,43 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
 		vcpu_gp_regs(vcpu)->regs.regs[reg_num] = val;
 }
 
-/* Get vcpu SPSR for current mode */
-static inline unsigned long *vcpu_spsr(const struct kvm_vcpu *vcpu)
+static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
 {
-	if (vcpu_mode_is_32bit(vcpu))
-		return vcpu_spsr32(vcpu);
+	unsigned long *p = (unsigned long *)&vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1];
+
+	if (vcpu_mode_is_32bit(vcpu)) {
+		unsigned long *p_32bit = vcpu_spsr32(vcpu);
+
+		/* KVM_SPSR_SVC aliases KVM_SPSR_EL1 */
+		if (p_32bit != (unsigned long *)p)
+			return *p_32bit;
+	}
+
+	if (vcpu->arch.sysregs_loaded_on_cpu)
+		return read_sysreg_el1(spsr);
+	else
+		return *p;
+}
 
-	return (unsigned long *)&vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1];
+static inline void vcpu_write_spsr(const struct kvm_vcpu *vcpu, unsigned long v)
+{
+	unsigned long *p = (unsigned long *)&vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1];
+
+	/* KVM_SPSR_SVC aliases KVM_SPSR_EL1 */
+	if (vcpu_mode_is_32bit(vcpu)) {
+		unsigned long *p_32bit = vcpu_spsr32(vcpu);
+
+		/* KVM_SPSR_SVC aliases KVM_SPSR_EL1 */
+		if (p_32bit != (unsigned long *)p) {
+			*p_32bit = v;
+			return;
+		}
+	}
+
+	if (vcpu->arch.sysregs_loaded_on_cpu)
+		write_sysreg_el1(v, spsr);
+	else
+		*p = v;
 }
 
 static inline bool vcpu_mode_priv(const struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 1e070943e7a6..c638593d305d 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -71,7 +71,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
 
 	*vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
-	*vcpu_spsr(vcpu) = cpsr;
+	vcpu_write_spsr(vcpu, cpsr);
 
 	vcpu_write_sys_reg(vcpu, FAR_EL1, addr);
 
@@ -106,7 +106,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
 
 	*vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
-	*vcpu_spsr(vcpu) = cpsr;
+	vcpu_write_spsr(vcpu, cpsr);
 
 	/*
 	 * Build an unknown exception, depending on the instruction
diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
index 8bc479fa37e6..efc84cbe8277 100644
--- a/virt/kvm/arm/aarch32.c
+++ b/virt/kvm/arm/aarch32.c
@@ -178,7 +178,7 @@ static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 	*vcpu_cpsr(vcpu) = cpsr;
 
 	/* Note: These now point to the banked copies */
-	*vcpu_spsr(vcpu) = new_spsr_value;
+	vcpu_write_spsr(vcpu, new_spsr_value);
 	*vcpu_reg32(vcpu, 14) = *vcpu_pc(vcpu) + return_offset;
 
 	/* Branch to exception vector */
-- 
2.14.2
