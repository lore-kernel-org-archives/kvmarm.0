Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72EC4C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 17:05:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28D534B25A;
	Wed,  1 Dec 2021 12:05:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7pVX5avP3HqS; Wed,  1 Dec 2021 12:05:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2B394B14C;
	Wed,  1 Dec 2021 12:05:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA5604B14C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:05:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LkBJPiHZOKRe for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 12:05:06 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 807E44B102
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:05:06 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id
 k8-20020a5d5248000000b001763e7c9ce5so4480364wrc.22
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Dec 2021 09:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Q/onK/NKlbcaX4KhfxRAjbAZkoN+SiOcre92D8hLf9o=;
 b=aul30UamSYt4Ckyai5kRTFmEJuXbGut32orKNWwnc9AayiXqn+TxLOd7v1BpFQ1BkV
 GbCmN3XKpHNrtpSiY4CcZt0+PMOPn9pIlCl5IYKNx/AzLVDxuTWDGyHkUEIHTm4F+7cP
 cfs5tvOShjkY1ghkmPC8ee+EsApXcRTCfMeKKWXX/PXQg+tWXSxLdryzJzl8FhLuN8Hk
 y6S4a8zmzBAclLt3d+Vt4GfxGLQIz3KoJinZGxhw7iraE71AsYv3QtwpJOmgwWU/nFDT
 kk6AcCiotX0F6MR0Ngy6Cts7whuy5SakHBFyAf4/uFCGznBRUGtBNTXqhMkf8eot6Ri6
 r4eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Q/onK/NKlbcaX4KhfxRAjbAZkoN+SiOcre92D8hLf9o=;
 b=m9wYt5oGCw8wr5/5d/5CR05BTIaxFWgLZvh9wYfugeGPJ7pxv6+fNLtmI4JDBeFFJ1
 zu6pNJa5KrruT8eyarODvcuJ/IH8kECRFekoP8oTp+RT2B7pAWPynS8VLwoPzwrQImVc
 +8reDbE4O7HmiTeiyOfee2WktpQdIXqkxkomSGKkeq+4+K67nNRV7fu0t8SXfJm5BZZe
 4DQceVjlpLKVH//2doBhapxa9/+EIb7tnuiFXaK1BwsP4Pm62beDra+s8V+Q0N7hUfuu
 E39ETS/VncX6b0ITQxtwTl/STmBtx409TQhjvqmKwCk7tqbztpic0AL48u/wCDUIGG5e
 iltg==
X-Gm-Message-State: AOAM5329PnZWiVbnnNCqA6kOGHB4QHgbd9kHLpbWg/4fM3iQQThnz9x5
 Nya545SeGHHku7wcZj1lDAW2OZYaZ6aM
X-Google-Smtp-Source: ABdhPJy8c9GuXRQczl6Iol0RhaVFPr754ddoPaIqPgP6tAiFNldL0Xn8h+g/trLyF7Bg2zGWhojVvIGkL+73
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1cab:1a20:2ef1:ddde])
 (user=qperret job=sendgmr) by 2002:a05:600c:500a:: with SMTP id
 n10mr9113665wmr.136.1638378305616; Wed, 01 Dec 2021 09:05:05 -0800 (PST)
Date: Wed,  1 Dec 2021 17:04:07 +0000
In-Reply-To: <20211201170411.1561936-1-qperret@google.com>
Message-Id: <20211201170411.1561936-14-qperret@google.com>
Mime-Version: 1.0
References: <20211201170411.1561936-1-qperret@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 13/15] KVM: arm64: Implement do_unshare() helper for
 unsharing memory
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

Tearing down a previously shared memory region results in the borrower
losing access to the underlying pages and returning them to the "owned"
state in the owner.

Implement a do_unshare() helper, along the same lines as do_share(), to
provide this functionality for the host-to-hyp case.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 115 ++++++++++++++++++++++++++
 1 file changed, 115 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 1282cbd6b9b3..43b25e2de780 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -485,6 +485,16 @@ static int host_request_owned_transition(u64 *completer_addr,
 	return __host_check_page_state_range(addr, size, PKVM_PAGE_OWNED);
 }
 
+static int host_request_unshare(u64 *completer_addr,
+				const struct pkvm_mem_transition *tx)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+	u64 addr = tx->initiator.addr;
+
+	*completer_addr = tx->initiator.host.completer_addr;
+	return __host_check_page_state_range(addr, size, PKVM_PAGE_SHARED_OWNED);
+}
+
 static int host_initiate_share(u64 *completer_addr,
 			       const struct pkvm_mem_transition *tx)
 {
@@ -495,6 +505,16 @@ static int host_initiate_share(u64 *completer_addr,
 	return __host_set_page_state_range(addr, size, PKVM_PAGE_SHARED_OWNED);
 }
 
+static int host_initiate_unshare(u64 *completer_addr,
+				 const struct pkvm_mem_transition *tx)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+	u64 addr = tx->initiator.addr;
+
+	*completer_addr = tx->initiator.host.completer_addr;
+	return __host_set_page_state_range(addr, size, PKVM_PAGE_OWNED);
+}
+
 static enum pkvm_page_state hyp_get_page_state(kvm_pte_t pte)
 {
 	if (!kvm_pte_valid(pte))
@@ -535,6 +555,17 @@ static int hyp_ack_share(u64 addr, const struct pkvm_mem_transition *tx,
 	return __hyp_check_page_state_range(addr, size, PKVM_NOPAGE);
 }
 
+static int hyp_ack_unshare(u64 addr, const struct pkvm_mem_transition *tx)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+
+	if (__hyp_ack_skip_pgtable_check(tx))
+		return 0;
+
+	return __hyp_check_page_state_range(addr, size,
+					    PKVM_PAGE_SHARED_BORROWED);
+}
+
 static int hyp_complete_share(u64 addr, const struct pkvm_mem_transition *tx,
 			      enum kvm_pgtable_prot perms)
 {
@@ -545,6 +576,14 @@ static int hyp_complete_share(u64 addr, const struct pkvm_mem_transition *tx,
 	return pkvm_create_mappings_locked(start, end, prot);
 }
 
+static int hyp_complete_unshare(u64 addr, const struct pkvm_mem_transition *tx)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+	int ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, addr, size);
+
+	return (ret != size) ? -EFAULT : 0;
+}
+
 static int check_share(struct pkvm_mem_share *share)
 {
 	const struct pkvm_mem_transition *tx = &share->tx;
@@ -621,6 +660,82 @@ static int do_share(struct pkvm_mem_share *share)
 	return WARN_ON(__do_share(share));
 }
 
+static int check_unshare(struct pkvm_mem_share *share)
+{
+	const struct pkvm_mem_transition *tx = &share->tx;
+	u64 completer_addr;
+	int ret;
+
+	switch (tx->initiator.id) {
+	case PKVM_ID_HOST:
+		ret = host_request_unshare(&completer_addr, tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (ret)
+		return ret;
+
+	switch (tx->completer.id) {
+	case PKVM_ID_HYP:
+		ret = hyp_ack_unshare(completer_addr, tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int __do_unshare(struct pkvm_mem_share *share)
+{
+	const struct pkvm_mem_transition *tx = &share->tx;
+	u64 completer_addr;
+	int ret;
+
+	switch (tx->initiator.id) {
+	case PKVM_ID_HOST:
+		ret = host_initiate_unshare(&completer_addr, tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (ret)
+		return ret;
+
+	switch (tx->completer.id) {
+	case PKVM_ID_HYP:
+		ret = hyp_complete_unshare(completer_addr, tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
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
+	int ret;
+
+	ret = check_unshare(share);
+	if (ret)
+		return ret;
+
+	return WARN_ON(__do_unshare(share));
+}
+
 int __pkvm_host_share_hyp(u64 pfn)
 {
 	int ret;
-- 
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
