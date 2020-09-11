Return-Path: <SRS0=CMxQ=CU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBAC8C43461
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 13:26:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E8392222A
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 13:26:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xhnut1vZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E8392222A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14A1A4B3B2;
	Fri, 11 Sep 2020 09:26:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y1YdtD8cY4Hg; Fri, 11 Sep 2020 09:26:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE6AE4B39B;
	Fri, 11 Sep 2020 09:25:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F5FA4B312
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 09:25:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eSEPHOzEy23W for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2020 09:25:56 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 108574B396
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 09:25:55 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 57DE5221EB;
 Fri, 11 Sep 2020 13:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599830754;
 bh=VZF4o/GKYaw28XKOH529qgraxPIYKaXmcU4eKvHmV5Y=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=xhnut1vZfNCRK9hjwVlKehqCnCJf0IpkT7ujdFmiXD4um45veJISkJBzJ+A15eIje
 z04ynknVF0NCJ9iwA/9OQTfU3wkWlkcaMqG1SR234m5vwo2EdaeNgYjZYqFUxxSePk
 C8tXMqJdd9INawYJin52dorJOP1qemqe835Mh1kg=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v5 07/21] KVM: arm64: Convert kvm_phys_addr_ioremap() to
 generic page-table API
Date: Fri, 11 Sep 2020 14:25:15 +0100
Message-Id: <20200911132529.19844-8-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200911132529.19844-1-will@kernel.org>
References: <20200911132529.19844-1-will@kernel.org>
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org
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

Convert kvm_phys_addr_ioremap() to use kvm_pgtable_stage2_map() instead
of stage2_set_pte().

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4607e9ca60a2..32e93f42aed0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1154,35 +1154,33 @@ static int stage2_pudp_test_and_clear_young(pud_t *pud)
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable)
 {
-	phys_addr_t addr, end;
+	phys_addr_t addr;
 	int ret = 0;
-	unsigned long pfn;
 	struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
+	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
+	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
+				     KVM_PGTABLE_PROT_R |
+				     (writable ? KVM_PGTABLE_PROT_W : 0);
 
-	end = (guest_ipa + size + PAGE_SIZE - 1) & PAGE_MASK;
-	pfn = __phys_to_pfn(pa);
-
-	for (addr = guest_ipa; addr < end; addr += PAGE_SIZE) {
-		pte_t pte = kvm_pfn_pte(pfn, PAGE_S2_DEVICE);
-
-		if (writable)
-			pte = kvm_s2pte_mkwrite(pte);
+	size += offset_in_page(guest_ipa);
+	guest_ipa &= PAGE_MASK;
 
+	for (addr = guest_ipa; addr < guest_ipa + size; addr += PAGE_SIZE) {
 		ret = kvm_mmu_topup_memory_cache(&cache,
 						 kvm_mmu_cache_min_pages(kvm));
 		if (ret)
-			goto out;
+			break;
+
 		spin_lock(&kvm->mmu_lock);
-		ret = stage2_set_pte(&kvm->arch.mmu, &cache, addr, &pte,
-				     KVM_S2PTE_FLAG_IS_IOMAP);
+		ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
+					     &cache);
 		spin_unlock(&kvm->mmu_lock);
 		if (ret)
-			goto out;
+			break;
 
-		pfn++;
+		pa += PAGE_SIZE;
 	}
 
-out:
 	kvm_mmu_free_memory_cache(&cache);
 	return ret;
 }
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
