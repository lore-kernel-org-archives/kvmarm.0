Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F808C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 09:57:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C79CB4B17B;
	Tue, 10 May 2022 05:57:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xHElfXCgZrIm; Tue, 10 May 2022 05:57:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CCAD4B133;
	Tue, 10 May 2022 05:57:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 752B249EE8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 05:57:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gSntmquFI5qv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 May 2022 05:57:19 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1219449F02
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 05:57:19 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 q6-20020a1cf306000000b0038c5726365aso584773wmq.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 02:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=cdS24URiQ9hDODL+n8hjhO6nhNMKCwWb+mMIRmYF2dE=;
 b=LsxlGn3eK/gaXkjid+4h362uyvEp3HGbkEplRLogSnmiaj0lRIdwKGAgLduIpPBftQ
 pLmCrau8dDHXNwaHu4HEqCe8Lbi1tgDONAzIMlrWcUTkzeZJjxzxUQD7GZGjUl/OaZIn
 CpjISr4fHhXotMlUTNR6HVF9p308yrRwu7StRd65i6yFHItM8QuMpJK2lFC/s0bpDekm
 +YqiVYNfEwhyk+nD6n5R/FEc9hLhk/cpTduDrilN7N4PgsbFlnwRyRRE7Atcd1gnLNdX
 n43rnbucqe4CkX5f/hXqTU2m4lTHBupGli/msS8c1D5vCb6g+vhCmMKs0WYmYXkqIm4y
 wWQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=cdS24URiQ9hDODL+n8hjhO6nhNMKCwWb+mMIRmYF2dE=;
 b=1Sey5bS5w/X1ZBieR4rVp60NW324GfSU2FNaHGOjkdUYgh7eqZZjHUG3oaRzBWWEnn
 XuwmkE0onAniWvhSTiEMDWSeHKcsvllnd+FBUClMQQjgHt+qpYutLsLPsPvoW44jr23k
 RBS8khxdYTAFcg+PqngiSsz/xXhttROdRB6Ejyb6bz/zZpwOPNe68hkaOBjKOtW75v5y
 VKICwgV9vr72UePCcezSHhGNJ4hV0AVnJTujkHKe7TpxVZ2jmA+lqj74xyBuoSlCUyuR
 lGgMCKT3m+Gb5T5jSx0a61a7X7GvRq+Yu/nwLtEKO5WvkohvAiZoImz5W5S3/vOn8gDq
 pWWA==
X-Gm-Message-State: AOAM530QcIQJtfRLUV+6jN93a/PDXgVSK9UOvxtvLGAz2Ow0lL+YwWVX
 AEk/Y7Yw9WJEXhkq2+gksSOeS3d6Gb3fqBXHi+Ru+d0zz1VZBW1R+00rGHFXfPOvi0BqOsrlnwD
 UmdRh6S1MgibW/TraL/cz9TBMAEi6DzcCTLlgDSkn7MtMQAPgZOVlWswyf61NtwzSNPM=
X-Google-Smtp-Source: ABdhPJyuURsCidMV8RPOnGu4WXw6fPmyFjVtCY0B1mzQVH/nVZwAMjdQVHwmXycuQXBgUXWOjrvPEfVqLw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:f9c7:0:b0:20a:dfa9:f4c3 with
 SMTP id
 w7-20020adff9c7000000b0020adfa9f4c3mr17960863wrr.289.1652176638133; Tue, 10
 May 2022 02:57:18 -0700 (PDT)
Date: Tue, 10 May 2022 09:57:09 +0000
In-Reply-To: <20220510095710.148178-1-tabba@google.com>
Message-Id: <20220510095710.148178-4-tabba@google.com>
Mime-Version: 1.0
References: <20220510095710.148178-1-tabba@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v4 3/4] KVM: arm64: Pass pmu events to hyp via vcpu
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

Instead of the host accessing hyp data directly, pass the pmu
events of the current cpu to hyp via the vcpu.

This adds 64 bits (in two fields) to the vcpu that need to be
synced before every vcpu run in nvhe and protected modes.
However, it isolates the hypervisor from the host, which allows
us to use pmu in protected mode in a subsequent patch.

No visible side effects in behavior intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  7 +------
 arch/arm64/kvm/arm.c              | 15 +++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c  | 20 ++++++--------------
 arch/arm64/kvm/pmu.c              | 12 ++++--------
 include/kvm/arm_pmu.h             |  6 ++++++
 5 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index dfd360404dd8..835dd5ef630b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -273,14 +273,8 @@ struct kvm_cpu_context {
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
@@ -821,6 +815,7 @@ void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
 void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
 void kvm_clr_pmu_events(u32 clr);
 
+struct kvm_pmu_events *kvm_get_pmu_events(void);
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 #else
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2adb5832a756..86bcdb2a23a8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -817,6 +817,19 @@ static int noinstr kvm_arm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+/*
+ * Updates the vcpu's view of the pmu events for this cpu.
+ * Must be called before every vcpu run after disabling interrupts, to ensure
+ * that an interrupt cannot fire and update the structure.
+ */
+static void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu)
+{
+	if (has_vhe() || !kvm_vcpu_has_pmu(vcpu))
+		return;
+
+	vcpu->arch.pmu.events = *kvm_get_pmu_events();
+}
+
 /**
  * kvm_arch_vcpu_ioctl_run - the main VCPU run function to execute guest code
  * @vcpu:	The VCPU pointer
@@ -882,6 +895,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		kvm_vgic_flush_hwstate(vcpu);
 
+		kvm_pmu_update_vcpu_events(vcpu);
+
 		/*
 		 * Ensure we set mode to IN_GUEST_MODE after we disable
 		 * interrupts and before the final VCPU requests check.
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 0716163313d6..c61120ec8d1a 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -153,13 +153,9 @@ static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 /*
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
@@ -173,13 +169,9 @@ static bool __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
 /*
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
@@ -304,7 +296,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
-	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
+	pmu_switch_needed = __pmu_switch_to_guest(vcpu);
 
 	__sysreg_save_state_nvhe(host_ctxt);
 	/*
@@ -366,7 +358,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__debug_restore_host_buffers_nvhe(vcpu);
 
 	if (pmu_switch_needed)
-		__pmu_switch_to_host(host_ctxt);
+		__pmu_switch_to_host(vcpu);
 
 	/* Returning to host will clear PSR.I, remask PMR if needed */
 	if (system_uses_irq_prio_masking())
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 4bd38ff34221..7887133d15f0 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -5,7 +5,8 @@
  */
 #include <linux/kvm_host.h>
 #include <linux/perf_event.h>
-#include <asm/kvm_hyp.h>
+
+static DEFINE_PER_CPU(struct kvm_pmu_events, kvm_pmu_events);
 
 /*
  * Given the perf event attributes and system type, determine
@@ -25,14 +26,9 @@ static bool kvm_pmu_switch_needed(struct perf_event_attr *attr)
 	return (attr->exclude_host != attr->exclude_guest);
 }
 
-static struct kvm_pmu_events *kvm_get_pmu_events(void)
+struct kvm_pmu_events *kvm_get_pmu_events(void)
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
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index eaa8290b116f..35a0903cae32 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -20,8 +20,14 @@ struct kvm_pmc {
 	struct perf_event *perf_event;
 };
 
+struct kvm_pmu_events {
+	u32 events_host;
+	u32 events_guest;
+};
+
 struct kvm_pmu {
 	struct irq_work overflow_work;
+	struct kvm_pmu_events events;
 	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
 	DECLARE_BITMAP(chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
 	int irq_num;
-- 
2.36.0.512.ge40c2bad7a-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
