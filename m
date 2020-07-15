Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C89DCC433F4
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 82907207BC
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="tsWjcYpf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82907207BC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C5B14B3B0;
	Wed, 15 Jul 2020 14:45:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Tt6Qf5ATZimz; Wed, 15 Jul 2020 14:45:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15ACE4B388;
	Wed, 15 Jul 2020 14:45:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06ECC4B3C0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vr8OiD74iSsn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:19 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D06054B3C4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:19 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id h4so2062704qkl.23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=gUi+pL95nHangpHU9mv6/1nVTrQ0ibsC6/EzxOy4I0k=;
 b=tsWjcYpfCiIv/NdRvEviXMESDU77Qb4IjecaJ2NKRFCpgr5QrjM/TE+qbqh8o6rRWm
 WmWv5Is0iNqElYbkadL30rxWDaD/0jo++s42+0iUoOEJrdrkPsNQ5X1KGalih3mRXAcd
 zu9teHTLQASZ14CO2zAEKrbGxwLVYDG7yY0azsv9ZDoSnQUOYhq5FLb2GfdPGUqPw9FC
 fmG3k04WEoJCfroyfLSGQS9rq6MBo09OulfT8aJBjlunViIAaDWXiOm7KvnfQT843ShO
 zCRQnXFAYKnLVKW+YNSrzzBhfZQahQvfDUAdjRkPGtuxbT7OijNr3pnFgv72s6Rz3jEC
 L59Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=gUi+pL95nHangpHU9mv6/1nVTrQ0ibsC6/EzxOy4I0k=;
 b=P7usJwLMnyggNfwh/95NK8KHTEZJR8hC3h0AomWy7pB8zp2+Bq2X4Qsbjt6R0SCn2C
 QHSiIygz/TTrMrKiOe+4oRYohgC8E47W5n/y7A+7z0mVLGSMC5MUs8k2qlwNjd4edpxg
 LYyZlAKh1GOgOBKD2q6qodDN8d+RoweCv2KhuMOIkqh8Tt/1CkXBb1CWh+s249imBQfY
 XBUMg+FCBxgDKnccE6Rzqrws8n/48q5/6RdNaZKDk8NZTbZffL7nCm7VA87LrxAeBkF4
 7Pp9CnFsl119x9IkgIgexnuTAt8sxi/zfQKfML2N+yiJRL+WWhb2BIUsWo/SBTWEgr8S
 dVSQ==
X-Gm-Message-State: AOAM531O2s95uIL680wBz8qRrxj4H3zzNyxk3lnvhR2h+mIsovioYg0b
 KzwWdM4cHVlE0r4rFz69rSlkKpC7MyB01Hjwd5FCHFEEH2eFmc1ob1Ssixx1SshmoNMROB4TaSB
 6u6NXedNmD8Nbyk6oZT3yL1cjwZt1KinJ33GdVlQC13ny2lUe2w2sAtrlmW3kYziZu//h3Q==
X-Google-Smtp-Source: ABdhPJwXsv4DZeg+KMEwxfy93xzIr+bZH1QIB2LdNhZgA+3SRBBAF3Mlbjp3yRE5BZM1xUn3SSz68QbMyOA=
X-Received: by 2002:a0c:d84d:: with SMTP id i13mr649517qvj.167.1594838719321; 
 Wed, 15 Jul 2020 11:45:19 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:15 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-15-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 14/37] KVM: arm64: nVHE: Use __kvm_vcpu_run for the host vcpu
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com
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

Keeping the assumption that transitions will only be from the host to a
guest and vice-versa, make __kvm_vcpu_run switch to the requested vcpu
and run it.

The context is only switched when it is not currently active allowing
the host to be run repeatedly when servicing HVCs.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 22 ++-----
 arch/arm64/kvm/hyp/nvhe/switch.c   | 95 ++++++++++++++++++++++--------
 2 files changed, 74 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2d621bf5ac3e..213977634601 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -115,10 +115,8 @@ void __noreturn kvm_hyp_main(void)
 {
 	/* Set tpidr_el2 for use by HYP */
 	struct kvm_vcpu *host_vcpu;
-	struct kvm_cpu_context *hyp_ctxt;
 
 	host_vcpu = __hyp_this_cpu_ptr(kvm_host_vcpu);
-	hyp_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 
 	kvm_init_host_cpu_context(&host_vcpu->arch.ctxt);
 
@@ -131,24 +129,14 @@ void __noreturn kvm_hyp_main(void)
 	 */
 	smccc_set_retval(host_vcpu, SMCCC_RET_SUCCESS, 0, 0, 0);
 
+	/* The host is already loaded so note it as the running vcpu. */
+	*__hyp_this_cpu_ptr(kvm_hyp_running_vcpu) = host_vcpu;
+
 	while (true) {
 		u64 exit_code;
 
-		/*
-		 * Set the running cpu for the vectors to pass to __guest_exit
-		 * so it can get the cpu context.
-		 */
-		*__hyp_this_cpu_ptr(kvm_hyp_running_vcpu) = host_vcpu;
-
-		/*
-		 * Enter the host now that we feel like we're in charge.
-		 *
-		 * This should merge with __kvm_vcpu_run as host becomes more
-		 * vcpu-like.
-		 */
-		do {
-			exit_code = __guest_enter(host_vcpu, hyp_ctxt);
-		} while (fixup_guest_exit(host_vcpu, &exit_code));
+		/* Enter the host now that we feel like we're in charge. */
+		exit_code = __kvm_vcpu_run(host_vcpu);
 
 		switch (ARM_EXCEPTION_CODE(exit_code)) {
 		case ARM_EXCEPTION_TRAP:
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 81cdf33f92bc..36140686e1d8 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -119,7 +119,7 @@ static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 /**
  * Disable host events, enable guest events
  */
-static bool __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
+static void __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_host_data *host;
 	struct kvm_pmu_events *pmu;
@@ -132,8 +132,6 @@ static bool __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
 
 	if (pmu->events_guest)
 		write_sysreg(pmu->events_guest, pmcntenset_el0);
-
-	return (pmu->events_host || pmu->events_guest);
 }
 
 /**
@@ -154,13 +152,10 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
-/* Switch to the guest for legacy non-VHE systems */
-int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
+static void __kvm_vcpu_switch_to_guest(struct kvm_cpu_context *host_ctxt,
+				       struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *host_ctxt;
-	struct kvm_cpu_context *guest_ctxt;
-	bool pmu_switch_needed;
-	u64 exit_code;
+	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 
 	/*
 	 * Having IRQs masked via PMR when entering the guest means the GIC
@@ -173,11 +168,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		pmr_sync();
 	}
 
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
-	*__hyp_this_cpu_ptr(kvm_hyp_running_vcpu) = vcpu;
-	guest_ctxt = &vcpu->arch.ctxt;
-
-	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
+	__pmu_switch_to_guest(host_ctxt);
 
 	__sysreg_save_state_nvhe(host_ctxt);
 
@@ -199,17 +190,13 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__timer_enable_traps(vcpu);
 
 	__debug_switch_to_guest(vcpu);
+}
 
-	__set_vcpu_arch_workaround_state(vcpu);
-
-	do {
-		/* Jump in the fire! */
-		exit_code = __guest_enter(vcpu, host_ctxt);
-
-		/* And we're baaack! */
-	} while (fixup_guest_exit(vcpu, &exit_code));
-
-	__set_hyp_arch_workaround_state(vcpu);
+static void __kvm_vcpu_switch_to_host(struct kvm_cpu_context *host_ctxt,
+				      struct kvm_vcpu *host_vcpu,
+				      struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 
 	__sysreg_save_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
@@ -230,12 +217,68 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	__debug_switch_to_host(vcpu);
 
-	if (pmu_switch_needed)
-		__pmu_switch_to_host(host_ctxt);
+	__pmu_switch_to_host(host_ctxt);
 
 	/* Returning to host will clear PSR.I, remask PMR if needed */
 	if (system_uses_irq_prio_masking())
 		gic_write_pmr(GIC_PRIO_IRQOFF);
+}
+
+static void __vcpu_switch_to(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_vcpu *running_vcpu;
+
+	/*
+	 * Restoration is not yet pure so it still makes use of the previously
+	 * running vcpu.
+	 */
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	running_vcpu = __hyp_this_cpu_read(kvm_hyp_running_vcpu);
+
+	if (vcpu->arch.ctxt.is_host)
+		__kvm_vcpu_switch_to_host(host_ctxt, vcpu, running_vcpu);
+	else
+		__kvm_vcpu_switch_to_guest(host_ctxt, vcpu);
+
+	*__hyp_this_cpu_ptr(kvm_hyp_running_vcpu) = vcpu;
+}
+
+/* Switch to the guest for legacy non-VHE systems */
+int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_vcpu *running_vcpu;
+	u64 exit_code;
+
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	running_vcpu = __hyp_this_cpu_read(kvm_hyp_running_vcpu);
+
+	if (running_vcpu != vcpu) {
+		if (!running_vcpu->arch.ctxt.is_host &&
+		    !vcpu->arch.ctxt.is_host) {
+			/*
+			 * There are still assumptions that the switch will
+			 * always be between a guest and the host so double
+			 * check that is the case. If it isn't, pretending
+			 * there was an interrupt is a harmless way to bail.
+			 */
+			return ARM_EXCEPTION_IRQ;
+		}
+
+		__vcpu_switch_to(vcpu);
+	}
+
+	__set_vcpu_arch_workaround_state(vcpu);
+
+	do {
+		/* Jump in the fire! */
+		exit_code = __guest_enter(vcpu, host_ctxt);
+
+		/* And we're baaack! */
+	} while (fixup_guest_exit(vcpu, &exit_code));
+
+	__set_hyp_arch_workaround_state(vcpu);
 
 	return exit_code;
 }
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
