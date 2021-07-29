Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D91ADC432BE
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6514660F23
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6514660F23
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B0AA4B0F2;
	Thu, 29 Jul 2021 09:28:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BfUk5nhBQxYG; Thu, 29 Jul 2021 09:28:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8BAE4B0D6;
	Thu, 29 Jul 2021 09:28:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB0394B0C2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gw9dByY++nd0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 09:28:30 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 036CE4B0B5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:30 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 v19-20020ad455530000b029032620cab853so3931419qvy.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ATiyLC5m+9bmdBYcDBkPgetNyCcHjVe1BNbOPK3Xa6Q=;
 b=OqRh2DivWRwS1PBtKegpyfDBYkMloX5jagqHe1vyeZJWSLQKdZRgp2d+xwx0GJIkQW
 QZ2QSanSfxgy9Wce9m9rmjL3UA1sTmhe2tgCos0VPpCxjlLtM0IGduNpJprR59Tu2CT+
 cIR1sequ0SyiSX6FhZl8dyIBIA11l5qUpOPwKsxeuIYoU2ZpHynVwaJOe+G3r8ykGWFo
 gdbjk7UlL1nYQ6wR9CGXdTP8kBswWWKumbD5kUNfvKtWm1So6t8OXteOZkdFy5HrMy0A
 3WECcSIO9ofZeH5sX4UUWEpcnFCrYOUdZwNbYRPL2dxux0HVY+y7WPY5DaUP47qFAmP6
 yjQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ATiyLC5m+9bmdBYcDBkPgetNyCcHjVe1BNbOPK3Xa6Q=;
 b=OX+5ixSLgK9/frjfIBaB5aHvecuOiBDBj1eh+E7Yy1xq+nsexDbfHtyVMI8r9m4mPF
 ZcJ3sRgXWpS2KDM8NSnXSfvBMWk4DrN9Be7SAtNpzY0W/G6pcUzHw8X6SoRJoNhQsahn
 iUFgqjyBi+MZ3K2RWLdGHU08mI7KVLGzpmFNnEqx3KRLGZah0ckCS9584DpU9aKWZcXP
 hWo2j90SoJuWx6/uL8ZmzT9M3vgFu0hqcTYqirxGBWubMsgbnmzYT7GZvGvLSmTjOLAo
 WgsK/SH1BOG9cGbYNpInnEpn3gTwRqiFenXe3Wd/092LtYLwdkADNV/H3frPyvXuZ37p
 Mz+Q==
X-Gm-Message-State: AOAM531FXrxyIo0r+JPypTtSVQyLKlIDcpgLnubkQJeNqbG5Uss1Ktdj
 89MeFqjRzEyof9pufnunOTFmuTDa9OqZ
X-Google-Smtp-Source: ABdhPJyvj7S5X1fDRFz1PU5wtUnJrRchL+QMKuVeP46VjzReAMKnCpUDVjPlF/qwJy6z74GCRKY+6nq3HeHT
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:293a:bc89:7514:5218])
 (user=qperret job=sendgmr) by 2002:a05:6214:501d:: with SMTP id
 jo29mr5191775qvb.43.1627565309560; Thu, 29 Jul 2021 06:28:29 -0700 (PDT)
Date: Thu, 29 Jul 2021 14:28:00 +0100
In-Reply-To: <20210729132818.4091769-1-qperret@google.com>
Message-Id: <20210729132818.4091769-4-qperret@google.com>
Mime-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v3 03/21] KVM: arm64: Provide the host_stage2_try() helper
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
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
