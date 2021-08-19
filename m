Return-Path: <SRS0=/4wP=NK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 676E1C432BE
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 22:37:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0081C60462
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 22:37:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0081C60462
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8A374B087;
	Thu, 19 Aug 2021 18:37:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id atSezH97WaKv; Thu, 19 Aug 2021 18:36:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1257C4B121;
	Thu, 19 Aug 2021 18:36:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 753314B127
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 18:36:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2A3eBLT+kQhg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Aug 2021 18:36:47 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20E134B087
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 18:36:47 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 k4-20020a25b284000000b0059844c88867so1120826ybj.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 15:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=B7ft+C53yDXB0+yPktYYFl4h/nCqhSyvFK9vusSpZaQ=;
 b=wSbb7a2mokCW7Vs5IFUwP7z/yN0MDjb+llO8oOLIteb4rYqrhrSDAD8r0dm2TYxEaU
 foypJs+EmRl/rYnzANu/2VINLqpPj2EDZEFhOdmgKAQLsh0KaF9rMcPDcN/1UV+7kJQI
 INkUs4cEizbVIdRHclAk9zBN/drqrBDSe3UYSKR02DbKbXD6EK/M7A0dIiAjxFc54LGC
 DnfWlorZc82U81Qio71vbTW/wZnCGpoKbXDH3mgFnokwNnIrDsQGvtrvCpfHje7YKdWh
 VFjvUR18CrDWpd9WAn13H0Xwzs1xl8xUMCfetGXNTW/9I1lDUA7LfqgbhinO6UbrYYcL
 z+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=B7ft+C53yDXB0+yPktYYFl4h/nCqhSyvFK9vusSpZaQ=;
 b=SDZhNn1RUNoUlVZV2drUEjH9gav0GYkMM5W+NnAI0BsrcqHz4L+i6pAAcfuO/MoSkM
 03HtYt47CBKq866edKgxKZbHI4QZ7ThuDmEDClNba33jr+VQmdlxK28ZfR5eeX6IkvRp
 E56lAodky341OXpKHVhxvNA5XlypOUYy4epl8g+n09379rmqK63sPjOaMJKO9so3JIku
 UiY9vgs4/BpowO+pI995g/7wiUY1YZ486Rcz/7zPcoVYCHhRrSOQfNBE3OJ98PdkWGin
 zz84suJ9r+BOUM4QX/jkmtWgFQeE8cPKtWUYYfbc/+46rRYlrh1vJtV5d7FHgst4icac
 lLKw==
X-Gm-Message-State: AOAM5309CsCqvG68eIW5NpN0xxFfiJIiHKjXeKJN19st9jWJnipITkic
 oIkd38CNjim9+UUVvRKv7p1tTXNpbHo=
X-Google-Smtp-Source: ABdhPJwtsiVe5jRaLujMbQ5x1J3N15UiiWapXS3MYaqiqc1m7Pd0dt6bAARdt2fFZ+uOeGFvehaMJLs0gUE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:d68a:: with SMTP id
 n132mr20212107ybg.483.1629412606727; 
 Thu, 19 Aug 2021 15:36:46 -0700 (PDT)
Date: Thu, 19 Aug 2021 22:36:37 +0000
In-Reply-To: <20210819223640.3564975-1-oupton@google.com>
Message-Id: <20210819223640.3564975-4-oupton@google.com>
Mime-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 3/6] KVM: arm64: Encapsulate reset request logic in a helper
 function
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Raghavendra Rao Anata <rananta@google.com>
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

In its implementation of the PSCI function, KVM needs to request that a
target vCPU resets before its next entry into the guest. Wrap the logic
for requesting a reset in a function for later use by other implemented
PSCI calls.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 59 +++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 310b9cb2b32b..bb59b692998b 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -64,9 +64,40 @@ static inline bool kvm_psci_valid_affinity(unsigned long affinity)
 	return !(affinity & ~MPIDR_HWID_BITMASK);
 }
 
-static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
+static void kvm_psci_vcpu_request_reset(struct kvm_vcpu *vcpu,
+					unsigned long entry_addr,
+					unsigned long context_id,
+					bool big_endian)
 {
 	struct vcpu_reset_state *reset_state;
+
+	lockdep_assert_held(&vcpu->kvm->lock);
+
+	reset_state = &vcpu->arch.reset_state;
+	reset_state->pc = entry_addr;
+
+	/* Propagate caller endianness */
+	reset_state->be = big_endian;
+
+	/*
+	 * NOTE: We always update r0 (or x0) because for PSCI v0.1
+	 * the general purpose registers are undefined upon CPU_ON.
+	 */
+	reset_state->r0 = context_id;
+
+	WRITE_ONCE(reset_state->reset, true);
+	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
+
+	/*
+	 * Make sure the reset request is observed if the change to
+	 * power_state is observed.
+	 */
+	smp_wmb();
+	vcpu->arch.power_off = false;
+}
+
+static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
+{
 	struct kvm *kvm = source_vcpu->kvm;
 	struct kvm_vcpu *vcpu = NULL;
 	unsigned long cpu_id;
@@ -90,29 +121,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 			return PSCI_RET_INVALID_PARAMS;
 	}
 
-	reset_state = &vcpu->arch.reset_state;
-
-	reset_state->pc = smccc_get_arg2(source_vcpu);
-
-	/* Propagate caller endianness */
-	reset_state->be = kvm_vcpu_is_be(source_vcpu);
-
-	/*
-	 * NOTE: We always update r0 (or x0) because for PSCI v0.1
-	 * the general purpose registers are undefined upon CPU_ON.
-	 */
-	reset_state->r0 = smccc_get_arg3(source_vcpu);
-
-	WRITE_ONCE(reset_state->reset, true);
-	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
-
-	/*
-	 * Make sure the reset request is observed if the change to
-	 * power_state is observed.
-	 */
-	smp_wmb();
-
-	vcpu->arch.power_off = false;
+	kvm_psci_vcpu_request_reset(vcpu, smccc_get_arg2(source_vcpu),
+				    smccc_get_arg3(source_vcpu),
+				    kvm_vcpu_is_be(source_vcpu));
 	kvm_vcpu_wake_up(vcpu);
 
 	return PSCI_RET_SUCCESS;
-- 
2.33.0.rc2.250.ged5fa647cd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
