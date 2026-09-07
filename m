Received: from mta1.migadu.com (out-247.mta1.migadu.com [95.215.58.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55BC40F724
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 07:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.247
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788764454; cv=none; b=ejKyy+e2IAB6/jqAhXVVZkCH6eU7Wox54exGhfyLDCaO0WdM+bElkOuszVjgqSyTLZFcV/7ZmZbB6cUsC5+7O7xKHz/X3b3fcmqEEwK1Z/wD7aIP8rF54R/j7hbYdKVG98+p6GjpyMswoz0OhPA4zp+C2up9Dt8iiWKvWY70wFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788764454; c=relaxed/simple;
	bh=il04srBHnxBWpSw+vl62VbPSEc2pLy5hniPh6DBOpjc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bl9OktCItUMiEqOFA8+pnBf7pVRwfom8o2HDEqWr9VjIL1TH4vEFXhKhNmiwXsr4US+xKsWXcpVDo/UsJ7xvIC5LkeIn5O55Qulyk+01o9pA/4ZehTvauWIqga/7/gxJDekZ14YrATwSYxWHFihsUlIFRXkJBsCj6KWMtE0cxno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DU23OkbV; arc=none smtp.client-ip=95.215.58.247
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DU23OkbV"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=il04srBHnxBWpSw+vl62VbPSEc2pLy5hniPh6DBOpjc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788764449; v=1; x=1789369249;
 b=DU23OkbVg+BWFrcaYaPkuEg/skYvME+1ormGtVmhQECUZWxHiGlfL7bBElhQ2FWrjwUMaIMS
 krOgzrAo9mUC5clFcD1e/S13pxyxqvqO6n5yeROpnk89DwcJd+b0Lo3cEgK5sZ1/SFmQhpkrf4u
 /6XU4W7O/BLPYOOzjwFS7R50=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 7979d0f1f2c79ca0;
	Mon, 07 Sep 2026 07:00:49 +0000
X-Mizu-Trace-ID: 7979d0f1f2c79ca0
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 06/17] KVM: arm64: Add system register reset framework for protected VMs
Date: Mon,  7 Sep 2026 07:59:51 +0100
Message-Id: <20260907070002.3333525-7-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260907070002.3333525-1-fuad.tabba@linux.dev>
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add kvm_reset_pvm_sys_regs() and the pvm_sys_reg_reset_vals[] table
that drives it, and call it from init_pkvm_hyp_vcpu() for protected
vCPUs. The table holds the registers sys_regs.c resets that
__sysreg_restore_state_nvhe() loads for a protected vCPU. The rest of
the context keeps the zero the donated hyp vCPU page is cleared to. A
poison value stands in where sys_regs.c resets to UNKNOWN, and for
VBAR_EL1 and CONTEXTIDR_EL1 in place of the 0 it uses. MPIDR_EL1 is
derived from vcpu_id, as for any KVM guest. AMAIR_EL1 resets to 0
where sys_regs.c reads the hardware: the host writes it freely before
the hypercall, and it's loaded on every guest entry.

Until the per-EC marshalling patch removes the host's full-context
copy from flush_hyp_vcpu(), that copy overwrites these values on every
entry, so this patch has no observable effect on its own.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c         |  5 ++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c     | 73 ++++++++++++++++++++++++--
 3 files changed, 75 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 49a0a992047ba..a04b7c04d5135 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -95,6 +95,7 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code);
 bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
 bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
 void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
+void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu);
 int kvm_check_pvm_sysreg_table(void);
 
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index e85f13233da08..af334318d0a03 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -551,6 +551,11 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 		goto done;
 
 	ret = pkvm_vcpu_init_sve(hyp_vcpu, host_vcpu);
+	if (ret)
+		goto done;
+
+	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		kvm_reset_pvm_sys_regs(&hyp_vcpu->vcpu);
 done:
 	if (ret)
 		unpin_host_vcpu(host_vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 8758c68017765..03d2c2447e0fd 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -525,6 +525,66 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	/* Performance Monitoring Registers are restricted. */
 };
 
+struct sys_reg_desc_reset {
+	int reg;
+	void (*reset)(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *rd);
+	u64 value;
+};
+
+static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *r)
+{
+	__vcpu_assign_sys_reg(vcpu, r->reg, kvm_calculate_mpidr(vcpu));
+}
+
+static void reset_value(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *r)
+{
+	__vcpu_assign_sys_reg(vcpu, r->reg, r->value);
+}
+
+#define RESET_VAL(REG, RESET_VAL) {  REG, reset_value, RESET_VAL }
+
+#define RESET_ZERO(REG) RESET_VAL(REG, 0)
+
+#define RESET_UNKNOWN(REG) RESET_VAL(REG, 0x1de7ec7edbadc0deULL)
+
+#define RESET_FUNC(REG, RESET_FUNC) {  REG, RESET_FUNC, 0 }
+
+/* Sorted ascending by reg; kvm_check_pvm_sysreg_table() enforces it. */
+static const struct sys_reg_desc_reset pvm_sys_reg_reset_vals[] = {
+	RESET_FUNC(MPIDR_EL1, reset_mpidr),
+	RESET_UNKNOWN(TPIDR_EL0),
+	RESET_UNKNOWN(TPIDRRO_EL0),
+	RESET_UNKNOWN(TPIDR_EL1),
+	RESET_ZERO(CNTKCTL_EL1),
+	RESET_UNKNOWN(PAR_EL1),
+	RESET_ZERO(DISR_EL1),
+	RESET_ZERO(CPACR_EL1),
+	RESET_VAL(CONTEXTIDR_EL1, 0x00000000dbadc0deULL),
+	RESET_VAL(SCTLR_EL1, 0x00C50078ULL),
+	RESET_ZERO(TCR_EL1),
+	RESET_UNKNOWN(AFSR0_EL1),
+	RESET_UNKNOWN(AFSR1_EL1),
+	RESET_UNKNOWN(ESR_EL1),
+	RESET_UNKNOWN(MAIR_EL1),
+	RESET_ZERO(AMAIR_EL1),
+	RESET_ZERO(MDSCR_EL1),
+	RESET_UNKNOWN(TTBR0_EL1),
+	RESET_UNKNOWN(TTBR1_EL1),
+	RESET_UNKNOWN(FAR_EL1),
+	RESET_VAL(VBAR_EL1, 0x1de7ec7edbadc000ULL),
+};
+
+void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu)
+{
+	unsigned long i;
+
+	for (i = 0; i < ARRAY_SIZE(pvm_sys_reg_reset_vals); i++) {
+		const struct sys_reg_desc_reset *r = &pvm_sys_reg_reset_vals[i];
+
+		r->reset(vcpu, r);
+	}
+}
+
 /*
  * Initializes feature registers for protected vms.
  */
@@ -550,16 +610,21 @@ void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Checks that the sysreg table is unique and in-order.
- *
- * Returns 0 if the table is consistent, or 1 otherwise.
+ * Both tables must be unique and sorted ascending. pvm_sys_reg_descs.reg is the
+ * sys_reg() encoding, pvm_sys_reg_reset_vals.reg the vcpu_sysreg index, so they
+ * compare differently. BUG_ON() at __pkvm_init: fatal at boot.
  */
 int kvm_check_pvm_sysreg_table(void)
 {
 	unsigned int i;
 
 	for (i = 1; i < ARRAY_SIZE(pvm_sys_reg_descs); i++) {
-		if (cmp_sys_reg(&pvm_sys_reg_descs[i-1], &pvm_sys_reg_descs[i]) >= 0)
+		if (cmp_sys_reg(&pvm_sys_reg_descs[i - 1], &pvm_sys_reg_descs[i]) >= 0)
+			return 1;
+	}
+
+	for (i = 1; i < ARRAY_SIZE(pvm_sys_reg_reset_vals); i++) {
+		if (pvm_sys_reg_reset_vals[i - 1].reg >= pvm_sys_reg_reset_vals[i].reg)
 			return 1;
 	}
 
-- 
2.39.5

