Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3BE3C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 08:41:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89AEC4B1C3;
	Fri,  8 Apr 2022 04:41:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id geIFpvX5pne3; Fri,  8 Apr 2022 04:41:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48BD940B7D;
	Fri,  8 Apr 2022 04:41:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33BD84B150
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 04:41:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4QiR4Q2T47DI for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 04:40:59 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B00614B15E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 04:40:59 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 v191-20020a1cacc8000000b0038ce818d2efso2084853wme.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2022 01:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=AN6Z4bkLNX2uGfXH7hceP8OFltZJdOCeyELTWYGKgio=;
 b=mX6soc29ZsfPe6gEIwRg34xBBwnATbjFyw7ih0K/+4fQh1TWWXcFiNG0vHv61WvaPT
 bBFEsRxVaYJEWLJUiZygEs0fNAJS7Ab789peCZpPz++ae6cvr85lp+PBE9jJZhCMfStr
 OPzp6wlHmALgLXDq8OCjhvN66uF7rI9ZegxHMkggv5FbqqP6G4c/vRMomn0DzqOO3BzC
 r4UUCweqtsBIg9+ENunc/671FmQQ6WkWGXRLnb5YapCJpKrEitzeqpfWTH0ESFvKmiAV
 /8DlYZiacRL/6+u4XmAtf2dnl3Mbd3s93wxxe7xyQNC0mOVW5e8/uSPvz5ASb7H/pmSr
 i3ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=AN6Z4bkLNX2uGfXH7hceP8OFltZJdOCeyELTWYGKgio=;
 b=ecMvNJ7AmcdzTFK+hpUGxr4OdI/6TVHY5giUmPUbuV8H3XP4JJBjOhc5phNSxeBFqb
 aEqffhEzv6m5Yp+DJRiqIGtjvilrIvyPvs8zRhjZPm9AamMK4t+qcjwNbp+Ag0zkL608
 rH5Uzn/84PVEm68rYlwpuWmQqOtW7HzcJpaYwRYkeLMTzZ2S3Rm9fxu5UkM82JFSQSFT
 1qSlnObeYpl0UO6Zh1IFX5GeCNFMtVrgHOFcaTTxe2wf0OaJo0O8dqtjn4i/HzTfPERR
 2UCEXankrs4805LWoW4pSVfkDa97RdpYrCK8wqQ4xed1PdBpMY7Lf4XI8U0QKXH3YcLi
 qWfw==
X-Gm-Message-State: AOAM5332g3N8ktO4IyF/rQ6cLeCJ3DY+89XVV0DJgowj1hYhn82esxCk
 aOg2JRdVTRwdQrRXtE9L7i/Sjz+q708BGQXlc8WmNiRGMxL5WNVGfz2ukrL8VYYXHbQ4yCVCwU7
 tWobXRj+GxNuFoHZ2upHnrO9Q174IFjdNe2jfDrKSZ0bkcjqVWM73SC5PrZxNJ58Ztw8=
X-Google-Smtp-Source: ABdhPJyP1boonFGrzHCz7hvU6W8UWP6E9RA1Ls2TTk+LkQKRlXBIsBIcfzdpHXiQa1B0YoMLpQLccAs+FQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:c057:0:b0:37b:ebad:c9c8 with
 SMTP id
 u23-20020a7bc057000000b0037bebadc9c8mr15647927wmc.61.1649407258833; Fri, 08
 Apr 2022 01:40:58 -0700 (PDT)
Date: Fri,  8 Apr 2022 09:40:51 +0100
In-Reply-To: <20220408084052.3310931-1-tabba@google.com>
Message-Id: <20220408084052.3310931-3-tabba@google.com>
Mime-Version: 1.0
References: <20220408084052.3310931-1-tabba@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v1 2/3] KVM: arm64: Pass pmu events to hyp via vcpu
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
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

Instead of accessing hyp data, pass the pmu events of the current
cpu to hyp via the loaded vcpu.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  8 ++------
 arch/arm64/kvm/arm.c              |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c  | 20 ++++++--------------
 arch/arm64/kvm/pmu.c              | 22 +++++++++++++---------
 include/kvm/arm_pmu.h             |  6 ++++++
 5 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0e96087885fe..b5cdfb6cb9c7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -244,14 +244,8 @@ struct kvm_cpu_context {
 	struct kvm_vcpu *__hyp_running_vcpu;
 };
 
-struct kvm_pmu_events {
-	u32 events_host;
-	u32 events_guest;
-};
-
 struct kvm_host_data {
 	struct kvm_cpu_context host_ctxt;
-	struct kvm_pmu_events pmu_events;
 };
 
 struct kvm_host_psci_config {
@@ -728,6 +722,7 @@ void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
 DECLARE_KVM_HYP_PER_CPU(struct kvm_host_data, kvm_host_data);
+DECLARE_PER_CPU(struct kvm_pmu_events, kvm_pmu_events);
 
 static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
 {
@@ -781,6 +776,7 @@ void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
 void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
 void kvm_clr_pmu_events(u32 clr);
 
+void kvm_vcpu_pmu_load(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 #else
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ba9165e84396..e6f76d843558 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -400,7 +400,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (has_vhe())
 		kvm_vcpu_load_sysregs_vhe(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
-	kvm_vcpu_pmu_restore_guest(vcpu);
+	kvm_vcpu_pmu_load(vcpu);
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6410d21d8695..ff7b29fb9787 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -123,13 +123,9 @@ static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 /**
  * Disable host events, enable guest events
  */
-static bool __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
+static bool __pmu_switch_to_guest(struct kvm_vcpu *vcpu)
 {
-	struct kvm_host_data *host;
-	struct kvm_pmu_events *pmu;
-
-	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
-	pmu = &host->pmu_events;
+	struct kvm_pmu_events *pmu = &vcpu->arch.pmu.events;
 
 	if (pmu->events_host)
 		write_sysreg(pmu->events_host, pmcntenclr_el0);
@@ -143,13 +139,9 @@ static bool __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
 /**
  * Disable guest events, enable host events
  */
-static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
+static void __pmu_switch_to_host(struct kvm_vcpu *vcpu)
 {
-	struct kvm_host_data *host;
-	struct kvm_pmu_events *pmu;
-
-	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
-	pmu = &host->pmu_events;
+	struct kvm_pmu_events *pmu = &vcpu->arch.pmu.events;
 
 	if (pmu->events_guest)
 		write_sysreg(pmu->events_guest, pmcntenclr_el0);
@@ -274,7 +266,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
-	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
+	pmu_switch_needed = __pmu_switch_to_guest(vcpu);
 
 	__sysreg_save_state_nvhe(host_ctxt);
 	/*
@@ -336,7 +328,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__debug_restore_host_buffers_nvhe(vcpu);
 
 	if (pmu_switch_needed)
-		__pmu_switch_to_host(host_ctxt);
+		__pmu_switch_to_host(vcpu);
 
 	/* Returning to host will clear PSR.I, remask PMR if needed */
 	if (system_uses_irq_prio_masking())
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 310d47c9990f..8f722692fb58 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -5,7 +5,8 @@
  */
 #include <linux/kvm_host.h>
 #include <linux/perf_event.h>
-#include <asm/kvm_hyp.h>
+
+DEFINE_PER_CPU(struct kvm_pmu_events, kvm_pmu_events);
 
 /*
  * Given the perf event attributes and system type, determine
@@ -27,12 +28,7 @@ static bool kvm_pmu_switch_needed(struct perf_event_attr *attr)
 
 static struct kvm_pmu_events *get_kvm_pmu_events(void)
 {
-	struct kvm_host_data *ctx = this_cpu_ptr_hyp_sym(kvm_host_data);
-
-	if (!ctx)
-		return NULL;
-
-	return &ctx->pmu_events;
+	return this_cpu_ptr(&kvm_pmu_events);
 }
 
 /*
@@ -43,7 +39,7 @@ void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
 {
 	struct kvm_pmu_events *pmu = get_kvm_pmu_events();
 
-	if (!kvm_arm_support_pmu_v3() || !pmu || !kvm_pmu_switch_needed(attr))
+	if (!kvm_arm_support_pmu_v3() || !kvm_pmu_switch_needed(attr))
 		return;
 
 	if (!attr->exclude_host)
@@ -59,7 +55,7 @@ void kvm_clr_pmu_events(u32 clr)
 {
 	struct kvm_pmu_events *pmu = get_kvm_pmu_events();
 
-	if (!kvm_arm_support_pmu_v3() || !pmu)
+	if (!kvm_arm_support_pmu_v3())
 		return;
 
 	pmu->events_host &= ~clr;
@@ -213,3 +209,11 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
 	kvm_vcpu_pmu_enable_el0(events_host);
 	kvm_vcpu_pmu_disable_el0(events_guest);
 }
+
+void kvm_vcpu_pmu_load(struct kvm_vcpu *vcpu)
+{
+	kvm_vcpu_pmu_restore_guest(vcpu);
+
+	if (kvm_arm_support_pmu_v3() && !has_vhe())
+		vcpu->arch.pmu.events = *get_kvm_pmu_events();
+}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 20193416d214..0b3898e0313f 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -20,6 +20,11 @@ struct kvm_pmc {
 	struct perf_event *perf_event;
 };
 
+struct kvm_pmu_events {
+	u32 events_host;
+	u32 events_guest;
+};
+
 struct kvm_pmu {
 	int irq_num;
 	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
@@ -27,6 +32,7 @@ struct kvm_pmu {
 	bool created;
 	bool irq_level;
 	struct irq_work overflow_work;
+	struct kvm_pmu_events events;
 };
 
 struct arm_pmu_entry {
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
