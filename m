Return-Path: <SRS0=IpCr=AY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1164C433E6
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 21:05:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA68B2068F
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 21:05:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="K97DDxmR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA68B2068F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 654934B168;
	Mon, 13 Jul 2020 17:05:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jjtccb4zJxG2; Mon, 13 Jul 2020 17:05:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33A544B1D8;
	Mon, 13 Jul 2020 17:05:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E3304B1D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 17:05:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KOGerey7nCjl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jul 2020 17:05:19 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E8CE4B1E4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 17:05:19 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id j5so18815186wro.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 14:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=OvFAL+tQeN0zKpW+0+1MWQelVJ3r/UfMG8HwbV8rwTU=;
 b=K97DDxmRIpB6AErDqPCVxCFHUkeJBV7lwv0rNF/FEKwF3LQs89YyWNrXP3EXIYPocn
 EpaUwCRrc5YG7sSXg1LJ8HKFB6HkFs+umM5ms55HhnNtnDmYdBXVWwq1Vc+PvaSjV9E/
 pLxzfrU3krLPcojb29oIyANQwKliPlrRc6GiT4OvLbFjB1XU6pe7G9zHjZnazS5QedWR
 MGhN2Hzq2o/92Pn9gMlV12HATcOgp6Zmju2OX4B3c+QhDydK+4jKGYsUnejC9Z9UbLpZ
 vwWpx7tWoNRdlWfEDbRWb2TiArjnliqUiwTKiIlVii/eBk1Wk29gDrbpaO+Rmhtrw2FY
 lRyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=OvFAL+tQeN0zKpW+0+1MWQelVJ3r/UfMG8HwbV8rwTU=;
 b=TQkDMb+r2IgxAHNu2PUHy5e7nu+6KHzCTOfcfe/Gk3zDeBsNbOJvI3HfXkHHz9qXLR
 uuv713Y4DESUJKp5yFysD3pDeEdqSiTW6AtwLTfhu3iuXInfopM0fTjpzYzzYoqlPvvA
 ajVSjyUXDaO/iWQWCNqEN/9JOVe1d257cEkwE6ewxXBn3Z77OvdiW9GI7EYBT9cRzmNi
 EXQuRaq31AaVDv5EnTA6txUA0aRwj3ELzNNRT23SBZubqBC0a9UdjyO32V4r47GbMtkB
 hVHGPMC3fTPq+72hHwmdTnlQVFQ3j+J80JJ8Q89H5FhtqUSfjDVNAYHiIFsSU3IexPDP
 8NHA==
X-Gm-Message-State: AOAM530wfoGGt2c5CrAzHVt7qu68beJCuimezOy4Kr4MxuZy1m1BwyPI
 r5Hm+LXh8NO+cmhK8mRjQ49NOdNs//K827A0OtwjHejDRjYOg6jIZ3HJaoFTF/IBPpoMSn3EKfN
 /gYVqxugq+b1dvGSLB95UcZCpp0yqONsbcq3NpzQ4t9Ck/Sj+dsyu80PDKEStUi+fRzxzBA==
X-Google-Smtp-Source: ABdhPJwyk9NWFgpLvy1Sj1iuPaqaoyrI8/eMH4rZIwmm1YnCTZeNoX51n/JshBS7mCzriccSmU88KB9sBLM=
X-Received: by 2002:a1c:4406:: with SMTP id r6mr1141828wma.161.1594674318772; 
 Mon, 13 Jul 2020 14:05:18 -0700 (PDT)
Date: Mon, 13 Jul 2020 22:05:05 +0100
In-Reply-To: <20200713210505.2959828-1-ascull@google.com>
Message-Id: <20200713210505.2959828-5-ascull@google.com>
Mime-Version: 1.0
References: <20200713210505.2959828-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH v2 4/4] KVM: arm64: Stop mapping host task thread flags to hyp
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com, dave.martin@arm.com
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

Since hyp now doesn't access the host task's thread flags, there's no
need to map them up to hyp.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 --
 arch/arm64/kvm/fpsimd.c           | 11 +----------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1a062d44b395..fb0dfffa8be1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -24,7 +24,6 @@
 #include <asm/fpsimd.h>
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
-#include <asm/thread_info.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
 
@@ -320,7 +319,6 @@ struct kvm_vcpu_arch {
 	struct kvm_guest_debug_arch vcpu_debug_state;
 	struct kvm_guest_debug_arch external_debug_state;
 
-	struct thread_info *host_thread_info;	/* hyp VA */
 	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
 
 	struct {
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 2779cc11f3dd..08ce264c2f41 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -27,22 +27,13 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
-	struct thread_info *ti = &current->thread_info;
 	struct user_fpsimd_state *fpsimd = &current->thread.uw.fpsimd_state;
 
-	/*
-	 * Make sure the host task thread flags and fpsimd state are
-	 * visible to hyp:
-	 */
-	ret = create_hyp_mappings(ti, ti + 1, PAGE_HYP);
-	if (ret)
-		goto error;
-
+	/* Make sure the host task fpsimd state is visible to hyp: */
 	ret = create_hyp_mappings(fpsimd, fpsimd + 1, PAGE_HYP);
 	if (ret)
 		goto error;
 
-	vcpu->arch.host_thread_info = kern_hyp_va(ti);
 	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
 error:
 	return ret;
-- 
2.27.0.383.g050319c2ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
