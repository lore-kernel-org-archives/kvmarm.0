Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F65C3B186
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 17:51:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CE86C20661
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 17:51:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ECaWC7uU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE86C20661
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84F5A4AED8;
	Tue, 11 Feb 2020 12:51:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AXUKhvo4RCYR; Tue, 11 Feb 2020 12:51:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 522F04AEA5;
	Tue, 11 Feb 2020 12:51:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60AB54AEE2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 12:51:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y4O4CM1Ou9na for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 12:51:22 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5DBC84AEC0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 12:51:21 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 85C54206CC;
 Tue, 11 Feb 2020 17:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1581443480;
 bh=VNVEjhnfzVzUtrBs05fM+reAaQaIItDsd0jrQQAovo4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=ECaWC7uUe2kT8oRS+6kMRJaSvW+T9qlLb1UD1J7ffTmJgalJ4u2/8Ae6aopzxI2LZ
 ynEDUCrle0CrsqFnWL4lYeibbBeJ4f15H4fCgsVCn9QzQd4+GC6KRcRuy9QV5S2GPw
 GyFqXKQumuRG/F7D6ae3aYm7ufqyfttENeLmrKVQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j1Zg6-004O7k-Hj; Tue, 11 Feb 2020 17:50:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 63/94] arm64: KVM: nv: Add handling of ARMv8.4-TTL TLB
 invalidation
Date: Tue, 11 Feb 2020 17:49:07 +0000
Message-Id: <20200211174938.27809-64-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu,
 alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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

Support guest-provided information information to find out about
the range of required invalidation.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  1 +
 arch/arm64/kvm/nested.c             | 56 ++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 79 +++++++++++++++++++----------
 3 files changed, 108 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 7cd0c5b0fec9..620296206483 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -67,6 +67,7 @@ extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
 			    u64 control_bit);
 extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
 extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
+unsigned int ttl_to_size(u8 ttl);
 
 struct sys_reg_params;
 struct sys_reg_desc;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 0ab08ee59110..4cb4831d4022 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -351,6 +351,62 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 	return ret;
 }
 
+
+unsigned int ttl_to_size(u8 ttl)
+{
+	int level = ttl & 3;
+	unsigned int max_size = 0;
+
+	switch (ttl >> 2) {
+	case 0:			/* No size information */
+		break;
+	case 1:			/* 4kB translation granule */
+		switch (level) {
+		case 0:
+			break;
+		case 1:
+			max_size = SZ_1G;
+			break;
+		case 2:
+			max_size = SZ_2M;
+			break;
+		case 3:
+			max_size = SZ_4K;
+			break;
+		}
+		break;
+	case 2:			/* 16kB translation granule */
+		switch (level) {
+		case 0:
+		case 1:
+			break;
+		case 2:
+			max_size = SZ_32M;
+			break;
+		case 3:
+			max_size = SZ_16K;
+			break;
+		}
+		break;
+	case 3:			/* 64kB translation granule */
+		switch (level) {
+		case 0:
+		case 1:
+			/* No 52bit IPA support */
+			break;
+		case 2:
+			max_size = SZ_512M;
+			break;
+		case 3:
+			max_size = SZ_64K;
+			break;
+		}
+		break;
+	}
+
+	return max_size;
+}
+
 /* Must be called with kvm->lock held */
 struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr)
 {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 121b3f28cae2..1dcde0230b87 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -9,6 +9,7 @@
  *          Christoffer Dall <c.dall@virtualopensystems.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/bsearch.h>
 #include <linux/kvm_host.h>
 #include <linux/mm.h>
@@ -2583,59 +2584,81 @@ static bool handle_vmalls12e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static unsigned long compute_tlb_inval_range(struct kvm_vcpu *vcpu,
+					     struct kvm_s2_mmu *mmu,
+					     u64 val)
+{
+	unsigned long max_size;
+	u8 ttl = 0;
+
+	if (cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL)) {
+		ttl = FIELD_GET(GENMASK_ULL(47, 44), val);
+	}
+
+	max_size = ttl_to_size(ttl);
+
+	if (!max_size) {
+		u64 vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
+
+		/* Compute the maximum extent of the invalidation */
+		switch ((vtcr & VTCR_EL2_TG0_MASK)) {
+		case VTCR_EL2_TG0_4K:
+			max_size = SZ_1G;
+			break;
+		case VTCR_EL2_TG0_16K:
+			max_size = SZ_32M;
+			break;
+		case VTCR_EL2_TG0_64K:
+			/*
+			 * No, we do not support 52bit IPA in nested yet. Once
+			 * we do, this should be 4TB.
+			 */
+			/* FIXME: remove the 52bit PA support from the IDregs */
+			max_size = SZ_512M;
+			break;
+		default:
+			BUG();
+		}
+	}
+
+	WARN_ON(!max_size);
+	return max_size;
+}
+
 static bool handle_ipas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			     const struct sys_reg_desc *r)
 {
 	u64 vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
-	u64 vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
 	struct kvm_s2_mmu *mmu;
 	u64 base_addr;
-	int max_size;
+	unsigned long max_size;
 
 	/*
 	 * We drop a number of things from the supplied value:
 	 *
 	 * - NS bit: we're non-secure only.
 	 *
-	 * - TTL field: We already have the granule size from the
-	 *   VTCR_EL2.TG0 field, and the level is only relevant to the
-	 *   guest's S2PT.
-	 *
 	 * - IPA[51:48]: We don't support 52bit IPA just yet...
 	 *
 	 * And of course, adjust the IPA to be on an actual address.
 	 */
 	base_addr = (p->regval & GENMASK_ULL(35, 0)) << 12;
 
-	/* Compute the maximum extent of the invalidation */
-	switch ((vtcr & VTCR_EL2_TG0_MASK)) {
-	case VTCR_EL2_TG0_4K:
-		max_size = SZ_1G;
-		break;
-	case VTCR_EL2_TG0_16K:
-		max_size = SZ_32M;
-		break;
-	case VTCR_EL2_TG0_64K:
-		/*
-		 * No, we do not support 52bit IPA in nested yet. Once
-		 * we do, this should be 4TB.
-		 */
-		/* FIXME: remove the 52bit PA support from the IDregs */
-		max_size = SZ_512M;
-		break;
-	default:
-		BUG();
-	}
-
 	spin_lock(&vcpu->kvm->mmu_lock);
 
 	mmu = lookup_s2_mmu(vcpu->kvm, vttbr, HCR_VM);
-	if (mmu)
+	if (mmu) {
+		max_size = compute_tlb_inval_range(vcpu, mmu, p->regval);
+		base_addr &= ~(max_size - 1);
 		kvm_unmap_stage2_range(mmu, base_addr, max_size);
+	}
 
 	mmu = lookup_s2_mmu(vcpu->kvm, vttbr, 0);
-	if (mmu)
+	if (mmu) {
+		max_size = compute_tlb_inval_range(vcpu, mmu, p->regval);
+		base_addr &= ~(max_size - 1);
 		kvm_unmap_stage2_range(mmu, base_addr, max_size);
+	}
 
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
