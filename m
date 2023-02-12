Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CA46FBD
	for <kvmarm@lists.linux.dev>; Sun, 12 Feb 2023 21:58:55 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id v24-20020a17090ac91800b00233e56ef3a0so529667pjt.7
        for <kvmarm@lists.linux.dev>; Sun, 12 Feb 2023 13:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1toswgo6a3bpqih+UDTGb2lmCzJhE6iGcvkmx02E8Rs=;
        b=bY4nioZfaP9PFLWSEpihApV8WhgfwkKYSrGDVPJc4dJ7wHs2j7y62Dp1i1/l603VkO
         cU7BlfLocGEmWQrhsne4qNg3B+mewp6OvRzxJmWmt+P8w1fcgb7z56himEsFQVMAub7t
         /OwnGUzmwejl70YodBfywojAORf7dDkPRudfpxF4QG144xe18N6YGqAOW99AWtptT2cL
         5fg2uT3NjnT+CJr5JhwZQY08nEQ63pz167JetHndhS32lbmIff2AybuIS+2nQz+bZ+27
         S2HyC0mE/Ty9W2q9YoU33gKhwmglmgDj356kbxKgqnRpvSDjwOULrGYzTIGF1LldNU65
         DgSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1toswgo6a3bpqih+UDTGb2lmCzJhE6iGcvkmx02E8Rs=;
        b=m1U2m8i7eKTuNbTQxVpggOXawMUwocRgAAxi2lWktdvazAvRGF8JTuIsPZ849CvaLq
         3m6TfWzTmXxRo9wNddA2Z7kHPXO0WgyyTyyKl3cJjSiCzElO/gTAB9hY0hoUzBQnhMR6
         s323mWbekdZjx2TMvZa+8IedD9Pcdz4ItQ9y0tjbusxNypE27Y/T9PPCqrdYcXxVJDnU
         pD11ySR2XIkCeEiS9gTc9PSLykJzG9LYHnx81Ziz5B3bxuGErA1A5NEsAYom8CMgc5Ds
         eXM1mkhtFX7wz9aofDUuNDWsPwvoZJnhV4CYyxIBizL+GviQpDqh8MB9yt52mff0kP9B
         7DRA==
X-Gm-Message-State: AO0yUKWPnPvreZ7Zjw5fl0y1rtK4kSFRFvNB6MDsy8dG7FV0KO8XrS77
	Ut4Ex80pAo40R8DzZ8o5/IN3gBppsLs7Osswng==
X-Google-Smtp-Source: AK7set/+P3VHiqk3cV+dQ2Yi5aGsEPU7Yy899XCU/wxk8/VvPQhK2puz7kcLpbNpmJb1BlZT8u0VBjmHiWV1NDc3Lg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:c205:b0:199:1dad:9cc with SMTP
 id 5-20020a170902c20500b001991dad09ccmr5437201pll.3.1676239134838; Sun, 12
 Feb 2023 13:58:54 -0800 (PST)
Date: Sun, 12 Feb 2023 21:58:29 +0000
In-Reply-To: <20230212215830.2975485-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230212215830.2975485-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230212215830.2975485-6-jingzhangos@google.com>
Subject: [PATCH v2 5/6] KVM: arm64: Introduce ID register specific descriptor
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
index 14ae03a1d8d0..15d0338742b6 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -18,6 +18,10 @@
 
 #include "sys_regs.h"
 
+struct id_reg_desc {
+	const struct sys_reg_desc	reg_desc;
+};
+
 static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_has_pmu(vcpu))
@@ -329,21 +333,25 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -351,12 +359,14 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -364,15 +374,17 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -382,9 +394,13 @@ static const struct sys_reg_desc id_reg_descs[] = {
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
@@ -413,8 +429,12 @@ static const struct sys_reg_desc id_reg_descs[] = {
 
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
@@ -424,8 +444,12 @@ static const struct sys_reg_desc id_reg_descs[] = {
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
@@ -457,7 +481,13 @@ static const struct sys_reg_desc id_reg_descs[] = {
 
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
@@ -465,39 +495,106 @@ void kvm_arm_reset_id_regs(struct kvm_vcpu *vcpu)
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
@@ -515,12 +612,12 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
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
index a4350f0737c3..cdcd61ac9868 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2518,7 +2518,7 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
  * Userspace API
  *****************************************************************************/
 
-static bool index_to_params(u64 id, struct sys_reg_params *params)
+bool index_to_params(u64 id, struct sys_reg_params *params)
 {
 	switch (id & KVM_REG_SIZE_MASK) {
 	case KVM_REG_SIZE_U64:
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 5cfab83ce8b8..3797d1b494a2 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -226,6 +226,7 @@ static inline bool write_to_read_only(struct kvm_vcpu *vcpu,
 	return false;
 }
 
+bool index_to_params(u64 id, struct sys_reg_params *params);
 const struct sys_reg_desc *get_reg_by_id(u64 id,
 					 const struct sys_reg_desc table[],
 					 unsigned int num);
-- 
2.39.1.581.gbfd45094c4-goog

