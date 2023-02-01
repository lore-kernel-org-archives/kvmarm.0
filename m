Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EF17E2
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 02:51:45 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id y20-20020a170902cad400b001962668ef33so9328699pld.22
        for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 18:51:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GY5YkAO2JmGWnrtTXf/JtWjEsDzeKZvCbDusCDXXDRg=;
        b=W6o8xRVrjZpa5j0eMnlqak3MRagJ4owbwI69dMtKXg0KwUJSov9GHR+qTx/hqPhP2t
         H2/mD/8fDXWWcAPn8k07XCvnheY7jxyEXpud8jetSWq2aVcIRs2LgEAZXk6o0Ey+nceb
         Tj+ILzGZM2hs6Lub1m1RTPrcSa5seXkK91xQd4U7Z0Ys93SUdd4SiZcId5H+8hZcqLx/
         gSQP7yGhcf/r3OYSmCUDjRHN/p8u5rxRZwcwt81Tdx2wQFi5YEP9h581qyfW8tNpzmyF
         pCNY1yjMyAksha0J6FK7KHeQk/K1+Nj1KyGIhQFv4LaYijfQj7d7B+7qFUSZHHh751Cv
         La5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GY5YkAO2JmGWnrtTXf/JtWjEsDzeKZvCbDusCDXXDRg=;
        b=bUbmDlUQAP3b6uhKgZKASQT5qO3xcZWJoOA5nzPvlGYQBwd+K8QuXDvE6GflmVB4Ou
         Y5kH9TXEN5+IsZ17fnw51C/2QCAuoI3HBFNYu7jJ+RyS0fm4a5DfuETmogZwWzNbO8rR
         K54god15nK1znl1CLMGiGuNYituDkrmV1wtRPBxRZwKsLJKXJJA80ACFBpS5zU4VEYda
         HpJ7OxKeBRqwQgXr8ZZC5jHvcgSD0A3YduOooDCWuAWgarWK/jOfWmF7OixkGnWEp/M5
         nKRx0tZ2OYBDwR1fzOY9vtDjv9fSBFzv/Ibr0QalBwSWT8xoXYD6E63AkEKlA0b3Zf3/
         j3yA==
X-Gm-Message-State: AO0yUKXuuyiX0XNKO5d4wz9Yjre6AvQWv0dpeQWJQnQq9Hr2kUCIdWo1
	3BDJAi3DSU0TGPrw9zJ+jZ7qckHdgv5ZF+dY+A==
X-Google-Smtp-Source: AK7set9O06En0E+/r2WJHCwu/lOZb2376kz/fsx+eRkhVRPRi0I9XAUyksxuyYMMt3fh1HF/Xf2N4W1zhqpAioaSgw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:aa7:9f43:0:b0:592:edcc:7f3c with SMTP
 id h3-20020aa79f43000000b00592edcc7f3cmr175083pfr.37.1675219904757; Tue, 31
 Jan 2023 18:51:44 -0800 (PST)
Date: Wed,  1 Feb 2023 02:50:47 +0000
In-Reply-To: <20230201025048.205820-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230201025048.205820-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230201025048.205820-6-jingzhangos@google.com>
Subject: [PATCH v1 5/6] KVM: arm64: Introduce ID register specific descriptor
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce an ID feature register specific descriptor to include ID
register specific fields and callbacks besides its corresponding
general system register descriptor.
New fields for ID register descriptor would be added later when it
is necessary to support a writable ID register.

No functional change intended.

Co-developed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/id_regs.c  | 187 +++++++++++++++++++++++++++++---------
 arch/arm64/kvm/sys_regs.c |   2 +-
 arch/arm64/kvm/sys_regs.h |   1 +
 3 files changed, 144 insertions(+), 46 deletions(-)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 5eade7d380af..435f38e3ceb3 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -17,6 +17,10 @@
 
 #include "sys_regs.h"
 
+struct id_reg_desc {
+	const struct sys_reg_desc	reg_desc;
+};
+
 static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
 {
 	u8 pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
@@ -312,21 +316,25 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
-#define ID_SANITISED(name) {			\
-	SYS_DESC(SYS_##name),			\
-	.access	= access_id_reg,		\
-	.get_user = get_id_reg,			\
-	.set_user = set_id_reg,			\
-	.visibility = id_visibility,		\
+#define ID_SANITISED(name) {				\
+	.reg_desc = {					\
+		SYS_DESC(SYS_##name),			\
+		.access	= access_id_reg,		\
+		.get_user = get_id_reg,			\
+		.set_user = set_id_reg,			\
+		.visibility = id_visibility,		\
+	},						\
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
-#define AA32_ID_SANITISED(name) {		\
-	SYS_DESC(SYS_##name),			\
-	.access	= access_id_reg,		\
-	.get_user = get_id_reg,			\
-	.set_user = set_id_reg,			\
-	.visibility = aa32_id_visibility,	\
+#define AA32_ID_SANITISED(name) {			\
+	.reg_desc = {					\
+		SYS_DESC(SYS_##name),			\
+		.access	= access_id_reg,		\
+		.get_user = get_id_reg,			\
+		.set_user = set_id_reg,			\
+		.visibility = aa32_id_visibility,	\
+	},						\
 }
 
 /*
@@ -334,12 +342,14 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
  * register with encoding Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
  * (1 <= crm < 8, 0 <= Op2 < 8).
  */
-#define ID_UNALLOCATED(crm, op2) {			\
-	Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),	\
-	.access = access_id_reg,			\
-	.get_user = get_id_reg,				\
-	.set_user = set_id_reg,				\
-	.visibility = raz_visibility			\
+#define ID_UNALLOCATED(crm, op2) {				\
+	.reg_desc = {						\
+		Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),	\
+		.access = access_id_reg,			\
+		.get_user = get_id_reg,				\
+		.set_user = set_id_reg,				\
+		.visibility = raz_visibility			\
+	},							\
 }
 
 /*
@@ -347,15 +357,17 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
  * For now, these are exposed just like unallocated ID regs: they appear
  * RAZ for the guest.
  */
-#define ID_HIDDEN(name) {			\
-	SYS_DESC(SYS_##name),			\
-	.access = access_id_reg,		\
-	.get_user = get_id_reg,			\
-	.set_user = set_id_reg,			\
-	.visibility = raz_visibility,		\
+#define ID_HIDDEN(name) {				\
+	.reg_desc = {					\
+		SYS_DESC(SYS_##name),			\
+		.access = access_id_reg,		\
+		.get_user = get_id_reg,			\
+		.set_user = set_id_reg,			\
+		.visibility = raz_visibility,		\
+	},						\
 }
 
-static const struct sys_reg_desc id_reg_descs[] = {
+static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 	/*
 	 * ID regs: all ID_SANITISED() entries here must have corresponding
 	 * entries in arm64_ftr_regs[].
@@ -365,9 +377,13 @@ static const struct sys_reg_desc id_reg_descs[] = {
 	/* CRm=1 */
 	AA32_ID_SANITISED(ID_PFR0_EL1),
 	AA32_ID_SANITISED(ID_PFR1_EL1),
-	{ SYS_DESC(SYS_ID_DFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_dfr0_el1,
-	  .visibility = aa32_id_visibility, },
+	{ .reg_desc = {
+		SYS_DESC(SYS_ID_DFR0_EL1),
+		.access = access_id_reg,
+		.get_user = get_id_reg,
+		.set_user = set_id_dfr0_el1,
+		.visibility = aa32_id_visibility, },
+	},
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
@@ -396,8 +412,12 @@ static const struct sys_reg_desc id_reg_descs[] = {
 
 	/* AArch64 ID registers */
 	/* CRm=4 */
-	{ SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_aa64pfr0_el1, },
+	{ .reg_desc = {
+		SYS_DESC(SYS_ID_AA64PFR0_EL1),
+		.access = access_id_reg,
+		.get_user = get_id_reg,
+		.set_user = set_id_aa64pfr0_el1, },
+	},
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4, 2),
 	ID_UNALLOCATED(4, 3),
@@ -407,8 +427,12 @@ static const struct sys_reg_desc id_reg_descs[] = {
 	ID_UNALLOCATED(4, 7),
 
 	/* CRm=5 */
-	{ SYS_DESC(SYS_ID_AA64DFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_aa64dfr0_el1, },
+	{ .reg_desc = {
+		SYS_DESC(SYS_ID_AA64DFR0_EL1),
+		.access = access_id_reg,
+		.get_user = get_id_reg,
+		.set_user = set_id_aa64dfr0_el1, },
+	},
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5, 2),
 	ID_UNALLOCATED(5, 3),
@@ -440,7 +464,13 @@ static const struct sys_reg_desc id_reg_descs[] = {
 
 const struct sys_reg_desc *kvm_arm_find_id_reg(const struct sys_reg_params *params)
 {
-	return find_reg(params, id_reg_descs, ARRAY_SIZE(id_reg_descs));
+	u32 id;
+
+	id = reg_to_encoding(params);
+	if (!is_id_reg(id))
+		return NULL;
+
+	return &id_reg_descs[IDREG_IDX(id)].reg_desc;
 }
 
 void kvm_arm_reset_id_regs(struct kvm_vcpu *vcpu)
@@ -448,39 +478,106 @@ void kvm_arm_reset_id_regs(struct kvm_vcpu *vcpu)
 	unsigned long i;
 
 	for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++)
-		if (id_reg_descs[i].reset)
-			id_reg_descs[i].reset(vcpu, &id_reg_descs[i]);
+		if (id_reg_descs[i].reg_desc.reset)
+			id_reg_descs[i].reg_desc.reset(vcpu, &id_reg_descs[i].reg_desc);
 }
 
 int kvm_arm_get_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
-	return kvm_sys_reg_get_user(vcpu, reg,
-				    id_reg_descs, ARRAY_SIZE(id_reg_descs));
+	u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
+	const struct sys_reg_desc *r;
+	struct sys_reg_params params;
+	u64 val;
+	int ret;
+	u32 id;
+
+	if (!index_to_params(reg->id, &params))
+		return -ENOENT;
+	id = reg_to_encoding(&params);
+
+	if (!is_id_reg(id))
+		return -ENOENT;
+
+	r = &id_reg_descs[IDREG_IDX(id)].reg_desc;
+	if (r->get_user) {
+		ret = (r->get_user)(vcpu, r, &val);
+	} else {
+		ret = 0;
+		val = 0;
+	}
+
+	if (!ret)
+		ret = put_user(val, uaddr);
+
+	return ret;
 }
 
 int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
-	return kvm_sys_reg_set_user(vcpu, reg,
-				    id_reg_descs, ARRAY_SIZE(id_reg_descs));
+	u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
+	const struct sys_reg_desc *r;
+	struct sys_reg_params params;
+	u64 val;
+	int ret;
+	u32 id;
+
+	if (!index_to_params(reg->id, &params))
+		return -ENOENT;
+	id = reg_to_encoding(&params);
+
+	if (!is_id_reg(id))
+		return -ENOENT;
+
+	if (get_user(val, uaddr))
+		return -EFAULT;
+
+	r = &id_reg_descs[IDREG_IDX(id)].reg_desc;
+
+	if (sysreg_user_write_ignore(vcpu, r))
+		return 0;
+
+	if (r->set_user)
+		ret = (r->set_user)(vcpu, r, val);
+	else
+		ret = 0;
+
+	return ret;
 }
 
 bool kvm_arm_check_idreg_table(void)
 {
-	return check_sysreg_table(id_reg_descs, ARRAY_SIZE(id_reg_descs), false);
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++) {
+		const struct sys_reg_desc *r = &id_reg_descs[i].reg_desc;
+
+		if (r->reg && !r->reset) {
+			kvm_err("sys_reg table %pS entry %d lacks reset\n", r, i);
+			return false;
+		}
+
+		if (i && cmp_sys_reg(&id_reg_descs[i-1].reg_desc, r) >= 0) {
+			kvm_err("sys_reg table %pS entry %d out of order\n",
+				&id_reg_descs[i - 1].reg_desc, i - 1);
+			return false;
+		}
+	}
+
+	return true;
 }
 
 /* Assumed ordered tables, see kvm_sys_reg_table_init. */
 int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
 {
-	const struct sys_reg_desc *i2, *end2;
+	const struct id_reg_desc *i2, *end2;
 	unsigned int total = 0;
 	int err;
 
 	i2 = id_reg_descs;
 	end2 = id_reg_descs + ARRAY_SIZE(id_reg_descs);
 
-	while (i2 != end2) {
-		err = walk_one_sys_reg(vcpu, i2++, &uind, &total);
+	for (; i2 != end2; i2++) {
+		err = walk_one_sys_reg(vcpu, &(i2->reg_desc), &uind, &total);
 		if (err)
 			return err;
 	}
@@ -498,12 +595,12 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
 	u64 val;
 
 	for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++) {
-		id = reg_to_encoding(&id_reg_descs[i]);
+		id = reg_to_encoding(&id_reg_descs[i].reg_desc);
 		if (WARN_ON_ONCE(!is_id_reg(id)))
 			/* Shouldn't happen */
 			continue;
 
-		if (id_reg_descs[i].visibility == raz_visibility)
+		if (id_reg_descs[i].reg_desc.visibility == raz_visibility)
 			/* Hidden or reserved ID register */
 			continue;
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4dec5b038d77..11d302a75090 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2365,7 +2365,7 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
  * Userspace API
  *****************************************************************************/
 
-static bool index_to_params(u64 id, struct sys_reg_params *params)
+bool index_to_params(u64 id, struct sys_reg_params *params)
 {
 	switch (id & KVM_REG_SIZE_MASK) {
 	case KVM_REG_SIZE_U64:
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 3b59cc940148..3646be75b920 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -216,6 +216,7 @@ static inline bool write_to_read_only(struct kvm_vcpu *vcpu,
 	return false;
 }
 
+bool index_to_params(u64 id, struct sys_reg_params *params);
 const struct sys_reg_desc *get_reg_by_id(u64 id,
 					 const struct sys_reg_desc table[],
 					 unsigned int num);
-- 
2.39.1.456.gfc5497dd1b-goog

