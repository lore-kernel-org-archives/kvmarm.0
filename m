Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 561692B9A4
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136526; cv=none; b=HkkjWJHswgCbOs6SUc1KgKlCu1WJU09jmCgVS+mk/way4yhrYPjK3KQxbqeivVKJqZypaamF/jA0ZyniqXxs1BvoKb11tC0y7fec9h0jS6svt+vzKy8VWBoieZRsg2kAlq5z4FV9hjbYq9Bf/cHOw/AKgpcVABc6n9rL1Mb7Z1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136526; c=relaxed/simple;
	bh=g4lHCTwMAU4ndGnY00xoomb/+GMYCVf/W+odcOmhlYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzaALvWXqjOmTKEoea07A2l2zksQPi5suPpu2JMsx/6a+AR01FSVMnb+JNh2d4wOpyHQvelSDdD/ESAE04s4A4XlVICmiDt6vWBZOvV1KWmL0AJ6tfXXRrF11tevhjBnrKtKPwK3lXruBey64hVzD2xEuxSIt70t/LouXIMjLAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4837919F6;
	Fri, 14 Nov 2025 08:08:37 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF63A3F5A1;
	Fri, 14 Nov 2025 08:08:42 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 28/35] KVM: arm64: at: Use callback for reading descriptor
Date: Fri, 14 Nov 2025 16:07:09 +0000
Message-ID: <20251114160717.163230-29-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow callers of __kvm_translate_va() to use a custom defined function for
reading the translation table descriptor from guest memory. This will be
useful for SPE virtualization, where the translation tables must also be
mapped at stage 2 for the entire duration of the guest profiling session.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_nested.h |  6 ++++++
 arch/arm64/kvm/at.c                 | 17 +++++++++++++----
 arch/arm64/kvm/nested.c             |  7 ++++---
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index f7c06a840963..e9a73ea74f24 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -284,6 +284,11 @@ static inline unsigned int ps_to_output_size(unsigned int ps, bool pa52bit)
 	}
 }
 
+typedef int (*read_desc_fn)(struct kvm_vcpu *, gpa_t, void *, unsigned long);
+
+int kvm_vcpu_read_desc(struct kvm_vcpu *vcpu, gpa_t gpa, void *desc,
+		       unsigned long len);
+
 enum trans_regime {
 	TR_EL10,
 	TR_EL20,
@@ -305,6 +310,7 @@ struct s1_walk_filter {
 
 struct s1_walk_info {
 	struct s1_walk_filter	*filter;
+	read_desc_fn		read_desc;
 	u64	     		baddr;
 	enum trans_regime	regime;
 	unsigned int		max_oa_bits;
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index be26d5aa668c..e1df4278d5d5 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -110,6 +110,12 @@ static u64 effective_tcr2(struct kvm_vcpu *vcpu, enum trans_regime regime)
 	return vcpu_read_sys_reg(vcpu, TCR2_EL2);
 }
 
+int kvm_vcpu_read_desc(struct kvm_vcpu *vcpu, gpa_t gpa, void *desc,
+		       unsigned long len)
+{
+	return kvm_read_guest(vcpu->kvm, gpa, desc, len);
+}
+
 static bool s1pie_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
 {
 	if (!kvm_has_s1pie(vcpu->kvm))
@@ -142,6 +148,9 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	unsigned int stride, x;
 	bool va55, tbi, lva;
 
+	if (!wi->read_desc)
+		return -EINVAL;
+
 	va55 = va & BIT(55);
 
 	if (vcpu_has_nv(vcpu)) {
@@ -414,7 +423,7 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 				return ret;
 		}
 
-		ret = kvm_read_guest(vcpu->kvm, ipa, &desc, sizeof(desc));
+		ret = wi->read_desc(vcpu, ipa, &desc, sizeof(desc));
 		if (ret) {
 			fail_s1_walk(wr, ESR_ELx_FSC_SEA_TTW(level), false);
 			return ret;
@@ -1542,9 +1551,9 @@ void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 }
 
 /*
- * Translate a VA for a given EL in a given translation regime, with
- * or without PAN. This requires wi->{regime, as_el0, pan} to be
- * set. The rest of the wi and wr should be 0-initialised.
+ * Translate a VA for a given EL in a given translation regime, with or without
+ * PAN. This requires wi->{read_desc, regime, as_el0, pan} to be set. The rest
+ * of the wi and wr should be 0-initialised.
  */
 int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		       struct s1_walk_result *wr, u64 va)
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index f04cda40545b..92e94bb96bcc 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1196,9 +1196,10 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 		invalidate_vncr(vt);
 
 		vt->wi = (struct s1_walk_info) {
-			.regime	= TR_EL20,
-			.as_el0	= false,
-			.pan	= false,
+			.read_desc	= kvm_vcpu_read_desc,
+			.regime		= TR_EL20,
+			.as_el0		= false,
+			.pan		= false,
 		};
 		vt->wr = (struct s1_walk_result){};
 	}
-- 
2.51.2

