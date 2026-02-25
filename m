Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914793939B8
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 10:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772016450; cv=none; b=o1aeWL7gY9VzqQ2uGZXDHzpjR3/rX9vpAPMxRoR2zEHSZi4arbaCwJDIoAFSan2hQSbSKz8ltuex5O1dO7KSCNJOtkMO6YPXHF9ihf/IRe+b0vrtZZg7wgcbgqMhuWY1tmkNgoIFsJXFXM1nAey/GfASInKMs+BuC1PiLwypgoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772016450; c=relaxed/simple;
	bh=bdnD7YNeSgoFDjsR80h75dWUj9sAfEHgusImJ+0NuKc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P0zokmSCHLRWwb0md8PJsMWqTGhFexruIMsUA2I8CT1PLfmN1UWUHr6WGAoNwSKDMASDJOO76YlflrwltIsyFrEa94TpQ+IDVHwC1wKbfOMginJgpZcQ3jZr8p2gBD+0MEtZj0li9We67fpsEpgmKhAU6um1tsvV8Wv7hKjgx9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E7zF8h14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E7zF8h14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1666CC116D0;
	Wed, 25 Feb 2026 10:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772016450;
	bh=bdnD7YNeSgoFDjsR80h75dWUj9sAfEHgusImJ+0NuKc=;
	h=From:To:Cc:Subject:Date:From;
	b=E7zF8h14iwOT1qT9iOWT7EGY03pcGgxNH7GaOxOfwhZ0hWHhL39qWqjHb4Lu67WpF
	 XkIPZk+e2z+Ae+O2v2sVnbFzz3d4t6xuUEN1u4VSzBMeMEr2ZS9Fm6WCi13CBGqJen
	 YxsDoFcYQdXvLHYZ9HSEt8Z06by/Gf4qaItoTi5G3tCo9QzO36L3Tx84S6h2qAmO3P
	 uKfdciTaUj5ZEiPpbzw8/VYQtvK4Okp4FIyUFZD97cWObSr25LL0KtRkvUjqU4wFxc
	 Lqf1eho3m0ZdVG8cz/Q8GjVSRSJJYYtEDB7JpzN4EwmFyqNJqNTlZC7bCCf/SGmobZ
	 NYW89HC0OTHZw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vvCQR-0000000Dfkb-3VQP;
	Wed, 25 Feb 2026 10:47:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Deduplicate ASID retrieval code
Date: Wed, 25 Feb 2026 10:47:18 +0000
Message-ID: <20260225104718.14209-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We currently have three versions of the ASID retrieval code, one
in the S1 walker, and two in the VNCR handling (although the last
two are limited to the EL2&0 transltion regime).

Make this code common, and take this opportunity to also simplify
the code a bit while switching over to the TTBRx_EL1_ASID macro.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  2 +
 arch/arm64/kvm/at.c                 | 27 +------------
 arch/arm64/kvm/nested.c             | 60 +++++++++++++++--------------
 3 files changed, 35 insertions(+), 54 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 905c658057a43..091544e6af442 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -397,6 +397,8 @@ int kvm_vcpu_allocate_vncr_tlb(struct kvm_vcpu *vcpu);
 int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu);
 void kvm_handle_s1e2_tlbi(struct kvm_vcpu *vcpu, u32 inst, u64 val);
 
+u16 get_asid_by_regime(struct kvm_vcpu *vcpu, enum trans_regime regime);
+
 #define vncr_fixmap(c)						\
 	({							\
 		u32 __c = (c);					\
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 885bd5bb2f416..6588ea251ed77 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -540,31 +540,8 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	wr->pa |= va & GENMASK_ULL(va_bottom - 1, 0);
 
 	wr->nG = (wi->regime != TR_EL2) && (desc & PTE_NG);
-	if (wr->nG) {
-		u64 asid_ttbr, tcr;
-
-		switch (wi->regime) {
-		case TR_EL10:
-			tcr = vcpu_read_sys_reg(vcpu, TCR_EL1);
-			asid_ttbr = ((tcr & TCR_A1) ?
-				     vcpu_read_sys_reg(vcpu, TTBR1_EL1) :
-				     vcpu_read_sys_reg(vcpu, TTBR0_EL1));
-			break;
-		case TR_EL20:
-			tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
-			asid_ttbr = ((tcr & TCR_A1) ?
-				     vcpu_read_sys_reg(vcpu, TTBR1_EL2) :
-				     vcpu_read_sys_reg(vcpu, TTBR0_EL2));
-			break;
-		default:
-			BUG();
-		}
-
-		wr->asid = FIELD_GET(TTBR_ASID_MASK, asid_ttbr);
-		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
-		    !(tcr & TCR_ASID16))
-			wr->asid &= GENMASK(7, 0);
-	}
+	if (wr->nG)
+		wr->asid = get_asid_by_regime(vcpu, wi->regime);
 
 	return 0;
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 7f1ea85dc67ab..787776aaf4ad1 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -854,6 +854,33 @@ int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
 	return kvm_inject_nested_sync(vcpu, esr_el2);
 }
 
+u16 get_asid_by_regime(struct kvm_vcpu *vcpu, enum trans_regime regime)
+{
+	enum vcpu_sysreg ttbr_elx;
+	u64 tcr;
+	u16 asid;
+
+	switch (regime) {
+	case TR_EL10:
+		tcr = vcpu_read_sys_reg(vcpu, TCR_EL1);
+		ttbr_elx = (tcr & TCR_A1) ? TTBR1_EL1 : TTBR0_EL1;
+		break;
+	case TR_EL20:
+		tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
+		ttbr_elx = (tcr & TCR_A1) ? TTBR1_EL2 : TTBR0_EL2;
+		break;
+	default:
+		BUG();
+	}
+
+	asid = FIELD_GET(TTBRx_EL1_ASID, vcpu_read_sys_reg(vcpu, ttbr_elx));
+	if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
+	    !(tcr & TCR_ASID16))
+		asid &= GENMASK(7, 0);
+
+	return asid;
+}
+
 static void invalidate_vncr(struct vncr_tlb *vt)
 {
 	vt->valid = false;
@@ -1333,20 +1360,8 @@ static bool kvm_vncr_tlb_lookup(struct kvm_vcpu *vcpu)
 	if (read_vncr_el2(vcpu) != vt->gva)
 		return false;
 
-	if (vt->wr.nG) {
-		u64 tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
-		u64 ttbr = ((tcr & TCR_A1) ?
-			    vcpu_read_sys_reg(vcpu, TTBR1_EL2) :
-			    vcpu_read_sys_reg(vcpu, TTBR0_EL2));
-		u16 asid;
-
-		asid = FIELD_GET(TTBR_ASID_MASK, ttbr);
-		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
-		    !(tcr & TCR_ASID16))
-			asid &= GENMASK(7, 0);
-
-		return asid == vt->wr.asid;
-	}
+	if (vt->wr.nG)
+		return get_asid_by_regime(vcpu, TR_EL20) == vt->wr.asid;
 
 	return true;
 }
@@ -1449,21 +1464,8 @@ static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)
 	if (read_vncr_el2(vcpu) != vt->gva)
 		return;
 
-	if (vt->wr.nG) {
-		u64 tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
-		u64 ttbr = ((tcr & TCR_A1) ?
-			    vcpu_read_sys_reg(vcpu, TTBR1_EL2) :
-			    vcpu_read_sys_reg(vcpu, TTBR0_EL2));
-		u16 asid;
-
-		asid = FIELD_GET(TTBR_ASID_MASK, ttbr);
-		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
-		    !(tcr & TCR_ASID16))
-			asid &= GENMASK(7, 0);
-
-		if (asid != vt->wr.asid)
-			return;
-	}
+	if (vt->wr.nG && get_asid_by_regime(vcpu, TR_EL20) != vt->wr.asid)
+		return;
 
 	vt->cpu = smp_processor_id();
 
-- 
2.47.3

