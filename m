Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A0BC433E0
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:16:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B08A1238E4
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:16:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B08A1238E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5073F4B36E;
	Fri,  8 Jan 2021 07:16:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KzlFBSc0hCz1; Fri,  8 Jan 2021 07:16:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C2AB4B42E;
	Fri,  8 Jan 2021 07:16:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 203EF4B15E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:16:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MWGrPcbkOrse for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 07:16:19 -0500 (EST)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCB654B3E1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:16:18 -0500 (EST)
Received: by mail-qk1-f201.google.com with SMTP id 189so9135390qko.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2021 04:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=/kvCjtuIQz5SjJffuu+OL8P3ygl/wSXxaf12YxB4qCw=;
 b=sXaLVMq61JcLZJ7SAyFmj4qvYYTao/QZUDKHDb3xCD5xHYJ4fLJSb1MDw77gXVZahu
 GHd8anCXlIA+gEPA3OrkKfCdIBBPed21yIvvP4u/QtmwFyIr4RKm78t6hPk4LcmtiuGl
 LWJlmj0AegTkmCNkcO9neBNdiLcVfxNxYmXhWiJEbq0QdSldprFK73+TKhabFk7lWCmq
 b1SZpo8VVMfhkLGNhaU9VUXMO3vR+8ecZ+cYehglSMSC+/qa0JQ2fmL4M8QIMdaveKli
 Q5mBZfiOrHA99BRo6Ve44te6CbokgQW9gTYHdRzbGq2clm3sZJWpIXFM48iiufWt7Z/U
 ncpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=/kvCjtuIQz5SjJffuu+OL8P3ygl/wSXxaf12YxB4qCw=;
 b=sa0G8uxhaPUzN3Ja1zKkMQ6Tu2uuM5oAGLYH5oH3o2IGyP6hAvHE0n8OfUO2EsvwRO
 qrm9yEbwCrLWIP59D1a1gy1R2kHuPBJO311dZWJN51epATkF6oGGa87FRb+lGYNwloie
 HVa5PHrj+uT3UfrqZBeOiigB0l29odDRQMGw9lQee/2p1H+xTRacTbrfKrLu8hape9qF
 jwW0yaK3ATzOtyjfWuOqZwap9iQK0ghQ5ZDyBRh+6s0sSMyc/0aSdZtWlEVofgmKhYWD
 4qnlnZl3l90T7AEBYYWNAzRMxtz0LeUb1xrGXgWdfoHdDxHRiH5KmozV8PpmUHxa+dC1
 XmKQ==
X-Gm-Message-State: AOAM533tc998rEOr2JXt6HzbWdNXobfVOpPJQIa4O47tfRnddp2085Xv
 QumT0Ar8tmzEpkyJp9iGjL3/W1FWLHj+
X-Google-Smtp-Source: ABdhPJyAyeWtBSy6/qlX3SVvUQWsmlUBEqJw+CdqkyK2mN7Fz3TinYAuvO+j5sLLsHjag7/tCMs04/QRlCoX
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:ad4:4083:: with SMTP id
 l3mr3194245qvp.17.1610108178425; Fri, 08 Jan 2021 04:16:18 -0800 (PST)
Date: Fri,  8 Jan 2021 12:15:22 +0000
In-Reply-To: <20210108121524.656872-1-qperret@google.com>
Message-Id: <20210108121524.656872-25-qperret@google.com>
Mime-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [RFC PATCH v2 24/26] KVM: arm64: Make memcache anonymous in pgtable
 allocator
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: devicetree@vger.kernel.org, android-kvm@google.com,
 linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

The current stage2 page-table allocator uses a memcache to get
pre-allocated pages when it needs any. To allow re-using this code at
EL2 which uses a concept of memory pools, make the memcache argument to
kvm_pgtable_stage2_map() anonymous. and let the mm_ops zalloc_page()
callbacks use it the way they need to.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 6 +++---
 arch/arm64/kvm/hyp/pgtable.c         | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 8e8f1d2c5e0e..d846bc3d3b77 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -176,8 +176,8 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  * @size:	Size of the mapping.
  * @phys:	Physical address of the memory to map.
  * @prot:	Permissions and attributes for the mapping.
- * @mc:		Cache of pre-allocated GFP_PGTABLE_USER memory from which to
- *		allocate page-table pages.
+ * @mc:		Cache of pre-allocated memory from which to allocate page-table
+ *		pages.
  *
  * The offset of @addr within a page is ignored, @size is rounded-up to
  * the next page boundary and @phys is rounded-down to the previous page
@@ -194,7 +194,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  */
 int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			   u64 phys, enum kvm_pgtable_prot prot,
-			   struct kvm_mmu_memory_cache *mc);
+			   void *mc);
 
 /**
  * kvm_pgtable_stage2_unmap() - Remove a mapping from a guest stage-2 page-table.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 96a25d0b7b6e..5dd1b4978fe8 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -443,7 +443,7 @@ struct stage2_map_data {
 	kvm_pte_t			*anchor;
 
 	struct kvm_s2_mmu		*mmu;
-	struct kvm_mmu_memory_cache	*memcache;
+	void				*memcache;
 
 	struct kvm_pgtable_mm_ops	*mm_ops;
 };
@@ -613,7 +613,7 @@ static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 
 int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			   u64 phys, enum kvm_pgtable_prot prot,
-			   struct kvm_mmu_memory_cache *mc)
+			   void *mc)
 {
 	int ret;
 	struct stage2_map_data map_data = {
-- 
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
