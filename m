Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4714C43461
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3C2FD21D7F
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="lY3tJHNQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C2FD21D7F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1B114B348;
	Tue, 15 Sep 2020 06:47:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qsA6aAE3yE2X; Tue, 15 Sep 2020 06:47:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1D364B32C;
	Tue, 15 Sep 2020 06:47:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66F0B4B35D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gL1wN7vKdvmP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 06:47:00 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 04C2E4B321
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:00 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id y17so2556058qky.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 03:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=kK0Nkqlx97phlNkNVM0H3UdgORvFyISMUeZJPb6S9IQ=;
 b=lY3tJHNQX/YeaIb4NFdcRGBG4mX+8bQEy/7baEu+cgNLvQYxXRSEL+RcF5YHSwapVV
 o/CPDPYRrq9bilK03YOvO4S+o8+HEt6NRGfUnNHnbUuGNT38lCG91d7U99HzutLeLT4e
 hsxoC6XG9O4pb4cVFdxUH2ehUyEnfMSpL0IP8zyVQ206fjOxJgPGh1is+nVJSee2hppi
 Y7uwjqGtn2vBcLeUGcjOa0Ei+Dtk9IaUwffKfi4iKZCVSNpT4+KMwDg4q5X4NDZKKarn
 f+HMxSJa28/mIH2K80wbQjqPlqb2xxDwL5viENVIE2DL1sdFkm/GE4WmCcL8H2tMG9sJ
 NFpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=kK0Nkqlx97phlNkNVM0H3UdgORvFyISMUeZJPb6S9IQ=;
 b=N17ZKYYcDWGu9vrEJey8j3kRYYAT3irtZ9T+pg8bf/x8jKrI3jv2xt9wckc6nc7CIx
 262IvuC+2ODjY2BL5e2lR4gRXKIoy39FszBq0m8XZgVLLFGWX94mb5YbMNzk8nA9eJAa
 Jo6U0sq8XthDKk1d2rlCyvVNLvEXimcdHeqLUUlKuQuPqjTov19+N3psfyvsb5TaHoI4
 NqMON5oGBURiCc1ttUWImmh2+Ijr7cbW/+rdQMeck4zV03FcgbUGJ7qRF9GqNOiycpsz
 S+EjvsZ1nMz4/S+xi7MmhtSU8Q1TPSDu2kshbhJDMA3GStg/Nvan997ZvWN1dWn9vRsI
 ubRQ==
X-Gm-Message-State: AOAM532A3eHnK7Q5wPejMJxRDTfGcdRIVgBGCCFjOhG5Q8KaTemVrUGZ
 N+tXdt8qDlU/InkRrPSyeSP7sCZ4T0pDtrLWV3FhSWvRSPKVAoU9QNq64dsj5otFmownUSdj+U0
 wivIvizxZAxihsTfshbzl4YosAAAUBimG9GC8p9l5kfWcBVHnrbufGRLzND5nXoCya2t2cQ==
X-Google-Smtp-Source: ABdhPJz1U5mFw04t/oZC/DN9ZXlVqPKd3B9ZGRx4Wei7AHsDj/ao/1HT3T88tmF9Nxqrv7NyykCCnUDC/rk=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:ad4:5a0e:: with SMTP id
 ei14mr2479891qvb.15.1600166819429; 
 Tue, 15 Sep 2020 03:46:59 -0700 (PDT)
Date: Tue, 15 Sep 2020 11:46:29 +0100
In-Reply-To: <20200915104643.2543892-1-ascull@google.com>
Message-Id: <20200915104643.2543892-6-ascull@google.com>
Mime-Version: 1.0
References: <20200915104643.2543892-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v4 05/19] KVM: arm64: Save chosen hyp vector to a percpu
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
index 1af4c77feda2..77fc856ea513 100644
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
index c1fd47557713..b49cf53c11f0 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -59,7 +59,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	write_sysreg(val, cpacr_el1);
 
-	write_sysreg(kvm_get_hyp_vector(), vbar_el1);
+	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el1);
 }
 NOKPROBE_SYMBOL(__activate_traps);
 
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
