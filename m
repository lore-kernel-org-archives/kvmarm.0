From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v4 4/4] KVM: arm64: Get rid of old vcpu_reg()
Date: Fri, 04 Dec 2015 15:03:14 +0300
Message-ID: <37aa6d529ed5c6df02b885eb7f791cddbccd02d7.1449230499.git.p.fedin@samsung.com>
References: <cover.1449230499.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DDF34999D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2015 07:01:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ysuAZUXkyA5f for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Dec 2015 07:01:47 -0500 (EST)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8CEF5498D0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2015 07:01:47 -0500 (EST)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYU0002Y1HLXJ00@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 04 Dec 2015 12:03:21 +0000 (GMT)
In-reply-to: <cover.1449230499.git.p.fedin@samsung.com>
In-reply-to: <cover.1449230499.git.p.fedin@samsung.com>
References: <cover.1449230499.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Using oldstyle vcpu_reg() accessor is proven to be inappropriate and
unsafe on ARM64. This patch converts the rest of use cases to new
accessors and completely removes vcpu_reg() on ARM64.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/psci.c                  | 20 ++++++++++----------
 arch/arm64/include/asm/kvm_emulate.h | 11 +++--------
 arch/arm64/kvm/handle_exit.c         |  2 +-
 3 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index 0b55696..a9b3b90 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -75,7 +75,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	unsigned long context_id;
 	phys_addr_t target_pc;
 
-	cpu_id = *vcpu_reg(source_vcpu, 1) & MPIDR_HWID_BITMASK;
+	cpu_id = vcpu_get_reg(source_vcpu, 1) & MPIDR_HWID_BITMASK;
 	if (vcpu_mode_is_32bit(source_vcpu))
 		cpu_id &= ~((u32) 0);
 
@@ -94,8 +94,8 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 			return PSCI_RET_INVALID_PARAMS;
 	}
 
-	target_pc = *vcpu_reg(source_vcpu, 2);
-	context_id = *vcpu_reg(source_vcpu, 3);
+	target_pc = vcpu_get_reg(source_vcpu, 2);
+	context_id = vcpu_get_reg(source_vcpu, 3);
 
 	kvm_reset_vcpu(vcpu);
 
@@ -114,7 +114,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 * NOTE: We always update r0 (or x0) because for PSCI v0.1
 	 * the general puspose registers are undefined upon CPU_ON.
 	 */
-	*vcpu_reg(vcpu, 0) = context_id;
+	vcpu_set_reg(vcpu, 0, context_id);
 	vcpu->arch.power_off = false;
 	smp_mb();		/* Make sure the above is visible */
 
@@ -134,8 +134,8 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_vcpu *tmp;
 
-	target_affinity = *vcpu_reg(vcpu, 1);
-	lowest_affinity_level = *vcpu_reg(vcpu, 2);
+	target_affinity = vcpu_get_reg(vcpu, 1);
+	lowest_affinity_level = vcpu_get_reg(vcpu, 2);
 
 	/* Determine target affinity mask */
 	target_affinity_mask = psci_affinity_mask(lowest_affinity_level);
@@ -209,7 +209,7 @@ int kvm_psci_version(struct kvm_vcpu *vcpu)
 static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 {
 	int ret = 1;
-	unsigned long psci_fn = *vcpu_reg(vcpu, 0) & ~((u32) 0);
+	unsigned long psci_fn = vcpu_get_reg(vcpu, 0) & ~((u32) 0);
 	unsigned long val;
 
 	switch (psci_fn) {
@@ -273,13 +273,13 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 		break;
 	}
 
-	*vcpu_reg(vcpu, 0) = val;
+	vcpu_set_reg(vcpu, 0, val);
 	return ret;
 }
 
 static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 {
-	unsigned long psci_fn = *vcpu_reg(vcpu, 0) & ~((u32) 0);
+	unsigned long psci_fn = vcpu_get_reg(vcpu, 0) & ~((u32) 0);
 	unsigned long val;
 
 	switch (psci_fn) {
@@ -295,7 +295,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 		break;
 	}
 
-	*vcpu_reg(vcpu, 0) = val;
+	vcpu_set_reg(vcpu, 0, val);
 	return 1;
 }
 
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5a182af..25a4021 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -100,15 +100,10 @@ static inline void vcpu_set_thumb(struct kvm_vcpu *vcpu)
 }
 
 /*
- * vcpu_reg should always be passed a register number coming from a
- * read of ESR_EL2. Otherwise, it may give the wrong result on AArch32
- * with banked registers.
+ * vcpu_get_reg and vcpu_set_reg should always be passed a register number
+ * coming from a read of ESR_EL2. Otherwise, it may give the wrong result on
+ * AArch32 with banked registers.
  */
-static inline unsigned long *vcpu_reg(const struct kvm_vcpu *vcpu, u8 reg_num)
-{
-	return (unsigned long *)&vcpu_gp_regs(vcpu)->regs.regs[reg_num];
-}
-
 static inline unsigned long vcpu_get_reg(const struct kvm_vcpu *vcpu,
 					 u8 reg_num)
 {
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 68a0759..15f0477 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -37,7 +37,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	int ret;
 
-	trace_kvm_hvc_arm64(*vcpu_pc(vcpu), *vcpu_reg(vcpu, 0),
+	trace_kvm_hvc_arm64(*vcpu_pc(vcpu), vcpu_get_reg(vcpu, 0),
 			    kvm_vcpu_hvc_get_imm(vcpu));
 
 	ret = kvm_psci_call(vcpu);
-- 
2.4.4
