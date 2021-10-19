Return-Path: <SRS0=DvdR=PH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5EFC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B27C96135E
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B27C96135E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 662CD4B1A3;
	Tue, 19 Oct 2021 08:13:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uVrWbBaPwCRl; Tue, 19 Oct 2021 08:13:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E8ED4B0F7;
	Tue, 19 Oct 2021 08:13:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2710F4B093
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FKB4uOmIvNyH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Oct 2021 08:13:39 -0400 (EDT)
Received: from mail-lj1-f202.google.com (mail-lj1-f202.google.com
 [209.85.208.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78DC74B0EF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:38 -0400 (EDT)
Received: by mail-lj1-f202.google.com with SMTP id
 n11-20020a2ebd0b000000b001f9ebdc2b7aso821945ljq.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 05:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ISeivE4VJePhwCDFvsBtzOVIerKBvyMpPq/U4suJ8Dg=;
 b=pMTyZ0Vbl+u7Dlf64iUAHAL8iII5oExKlGMnTMHZaH1N3KOh6pszIEURsP71VOA8zm
 YmAfLbs73BpmIWiQFsAwuQdZch7d1aBX0VE1dqPVlo4MR+Iv3SEIvK1dzqA44YUBqokQ
 3BWhGEojgqF2KRv1G62YRc39Vn8Nnjta2ATq8LApIpEt7DGix0abtEW9pGr56bx76kdj
 22z6U+fFymB5GMOz4WZX6L7B8vnwJ+yGDZM1gxOHNZEdOyXICg/04hJWqSYDUUhm5VGZ
 8XPgn1dhN12ntFAgc27i+8EKZxW4j4Rv26/Vjwmr2QvI0pNoKwfj6Pef3gBLMRK7blQh
 duHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ISeivE4VJePhwCDFvsBtzOVIerKBvyMpPq/U4suJ8Dg=;
 b=bl8ztmkjLlxMeDljdLVxx4a62wiHv/jh5hVLdq/jS6MOjeaqkbsOOu44a/V3TS+nst
 FQRpZ6peFN6BzM5ZH+yesTuyOmnEXzWbWZyuHcvZm/e7Z3t2Pmk8prkjgaTaPRsiIuWD
 iriMGCdVYWrUUOZQquJjavEFZzJL8G1GF0xDf5n0gR1nhLTe0sQndxEj4BTc2RDlNE3/
 wYuzjmlqplnJZRuB2yKqprbDOPD8pSy4muEsZyOQWYSLqWtQ5pi/rvic5gsNkLF8Fb8l
 IXsdo0ckwBWYmm40QRkK1BBvymmVHhGgYwv95i6Y/Y3Q3kCz00S8EMdQcLIs45zKa6Rj
 pPCA==
X-Gm-Message-State: AOAM533uAw4kFTT+IT6dHMy+STpFN6ZIgelGSltlFjoWLR5/iBNtkF39
 QEvOd9lFlxofkuVZmgmwCDNdIgHQWgVv
X-Google-Smtp-Source: ABdhPJwgKkmhxiB5XvxU66pG49kdREnEBCBJUkS8jWIoTxJjPaFPdF/auvzHlo/liyhgODAIlIOug/KJN2Yd
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:59ca:401f:83a8:de6d])
 (user=qperret job=sendgmr) by 2002:a2e:7816:: with SMTP id
 t22mr6884979ljc.133.1634645617143; Tue, 19 Oct 2021 05:13:37 -0700 (PDT)
Date: Tue, 19 Oct 2021 13:13:02 +0100
In-Reply-To: <20211019121304.2732332-1-qperret@google.com>
Message-Id: <20211019121304.2732332-14-qperret@google.com>
Mime-Version: 1.0
References: <20211019121304.2732332-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2 13/15] KVM: arm64: Implement do_unshare() helper for
 unsharing memory
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, 
 David Brazdil <dbrazdil@google.com>, Andrew Walbran <qwandor@google.com>
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
index ab1732c38b3b..205616c9f107 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -474,6 +474,16 @@ static int host_request_owned_transition(u64 *completer_addr,
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
@@ -484,6 +494,16 @@ static int host_initiate_share(u64 *completer_addr,
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
@@ -524,6 +544,17 @@ static int hyp_ack_share(u64 addr, const struct pkvm_mem_transition *tx,
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
@@ -534,6 +565,14 @@ static int hyp_complete_share(u64 addr, const struct pkvm_mem_transition *tx,
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
@@ -610,6 +649,82 @@ static int do_share(struct pkvm_mem_share *share)
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
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
