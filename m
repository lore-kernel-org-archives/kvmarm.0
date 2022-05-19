Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F78FC4332F
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:43:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38AE34B38A;
	Thu, 19 May 2022 09:43:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fYqcB5uURhGF; Thu, 19 May 2022 09:43:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D32D4B382;
	Thu, 19 May 2022 09:43:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31F9D4B105
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:43:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M1ci7JWjpVTo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:43:02 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ECD304B1FD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:43:01 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 64FCC6176B;
 Thu, 19 May 2022 13:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55950C36AE3;
 Thu, 19 May 2022 13:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967780;
 bh=NrldTKw4gy/AB6RKI6l9qxaqANtkJHYc69sbOYfX8H0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=EYcUG+Rd5Iy1H2+7orRU5jbJJSXTyoid9xZEwJUJdhKF1jpfKD/5Hz5oxS8MNYswp
 jO3O3fNqUjpngNKH/am3JaOJYSiU8P9fElf6AGXTTsDcQ76myYidcj8l13D63TYj09
 THvgbGo5pfRtjUlNwZBY5opYZygHg/nPN/tDIlZf1M3nxaz7JY+tGN4rYdDKemJvFg
 kKz1/P0yUUTvdgueD/mQtXumo0jDKve6WvJhn8NyGPa60gliRDP4/48UH3rkr1EvKq
 sIA2Jr6zy/IRkJsXuG0QxmdL9aKJ8bJf59SkzEo5qAqi3blh//oj0lpYrrP7cDCyVt
 xPa003YwbLtOA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 09/89] KVM: arm64: Unify identifiers used to distinguish host
 and hypervisor
Date: Thu, 19 May 2022 14:40:44 +0100
Message-Id: <20220519134204.5379-10-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
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
index 1e78acf9662e..ff86f5bd230f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -26,8 +26,6 @@ struct host_kvm host_kvm;
 
 static struct hyp_pool host_s2_pool;
 
-const u8 pkvm_hyp_id = 1;
-
 static void host_lock_component(void)
 {
 	hyp_spin_lock(&host_kvm.lock);
@@ -380,12 +378,6 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
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
index 7d2b325efb50..311197a223e6 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -197,7 +197,7 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 	state = pkvm_getstate(kvm_pgtable_hyp_pte_prot(pte));
 	switch (state) {
 	case PKVM_PAGE_OWNED:
-		return host_stage2_set_owner_locked(phys, PAGE_SIZE, pkvm_hyp_id);
+		return host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HYP);
 	case PKVM_PAGE_SHARED_OWNED:
 		prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, PKVM_PAGE_SHARED_BORROWED);
 		break;
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
