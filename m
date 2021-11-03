Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1872CC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:27:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A96A361166
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:27:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A96A361166
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 486474A19F;
	Wed,  3 Nov 2021 02:27:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jBvYK9O4b-zg; Wed,  3 Nov 2021 02:27:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3A514B106;
	Wed,  3 Nov 2021 02:27:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 740454A19F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:27:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8r0+DtWfNgP0 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:27:32 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ADE0F49E57
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:27:32 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 b5-20020a25a205000000b005c2150fc181so2737788ybi.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=5NZ1PewkVBHXKHBWduRPYy68+IVzIFx45xL3upKYtFs=;
 b=jnCXRXMvE9ZB+MnQQVF9LzDUssipfiWrPymUniSl6L6OVOjHzZerCGTDf7uw0hSfrY
 WQgBXkPNeqkCU4/SlHpsIhdslXsUZ0lkqKP4SuNXitWbEnli/2AuJG0db5GqX+TL2Nnb
 NLuwVJi9lhBcfI/GosjLFEv3e5qNPsOV9f0J9krOP2aTC/Hc6jKzDHJS7MzMFhOVpqA2
 AmtCsvswBDJQmbcJZUDCevPkTBATPE1WxJoBnl2Itd6iQIeP4bcnuBbAGnNvXEbWGq6S
 a5WOLMZN7mP2jBGdAFTG7XyRK/J1SA48r605zUX4enhTRO9mdlDLR+oQGjKPQ5sZZ6s2
 Yrzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=5NZ1PewkVBHXKHBWduRPYy68+IVzIFx45xL3upKYtFs=;
 b=Z71E0zd07/yxiaZaif4BNPLuNspK72ge3Oj6KlGyA0HxgF7e85EnKcTHrVenPjIicY
 M6t99Quxqy/5q67St8za/30vyElKjCcideRNHJraIpKGHSdpr3GChjmena36CwgJQv2F
 KJ0moV+qQ/1zxxEgAsYcTxZq26vN0470dkEsHqR+UX0g4J2prH0rfagZP9/R+eTcxf9K
 VGQaBnMrIM2qE6B3MeZIOYpcfiqx/fTiyrCoXuO1noitX8mk5K1MIbOawCsjKPXkmgOt
 mhJlzh6vXuo36bItcoADgtfwwVLA/OzppQKPCruUOWAaQTxeqsppjyRImQ1UMFMOnVSe
 EStA==
X-Gm-Message-State: AOAM532dzWa0V1SUECn2mr5pa2G5/jfw6aPPeV7yrmCIr8vww2MH/E12
 7i9DdYss+7P6lPr4+sDxTnrhPoHDVK0=
X-Google-Smtp-Source: ABdhPJyypqhuw0+qVyo6SYiqQmRnwaA+Xr/FX+o5ay5pTVVxe8nLUkcWASh53mAdIZt9sBeSXhyfbn0z3qg=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a25:74c8:: with SMTP id
 p191mr35571120ybc.157.1635920852001; 
 Tue, 02 Nov 2021 23:27:32 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:24:55 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-4-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 03/28] KVM: arm64: Introduce struct id_reg_info
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

This patch lays the groundwork to make ID registers writable.

Introduce struct id_reg_info for an ID register to manage the
register specific control of its value for the guest, and provide set
of functions commonly used for ID registers to make them writable.

The id_reg_info is used to do register specific initialization,
validation of the ID register and etc.  Not all ID registers must
have the id_reg_info. ID registers that don't have the id_reg_info
are handled in a common way that is applied to all ID registers.

At present, changing an ID register from userspace is allowed only
if the ID register has the id_reg_info, but that will be changed
by the following patches.

No ID register has the structure yet and the following patches
will add the id_reg_info for some ID registers.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/sysreg.h |   1 +
 arch/arm64/kvm/sys_regs.c       | 222 ++++++++++++++++++++++++++++++--
 2 files changed, 214 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b268082d67ed..5c4890cdc29b 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1186,6 +1186,7 @@
 #define ICH_VTR_A3V_MASK	(1 << ICH_VTR_A3V_SHIFT)
 
 #define ARM64_FEATURE_FIELD_BITS	4
+#define ARM64_FEATURE_FIELD_MASK	((1ull << ARM64_FEATURE_FIELD_BITS) - 1)
 
 /* Create a mask for the feature bits of the specified feature. */
 #define ARM64_FEATURE_MASK(x)	(GENMASK_ULL(x##_SHIFT + ARM64_FEATURE_FIELD_BITS - 1, x##_SHIFT))
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2443440720b4..64d51aa3aee3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -263,6 +263,181 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 		return read_zero(vcpu, p);
 }
 
+/*
+ * A value for FCT_LOWER_SAFE must be zero and changing that will affect
+ * ftr_check_types of id_reg_info.
+ */
+enum feature_check_type {
+	FCT_LOWER_SAFE = 0,
+	FCT_HIGHER_SAFE,
+	FCT_HIGHER_OR_ZERO_SAFE,
+	FCT_EXACT,
+	FCT_EXACT_OR_ZERO_SAFE,
+	FCT_IGNORE,	/* Don't check (any value is fine) */
+};
+
+static int arm64_check_feature_one(enum feature_check_type type, int val,
+				   int limit)
+{
+	bool is_safe = false;
+
+	if (val == limit)
+		return 0;
+
+	switch (type) {
+	case FCT_LOWER_SAFE:
+		is_safe = (val <= limit);
+		break;
+	case FCT_HIGHER_OR_ZERO_SAFE:
+		if (val == 0) {
+			is_safe = true;
+			break;
+		}
+		fallthrough;
+	case FCT_HIGHER_SAFE:
+		is_safe = (val >= limit);
+		break;
+	case FCT_EXACT:
+		break;
+	case FCT_EXACT_OR_ZERO_SAFE:
+		is_safe = (val == 0);
+		break;
+	case FCT_IGNORE:
+		is_safe = true;
+		break;
+	default:
+		WARN_ONCE(1, "Unexpected feature_check_type (%d)\n", type);
+		break;
+	}
+
+	return is_safe ? 0 : -1;
+}
+
+#define	FCT_TYPE_MASK		0x7
+#define	FCT_TYPE_SHIFT		1
+#define	FCT_SIGN_MASK		0x1
+#define	FCT_SIGN_SHIFT		0
+#define	FCT_TYPE(val)	((val >> FCT_TYPE_SHIFT) & FCT_TYPE_MASK)
+#define	FCT_SIGN(val)	((val >> FCT_SIGN_SHIFT) & FCT_SIGN_MASK)
+
+#define	MAKE_FCT(shift, type, sign)				\
+	((u64)((((type) & FCT_TYPE_MASK) << FCT_TYPE_SHIFT) |	\
+	       (((sign) & FCT_SIGN_MASK) << FCT_SIGN_SHIFT)) << (shift))
+
+/* For signed field */
+#define	S_FCT(shift, type)	MAKE_FCT(shift, type, 1)
+/* For unigned field */
+#define	U_FCT(shift, type)	MAKE_FCT(shift, type, 0)
+
+/*
+ * @val and @lim are both a value of the ID register. The function checks
+ * if all features indicated in @val can be supported for guests on the host,
+ * which supports features indicated in @lim. @check_types indicates how
+ * features in the ID register needs to be checked.
+ * See comments for id_reg_info's ftr_check_types field for more detail.
+ */
+static int arm64_check_features(u64 check_types, u64 val, u64 lim)
+{
+	int i;
+
+	for (i = 0; i < 64; i += ARM64_FEATURE_FIELD_BITS) {
+		u8 ftr_check = (check_types >> i) & ARM64_FEATURE_FIELD_MASK;
+		bool is_sign = FCT_SIGN(ftr_check);
+		enum feature_check_type fctype = FCT_TYPE(ftr_check);
+		int fval, flim, ret;
+
+		fval = cpuid_feature_extract_field_width(val, i, 4, is_sign);
+		flim = cpuid_feature_extract_field_width(lim, i, 4, is_sign);
+
+		ret = arm64_check_feature_one(fctype, fval, flim);
+		if (ret)
+			return -E2BIG;
+	}
+	return 0;
+}
+
+struct id_reg_info {
+	u32	sys_reg;	/* Register ID */
+
+	/*
+	 * Limit value of the register for a vcpu. The value is the sanitized
+	 * system value with bits cleared for unsupported features for the
+	 * guest.
+	 */
+	u64	vcpu_limit_val;
+
+	/*
+	 * The ftr_check_types is comprised of a set of 4 bits fields.
+	 * Each 4 bits field is for a feature indicated by the same bits
+	 * field of the ID register and indicates how the feature support
+	 * for guests needs to be checked.
+	 * The bit 0 indicates that the corresponding ID register field
+	 * is signed(1) or unsigned(0).
+	 * The bits [3:1] hold feature_check_type for the field.
+	 * If all zero, all features in the ID register are treated as unsigned
+	 * fields and checked based on Principles of the ID scheme for fields
+	 * in ID registers (FCT_LOWER_SAFE of feature_check_type).
+	 */
+	u64	ftr_check_types;
+
+	/* Initialization function of the id_reg_info */
+	void (*init)(struct id_reg_info *id_reg);
+
+	/* Register specific validation function */
+	int (*validate)(struct kvm_vcpu *vcpu, const struct id_reg_info *id_reg,
+			u64 val);
+
+	/* Return the reset value of the register for the vCPU */
+	u64 (*get_reset_val)(struct kvm_vcpu *vcpu,
+			     const struct id_reg_info *id_reg);
+};
+
+static void id_reg_info_init(struct id_reg_info *id_reg)
+{
+	id_reg->vcpu_limit_val = read_sanitised_ftr_reg(id_reg->sys_reg);
+	if (id_reg->init)
+		id_reg->init(id_reg);
+}
+
+/*
+ * An ID register that needs special handling to control the value for the
+ * guest must have its own id_reg_info in id_reg_info_table.
+ * (i.e. the reset value is different from the host's sanitized value,
+ * the value is affected by opt-in features, some fields needs specific
+ * validation, etc.)
+ */
+#define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
+static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {};
+
+static int validate_id_reg(struct kvm_vcpu *vcpu,
+			   const struct sys_reg_desc *rd, u64 val)
+{
+	u32 id = reg_to_encoding(rd);
+	const struct id_reg_info *id_reg = GET_ID_REG_INFO(id);
+	u64 limit, check_types;
+	int err;
+
+	if (id_reg) {
+		check_types = id_reg->ftr_check_types;
+		limit = id_reg->vcpu_limit_val;
+	} else {
+		/* All fields are treated as unsigned and FCT_LOWER_SAFE */
+		check_types = 0;
+		limit = read_sanitised_ftr_reg(id);
+	}
+
+	/* Check if the value indicates any feature that is not in the limit. */
+	err = arm64_check_features(check_types, val, limit);
+	if (err)
+		return err;
+
+	if (id_reg && id_reg->validate)
+		/* Run the ID register specific validity check. */
+		err = id_reg->validate(vcpu, id_reg, val);
+
+	return err;
+}
+
 /*
  * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
  * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
@@ -1176,11 +1351,19 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
 {
 	u32 id = reg_to_encoding(rd);
+	struct id_reg_info *id_reg;
+	u64 val;
 
 	if (vcpu_has_reset_once(vcpu))
 		return;
 
-	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = read_sanitised_ftr_reg(id);
+	id_reg = GET_ID_REG_INFO(id);
+	if (id_reg && id_reg->get_reset_val)
+		val = id_reg->get_reset_val(vcpu, id_reg);
+	else
+		val = read_sanitised_ftr_reg(id);
+
+	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = val;
 }
 
 static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
@@ -1225,11 +1408,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-/*
- * cpufeature ID register user accessors
- *
- * We don't allow the effective value to be changed.
- */
+/* cpufeature ID register user accessors */
 static int __get_id_reg(const struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
 			bool raz)
@@ -1240,11 +1419,12 @@ static int __get_id_reg(const struct kvm_vcpu *vcpu,
 	return reg_to_user(uaddr, &val, id);
 }
 
-static int __set_id_reg(const struct kvm_vcpu *vcpu,
+static int __set_id_reg(struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
 			bool raz)
 {
 	const u64 id = sys_reg_to_index(rd);
+	u32 encoding = reg_to_encoding(rd);
 	int err;
 	u64 val;
 
@@ -1252,10 +1432,18 @@ static int __set_id_reg(const struct kvm_vcpu *vcpu,
 	if (err)
 		return err;
 
-	/* This is what we mean by invariant: you can't change it. */
-	if (val != read_id_reg(vcpu, rd, raz))
+	/* Don't allow to change the reg unless the reg has id_reg_info */
+	if (val != read_id_reg(vcpu, rd, raz) && !GET_ID_REG_INFO(encoding))
 		return -EINVAL;
 
+	if (raz)
+		return 0;
+
+	err = validate_id_reg(vcpu, rd, val);
+	if (err)
+		return err;
+
+	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(encoding)) = val;
 	return 0;
 }
 
@@ -2816,6 +3004,20 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
+static void id_reg_info_init_all(void)
+{
+	int i;
+	struct id_reg_info *id_reg;
+
+	for (i = 0; i < ARRAY_SIZE(id_reg_info_table); i++) {
+		id_reg = (struct id_reg_info *)id_reg_info_table[i];
+		if (!id_reg)
+			continue;
+
+		id_reg_info_init(id_reg);
+	}
+}
+
 void kvm_sys_reg_table_init(void)
 {
 	unsigned int i;
@@ -2850,4 +3052,6 @@ void kvm_sys_reg_table_init(void)
 			break;
 	/* Clear all higher bits. */
 	cache_levels &= (1 << (i*3))-1;
+
+	id_reg_info_init_all();
 }
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
