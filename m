Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B99C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:58:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 893B0611AE
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:58:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 893B0611AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D6CB4B092;
	Wed, 13 Oct 2021 11:58:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jQLC4Q+JwmsL; Wed, 13 Oct 2021 11:58:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C347B4B10D;
	Wed, 13 Oct 2021 11:58:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD09F4B092
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:58:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qnNzl+TJkwM2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 11:58:37 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 64BF14B0EC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:58:37 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 j19-20020adfb313000000b00160a9de13b3so2359220wrd.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=v2gd8qWvh4eZ/J6qFrhADUHaOZfVJrXdFAKXh8OoabM=;
 b=aiLbfTOZ81dk7Ubs6Jh81CTkEkNUWHmmr8x/KGdngNpEYBP0Z9GSspCYasDJsokS8B
 25KZrOjXeP6snrT3y16Ol8qeQ19bx/ldAPBQvNXukYoiUW0Ufy5hmjawfyXajTExU78p
 +Jtl2soJvLAYtF6s8fAP35c5qkaYm9mbyzZ42HC5BJyLrpcL4DWXdn2mWAiednc4H+nv
 o9Tnzs9v8p6vKewI9cHEr48DTa5cRelubAkDJ0eH3elTYaKbv8y5b/Mx2J+oogxsNLZZ
 ykwRSxEIBpLGJUfWcrt8p0vSO/pZ7aS2DZHRC+PFmJW6bfsYxHkoLpX00sU0YFYLQaAP
 NLxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=v2gd8qWvh4eZ/J6qFrhADUHaOZfVJrXdFAKXh8OoabM=;
 b=HQH/fVRwSHacr6uy6+JKrRnDQYLBwL3889ZtTWYcV8jGmV10ANb6xdfXothQ1ESnUi
 yBuDpA3fwd6W8HOpiF0yOtVbCDZLVQJM5RW0gVG1SCdw2Ti0Z/9Ci55rrvdWCn5bJm6R
 L3Kkx+BNOQJgjyVNHCdPS7oE58CWYSVu/pHZri36GZrQl+pwf+lD6mTYDcv1KRI0Sz9l
 XovGVioM5v9tPQjal4lxF3eUrQHuTzKKRinVKjKvJa3Ve//eEq+d4A8UWcVeh+ZQE3MO
 FIE4MuTDZC9QfkYJ60LZ4UEPa9M4Pcpzn6heBwUnph2a44pzpIEasDZH7yF3+ERL8LLH
 votg==
X-Gm-Message-State: AOAM533FFxzXkmHtgUrFMdoZCT4VxRQMrizPL+OPdMDSljzAO4JHtVv8
 TpVF2tss+1on4l+Eb45EpLfVCCE6BVc6
X-Google-Smtp-Source: ABdhPJzsn1SgKf860FkEzGm1RZCUUM/Y+aQz9WqD6w1BPfROEP4vWn6pc5yiCYtsPSp0+MddQ+sTTMF4s46R
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:65b5:73d3:1558:b9ae])
 (user=qperret job=sendgmr) by 2002:a7b:c5cc:: with SMTP id
 n12mr69756wmk.43.1634140716553; Wed, 13 Oct 2021 08:58:36 -0700 (PDT)
Date: Wed, 13 Oct 2021 16:58:16 +0100
In-Reply-To: <20211013155831.943476-1-qperret@google.com>
Message-Id: <20211013155831.943476-2-qperret@google.com>
Mime-Version: 1.0
References: <20211013155831.943476-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 01/16] KVM: arm64: Introduce do_share() helper for memory
 sharing between components
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

From: Will Deacon <will@kernel.org>

In preparation for extending memory sharing to include the guest as well
as the hypervisor and the host, introduce a high-level do_share() helper
which allows memory to be shared between these components without
duplication of validity checks.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   5 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 315 ++++++++++++++++++
 2 files changed, 320 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index b58c910babaf..56445586c755 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -24,6 +24,11 @@ enum pkvm_page_state {
 	PKVM_PAGE_OWNED			= 0ULL,
 	PKVM_PAGE_SHARED_OWNED		= KVM_PGTABLE_PROT_SW0,
 	PKVM_PAGE_SHARED_BORROWED	= KVM_PGTABLE_PROT_SW1,
+	__PKVM_PAGE_RESERVED		= KVM_PGTABLE_PROT_SW0 |
+					  KVM_PGTABLE_PROT_SW1,
+
+	/* Meta-states which aren't encoded directly in the PTE's SW bits */
+	PKVM_NOPAGE,
 };
 
 #define PKVM_PAGE_STATE_PROT_MASK	(KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index bacd493a4eac..53e503501044 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -443,3 +443,318 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 	ret = host_stage2_idmap(addr);
 	BUG_ON(ret && ret != -EAGAIN);
 }
+
+/* This corresponds to locking order */
+enum pkvm_component_id {
+	PKVM_ID_HOST,
+	PKVM_ID_HYP,
+};
+
+struct pkvm_mem_transition {
+	u64				nr_pages;
+
+	struct {
+		enum pkvm_component_id	id;
+		u64			addr;
+
+		union {
+			struct {
+				u64	completer_addr;
+			} host;
+		};
+	} initiator;
+
+	struct {
+		enum pkvm_component_id	id;
+	} completer;
+};
+
+struct pkvm_mem_share {
+	struct pkvm_mem_transition	tx;
+	enum kvm_pgtable_prot		prot;
+};
+
+struct pkvm_page_req {
+	struct {
+		enum pkvm_page_state	state;
+		u64			addr;
+	} initiator;
+
+	struct {
+		u64			addr;
+	} completer;
+
+	phys_addr_t			phys;
+};
+
+struct pkvm_page_share_ack {
+	struct {
+		enum pkvm_page_state	state;
+		phys_addr_t		phys;
+		enum kvm_pgtable_prot	prot;
+	} completer;
+};
+
+static void host_lock_component(void)
+{
+	hyp_spin_lock(&host_kvm.lock);
+}
+
+static void host_unlock_component(void)
+{
+	hyp_spin_unlock(&host_kvm.lock);
+}
+
+static void hyp_lock_component(void)
+{
+	hyp_spin_lock(&pkvm_pgd_lock);
+}
+
+static void hyp_unlock_component(void)
+{
+	hyp_spin_unlock(&pkvm_pgd_lock);
+}
+
+static int host_request_share(struct pkvm_page_req *req,
+			      struct pkvm_mem_transition *tx,
+			      u64 idx)
+{
+	u64 offset = idx * PAGE_SIZE;
+	enum kvm_pgtable_prot prot;
+	u64 host_addr;
+	kvm_pte_t pte;
+	int err;
+
+	hyp_assert_lock_held(&host_kvm.lock);
+
+	host_addr = tx->initiator.addr + offset;
+	err = kvm_pgtable_get_leaf(&host_kvm.pgt, host_addr, &pte, NULL);
+	if (err)
+		return err;
+
+	if (!kvm_pte_valid(pte) && pte)
+		return -EPERM;
+
+	prot = kvm_pgtable_stage2_pte_prot(pte);
+	*req = (struct pkvm_page_req) {
+		.initiator	= {
+			.state	= pkvm_getstate(prot),
+			.addr	= host_addr,
+		},
+		.completer	= {
+			.addr	= tx->initiator.host.completer_addr + offset,
+		},
+		.phys		= host_addr,
+	};
+
+	return 0;
+}
+
+/*
+ * Populate the page-sharing request (@req) based on the share transition
+ * information from the initiator and its current page state.
+ */
+static int request_share(struct pkvm_page_req *req,
+			 struct pkvm_mem_share *share,
+			 u64 idx)
+{
+	struct pkvm_mem_transition *tx = &share->tx;
+
+	switch (tx->initiator.id) {
+	case PKVM_ID_HOST:
+		return host_request_share(req, tx, idx);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int hyp_ack_share(struct pkvm_page_share_ack *ack,
+			 struct pkvm_page_req *req,
+			 enum kvm_pgtable_prot perms)
+{
+	enum pkvm_page_state state = PKVM_NOPAGE;
+	enum kvm_pgtable_prot prot = 0;
+	phys_addr_t phys = 0;
+	kvm_pte_t pte;
+	u64 hyp_addr;
+	int err;
+
+	hyp_assert_lock_held(&pkvm_pgd_lock);
+
+	if (perms != PAGE_HYP)
+		return -EPERM;
+
+	hyp_addr = req->completer.addr;
+	err = kvm_pgtable_get_leaf(&pkvm_pgtable, hyp_addr, &pte, NULL);
+	if (err)
+		return err;
+
+	if (kvm_pte_valid(pte)) {
+		state	= pkvm_getstate(kvm_pgtable_hyp_pte_prot(pte));
+		phys	= kvm_pte_to_phys(pte);
+		prot	= kvm_pgtable_hyp_pte_prot(pte) & KVM_PGTABLE_PROT_RWX;
+	}
+
+	*ack = (struct pkvm_page_share_ack) {
+		.completer	= {
+			.state	= state,
+			.phys	= phys,
+			.prot	= prot,
+		},
+	};
+
+	return 0;
+}
+
+/*
+ * Populate the page-sharing acknowledgment (@ack) based on the sharing request
+ * from the initiator and the current page state in the completer.
+ */
+static int ack_share(struct pkvm_page_share_ack *ack,
+		     struct pkvm_page_req *req,
+		     struct pkvm_mem_share *share)
+{
+	struct pkvm_mem_transition *tx = &share->tx;
+
+	switch (tx->completer.id) {
+	case PKVM_ID_HYP:
+		return hyp_ack_share(ack, req, share->prot);
+	default:
+		return -EINVAL;
+	}
+}
+
+/*
+ * Check that the page states in the initiator and the completer are compatible
+ * for the requested page-sharing operation to go ahead.
+ */
+static int check_share(struct pkvm_page_req *req,
+		       struct pkvm_page_share_ack *ack,
+		       struct pkvm_mem_share *share)
+{
+	if (!addr_is_memory(req->phys))
+		return -EINVAL;
+
+	if (req->initiator.state == PKVM_PAGE_OWNED &&
+	    ack->completer.state == PKVM_NOPAGE) {
+		return 0;
+	}
+
+	if (req->initiator.state != PKVM_PAGE_SHARED_OWNED)
+		return -EPERM;
+
+	if (ack->completer.state != PKVM_PAGE_SHARED_BORROWED)
+		return -EPERM;
+
+	if (ack->completer.phys != req->phys)
+		return -EPERM;
+
+	if (ack->completer.prot != share->prot)
+		return -EPERM;
+
+	return 0;
+}
+
+static int host_initiate_share(struct pkvm_page_req *req)
+{
+	enum kvm_pgtable_prot prot;
+
+	prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, PKVM_PAGE_SHARED_OWNED);
+	return host_stage2_idmap_locked(req->initiator.addr, PAGE_SIZE, prot);
+}
+
+/* Update the initiator's page-table for the page-sharing request */
+static int initiate_share(struct pkvm_page_req *req,
+			  struct pkvm_mem_share *share)
+{
+	struct pkvm_mem_transition *tx = &share->tx;
+
+	switch (tx->initiator.id) {
+	case PKVM_ID_HOST:
+		return host_initiate_share(req);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int hyp_complete_share(struct pkvm_page_req *req,
+			      enum kvm_pgtable_prot perms)
+{
+	void *start = (void *)req->completer.addr, *end = start + PAGE_SIZE;
+	enum kvm_pgtable_prot prot;
+
+	prot = pkvm_mkstate(perms, PKVM_PAGE_SHARED_BORROWED);
+	return pkvm_create_mappings_locked(start, end, prot);
+}
+
+/* Update the completer's page-table for the page-sharing request */
+static int complete_share(struct pkvm_page_req *req,
+			  struct pkvm_mem_share *share)
+{
+	struct pkvm_mem_transition *tx = &share->tx;
+
+	switch (tx->completer.id) {
+	case PKVM_ID_HYP:
+		return hyp_complete_share(req, share->prot);
+	default:
+		return -EINVAL;
+	}
+}
+
+/*
+ * do_share():
+ *
+ * The page owner grants access to another component with a given set
+ * of permissions.
+ *
+ * Initiator: OWNED	=> SHARED_OWNED
+ * Completer: NOPAGE	=> SHARED_BORROWED
+ *
+ * Note that we permit the same share operation to be repeated from the
+ * host to the hypervisor, as this removes the need for excessive
+ * book-keeping of shared KVM data structures at EL1.
+ */
+static int do_share(struct pkvm_mem_share *share)
+{
+	struct pkvm_page_req req;
+	int ret = 0;
+	u64 idx;
+
+	for (idx = 0; idx < share->tx.nr_pages; ++idx) {
+		struct pkvm_page_share_ack ack;
+
+		ret = request_share(&req, share, idx);
+		if (ret)
+			goto out;
+
+		ret = ack_share(&ack, &req, share);
+		if (ret)
+			goto out;
+
+		ret = check_share(&req, &ack, share);
+		if (ret)
+			goto out;
+	}
+
+	for (idx = 0; idx < share->tx.nr_pages; ++idx) {
+		ret = request_share(&req, share, idx);
+		if (ret)
+			break;
+
+		/* Allow double-sharing by skipping over the page */
+		if (req.initiator.state == PKVM_PAGE_SHARED_OWNED)
+			continue;
+
+		ret = initiate_share(&req, share);
+		if (ret)
+			break;
+
+		ret = complete_share(&req, share);
+		if (ret)
+			break;
+	}
+
+	WARN_ON(ret);
+out:
+	return ret;
+}
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
