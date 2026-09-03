Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 525644EC640
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451650; cv=none; b=ir+6MqtRZLwdpkjrzPY14y54KWz/plFsvsrO0uQALahNf58q2vRgMs56Xqy+pUTKFbk62gbKIizF3HdCodQyYxWlK/ZsTKvrgG+xM1ciJYWEsdSSoamGfsRoywJEwx+aVi8UG3VgPnH/XiPhRfiAksgZPzzOpTPWkjnZ1+oWsGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451650; c=relaxed/simple;
	bh=pFtVEZ2dhq5smjJX4KiK2ggzIgj0EsmQQlo0I05g5Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bU0W2I96oR9Yh98fDSocCNSsJOpN6/cJjnUG2deQeWap/6ZA4RG/vvQmvPNZJOuU8kgqsdqYD92V+gSe2ctq2qYnjTgFwQOSNceN70ngd4zzQIuEMetYHKyZFJMJTsDS/C4bp81LH/D4ODvuOLhnVogt3EHVpqxY7IUUdRQrjos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Cclb8IAx; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Cclb8IAx"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EEC5E1FC4;
	Thu,  3 Sep 2026 09:07:23 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C6A3D3F673;
	Thu,  3 Sep 2026 09:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451647; bh=pFtVEZ2dhq5smjJX4KiK2ggzIgj0EsmQQlo0I05g5Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cclb8IAxJYcTBznChszZY9BsNWNZGkaQFyqm8nr1EZ8pJ53k665yKYHcVHqy4eZmW
	 EKqqfGwbBGOF989Nt7eV2VyuttIVcKIl0u8QJvJB3U8urkC3vQ6a4PZj/xxkkDnXi6
	 AQx7htBRVBDKML7vol5EvWVWcmTJlK5ZJmKq3huI=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	will@kernel.org,
	mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org,
	catalin.marinas@arm.com,
	james.clark@linaro.org
Cc: James Morse <james.morse@arm.com>
Subject: [RFC PATCH v7 25/28] KVM: arm64: at: Use callback for reading descriptor
Date: Thu,  3 Sep 2026 17:06:20 +0100
Message-ID: <20260903160623.315525-26-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260903160623.315525-1-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow callers of __kvm_translate_va() to use a custom function for reading
the translation table descriptor from guest memory. This will be useful for
handling stage 2 faults reported by SPE, to map the stage 1 translation
tables at stage 2.

Suggested-by: James Morse <james.morse@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_nested.h |  7 +++++++
 arch/arm64/kvm/at.c                 | 22 ++++++++++++++--------
 arch/arm64/kvm/nested.c             |  7 ++++---
 3 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 1ed708335809..d812137dcd9e 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -350,8 +350,15 @@ struct s1_walk_filter {
 	void	*priv;
 };
 
+typedef int (*read_desc_fn)(struct kvm_vcpu *, u64, u64 *,
+			    struct s1_walk_info *);
+
+int kvm_vcpu_read_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 *desc,
+			  struct s1_walk_info *wi);
+
 struct s1_walk_info {
 	struct s1_walk_filter	*filter;
+	read_desc_fn		read_s1_desc;
 	u64	     		baddr;
 	enum trans_regime	regime;
 	unsigned int		max_oa_bits;
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 0926426b8798..6e77beced96c 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -224,6 +224,9 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	unsigned int stride, x;
 	bool va55, tbi, lva, upper_range;
 
+	if (!wi->read_s1_desc)
+		return -EINVAL;
+
 	va55 = va & BIT(55);
 	upper_range = va55 && wi->regime != TR_EL2;
 
@@ -427,8 +430,8 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	return -EFAULT;
 }
 
-static int kvm_read_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 *desc,
-			    struct s1_walk_info *wi)
+int kvm_vcpu_read_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 *desc,
+			  struct s1_walk_info *wi)
 {
 	u64 val;
 	int r;
@@ -513,7 +516,7 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 				return ret;
 		}
 
-		ret = kvm_read_s1_desc(vcpu, ipa, &desc, wi);
+		ret = wi->read_s1_desc(vcpu, ipa, &desc, wi);
 		if (ret) {
 			fail_s1_walk(wr, ESR_ELx_FSC_SEA_TTW(level), false);
 			return ret;
@@ -1324,6 +1327,7 @@ static int handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr, u64 *par)
 	bool perm_fail = false;
 	int ret, idx;
 
+	wi.read_s1_desc = kvm_vcpu_read_s1_desc;
 	wi.regime = compute_translation_regime(vcpu, op);
 	wi.as_el0 = (op == OP_AT_S1E0R || op == OP_AT_S1E0W);
 	wi.pan = (op == OP_AT_S1E1RP || op == OP_AT_S1E1WP) &&
@@ -1657,9 +1661,10 @@ int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 }
 
 /*
- * Translate a VA for a given EL in a given translation regime, with
- * or without PAN. This requires wi->{regime, as_el0, pan} to be
- * set. The rest of the wi and wr should be 0-initialised.
+ * Translate a VA for a given EL in a given translation regime, with or without
+ * PAN. This requires wi->{regime, as_el0, pan, read_s1_desc} to be set.
+ * Setting wi->filter is optional. The rest of the wi and wr should be
+ * 0-initialised.
  */
 int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		       struct s1_walk_result *wr, u64 va)
@@ -1716,8 +1721,9 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
 			.fn	= match_s1_desc,
 			.priv	= &dm,
 		},
-		.as_el0	= false,
-		.pan	= false,
+		.read_s1_desc	= kvm_vcpu_read_s1_desc,
+		.as_el0		= false,
+		.pan		= false,
 	};
 	struct s1_walk_result wr = {};
 	int ret;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 17123f0b6dab..e3e71628f8c5 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1435,9 +1435,10 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 			invalidate_vncr(vcpu->kvm, vt);
 
 		vt->wi = (struct s1_walk_info) {
-			.regime	= TR_EL20,
-			.as_el0	= false,
-			.pan	= false,
+			.read_s1_desc	= kvm_vcpu_read_s1_desc,
+			.regime		= TR_EL20,
+			.as_el0		= false,
+			.pan		= false,
 		};
 		vt->wr = (struct s1_walk_result){};
 	}
-- 
2.43.0

