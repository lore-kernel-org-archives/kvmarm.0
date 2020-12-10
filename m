Return-Path: <SRS0=L5kI=FO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2150C0018C
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 16:04:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A12D123F38
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 16:04:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A12D123F38
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 492294B2CC;
	Thu, 10 Dec 2020 11:04:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Koj+UEchb4iC; Thu, 10 Dec 2020 11:04:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E1D84B2C8;
	Thu, 10 Dec 2020 11:04:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D4FE4B273
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 11:04:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id efsYtbMCQVQI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Dec 2020 11:04:34 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F33EB4B2B8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 11:04:31 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1DAF123F2A;
 Thu, 10 Dec 2020 16:04:31 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1knONh-0008Di-K5; Thu, 10 Dec 2020 16:01:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v3 53/66] KVM: arm64: nv: Add handling of ARMv8.4-TTL TLB
 invalidation
Date: Thu, 10 Dec 2020 15:59:49 +0000
Message-Id: <20201210160002.1407373-54-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210160002.1407373-1-maz@kernel.org>
References: <20201210160002.1407373-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>
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
 arch/arm64/kvm/nested.c             | 57 +++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 79 +++++++++++++++++++----------
 3 files changed, 109 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 5fa3c634c8e1..7c47ad655e2e 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -123,6 +123,7 @@ extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
 			    u64 control_bit);
 extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
 extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
+unsigned int ttl_to_size(u8 ttl);
 
 struct sys_reg_params;
 struct sys_reg_desc;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 9574fde823e6..05b711e730b6 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -351,6 +351,63 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 	return ret;
 }
 
+
+unsigned int ttl_to_size(u8 ttl)
+{
+	int level = ttl & 3;
+	int gran = (ttl >> 2) & 3;
+	unsigned int max_size = 0;
+
+	switch (gran) {
+	case TLBI_TTL_TG_4K:
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
+	case TLBI_TTL_TG_16K:
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
+	case TLBI_TTL_TG_64K:
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
+	default:			/* No size information */
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
index 60d2fb6edc93..61094f5e955e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -9,6 +9,7 @@
  *          Christoffer Dall <c.dall@virtualopensystems.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/bsearch.h>
 #include <linux/kvm_host.h>
 #include <linux/mm.h>
@@ -2578,59 +2579,81 @@ static bool handle_vmalls12e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
