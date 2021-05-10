Return-Path: <SRS0=2g2/=KF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D12C43470
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 17:27:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 43C5161492
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 17:27:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 43C5161492
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C16A84B456;
	Mon, 10 May 2021 13:27:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K2Mp7Ic2WHBi; Mon, 10 May 2021 13:27:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA9D74B45B;
	Mon, 10 May 2021 13:27:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECC8D4B42A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 13:27:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eYBZBijHYnub for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 May 2021 13:27:14 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5EEA14B318
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 13:27:14 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3C7AD61469;
 Mon, 10 May 2021 17:27:13 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1lg9GX-000Uqg-RY; Mon, 10 May 2021 18:00:22 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v4 36/66] KVM: arm64: nv: Restrict S2 RD/WR permissions to
 match the guest's
Date: Mon, 10 May 2021 17:58:50 +0100
Message-Id: <20210510165920.1913477-37-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210510165920.1913477-1-maz@kernel.org>
References: <20210510165920.1913477-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
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

When mapping a page in a shadow stage-2, special care must be
taken not to be more permissive than the guest is (writable or
readable page when the guest hasn't set that permission).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 15 +++++++++++++++
 arch/arm64/kvm/mmu.c                | 14 +++++++++++++-
 arch/arm64/kvm/nested.c             |  2 +-
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 4f93a5dab183..3f3d8e10bd99 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -93,6 +93,21 @@ static inline u32 kvm_s2_trans_esr(struct kvm_s2_trans *trans)
 	return trans->esr;
 }
 
+static inline bool kvm_s2_trans_readable(struct kvm_s2_trans *trans)
+{
+	return trans->readable;
+}
+
+static inline bool kvm_s2_trans_writable(struct kvm_s2_trans *trans)
+{
+	return trans->writable;
+}
+
+static inline bool kvm_s2_trans_executable(struct kvm_s2_trans *trans)
+{
+	return !(trans->upper_attr & BIT(54));
+}
+
 extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 			      struct kvm_s2_trans *result);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6b3753460293..6db8fa8bc5a3 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -991,6 +991,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault && device)
 		return -ENOEXEC;
 
+	/*
+	 * Potentially reduce shadow S2 permissions to match the guest's own
+	 * S2. For exec faults, we'd only reach this point if the guest
+	 * actually allowed it (see kvm_s2_handle_perm_fault).
+	 */
+	if (kvm_is_shadow_s2_fault(vcpu)) {
+		writable &= kvm_s2_trans_writable(nested);
+		if (!kvm_s2_trans_readable(nested))
+			prot &= ~KVM_PGTABLE_PROT_R;
+	}
+
 	spin_lock(&kvm->mmu_lock);
 	pgt = vcpu->arch.hw_mmu->pgt;
 	if (mmu_notifier_retry(kvm, mmu_seq))
@@ -1016,7 +1027,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	if (device)
 		prot |= KVM_PGTABLE_PROT_DEVICE;
-	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
+	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC) &&
+		 kvm_s2_trans_executable(nested))
 		prot |= KVM_PGTABLE_PROT_X;
 
 	/*
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 57f32768d04d..2e6a97e43396 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -481,7 +481,7 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
 		return 0;
 
 	if (kvm_vcpu_trap_is_iabt(vcpu)) {
-		forward_fault = (trans->upper_attr & BIT(54));
+		forward_fault = !kvm_s2_trans_executable(trans);
 	} else {
 		bool write_fault = kvm_is_write_fault(vcpu);
 
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
