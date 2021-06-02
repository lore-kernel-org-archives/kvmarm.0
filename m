Return-Path: <SRS0=fRMP=K4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A6B5C47097
	for <kvmarm@archiver.kernel.org>; Wed,  2 Jun 2021 09:44:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CE4C9613DC
	for <kvmarm@archiver.kernel.org>; Wed,  2 Jun 2021 09:44:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE4C9613DC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80D724A1A7;
	Wed,  2 Jun 2021 05:44:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iuZ1rMR7M-qr; Wed,  2 Jun 2021 05:44:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ADDD4A522;
	Wed,  2 Jun 2021 05:44:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54C8B406E0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 05:44:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tqha1Lr0nkfM for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Jun 2021 05:44:09 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A4A344A19F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 05:44:06 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 a24-20020a05620a1038b02902fa6ba180ffso1264724qkk.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Jun 2021 02:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=6BW7fDsTteROuo6K5BqDbcxWDf5UHuxhaiKaGg5d2Mc=;
 b=T6g1G1dBfUxc5a4uRyN0WITPLWnvNi8vRjaU0WxUeXxRylqlrnTDVZ76WleGEclLOB
 bFAArsvkYHz97FjuhdnCCh+WEkLIwWDbGPN8HcQ78O37UJm4EoCDSqpQXeqPvmiYy6nr
 yIq1GGdZJktTkGB8wQ4EBTglMjSXseqlhcwtjeBXe9GBq8u46ny++nQ2E4bWDjknAAve
 2U2O/hlxHUJkYkpUskkdnrYRyPf0c1V6lmQnl8jnqVfGA3zTVMsoKNxQl4+tCdCbeRIj
 UPVn2XdYfC7UcpIUefZVUauC2ueC83iZpRd9bxE+tL/DUwpCrqaQCV3dz1x9aDI/G7rx
 MDvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=6BW7fDsTteROuo6K5BqDbcxWDf5UHuxhaiKaGg5d2Mc=;
 b=TzIvb8K08PmLlOUqDBXQbG4+Z6Cut8fKlHm4W/HHYUmYHMwX2vMK4g7wl15LnY0Cd5
 +EEsQw06r6viPeV5Qry9WGkWYqBdi3an8qqj7umDcRzCM0VbRDxDVdgxMfLpN+DP/do4
 jfWkGQFwfoBL+xMyQSHQg2IKwKlMHTQINVrPQSimMZYQaYSsYdzTtxTpIihCv0QAKZkC
 cfyX/isJGcy5tKEX5uMyW0MZNLaUj4HtcFSW4tdTXibCJq7kWIFaqgdtaLzBha7ZDnGR
 TJ9cjWOg8uzY9vL50x8ZARr08gwy7tBo5IMFDxq7I6zPTSoFOYoJxi6rWN66n4z12unV
 CCMw==
X-Gm-Message-State: AOAM530tOmB1c/C2swgSX9AHJIJjEAKcM8IifuJO1XtTRmgfcWsLd67L
 YoDT4QpnG/IlHTwv03GNjO8jAmTBJ2LT
X-Google-Smtp-Source: ABdhPJxl+MLQjn8yPrKOU2bQi1i+tyBz/2Fy9EQ5GBW0rZbYDu246jiWjDU3i6n0uX5Qndx78NtlHv8adJah
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:e8cd:: with SMTP id
 m13mr6368320qvo.52.1622627046193; Wed, 02 Jun 2021 02:44:06 -0700 (PDT)
Date: Wed,  2 Jun 2021 09:43:47 +0000
In-Reply-To: <20210602094347.3730846-1-qperret@google.com>
Message-Id: <20210602094347.3730846-8-qperret@google.com>
Mime-Version: 1.0
References: <20210602094347.3730846-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
Subject: [PATCH v2 7/7] KVM: arm64: Use less bits for hyp_page refcount
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, will@kernel.org, james.morse@arm.com, 
 alexandru.elisei@arm.com, catalin.marinas@arm.com, suzuki.poulose@arm.com
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

The hyp_page refcount is currently encoded on 4 bytes even though we
never need to count that many objects in a page. Make it 2 bytes to save
some space in the vmemmap.

As overflows are more likely to happen as well, make sure to catch those
with a BUG in the increment function.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/memory.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 3fe34fa30ea4..592b7edb3edb 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -8,7 +8,7 @@
 #include <linux/types.h>
 
 struct hyp_page {
-	unsigned int refcount;
+	unsigned short refcount;
 	unsigned short order;
 };
 
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index be07055bbc10..41fc25bdfb34 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -146,6 +146,7 @@ static struct hyp_page *__hyp_extract_page(struct hyp_pool *pool,
 
 static inline void hyp_page_ref_inc(struct hyp_page *p)
 {
+	BUG_ON(p->refcount == USHRT_MAX);
 	p->refcount++;
 }
 
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
