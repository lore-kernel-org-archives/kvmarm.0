Return-Path: <SRS0=c5RA=B6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D082FC433DF
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 81E5F20639
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="OVOsIi24"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81E5F20639
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B9B44B852;
	Thu, 20 Aug 2020 06:35:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id feWl2Bmu5dsM; Thu, 20 Aug 2020 06:35:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D59254B888;
	Thu, 20 Aug 2020 06:35:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B13F84B81A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TdZXWbFppRmP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Aug 2020 06:35:31 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6B344B89E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:31 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id y7so1010976qvj.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 03:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=37zpMdjcndUFVD4+uS94TLYior1Sf4KsI6kIarwDjl4=;
 b=OVOsIi243JYWAw6YuRdKFan/r8KFf4/6BdxTaZjT8YwEKwQtJ5r/Z6afR6P88if59N
 7NnrzuRZe4avYB6A+Sd1mx6qfnOjuDquokyWWQ5Jb767pbdR/cIbjoL5EDFda1xl2OsD
 Jr8mthVA/rvXcQjokli2Mji0sTQzKU/OFhSJdJ4Ght+3u9qyNgB3Hua6NJHY8LlpWxSR
 Y93B9rG5nCUn8j+LaXZbFX1e0jcPiGEAFntoNnvUIY8xw+xD8HXKAja1StYZZeRSUKFr
 HKyUN0MM7xD76isoBXYEOgFx9gxXIoyG4LztPBn2EyAFa3/dFmT90ZQqnyxbNltIkzZg
 RZBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=37zpMdjcndUFVD4+uS94TLYior1Sf4KsI6kIarwDjl4=;
 b=C2POHiobKKOsJEgrMHmvY14DMzTClAbyciIvbV2zE+3zBu0o2QjfV/RpJ50HOL5cBW
 OuJMJ5VDacZSwmlbisasWl+Rv85WclvMnwNoCedwfGmBqX9e2PwjoF1+aZyT1Wvto2eo
 +KZNEeaASddSpZrQm6LfpEaWgN/wCQULueLtvpTGVvygCDC0FN16TVYTDrpVgJAxpiJ6
 ZpO+P0hMj0bek+hr+maG4U93xhNOZI5jSW3hAYfQ2FsGsN6LwiC2pdZvOGHs1NG+ximE
 6CouTMw8up6TqCyah4WcW6AuCy22rbJ+1xvepi9XmBImzdL2Ll7SKl1hM0flUJTTU+Um
 IyqQ==
X-Gm-Message-State: AOAM5306BnsM2is8ip43fUILtVdKgMC1NmT30t5UoNMzb2R+FkFO3/eJ
 kK256xbq44xYAhvqtvR87QgQDn4P/wNUlmpTM6olF4Q/8oGu3hkIsYj8mZ8XCUSfp9kxxD8y/j2
 4iJpMZ9PxZ/TJsJPPpQgqo6XiDukE70q5wuse1YIks7Eo02VcSjdA3Lsj/8XwuUxIf2PYGA==
X-Google-Smtp-Source: ABdhPJzNjftrIqn+OHJCp1q4uT2Q7nzJdUixaBmiasMHtpSaYAECUIJZUnuTb3oQIgpS8hgiVikwnxhxk7Y=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a0c:ec01:: with SMTP id
 y1mr2212111qvo.167.1597919731182; 
 Thu, 20 Aug 2020 03:35:31 -0700 (PDT)
Date: Thu, 20 Aug 2020 11:34:31 +0100
In-Reply-To: <20200820103446.959000-1-ascull@google.com>
Message-Id: <20200820103446.959000-6-ascull@google.com>
Mime-Version: 1.0
References: <20200820103446.959000-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v2 05/20] KVM: arm64: Save chosen hyp vector to a percpu
 variable
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

Introduce a percpu variable to hold the address of the selected hyp
vector that will be used with guests. This avoids the selection process
each time a guest is being entered and can be used by nVHE when a
separate vector is introduced for the host.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 2 ++
 arch/arm64/kvm/arm.c             | 5 ++++-
 arch/arm64/kvm/hyp/vhe/switch.c  | 2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 3de99b323061..1e2491da324e 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -12,6 +12,8 @@
 #include <asm/alternative.h>
 #include <asm/sysreg.h>
 
+DECLARE_PER_CPU(unsigned long, kvm_hyp_vector);
+
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
 		u64 reg;						\
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6b09c0f3365c..d779814f0da6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -47,6 +47,7 @@ __asm__(".arch_extension	virt");
 #endif
 
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
+DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 
 /* The VMID used in the VTTBR */
@@ -1276,7 +1277,7 @@ static void cpu_init_hyp_mode(void)
 
 	pgd_ptr = kvm_mmu_get_httbr();
 	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
-	vector_ptr = (unsigned long)kvm_get_hyp_vector();
+	vector_ptr = __this_cpu_read(kvm_hyp_vector);
 
 	/*
 	 * Call initialization code, and switch to the full blown HYP code.
@@ -1309,6 +1310,8 @@ static void cpu_hyp_reinit(void)
 
 	cpu_hyp_reset();
 
+	__this_cpu_write(kvm_hyp_vector, (unsigned long)kvm_get_hyp_vector());
+
 	if (is_kernel_in_hyp_mode())
 		kvm_timer_init_vhe();
 	else
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 099bfa78011c..20ee901fd4ff 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -59,7 +59,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	write_sysreg(val, cpacr_el1);
 
-	write_sysreg(kvm_get_hyp_vector(), vbar_el1);
+	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el1);
 }
 NOKPROBE_SYMBOL(__activate_traps);
 
-- 
2.28.0.220.ged08abb693-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
