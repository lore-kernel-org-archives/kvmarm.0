Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32569C43334
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jun 2022 13:58:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4767411BD;
	Thu, 30 Jun 2022 09:58:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gwc1muEhqMvE; Thu, 30 Jun 2022 09:58:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B79EE4B0C2;
	Thu, 30 Jun 2022 09:58:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95B72411BD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:58:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cpR-UOBk+QyE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2022 09:58:22 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3DF5D4B4A2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:58:22 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 72687B82AF3;
 Thu, 30 Jun 2022 13:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5287C34115;
 Thu, 30 Jun 2022 13:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1656597500;
 bh=XvT/NCRTnrJVqvVlVy8yC1jsjzB/S3LNKS9+VwFbCGM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=sd+BqIIGQ2bJHAOVyxIMzoXgTEavLc4O9w5bkMyu34ru44TI+oll/hr6TDhenZy6b
 5/ZKBL8MANJxBe930B21QriautEF7KzHBzF+dcmA1OqOvUjo1Rq9+dfP0N1M/tPNKZ
 WceV0ZlIgZX75lYEB9iGzOKob/J2gV5OMh0PFGh54DqltXoLuuk7Oidnq7bL0V/Z+j
 4qdPAtCtarkC176cVgL2k2DG5ul1VAaDydxMWeEYEoqsRAyR56u5Fx1QcvvORKORUJ
 ciWnLHr/wcHuZ3GgJL+m8ati3Qr6wEOuZRmL/hqakRZ2CRv+d+TbqHLzH0FK2WY3/G
 7ZxK8xa22GAww==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 06/24] KVM: arm64: Unify identifiers used to distinguish
 host and hypervisor
Date: Thu, 30 Jun 2022 14:57:29 +0100
Message-Id: <20220630135747.26983-7-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220630135747.26983-1-will@kernel.org>
References: <20220630135747.26983-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

The 'pkvm_component_id' enum type provides constants to refer to the
host and the hypervisor, yet this information is duplicated by the
'pkvm_hyp_id' constant.

Remove the definition of 'pkvm_hyp_id' and move the 'pkvm_component_id'
type definition to 'mem_protect.h' so that it can be used outside of
the memory protection code.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 6 +++++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 8 --------
 arch/arm64/kvm/hyp/nvhe/setup.c               | 2 +-
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 80e99836eac7..f5705a1e972f 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -51,7 +51,11 @@ struct host_kvm {
 };
 extern struct host_kvm host_kvm;
 
-extern const u8 pkvm_hyp_id;
+/* This corresponds to page-table locking order */
+enum pkvm_component_id {
+	PKVM_ID_HOST,
+	PKVM_ID_HYP,
+};
 
 int __pkvm_prot_finalize(void);
 int __pkvm_host_share_hyp(u64 pfn);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 78edf077fa3b..10390b8dc841 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -26,8 +26,6 @@ struct host_kvm host_kvm;
 
 static struct hyp_pool host_s2_pool;
 
-const u8 pkvm_hyp_id = 1;
-
 static void host_lock_component(void)
 {
 	hyp_spin_lock(&host_kvm.lock);
@@ -384,12 +382,6 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 	BUG_ON(ret && ret != -EAGAIN);
 }
 
-/* This corresponds to locking order */
-enum pkvm_component_id {
-	PKVM_ID_HOST,
-	PKVM_ID_HYP,
-};
-
 struct pkvm_mem_transition {
 	u64				nr_pages;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 8f2726d7e201..0312c9c74a5a 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -212,7 +212,7 @@ static int fix_host_ownership_walker(u64 addr, u64 end, u32 level,
 	state = pkvm_getstate(kvm_pgtable_hyp_pte_prot(pte));
 	switch (state) {
 	case PKVM_PAGE_OWNED:
-		return host_stage2_set_owner_locked(phys, PAGE_SIZE, pkvm_hyp_id);
+		return host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HYP);
 	case PKVM_PAGE_SHARED_OWNED:
 		prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, PKVM_PAGE_SHARED_BORROWED);
 		break;
-- 
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
