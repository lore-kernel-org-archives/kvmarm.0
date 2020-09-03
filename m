Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A53C433E9
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2A23F208C7
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="EC4t/Z3M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A23F208C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D446E4B0C8;
	Thu,  3 Sep 2020 09:53:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w+J-txIp+6in; Thu,  3 Sep 2020 09:53:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E53B54B2BE;
	Thu,  3 Sep 2020 09:53:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DE8A4B0C8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7WkJ092v2SGE for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 09:53:18 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9B42A4B2A2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:18 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id b54so587371qtk.17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2020 06:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=lkS3HdLznCxMbsFhlurcWnSrTq5G/SsOZVmpPWKJtBQ=;
 b=EC4t/Z3MHb9RU9819zmwAkj6/bFVLneqooJ1YIeq8v3LIIzN4Hz6j04Xm5JAYC4faS
 6uM4SywqJx3hgAzbiJBGmAVQ1zkK5Xj8GYJh2CQiesJAIcr4CHNOpU5EFkEyvpozd7QP
 Je5wagoC34EB0P/ImbsDHsR8A7A0dwaMEt1U19YMpCM/GUD/7CTtMuq5SbdsSUKHb6AZ
 Pis11q6LlxHObK6PgDJj0YRW0T4sd9VEfzBAwX+dUa8ZeRxM2KbYEffQnshgeXTKJA+4
 sFAb3VybXO567oj/5aAULZefVD47pu58AJX+9WhuQyjuXofTmoVesrXx9q2vROb+asyA
 eymA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=lkS3HdLznCxMbsFhlurcWnSrTq5G/SsOZVmpPWKJtBQ=;
 b=tNGUGNcE9jFmkNdPoJjjVuUIW9u+hyzPx6TxolyhupYycMgvUdmRM2rDQJolQugj/+
 m66T49GlyZwJTR6hmXAPSlzqrRzlKgC9ymrn8BvzGM69p+KcwgOH3RtWGqCqBv2ll6aW
 NYPjPB3O30AFdGHD+b8N5hBAZt03/yYGkHIKxeV8+E+JYX4Ycl9aw6gMSQStLa9WqM6Z
 FJaMekAAXCA1M6jG4ROx9yBirm2dkv59z+Loi3pCvs9J6snATbHGP/55EztAEBKBhvhM
 DKh2bPAbneO8YheEYDGkLBjtnvqzxvWGgGLWVaJeU9qCBrhww8Ieqvp0A3lwtAw1ZNiN
 cfDQ==
X-Gm-Message-State: AOAM533Z//l8eFtCBFoPiKJf1nuZDkavh76SJ6mCq32R5eye+o2cY9Qf
 YViFJVh0jjX3OS7vU+PpHlD4MOSAYPvEG99xkmKgw+93izdasRu4Dg9o7SHznSnGnNJpGRGa2eT
 ANQlU4HWQHLGt6TRATRDNPcV7srnCzXZlDwY5NGe9hV5OC68ZctrJ/OghrAeTMCdS9BYeLA==
X-Google-Smtp-Source: ABdhPJy0N/5mGTDUGiPLg/oa1CKfP1NryMz4+xoDwd2Q7Mq0rBOzDSAcrCvbyQsKiYNt0Y3cjToYu7OELI8=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:ad4:45a6:: with SMTP id
 y6mr2091657qvu.8.1599141198093; 
 Thu, 03 Sep 2020 06:53:18 -0700 (PDT)
Date: Thu,  3 Sep 2020 14:52:52 +0100
In-Reply-To: <20200903135307.251331-1-ascull@google.com>
Message-Id: <20200903135307.251331-4-ascull@google.com>
Mime-Version: 1.0
References: <20200903135307.251331-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH v3 03/18] KVM: arm64: Remove kvm_host_data_t typedef
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

The kvm_host_data_t typedef is used inconsistently and goes against the
kernel's coding style. Remove it in favour of the full struct specifier.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 4 +---
 arch/arm64/kvm/arm.c              | 4 ++--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e52c927aade5..16adbefde1cc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -262,8 +262,6 @@ struct kvm_host_data {
 	struct kvm_pmu_events pmu_events;
 };
 
-typedef struct kvm_host_data kvm_host_data_t;
-
 struct vcpu_reset_state {
 	unsigned long	pc;
 	unsigned long	r0;
@@ -565,7 +563,7 @@ void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
-DECLARE_PER_CPU(kvm_host_data_t, kvm_host_data);
+DECLARE_PER_CPU(struct kvm_host_data, kvm_host_data);
 
 static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
 {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 46dc3d75cf13..1af4c77feda2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -46,7 +46,7 @@
 __asm__(".arch_extension	virt");
 #endif
 
-DEFINE_PER_CPU(kvm_host_data_t, kvm_host_data);
+DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 
 /* The VMID used in the VTTBR */
@@ -1538,7 +1538,7 @@ static int init_hyp_mode(void)
 	}
 
 	for_each_possible_cpu(cpu) {
-		kvm_host_data_t *cpu_data;
+		struct kvm_host_data *cpu_data;
 
 		cpu_data = per_cpu_ptr(&kvm_host_data, cpu);
 		err = create_hyp_mappings(cpu_data, cpu_data + 1, PAGE_HYP);
-- 
2.28.0.402.g5ffc5be6b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
