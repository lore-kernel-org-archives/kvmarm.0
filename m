Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F52C3B187
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 17:53:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 36ED520848
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 17:53:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="C2hxYCSB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36ED520848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E00304AED1;
	Tue, 11 Feb 2020 12:53:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CsPhI6Vl-Iti; Tue, 11 Feb 2020 12:53:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA7804AEF5;
	Tue, 11 Feb 2020 12:53:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B31554A946
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 12:53:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VxXZdr5KsEqG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 12:53:26 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C86F24AF10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 12:53:25 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 07D0A20578;
 Tue, 11 Feb 2020 17:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1581443605;
 bh=6qEfnPAQpmbL6mkKK1EQQA1y8FQyNR3EaGGAZea+tbk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=C2hxYCSBr8A2cGVap21mWjhMt72gIg1HgqTKuOrdCTVW4rkT+XN8MmJXbILHounYV
 sku3e/hkzreGyEo5shAsbkuwL8odH4tzmlWRDYQjnYuWjGmzmZ2r4eL+Pnl7utC925
 U3GQaUkOsj5HYl856LkVthyKy8D1I+RdICX9srbU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j1Zg4-004O7k-ON; Tue, 11 Feb 2020 17:50:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 60/94] arm64: KVM: nv: Restrict S2 RD/WR permissions to
 match the guest's
Date: Tue, 11 Feb 2020 17:49:04 +0000
Message-Id: <20200211174938.27809-61-maz@kernel.org>
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

When mapping a page in a shadow stage-2, special care must be
taken not to be more permissive than the guest is (writable or
readable page when the guest hasn't set that permission).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm/include/asm/kvm_mmu.h      | 18 ++++++++++++++++++
 arch/arm64/include/asm/kvm_mmu.h    | 18 ++++++++++++++++++
 arch/arm64/include/asm/kvm_nested.h | 10 ++++++++++
 virt/kvm/arm/mmu.c                  | 21 ++++++++++++++++++++-
 4 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 1d0d5f00f0af..be7be6583e54 100644
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
index 9c0bf878fb3b..b390bba466e9 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -228,6 +228,24 @@ static inline pud_t kvm_s2pud_mkexec(pud_t pud)
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
index 45c013c0c856..7cd0c5b0fec9 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -43,6 +43,16 @@ static inline u32 kvm_s2_trans_esr(struct kvm_s2_trans *trans)
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
index 0086b42237af..7da72c2b7f0f 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1721,7 +1721,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  unsigned long hva, unsigned long fault_status)
 {
 	int ret;
-	bool write_fault, writable;
+	bool write_fault, writable, readable = true;
 	bool exec_fault, needs_exec;
 	unsigned long mmu_seq;
 	phys_addr_t ipa = fault_ipa;
@@ -1841,6 +1841,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault && is_iomap(flags))
 		return -ENOEXEC;
 
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
@@ -1886,6 +1896,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		if (writable)
 			new_pud = kvm_s2pud_mkwrite(new_pud);
 
+		if (!readable)
+			new_pud = kvm_s2pud_revoke_read(new_pud);
+
 		if (needs_exec)
 			new_pud = kvm_s2pud_mkexec(new_pud);
 
@@ -1898,6 +1911,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		if (writable)
 			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
 
+		if (!readable)
+			new_pmd = kvm_s2pmd_revoke_read(new_pmd);
+
 		if (needs_exec)
 			new_pmd = kvm_s2pmd_mkexec(new_pmd);
 
@@ -1910,6 +1926,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
