Return-Path: <SRS0=LUtr=UU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D30ADC48BE0
	for <kvmarm@archiver.kernel.org>; Fri, 21 Jun 2019 09:40:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9934B21530
	for <kvmarm@archiver.kernel.org>; Fri, 21 Jun 2019 09:40:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9934B21530
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 820DE4A50A;
	Fri, 21 Jun 2019 05:40:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EUWwsGtHIXXR; Fri, 21 Jun 2019 05:40:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FD3D4A57C;
	Fri, 21 Jun 2019 05:40:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51F354A4C1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jun 2019 05:40:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VBC1QX3QYu3i for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Jun 2019 05:40:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6A0D4A3BF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jun 2019 05:40:43 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6FAED1478;
 Fri, 21 Jun 2019 02:40:43 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B3263F246;
 Fri, 21 Jun 2019 02:40:42 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 58/59] arm64: KVM: nv: Restrict S2 RD/WR permissions to match
 the guest's
Date: Fri, 21 Jun 2019 10:38:42 +0100
Message-Id: <20190621093843.220980-59-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
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

When mapping a page in a shadow stage-2, special care must be
taken not to be more permissive than the guest is (writable or
readable page when the guest hasn't set that permission).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h      | 18 ++++++++++++++++++
 arch/arm64/include/asm/kvm_mmu.h    | 18 ++++++++++++++++++
 arch/arm64/include/asm/kvm_nested.h | 10 ++++++++++
 virt/kvm/arm/mmu.c                  | 21 ++++++++++++++++++++-
 4 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 7a6e9008ed45..7aa7182ca744 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -113,6 +113,12 @@ static inline pud_t kvm_s2pud_mkexec(pud_t pud)
 	return pud;
 }
 
+static inline pud_t kvm_s2pud_revoke_read(pud_t pud)
+{
+	WARN_ON(1);
+	return pud;
+}
+
 static inline bool kvm_s2pud_exec(pud_t *pud)
 {
 	WARN_ON(1);
@@ -155,6 +161,18 @@ static inline pmd_t kvm_s2pmd_mkexec(pmd_t pmd)
 	return pmd;
 }
 
+static inline pte_t kvm_s2pte_revoke_read(pte_t pte)
+{
+	pte_val(pte) &= ~L_PTE_S2_RDONLY;
+	return pte;
+}
+
+static inline pmd_t kvm_s2pmd_revoke_read(pmd_t pmd)
+{
+	pmd_val(pmd) &= ~L_PMD_S2_RDONLY;
+	return pmd;
+}
+
 static inline void kvm_set_s2pte_readonly(pte_t *pte)
 {
 	pte_val(*pte) = (pte_val(*pte) & ~L_PTE_S2_RDWR) | L_PTE_S2_RDONLY;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 53103607065a..f46ea12e55c2 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -238,6 +238,24 @@ static inline pud_t kvm_s2pud_mkexec(pud_t pud)
 	return pud;
 }
 
+static inline pte_t kvm_s2pte_revoke_read(pte_t pte)
+{
+	pte_val(pte) &= ~PTE_S2_RDONLY;
+	return pte;
+}
+
+static inline pmd_t kvm_s2pmd_revoke_read(pmd_t pmd)
+{
+	pmd_val(pmd) &= ~PMD_S2_RDONLY;
+	return pmd;
+}
+
+static inline pud_t kvm_s2pud_revoke_read(pud_t pud)
+{
+	pud_val(pud) &= ~PUD_S2_RDONLY;
+	return pud;
+}
+
 static inline void kvm_set_s2pte_readonly(pte_t *ptep)
 {
 	pteval_t old_pteval, pteval;
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 3b415bc76ced..76777b1b9419 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -42,6 +42,16 @@ static inline u32 kvm_s2_trans_esr(struct kvm_s2_trans *trans)
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
 extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 			      struct kvm_s2_trans *result);
 
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 0ea79e543b29..bc8cb529647b 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1729,7 +1729,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  unsigned long hva, unsigned long fault_status)
 {
 	int ret;
-	bool write_fault, writable;
+	bool write_fault, writable, readable = true;
 	bool exec_fault, needs_exec;
 	unsigned long mmu_seq;
 	phys_addr_t ipa = fault_ipa;
@@ -1842,6 +1842,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			writable = false;
 	}
 
+	/*
+	 * Potentially reduce shadow S2 permissions to match the guest's own
+	 * S2. For exec faults, we'd only reach this point if the guest
+	 * actually allowed it (see kvm_s2_handle_perm_fault).
+	 */
+	if (kvm_is_shadow_s2_fault(vcpu)) {
+		writable &= kvm_s2_trans_writable(nested);
+		readable &= kvm_s2_trans_readable(nested);
+	}
+
 	spin_lock(&kvm->mmu_lock);
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
@@ -1887,6 +1897,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		if (writable)
 			new_pud = kvm_s2pud_mkwrite(new_pud);
 
+		if (!readable)
+			new_pud = kvm_s2pud_revoke_read(new_pud);
+
 		if (needs_exec)
 			new_pud = kvm_s2pud_mkexec(new_pud);
 
@@ -1899,6 +1912,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		if (writable)
 			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
 
+		if (!readable)
+			new_pmd = kvm_s2pmd_revoke_read(new_pmd);
+
 		if (needs_exec)
 			new_pmd = kvm_s2pmd_mkexec(new_pmd);
 
@@ -1911,6 +1927,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			mark_page_dirty(kvm, gfn);
 		}
 
+		if (!readable)
+			new_pte = kvm_s2pte_revoke_read(new_pte);
+
 		if (needs_exec)
 			new_pte = kvm_s2pte_mkexec(new_pte);
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
