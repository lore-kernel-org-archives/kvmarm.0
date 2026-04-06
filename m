Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 365E635F5E9
	for <kvmarm@lists.linux.dev>; Mon,  6 Apr 2026 16:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775494058; cv=none; b=oWUJ7m3I0rYybGCSXMFZ0e+yOOyELkjSmeFZ18EYzMs+Ox2Dq85kUHUr8igtTFGUT7lTTBRtQ9MNVfmnnmfwRcTtYdc0TlP1E4aZQkibBsaKotYN1I7FwrjlsBfnUM+GS8XsYXHVfZEOPOKdYo/W/RFn80faRpdh/U8zc056UTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775494058; c=relaxed/simple;
	bh=+TkEll1g4GPMoDQnUJ+ojaCZea8pptFIoCXOi3JHR/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCEeEOd1mpE2xhDGYsH1biyUQgVL0tIz1M4PakYjXMtActKewrx2WiDCtvgGUxl61A0ZpgtFzu+ocxZFCVbyO2VQhCf8nF72uFdxwMPOSLOLIgJxKogF+dDc52BqLPePuCUkBZ9UQX/8UyjCt1Mtpx74BVP4+2NKFf+ljQWgK+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pazcLLgE; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pazcLLgE"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC47016F3;
	Mon,  6 Apr 2026 09:47:29 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 258A53F7D8;
	Mon,  6 Apr 2026 09:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775494055; bh=+TkEll1g4GPMoDQnUJ+ojaCZea8pptFIoCXOi3JHR/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pazcLLgEY+txpooJQ2Q2dqL696hUl0qWATrOFtJeOxjQX5loFPlBhHscKu08qaw5c
	 Akoxy7d0q1HRQtp0rag04febeM0q9IzTjCQ7O3wM0YjETgEL9M4L8MLiNhk6HnonkS
	 eKRMN2BN1ydiRUqKtNXB1SWesVmL0db5zBFYbqlU=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH 2/2] KVM: arm64: Fallback to a supported value for unsupported guest TGx
Date: Mon,  6 Apr 2026 17:46:18 +0100
Message-ID: <20260406164618.3312473-3-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260406164618.3312473-1-weilin.chang@arm.com>
References: <20260406164618.3312473-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When KVM derives the translation granule for emulated stage-1 and
stage-2 walks, it decodes TCR/VTCR.TGx and treats the granule as-is.
This is wrong when the guest programs a granule size that is not
advertised in the guest's ID_AA64MMFR0_EL1.TGRAN* fields.
Architecturally, such a value must be treated as an implemented granule
size. Choose an available one while prioritizing PAGE_SIZE.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/at.c     | 48 ++++++++++++++++++++++++++
 arch/arm64/kvm/nested.c | 75 +++++++++++++++++++++++++++++++----------
 2 files changed, 105 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index ff8ba30e917b..6dd883798f83 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -135,6 +135,30 @@ static void compute_s1poe(struct kvm_vcpu *vcpu, struct s1_walk_info *wi)
 	wi->e0poe = (wi->regime != TR_EL2) && (val & TCR2_EL1_E0POE);
 }
 
+#define _has_tgran(__r, __sz)					\
+	({							\
+		u64 _s1, _mmfr0 = __r;				\
+								\
+		_s1 = SYS_FIELD_GET(ID_AA64MMFR0_EL1,		\
+				    TGRAN##__sz, _mmfr0);	\
+								\
+		_s1 != ID_AA64MMFR0_EL1_TGRAN##__sz##_NI;	\
+	})
+
+static bool has_tgran(u64 mmfr0, unsigned int shift)
+{
+	switch (shift) {
+	case 12:
+		return _has_tgran(mmfr0, 4);
+	case 14:
+		return _has_tgran(mmfr0, 16);
+	case 16:
+		return _has_tgran(mmfr0, 64);
+	default:
+		BUG();
+	}
+}
+
 static unsigned int tg0_to_shift(u64 tg0)
 {
 	switch (tg0) {
@@ -161,8 +185,23 @@ static unsigned int tg1_to_shift(u64 tg1)
 	}
 }
 
+static unsigned int fallback_tgran_shift(u64 mmfr0)
+{
+	if (has_tgran(mmfr0, PAGE_SHIFT))
+		return PAGE_SHIFT;
+	else if (has_tgran(mmfr0, 12))
+		return 12;
+	else if (has_tgran(mmfr0, 14))
+		return 14;
+	else if (has_tgran(mmfr0, 16))
+		return 16;
+	else
+		return PAGE_SHIFT;
+}
+
 static u64 tcr_tg_shift(struct kvm *kvm, u64 tcr, bool upper_range)
 {
+	u64 mmfr0 = kvm_read_vm_id_reg(kvm, SYS_ID_AA64MMFR0_EL1);
 	unsigned int shift;
 
 	/* Someone was silly enough to encode TG0/TG1 differently */
@@ -171,6 +210,15 @@ static u64 tcr_tg_shift(struct kvm *kvm, u64 tcr, bool upper_range)
 	else
 		shift = tg0_to_shift(FIELD_GET(TCR_EL1_TG0_MASK, tcr));
 
+	/*
+	 * If TGx is programmed to an unimplemented value (not advertised in
+	 * ID_AA64MMFR0_EL1), we should treat it as if an implemented value is
+	 * written, as per the architecture. Choose an available one while
+	 * prioritizing PAGE_SIZE.
+	 */
+	if (!has_tgran(mmfr0, shift))
+		return fallback_tgran_shift(mmfr0);
+
 	return shift;
 }
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 2bfab3007cb3..64794ba4848d 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -378,6 +378,36 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 	return 0;
 }
 
+#define _has_tgran_2(__r, __sz)						\
+	({								\
+		u64 _s1, _s2, _mmfr0 = __r;				\
+									\
+		_s2 = SYS_FIELD_GET(ID_AA64MMFR0_EL1,			\
+				    TGRAN##__sz##_2, _mmfr0);		\
+									\
+		_s1 = SYS_FIELD_GET(ID_AA64MMFR0_EL1,			\
+				    TGRAN##__sz, _mmfr0);		\
+									\
+		((_s2 != ID_AA64MMFR0_EL1_TGRAN##__sz##_2_NI &&		\
+		  _s2 != ID_AA64MMFR0_EL1_TGRAN##__sz##_2_TGRAN##__sz) || \
+		 (_s2 == ID_AA64MMFR0_EL1_TGRAN##__sz##_2_TGRAN##__sz && \
+		  _s1 != ID_AA64MMFR0_EL1_TGRAN##__sz##_NI));		\
+	})
+
+static bool has_tgran_2(u64 mmfr0, unsigned int shift)
+{
+	switch (shift) {
+	case 12:
+		return _has_tgran_2(mmfr0, 4);
+	case 14:
+		return _has_tgran_2(mmfr0, 16);
+	case 16:
+		return _has_tgran_2(mmfr0, 64);
+	default:
+		BUG();
+	}
+}
+
 static unsigned int tg0_to_shift(u64 tg0)
 {
 	switch (tg0) {
@@ -391,11 +421,35 @@ static unsigned int tg0_to_shift(u64 tg0)
 	}
 }
 
+static unsigned int fallback_tgran2_shift(u64 mmfr0)
+{
+	if (has_tgran_2(mmfr0, PAGE_SHIFT))
+		return PAGE_SHIFT;
+	else if (has_tgran_2(mmfr0, 12))
+		return 12;
+	else if (has_tgran_2(mmfr0, 14))
+		return 14;
+	else if (has_tgran_2(mmfr0, 16))
+		return 16;
+	else
+		return PAGE_SHIFT;
+}
+
 static u64 vtcr_tg0_shift(struct kvm *kvm, u64 vtcr)
 {
+	u64 mmfr0 = kvm_read_vm_id_reg(kvm, SYS_ID_AA64MMFR0_EL1);
 	u64 tg0 = FIELD_GET(VTCR_EL2_TG0_MASK, vtcr);
 	unsigned int shift = tg0_to_shift(tg0);
 
+	/*
+	 * If TGx is programmed to an unimplemented value (not advertised in
+	 * ID_AA64MMFR0_EL1), we should treat it as if an implemented value is
+	 * written, as per the architecture. Choose an available one while
+	 * prioritizing PAGE_SIZE.
+	 */
+	if (!has_tgran_2(mmfr0, shift))
+		return fallback_tgran2_shift(mmfr0);
+
 	return shift;
 }
 
@@ -1516,21 +1570,6 @@ static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)
 	}
 }
 
-#define has_tgran_2(__r, __sz)						\
-	({								\
-		u64 _s1, _s2, _mmfr0 = __r;				\
-									\
-		_s2 = SYS_FIELD_GET(ID_AA64MMFR0_EL1,			\
-				    TGRAN##__sz##_2, _mmfr0);		\
-									\
-		_s1 = SYS_FIELD_GET(ID_AA64MMFR0_EL1,			\
-				    TGRAN##__sz, _mmfr0);		\
-									\
-		((_s2 != ID_AA64MMFR0_EL1_TGRAN##__sz##_2_NI &&		\
-		  _s2 != ID_AA64MMFR0_EL1_TGRAN##__sz##_2_TGRAN##__sz) || \
-		 (_s2 == ID_AA64MMFR0_EL1_TGRAN##__sz##_2_TGRAN##__sz && \
-		  _s1 != ID_AA64MMFR0_EL1_TGRAN##__sz##_NI));		\
-	})
 /*
  * Our emulated CPU doesn't support all the possible features. For the
  * sake of simplicity (and probably mental sanity), wipe out a number
@@ -1617,15 +1656,15 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		 */
 		switch (PAGE_SIZE) {
 		case SZ_4K:
-			if (has_tgran_2(orig_val, 4))
+			if (_has_tgran_2(orig_val, 4))
 				val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN4_2, IMP);
 			fallthrough;
 		case SZ_16K:
-			if (has_tgran_2(orig_val, 16))
+			if (_has_tgran_2(orig_val, 16))
 				val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN16_2, IMP);
 			fallthrough;
 		case SZ_64K:
-			if (has_tgran_2(orig_val, 64))
+			if (_has_tgran_2(orig_val, 64))
 				val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN64_2, IMP);
 			break;
 		}
-- 
2.43.0

