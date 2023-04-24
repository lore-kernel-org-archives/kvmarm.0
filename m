Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E199D7470
	for <kvmarm@lists.linux.dev>; Mon, 24 Apr 2023 23:47:16 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2475be6f3a9so3015679a91.1
        for <kvmarm@lists.linux.dev>; Mon, 24 Apr 2023 16:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682380036; x=1684972036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N1fnAqPS6zL0Ps1vqExjSmtaVpxRkVKSnGLq5UOuzww=;
        b=wwxk35/g4Az1wwaNwvrHcLXr12FfuJhAQIlYQmKpKZGGCiMMf278Khh2hHW2oClQAL
         YTOi2klMUv0fIAjBMrvmHh7WNhX7ulV/hhN3mBVAEwaujR0h6JBL+cwjr7ciZB+ilGRm
         lNPnRYhjxY18sCMb1gDOYOTtStc1w5QvYt5CV1Y/f/X/TtT9fb0EZMSipfCwkshlxA6S
         tUVq1/QyYY96wQEAqPrOdIyprcViCgtE5cBgR2K0f5A0fuxjXokInyiU01dii2Icsgox
         dj/maNOZi3vPpPCqF9ikfijvUukr4D55b824WG6vM2Dvq+ZIa6BPznEG+Ew4fju9JhBT
         ykUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682380036; x=1684972036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N1fnAqPS6zL0Ps1vqExjSmtaVpxRkVKSnGLq5UOuzww=;
        b=B4TgQf9yvOGt1hbGY6U79Pv0qxc68gSGo89CYnWxJp0rd9xpHNL2mcf74QxC4erphQ
         xsysGn/RqqBUxpJHi6f8oH/vbtypocWA8D8zfQnP3w0JAs1LgRAlkFwWAkK1tkFdaZWJ
         u0/g1M04GLLAhd4nymAcJD93cB40engcZcgNpbXOlk/znLB+W92GpmvN9++ybDmyFeFO
         DVjFR2FkRPEaPhtKmY/lkzRHW7HxYqRjBE84p2ht/yAZFjH9t6wBnxDDF03jLDsqq93h
         T2v1yu7Cb/Wdym+7P010l2xrqL8quOATZ77DASMqRa0uhwoUhyhI2CuncH1Uuesc+2Rw
         JokQ==
X-Gm-Message-State: AAQBX9c7gO3izVMJlYm0K8hFcAD8VTmOmK83JJHKyn1omHy69alFT961
	91kVIJlOACQa4qjVAgCuLFQ9j4K+VHSibrUnSA==
X-Google-Smtp-Source: AKy350ZC5NeJ9+1f8LWHjSHP9Z3frQvpHGhVMkQb8KDBxQuRkByt0R6mNAc6Q7EryfQtsuetooixLzLFvZsfsfzPug==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:72c5:b0:247:710c:c14f with
 SMTP id l5-20020a17090a72c500b00247710cc14fmr3649162pjk.5.1682380036476; Mon,
 24 Apr 2023 16:47:16 -0700 (PDT)
Date: Mon, 24 Apr 2023 23:47:03 +0000
In-Reply-To: <20230424234704.2571444-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230424234704.2571444-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424234704.2571444-6-jingzhangos@google.com>
Subject: [PATCH v7 5/6] KVM: arm64: Reuse fields of sys_reg_desc for idreg
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

Since reset() and val are not used for idreg in sys_reg_desc, they would
be used with other purposes for idregs.
The callback reset() would be used to return KVM sanitised id register
values. The u64 val would be used as mask for writable fields in idregs.
Only bits with 1 in val are writable from userspace.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/id_regs.c  | 44 +++++++++++++++++++----------
 arch/arm64/kvm/sys_regs.c | 59 +++++++++++++++++++++++++++------------
 arch/arm64/kvm/sys_regs.h | 10 ++++---
 3 files changed, 77 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 15f79a654be8..a5fabbb04ceb 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -55,6 +55,11 @@ static u8 pmuver_to_perfmon(u8 pmuver)
 	}
 }
 
+static u64 general_read_kvm_sanitised_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
+{
+	return read_sanitised_ftr_reg(reg_to_encoding(rd));
+}
+
 u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 {
 	u64 val = idreg_read(&vcpu->kvm->arch, id);
@@ -333,6 +338,17 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+/*
+ * Since reset() callback and field val are not used for idregs, they will be
+ * used for specific purposes for idregs.
+ * The reset() would return KVM sanitised register value. The value would be the
+ * same as the host kernel sanitised value if there is no KVM sanitisation.
+ * The val would be used as a mask indicating writable fields for the idreg.
+ * Only bits with 1 are writable from userspace. This mask might not be
+ * necessary in the future whenever all ID registers are enabled as writable
+ * from userspace.
+ */
+
 /* sys_reg_desc initialiser for known cpufeature ID registers */
 #define ID_SANITISED(name) {			\
 	SYS_DESC(SYS_##name),			\
@@ -340,6 +356,8 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	.get_user = get_id_reg,			\
 	.set_user = set_id_reg,			\
 	.visibility = id_visibility,		\
+	.reset = general_read_kvm_sanitised_reg,\
+	.val = 0,				\
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
@@ -349,6 +367,8 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	.get_user = get_id_reg,			\
 	.set_user = set_id_reg,			\
 	.visibility = aa32_id_visibility,	\
+	.reset = general_read_kvm_sanitised_reg,\
+	.val = 0,				\
 }
 
 /*
@@ -361,7 +381,9 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	.access = access_id_reg,			\
 	.get_user = get_id_reg,				\
 	.set_user = set_id_reg,				\
-	.visibility = raz_visibility			\
+	.visibility = raz_visibility,			\
+	.reset = NULL,					\
+	.val = 0,					\
 }
 
 /*
@@ -375,6 +397,8 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	.get_user = get_id_reg,			\
 	.set_user = set_id_reg,			\
 	.visibility = raz_visibility,		\
+	.reset = NULL,				\
+	.val = 0,				\
 }
 
 const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
@@ -485,10 +509,7 @@ int emulate_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params)
 	return 1;
 }
 
-/*
- * Set the guest's ID registers that are defined in id_reg_descs[]
- * with ID_SANITISED() to the host's sanitized value.
- */
+/* Initialize the guest's ID registers with KVM sanitised values. */
 void kvm_arm_init_id_regs(struct kvm *kvm)
 {
 	int i;
@@ -501,16 +522,11 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 			/* Shouldn't happen */
 			continue;
 
-		/*
-		 * Some hidden ID registers which are not in arm64_ftr_regs[]
-		 * would cause warnings from read_sanitised_ftr_reg().
-		 * Skip those ID registers to avoid the warnings.
-		 */
-		if (id_reg_descs[i].visibility == raz_visibility)
-			/* Hidden or reserved ID register */
-			continue;
+		val = 0;
+		/* Read KVM sanitised register value if available */
+		if (id_reg_descs[i].reset)
+			val = id_reg_descs[i].reset(NULL, &id_reg_descs[i]);
 
-		val = read_sanitised_ftr_reg(id);
 		idreg_write(&kvm->arch, id, val);
 	}
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6370a0db9d26..032258496f71 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -540,10 +540,11 @@ static int get_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	return 0;
 }
 
-static void reset_bvr(struct kvm_vcpu *vcpu,
+static u64 reset_bvr(struct kvm_vcpu *vcpu,
 		      const struct sys_reg_desc *rd)
 {
 	vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm] = rd->val;
+	return rd->val;
 }
 
 static bool trap_bcr(struct kvm_vcpu *vcpu,
@@ -576,10 +577,11 @@ static int get_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	return 0;
 }
 
-static void reset_bcr(struct kvm_vcpu *vcpu,
+static u64 reset_bcr(struct kvm_vcpu *vcpu,
 		      const struct sys_reg_desc *rd)
 {
 	vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm] = rd->val;
+	return rd->val;
 }
 
 static bool trap_wvr(struct kvm_vcpu *vcpu,
@@ -613,10 +615,11 @@ static int get_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	return 0;
 }
 
-static void reset_wvr(struct kvm_vcpu *vcpu,
+static u64 reset_wvr(struct kvm_vcpu *vcpu,
 		      const struct sys_reg_desc *rd)
 {
 	vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm] = rd->val;
+	return rd->val;
 }
 
 static bool trap_wcr(struct kvm_vcpu *vcpu,
@@ -649,25 +652,28 @@ static int get_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	return 0;
 }
 
-static void reset_wcr(struct kvm_vcpu *vcpu,
+static u64 reset_wcr(struct kvm_vcpu *vcpu,
 		      const struct sys_reg_desc *rd)
 {
 	vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm] = rd->val;
+	return rd->val;
 }
 
-static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 amair = read_sysreg(amair_el1);
 	vcpu_write_sys_reg(vcpu, amair, AMAIR_EL1);
+	return amair;
 }
 
-static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 actlr = read_sysreg(actlr_el1);
 	vcpu_write_sys_reg(vcpu, actlr, ACTLR_EL1);
+	return actlr;
 }
 
-static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 mpidr;
 
@@ -681,7 +687,10 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
 	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
 	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
-	vcpu_write_sys_reg(vcpu, (1ULL << 31) | mpidr, MPIDR_EL1);
+	mpidr |= (1ULL << 31);
+	vcpu_write_sys_reg(vcpu, mpidr, MPIDR_EL1);
+
+	return mpidr;
 }
 
 static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
@@ -693,13 +702,13 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
-static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
 
 	/* No PMU available, any PMU reg may UNDEF... */
 	if (!kvm_arm_support_pmu_v3())
-		return;
+		return 0;
 
 	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
 	n &= ARMV8_PMU_PMCR_N_MASK;
@@ -708,33 +717,41 @@ static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 
 	reset_unknown(vcpu, r);
 	__vcpu_sys_reg(vcpu, r->reg) &= mask;
+
+	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
-static void reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	reset_unknown(vcpu, r);
 	__vcpu_sys_reg(vcpu, r->reg) &= GENMASK(31, 0);
+
+	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
-static void reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	reset_unknown(vcpu, r);
 	__vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_EVTYPE_MASK;
+
+	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
-static void reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	reset_unknown(vcpu, r);
 	__vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_COUNTER_MASK;
+
+	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
-static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 pmcr;
 
 	/* No PMU available, PMCR_EL0 may UNDEF... */
 	if (!kvm_arm_support_pmu_v3())
-		return;
+		return 0;
 
 	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
 	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
@@ -742,6 +759,8 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 		pmcr |= ARMV8_PMU_PMCR_LC;
 
 	__vcpu_sys_reg(vcpu, r->reg) = pmcr;
+
+	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
 static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
@@ -1220,7 +1239,7 @@ static bool access_clidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
  * Fabricate a CLIDR_EL1 value instead of using the real value, which can vary
  * by the physical CPU which the vcpu currently resides in.
  */
-static void reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
 	u64 clidr;
@@ -1268,6 +1287,8 @@ static void reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 		clidr |= 2 << CLIDR_TTYPE_SHIFT(loc);
 
 	__vcpu_sys_reg(vcpu, r->reg) = clidr;
+
+	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
 static int set_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
@@ -2621,19 +2642,21 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
  */
 
 #define FUNCTION_INVARIANT(reg)						\
-	static void get_##reg(struct kvm_vcpu *v,			\
+	static u64 get_##reg(struct kvm_vcpu *v,			\
 			      const struct sys_reg_desc *r)		\
 	{								\
 		((struct sys_reg_desc *)r)->val = read_sysreg(reg);	\
+		return ((struct sys_reg_desc *)r)->val;			\
 	}
 
 FUNCTION_INVARIANT(midr_el1)
 FUNCTION_INVARIANT(revidr_el1)
 FUNCTION_INVARIANT(aidr_el1)
 
-static void get_ctr_el0(struct kvm_vcpu *v, const struct sys_reg_desc *r)
+static u64 get_ctr_el0(struct kvm_vcpu *v, const struct sys_reg_desc *r)
 {
 	((struct sys_reg_desc *)r)->val = read_sanitised_ftr_reg(SYS_CTR_EL0);
+	return ((struct sys_reg_desc *)r)->val;
 }
 
 /* ->val is filled in by kvm_sys_reg_table_init() */
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index e88fd77309b2..21869319f6e1 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -65,12 +65,12 @@ struct sys_reg_desc {
 		       const struct sys_reg_desc *);
 
 	/* Initialization for vcpu. */
-	void (*reset)(struct kvm_vcpu *, const struct sys_reg_desc *);
+	u64 (*reset)(struct kvm_vcpu *, const struct sys_reg_desc *);
 
 	/* Index into sys_reg[], or 0 if we don't need to save it. */
 	int reg;
 
-	/* Value (usually reset value) */
+	/* Value (usually reset value), or write mask for idregs */
 	u64 val;
 
 	/* Custom get/set_user functions, fallback to generic if NULL */
@@ -123,19 +123,21 @@ static inline bool read_zero(struct kvm_vcpu *vcpu,
 }
 
 /* Reset functions */
-static inline void reset_unknown(struct kvm_vcpu *vcpu,
+static inline u64 reset_unknown(struct kvm_vcpu *vcpu,
 				 const struct sys_reg_desc *r)
 {
 	BUG_ON(!r->reg);
 	BUG_ON(r->reg >= NR_SYS_REGS);
 	__vcpu_sys_reg(vcpu, r->reg) = 0x1de7ec7edbadc0deULL;
+	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
-static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static inline u64 reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	BUG_ON(!r->reg);
 	BUG_ON(r->reg >= NR_SYS_REGS);
 	__vcpu_sys_reg(vcpu, r->reg) = r->val;
+	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
 static inline unsigned int sysreg_visibility(const struct kvm_vcpu *vcpu,
-- 
2.40.0.634.g4ca3ef3211-goog

