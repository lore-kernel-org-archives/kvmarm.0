Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FE7C43461
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:46:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2710721D24
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:46:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="G48FZrRl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2710721D24
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 970874B349;
	Tue, 15 Sep 2020 06:46:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lP1+p7XmUxk1; Tue, 15 Sep 2020 06:46:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87F2E4B32E;
	Tue, 15 Sep 2020 06:46:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4A614B334
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:46:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1lBHivFFRG4t for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 06:46:55 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE90E4B321
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:46:55 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id 99so1934611qva.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 03:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=gTjGw9ImztLyDWYkFo0dNEUflgDWtEiIdiP6CPvSqDM=;
 b=G48FZrRlJijGlOd52Jxp3+TlqDvCWO+Dl+se1eSdYve/GDvTP7M9s9J1/cP5yznoHf
 RqgcER3vR6dgEJWeaPSrWkVhqFJOb0Csdqdl1/HpS+YESzae3mEJaeVZxlQK1YOyNK9D
 3YEtMp7oS4Gj5UVOnwC1/nnncdhNbAO42FqGaVt1Bvk7tha+CiRbftYo6bISt9wOG0Zu
 49m/73c/DBP63RfLIyAX9IUuZEjrFv1Kwv9WB6xTvKdYX3JEySa0F2wvb5juyt7hZAE0
 ON3+VDiVhu5KTSZxMAr3J1bV5NZJ9Ats2V5YV1SNUiNLVgUq1grrBQ81vIE4pTcJgA6Q
 VWAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=gTjGw9ImztLyDWYkFo0dNEUflgDWtEiIdiP6CPvSqDM=;
 b=XLLy08TMP3pxJQEXt8vYdbwNTPu5+/RR3dpFcH57rtkBA/jUS+rdzeZZfpBtFG6F/s
 /c6PRf6MaYNlgxUc914+ZVGTy61tYS1BGjmZr1UUOb3gkTUfqaiJrreIKaiRZIavvsur
 oeUH0lAbkKBkNxZkQCh/b4QaXx6KuW5x03qhxAycfg2PnZG2d1/5UwoNEX/pt3u3IkuE
 jPjMe6V9MNbwjYoJh3tA0LoECVw42auYIHy4iAy9EljRKWJNjVK6BTj8eP4iBiSLNBfm
 4/Qk9VccY4OyPqYlgP5TocP2AeMfox76+4qRuMrzEbLGT8ZOcGIrdNCRKDQwg1lIybVt
 Uxsw==
X-Gm-Message-State: AOAM533iVSvpi6vDO74ukL0dqrCQURMG/NW9bjLCELwTY3wrsnxy/6sd
 QiOmYrFXRpYjcStBELRyNv1h1ZNJUbItNbnyICN8ugv7wVlzpQxFDkQ7drFNYhOZ9+2kwT8M5gB
 NtDU0BlQ1IvtzgV5yJBnD/iKpuP918HS6NyCob2ek562XdWKIsC2PP+FMGzVsTgfKGGLNdw==
X-Google-Smtp-Source: ABdhPJwg17+97CHQHDRnioFqCvS+QzG2nJ9WQ27LQJtstyxanlpRIZbCsLQOidvdSKpjDtlOlP/Edd0zy18=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a0c:d443:: with SMTP id
 r3mr17610682qvh.17.1600166815284; 
 Tue, 15 Sep 2020 03:46:55 -0700 (PDT)
Date: Tue, 15 Sep 2020 11:46:27 +0100
In-Reply-To: <20200915104643.2543892-1-ascull@google.com>
Message-Id: <20200915104643.2543892-4-ascull@google.com>
Mime-Version: 1.0
References: <20200915104643.2543892-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v4 03/19] KVM: arm64: Remove kvm_host_data_t typedef
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
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
