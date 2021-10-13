Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9C1C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:59:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7FC18611AD
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:59:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7FC18611AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 325C84B0FB;
	Wed, 13 Oct 2021 11:59:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g5KiLr9ZXIjt; Wed, 13 Oct 2021 11:59:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D42264B132;
	Wed, 13 Oct 2021 11:59:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 963744A531
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:59:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X-gtA8lGwUlb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 11:59:10 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9B6974A5A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:59:09 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 10-20020a5d47aa000000b001610cbda93dso2310324wrb.23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=jUMxCe3iQSBSJfPoTwqGidXgGNlM0bDyqNQH45PKm9Y=;
 b=CxAgTNfkMVoo/RZUREDqrhDj64DfsmkHXTQ2HN3iUTz4h/Lelio1RTdCwqgDDJwOc2
 CNDWLBR/MtpWHrE5lUVvJrbYbPewemJg5kLKt6YlEEpjtThnwR7LyscUzaCfdO3ij5xv
 6VhDekgWir7IZZsHshYkvkCCssKuDKeUXkCvpM5chObuWvWpYqOl8CnWNdOizEvZ3iQl
 DITd/DonpqAO5uDMy/0H6kI0MalnrqreSOZsLxbwhgVUsMGfGwsch9C1e/sBmnh5JO3G
 uJQ29zHBKjsXkMRmZe/P5nzDxaKhvBu1xLRUvSm49gxoYB1ukqpj2qOlNTSHbGL3syL2
 bm8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=jUMxCe3iQSBSJfPoTwqGidXgGNlM0bDyqNQH45PKm9Y=;
 b=ypGo46xHgwefhbYXqiGBWWIvOUrvS4ooWq98mFyVaLTqQHJoX6YNpZL8TvaVUWwTbk
 B/wuRq6mZcZTdIbWwopOthc9xMZ39FG3eYv6f/FKPyel0QuXbgh9t3yS4uDq2310WaUi
 EsGuJUjwVTylXNa/GmSysCuCDpEg7VQ6LS9Ci1QEMDVaVCjtjHX8cRQb1nLQr4DowMsE
 DplWXlrLmZMDUsKPqayQFHtr2i4QHJLDupA/jozsqTCwlwzbEt5TJA6EB6/VGtgF5yep
 fdC5ja2UIpx5JLJ8QL9eREeDrNHYohHPeQwN8vkkUQAHZw4KOKpks5biibi8eZIPwXTI
 IwSA==
X-Gm-Message-State: AOAM532FtSp4go6DTAifKU9xyCitbtgq2AHxEo34i+pSTw+SNjhyTfIu
 0ezlt1nOiw+yDt+SDg5Jp1hK20roJqqL
X-Google-Smtp-Source: ABdhPJyvQxc0b2FqQ/DuPVB64HYbLHR9vI9grqwIbQ8mH0Sw/KNQLH0z95tp7Cv/xFYiDERs2LeVdh2X8e3V
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:65b5:73d3:1558:b9ae])
 (user=qperret job=sendgmr) by 2002:a7b:c766:: with SMTP id
 x6mr13644451wmk.15.1634140748699; Wed, 13 Oct 2021 08:59:08 -0700 (PDT)
Date: Wed, 13 Oct 2021 16:58:30 +0100
In-Reply-To: <20211013155831.943476-1-qperret@google.com>
Message-Id: <20211013155831.943476-16-qperret@google.com>
Mime-Version: 1.0
References: <20211013155831.943476-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 15/16] KVM: arm64: pkvm: Introduce an unshare hypercall
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, David Brazdil <dbrazdil@google.com>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

Introduce an unshare hypercall which can be used to unmap things from
the hypervisor stage-1 in nVHE protected mode. This will be useful to
update the EL2 ownership state of pages during guest teardown, and
avoids keeping dangling mappings to unreferenced portions of memory.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |   1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   9 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 159 ++++++++++++++++++
 4 files changed, 170 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index e86045ac43ba..98ba11b7b192 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -64,6 +64,7 @@
 #define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
 #define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
 #define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			20
+#define __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp		21
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 9c02abe92e0a..88e1607a94fe 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -55,6 +55,7 @@ extern const u8 pkvm_hyp_id;
 
 int __pkvm_prot_finalize(void);
 int __pkvm_host_share_hyp(u64 pfn, u64 nr_pages);
+int __pkvm_host_unshare_hyp(u64 pfn, u64 nr_pages);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f78bec2b9dd4..7070ed9ead9b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -148,6 +148,14 @@ static void handle___pkvm_host_share_hyp(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_host_share_hyp(pfn, nr_pages);
 }
 
+static void handle___pkvm_host_unshare_hyp(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, pfn, host_ctxt, 1);
+	DECLARE_REG(u64, nr_pages, host_ctxt, 2);
+
+	cpu_reg(host_ctxt, 1) = __pkvm_host_unshare_hyp(pfn, nr_pages);
+}
+
 static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
@@ -184,6 +192,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_init),
 	HANDLE_FUNC(__pkvm_cpu_set_vector),
 	HANDLE_FUNC(__pkvm_host_share_hyp),
+	HANDLE_FUNC(__pkvm_host_unshare_hyp),
 	HANDLE_FUNC(__pkvm_create_private_mapping),
 	HANDLE_FUNC(__pkvm_prot_finalize),
 };
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index cad76bc68e53..3b724ab62e9f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -740,3 +740,162 @@ int __pkvm_host_share_hyp(u64 pfn, u64 nr_pages)
 
 	return ret;
 }
+
+static int host_initiate_unshare(struct pkvm_page_req *req)
+{
+	struct hyp_page *page = hyp_phys_to_page(req->phys);
+	enum kvm_pgtable_prot prot;
+
+	if (page->refcount > 1)
+		return 0;
+
+	prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, PKVM_PAGE_OWNED);
+	return host_stage2_idmap_locked(req->initiator.addr, PAGE_SIZE, prot);
+}
+
+static int initiate_unshare(struct pkvm_page_req *req,
+			    struct pkvm_mem_share *share)
+{
+	struct pkvm_mem_transition *tx = &share->tx;
+
+	switch (tx->initiator.id) {
+	case PKVM_ID_HOST:
+		return host_initiate_unshare(req);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int hyp_complete_unshare(struct pkvm_page_req *req)
+{
+	struct hyp_page *page = hyp_phys_to_page(req->phys);
+	void *addr = (void *)req->completer.addr;
+	int ret = 0;
+
+	if (hyp_page_ref_dec_and_test(page)) {
+		ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)addr, PAGE_SIZE);
+		ret = (ret == PAGE_SIZE) ? 0 : -EINVAL;
+	}
+
+	return ret;
+}
+
+static int complete_unshare(struct pkvm_page_req *req,
+			    struct pkvm_mem_share *share)
+{
+	struct pkvm_mem_transition *tx = &share->tx;
+
+	switch (tx->completer.id) {
+	case PKVM_ID_HYP:
+		return hyp_complete_unshare(req);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int check_unshare(struct pkvm_page_req *req,
+			 struct pkvm_page_share_ack *ack,
+			 struct pkvm_mem_share *share)
+{
+	struct pkvm_mem_transition *tx = &share->tx;
+
+	if (!addr_is_memory(req->phys))
+		return -EINVAL;
+
+	switch (tx->completer.id) {
+	case PKVM_ID_HYP:
+		return hyp_check_incoming_share(req, ack, tx->initiator.id,
+						share->prot);
+	default:
+		return -EPERM;
+	}
+}
+
+/*
+ * do_unshare():
+ *
+ * The page owner revokes access from another component for a range of
+ * pages which were previously shared using do_share().
+ *
+ * Initiator: SHARED_OWNED	=> OWNED
+ * Completer: SHARED_BORROWED	=> NOPAGE
+ */
+static int do_unshare(struct pkvm_mem_share *share)
+{
+	struct pkvm_page_req req;
+	int ret = 0;
+	u64 idx;
+
+	for (idx = 0; idx < share->tx.nr_pages; ++idx) {
+		struct pkvm_page_share_ack ack;
+
+		/*
+		 * Use the request_share() and ack_share() from the normal share
+		 * path as they implement all the checks we need here. But
+		 * check_unshare() needs to differ -- PKVM_PAGE_OWNED is illegal
+		 * for the initiator.
+		 */
+		ret = request_share(&req, share, idx);
+		if (ret)
+			goto out;
+
+		ret = ack_share(&ack, &req, share);
+		if (ret)
+			goto out;
+
+		ret = check_unshare(&req, &ack, share);
+		if (ret)
+			goto out;
+	}
+
+	for (idx = 0; idx < share->tx.nr_pages; ++idx) {
+		ret = request_share(&req, share, idx);
+		if (ret)
+			break;
+
+		ret = initiate_unshare(&req, share);
+		if (ret)
+			break;
+
+		ret = complete_unshare(&req, share);
+		if (ret)
+			break;
+	}
+
+	WARN_ON(ret);
+out:
+	return ret;
+}
+
+int __pkvm_host_unshare_hyp(u64 pfn, u64 nr_pages)
+{
+	int ret;
+	u64 host_addr = hyp_pfn_to_phys(pfn);
+	u64 hyp_addr = (u64)__hyp_va(host_addr);
+	struct pkvm_mem_share share = {
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
+		.prot	= PAGE_HYP,
+	};
+
+	host_lock_component();
+	hyp_lock_component();
+
+	ret = do_unshare(&share);
+
+	hyp_unlock_component();
+	host_unlock_component();
+
+	return ret;
+}
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
