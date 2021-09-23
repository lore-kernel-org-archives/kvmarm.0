Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C084C43217
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B398861263
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B398861263
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68DF64B126;
	Thu, 23 Sep 2021 15:16:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5UKa7f9uQ445; Thu, 23 Sep 2021 15:16:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D5594B0E1;
	Thu, 23 Sep 2021 15:16:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35E4A4B119
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rVsFtlq+djqs for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 15:16:20 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1FE234B115
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:20 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 d11-20020a92d78b000000b0022c670da306so6244018iln.23
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 12:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=2asC0Rqx18RgPRLiSzHgbr40dKQc4/+1utoD7s7ji4c=;
 b=qmWxJl8N7VPhQwq1iVzn7zIRiLfz55FQdBAPpXmcXjkncp+qy2dX9MWloQCvvPvJ2z
 YFltQyoEZ2XVmE7ByBDa1hXpmU190EeKmxQ01GuRis1+KDUgCJhksdK/AT4Zsgu7uRlo
 61YkmElQFogLLTpS+8vqdwrxCTpI/gjiG/Ws1sg8imVHPNwAFTXsfxN323raR1jtS2/n
 C+7976GUVrs4rJGi+8G/C2drf3/B7JW6x6epW2KCoBr1JmAMeXzisIfVCwdPI1lJbymA
 M1bdRQZOgpd0+6zVtD9ESuWnW/gx7eJ74K55G6T0LgY7pikP7ONSGqjZynj9wVJGZZvv
 Mmsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=2asC0Rqx18RgPRLiSzHgbr40dKQc4/+1utoD7s7ji4c=;
 b=E2U3Fq2OVUpS1dbDOQ/MUra/2QmAss0GuHwaVdIlBDT/CRB34CvNV/kKJ1AkqnaIV8
 ziYAMNHS2HnTkhmBWOqfDicjqIAh/d1IuyViTHckHThCJZekItW9Wmb4jTLeHYm7+S1e
 3+FhQaXNoUcVfz+z+fp3jgLqCOfSS9mejVYseq1UPxCj1l7wVsXjqFQiH1+YdNk0wqQc
 fhu+/oBOwAN8K81EWXJgJ8cLiechHIsws/Y1ZGJfoQdVeN7DOsAwFncjhcPTXHUGGAXf
 RBK8SWbCGg8OHqhmFDdz4K1LbyGXjMSG5KGJF/BbBt64gCi2QQbAR4QUeOnRuY5MFG6U
 tAEg==
X-Gm-Message-State: AOAM533x2medsuPh852iKYarVmEcUmeoJfAvCSGiCN1AglJo/TcS+0uo
 bIZnsguUVZMa2LPoXxShfgLZa8WFVIYiVwWHPTJ0/U06Bu81RUIEsjMOAeAwyupgNbzAi2WURsV
 VyILfwopLN2c7wAEp40GpgoB8D5bo8LROsyRVBNszPKAAT8FGQC2ZDWFjxrvMkw/ObDJr7g==
X-Google-Smtp-Source: ABdhPJxtuC86c4seq0Yi0ytSDi5No4IEOB4Xjc6doIoIAtU4XvjZFliTDgFtlqolEDhlMd3rYKHr6CIkr9A=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:b0d5:: with SMTP id
 w21mr5489320jah.45.1632424579479; 
 Thu, 23 Sep 2021 12:16:19 -0700 (PDT)
Date: Thu, 23 Sep 2021 19:16:02 +0000
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Message-Id: <20210923191610.3814698-4-oupton@google.com>
Mime-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 03/11] KVM: arm64: Encapsulate reset request logic in a
 helper function
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>
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
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
