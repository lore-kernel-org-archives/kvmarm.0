Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F13AC433FE
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 09:04:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C5A2E61501
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 09:04:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C5A2E61501
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C2254B24F;
	Mon,  4 Oct 2021 05:04:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xCyoJv25JmBY; Mon,  4 Oct 2021 05:04:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 705614B261;
	Mon,  4 Oct 2021 05:04:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F2A64B236
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 05:03:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0YQOqhPuk6CH for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 05:03:58 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 762034B211
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 05:03:58 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 m1-20020a05620a290100b0045e5e0b11e6so23226396qkp.23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 02:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=tHk4fNmSvcmkrUgevYD4U41Hr/4Newl1f8mzt2RPUWc=;
 b=myW/CpAigjPZ2o/T9HjLhLXbZVJxyS9JodGVVoxwHVcl/oDBQWttTnf0/LE1PwwT89
 gKHppZ/CIgxO5msodZmnUfQBvJdqFUxdYc2bpazuwiq6sHG2QRGBrRuLvZr9ama7hWIy
 ZMJVyyU+o0d18Ju2reVMrpwo7YeU6Ga9AixILWDG8AnRm/y8T+cOnFt3lc+f0kCaWJdY
 pnU5kjI5gSCdVuPAbJjWYsFQ5TkKHM5RnmPP8Cax+hFd8/qzWgC9yJEvhQaq+CaYCveL
 mPuIgKFgnPJ9kaD32mXvPB1nryO78HAjInlK0UW7Z7MGbp2HyWIXaRHkD94LZXB0c6Xr
 UHRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=tHk4fNmSvcmkrUgevYD4U41Hr/4Newl1f8mzt2RPUWc=;
 b=aYj3aJ/ufqu1SZtB+fQBcVXt5XPAi/kXr8NfvktHu5C9+bfwMQgji6T4KaT+EYVtJQ
 vjtEomepE2sbYqRsPWgF5Go6SmPr2Skx/AinI54gKJYaD132FxzWVPkHrpGBybpfnyUP
 kYnMos5nN+hXs6RT+JU6hVle4hEXH3gRjDXfEi6stYS4d/FTOol+HSbChkPRpCeaTRUV
 QvW07Jty+Gr3fHAHTCrzuonlltUFO4hoGN53f15DcazQzz4EIBN7P2m7bYFHBEF11dPP
 kw5QKEugdiYIEQ+Lsx38L7Zn+yhf59wpney4rzReHbs2BN4aQkdwO1S1lrmPlxWfRBLz
 TfHg==
X-Gm-Message-State: AOAM532QYZvrWphoEmnwuXcBmVcqI254j5P9RKg8tnxgnnUtmu189Qs0
 v6mjdqjVY5rnELT1b558FQIaKGr/4JOg
X-Google-Smtp-Source: ABdhPJycEaMXqOovXmHOEABw2fHm7gyvxCA3r77eIjHFoIIvQP3KmydvfcyBUYygJRYLqZ5CcnPGaqUsZunc
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:669b:5b16:60b7:a3d4])
 (user=qperret job=sendgmr) by 2002:a05:6214:c47:: with SMTP id
 r7mr4515752qvj.12.1633338238007; Mon, 04 Oct 2021 02:03:58 -0700 (PDT)
Date: Mon,  4 Oct 2021 10:03:13 +0100
In-Reply-To: <20211004090328.540941-1-qperret@google.com>
Message-Id: <20211004090328.540941-2-qperret@google.com>
Mime-Version: 1.0
References: <20211004090328.540941-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH 1/2] KVM: arm64: Fix host stage-2 PGD refcount
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>, 
 David Brazdil <dbrazdil@google.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Cc: kernel-team@android.com
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

The KVM page-table library refcounts the pages of concatenated stage-2
PGDs individually. However, the host's stage-2 PGD is currently managed
by EL2 as a single high-order compound page, which can cause the
refcount of the tail pages to reach 0 when they really shouldn't, hence
corrupting the page-table.

Fix this by introducing a new hyp_split_page() helper in the EL2 page
allocator (matching EL1's split_page() function), and make use of it
from host_s2_zalloc_page().

Fixes: 1025c8c0c6ac ("KVM: arm64: Wrap the host with a stage 2")
Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/gfp.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 +++++-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c  | 14 ++++++++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
index fb0f523d1492..0a048dc06a7d 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
@@ -24,6 +24,7 @@ struct hyp_pool {
 
 /* Allocation */
 void *hyp_alloc_pages(struct hyp_pool *pool, unsigned short order);
+void hyp_split_page(struct hyp_page *page);
 void hyp_get_page(struct hyp_pool *pool, void *addr);
 void hyp_put_page(struct hyp_pool *pool, void *addr);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index bacd493a4eac..93a79736c283 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -35,7 +35,11 @@ const u8 pkvm_hyp_id = 1;
 
 static void *host_s2_zalloc_pages_exact(size_t size)
 {
-	return hyp_alloc_pages(&host_s2_pool, get_order(size));
+	void *addr = hyp_alloc_pages(&host_s2_pool, get_order(size));
+
+	hyp_split_page(hyp_virt_to_page(addr));
+
+	return addr;
 }
 
 static void *host_s2_zalloc_page(void *pool)
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index 41fc25bdfb34..a6e874e61a40 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -193,6 +193,20 @@ void hyp_get_page(struct hyp_pool *pool, void *addr)
 	hyp_spin_unlock(&pool->lock);
 }
 
+void hyp_split_page(struct hyp_page *p)
+{
+	unsigned short order = p->order;
+	unsigned int i;
+
+	p->order = 0;
+	for (i = 1; i < (1 << order); i++) {
+		struct hyp_page *tail = p + i;
+
+		tail->order = 0;
+		hyp_set_page_refcounted(tail);
+	}
+}
+
 void *hyp_alloc_pages(struct hyp_pool *pool, unsigned short order)
 {
 	unsigned short i = order;
-- 
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
