Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7637BC433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 05D9064F36
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05D9064F36
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 961734B613;
	Thu,  4 Mar 2021 06:55:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YBPSfnQSJ5Gd; Thu,  4 Mar 2021 06:55:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EB1B4B637;
	Thu,  4 Mar 2021 06:55:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAB244B4DC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ka5nyozkc+HX for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 06:55:21 -0500 (EST)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 51CF44B4F0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:21 -0500 (EST)
Received: by mail-qt1-f201.google.com with SMTP id j25so15427584qtv.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Mar 2021 03:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=UUJN2Q5WluHa1Ll2+7p/Qu05jL40zhrFUlZue6KcZG8=;
 b=ZJdhYidQWtQV/SvvWf4iw/cFMWWqYO5MQT0a0jd9f4TK+OI6xhTI6OxnaH4uA90hJz
 f5YCFTLeVfY/aiTG9cdlJqp/tesrPPMFm6sQiDdg+U6LfRWpVkV06nRpJ9LjiqRr74l8
 sSdkkJRCCdcEURAOZVgbxI8lnnk+pgqOdOvkMR6pwOE7+9w49IZs5tMLsJ6tiSjK9wOq
 7gU0X1B13FUebwYSDjqhYjkNXsLK7VScAy1/7QMxUEFEk9lyTm0mFVJJwFbdI7kUrQED
 4G0oCly99OivF/v4kSE3Z3e5pkq2O+JPIOiMAJRyrDe4dPhg/9elHqtG4NyQzTmKaVBX
 07bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=UUJN2Q5WluHa1Ll2+7p/Qu05jL40zhrFUlZue6KcZG8=;
 b=RZJHY9UC9eK8ATnoI6dBpyWGFvAsRE3zyzpI91Y/I2T7uu2YMxVZaL4St9BKHnVXD1
 coNnn+Tv3VhZi4Rn726mAhcUUAYDG7cURuj3I+YnECzp0S1N7NQ0mW6N7sVyY019mNjs
 rLVSEA7l4WzoIUybosmceVhQImkbWkuLCXQI/8WoUybr97vNBU9uLH8sHrz1qoQiM02a
 qnVemJny9CM5xigyW4lQ3Gk0l2ANN6bKPdgYUPHjIHroTW3Sp00U32tFoy21TPN92Tof
 4aT9vMVX051fW0Gwj2dXMNLID/S+0ct5pEMcRRAYQ2qCws9axHvo0d/AEE2pV2tf7hr5
 0fug==
X-Gm-Message-State: AOAM532ziwr5ZZtRb5KKp+I5PuSLeXtwPegTzlG/db02vYouHg+u2HvD
 gdxMAfwF7W3rZ8Qhv8qgoKKyEFm4Efh4gjGI1RYmzHc3gMilg3lgxSErUflqB9Gyk+JUHwV4U8S
 ARsQBCez0//n2Gs9Y8/fnKa9s2nUnmYFOEQecKH+0sBZLGmuZEKeXM88+akuu2DeewhVxgw==
X-Google-Smtp-Source: ABdhPJyDnIdKbm5cOCEILWYJ2FXL7Ru1Se3FhvxfVdhwgKBHMlYM3DbEZThtffqmOT3iuDDPNY9SImdE9J4=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a05:6214:1909:: with SMTP id
 er9mr3734318qvb.5.1614858920707; Thu, 04 Mar 2021 03:55:20 -0800 (PST)
Date: Thu,  4 Mar 2021 11:54:47 +0000
In-Reply-To: <20210304115454.3597879-1-ascull@google.com>
Message-Id: <20210304115454.3597879-5-ascull@google.com>
Mime-Version: 1.0
References: <20210304115454.3597879-1-ascull@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 04/10] KVM: arm64: Support smp_processor_id() in nVHE hyp
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, Dave.Martin@arm.com
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

smp_procesor_id() works off of the cpu_number per-cpu variable. Create
an nVHE hyp version of cpu_number and initialize it to the same value as
the host when creating the hyp per-cpu regions.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/arm.c              | 2 ++
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 26ccc369cf11..e3edea8379f3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -54,6 +54,7 @@ DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
 DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
+DECLARE_KVM_NVHE_PER_CPU(int, cpu_number);
 
 /* The VMID used in the VTTBR */
 static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
@@ -1740,6 +1741,7 @@ static int init_hyp_mode(void)
 		page_addr = page_address(page);
 		memcpy(page_addr, CHOOSE_NVHE_SYM(__per_cpu_start), nvhe_percpu_size());
 		kvm_arm_hyp_percpu_base[cpu] = (unsigned long)page_addr;
+		*per_cpu_ptr_nvhe_sym(cpu_number, cpu) = cpu;
 	}
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
index 879559057dee..86f952b1de18 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
@@ -8,6 +8,8 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+DEFINE_PER_CPU_READ_MOSTLY(int, cpu_number);
+
 /*
  * nVHE copy of data structures tracking available CPU cores.
  * Only entries for CPUs that were online at KVM init are populated.
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
