Received: from mta0.migadu.com (out-88.mta0.migadu.com [91.218.175.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F73549EC63
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 16:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194085; cv=none; b=KlbniAockPiEPjZMHVMmTuAvD9+mR9AAitB9+J4Oo+h1d9K0Bcin/9i9ixHw/h1/Q5x84tL5shgtwqVWrpoU6S2+S+DyBaCgT0+ianj7+xNhGdz4elOpwQRYrEXIqb/9J7B1PxqA6On6Ce/sxQqr9rKIWWNh4Gr8z7l8ByRVf3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194085; c=relaxed/simple;
	bh=6t1gqYdyhRpYCJ4ePxm8eKCyjmvWIh4HU6EgCqsQmzQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uZyxez4hzB6o82wg5AKv803cGw5q6ElV7tChbgf3oAUOXp7aTzMijMVyZDUaOm8PtUkjqAC/Xdwisnn0yMvlGC1kPpnqWzZ5vQT/fpOGcMMYhXnr7lzCv2/+NNMzFsf7y4cRmUUA58nqxoIaF7TqeWSqra1SZ1yaLmlY+jToIQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IgEYf/Az; arc=none smtp.client-ip=91.218.175.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IgEYf/Az"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=6t1gqYdyhRpYCJ4ePxm8eKCyjmvWIh4HU6EgCqsQmzQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788194081; v=1; x=1788798881;
 b=IgEYf/Az+fqDs23NBg8dsv69+fkBGC62ietkamCYq5kJZ/OlVP5fHWII9/BR/SkI46uaM6qd
 jjN+W+/ebrGd2uTq6FfAuyvOsp9yQhPBXw2Ikn3zNU8skFdjfFZodfnIj+vaLF6+3H3Q15KMnX4
 mFrrvXR25KYGRhE8haZZt/7s=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id faf522f5f8183ba7;
	Mon, 31 Aug 2026 16:34:40 +0000
X-Mizu-Trace-ID: faf522f5f8183ba7
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
Subject: [PATCH 07/17] KVM: arm64: Add system register reset framework for protected VMs
Date: Mon, 31 Aug 2026 17:34:11 +0100
Message-Id: <20260831163421.272420-8-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260831163421.272420-1-fuad.tabba@linux.dev>
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reset a protected VM's system registers at EL2 rather than taking the
host's values: add kvm_reset_pvm_sys_regs() and the
pvm_sys_reg_reset_vals[] table that drives it, and call it from
init_pkvm_hyp_vcpu() for protected vCPUs. The values follow the
host-side reset in sys_regs.c, with a poison value where it resets to
UNKNOWN, and for VBAR_EL1 and CONTEXTIDR_EL1 in place of the 0 it
resets them to. MPIDR_EL1 is derived from vcpu_id, as for any KVM
guest.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c         |  5 ++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c     | 91 ++++++++++++++++++++++++--
 3 files changed, 93 insertions(+), 4 deletions(-)

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
index 8758c68017765..ebfd48aa15b56 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -525,6 +525,84 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	/* Performance Monitoring Registers are restricted. */
 };
 
+struct sys_reg_desc_reset {
+	int reg;
+	void (*reset)(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *rd);
+	u64 value;
+};
+
+/* Hardware value, as sys_regs.c's reset_actlr()/reset_amair_el1(). */
+static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *r)
+{
+	__vcpu_assign_sys_reg(vcpu, r->reg, read_sysreg(actlr_el1));
+}
+
+static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *r)
+{
+	__vcpu_assign_sys_reg(vcpu, r->reg, read_sysreg(amair_el1));
+}
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
+	RESET_ZERO(MDCCINT_EL1),
+	RESET_ZERO(DISR_EL1),
+	RESET_ZERO(PMCCFILTR_EL0),
+	RESET_ZERO(PMUSERENR_EL0),
+	RESET_ZERO(CPACR_EL1),
+	RESET_VAL(CONTEXTIDR_EL1, 0x00000000dbadc0deULL),
+	RESET_VAL(SCTLR_EL1, 0x00C50078ULL),
+	RESET_FUNC(ACTLR_EL1, reset_actlr),
+	RESET_ZERO(TCR_EL1),
+	RESET_UNKNOWN(AFSR0_EL1),
+	RESET_UNKNOWN(AFSR1_EL1),
+	RESET_UNKNOWN(ESR_EL1),
+	RESET_UNKNOWN(MAIR_EL1),
+	RESET_FUNC(AMAIR_EL1, reset_amair_el1),
+	RESET_ZERO(MDSCR_EL1),
+	RESET_ZERO(ZCR_EL1),
+	RESET_UNKNOWN(TTBR0_EL1),
+	RESET_UNKNOWN(TTBR1_EL1),
+	RESET_UNKNOWN(FAR_EL1),
+	RESET_VAL(VBAR_EL1, 0x1de7ec7edbadc000ULL),
+	RESET_UNKNOWN(PIRE0_EL1),
+	RESET_UNKNOWN(PIR_EL1),
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
@@ -550,16 +628,21 @@ void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu)
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

