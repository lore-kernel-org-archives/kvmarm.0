Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7957C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:58:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E8E2611AD
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:58:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6E8E2611AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21B624B132;
	Wed, 13 Oct 2021 11:58:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nVJ9y4qXBFcd; Wed, 13 Oct 2021 11:58:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0C864B0D9;
	Wed, 13 Oct 2021 11:58:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD1994B14C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:58:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aXXS6xji239e for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 11:58:51 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A03A4B129
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:58:51 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 c19-20020ac81e93000000b002a71180fd3dso2447310qtm.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ztuYYF9Onc0ZIjngTVEp2z77n51MjY0wGMZOLwDTwhY=;
 b=GVq5GFcw/0eVvulNbba6ktlvmE8YFALwpDIhCJ2/vsiC21sLdLoc9O7Xq36D1lJ5lf
 ZQpif0gOuVc4Y1gCrCxInx9Dy5dbafYfdL55owb7iUdw+pbGb6j7FjBOyhKrHNDwIkvj
 IUagiUdDR+zKO/Ac9HpWerSCBqwNR3R74jb/oiqdXP39kp5RokKJ70PgYiZ7br199OT/
 fxtAXX/51HuCFEYze6DhFLzMABWI4+IwL8WM23aFrRth8DgCQnF6HKbnFhSTNuYZOayb
 PcC6MbtcinQD4fvigVVSdsAf5MhLy6ddmj2xBzYeMb40ITQkrfyGcy+2NPXD9hI6eXPQ
 nvgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ztuYYF9Onc0ZIjngTVEp2z77n51MjY0wGMZOLwDTwhY=;
 b=0a6cbAPsi9VkQWM4siUNDLK3haewrVqF7cB2sA/sgMBFKNTNdDSwZluJjAr3zZWzIg
 +Lu+GG0OdH+cutkhKnL8n+Pmxz7XuYtWPmsTNj+YA1Xd6arn3DSyr8q1jBBquBeMVCvt
 Zp73Kizgzt0Xu2Wzi9Ob+lgElRk4XWnEwCpVL8Jyw8A0NiGcSBL5SVlDVyGUMBth34Vj
 QcjNDQJs0SzdzZp8Ge1bDU+5kgoELslYJ48DtQqXrxpcoNsS5G0eA3QMxLfMwlI5xyxr
 rXzqTH9h0fMJyT4x//zwFPl3JJPPrVCvNCY2YKsfcwsywtSbK/OLhnzDvCwxUlPJRvhD
 umbg==
X-Gm-Message-State: AOAM532OzzmUlIXCyJFwtyEHlm8tQ4KhsiRb0yMF6jcQtB8lowRKOusD
 FSSRioGLAXkdhLUsn2XBpZ82+42HuFgl
X-Google-Smtp-Source: ABdhPJxp1hUAJxs/riqQe2cYJzZaiMjwH6ehh74ltN5CiIrrR1/FVufG6S8GAC+vFxwjhGJSaTXJSPc9xIJG
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:65b5:73d3:1558:b9ae])
 (user=qperret job=sendgmr) by 2002:a05:622a:13c6:: with SMTP id
 p6mr65288qtk.165.1634140730556; Wed, 13 Oct 2021 08:58:50 -0700 (PDT)
Date: Wed, 13 Oct 2021 16:58:22 +0100
In-Reply-To: <20211013155831.943476-1-qperret@google.com>
Message-Id: <20211013155831.943476-8-qperret@google.com>
Mime-Version: 1.0
References: <20211013155831.943476-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 07/16] KVM: arm64: Refcount hyp stage-1 pgtable pages
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

To prepare the ground for allowing hyp stage-1 mappings to be removed at
run-time, update the KVM page-table code to maintain a correct refcount
using the ->{get,put}_page() function callbacks.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index f8ceebe4982e..768a58835153 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -408,8 +408,10 @@ static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 		return false;
 
 	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
-	if (hyp_pte_needs_update(old, new))
+	if (hyp_pte_needs_update(old, new)) {
 		smp_store_release(ptep, new);
+		data->mm_ops->get_page(ptep);
+	}
 
 	data->phys += granule;
 	return true;
@@ -433,6 +435,7 @@ static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		return -ENOMEM;
 
 	kvm_set_table_pte(ptep, childp, mm_ops);
+	mm_ops->get_page(ptep);
 	return 0;
 }
 
@@ -482,8 +485,16 @@ static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			   enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = arg;
+	kvm_pte_t pte = *ptep;
+
+	if (!kvm_pte_valid(pte))
+		return 0;
+
+	mm_ops->put_page(ptep);
+
+	if (kvm_pte_table(pte, level))
+		mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
 
-	mm_ops->put_page((void *)kvm_pte_follow(*ptep, mm_ops));
 	return 0;
 }
 
@@ -491,7 +502,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 {
 	struct kvm_pgtable_walker walker = {
 		.cb	= hyp_free_walker,
-		.flags	= KVM_PGTABLE_WALK_TABLE_POST,
+		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
 		.arg	= pgt->mm_ops,
 	};
 
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
