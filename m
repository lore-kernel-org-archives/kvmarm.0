Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A49145B2D
	for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 10:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714128607; cv=none; b=XeF1RZEDSGHQ1i3TwFQ2LZ/ZRUv3GgnV4xxZ3EsyJQiKt8e6HbSxvQBB2tI5S4O+8GwurYP26IW7U3jm6hpoN56XyoBr0LQIAX0PeL+wuPXhpxQhddcn8IVRiRxEHIvfI9l9V6jc4fk/TqxFJdnTp8DGe8p5QXefhAQUz/QwcB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714128607; c=relaxed/simple;
	bh=p3iy9R1aqq0jp5u8JochXtiyq7C5gXk3Vtm5bawKjkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZJCTr1s8NvTgAujyx7Bu1pIvkOYxJ5ZaP8MXu2rO/yY8JGfczRaZMWfR/Sws4mkt9Ewo7Yrl7KIthZAyYQ2rCJNPvXnaxDWlwC6kpMpDaQjbQf0/p4VCZ72c7+4swMEogprJlMXfBx0MxJ/S71rehpILOC/Vi2Hp87jEwkzIMjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gh6LGHyL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gh6LGHyL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714128605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h2VZGXYGnHdShn33lWIpuOwQARptQfZv/c0XotdUQLs=;
	b=Gh6LGHyLqQlXzFbz7HdutBNW2Jeuqq0XrqM16NFhePiFdOL9PVMpTTm+rTx0vrjk8mKR0j
	xsku8EYMte+XHLknZ+afHvHRjsAzsNQKj5eznxJzqDwoO+ubwsYWvFZt+Fei1SuBfnYjrF
	lQuNc2b/Lba0dNvL/vXtuSO14H4+VSE=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-9e5xcvxTMQSQDt-suV2WDA-1; Fri, 26 Apr 2024 06:50:04 -0400
X-MC-Unique: 9e5xcvxTMQSQDt-suV2WDA-1
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6ebc3864709so2540888a34.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 03:50:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714128603; x=1714733403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h2VZGXYGnHdShn33lWIpuOwQARptQfZv/c0XotdUQLs=;
        b=eNmprS198Zg6fjM9wet/7vnsv0oD0TjLAgGSyiXal1xQbVIqMlKBXmSS1M/ww+z4Os
         ArQRFDBb2xxRE0lTxBdgXiXC8rT4IIRQ6Ju6qjNkdul4EfDiklg3BxJvIzxcvJ4+zLoW
         18737AiIcz8vTMbwysvPj19LCiLtomdBh5DQblBiy4ProfLerUjC+dECHpGd92pWObDZ
         u5iTNIEOyuj/ojL3Esxktb5cOWdkw6sl/lH7ZfrZXAsq88SUqjPaRsnUshIUg8J5lajI
         YhkVIDzu52PrThdzelSW1OjNKeUAoFXoi4Q+IVbYQTAsx7EAK0I2lrNIeDWMX9nJjiT7
         8kjw==
X-Forwarded-Encrypted: i=1; AJvYcCV6vOlJLpwvUgiq4VxWu74umklYjLtqmIrur12SCmFcAmRnWgteclzrchTzLcPEj8CSIOlEhxGdmkiCTmhB7KfdQ09BsDZg
X-Gm-Message-State: AOJu0YzP6OROIWN8sensL2+zkLp16YGQ8OmycvuH92OtjuMTEC+XtEpR
	e+Ux6LUrEKPt0Ws/Nbdu9diMgpMHwGEsMz82omG3ylFUI+6vYkAqxzrtUh0s6bsoRni3XhTWJNy
	DIq7Do6fCsLD8soUW7KNpBbSFnMUbnyFpRpygFW9MBKAemm2NmSwwAA==
X-Received: by 2002:a05:6830:119:b0:6ed:4986:40dd with SMTP id i25-20020a056830011900b006ed498640ddmr2169635otp.35.1714128602976;
        Fri, 26 Apr 2024 03:50:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKjMUkBt0VYe1cXxGJ/eOvuZGdV4nSBkiEKax45TG8leNaeVXjcYMCGMXRVKSvLaHiuVgVbg==
X-Received: by 2002:a05:6830:119:b0:6ed:4986:40dd with SMTP id i25-20020a056830011900b006ed498640ddmr2169614otp.35.1714128602509;
        Fri, 26 Apr 2024 03:50:02 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id vv26-20020a05620a563a00b007907b57aa1fsm3888019qkn.12.2024.04.26.03.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 03:50:02 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2 4/6] KVM: arm64: add emulation for CTR_EL0 register
Date: Fri, 26 Apr 2024 12:49:48 +0200
Message-ID: <20240426104950.7382-5-sebott@redhat.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240426104950.7382-1-sebott@redhat.com>
References: <20240426104950.7382-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

CTR_EL0 is currently handled as an invariant register, thus
guests will be presented with the host value of that register.

Add emulation for CTR_EL0 based on a per VM value. Userspace can
switch off DIC and IDC bits and reduce DminLine and IminLine sizes.

When CTR_EL0 is changed validate that against CLIDR_EL1 and CCSIDR_EL1
to make sure we present the guest with consistent register values.
Changes that affect the generated cache topology values are allowed if
they don't clash with previous register writes.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 arch/arm64/kvm/sys_regs.c | 123 +++++++++++++++++++++++++++++++++-----
 1 file changed, 107 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1488b93050d4..2fe3492ba3c4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -215,13 +215,8 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 /* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
 #define CSSELR_MAX 14
 
-/*
- * Returns the minimum line size for the selected cache, expressed as
- * Log2(bytes).
- */
-static u8 get_min_cache_line_size(struct kvm *kvm, bool icache)
+static u8 __get_min_cache_line_size(u64 ctr, bool icache)
 {
-	u64 ctr = kvm->arch.ctr_el0;
 	u8 field;
 
 	if (icache)
@@ -240,6 +235,15 @@ static u8 get_min_cache_line_size(struct kvm *kvm, bool icache)
 	return field + 2;
 }
 
+/*
+ * Returns the minimum line size for the selected cache, expressed as
+ * Log2(bytes).
+ */
+static u8 get_min_cache_line_size(struct kvm *kvm, bool icache)
+{
+	return __get_min_cache_line_size(kvm->arch.ctr_el0, icache);
+}
+
 /* Which cache CCSIDR represents depends on CSSELR value. */
 static u32 get_ccsidr(struct kvm_vcpu *vcpu, u32 csselr)
 {
@@ -1856,6 +1860,45 @@ static int set_wi_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	return 0;
 }
 
+static const struct sys_reg_desc *get_sys_reg_desc(u32 encoding);
+
+static int validate_clidr_el1(u64 clidr_el1, u64 ctr_el0)
+{
+	u64 idc = !CLIDR_LOC(clidr_el1) ||
+		  (!CLIDR_LOUIS(clidr_el1) && !CLIDR_LOUU(clidr_el1));
+
+	if ((clidr_el1 & CLIDR_EL1_RES0) || (!(ctr_el0 & CTR_EL0_IDC) && idc))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int validate_cache_top(struct kvm_vcpu *vcpu, u64 ctr_el0)
+{
+	const struct sys_reg_desc *clidr_el1;
+	unsigned int i;
+	int ret;
+
+	clidr_el1 = get_sys_reg_desc(SYS_CLIDR_EL1);
+	if (!clidr_el1)
+		return -ENOENT;
+
+	ret = validate_clidr_el1(__vcpu_sys_reg(vcpu, clidr_el1->reg), ctr_el0);
+	if (ret)
+		return ret;
+
+	if (!vcpu->arch.ccsidr)
+		return 0;
+
+	for (i = 0; i < CSSELR_MAX; i++) {
+		if ((FIELD_GET(CCSIDR_EL1_LineSize, get_ccsidr(vcpu, i)) + 4)
+		    < __get_min_cache_line_size(ctr_el0, i & CSSELR_EL1_InD))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 static bool access_ctr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		       const struct sys_reg_desc *r)
 {
@@ -1866,6 +1909,48 @@ static bool access_ctr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static u64 reset_ctr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
+{
+	vcpu->kvm->arch.ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
+	return vcpu->kvm->arch.ctr_el0;
+}
+
+static int get_ctr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+		   u64 *val)
+{
+	*val = vcpu->kvm->arch.ctr_el0;
+	return 0;
+}
+
+static int set_ctr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+		   u64 val)
+{
+	int ret;
+
+	if (val == vcpu->kvm->arch.ctr_el0)
+		return 0;
+
+	if (kvm_vm_has_ran_once(vcpu->kvm))
+		return -EBUSY;
+
+	mutex_lock(&vcpu->kvm->arch.config_lock);
+	ret = arm64_check_features(vcpu, rd, val);
+	if (ret) {
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+		return ret;
+	}
+	ret = validate_cache_top(vcpu, val);
+	if (ret) {
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+		return ret;
+	}
+
+	vcpu->kvm->arch.ctr_el0 = val;
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
+
+	return 0;
+}
+
 static bool access_clidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
@@ -1935,10 +2020,9 @@ static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 static int set_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 val)
 {
-	u64 idc = !CLIDR_LOC(val) || (!CLIDR_LOUIS(val) && !CLIDR_LOUU(val));
 	u64 ctr_el0 = vcpu->kvm->arch.ctr_el0;
 
-	if ((val & CLIDR_EL1_RES0) || (!(ctr_el0 & CTR_EL0_IDC) && idc))
+	if (validate_clidr_el1(val, ctr_el0))
 		return -EINVAL;
 
 	__vcpu_sys_reg(vcpu, rd->reg) = val;
@@ -2452,7 +2536,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
 	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
-	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
+	{ SYS_DESC(SYS_CTR_EL0), access_ctr, .reset = reset_ctr,
+	  .get_user = get_ctr, .set_user = set_ctr, .val = (CTR_EL0_DIC_MASK |
+							    CTR_EL0_IDC_MASK |
+							    CTR_EL0_DminLine_MASK |
+							    CTR_EL0_IminLine_MASK)},
 	{ SYS_DESC(SYS_SVCR), undef_access },
 
 	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
@@ -3616,6 +3704,13 @@ static bool index_to_params(u64 id, struct sys_reg_params *params)
 	}
 }
 
+static const struct sys_reg_desc *get_sys_reg_desc(u32 encoding)
+{
+	struct sys_reg_params params = encoding_to_params(encoding);
+
+	return find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+}
+
 const struct sys_reg_desc *get_reg_by_id(u64 id,
 					 const struct sys_reg_desc table[],
 					 unsigned int num)
@@ -3669,18 +3764,11 @@ FUNCTION_INVARIANT(midr_el1)
 FUNCTION_INVARIANT(revidr_el1)
 FUNCTION_INVARIANT(aidr_el1)
 
-static u64 get_ctr_el0(struct kvm_vcpu *v, const struct sys_reg_desc *r)
-{
-	((struct sys_reg_desc *)r)->val = read_sanitised_ftr_reg(SYS_CTR_EL0);
-	return ((struct sys_reg_desc *)r)->val;
-}
-
 /* ->val is filled in by kvm_sys_reg_table_init() */
 static struct sys_reg_desc invariant_sys_regs[] __ro_after_init = {
 	{ SYS_DESC(SYS_MIDR_EL1), NULL, get_midr_el1 },
 	{ SYS_DESC(SYS_REVIDR_EL1), NULL, get_revidr_el1 },
 	{ SYS_DESC(SYS_AIDR_EL1), NULL, get_aidr_el1 },
-	{ SYS_DESC(SYS_CTR_EL0), NULL, get_ctr_el0 },
 };
 
 static int get_invariant_sys_reg(u64 id, u64 __user *uaddr)
@@ -4066,6 +4154,9 @@ static void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 	 */
 	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
 		vcpu->arch.hcr_el2 |= HCR_TTLBOS;
+
+	if (kvm->arch.ctr_el0 != read_sanitised_ftr_reg(SYS_CTR_EL0))
+		vcpu->arch.hcr_el2 |= HCR_TID2;
 }
 
 void kvm_setup_traps(struct kvm_vcpu *vcpu)
-- 
2.42.0

