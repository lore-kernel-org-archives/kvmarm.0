Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E598AC12002
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:47:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B53D61107
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:47:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B53D61107
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E20E4A4E5;
	Mon, 19 Jul 2021 06:47:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2eWGBdtjDi+i; Mon, 19 Jul 2021 06:47:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 059624B08D;
	Mon, 19 Jul 2021 06:47:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F2784A95C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:47:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GRWzwr9-lAuO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 06:47:48 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F2764A193
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:47:48 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 b127-20020a3799850000b02903b960837cbfso2145413qke.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 03:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=lb/gYwEJ52V8NJMW9ljOtVfH6PwbyXsZiRh6U1L061M=;
 b=dVcGRuTeuLeRZV2QwASmH66frNnilIZiSJsAaKb1s76JoXlM4AtD3npXiYQzxt28XK
 WRmijrISMsClSbfD/j1ZqOtq+NAIkXrS2vs0tgWk2FNH+4EGuiPN0pghsbdxN4MoQF5k
 dIL201YwNFekTdUovrgHjn/z4+PZxwtyG77qNXlJ+DbJY5BfxZyGA38C7WIW2DXBG+c7
 cAVEg+Vw0+L5Ce2pVQUm3xmwl4XlB7do98+Wr4I207ZGws9WsRZZ3sWM5nrre3xUZJ+Q
 0GH6Old6+be+vA+5Ga601BkY28wqGSPU4phFvCk5iEc0GkkR2DcpFMBULOEnVKIW5OcC
 zJew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=lb/gYwEJ52V8NJMW9ljOtVfH6PwbyXsZiRh6U1L061M=;
 b=lp5JY2ZuRcqitWCKb4IV2DDqMlfwW+pW9nTL60JU0j5iaRMxLC/uhGHmMx45fw7cKv
 exHw1WzmpU320bVn2BV80cmw7j+Achvg1rzAf0dK9GPDItZEBWr1fon0hDQJ9dztFYox
 E6XMHJ8G5sRtGC7jEOaUwYVPMY4MFPHlGhsVCYLw7yKj1dUYsq/qLXKIBi9kN+RP4HGa
 +ciujkQm6Eq9KAeSBb7bWBAOfStXgUdwM/lCqM51y4sPoOwvmxCuxqjC435zuUEQRYgD
 yYSZ3dtZZhSbBg6pK/2ObQ5/A3vQseaTSzxRNryEZvOjHvIT0mJ4Hl1O4A1zK9bxSrad
 yZIQ==
X-Gm-Message-State: AOAM53389J5h88O86vAuDKOTeOmMtZQJoT1QBXPLjUu2jVvi7+wRp0Ct
 ZI2URptYhqxEBhvTBso4WMXFVOtn4859
X-Google-Smtp-Source: ABdhPJytH3lHIJjCHy/P5Ydbwldz1i5qqlyWptr5/IHXQucIC5VXiU31XNnB+3cuKdHQC5Bm27x6uAI37Z5o
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1a96:a43f:6c2e:bb5a])
 (user=qperret job=sendgmr) by 2002:a05:6214:7e9:: with SMTP id
 bp9mr24508149qvb.4.1626691668039; Mon, 19 Jul 2021 03:47:48 -0700 (PDT)
Date: Mon, 19 Jul 2021 11:47:24 +0100
In-Reply-To: <20210719104735.3681732-1-qperret@google.com>
Message-Id: <20210719104735.3681732-4-qperret@google.com>
Mime-Version: 1.0
References: <20210719104735.3681732-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH 03/14] KVM: arm64: Continue stage-2 map when re-creating
 mappings
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Cc: qwandor@google.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
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

The stage-2 map walkers currently return -EAGAIN when re-creating
identical mappings or only changing access permissions. This allows to
optimize mapping pages for concurrent (v)CPUs faulting on the same
page.

While this works as expected when touching one page-table leaf at a
time, this can lead to difficult situations when mapping larger ranges.
Indeed, a large map operation can fail in the middle if an existing
mapping is found in the range, even if it has compatible attributes,
hence leaving only half of the range mapped.

To avoid having to deal with such failures in the caller, don't
interrupt the map operation when hitting existing PTEs, but make sure to
still return -EAGAIN so that user_mem_abort() can mark the page dirty
when needed.

Cc: Yanan Wang <wangyanan55@huawei.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  2 +-
 arch/arm64/kvm/hyp/pgtable.c         | 21 +++++++++++++++++----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index d6649352c8b3..af62203d2f7a 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -258,7 +258,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  * If device attributes are not explicitly requested in @prot, then the
  * mapping will be normal, cacheable.
  *
- * Note that the update of a valid leaf PTE in this function will be aborted,
+ * Note that the update of a valid leaf PTE in this function will be skipped,
  * if it's trying to recreate the exact same mapping or only change the access
  * permissions. Instead, the vCPU will exit one more time from guest if still
  * needed and then go through the path of relaxing permissions.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 978f341d02ca..bb73c5331b7c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -475,6 +475,8 @@ struct stage2_map_data {
 	void				*memcache;
 
 	struct kvm_pgtable_mm_ops	*mm_ops;
+
+	int				ret;
 };
 
 u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
@@ -612,8 +614,10 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 		 * the vCPU will exit one more time from guest if still needed
 		 * and then go through the path of relaxing permissions.
 		 */
-		if (!stage2_pte_needs_update(old, new))
-			return -EAGAIN;
+		if (!stage2_pte_needs_update(old, new)) {
+			data->ret = -EAGAIN;
+			goto out;
+		}
 
 		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
 	}
@@ -629,6 +633,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	smp_store_release(ptep, new);
 	if (stage2_pte_is_counted(new))
 		mm_ops->get_page(ptep);
+out:
 	if (kvm_phys_is_valid(phys))
 		data->phys += granule;
 	return 0;
@@ -771,6 +776,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.mmu		= pgt->mmu,
 		.memcache	= mc,
 		.mm_ops		= pgt->mm_ops,
+		.ret		= 0,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_map_walker,
@@ -789,7 +795,10 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 
 	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
 	dsb(ishst);
-	return ret;
+	if (ret)
+		return ret;
+
+	return map_data.ret;
 }
 
 int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
@@ -802,6 +811,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.memcache	= mc,
 		.mm_ops		= pgt->mm_ops,
 		.owner_id	= owner_id,
+		.ret		= 0,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_map_walker,
@@ -815,7 +825,10 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		return -EINVAL;
 
 	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
-	return ret;
+	if (ret)
+		return ret;
+
+	return map_data.ret;
 }
 
 static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
