Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C791C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2871565002
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2871565002
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2AA74B6F0;
	Mon, 15 Mar 2021 10:36:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ihl3DmRrjygZ; Mon, 15 Mar 2021 10:36:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A95DA4B57B;
	Mon, 15 Mar 2021 10:36:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E47D94B6DC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R1mY-XMTmYjs for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:36:32 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE3104B6DA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:32 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id y5so15187204wrp.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Cxdxaiam1X2gsTV6KPc4g5L7XZMiE67OSu7PD7BcN7o=;
 b=OMsxJI7KJj6F2RuvFviEZz84cZybVuZYThaK3AmaKHP1u8aAuqn1WOOcT2LSJKF9V7
 vDcNvZhVfhqocQA7wmz66kO6OnwWldlrfaZPwqPTi6krQcWQOC+0UvX840UIbbh5ftqt
 oKDtYOHbUc7n70UKZc6DgdOCN7e5chAPaoA9HsJxC5240NXoVoTKtijG7Quiq1R+hOei
 TjvA+2uxGeEJyocrfKq6KpomlHmn6s2H4fQAhHQVouRekpeDPRcMehqic7AHjrCTzQRE
 BlBA46/4o/1J5S3k1AEp73sprYebuMw17kSK4PerOOsOOvSLkme2qCD4p9UoekTY5+3T
 3NFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Cxdxaiam1X2gsTV6KPc4g5L7XZMiE67OSu7PD7BcN7o=;
 b=YA52koY1kNVP4sxgAoi/QAsXMiP8E9KXNMi/18l+Bsr8rYA7bSj/vteFGYO429oYnt
 ItC83I55dPuIQTPYBNPV6LK2BSZBpIfAIdUJ01/SGueSBDng9Iw41qaYbHh5TfnCXlt+
 Jy2+8kX2VgsGZ5ZHux18OQfCL1WQpKbgMNUUVQ00FB8MjamhNrcPZT4nUbnivd7HJFOj
 3jS1jcJ7FPTKXdlpv4g1jL7bLdRTBrlIBXuBymBVEVaYGV8cvTt4IYu+7CDLewc/nlQR
 cj+IeeWUzl1uOe85G41mMS1Jc1EC2YzVkUiHKJAbdRO6YEIQewX3t4mg65gYbpuvRKMi
 erkw==
X-Gm-Message-State: AOAM530r/7Sr3SB9PdnDSVRE7/1FnAcuvarUpcc+AiZ+qtDGj+568khY
 /57Gkk2r1KzZ1nkUTjs52ib+PaF0o3Lj
X-Google-Smtp-Source: ABdhPJzXhlBmc8e/B+KVzi/50+fA2t7x+8GH00VuaEIHUCbA/WbBddcs0rg+cC27VW6NLE39ZvY96jTAe/7X
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:adf:f841:: with SMTP id
 d1mr31309wrq.36.1615818992019; Mon, 15 Mar 2021 07:36:32 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:25 +0000
In-Reply-To: <20210315143536.214621-1-qperret@google.com>
Message-Id: <20210315143536.214621-26-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 25/36] KVM: arm64: Make memcache anonymous in pgtable
 allocator
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org, tabba@google.com,
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
EL2 which uses a concept of memory pools, make the memcache argument of
kvm_pgtable_stage2_map() anonymous, and let the mm_ops zalloc_page()
callbacks use it the way they need to.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 6 +++---
 arch/arm64/kvm/hyp/pgtable.c         | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 9cdc198ea6b4..4ae19247837b 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -213,8 +213,8 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  * @size:	Size of the mapping.
  * @phys:	Physical address of the memory to map.
  * @prot:	Permissions and attributes for the mapping.
- * @mc:		Cache of pre-allocated GFP_PGTABLE_USER memory from which to
- *		allocate page-table pages.
+ * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
+ *		page-table pages.
  *
  * The offset of @addr within a page is ignored, @size is rounded-up to
  * the next page boundary and @phys is rounded-down to the previous page
@@ -236,7 +236,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  */
 int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			   u64 phys, enum kvm_pgtable_prot prot,
-			   struct kvm_mmu_memory_cache *mc);
+			   void *mc);
 
 /**
  * kvm_pgtable_stage2_unmap() - Remove a mapping from a guest stage-2 page-table.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 296675e5600d..bdd6e3d4eeb6 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -445,7 +445,7 @@ struct stage2_map_data {
 	kvm_pte_t			*anchor;
 
 	struct kvm_s2_mmu		*mmu;
-	struct kvm_mmu_memory_cache	*memcache;
+	void				*memcache;
 
 	struct kvm_pgtable_mm_ops	*mm_ops;
 };
@@ -669,7 +669,7 @@ static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 
 int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			   u64 phys, enum kvm_pgtable_prot prot,
-			   struct kvm_mmu_memory_cache *mc)
+			   void *mc)
 {
 	int ret;
 	struct stage2_map_data map_data = {
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
