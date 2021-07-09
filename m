Return-Path: <SRS0=w/1t=MB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A2AC07E9B
	for <kvmarm@archiver.kernel.org>; Fri,  9 Jul 2021 09:25:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 43F93613DF
	for <kvmarm@archiver.kernel.org>; Fri,  9 Jul 2021 09:25:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 43F93613DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E08E64A4A0;
	Fri,  9 Jul 2021 05:25:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id us3sXXI6fbsJ; Fri,  9 Jul 2021 05:25:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68AE44A4E5;
	Fri,  9 Jul 2021 05:25:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D887C4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jul 2021 00:37:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PLHQ9YY5ZRop for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Jul 2021 00:37:39 -0400 (EDT)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 72B0E40808
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jul 2021 00:37:39 -0400 (EDT)
Received: by mail-pl1-f170.google.com with SMTP id o4so4377622plg.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Jul 2021 21:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=ZZUGx6FUn/yCOexFnd62yjwoHeZYcMvsi4jsYnjIhcI=;
 b=mnqL5LKj1+FnamixOwkTSQeCEEsEDIiTJ4OrXzpL+MYCLTaIX8UceKo56jssGXfhya
 AiyKBgqPshL1jRfsrnva3VJkh9nIs5pzd7owYvCclj5HvzoDdtDpNgTYta2VlV97cVbq
 f719LMEdgFQMijyy0TdAzT9kq+olxmWAYTGWI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=ZZUGx6FUn/yCOexFnd62yjwoHeZYcMvsi4jsYnjIhcI=;
 b=WLhsVb1yyNCynd7GX3CkYhgta7AiFCEYv/ZAyjRs7MgnhFMDbp2jLtGaSSAwTp9Cd0
 8N3YlcVwZcyBFsBpcW0uE/nEzZOy2g4vSQITwrSqTffKFARUqI8gqcZ0//rwJqJL8OZa
 TDP1z3+kw8O5EqYI6dy6bJM00Ge90CgvWoW8cZI2yYxS7SRL90VdCMYJBdGlono38Myu
 3AoYcMVEU8G1j9AbHcdEOfmox9V9IZgvTDBhXbTz5s+H5jl0dW/AFpEI9lBmBQ39oGr0
 wXUmpAjvkojhECK1J5stvHkqPaAU1+6U0EIh3yXCBFkSW04qfbXJFXi2i0mXYCtTW9zD
 hfZQ==
X-Gm-Message-State: AOAM533HHkm8E2Ykz3xJRlVScfeG4AKucSfE5RfH++ihg4s+iCvCTrA4
 hLVQEDgw3D0tBVPG41bv5ScGtw==
X-Google-Smtp-Source: ABdhPJy83yDQ64mKLzi/SYhx94sw/R1wHIjE+W52lxng461RsjxcZZAvhU+WYZGbVC1nt6g8LZkI2g==
X-Received: by 2002:a17:903:18c:b029:125:b183:798f with SMTP id
 z12-20020a170903018cb0290125b183798fmr28860558plg.24.1625805458691; 
 Thu, 08 Jul 2021 21:37:38 -0700 (PDT)
Received: from senozhatsky.flets-east.jp
 ([2409:10:2e40:5100:a30d:fc4:7834:ee08])
 by smtp.gmail.com with ESMTPSA id y4sm4420760pfa.14.2021.07.08.21.37.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 08 Jul 2021 21:37:38 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCHv2 2/4] arm64: add guest pvstate support
Date: Fri,  9 Jul 2021 13:37:11 +0900
Message-Id: <20210709043713.887098-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
In-Reply-To: <20210709043713.887098-1-senozhatsky@chromium.org>
References: <20210709043713.887098-1-senozhatsky@chromium.org>
MIME-Version: 1.0
X-Mailman-Approved-At: Fri, 09 Jul 2021 05:25:42 -0400
Cc: Joel Fernandes <joelaf@google.com>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Suleiman Souhlal <suleiman@google.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

PV-vcpu-state is a per-CPU struct, which, for the time being,
holds boolean `preempted' vCPU state. During the startup,
given that host supports PV-state, each guest vCPU sends
a pointer to its per-CPU variable to the host as a payload
with the SMCCC HV call, so that host can update vCPU state
when it puts or loads vCPU.

This has impact on the guest's scheduler:

[..]
  wake_up_process()
   try_to_wake_up()
    select_task_rq_fair()
     available_idle_cpu()
      vcpu_is_preempted()

Some sched benchmarks data is available on the github page [0].

[0] https://github.com/sergey-senozhatsky/arm64-vcpu_is_preempted

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 arch/arm64/include/asm/paravirt.h | 19 +++++++
 arch/arm64/kernel/paravirt.c      | 94 +++++++++++++++++++++++++++++++
 arch/arm64/kernel/smp.c           |  4 ++
 3 files changed, 117 insertions(+)

diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
index 9aa193e0e8f2..a3f7665dff38 100644
--- a/arch/arm64/include/asm/paravirt.h
+++ b/arch/arm64/include/asm/paravirt.h
@@ -2,6 +2,11 @@
 #ifndef _ASM_ARM64_PARAVIRT_H
 #define _ASM_ARM64_PARAVIRT_H
 
+struct vcpu_state {
+	bool	preempted;
+	u8	reserved[63];
+};
+
 #ifdef CONFIG_PARAVIRT
 #include <linux/static_call_types.h>
 
@@ -20,8 +25,22 @@ static inline u64 paravirt_steal_clock(int cpu)
 
 int __init pv_time_init(void);
 
+bool dummy_vcpu_is_preempted(unsigned int cpu);
+
+extern struct static_key pv_vcpu_is_preempted_enabled;
+DECLARE_STATIC_CALL(pv_vcpu_is_preempted, dummy_vcpu_is_preempted);
+
+static inline bool paravirt_vcpu_is_preempted(unsigned int cpu)
+{
+	return static_call(pv_vcpu_is_preempted)(cpu);
+}
+
+int __init pv_vcpu_state_init(void);
+
 #else
 
+#define pv_vcpu_state_init() do {} while (0)
+
 #define pv_time_init() do {} while (0)
 
 #endif // CONFIG_PARAVIRT
diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
index 75fed4460407..d8fc46795d94 100644
--- a/arch/arm64/kernel/paravirt.c
+++ b/arch/arm64/kernel/paravirt.c
@@ -40,6 +40,11 @@ struct pv_time_stolen_time_region {
 
 static DEFINE_PER_CPU(struct pv_time_stolen_time_region, stolen_time_region);
 
+static DEFINE_PER_CPU(struct vcpu_state, vcpus_states);
+struct static_key pv_vcpu_is_preempted_enabled;
+
+DEFINE_STATIC_CALL(pv_vcpu_is_preempted, dummy_vcpu_is_preempted);
+
 static bool steal_acc = true;
 static int __init parse_no_stealacc(char *arg)
 {
@@ -165,3 +170,92 @@ int __init pv_time_init(void)
 
 	return 0;
 }
+
+bool dummy_vcpu_is_preempted(unsigned int cpu)
+{
+	return false;
+}
+
+static bool __vcpu_is_preempted(unsigned int cpu)
+{
+	struct vcpu_state *st;
+
+	st = &per_cpu(vcpus_states, cpu);
+	return READ_ONCE(st->preempted);
+}
+
+static bool has_pv_vcpu_state(void)
+{
+	struct arm_smccc_res res;
+
+	/* To detect the presence of PV time support we require SMCCC 1.1+ */
+	if (arm_smccc_1_1_get_conduit() == SMCCC_CONDUIT_NONE)
+		return false;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+			     ARM_SMCCC_HV_PV_VCPU_STATE_FEATURES,
+			     &res);
+
+	if (res.a0 != SMCCC_RET_SUCCESS)
+		return false;
+	return true;
+}
+
+static int __pv_vcpu_state_hook(unsigned int cpu, int event)
+{
+	struct arm_smccc_res res;
+	struct vcpu_state *st;
+
+	st = &per_cpu(vcpus_states, cpu);
+	arm_smccc_1_1_invoke(event, virt_to_phys(st), &res);
+	if (res.a0 != SMCCC_RET_SUCCESS)
+		return -EINVAL;
+	return 0;
+}
+
+static int vcpu_state_init(unsigned int cpu)
+{
+	int ret = __pv_vcpu_state_hook(cpu, ARM_SMCCC_HV_PV_VCPU_STATE_INIT);
+
+	if (ret)
+		pr_warn("Unable to ARM_SMCCC_HV_PV_STATE_INIT\n");
+	return ret;
+}
+
+static int vcpu_state_release(unsigned int cpu)
+{
+	int ret = __pv_vcpu_state_hook(cpu, ARM_SMCCC_HV_PV_VCPU_STATE_RELEASE);
+
+	if (ret)
+		pr_warn("Unable to ARM_SMCCC_HV_PV_STATE_RELEASE\n");
+	return ret;
+}
+
+static int pv_vcpu_state_register_hooks(void)
+{
+	int ret;
+
+	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
+				"hypervisor/arm/pvstate:starting",
+				vcpu_state_init,
+				vcpu_state_release);
+	if (ret < 0)
+		pr_warn("Failed to register CPU hooks\n");
+	return 0;
+}
+
+int __init pv_vcpu_state_init(void)
+{
+	int ret;
+
+	if (!has_pv_vcpu_state())
+		return 0;
+
+	ret = pv_vcpu_state_register_hooks();
+	if (ret)
+		return ret;
+
+	static_call_update(pv_vcpu_is_preempted, __vcpu_is_preempted);
+	static_key_slow_inc(&pv_vcpu_is_preempted_enabled);
+	return 0;
+}
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 6f6ff072acbd..20d42e0f2a99 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -50,6 +50,7 @@
 #include <asm/tlbflush.h>
 #include <asm/ptrace.h>
 #include <asm/virt.h>
+#include <asm/paravirt.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ipi.h>
@@ -756,6 +757,9 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	numa_store_cpu_info(this_cpu);
 	numa_add_cpu(this_cpu);
 
+	/* Init paravirt CPU state */
+	pv_vcpu_state_init();
+
 	/*
 	 * If UP is mandated by "nosmp" (which implies "maxcpus=0"), don't set
 	 * secondary CPUs present.
-- 
2.32.0.93.g670b81a890-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
