From: Ashok Kumar <ashoks@broadcom.com>
Subject: [RFC PATCH] arm64: KVM: Allow userspace to configure guest MPIDR_EL1
Date: Wed, 20 Apr 2016 07:08:39 -0700
Message-ID: <1461161319-38835-1-git-send-email-ashoks@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: drjones@redhat.com, marc.zyngier@arm.com, will.deacon@arm.com, shannon.zhao@linaro.org, Ashok Kumar <ashoks@broadcom.com>, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

For guests with NUMA configuration, Node ID needs to
be recorded in the respective affinity byte of MPIDR_EL1.

Cache the MPIDR_EL1 programmed by userspace and use it for
subsequent reset_mpidr calls.

Signed-off-by: Ashok Kumar <ashoks@broadcom.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/sys_regs.c         | 44 ++++++++++++++++++++++++++++-----------
 2 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f5c6bd2..1fc723d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -197,6 +197,7 @@ struct kvm_vcpu_arch {
 	/* HYP configuration */
 	u64 hcr_el2;
 	u32 mdcr_el2;
+	u64 vmpidr_el2;
 
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7bbe3ff..468f251 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -424,21 +424,29 @@ static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_sys_reg(vcpu, AMAIR_EL1) = amair;
 }
 
+static int set_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+		     const struct kvm_one_reg *reg, void __user *uaddr);
+
 static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 mpidr;
 
-	/*
-	 * Map the vcpu_id into the first three affinity level fields of
-	 * the MPIDR. We limit the number of VCPUs in level 0 due to a
-	 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
-	 * of the GICv3 to be able to address each CPU directly when
-	 * sending IPIs.
-	 */
-	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
-	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
-	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
-	vcpu_sys_reg(vcpu, MPIDR_EL1) = (1ULL << 31) | mpidr;
+	if (!vcpu->arch.vmpidr_el2) {
+		/*
+		 * Map the vcpu_id into the first three affinity level fields of
+		 * the MPIDR. We limit the number of VCPUs in level 0 due to a
+		 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
+		 * of the GICv3 to be able to address each CPU directly when
+		 * sending IPIs.
+		 */
+		mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
+		mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
+		mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
+		vcpu_sys_reg(vcpu, MPIDR_EL1) = (1ULL << 31) | mpidr;
+	} else {
+		/* use the userspace configured value */
+		vcpu_sys_reg(vcpu, MPIDR_EL1) = vcpu->arch.vmpidr_el2;
+	}
 }
 
 static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
@@ -902,7 +910,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* MPIDR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b101),
-	  NULL, reset_mpidr, MPIDR_EL1 },
+	  NULL, reset_mpidr, MPIDR_EL1, 0, NULL, set_mpidr },
 	/* SCTLR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b000),
 	  access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
@@ -2034,6 +2042,18 @@ static int demux_c15_set(u64 id, void __user *uaddr)
 	}
 }
 
+static int set_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+		     const struct kvm_one_reg *reg, void __user *uaddr)
+{
+	int ret;
+
+	ret = reg_from_user(&vcpu_sys_reg(vcpu, rd->reg), uaddr, reg->id);
+	if (!ret)
+		vcpu->arch.vmpidr_el2 = vcpu_sys_reg(vcpu, rd->reg);
+
+	return ret;
+}
+
 int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	const struct sys_reg_desc *r;
-- 
2.1.0
