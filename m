Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD2CC433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DE27E208B3
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="aLacCg2v"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE27E208B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A8E84B1DD;
	Thu,  3 Sep 2020 09:53:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x1+Z3rKk1SEe; Thu,  3 Sep 2020 09:53:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3F214B280;
	Thu,  3 Sep 2020 09:53:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50EAF4B14C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sJ2x1VN4L+xm for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 09:53:47 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 382094B300
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:47 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id l67so2898640ybb.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2020 06:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=4iP/0UmEC3+yJOjmYc8EWVC/sjbrwx1IUcG157f2HaQ=;
 b=aLacCg2v86hUnmf7odV/s5z/WAbRXvfyamfg7rnFPyJ0c/AHAKFrNblQS/fgSB/ADY
 A9sP3/R4n9SEbVvduYpp+0MFCoPjIVgZcs6lJy5QEM9Yc3qf2FN6pWSH5QvdS3UWxbLQ
 mF3Ye2t2/OkpzyifnZjywJToU0kyuZFZdvGy3N9NDBX0TzrKASbz1u0JLN9EepS+VNhh
 qb3I2rUipw8AKHuLwvfMXzOxixwN58bkmXFIViVmkc6y41aBhclNvE9VESvtX7S6ORQF
 eYSLOt+17oIAkdySsgqNRt4S5RV/OHHcWHjTmY0xoEsrky1C/3s0GgScRt37729gkU5t
 tWNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4iP/0UmEC3+yJOjmYc8EWVC/sjbrwx1IUcG157f2HaQ=;
 b=KrIxIrDcuH4s1BpBkba4hWpGWotE2U9xbFmfREK0XZ751uaP3aRmsmfjsARPrEyCXF
 KiY77cY0drsdFEP2H0faK3FMWOi4Yx9vT2AViav63lthERPPNMNvjkn6sA0LkaGt/h2l
 deqf93rXc/apasdzXOXeU8sdHGqmuVHa9fHAtz9Zpi55bbBV/1mGp+b0ANfP1z08rvC2
 YMe1+j+yI8223ueQEn7i81zc+TVrgH4tfx2rAq9k5YWagj02m+mgXCRo0BEgH90JvUlL
 /v1xiAAEgGjSWDJv051ACRokdh5Iu7Yz9EZ3SQP9lcBvEb+83I8Vx9HC8rPGtK8BfitK
 I6HQ==
X-Gm-Message-State: AOAM530ymOI83/4xjHREIitGbikHIssOPuqF66zs5J5Ucj8D0J0tu+1o
 teLDI+T+8tmYw4FXCSr62z7dyIShOIcZHqwJjfoS5UIJuaN3vFhoS/tyTbhNCp5tVr/KYBbsDfC
 XROx7ql6sF6x3SzZLTcLPvP/Bsiv3rp1rn04jSxVi0snE79PlApdH5l6Deh4MqrM3somRyw==
X-Google-Smtp-Source: ABdhPJxRFkOJikYMz+BDwt8BKYMA4bhps+QNVk7nAdKaPI6HmB+eD97tWpk67Ge43bFov2pZjNujt2Ge5eU=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a25:3891:: with SMTP id
 f139mr2838638yba.174.1599141225490; 
 Thu, 03 Sep 2020 06:53:45 -0700 (PDT)
Date: Thu,  3 Sep 2020 14:53:04 +0100
In-Reply-To: <20200903135307.251331-1-ascull@google.com>
Message-Id: <20200903135307.251331-16-ascull@google.com>
Mime-Version: 1.0
References: <20200903135307.251331-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH v3 15/18] KVM: arm64: nVHE: Pass pointers consistently to
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
index ae4b34f91e94..6b7180072c8d 100644
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
2.28.0.402.g5ffc5be6b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
