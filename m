Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 607A3C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:42:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 074304B357;
	Thu, 19 May 2022 09:42:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ShS8Ay2TcHvq; Thu, 19 May 2022 09:42:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E51494B240;
	Thu, 19 May 2022 09:42:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41624410FF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:42:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wHJQ6XAiM5f6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:42:53 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC3274B38C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:42:53 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 6F85C6176B;
 Thu, 19 May 2022 13:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670B3C34116;
 Thu, 19 May 2022 13:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967772;
 bh=KylN5F7OBemLgjR/NfTk3I4TCHIFYQD56mt7BpV3Ah4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=RiqPzk+iNLqmlON7sfdQpR9X2SO9AnM4CZrDiG0TLX76KVTCasJoLfBMUFIlysDQG
 mA0tzDYlwHJhXtru1VdUgzT4j8E2YFnsdCDSHUyoFlS5liPTIHfMR3Rf+0B+jrtcEB
 n69jGofclGAolmDnYg3ELgPB8xuCdrjwmdOg/DMHZtlRIL5q0fnsMZ8ZjC7U7jw8IJ
 STjzA5vz0MLhbQ0W/vKuHryuy79VNd47QR2OPku2nZs3/SUBnoRTS4R2omX8yF2Ft7
 Uc6yEgkN+vtLVzNOphrbZgbR5E9ibRgX+62TToE+RNKTlHUxKFWpd+iIDiOUiBp8Di
 Y75RfgaJ5Pxkg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 07/89] KVM: arm64: Move hyp refcount manipulation helpers
Date: Thu, 19 May 2022 14:40:42 +0100
Message-Id: <20220519134204.5379-8-will@kernel.org>
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

From: Quentin Perret <qperret@google.com>

We will soon need to manipulate struct hyp_page refcounts from outside
page_alloc.c, so move the helpers to a header file.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/memory.h | 18 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 19 -------------------
 2 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 592b7edb3edb..418b66a82a50 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -45,4 +45,22 @@ static inline int hyp_page_count(void *addr)
 	return p->refcount;
 }
 
+static inline void hyp_page_ref_inc(struct hyp_page *p)
+{
+	BUG_ON(p->refcount == USHRT_MAX);
+	p->refcount++;
+}
+
+static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
+{
+	BUG_ON(!p->refcount);
+	p->refcount--;
+	return (p->refcount == 0);
+}
+
+static inline void hyp_set_page_refcounted(struct hyp_page *p)
+{
+	BUG_ON(p->refcount);
+	p->refcount = 1;
+}
 #endif /* __KVM_HYP_MEMORY_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index d40f0b30b534..1ded09fc9b10 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -144,25 +144,6 @@ static struct hyp_page *__hyp_extract_page(struct hyp_pool *pool,
 	return p;
 }
 
-static inline void hyp_page_ref_inc(struct hyp_page *p)
-{
-	BUG_ON(p->refcount == USHRT_MAX);
-	p->refcount++;
-}
-
-static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
-{
-	BUG_ON(!p->refcount);
-	p->refcount--;
-	return (p->refcount == 0);
-}
-
-static inline void hyp_set_page_refcounted(struct hyp_page *p)
-{
-	BUG_ON(p->refcount);
-	p->refcount = 1;
-}
-
 static void __hyp_put_page(struct hyp_pool *pool, struct hyp_page *p)
 {
 	if (hyp_page_ref_dec_and_test(p))
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
