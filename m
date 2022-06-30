Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61040C43334
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jun 2022 13:58:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1794A403AD;
	Thu, 30 Jun 2022 09:58:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p5Pfyg+ry8S4; Thu, 30 Jun 2022 09:58:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D51C64B274;
	Thu, 30 Jun 2022 09:58:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E49540712
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:58:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PgX-LQX6B9T4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2022 09:58:26 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 16B4649AFD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:58:26 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 25349B82AEE;
 Thu, 30 Jun 2022 13:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA00C341CC;
 Thu, 30 Jun 2022 13:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1656597503;
 bh=4jvhAvWd7DlxQP1ElFGB37Cbym7UjvcFAUmt5hM3j/s=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=nwvIw3DhaBmEdok9KfrzFFendkiyXLa4HQDJEFlcDJYBmElIPxFkgiusd4wPocVBL
 /HWGQGylf7UCCp5WOZoq+ZY0BuWydOEyXccQPWTCTrhuAF9cbjc0TZIVKha2VbNXUT
 ivm8vZZ+GXRk7JFTLYxQO1pOdtVXut8QCC8i6/cGNI1VicATQsXeuYucShRG7UUZGw
 QXmY2w0vxTSdpr6F5fhoMmKTJT+G9JerR8jDiT+YWuF5RPBEncHw40NAy1aePrKXXL
 zUYOKDuTVPfxiutT2tFlG0izrx9r8cTwotpwk52ok1uRf2bHKnRjsEEfKfIELFh+I+
 rlOJmZ7kITrEg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 07/24] KVM: arm64: Implement do_donate() helper for
 donating memory
Date: Thu, 30 Jun 2022 14:57:30 +0100
Message-Id: <20220630135747.26983-8-will@kernel.org>
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

From: Quentin Perret <qperret@google.com>

Transferring ownership information of a memory region from one component
to another can be achieved using a "donate" operation, which results
in the previous owner losing access to the underlying pages entirely.

Implement a do_donate() helper, along the same lines as do_{un,}share,
and provide this functionality for the host-{to,from}-hyp cases as this
will later be used to donate/reclaim memory pages to store VM metadata
at EL2.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 239 ++++++++++++++++++
 2 files changed, 241 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index f5705a1e972f..c87b19b2d468 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -60,6 +60,8 @@ enum pkvm_component_id {
 int __pkvm_prot_finalize(void);
 int __pkvm_host_share_hyp(u64 pfn);
 int __pkvm_host_unshare_hyp(u64 pfn);
+int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
+int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 10390b8dc841..f475d554c9fd 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -395,6 +395,9 @@ struct pkvm_mem_transition {
 				/* Address in the completer's address space */
 				u64	completer_addr;
 			} host;
+			struct {
+				u64	completer_addr;
+			} hyp;
 		};
 	} initiator;
 
@@ -408,6 +411,10 @@ struct pkvm_mem_share {
 	const enum kvm_pgtable_prot		completer_prot;
 };
 
+struct pkvm_mem_donation {
+	const struct pkvm_mem_transition	tx;
+};
+
 struct check_walk_data {
 	enum pkvm_page_state	desired;
 	enum pkvm_page_state	(*get_page_state)(kvm_pte_t pte);
@@ -507,6 +514,46 @@ static int host_initiate_unshare(u64 *completer_addr,
 	return __host_set_page_state_range(addr, size, PKVM_PAGE_OWNED);
 }
 
+static int host_initiate_donation(u64 *completer_addr,
+				  const struct pkvm_mem_transition *tx)
+{
+	u8 owner_id = tx->completer.id;
+	u64 size = tx->nr_pages * PAGE_SIZE;
+
+	*completer_addr = tx->initiator.host.completer_addr;
+	return host_stage2_set_owner_locked(tx->initiator.addr, size, owner_id);
+}
+
+static bool __host_ack_skip_pgtable_check(const struct pkvm_mem_transition *tx)
+{
+	return !(IS_ENABLED(CONFIG_NVHE_EL2_DEBUG) ||
+		 tx->initiator.id != PKVM_ID_HYP);
+}
+
+static int __host_ack_transition(u64 addr, const struct pkvm_mem_transition *tx,
+				 enum pkvm_page_state state)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+
+	if (__host_ack_skip_pgtable_check(tx))
+		return 0;
+
+	return __host_check_page_state_range(addr, size, state);
+}
+
+static int host_ack_donation(u64 addr, const struct pkvm_mem_transition *tx)
+{
+	return __host_ack_transition(addr, tx, PKVM_NOPAGE);
+}
+
+static int host_complete_donation(u64 addr, const struct pkvm_mem_transition *tx)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+	u8 host_id = tx->completer.id;
+
+	return host_stage2_set_owner_locked(addr, size, host_id);
+}
+
 static enum pkvm_page_state hyp_get_page_state(kvm_pte_t pte)
 {
 	if (!kvm_pte_valid(pte))
@@ -527,6 +574,27 @@ static int __hyp_check_page_state_range(u64 addr, u64 size,
 	return check_page_state_range(&pkvm_pgtable, addr, size, &d);
 }
 
+static int hyp_request_donation(u64 *completer_addr,
+				const struct pkvm_mem_transition *tx)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+	u64 addr = tx->initiator.addr;
+
+	*completer_addr = tx->initiator.hyp.completer_addr;
+	return __hyp_check_page_state_range(addr, size, PKVM_PAGE_OWNED);
+}
+
+static int hyp_initiate_donation(u64 *completer_addr,
+				 const struct pkvm_mem_transition *tx)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+	int ret;
+
+	*completer_addr = tx->initiator.hyp.completer_addr;
+	ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, tx->initiator.addr, size);
+	return (ret != size) ? -EFAULT : 0;
+}
+
 static bool __hyp_ack_skip_pgtable_check(const struct pkvm_mem_transition *tx)
 {
 	return !(IS_ENABLED(CONFIG_NVHE_EL2_DEBUG) ||
@@ -558,6 +626,16 @@ static int hyp_ack_unshare(u64 addr, const struct pkvm_mem_transition *tx)
 					    PKVM_PAGE_SHARED_BORROWED);
 }
 
+static int hyp_ack_donation(u64 addr, const struct pkvm_mem_transition *tx)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+
+	if (__hyp_ack_skip_pgtable_check(tx))
+		return 0;
+
+	return __hyp_check_page_state_range(addr, size, PKVM_NOPAGE);
+}
+
 static int hyp_complete_share(u64 addr, const struct pkvm_mem_transition *tx,
 			      enum kvm_pgtable_prot perms)
 {
@@ -576,6 +654,15 @@ static int hyp_complete_unshare(u64 addr, const struct pkvm_mem_transition *tx)
 	return (ret != size) ? -EFAULT : 0;
 }
 
+static int hyp_complete_donation(u64 addr,
+				 const struct pkvm_mem_transition *tx)
+{
+	void *start = (void *)addr, *end = start + (tx->nr_pages * PAGE_SIZE);
+	enum kvm_pgtable_prot prot = pkvm_mkstate(PAGE_HYP, PKVM_PAGE_OWNED);
+
+	return pkvm_create_mappings_locked(start, end, prot);
+}
+
 static int check_share(struct pkvm_mem_share *share)
 {
 	const struct pkvm_mem_transition *tx = &share->tx;
@@ -728,6 +815,94 @@ static int do_unshare(struct pkvm_mem_share *share)
 	return WARN_ON(__do_unshare(share));
 }
 
+static int check_donation(struct pkvm_mem_donation *donation)
+{
+	const struct pkvm_mem_transition *tx = &donation->tx;
+	u64 completer_addr;
+	int ret;
+
+	switch (tx->initiator.id) {
+	case PKVM_ID_HOST:
+		ret = host_request_owned_transition(&completer_addr, tx);
+		break;
+	case PKVM_ID_HYP:
+		ret = hyp_request_donation(&completer_addr, tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (ret)
+		return ret;
+
+	switch (tx->completer.id){
+	case PKVM_ID_HOST:
+		ret = host_ack_donation(completer_addr, tx);
+		break;
+	case PKVM_ID_HYP:
+		ret = hyp_ack_donation(completer_addr, tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int __do_donate(struct pkvm_mem_donation *donation)
+{
+	const struct pkvm_mem_transition *tx = &donation->tx;
+	u64 completer_addr;
+	int ret;
+
+	switch (tx->initiator.id) {
+	case PKVM_ID_HOST:
+		ret = host_initiate_donation(&completer_addr, tx);
+		break;
+	case PKVM_ID_HYP:
+		ret = hyp_initiate_donation(&completer_addr, tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (ret)
+		return ret;
+
+	switch (tx->completer.id){
+	case PKVM_ID_HOST:
+		ret = host_complete_donation(completer_addr, tx);
+		break;
+	case PKVM_ID_HYP:
+		ret = hyp_complete_donation(completer_addr, tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+/*
+ * do_donate():
+ *
+ * The page owner transfers ownership to another component, losing access
+ * as a consequence.
+ *
+ * Initiator: OWNED	=> NOPAGE
+ * Completer: NOPAGE	=> OWNED
+ */
+static int do_donate(struct pkvm_mem_donation *donation)
+{
+	int ret;
+
+	ret = check_donation(donation);
+	if (ret)
+		return ret;
+
+	return WARN_ON(__do_donate(donation));
+}
+
 int __pkvm_host_share_hyp(u64 pfn)
 {
 	int ret;
@@ -793,3 +968,67 @@ int __pkvm_host_unshare_hyp(u64 pfn)
 
 	return ret;
 }
+
+int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
+{
+	int ret;
+	u64 host_addr = hyp_pfn_to_phys(pfn);
+	u64 hyp_addr = (u64)__hyp_va(host_addr);
+	struct pkvm_mem_donation donation = {
+		.tx	= {
+			.nr_pages	= nr_pages,
+			.initiator	= {
+				.id	= PKVM_ID_HOST,
+				.addr	= host_addr,
+				.host	= {
+					.completer_addr = hyp_addr,
+				},
+			},
+			.completer	= {
+				.id	= PKVM_ID_HYP,
+			},
+		},
+	};
+
+	host_lock_component();
+	hyp_lock_component();
+
+	ret = do_donate(&donation);
+
+	hyp_unlock_component();
+	host_unlock_component();
+
+	return ret;
+}
+
+int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
+{
+	int ret;
+	u64 host_addr = hyp_pfn_to_phys(pfn);
+	u64 hyp_addr = (u64)__hyp_va(host_addr);
+	struct pkvm_mem_donation donation = {
+		.tx	= {
+			.nr_pages	= nr_pages,
+			.initiator	= {
+				.id	= PKVM_ID_HYP,
+				.addr	= hyp_addr,
+				.hyp	= {
+					.completer_addr = host_addr,
+				},
+			},
+			.completer	= {
+				.id	= PKVM_ID_HOST,
+			},
+		},
+	};
+
+	host_lock_component();
+	hyp_lock_component();
+
+	ret = do_donate(&donation);
+
+	hyp_unlock_component();
+	host_unlock_component();
+
+	return ret;
+}
-- 
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
