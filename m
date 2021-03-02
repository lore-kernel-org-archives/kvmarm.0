Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C603C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:01:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BDC9C64F37
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:01:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BDC9C64F37
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 578824B664;
	Tue,  2 Mar 2021 10:01:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LI7Rt8+drpqf; Tue,  2 Mar 2021 10:01:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42FA24B688;
	Tue,  2 Mar 2021 10:01:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32F8D4B687
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:01:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zIGrzfAtqqdt for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 10:01:09 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EDCA24B645
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:01:08 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id v1so715350wru.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Mar 2021 07:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=MUiu5cL4XJy7bcbjb67w8AVccQ6swyc7cTqk7H/pito=;
 b=V2tQz8JIPctM0p8zJgSN56SE2f+sjG4GB6ZR55LMQiswnxYtR/ePVhbwO/o8W66G0b
 PbHVynwDMo4m5hQTkVbwHPUN6c0PkFKQE/sf5DH5nMyM0tggxmbD3FPQjbi6a0POeCz+
 jh+2Nsxcsol/OZxoAVv6MqFZjCqNUXiv4O8MXjSVu9i+FDKGBgulOa9tkVjyrYK5Z9Bd
 Nq67f+OAletST31RgOjWXRR0vHMxg7CzWFcXeOoLWmi9Q4vWw9Jmfj0fTHu7FSTjC0o5
 F2L8XjgbG6jShJL/W0Af7NMKKMKboklNsvT6OliD+fo6afqsvX1EexCiNHhJOW3b0KIF
 4qmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=MUiu5cL4XJy7bcbjb67w8AVccQ6swyc7cTqk7H/pito=;
 b=owhdRwhkoU7DBRIP8voi8npVITxUS0XGqke4+jo9fSjIgG3M8k4+x+pH3vB809zot5
 1bPmJXF72lxVEXJDp7Blsiads4Ep2q7kWHEBXn4Bz3mkuLXbYZ378SfcHH2+hQsTXywA
 5i+uhjYvA95ZT5//VaoKX8ciLiBrX+21/xZPbATWoGHAZlobuu9TS4WrA/8LY7IygJp/
 dL8LTY29Y1mjK5/KaHyneA33D5fGFuou2swN8yJeZy/WmnEMaOzZGm02SrK3OH/hmgvG
 0wJkbcu6DM8UW/fCCglp3J5aiJlfqcHzyr5nLfsw+/JU2dJ25dbmXq0nS+ijbazBEhIb
 7etQ==
X-Gm-Message-State: AOAM530qAKkV0IAO+BfKBWJfLKTYV9uJnL1Si3XjBudmY+2BdkUbPoo5
 rwZUSFgO0FTN2xw4YMZBQ1BwiemCayY5
X-Google-Smtp-Source: ABdhPJz9F9KFBBfsTkBPKASwdRvs8WkwjMfKCJcm0vk7lvPEyGjjf4UWYBSGhgGbD6PbV21B/moA66tRIrG2
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a7b:c18e:: with SMTP id
 y14mr495903wmi.1.1614697267665; Tue, 02 Mar 2021 07:01:07 -0800 (PST)
Date: Tue,  2 Mar 2021 14:59:57 +0000
In-Reply-To: <20210302150002.3685113-1-qperret@google.com>
Message-Id: <20210302150002.3685113-28-qperret@google.com>
Mime-Version: 1.0
References: <20210302150002.3685113-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v3 27/32] KVM: arm64: Refactor stage2_map_set_prot_attr()
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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

In order to ease its re-use in other code paths, refactor
stage2_map_set_prot_attr() to not depend on a stage2_map_data struct.
No functional change intended.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 8e7059fcfd40..8aa01a9e2603 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -494,8 +494,7 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	return vtcr;
 }
 
-static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
-				    struct stage2_map_data *data)
+static kvm_pte_t stage2_get_prot_attr(enum kvm_pgtable_prot prot)
 {
 	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
 	kvm_pte_t attr = device ? PAGE_S2_MEMATTR(DEVICE_nGnRE) :
@@ -504,15 +503,15 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
 
 	if (prot & KVM_PGTABLE_PROT_NONE) {
 		if (prot != KVM_PGTABLE_PROT_NONE)
-			return -EINVAL;
+			return 0;
 		attr |= KVM_PTE_LEAF_SW_BIT_PROT_NONE;
-		goto out;
+		return attr;
 	}
 
 	if (!(prot & KVM_PGTABLE_PROT_X))
 		attr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
 	else if (device)
-		return -EINVAL;
+		return 0;
 
 	if (prot & KVM_PGTABLE_PROT_R)
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
@@ -523,9 +522,7 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
 	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
 
-out:
-	data->attr = attr;
-	return 0;
+	return attr;
 }
 
 static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
@@ -708,9 +705,9 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.arg		= &map_data,
 	};
 
-	ret = stage2_map_set_prot_attr(prot, &map_data);
-	if (ret)
-		return ret;
+	map_data.attr = stage2_get_prot_attr(prot);
+	if (!map_data.attr)
+		return -EINVAL;
 
 	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
 	dsb(ishst);
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
