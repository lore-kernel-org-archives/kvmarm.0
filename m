Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF4A0C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 12:47:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E1F1611C9
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 12:47:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6E1F1611C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 234864B103;
	Wed, 22 Sep 2021 08:47:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Or7m4WfZqPvf; Wed, 22 Sep 2021 08:47:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A73514B0DD;
	Wed, 22 Sep 2021 08:47:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 842D74A19A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 08:47:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vuVosUPu+IOh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 08:47:18 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7FFFF4024F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 08:47:18 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 k2-20020adfc702000000b0016006b2da9bso2075050wrg.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 05:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ncTfbrWWXjvnrM1t5gDCcZGArioiisqz5PzMYrE1ABU=;
 b=ZDMybYywTFQQpVUc/dVOu/y6W7gTrKthBO61GH3XhwlQGnlKOClij0roOppKg7XSEP
 clbFYJCsJIFAy0uAppeo3k0ycBs81jPTm7rVX7FizUStIsnee+DvhptZ/GwRqMrqAs3Q
 rWUizLEJWwSDhsZhUC9K5yHWBSdif9a41afkAp+dXp7Y5z3pQnlea4M1mC3XDaq/Wul1
 G9Vq7aJ9v1hVMeLqEkakhEYiOQNmglrJbpo32OI27oT2Ye6gILcdZugwMB46ObzIWWWd
 W2mlR4Ntc+oKd4WPrapVx1fY5arueErTvdM6UfqY7WpNyKQ+meEZY1BoUnQ+RocSMOJs
 ojmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ncTfbrWWXjvnrM1t5gDCcZGArioiisqz5PzMYrE1ABU=;
 b=pRArIeE/U2yQTAsoV0KMubq0MLnvEI090e5hevBnWZE0/U45kW8cUfbD4cI2l9ckwm
 iR1NieMFJ8fkdThqBr/AnJl2H4GLiFXJS3nyD/6M51G9/WfLbmJPzja5M3ZIXyzmJEp+
 B8ibTAa3BxyEtYuKFCmHAtf51ghxixWGs7pTyw1pO20WZolEA4xR+HUFWVC3eeF//CEJ
 69AdAKySe56iL3b8KIS/vvdJjbB6VMsOep/mK66OBY4vZlYwV8uNcy1/lz+/7pl0guR2
 QOjztLeP7l3sC/TMG8oI6JIrkJmFKFthJ2oM+NylSqU9eSabAKWnBMqxbLjLTkG0Nq3H
 9AGQ==
X-Gm-Message-State: AOAM532/Y7dDk9Mh+TJhewDY32p4lkcY/WnLY6Iv7NeOZiautcejY3P0
 dCvfMqxOwii8w018FpqcOM45XM+UHPUUNSSB7BUQELCTIANhEpOlGdZDPlv+kguf68P+I2g56cD
 af11+7hqaf7OPSHqvmv9BwCUBZHgIWnbsvSodsuhVPzgQDOeDDJcUASLKwRY08RmxX5o=
X-Google-Smtp-Source: ABdhPJyqqbcbmWWxFUAoN0ubpIg901FVokDG3zdESYltfWovzpoZnxktaZaX+Lno4ei5g7zYuT5P8w37yw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:adf:db0c:: with SMTP id
 s12mr360252wri.322.1632314837410; 
 Wed, 22 Sep 2021 05:47:17 -0700 (PDT)
Date: Wed, 22 Sep 2021 13:46:57 +0100
In-Reply-To: <20210922124704.600087-1-tabba@google.com>
Message-Id: <20210922124704.600087-6-tabba@google.com>
Mime-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 05/12] KVM: arm64: Pass struct kvm to per-EC handlers
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

We need struct kvm to check for protected VMs to be able to pick
the right handlers for them in subsequent patches.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 4 ++--
 arch/arm64/kvm/hyp/nvhe/switch.c        | 2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 0397606c0951..733e39f5aaaf 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -403,7 +403,7 @@ static bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 typedef bool (*exit_handler_fn)(struct kvm_vcpu *, u64 *);
 
-static const exit_handler_fn *kvm_get_exit_handler_array(void);
+static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm);
 
 /*
  * Allow the hypervisor to handle the exit with an exit handler if it has one.
@@ -413,7 +413,7 @@ static const exit_handler_fn *kvm_get_exit_handler_array(void);
  */
 static inline bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	const exit_handler_fn *handlers = kvm_get_exit_handler_array();
+	const exit_handler_fn *handlers = kvm_get_exit_handler_array(kern_hyp_va(vcpu->kvm));
 	exit_handler_fn fn;
 
 	fn = handlers[kvm_vcpu_trap_get_class(vcpu)];
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index c52d580708e0..49080c607838 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -170,7 +170,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
-static const exit_handler_fn *kvm_get_exit_handler_array(void)
+static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 {
 	return hyp_exit_handlers;
 }
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 0e0d342358f7..34a4bd9f67a7 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -108,7 +108,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
-static const exit_handler_fn *kvm_get_exit_handler_array(void)
+static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 {
 	return hyp_exit_handlers;
 }
-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
