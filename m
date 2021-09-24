Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664BEC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1143661409
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1143661409
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B00324B14D;
	Fri, 24 Sep 2021 08:54:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7YeP9uBMgfOG; Fri, 24 Sep 2021 08:54:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60BEB4B1A0;
	Fri, 24 Sep 2021 08:54:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 913874B176
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XxLxEOWBmVpT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:54:11 -0400 (EDT)
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com
 [209.85.208.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 803EA4B136
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:11 -0400 (EDT)
Received: by mail-ed1-f74.google.com with SMTP id
 z6-20020a50cd06000000b003d2c2e38f1fso10176700edi.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=NDvJPFQrogpAsPTwpI9wbd6GY9uLrhdDShc06jG7Kb4=;
 b=ofmwdIYsCOT3dwUKE9fs1S0wlAahS1/K44MZDjnE5gAUoqkmdR2JLYgcKHIfptReIX
 dndQywZVRlFuQ3eOGRYinLFu/MngUVLE+8LX51SRkzUM7CBa6Rel5x8axNZa4uL1zp2U
 wJ0d3vM7NVwH6J3XmsmRgs8W0rTFnsn3wb9mC3nhOrcNH1NR5ZUwDA9tPRh1JDDH4f7l
 zQvYCm3Kkr3QWGWjZ1LC7iqi68tZn7ouspyCGugcVjLxryYO+CyIMSNqEVdSrV7xuY4w
 ABuCGZ9OVVMOUxX2tJIa+3AE5Tc9C+idHAo8MF2y4xXovo527JFfadzqGEw6vk6+5pL5
 tqKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=NDvJPFQrogpAsPTwpI9wbd6GY9uLrhdDShc06jG7Kb4=;
 b=aMXczTwmwo09/r90tWzhminusPpvMrylnVIBuCPzrnLfIT9IPbL2iq886pSWwOb1mO
 pvoaPeRS/eIJIHGnDzZyNjulJpwDU7vmR+65VyZeqwes89Xqmc1AdjhSY1tTypfVkTQR
 +PieVZSCInkjGMQt+bal2LTZ1THyNjIMb+U049hdIf+Mgt0R8C8YDNe4i2hXNvSopGqn
 LAl26JfcYXtK9bc+9X/J672aot0fUn5R4h9AUyOJawzo055Q2rjWyBrC1GK2QQ+cqMjP
 MHnUHYBJ1Xn6Vs5wdgmkr5KC9E4nQc26CpsGrIRmgknkwihmbZGxLZun9twrVzIAFbNB
 VLSA==
X-Gm-Message-State: AOAM532y3ND5vk4fMT6GK4k8f2uZUNa4Ssbe1qAZLn7qDUwwb6VEZL84
 SC1VbY5Fup/M/I5zFQAeIFVrp2VE1FbHzd6WZ0Ugj20tida71nIP0LaXpUPYbYoU/lbwCwg6t4g
 9u9zWT+NHBmNMy1wxmkqvCuUgpWYC+cuIk/ac2bKkPW5pDY1Q0a2Bx9mj2Gv78O4bdL8=
X-Google-Smtp-Source: ABdhPJxKKemydyBQbjYJSypMRsSre41xZtGQ0H5ytHahnnYcVhn4lCAlWI7RlpAOylFBNu1TXAL96enMEA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a50:e10d:: with SMTP id
 h13mr4772015edl.77.1632488050517; 
 Fri, 24 Sep 2021 05:54:10 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:33 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-5-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 04/30] KVM: arm64: remove unused parameters and asm
 offsets
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Remove unused vcpu function parameters and asm-offset definitions.

Cleaner code and simplifies future refactoring.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h   | 4 ++--
 arch/arm64/kernel/asm-offsets.c    | 1 -
 arch/arm64/kvm/hyp/nvhe/switch.c   | 6 +++---
 arch/arm64/kvm/hyp/nvhe/timer-sr.c | 4 ++--
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 9d60b3006efc..2e2b60a1b6c7 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -66,8 +66,8 @@ void __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __timer_enable_traps(struct kvm_vcpu *vcpu);
-void __timer_disable_traps(struct kvm_vcpu *vcpu);
+void __timer_enable_traps(void);
+void __timer_disable_traps(void);
 #endif
 
 #ifdef __KVM_NVHE_HYPERVISOR__
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 0cb34ccb6e73..c2cc3a2813e6 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -109,7 +109,6 @@ int main(void)
   DEFINE(VCPU_CONTEXT,		offsetof(struct kvm_vcpu, arch.ctxt));
   DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
   DEFINE(VCPU_WORKAROUND_FLAGS,	offsetof(struct kvm_vcpu, arch.workaround_flags));
-  DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
   DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_cpu_context, regs));
   DEFINE(CPU_APIAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIAKEYLO_EL1]));
   DEFINE(CPU_APIBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIBKEYLO_EL1]));
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index f7af9688c1f7..9296d7108f93 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -217,7 +217,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__activate_traps(vcpu);
 
 	__hyp_vgic_restore_state(vcpu);
-	__timer_enable_traps(vcpu);
+	__timer_enable_traps();
 
 	__debug_switch_to_guest(vcpu);
 
@@ -230,7 +230,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_save_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
-	__timer_disable_traps(vcpu);
+	__timer_disable_traps();
 	__hyp_vgic_save_state(vcpu);
 
 	__deactivate_traps(vcpu);
@@ -272,7 +272,7 @@ void __noreturn hyp_panic(void)
 	vcpu = host_ctxt->__hyp_running_vcpu;
 
 	if (vcpu) {
-		__timer_disable_traps(vcpu);
+		__timer_disable_traps();
 		__deactivate_traps(vcpu);
 		__load_host_stage2();
 		__sysreg_restore_state_nvhe(host_ctxt);
diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index 9072e71693ba..7b2a23ccdb0a 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -19,7 +19,7 @@ void __kvm_timer_set_cntvoff(u64 cntvoff)
  * Should only be called on non-VHE systems.
  * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
  */
-void __timer_disable_traps(struct kvm_vcpu *vcpu)
+void __timer_disable_traps(void)
 {
 	u64 val;
 
@@ -33,7 +33,7 @@ void __timer_disable_traps(struct kvm_vcpu *vcpu)
  * Should only be called on non-VHE systems.
  * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
  */
-void __timer_enable_traps(struct kvm_vcpu *vcpu)
+void __timer_enable_traps(void)
 {
 	u64 val;
 
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
