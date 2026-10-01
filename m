Received: from mta0.migadu.com (out-99.mta0.migadu.com [91.218.175.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98F251121D
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 13:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790863098; cv=none; b=piKfn3Hy21wMI0hP63NKn2Cre4NHoQYLfsJyqTZuEKQlUsrWjuaMG+d99oXm7aPuJXwmMnna2Qg7RnvNMuPqLqiPxnfyKHYZCTV6i8o7DCsuFH4KXLUImdArPdNUrC4KQWLuEIsekEpTuyBMy+N6uAKWYMNptCvoROarPXU/wsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790863098; c=relaxed/simple;
	bh=9nCliy2aYIGuE6P4bJSsRa7bKNW1x8X38VUQa8owlws=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QHDbCFSfilU8UvVlPgpKL0QUdQ0tUZBaQNaL0rZ5PGo0iXng+8DJxmQfUMZMLLVHBTX+DGffRnws5nvhfFO9iDQ0/QhqooTWP00rdkbdYQFvLz4VGC/ma+pMZZgbej+H9iiHWzPkr8maTqo3/lusvh8flDqh/mohouHa4NNtFqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PkTTo4Yw; arc=none smtp.client-ip=91.218.175.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PkTTo4Yw"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=9nCliy2aYIGuE6P4bJSsRa7bKNW1x8X38VUQa8owlws=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790863092; v=1; x=1791467892;
 b=PkTTo4YwIA05hNlgSKAuhflfhFM1Cjjv7j6zdCWm2gbIkPxqNboWEkikaS9wU6ngnUa6tcjf
 jOSFj1cl81um53OVokjY3jJRRrorMxm82W8Tbhbnaw7ONnPZ9jee4oDtqyvgT/lX//2AbqbN6gN
 JBgjYb8jMoBrHA911EgANRVM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d10e3876025132ec;
	Thu, 01 Oct 2026 13:58:12 +0000
X-Mizu-Trace-ID: d10e3876025132ec
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	steven.price@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	tabba@google.com
Subject: [PATCH v4 08/18] KVM: arm64: Add system register reset framework for protected VMs
Date: Thu,  1 Oct 2026 14:57:01 +0100
Message-Id: <20261001135711.1640520-9-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261001135711.1640520-1-fuad.tabba@linux.dev>
References: <20261001135711.1640520-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add kvm_reset_pvm_sys_regs() and the pvm_sys_reg_reset_vals[] table
that drives it, and call it from init_pkvm_hyp_vcpu() for protected
vCPUs. The table holds the registers KVM resets that EL2 loads for a
protected vCPU: the ones __sysreg_restore_state_nvhe() restores, and
CNTV_CTL_EL0, which flush_hyp_timer_state() loads from a copy the
host's kvm_timer_vcpu_reset() doesn't write. The ptrauth keys, which
entry.S loads, are not in the table: sys_regs.c resets them to
UNKNOWN, and a vCPU that CPU_ON brings back keeps the keys the guest
last set, one UNKNOWN value in place of another.

A register that resets to 0 still takes an entry: a later patch calls
kvm_reset_pvm_sys_regs() again for PSCI CPU_ON at EL2, on a context
that has run.

A poison value stands in where sys_regs.c resets to UNKNOWN, and for
VBAR_EL1 and CONTEXTIDR_EL1 in place of the 0 it uses.

MPIDR_EL1 is derived from vcpu_id, as for any KVM guest.

AMAIR_EL1 resets to 0 where sys_regs.c reads the hardware: the host
writes it freely before the hypercall, and it's loaded on every guest
entry.

Until the per-EC marshalling patch removes the host's full-context
copy from flush_hyp_vcpu(), that copy overwrites these values on every
entry. It preserves CNTV_CTL_EL0, whose entry writes the zero the page
already holds. So this patch has no observable effect on its own.

No functional change intended.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c         |  5 +++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c     | 60 ++++++++++++++++++++++++++
 3 files changed, 66 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index ad42abaf31c5c..fcb13d8b4cb69 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -97,6 +97,7 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code);
 bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
 bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
 void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
+void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu);
 int kvm_check_pvm_sysreg_table(void);
 
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 8f3d9c293d186..6ff08d195ff56 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -588,6 +588,11 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
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
index 8758c68017765..87557d1b3bf07 100644
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
+#define RESET_VAL(REG, VAL) {  REG, reset_value, VAL }
+
+#define RESET_ZERO(REG) RESET_VAL(REG, 0)
+
+#define RESET_UNKNOWN(REG) RESET_VAL(REG, 0x1de7ec7edbadc0deULL)
+
+#define RESET_FUNC(REG, FN) {  REG, FN, 0 }
+
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
+	RESET_ZERO(CNTV_CTL_EL0),
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
-- 
2.39.5

