Return-Path: <SRS0=fiTO=MS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA21C4320A
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 529F360F4C
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 529F360F4C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 065704B086;
	Mon, 26 Jul 2021 05:29:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N7pLX8ZJHdAL; Mon, 26 Jul 2021 05:29:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9A264A522;
	Mon, 26 Jul 2021 05:29:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0116949F5D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wA60MwoNKByb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Jul 2021 05:29:16 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D57EC49E93
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:15 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 r14-20020a0c8d0e0000b02902e82df307f0so7906457qvb.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 02:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=SklhMqwq/2h4UO2xk/TmhlS4/BSmhG4vZDkK4FOF1kk=;
 b=LcLE/Jxwj2rOGbqgdQiy58nAwXiFuJnR0+9TqiIE8hs+Iyxf9iUvWeng8nwkqOFgWB
 BuOc+xFO+Gucu5aszLn/tMe2JBUDM0tc2WMztZaRwSiTi0Z4dI7WRe4nF1DGw2Ada5mQ
 EJsy1NU9tzqDQEMIt0kQYVRgSEktTdB91LYl0+Z47z30mnDwuEWgGlbsuqbVEr+rmgwo
 WUV8b9MRyYMu/8EWYGeJZ2scufoqME6mhLaF+TJYVQIj6VnxRKpweuJnPiv8LSh/Uy7l
 v+NIhechSjHyaVP7EIEbLZpQNJ+rJ7CFadROzDvvnI3yU16amLsOWHV/8yMYGz9H3HUz
 fFZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=SklhMqwq/2h4UO2xk/TmhlS4/BSmhG4vZDkK4FOF1kk=;
 b=VxDV0PAZ/eS99eeuhLtmVTU0UXpHLq0kfFDLuNAPFRc/SjLYjFm2WaX8x8gckZxD8s
 8jGNRrsYUmB+wl2/e+6iSVTSvqt0EtYihwuakLr1p9j61cxClUHRnm43BceI9YybhOxS
 LEPdRH0xWzcVWGiPPdTnfg58u2hpg77rn8jOPovbCrdpdvL0+w0Qctuj8uhMS0PB9Qqq
 DKW8BaV5yNkUnSzBniQzd5WooeQaqdYRX+0PC++YkmmGHjWq5L0zwsenKjswvUe9hbVW
 x57DxXb9yk8DE5idNzTruoFmLQUKZ7ldXW7xLipQny0mvbqPDCQgJYR3sHjKiroPMIw8
 lRGQ==
X-Gm-Message-State: AOAM533KGpZ6/FuZe88SJiVtj7+mps2Cy9/vh47kVG8p5HqCXjGTewyd
 9kOtV72T6MKp74+KlDWr6l/+1cf1CF0j
X-Google-Smtp-Source: ABdhPJyogngKNGamlr33/F+qdMicL+YqDoeMIdDoBqR2/1/6VaABd58xqeW5MV1R2hLXiW7ahS2yx7ibByaj
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:23a0:2f14:433:e6cb])
 (user=qperret job=sendgmr) by 2002:a05:6214:ca5:: with SMTP id
 s5mr16960121qvs.58.1627291755454; Mon, 26 Jul 2021 02:29:15 -0700 (PDT)
Date: Mon, 26 Jul 2021 10:28:51 +0100
In-Reply-To: <20210726092905.2198501-1-qperret@google.com>
Message-Id: <20210726092905.2198501-3-qperret@google.com>
Mime-Version: 1.0
References: <20210726092905.2198501-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 02/16] KVM: arm64: Provide the host_stage2_try() helper
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
index d938ce95d3bd..871149246f5f 100644
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
+ *
+ * Must be called with host_kvm.lock held.
+ */
+#define host_stage2_try(fn, ...)					\
+	({								\
+		int __ret = fn(__VA_ARGS__);				\
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
