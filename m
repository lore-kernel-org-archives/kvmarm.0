Return-Path: <SRS0=fiTO=MS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0243EC4338F
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A561560F02
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A561560F02
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B83E49F83;
	Mon, 26 Jul 2021 05:29:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Kze6kU3OBOhX; Mon, 26 Jul 2021 05:29:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C61E4A1FA;
	Mon, 26 Jul 2021 05:29:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD36A4A4E1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EC8-jqZ7QGbl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Jul 2021 05:29:27 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3243B4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:27 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 ff14-20020a0562140bceb02902fc3fd31414so7373537qvb.16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 02:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=HFQLFqYnlTo1lpqJ7D2ypgfrC23LiNE+ZmEwXkcYw0A=;
 b=emynXi8zGe9T2RndgYYOenyBOAtMls9A7ba9xIszaaQomvI/LjgYmTFavbkZgJJOTH
 jtvzzyteKVqko+G94XCfuANCCNBvhNP6T8mqrsBlRt2dIVhBPJQgOhI/dnyTrfGziGRE
 GcgWV2cqwrrCNSKHbUGrT0Hl1O/yQGv0tUrhtwxijYozBbsYTGsDQ6n+LTmNJwhn3cg8
 WcykCVqR8O4yeSvhqiW3Qloa6Dgf7LRz4x2f1knnPA+hmnUz6ZdGf46FMq0Ziiv4b5kW
 v56uzZXpFd2basc8actTQOWCM+4oWAr9MsHdmrPOv0tj9Oqw6eVBoJowa+i4YfgCPyWT
 R30w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=HFQLFqYnlTo1lpqJ7D2ypgfrC23LiNE+ZmEwXkcYw0A=;
 b=MoHVxt9+Q7zKIVFyjM1QWpj/EdibSMrFYnUAo+NsKLOfDY8Mz+qA1UDbZRxc0mETwl
 6hNr3t/ve0wRTSpiuf3C6it1lm5ZbSKguxK2ztJKu2M0sbSEmuZq7GNybJXp3nKVDrk+
 GL+MP48TFGIfurE/+KH6xBcHFR2CzHz6Qxo6cUtlQcp8jovSNent3aTxEJPyqMnwuqSs
 zJ/qla4H+lIIey3k5GBoct594ds8Xbb1CJi4FaWyL9H+G3X2FTsI0hGY356wrsc2Gza/
 hX+3dMhP51kpmknw5thCXxDjCg6Hoq3ONIHPZY71EZ+omIw1ggVf3GqvW5VVDw1sWD5p
 1YXg==
X-Gm-Message-State: AOAM531Lka9hd7qq8boIUSJOzE5c+ulZ/OD0vnXXTZV4AXQLhZTawON4
 9rTS/XFhAYYZRA9X/cW4+UGzYxhnzr2p
X-Google-Smtp-Source: ABdhPJypoUwsNuwCxy8ymHAKoR1zqHYLDOPbF+TzYxseet5jGrMrBQsRY36QeoNA7Ahvpckl3UlgU5nhuRXS
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:23a0:2f14:433:e6cb])
 (user=qperret job=sendgmr) by 2002:a05:6214:1021:: with SMTP id
 k1mr17176909qvr.4.1627291766710; Mon, 26 Jul 2021 02:29:26 -0700 (PDT)
Date: Mon, 26 Jul 2021 10:28:56 +0100
In-Reply-To: <20210726092905.2198501-1-qperret@google.com>
Message-Id: <20210726092905.2198501-8-qperret@google.com>
Mime-Version: 1.0
References: <20210726092905.2198501-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 07/16] KVM: arm64: Tolerate re-creating hyp mappings to set
 software bits
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

The current hypervisor stage-1 mapping code doesn't allow changing an
existing valid mapping. Relax this condition by allowing changes that
only target software bits, as that will soon be needed to annotate shared
pages.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b5ca21b44b6a..93cc9de4d46c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -375,6 +375,21 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 	return 0;
 }
 
+static bool hyp_pte_needs_update(kvm_pte_t old, kvm_pte_t new)
+{
+	/*
+	 * Tolerate KVM recreating the exact same mapping, or changing software
+	 * bits if the existing mapping was valid.
+	 */
+	if (old == new)
+		return false;
+
+	if (!kvm_pte_valid(old))
+		return true;
+
+	return !WARN_ON((old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW);
+}
+
 static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 				    kvm_pte_t *ptep, struct hyp_map_data *data)
 {
@@ -384,9 +399,8 @@ static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	if (!kvm_block_mapping_supported(addr, end, phys, level))
 		return false;
 
-	/* Tolerate KVM recreating the exact same mapping */
 	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
-	if (old != new && !WARN_ON(kvm_pte_valid(old)))
+	if (hyp_pte_needs_update(old, new))
 		smp_store_release(ptep, new);
 
 	data->phys += granule;
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
