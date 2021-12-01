Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8CF5C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 17:04:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72D974B21F;
	Wed,  1 Dec 2021 12:04:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S4zu7PvfvQVm; Wed,  1 Dec 2021 12:04:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13A624B1F7;
	Wed,  1 Dec 2021 12:04:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77CDC4B1F5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:04:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id THCCaDL+ZMxo for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 12:04:47 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A95614B21F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:04:46 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id
 r129-20020a1c4487000000b00333629ed22dso133619wma.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Dec 2021 09:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=3kGqtrkDX/7YFDJqNxF3cw4ExJXKG5GDRcsjJYQ/JVo=;
 b=TMO4hW6gBvmBsrzVeqH/Hwa2gs9Xbv3N2Qp7sh2MQz/vWRh6mkuEatIkrGrTZf3Z4I
 J4ZT0n9fQuNxYUa41Q/bfrGeXJfXoAxp0fVLJYsUlcz4fJ9elw13634GMg/GtfXBD9gS
 HgsZuqhwLHubwI2YpiTsQ5gPYmF4oiPV0t0LYGbZQsqW5tsVfYeH3pZdLC20OCtG9SBk
 hhssObLi/zjJz/dfhhWUJZkRS15K+o5PXPkzjL6lAnmts21mdTmxYXoGDWcbisE6lvjw
 Zdp4uo94fV72wWfRF6SQkDM9TrvSF/jxNwMbnGAP2S4QVSSagWKieTx6L10xi1OZqvWY
 FH7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=3kGqtrkDX/7YFDJqNxF3cw4ExJXKG5GDRcsjJYQ/JVo=;
 b=mmPcg69PUQWs5X3gNkH4+APmRUy8US9UlJ5VihDs/L5kqAFh1nj6BKENFZSQYr1vE9
 Vc59YwyUiteJgzjkjD6bmEHfO28wLrSFTIk7MmyA1md1Z+BA4jrDe4xBGjmNliuPBzWJ
 5JkwhZZhMJrlDT8G9eCAcFCfz/b0WlpMc5+E2PZ9oD3XDuUvqDAF0IU3zMxSaSfIgoYC
 jrAX79lEcspj5NR4RujAYng2cwYwyCw+6CDddsffURAD9qzUe5zEw5yHHj+KltwQDCLf
 AGy/WiAge5igba8Acumct272IVqseAkUGIvkF8V/P2jIzhzoc1dTHkEY1hHJVoIB2HCf
 D7AA==
X-Gm-Message-State: AOAM531ysezHGog7pBB/ihn866+RYM5ovAwwY7shusYBTexkhD4RevDA
 IOFJRtUiRVTT190QVn/y9TDIa/bPA/6b
X-Google-Smtp-Source: ABdhPJzzYr8OrnKjxfmfCT1wD/gpPb9rlHIvVwT+T1gmq0Ql8fSZ2Xu5j+Ura+iJuS9E70AhlNnb1YCGJ043
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1cab:1a20:2ef1:ddde])
 (user=qperret job=sendgmr) by 2002:a05:600c:4e07:: with SMTP id
 b7mr8305933wmq.16.1638378285742; Wed, 01 Dec 2021 09:04:45 -0800 (PST)
Date: Wed,  1 Dec 2021 17:04:02 +0000
In-Reply-To: <20211201170411.1561936-1-qperret@google.com>
Message-Id: <20211201170411.1561936-9-qperret@google.com>
Mime-Version: 1.0
References: <20211201170411.1561936-1-qperret@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 08/15] KVM: arm64: pkvm: Refcount the pages shared with EL2
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

In order to simplify the page tracking infrastructure at EL2 in nVHE
protected mode, move the responsibility of refcounting pages that are
shared multiple times on the host. In order to do so, let's create a
red-black tree tracking all the PFNs that have been shared, along with
a refcount.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/mmu.c | 78 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 68 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index fd868fb9d922..d72566896755 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -284,23 +284,72 @@ static phys_addr_t kvm_kaddr_to_phys(void *kaddr)
 	}
 }
 
-static int pkvm_share_hyp(phys_addr_t start, phys_addr_t end)
+struct hyp_shared_pfn {
+	u64 pfn;
+	int count;
+	struct rb_node node;
+};
+
+static DEFINE_MUTEX(hyp_shared_pfns_lock);
+static struct rb_root hyp_shared_pfns = RB_ROOT;
+
+static struct hyp_shared_pfn *find_shared_pfn(u64 pfn, struct rb_node ***node,
+					      struct rb_node **parent)
 {
-	phys_addr_t addr;
-	int ret;
+	struct hyp_shared_pfn *this;
+
+	*node = &hyp_shared_pfns.rb_node;
+	*parent = NULL;
+	while (**node) {
+		this = container_of(**node, struct hyp_shared_pfn, node);
+		*parent = **node;
+		if (this->pfn < pfn)
+			*node = &((**node)->rb_left);
+		else if (this->pfn > pfn)
+			*node = &((**node)->rb_right);
+		else
+			return this;
+	}
 
-	for (addr = ALIGN_DOWN(start, PAGE_SIZE); addr < end; addr += PAGE_SIZE) {
-		ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp,
-					__phys_to_pfn(addr));
-		if (ret)
-			return ret;
+	return NULL;
+}
+
+static int share_pfn_hyp(u64 pfn)
+{
+	struct rb_node **node, *parent;
+	struct hyp_shared_pfn *this;
+	int ret = 0;
+
+	mutex_lock(&hyp_shared_pfns_lock);
+	this = find_shared_pfn(pfn, &node, &parent);
+	if (this) {
+		this->count++;
+		goto unlock;
 	}
 
-	return 0;
+	this = kzalloc(sizeof(*this), GFP_KERNEL);
+	if (!this) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	this->pfn = pfn;
+	this->count = 1;
+	rb_link_node(&this->node, parent, node);
+	rb_insert_color(&this->node, &hyp_shared_pfns);
+	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn, 1);
+unlock:
+	mutex_unlock(&hyp_shared_pfns_lock);
+
+	return ret;
 }
 
 int kvm_share_hyp(void *from, void *to)
 {
+	phys_addr_t start, end, cur;
+	u64 pfn;
+	int ret;
+
 	if (is_kernel_in_hyp_mode())
 		return 0;
 
@@ -315,7 +364,16 @@ int kvm_share_hyp(void *from, void *to)
 	if (kvm_host_owns_hyp_mappings())
 		return create_hyp_mappings(from, to, PAGE_HYP);
 
-	return pkvm_share_hyp(__pa(from), __pa(to));
+	start = ALIGN_DOWN(__pa(from), PAGE_SIZE);
+	end = PAGE_ALIGN(__pa(to));
+	for (cur = start; cur < end; cur += PAGE_SIZE) {
+		pfn = __phys_to_pfn(cur);
+		ret = share_pfn_hyp(pfn);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 /**
-- 
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
