Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA33C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 09:55:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 370AB4B2BF;
	Mon,  9 May 2022 05:55:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Pj326XeKAEpt; Mon,  9 May 2022 05:55:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAE164B2E9;
	Mon,  9 May 2022 05:55:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A19354B2DF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 05:55:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dS0iE443SmL5 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 05:55:10 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A2054B2EE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 05:55:10 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 q128-20020a1c4386000000b003942fe15835so4052526wma.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 02:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=2rvTcY9BIidUHBzUA7XA8Q6RA0v9exR5wW0SzS1W6F4=;
 b=Eu10ysdebvTsP+EnWopeahOnUjwyJ+1XlqpgzFvpqYoMuxqBcRYtM9MsZf9z97wOx8
 gjqXjscFJuWywUVv78VDUwtpcTQAfNqVUcS24PhrHM3Cj4+x3IiRg6b0FpHLRV+7Pq3o
 LI/iafDStMJ6z9O5zsvnsmSzBzpiHFMzDdu8huJweJRCXuWJdGYeBNq1B4/slrB47k3r
 qchh1z9t3RzkKdVGB1ObsNhyOlE0C/fjeCajktoFl8Ydraf/1JIO56rCn/9U5BEHPiPi
 eXDfnBop4YIQnxDy9+kH2bbf40OdA4IPid/e4xEX8wovXm4hyComdVt1APcyENrzYEaP
 /QpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=2rvTcY9BIidUHBzUA7XA8Q6RA0v9exR5wW0SzS1W6F4=;
 b=JvieZ07kUZPlbMYrIbk+a4dL2VBKRMP9WteKkpWSTQjJr3Psucz4ueEaXufbxynruZ
 X57uu19FPIlC+Cdq0BGqOKPTsQsxWUADTsIQ6HS1c7SG6dYXeTQq3ee10ihhBDzsNK6E
 DRfVzReSK9g2jnodBdGecweib+GpqZ6pNzWd6y+BN69SBq8BbMIXcdF927ohd96EqlIT
 MezdVhXD3o8E9PLWzfOwaGNPnRmYs1wH/Wd+qX5PlFav4SlE9har7Ztc1Db3wj8+ZQai
 Box8GIgsKgxuA/YnMp2mOKVx9Xtj9qmo5Q4mJDAAjjXfgrp085Gc/1qdvCICTV+ULtvI
 1Bxg==
X-Gm-Message-State: AOAM530b0Ba7nZvhx+JvBChcyuRMWkGUWul9BFEFIEyegYSyo7VT3k8N
 9HzorLaNiP4GXoGi2XAhJF3AT7t57RAlLHmry4lZ1kFsXK66gJox6pZdWWZha8wklodS31YyIpn
 qmn2R+bdZbkNjq8UP8pWX6Nw6KrjHkuwDwldJ+LxS/2nZFLtLVPpHxyQIm6ATSTSFnuA=
X-Google-Smtp-Source: ABdhPJzjTAgXr2h2XYZ99cUNQCnmXnvSrT1v3AP89aVNWj1oExbUdjEjmTGtaH0roBRZm47fkEAAbVhX8g==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a7b:cb47:0:b0:393:dd9f:e64a with
 SMTP id
 v7-20020a7bcb47000000b00393dd9fe64amr21391076wmj.170.1652090109396; Mon, 09
 May 2022 02:55:09 -0700 (PDT)
Date: Mon,  9 May 2022 09:54:59 +0000
In-Reply-To: <20220509095500.2408785-1-tabba@google.com>
Message-Id: <20220509095500.2408785-4-tabba@google.com>
Mime-Version: 1.0
References: <20220509095500.2408785-1-tabba@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v2 3/4] KVM: arm64: Pass pmu events to hyp via vcpu
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

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  8 ++------
 arch/arm64/kvm/hyp/nvhe/switch.c  | 20 ++++++--------------
 arch/arm64/kvm/pmu-emul.c         |  3 +++
 arch/arm64/kvm/pmu.c              | 12 ++++--------
 include/kvm/arm_pmu.h             |  6 ++++++
 5 files changed, 21 insertions(+), 28 deletions(-)

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
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 3dc990ac4f44..08d0551a4e43 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -406,6 +406,9 @@ static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return;
 
+	if (!has_vhe())
+		pmu->events = *kvm_get_pmu_events();
+
 	overflow = !!kvm_pmu_overflow_status(vcpu);
 	if (pmu->irq_level == overflow)
 		return;
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
