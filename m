Return-Path: <SRS0=DvdR=PH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D3BC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9C1A661372
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9C1A661372
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 487554B1A3;
	Tue, 19 Oct 2021 08:13:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hAQ7Nm2lUHtE; Tue, 19 Oct 2021 08:13:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01C484B186;
	Tue, 19 Oct 2021 08:13:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81CFA4B0DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZVEoSiTw6KCs for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Oct 2021 08:13:33 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 464D84B18A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:33 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 h99-20020adf906c000000b001644add8925so6904130wrh.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 05:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ujj+7B+0nuZuoSuPZCEqJilB3KVDDbovLbdFeyFEdl4=;
 b=Z36MuVbabgtLcQJafM4rih1H9ZRXiETiB3WImm4G8LI3SOhi/roAv2h0LV2C7/DSQl
 nmrSsgXGZW+pxC5jEUB/4n4FWkFXLRAan+kNQWF6VlX08HYf3v7IclApBg61Cgwz/WZT
 a+eOLK9mz2Zy+hTo27dvPDSxhTNljl0ZH2SB+xcskO+vVkBntf7xW/RxP9uppeP9QIsf
 2phhSYPRu2DbI41PCsQFHA06lrqm4QDaf6DSwSqacBpfRVUSb9+haZEx3DCn3otJIDDH
 TACCyDDp2WEY/GE6fkQbvLNpXgkkjDsGai+UPTXHl24rQ2+SbbheB87qi/bAIHG7QEtT
 rPlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ujj+7B+0nuZuoSuPZCEqJilB3KVDDbovLbdFeyFEdl4=;
 b=A+k3DdPARX4diYZs3XLgoIMPl5xiYbOw3B59McKDcQiuCFMFslz/Lwe4mqbwcwc1++
 fcB0CsX0OfBTxTcuXUmDLMPgfLYANKvV4BGZCjo42vxfypFYSqwPNaZ7onz/SbamAWmU
 Ji7zApM5YczoJL8F/rk5F2e/SMkK0ISY8P06z1/qQ5OgzFSmQISFWfGd6icH8JkHHn6u
 9DQw2gYXfFpWMhhvR/oLZaZKXq1O6oXXClicLVWIb3Vjk2764zpAT7Hn/YYRVy7ND2tA
 ymEcnKYs87++xZV14zditDIGgWGGC5+ol5RYsADLexGOW64HyUHRAsyo5L0s4XJga7Xi
 Z0Hw==
X-Gm-Message-State: AOAM530tWB5mWH3X0cKwS7xcJ+lMu+JcwAAxJ2Lkuc9JIIwRPZ3UbvB2
 c0rhe4zgDABXsITiEuwBXtXBLWvAgAyt
X-Google-Smtp-Source: ABdhPJzPSTaE5jzLKB1zddUidDr+xxPerq5HIbOVn52bHTZu5cFEMbPaBO1n4f6RCVVoKM6rqb4L5boRccfl
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:59ca:401f:83a8:de6d])
 (user=qperret job=sendgmr) by 2002:a05:600c:154b:: with SMTP id
 f11mr5592079wmg.143.1634645612364; Tue, 19 Oct 2021 05:13:32 -0700 (PDT)
Date: Tue, 19 Oct 2021 13:13:00 +0100
In-Reply-To: <20211019121304.2732332-1-qperret@google.com>
Message-Id: <20211019121304.2732332-12-qperret@google.com>
Mime-Version: 1.0
References: <20211019121304.2732332-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2 11/15] KVM: arm64: Implement do_share() helper for sharing
 memory
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

By default, protected KVM isolates memory pages so that they are
accessible only to their owner: be it the host kernel, the hypervisor
at EL2 or (in future) the guest. Establishing shared-memory regions
between these components therefore involves a transition for each page
so that the owner can share memory with a borrower under a certain set
of permissions.

Introduce a do_share() helper for safely sharing a memory region between
two components. Currently, only host-to-hyp sharing is implemented, but
the code is easily extended to handle other combinations and the
permission checks for each component are reusable.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 237 ++++++++++++++++++++++++++
 1 file changed, 237 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index c111e0fcfa0a..d87cdd53dd21 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -460,3 +460,240 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
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
+		/* Address in the initiator's address space */
+		u64			addr;
+
+		union {
+			struct {
+				/* Address in the completer's address space */
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
+	const struct pkvm_mem_transition	tx;
+	const enum kvm_pgtable_prot		prot;
+};
+
+struct check_walk_data {
+	enum pkvm_page_state	desired;
+	enum pkvm_page_state	(*get_page_state)(kvm_pte_t pte);
+};
+
+static int __check_page_state_visitor(u64 addr, u64 end, u32 level,
+				      kvm_pte_t *ptep,
+				      enum kvm_pgtable_walk_flags flag,
+				      void * const arg)
+{
+	struct check_walk_data *d = arg;
+	kvm_pte_t pte = *ptep;
+
+	if (kvm_pte_valid(pte) && !addr_is_memory(kvm_pte_to_phys(pte)))
+		return -EINVAL;
+
+	return d->get_page_state(pte) == d->desired ? 0 : -EPERM;
+}
+
+static int check_page_state_range(struct kvm_pgtable *pgt, u64 addr, u64 size,
+				  struct check_walk_data *data)
+{
+	struct kvm_pgtable_walker walker = {
+		.cb	= __check_page_state_visitor,
+		.arg	= data,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+	};
+
+	return kvm_pgtable_walk(pgt, addr, size, &walker);
+}
+
+static enum pkvm_page_state host_get_page_state(kvm_pte_t pte)
+{
+	if (!kvm_pte_valid(pte) && pte)
+		return PKVM_NOPAGE;
+
+	return pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte));
+}
+
+static int __host_check_page_state_range(u64 addr, u64 size,
+					 enum pkvm_page_state state)
+{
+	struct check_walk_data d = {
+		.desired	= state,
+		.get_page_state	= host_get_page_state,
+	};
+
+	hyp_assert_lock_held(&host_kvm.lock);
+	return check_page_state_range(&host_kvm.pgt, addr, size, &d);
+}
+
+static int __host_set_page_state_range(u64 addr, u64 size,
+				       enum pkvm_page_state state)
+{
+	enum kvm_pgtable_prot prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, state);
+
+	return host_stage2_idmap_locked(addr, size, prot);
+}
+
+static int host_request_owned_transition(u64 *completer_addr,
+					 const struct pkvm_mem_transition *tx)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+	u64 addr = tx->initiator.addr;
+
+	*completer_addr = tx->initiator.host.completer_addr;
+	return __host_check_page_state_range(addr, size, PKVM_PAGE_OWNED);
+}
+
+static int host_initiate_share(u64 *completer_addr,
+			       const struct pkvm_mem_transition *tx)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+	u64 addr = tx->initiator.addr;
+
+	*completer_addr = tx->initiator.host.completer_addr;
+	return __host_set_page_state_range(addr, size, PKVM_PAGE_SHARED_OWNED);
+}
+
+static enum pkvm_page_state hyp_get_page_state(kvm_pte_t pte)
+{
+	if (!kvm_pte_valid(pte))
+		return PKVM_NOPAGE;
+
+	return pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte));
+}
+
+static int __hyp_check_page_state_range(u64 addr, u64 size,
+					enum pkvm_page_state state)
+{
+	struct check_walk_data d = {
+		.desired	= state,
+		.get_page_state	= hyp_get_page_state,
+	};
+
+	hyp_assert_lock_held(&pkvm_pgd_lock);
+	return check_page_state_range(&pkvm_pgtable, addr, size, &d);
+}
+
+static bool __hyp_ack_skip_pgtable_check(const struct pkvm_mem_transition *tx)
+{
+	return !(IS_ENABLED(CONFIG_NVHE_EL2_DEBUG) ||
+		 tx->initiator.id != PKVM_ID_HOST);
+}
+
+static int hyp_ack_share(u64 addr, const struct pkvm_mem_transition *tx,
+			 enum kvm_pgtable_prot perms)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+
+	if (perms != PAGE_HYP)
+		return -EPERM;
+
+	if (__hyp_ack_skip_pgtable_check(tx))
+		return 0;
+
+	return __hyp_check_page_state_range(addr, size, PKVM_NOPAGE);
+}
+
+static int hyp_complete_share(u64 addr, const struct pkvm_mem_transition *tx,
+			      enum kvm_pgtable_prot perms)
+{
+	void *start = (void *)addr, *end = start + (tx->nr_pages * PAGE_SIZE);
+	enum kvm_pgtable_prot prot;
+
+	prot = pkvm_mkstate(perms, PKVM_PAGE_SHARED_BORROWED);
+	return pkvm_create_mappings_locked(start, end, prot);
+}
+
+static int check_share(struct pkvm_mem_share *share)
+{
+	const struct pkvm_mem_transition *tx = &share->tx;
+	u64 completer_addr;
+	int ret;
+
+	switch (tx->initiator.id) {
+	case PKVM_ID_HOST:
+		ret = host_request_owned_transition(&completer_addr, tx);
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
+		ret = hyp_ack_share(completer_addr, tx, share->prot);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int __do_share(struct pkvm_mem_share *share)
+{
+	const struct pkvm_mem_transition *tx = &share->tx;
+	u64 completer_addr;
+	int ret;
+
+	switch (tx->initiator.id) {
+	case PKVM_ID_HOST:
+		ret = host_initiate_share(&completer_addr, tx);
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
+		ret = hyp_complete_share(completer_addr, tx, share->prot);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
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
+ */
+static int do_share(struct pkvm_mem_share *share)
+{
+	int ret;
+
+	ret = check_share(share);
+	if (ret)
+		return ret;
+
+	return WARN_ON(__do_share(share));
+}
-- 
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
