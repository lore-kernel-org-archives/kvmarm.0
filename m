Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A059EC4338F
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 41E316101D
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 41E316101D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D73A34B0EA;
	Mon,  9 Aug 2021 11:25:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5PGlYA97Uo-x; Mon,  9 Aug 2021 11:25:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0AF04A32E;
	Mon,  9 Aug 2021 11:25:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A66374A2E5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:24:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UMP9tC2WFcni for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 11:24:58 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A3944B0DE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:24:58 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 y12-20020adfee0c0000b0290154e82fef34so1220762wrn.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 08:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=g0Tec8zCIIV6B7UFt/na0xdI02dI+qYcG36GmUIxQNs=;
 b=u/8T1pZALwA4/sFdX62scy5dCtljsLkrBi8I1Wo5YlC53+ou/YjrvDL8JNsEIB71bE
 LRivkMFVgCH0BtjYzhigCs/bBsZnzm1aZdrrbJrAhXN2dDwjESl94VxP5qszcWj4CCEd
 kb6ZNqQAPWs3owfE5gBV3uIxdOads4TKkeSBC+CEa86jU1FkSsXByuLM+TGmtl+JwI1s
 V5+s+6x3trNBHDLQF9LXi2sMfrQr2qHgz74SlBLo1h0tqRcsn8LkQJbmZFl6TVJkfNSa
 l+1c8KgXcM3JN+xcOybD93Qo/Y8JcdC1KdNJjrp98+bqF+lnmdb8LFXpm1F/xsbnlAZG
 wATw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=g0Tec8zCIIV6B7UFt/na0xdI02dI+qYcG36GmUIxQNs=;
 b=VK2+iebZozAkdyjo1ersPBEPrFCUlbVA8z3YIRG+II+vw0DheO6l4+SR2WG8j70ydD
 ujlwFK283zj15IVPOiK3HrshtJ6MQq7pidUt2lPfaGtgYbr+HCoDUvinjzKorqu1rufY
 LmApytyQ1WeXc8EMJ7OB6FxrErDA+RXc7qp2VaVTYKj/6X0U37h8xQQsNjcal2ZJvCUe
 uvZ3DHPsrUk+US1DYMHOs4hRZyAjKtvMcLnkMr9kaK0+SMyBYDni7r11rbiSr4KrVjSK
 zSdufTSH+O0bM7GuleWja2wFZpF/mEluRRduLO8obxymdmgXtW0hhYzFvhbpUmQb5+YU
 3i5g==
X-Gm-Message-State: AOAM532cXO2zsRgEG4b6i8OQxEwMoWdJPNMF/kZqXRkYY2UGqk8wdvWp
 QLUXPRtaTa0nIvrGc8MsNbAUdZiTt9kV
X-Google-Smtp-Source: ABdhPJwdhbneOWgiW5/bK5oKtxthf7W2lS34xOPxnKsvszEVciXZLPa8/F4hD9ZjXEHPO3uTXXdiY7U47vX5
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:b0e8:d460:758b:a0ae])
 (user=qperret job=sendgmr) by 2002:a05:6000:232:: with SMTP id
 l18mr25664566wrz.24.1628522697474; Mon, 09 Aug 2021 08:24:57 -0700 (PDT)
Date: Mon,  9 Aug 2021 16:24:30 +0100
In-Reply-To: <20210809152448.1810400-1-qperret@google.com>
Message-Id: <20210809152448.1810400-4-qperret@google.com>
Mime-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v4 03/21] KVM: arm64: Provide the host_stage2_try() helper
 macro
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

We currently unmap all MMIO mappings from the host stage-2 to recycle
the pages whenever we run out. In order to make this pattern easy to
re-use from other places, factor the logic out into a dedicated macro.
While at it, apply the macro for the kvm_pgtable_stage2_set_owner()
calls. They're currently only called early on and are guaranteed to
succeed, but making them robust to the -ENOMEM case doesn't hurt and
will avoid painful debugging sessions later on.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 40 +++++++++++++++------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d938ce95d3bd..74280a753efb 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -208,6 +208,25 @@ static inline int __host_stage2_idmap(u64 start, u64 end,
 				      prot, &host_s2_pool);
 }
 
+/*
+ * The pool has been provided with enough pages to cover all of memory with
+ * page granularity, but it is difficult to know how much of the MMIO range
+ * we will need to cover upfront, so we may need to 'recycle' the pages if we
+ * run out.
+ */
+#define host_stage2_try(fn, ...)					\
+	({								\
+		int __ret;						\
+		hyp_assert_lock_held(&host_kvm.lock);			\
+		__ret = fn(__VA_ARGS__);				\
+		if (__ret == -ENOMEM) {					\
+			__ret = host_stage2_unmap_dev_all();		\
+			if (!__ret)					\
+				__ret = fn(__VA_ARGS__);		\
+		}							\
+		__ret;							\
+	 })
+
 static int host_stage2_idmap(u64 addr)
 {
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W;
@@ -223,22 +242,7 @@ static int host_stage2_idmap(u64 addr)
 	if (ret)
 		goto unlock;
 
-	ret = __host_stage2_idmap(range.start, range.end, prot);
-	if (ret != -ENOMEM)
-		goto unlock;
-
-	/*
-	 * The pool has been provided with enough pages to cover all of memory
-	 * with page granularity, but it is difficult to know how much of the
-	 * MMIO range we will need to cover upfront, so we may need to 'recycle'
-	 * the pages if we run out.
-	 */
-	ret = host_stage2_unmap_dev_all();
-	if (ret)
-		goto unlock;
-
-	ret = __host_stage2_idmap(range.start, range.end, prot);
-
+	ret = host_stage2_try(__host_stage2_idmap, range.start, range.end, prot);
 unlock:
 	hyp_spin_unlock(&host_kvm.lock);
 
@@ -257,8 +261,8 @@ int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end)
 		return -EINVAL;
 
 	hyp_spin_lock(&host_kvm.lock);
-	ret = kvm_pgtable_stage2_set_owner(&host_kvm.pgt, start, end - start,
-					   &host_s2_pool, pkvm_hyp_id);
+	ret = host_stage2_try(kvm_pgtable_stage2_set_owner, &host_kvm.pgt,
+			      start, end - start, &host_s2_pool, pkvm_hyp_id);
 	hyp_spin_unlock(&host_kvm.lock);
 
 	return ret != -EAGAIN ? ret : 0;
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
