Return-Path: <SRS0=c5RA=B6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 097EFC433DF
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:36:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B2BDF20855
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Lz+c7mxE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2BDF20855
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AFEB4B888;
	Thu, 20 Aug 2020 06:35:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zF3JnbwlM2ea; Thu, 20 Aug 2020 06:35:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63EA94B7C7;
	Thu, 20 Aug 2020 06:35:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ECCB4B364
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id thOk5j06MAOd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Aug 2020 06:35:56 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DD1F4B89A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:56 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id c186so801675wmd.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 03:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=74yntT1kxv0J/pTwf0wLv411jMgw/p3nen54ZOSwT/I=;
 b=Lz+c7mxELafLwoUlrK+Akp/7rdHb7L51hH3TPaVfxdgBIhSUiza+hYlLvu5WLVJfpK
 bFwWak/4tKuFc4+IttRiCiohCMtWhCZvijxLhYMklXvAc6v11H44hXqCHJPlWErYng2o
 d25b2Bfoiw733maaNKnyaKObVYfZ2CJSHF9kvsbuCt5NGmS63kZOawr3zpjoBPtP8Icp
 3aAtJqPDrztjcEpD/XuGZXuVebqQ8NfZxbBZxujaB/9hKqgt18DSqdozZpRBEACHXeSA
 ULtkR09bayFTGpDPVcNp5g0Kj4MwJ4P9N20oFjZ98wSPwmpEWJVd9gi7oDPizCZdLc0j
 IZxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=74yntT1kxv0J/pTwf0wLv411jMgw/p3nen54ZOSwT/I=;
 b=tGtKmZ0d9AazTb6S1XBYH+MD5+RopmLiZFwhXExJebMgvud7m/4UoEGu+BwUFlG36d
 KYpprU4vRC3Z2GObE8ywaFFOqItqdDtCd6jQ6jgXDsL+ngRok0n4+DMEvJNu9sCpFyQK
 WIZxbEnXKoZhuTFn4y7e3WAZ9Uxj8i9aWNA79gjzXj2raRXWGODDkOLsbU2g5B+pQNKa
 3UF12XWTaR9jyy+N/kErePgDSVQ4lmgZR4hpH92qcZyvS3uyQuQRtxK98pZni1C3bqLi
 alu6OLeGToPLyU/QizTShUWJDYvA/FoAqLj/6EAs6JEuQcbmdGWpnVWpxcoeM8gByhLD
 HCtw==
X-Gm-Message-State: AOAM530rFwszCXDuU2NCnP6ubzwOk5VxQRXef1VOTWQnQzCxRmPJqmjv
 gsFOaqBQhoQlXqRfUAiHi8nvG9Fb+eSseWdMrt1Q5EIIa/6xfzC8ydVdKIQMGtjfmWkM+AZfwoi
 mVGu2YxbPgwg/8IS8WGTYTn5xvA6O11dwUrHFq8Lwxjx5LK64/Ype1ETfenjoBesJI2ZCfg==
X-Google-Smtp-Source: ABdhPJyXooREtfUVBflBDIpWZ6Vxt5EN9/e5jMZ4iaiI6lNPkYgQor6CWClHFKJILCEcgG/9dfwM2UolGiA=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a05:600c:c3:: with SMTP id
 u3mr1389280wmm.1.1597919755166; Thu, 20 Aug 2020 03:35:55 -0700 (PDT)
Date: Thu, 20 Aug 2020 11:34:42 +0100
In-Reply-To: <20200820103446.959000-1-ascull@google.com>
Message-Id: <20200820103446.959000-17-ascull@google.com>
Mime-Version: 1.0
References: <20200820103446.959000-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v2 16/20] KVM: arm64: nVHE: Pass pointers consistently to
 hyp-init
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 maz@kernel.org, Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
 will@kernel.org
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

Rather than some being kernel pointer and others being hyp pointers,
standardize on all pointers being hyp pointers.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/arm.c               | 1 +
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0e3bdb7cb9d0..3f5d00167674 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1278,6 +1278,7 @@ static void cpu_init_hyp_mode(void)
 
 	pgd_ptr = kvm_mmu_get_httbr();
 	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
+	hyp_stack_ptr = kern_hyp_va(hyp_stack_ptr);
 	vector_ptr = (unsigned long)kern_hyp_va(kvm_ksym_ref(__kvm_hyp_host_vector));
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index d9434e90c06d..abe885e26fe2 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -114,7 +114,6 @@ alternative_else_nop_endif
 	isb
 
 	/* Set the stack and new vectors */
-	kern_hyp_va	x1
 	mov	sp, x1
 	msr	vbar_el2, x2
 
-- 
2.28.0.220.ged08abb693-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
