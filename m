Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9616312EBD3
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 13:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419932; cv=none; b=tXfa1K7Mvs6zVvpmTq/FZ4AuyIvJeh8imCSKgTBw1eM/yqT3wMsx39+Dhf1uFL6itYuB1YQFi2BUornnyXjae8W5/y1E0J9gtq7Y15xR5LhYRWxbfIFanxl09WG7jkPr6eYMJmpLockvYWiSUy0jI1SNUj+PiSipGvU+DqbjMEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419932; c=relaxed/simple;
	bh=scenQSkndiyIV9zl6y7bUbzztF2nN+Emdo2MstNoFVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=llcnvHUhX2/4uXpE+jJknCf6YgF6FigmIVU1vFlOSD33eXlxmJ5euBCKyEVm9t1L1aDV+cRXYH+08ekFnZeK4I215QWczPWk0yhnDHs4wiCZ4BrBgkFR7tMzCXIf7eXktjg9xDHC691n2BS+LsMHsfnPMteM5fCxDUYBu1Bi6hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q4lF9uNh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q4lF9uNh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717419929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rjhG9UCSzuq2kMSae0kdEk0yI/UiNsWW4hVHnZD/ix0=;
	b=Q4lF9uNhepVsSz/dNlr76iip1lMRK3jveFVc41r/SLwLa2jj4LsuFwpVbZBmgfP4F4AsYP
	aE37vV8toTzBrBMl/PqhyS+2M75ZX8uNKL2jjD1plFXQOxXuc2lcTvbIo34/RVTI889pL1
	Lawlqj30dG8iHh7PXTNK9HvyQwQx+EM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-119-IwgkFH82OMiTesaOZj2ruQ-1; Mon, 03 Jun 2024 09:05:24 -0400
X-MC-Unique: IwgkFH82OMiTesaOZj2ruQ-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6ae3dd961afso39221846d6.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 06:05:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717419923; x=1718024723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rjhG9UCSzuq2kMSae0kdEk0yI/UiNsWW4hVHnZD/ix0=;
        b=R/5hZYRmYfDm71xgkPmmAXV/kHTP1IU9bXqxrXVlxo9JdH6e4jGurXf0g2pjnmVzjJ
         7/O+PGwhBjSPtGxtiRPQJqwD8ZVT/Acb5aNrERhbibiMetZkJ2UWCkZte+k8rk6MRhJK
         4r5sOnlgfnMDP71tHTfmG+lhtWYXn6TWE3ldvtSWO5iRmvLOqvXB1z9FSNp8uoF5zg3U
         QAPtF/uEeioOXJ/YlsAYUj9nkfwpW6QW0AWXsjG82FSKKX+x2dzeKczliD2Dw6PQNyV4
         YU/NtggNC1NvP804qnkLO6sIwbvrFY+2vScsgUTWWtHXuApncw1xFfSQY8VGKS7sDQeu
         +gcA==
X-Forwarded-Encrypted: i=1; AJvYcCVKZf4Q45oXz68TpSoBBXeXlXPNr/prSyPsoNo9HULxOU1Wml03D83Q0G7XZgIpAu1/GsseNn00xO825cv8N2itwc9+ZOfz
X-Gm-Message-State: AOJu0YwJzbqc2NcCrjLO8kQivNZ2KwW/Y6bhX4PP4fVoaFylBv4m+jG3
	n7hm521olr+BSzm1LUMkzJEbCprJ+uRaSMKMOVOYvT2EaXPqgqRZHIyan3NO2uzuLyWfDbbwrX4
	3Cohy3dWaBHzNRe+DEHlHv75jw3yqxGu9sGPnn7C5ht1ApIkwmL9w3Q==
X-Received: by 2002:a05:6214:5346:b0:6ae:cfb:480e with SMTP id 6a1803df08f44-6aecd6f119dmr105171946d6.45.1717419922885;
        Mon, 03 Jun 2024 06:05:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHolH+G4GuQYs6HI9NnW169OQHkdJXRwQLY9tFA4pzpc7gJV2/q1S6ZdyVVkQl42kGzFUkX3w==
X-Received: by 2002:a05:6214:5346:b0:6ae:cfb:480e with SMTP id 6a1803df08f44-6aecd6f119dmr105171106d6.45.1717419922127;
        Mon, 03 Jun 2024 06:05:22 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ae4b4179f4sm30558826d6.113.2024.06.03.06.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 06:05:21 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 3/6] KVM: arm64: add emulation for CTR_EL0 register
Date: Mon,  3 Jun 2024 15:05:04 +0200
Message-ID: <20240603130507.17597-4-sebott@redhat.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240603130507.17597-1-sebott@redhat.com>
References: <20240603130507.17597-1-sebott@redhat.com>
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
 arch/arm64/kvm/sys_regs.c | 134 +++++++++++++++++++++++++++++++++-----
 1 file changed, 118 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0213c96f73f2..39057718fbcd 100644
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
@@ -1880,6 +1884,49 @@ static int set_wi_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
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
+static int validate_cache_topology(struct kvm_vcpu *vcpu, u64 ctr_el0)
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
+	/*
+	 * Make sure the cache line size per level obeys the minimum
+	 * cache line setting.
+	 */
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
@@ -1890,6 +1937,55 @@ static bool access_ctr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
+	u64 ctr, writable_mask = rd->val;
+	int ret = 0;
+
+	mutex_lock(&vcpu->kvm->arch.config_lock);
+	ctr  = vcpu->kvm->arch.ctr_el0;
+	if (val == ctr)
+		goto out_unlock;
+
+	ret = -EBUSY;
+	if (kvm_vm_has_ran_once(vcpu->kvm))
+		goto out_unlock;
+
+	ret = -EINVAL;
+	if ((ctr & ~writable_mask) != (val & ~writable_mask))
+		goto out_unlock;
+
+	if (((ctr & CTR_EL0_DIC_MASK) < (val & CTR_EL0_DIC_MASK)) ||
+	    ((ctr & CTR_EL0_IDC_MASK) < (val & CTR_EL0_IDC_MASK)) ||
+	    ((ctr & CTR_EL0_DminLine_MASK) < (val & CTR_EL0_DminLine_MASK)) ||
+	    ((ctr & CTR_EL0_IminLine_MASK) < (val & CTR_EL0_IminLine_MASK))) {
+		goto out_unlock;
+	}
+	ret = validate_cache_topology(vcpu, val);
+	if (ret)
+		goto out_unlock;
+
+	vcpu->kvm->arch.ctr_el0 = val;
+out_unlock:
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
+
+	return ret;
+}
+
 static bool access_clidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
@@ -1959,10 +2055,9 @@ static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 static int set_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 val)
 {
-	u64 idc = !CLIDR_LOC(val) || (!CLIDR_LOUIS(val) && !CLIDR_LOUU(val));
 	u64 ctr_el0 = vcpu->kvm->arch.ctr_el0;
 
-	if ((val & CLIDR_EL1_RES0) || (!(ctr_el0 & CTR_EL0_IDC) && idc))
+	if (validate_clidr_el1(val, ctr_el0))
 		return -EINVAL;
 
 	__vcpu_sys_reg(vcpu, rd->reg) = val;
@@ -2475,7 +2570,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
@@ -3651,6 +3750,13 @@ static bool index_to_params(u64 id, struct sys_reg_params *params)
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
@@ -3704,18 +3810,11 @@ FUNCTION_INVARIANT(midr_el1)
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
@@ -4083,6 +4182,9 @@ static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
 	 */
 	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
 		vcpu->arch.hcr_el2 |= HCR_TTLBOS;
+
+	if (kvm->arch.ctr_el0 != read_sanitised_ftr_reg(SYS_CTR_EL0))
+		vcpu->arch.hcr_el2 |= HCR_TID2;
 }
 
 void kvm_calculate_traps(struct kvm_vcpu *vcpu)
-- 
2.42.0

