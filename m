Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052AD10E9
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 00:51:23 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-64d44d14db4so1032410b3a.0
        for <kvmarm@lists.linux.dev>; Thu, 01 Jun 2023 17:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685667083; x=1688259083;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aqqMvtdgU14/NtzieAzXaY8mJ7w2IxxoClOvSCaQaJg=;
        b=s+McyxOhaxJJL+i7Vyyo/somnZMM0z/0zYSWSeKRQc3/Q3YbBtEtpGL4MC81r2wmPb
         /QzHL7YuQxpsCKLwLdQ84uLtPbf3UlKB6pWP68n8HmMm9cvkdn+hrimpWNBHOsu2Nyjr
         K/nkk7vQSha3k7GVl7G9y+BtyHkH24gGnG/qgbkyY4fVP7QESOxHfYOAknmuvn+xrVT1
         V0mVITjr8wEN+yA9rqxflYjmuuYKUwqFBZUALck7YtDi5bGZNJ7bQub0wgpWE2SpQl1p
         WDPsD3Rqwu+juu6VqgLmNp6SoWRGLW1tEzMcU5AoFqWQFg+Oq2nzyDqj7JmT3fusEZay
         qrgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685667083; x=1688259083;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aqqMvtdgU14/NtzieAzXaY8mJ7w2IxxoClOvSCaQaJg=;
        b=d+LCC+mRjdM342vPIUTQJ3qS0XdsktSBlBfyDmaQF6Kf8tplG3ZeUfvAH0A2BJ05pq
         mqGkqpUuhNjPZ/Bns6YyPQ7uZXiBXncRB0dzi4DF9dntb1a+MAaVaulDrMDQrpGAxy0k
         rk0MkpWVVKqxgHDWVNKOZFmhl2qFnDM6tAvrLrpZHpPCkTq2sy5VX52swxtaqVnUlkM1
         AfGOhzmqI7OggDRMpOcas/Epdr2FQjQ3rvby0lHAtlTXa++bvxpNpThsmfGJGyBmNrf0
         XXtCMtncM8/iseKUDsoEXBqpxvASPOlX9+9iLY2Chj4fs67EjFzDsAIbgeEqccc5aYzI
         Nz3Q==
X-Gm-Message-State: AC+VfDx8YRk/4+Ky09rbGfnBtu3GDOpGcMxRFySqIlRXfdNQDGoF4ftr
	+dbHGytVg10TmhYfy1Yk84MSwTZTxVo6FpVxkg==
X-Google-Smtp-Source: ACHHUZ6lmnQi5Dmdp+/y8rYelG42D+OCJubc0W0T2dyXOjAscoq8QNNcX+lSp+L6/PJtbKsKvn3I5N4J5EcEvPgGzA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:1d25:b0:64d:4191:6f39 with
 SMTP id a37-20020a056a001d2500b0064d41916f39mr775807pfx.0.1685667083328; Thu,
 01 Jun 2023 17:51:23 -0700 (PDT)
Date: Fri,  2 Jun 2023 00:51:13 +0000
In-Reply-To: <20230602005118.2899664-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602005118.2899664-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602005118.2899664-2-jingzhangos@google.com>
Subject: [PATCH v11 1/5] KVM: arm64: Save ID registers' sanitized value per guest
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
and save ID registers' sanitized value in the array at KVM_CREATE_VM.
Use the saved ones when ID registers are read by the guest or
userspace (via KVM_GET_ONE_REG).

No functional change intended.

Co-developed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 20 +++++++++
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/sys_regs.c         | 72 +++++++++++++++++++++++++------
 arch/arm64/kvm/sys_regs.h         |  7 +++
 4 files changed, 87 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7e7e19ef6993..069606170c82 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -178,6 +178,21 @@ struct kvm_smccc_features {
 	unsigned long vendor_hyp_bmap;
 };
 
+/*
+ * Emulated CPU ID registers per VM
+ * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved in it
+ * is (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
+ *
+ * These emulated idregs are VM-wide, but accessed from the context of a vCPU.
+ * Atomic access to multiple idregs are guarded by kvm_arch.config_lock.
+ */
+#define IDREG_IDX(id)		(((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
+#define IDREG(kvm, id)		((kvm)->arch.idregs.regs[IDREG_IDX(id)])
+#define KVM_ARM_ID_REG_NUM	(IDREG_IDX(sys_reg(3, 0, 0, 7, 7)) + 1)
+struct kvm_idregs {
+	u64 regs[KVM_ARM_ID_REG_NUM];
+};
+
 typedef unsigned int pkvm_handle_t;
 
 struct kvm_protected_vm {
@@ -253,6 +268,9 @@ struct kvm_arch {
 	struct kvm_smccc_features smccc_feat;
 	struct maple_tree smccc_filter;
 
+	/* Emulated CPU ID registers */
+	struct kvm_idregs idregs;
+
 	/*
 	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
 	 * the associated pKVM instance in the hypervisor.
@@ -1045,6 +1063,8 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 				    struct kvm_arm_counter_offset *offset);
 
+void kvm_arm_init_id_regs(struct kvm *kvm);
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 14391826241c..774656a0718d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -163,6 +163,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	set_default_spectre(kvm);
 	kvm_arm_init_hypercalls(kvm);
+	kvm_arm_init_id_regs(kvm);
 
 	/*
 	 * Initialise the default PMUver before there is a chance to
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 71b12094d613..40a9315015af 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -41,6 +41,7 @@
  * 64bit interface.
  */
 
+static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 encoding);
 static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
 
 static bool read_from_write_only(struct kvm_vcpu *vcpu,
@@ -364,7 +365,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	u64 val = kvm_arm_read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_EL1_LO_SHIFT))) {
@@ -1208,18 +1209,11 @@ static u8 pmuver_to_perfmon(u8 pmuver)
 	}
 }
 
-/* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
+static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 encoding)
 {
-	u32 id = reg_to_encoding(r);
-	u64 val;
+	u64 val = IDREG(vcpu->kvm, encoding);
 
-	if (sysreg_visible_as_raz(vcpu, r))
-		return 0;
-
-	val = read_sanitised_ftr_reg(id);
-
-	switch (id) {
+	switch (encoding) {
 	case SYS_ID_AA64PFR0_EL1:
 		if (!vcpu_has_sve(vcpu))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
@@ -1280,6 +1274,26 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r
 	return val;
 }
 
+/* Read a sanitised cpufeature ID register by sys_reg_desc */
+static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
+{
+	if (sysreg_visible_as_raz(vcpu, r))
+		return 0;
+
+	return kvm_arm_read_id_reg(vcpu, reg_to_encoding(r));
+}
+
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
@@ -2237,6 +2251,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(SP_EL2, NULL, reset_unknown, 0),
 };
 
+static const struct sys_reg_desc *first_idreg;
+
 static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -2244,8 +2260,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 	if (p->is_write) {
 		return ignore_write(vcpu, p);
 	} else {
-		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+		u64 dfr = kvm_arm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
+		u64 pfr = kvm_arm_read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
 		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL1_EL3_SHIFT);
 
 		p->regval = ((((dfr >> ID_AA64DFR0_EL1_WRPs_SHIFT) & 0xf) << 28) |
@@ -3343,8 +3359,32 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
+/*
+ * Set the guest's ID registers with ID_SANITISED() to the host's sanitized value.
+ */
+void kvm_arm_init_id_regs(struct kvm *kvm)
+{
+	const struct sys_reg_desc *idreg = first_idreg;
+	u32 id = reg_to_encoding(idreg);
+
+	/* Initialize all idregs */
+	while (is_id_reg(id)) {
+		/*
+		 * Some hidden ID registers which are not in arm64_ftr_regs[]
+		 * would cause warnings from read_sanitised_ftr_reg().
+		 * Skip those ID registers to avoid the warnings.
+		 */
+		if (idreg->visibility != raz_visibility)
+			IDREG(kvm, id) = read_sanitised_ftr_reg(id);
+
+		idreg++;
+		id = reg_to_encoding(idreg);
+	}
+}
+
 int __init kvm_sys_reg_table_init(void)
 {
+	struct sys_reg_params params;
 	bool valid = true;
 	unsigned int i;
 
@@ -3363,5 +3403,11 @@ int __init kvm_sys_reg_table_init(void)
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
index 6b11f2cc7146..eba10de2e7ae 100644
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
2.41.0.rc0.172.g3f132b7071-goog

