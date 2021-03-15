Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 669CFC433E6
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 07F0D64F56
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07F0D64F56
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F07E4B290;
	Mon, 15 Mar 2021 10:36:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G+jQH0bwwhLH; Mon, 15 Mar 2021 10:36:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 799344B6DB;
	Mon, 15 Mar 2021 10:36:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 573824B6DC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a+EEqqMLD4AT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:36:42 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FC0B4B6E7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:42 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id jx11so23037091qvb.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=N5s0/RbCYhUO0g3Zm7KUzHx7P+K05LDC1HPuvdfEh+U=;
 b=Zsr83XwouEaIFsOmKQebxP45mo30AcyU+79WfY13WWpqz/30q9YdfnTxkyZhfj4VMZ
 5N/PN65sKtqHEJ0F7UO0XwE1vmkX7WtfR826THltDl1QzGmODdsxznZTxGJxLzAu/yzG
 y9RwL/puLSAhwnVRhvMKPNlJawAso9JrVyO4xGrNIXpLUR6kLrUXrcYr49cGvE61PFPf
 FZePHK8+5oT3IAIqvVyfnn5LOye9zY9F3xBDEwVULgG+wtjmJJ9jFJlhz3Nr+lQOKnpP
 t27x2C0hTSaHAYrMf2x4MjJFG86zg9sHfStokpDLnSewSGscu7pYDrp+0JNAcI0xlpwV
 nGtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=N5s0/RbCYhUO0g3Zm7KUzHx7P+K05LDC1HPuvdfEh+U=;
 b=W8OhpcuERBGngEuFbxZgf4+cHelIjJOWipCng1Hgckv4xAkek7F06cD6Cuxd5vSUoe
 i2AnLUqGFsXAujXxccOweB6xbWJ2wqurI3cAQOSVQPx/LV7Nf5wh6KglmJzvu209RuAy
 Hc1V3Fows/NXuGIDLSSYTOWSHeP0Q85ltzw9PMqHGubjIkSvzr/k36Lo2CKIxthL7ile
 bbAARUHLYWf0cOfGzSNmhzplWvrz3fpAo16Zhp4vJfBU70+EbejrjOLSFL4rrfsbkuTt
 e9Dpy3vfihOrkv5jPSEK5s7z3W6NaDVdMNCvGGfXRffD1oKNDcdLV5UstzBCo52za+D1
 y4Bg==
X-Gm-Message-State: AOAM531Y8s1kOK2Cnck8W/5RqoH07ipJtVMZsjAIyC6Zo3tN2JMLXUG5
 pCiPRNdPjYQRnhG1D04k2EJ/FRDYoUCv
X-Google-Smtp-Source: ABdhPJwsW3+UISmJa1GuCOTEPA/v4H+6KrK3TX2T8OvR6HABWCt5lvp9HyL96vdBHaY+aTq+PjSpuKjXnCOH
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:ad4:472d:: with SMTP id
 l13mr11032486qvz.17.1615819002072; Mon, 15 Mar 2021 07:36:42 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:30 +0000
In-Reply-To: <20210315143536.214621-1-qperret@google.com>
Message-Id: <20210315143536.214621-31-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 30/36] KVM: arm64: Refactor the *_map_set_prot_attr()
 helpers
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

In order to ease their re-use in other code paths, refactor the
*_map_set_prot_attr() helpers to not depend on a map_data struct.
No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index bd44e84dedc4..a5347d78293f 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -324,8 +324,7 @@ struct hyp_map_data {
 	struct kvm_pgtable_mm_ops	*mm_ops;
 };
 
-static int hyp_map_set_prot_attr(enum kvm_pgtable_prot prot,
-				 struct hyp_map_data *data)
+static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 {
 	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
 	u32 mtype = device ? MT_DEVICE_nGnRE : MT_NORMAL;
@@ -350,7 +349,8 @@ static int hyp_map_set_prot_attr(enum kvm_pgtable_prot prot,
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
 	attr |= KVM_PTE_LEAF_ATTR_LO_S1_AF;
-	data->attr = attr;
+	*ptep = attr;
+
 	return 0;
 }
 
@@ -407,7 +407,7 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 		.arg	= &map_data,
 	};
 
-	ret = hyp_map_set_prot_attr(prot, &map_data);
+	ret = hyp_set_prot_attr(prot, &map_data.attr);
 	if (ret)
 		return ret;
 
@@ -500,8 +500,7 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	return vtcr;
 }
 
-static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
-				    struct stage2_map_data *data)
+static int stage2_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 {
 	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
 	kvm_pte_t attr = device ? PAGE_S2_MEMATTR(DEVICE_nGnRE) :
@@ -521,7 +520,8 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
 
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
 	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
-	data->attr = attr;
+	*ptep = attr;
+
 	return 0;
 }
 
@@ -741,7 +741,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.arg		= &map_data,
 	};
 
-	ret = stage2_map_set_prot_attr(prot, &map_data);
+	ret = stage2_set_prot_attr(prot, &map_data.attr);
 	if (ret)
 		return ret;
 
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
