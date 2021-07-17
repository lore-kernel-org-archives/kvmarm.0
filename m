Return-Path: <SRS0=Kzo3=MJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0DC8C636CD
	for <kvmarm@archiver.kernel.org>; Sat, 17 Jul 2021 09:56:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 595A4613E8
	for <kvmarm@archiver.kernel.org>; Sat, 17 Jul 2021 09:56:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 595A4613E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC4BD4B0DF;
	Sat, 17 Jul 2021 05:56:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uo597aXxpD89; Sat, 17 Jul 2021 05:56:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6F5B4B0DB;
	Sat, 17 Jul 2021 05:56:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC9184B0DD
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Jul 2021 05:56:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nLw1zDhQNgli for <kvmarm@lists.cs.columbia.edu>;
 Sat, 17 Jul 2021 05:56:12 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DE0884B0D6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Jul 2021 05:56:11 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 286E2613E3;
 Sat, 17 Jul 2021 09:56:11 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1m4h3J-00DvkH-GM; Sat, 17 Jul 2021 10:56:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org
Subject: [PATCH 2/5] KVM: arm64: Avoid mapping size adjustment on permission
 fault
Date: Sat, 17 Jul 2021 10:55:38 +0100
Message-Id: <20210717095541.1486210-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210717095541.1486210-1-maz@kernel.org>
References: <20210717095541.1486210-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org, seanjc@google.com,
 willy@infradead.org, pbonzini@redhat.com, will@kernel.org, qperret@google.com,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Sean Christopherson <seanjc@google.com>,
 Matthew Wilcox <willy@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>
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

Since we only support PMD-sized mappings for THP, getting
a permission fault on a level that results in a mapping
being larger than PAGE_SIZE is a sure indication that we have
already upgraded our mapping to a PMD.

In this case, there is no need to try and parse userspace page
tables, as the fault information already tells us everything.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index db6314b93e99..c036a480ca27 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1088,9 +1088,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * If we are not forced to use page mapping, check if we are
 	 * backed by a THP and thus use block mapping if possible.
 	 */
-	if (vma_pagesize == PAGE_SIZE && !(force_pte || device))
-		vma_pagesize = transparent_hugepage_adjust(kvm, memslot, hva,
-							   &pfn, &fault_ipa);
+	if (vma_pagesize == PAGE_SIZE && !force_pte) {
+		if (fault_status == FSC_PERM && fault_granule > PAGE_SIZE)
+			vma_pagesize = fault_granule;
+		else
+			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
+								   hva, &pfn,
+								   &fault_ipa);
+	}
 
 	if (fault_status != FSC_PERM && !device && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new VM_SHARED VMA */
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
