Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98874C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 12:03:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50E9E4B2F6;
	Mon,  9 May 2022 08:03:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c7j4nJPWEeNY; Mon,  9 May 2022 08:03:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04C044B2FC;
	Mon,  9 May 2022 08:03:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A0BC4B2EC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 08:03:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 81250+eS7Apd for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 08:03:40 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 69A074B2F6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 08:03:39 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 o11-20020adfca0b000000b0020adc114131so5681473wrh.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 05:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=+NI1KNWkSZIlS5W0iJiER/VBsfQ9lOQohEly/fxvSOk=;
 b=YjVOqOBTPBTXdidDhWbdBP2lKnWm6u8fO0oRbRkPfB6qM4xyALDByU6hEL6IWHuma5
 ZUvhVRXFC2Wap2opmSvPkkYyqZj40zdEb3sONq9Hu07CKa7bWO5HyJLpFgB//5qcN8WX
 +o8FT3pCN8Qo1f+BYBtkSwQA7rcpV7b+GR1eqJC4bJI9Ff3BznGqLRU9LSQ4+sKIZ00m
 EekSF8GQGLRmP3UhUlAo37zdJGCRMlhHRVCtGt/IgJcIpnDZMV4Xiqv0JWLDgxv0n6mt
 043BjNytPoIMR4LxKTHyJLOOaaoI3LSI9gSzUmj1d2Xj8ZzK6BPo5iX7V2o7Y9Gxv9JJ
 rUIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=+NI1KNWkSZIlS5W0iJiER/VBsfQ9lOQohEly/fxvSOk=;
 b=vuf7B1+7rJGcI5SuNOVT9KJq0FNsAHdAQVcxhY1Ej9rGw6nVQFk4IcfiOeqes3beEB
 I0qNmzR4qFDtgPoK4w+xk4s5YCHJm53oWaJZSx26ETKya0IXaWFEh8MLhrlJJfsSMbTA
 oAsJvhWewrRCdDjmdmdFoa82c7ozWbY/goGuNXP2cS0u7T8DeH+1GsL4k5X0gZMXwU3C
 TP2TNyVWY5LeI5+1qUtiRJNJmIyDFeM7yEokn5YQJLMB9x2WWOC64Z/s0hV/uXlhJLAZ
 iNOxWJajWO89OdXz3igrTlmZ7aBNq14VdMJkOfbVACClVZD4xpQNCRYq54Rz6eTIByXR
 rjKw==
X-Gm-Message-State: AOAM5322xOCALvWhIj1Qg2V2PgSZpClPgZRRBw0NorzapTvwSNkrTSML
 kQx3QJ+EOARixxLKCi2k6zta020vHn48MHRTA+5CC6PmAehOmlOCBWqpAltVg69vVgQzFfTQNE5
 gavgV8sS32x5PNHdFzU0CARw99M0NaaqwuFDmGIe8wuxaAAO21aaCAJxMCxDeal7NA48=
X-Google-Smtp-Source: ABdhPJwzeCAcdSiIYrG/TdMKmXwUguVM0XXYHg3/0ZsBlUNcn8xYti7LaJB7oSYq2WF2hduKV26EnpoIHA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a7b:c841:0:b0:394:890e:9195 with
 SMTP id
 c1-20020a7bc841000000b00394890e9195mr7729853wml.59.1652097818508; Mon, 09 May
 2022 05:03:38 -0700 (PDT)
Date: Mon,  9 May 2022 12:03:29 +0000
In-Reply-To: <20220509120330.3043773-1-tabba@google.com>
Message-Id: <20220509120330.3043773-4-tabba@google.com>
Mime-Version: 1.0
References: <20220509120330.3043773-1-tabba@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v3 3/4] KVM: arm64: Pass pmu events to hyp via vcpu
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
 arch/arm64/include/asm/kvm_host.h |  8 ++------
 arch/arm64/kvm/arm.c              | 15 +++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c  | 20 ++++++--------------
 arch/arm64/kvm/pmu.c              | 12 ++++--------
 include/kvm/arm_pmu.h             |  6 ++++++
 5 files changed, 33 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index dfd360404dd8..90476e713643 100644
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
@@ -763,6 +757,7 @@ void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
 DECLARE_KVM_HYP_PER_CPU(struct kvm_host_data, kvm_host_data);
+DECLARE_PER_CPU(struct kvm_pmu_events, kvm_pmu_events);
 
 static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
 {
@@ -821,6 +816,7 @@ void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
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
index 4bd38ff34221..c19bf6e4969e 100644
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
