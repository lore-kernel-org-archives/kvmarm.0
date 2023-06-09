Received: from out-4.mta1.migadu.com (out-4.mta1.migadu.com [95.215.58.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5441548C
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 19:01:22 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686337280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w/FQV1u6k/vmjhjKH6y7PilsmMno9isZ0LhyzzC2110=;
	b=fBpK2qOzR8aClywwyMse2BXuq2254jQEOY513gG0PjXSBmYM5DJa4ajexvTKKkJqVp4+Vj
	zKyG1HHecoNfrWBsyHV/m4UXw1jSmgzetZBENfJpKNixR6p7BkkopCbk2R+8T1f12nNlRA
	x7IX0OJXGkz4VD9oLNx0lb+kflyLNv8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	surajjs@amazon.com,
	Cornelia Huck <cohuck@redhat.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v12 06/11] KVM: arm64: Save ID registers' sanitized value per guest
Date: Fri,  9 Jun 2023 19:00:49 +0000
Message-ID: <20230609190054.1542113-7-oliver.upton@linux.dev>
In-Reply-To: <20230609190054.1542113-1-oliver.upton@linux.dev>
References: <20230609190054.1542113-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Jing Zhang <jingzhangos@google.com>

Initialize the default ID register values upon the first call to
KVM_ARM_VCPU_INIT. The vCPU feature flags are finalized at that point,
so it is possible to determine the maximum feature set supported by a
particular VM configuration. Do nothing with these values for now, as we
need to rework the plumbing of what's already writable to be compatible
with the generic infrastructure.

Co-developed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
[Oliver: Hoist everything into KVM_ARM_VCPU_INIT time, so the features
 are final]
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h | 15 +++++++++
 arch/arm64/kvm/sys_regs.c         | 56 +++++++++++++++++++++++++++++--
 arch/arm64/kvm/sys_regs.h         |  7 ++++
 3 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 44da989435fc..39270bc29a3f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -225,6 +225,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE		6
 	/* SMCCC filter initialized for the VM */
 #define KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED		7
+	/* Initial ID reg values loaded */
+#define KVM_ARCH_FLAG_ID_REGS_INITIALIZED		8
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
@@ -247,6 +249,19 @@ struct kvm_arch {
 	struct kvm_smccc_features smccc_feat;
 	struct maple_tree smccc_filter;
 
+	/*
+	 * Emulated CPU ID registers per VM
+	 * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved in it
+	 * is (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
+	 *
+	 * These emulated idregs are VM-wide, but accessed from the context of a vCPU.
+	 * Atomic access to multiple idregs are guarded by kvm_arch.config_lock.
+	 */
+#define IDREG_IDX(id)		(((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
+#define IDREG(kvm, id)		((kvm)->arch.id_regs[IDREG_IDX(id)])
+#define KVM_ARM_ID_REG_NUM	(IDREG_IDX(sys_reg(3, 0, 0, 7, 7)) + 1)
+	u64 id_regs[KVM_ARM_ID_REG_NUM];
+
 	/*
 	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
 	 * the associated pKVM instance in the hypervisor.
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9d37f16cfb7b..3015c860deca 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1311,6 +1311,17 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, const struct sys_reg_desc *r
 	return __kvm_read_sanitised_id_reg(vcpu, r);
 }
 
+/*
+ * Return true if the register's (Op0, Op1, CRn, CRm, Op2) is
+ * (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
+ */
+static inline bool is_id_reg(u32 id)
+{
+	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
+		sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 1 &&
+		sys_reg_CRm(id) < 8);
+}
+
 static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
 				  const struct sys_reg_desc *r)
 {
@@ -2303,6 +2314,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(SP_EL2, NULL, reset_unknown, 0),
 };
 
+static const struct sys_reg_desc *first_idreg;
+
 static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -2993,6 +3006,28 @@ static bool emulate_sys_reg(struct kvm_vcpu *vcpu,
 	return false;
 }
 
+static void kvm_reset_id_regs(struct kvm_vcpu *vcpu)
+{
+	const struct sys_reg_desc *idreg = first_idreg;
+	u32 id = reg_to_encoding(idreg);
+	struct kvm *kvm = vcpu->kvm;
+
+	if (test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags))
+		return;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	/* Initialize all idregs */
+	while (is_id_reg(id)) {
+		IDREG(kvm, id) = idreg->reset(vcpu, idreg);
+
+		idreg++;
+		id = reg_to_encoding(idreg);
+	}
+
+	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
+}
+
 /**
  * kvm_reset_sys_regs - sets system registers to reset value
  * @vcpu: The VCPU pointer
@@ -3004,9 +3039,17 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 {
 	unsigned long i;
 
-	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++)
-		if (sys_reg_descs[i].reset)
-			sys_reg_descs[i].reset(vcpu, &sys_reg_descs[i]);
+	kvm_reset_id_regs(vcpu);
+
+	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
+		const struct sys_reg_desc *r = &sys_reg_descs[i];
+
+		if (is_id_reg(reg_to_encoding(r)))
+			continue;
+
+		if (r->reset)
+			r->reset(vcpu, r);
+	}
 }
 
 /**
@@ -3413,6 +3456,7 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 
 int __init kvm_sys_reg_table_init(void)
 {
+	struct sys_reg_params params;
 	bool valid = true;
 	unsigned int i;
 
@@ -3431,5 +3475,11 @@ int __init kvm_sys_reg_table_init(void)
 	for (i = 0; i < ARRAY_SIZE(invariant_sys_regs); i++)
 		invariant_sys_regs[i].reset(NULL, &invariant_sys_regs[i]);
 
+	/* Find the first idreg (SYS_ID_PFR0_EL1) in sys_reg_descs. */
+	params = encoding_to_params(SYS_ID_PFR0_EL1);
+	first_idreg = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	if (!first_idreg)
+		return -EINVAL;
+
 	return 0;
 }
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 63bca7521dfd..c65c129b3500 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -27,6 +27,13 @@ struct sys_reg_params {
 	bool	is_write;
 };
 
+#define encoding_to_params(reg)						\
+	((struct sys_reg_params){ .Op0 = sys_reg_Op0(reg),		\
+				  .Op1 = sys_reg_Op1(reg),		\
+				  .CRn = sys_reg_CRn(reg),		\
+				  .CRm = sys_reg_CRm(reg),		\
+				  .Op2 = sys_reg_Op2(reg) })
+
 #define esr_sys64_to_params(esr)                                               \
 	((struct sys_reg_params){ .Op0 = ((esr) >> 20) & 3,                    \
 				  .Op1 = ((esr) >> 14) & 0x7,                  \
-- 
2.41.0.162.gfafddb0af9-goog

