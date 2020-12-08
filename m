Return-Path: <SRS0=0wdR=FM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA64FC4361B
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 14:25:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A13F23A33
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 14:25:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A13F23A33
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA2F14B271;
	Tue,  8 Dec 2020 09:25:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aYcwDYRXhpEZ; Tue,  8 Dec 2020 09:25:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B47414B281;
	Tue,  8 Dec 2020 09:25:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 696204B272
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 09:25:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QEOd1ExObLzb for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2020 09:25:02 -0500 (EST)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B9954B232
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 09:25:02 -0500 (EST)
Received: by mail-wr1-f68.google.com with SMTP id t4so16385324wrr.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Dec 2020 06:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=ZJVcW+gDZ2QoZEFI86wiRHeEnmSVBb/mqFwXrVdG81k=;
 b=JuodSu1f9maE2qhArXiU3zxnxd+Aa1T/qMyiVTbr02hSTThljFG0K8+XSuMk4C0I98
 0VaePBU0TePTYesJkS4wRGX2eLRP5rumtaLHudGToFoRx+rnWJGJKrkv87+jGXtZRwng
 ZRR0fP3GIFkKYGa8TSriFT8dkl7x8HXQC8XnCuhoZUKJVjkX14Y4IOp0vTvR/8O17plK
 SwPJlzQ3cszZ0KBxIj+UrHjQynYhPQgVPKRc2h4WiO8zgJwuVmZyJxu/VcYkh5g2iAgW
 LA1Eo7zh7aF1jUUXxzGvEI7fwv++bQjB3joY5++AW/v2tM1QJ1lF1lEYOv/S2a/XvQgr
 bIhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=ZJVcW+gDZ2QoZEFI86wiRHeEnmSVBb/mqFwXrVdG81k=;
 b=q5ZYDOkR6PXfv4qeyySbhBhHXUOQmXZ6wABjHUrr8xv5STTeBf5BzfYy6H12b+swn6
 up9v7bCI0Dj1KLhlddbQf9hQAZ4hQ0TpMMJ7HgApe5oUTMniJpXP/G65nQgxdzfVFgYX
 ZssGaxVRZbmkWPZt3HgjyVS6SffGQcRGek1B3OYcHNHUzmYHsTxUMEtXrW1r5ZlmnUqt
 1dEwkjCOvBO9YTI2dG23Uck/qYVudBB36jqS7rLIfgI5xdrITuudpM/RUzwSyTOnz4ND
 lYX+nkqTQg1x8g7aBYBYlphT24XjPRuWmyClTYZ/jby85IP6A2QPicr0HS/u1xoy71sJ
 Ah+Q==
X-Gm-Message-State: AOAM5319XqTwtdWFu+4IN96iCrbhc5dIr/TAQ52TId87TIE7DoybbluI
 Q/9VQb5qDFbk9pRIYkHtom7j3pb9SVbY4g==
X-Google-Smtp-Source: ABdhPJz8XZZNRVczP1MNa+5GwvK6arhmg8wv+WVN7EM+CgWkgNOsNuQYcOEIW/yFZ+6gPYaHW1knsg==
X-Received: by 2002:adf:dc87:: with SMTP id r7mr3566881wrj.305.1607437501067; 
 Tue, 08 Dec 2020 06:25:01 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:258e:cb26:cef:a620])
 by smtp.gmail.com with ESMTPSA id i8sm3763850wma.32.2020.12.08.06.24.59
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 08 Dec 2020 06:24:59 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/6] kvm: arm64: Prevent use of invalid PSCI v0.1 function IDs
Date: Tue,  8 Dec 2020 14:24:47 +0000
Message-Id: <20201208142452.87237-2-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201208142452.87237-1-dbrazdil@google.com>
References: <20201208142452.87237-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

PSCI driver exposes a struct containing the PSCI v0.1 function IDs
configured in the DT. However, the struct does not convey the
information whether these were set from DT or contain the default value
zero. This could be a problem for PSCI proxy in KVM protected mode.

Extend config passed to KVM with a bit mask with individual bits set
depending on whether the corresponding function pointer in psci_ops is
set, eg. set bit for PSCI_CPU_SUSPEND if psci_ops.cpu_suspend != NULL.

Previously config was split into multiple global variables. Put
everything into a single struct for convenience.

Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_host.h    | 20 +++++++++++
 arch/arm64/kvm/arm.c                 | 14 +++++---
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 53 +++++++++++++++++++++-------
 3 files changed, 70 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 11beda85ee7e..828d50d40dc2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -17,6 +17,7 @@
 #include <linux/jump_label.h>
 #include <linux/kvm_types.h>
 #include <linux/percpu.h>
+#include <linux/psci.h>
 #include <asm/arch_gicv3.h>
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
@@ -240,6 +241,25 @@ struct kvm_host_data {
 	struct kvm_pmu_events pmu_events;
 };
 
+#define KVM_HOST_PSCI_0_1_CPU_SUSPEND	BIT(0)
+#define KVM_HOST_PSCI_0_1_CPU_ON	BIT(1)
+#define KVM_HOST_PSCI_0_1_CPU_OFF	BIT(2)
+#define KVM_HOST_PSCI_0_1_MIGRATE	BIT(3)
+
+struct kvm_host_psci_config {
+	/* PSCI version used by host. */
+	u32 version;
+
+	/* Function IDs used by host if version is v0.1. */
+	struct psci_0_1_function_ids function_ids_0_1;
+
+	/* Bitmask of functions enabled for v0.1, bits KVM_HOST_PSCI_0_1_*. */
+	unsigned int enabled_functions_0_1;
+};
+
+extern struct kvm_host_psci_config kvm_nvhe_sym(kvm_host_psci_config);
+#define kvm_host_psci_config CHOOSE_NVHE_SYM(kvm_host_psci_config)
+
 struct vcpu_reset_state {
 	unsigned long	pc;
 	unsigned long	r0;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6e637d2b4cfb..6a2f4e01b04f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -66,8 +66,6 @@ static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
 DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 extern u64 kvm_nvhe_sym(__cpu_logical_map)[NR_CPUS];
-extern u32 kvm_nvhe_sym(kvm_host_psci_version);
-extern struct psci_0_1_function_ids kvm_nvhe_sym(kvm_host_psci_0_1_function_ids);
 
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
@@ -1618,8 +1616,16 @@ static bool init_psci_relay(void)
 		return false;
 	}
 
-	kvm_nvhe_sym(kvm_host_psci_version) = psci_ops.get_version();
-	kvm_nvhe_sym(kvm_host_psci_0_1_function_ids) = get_psci_0_1_function_ids();
+	kvm_host_psci_config.version = psci_ops.get_version();
+
+	if (kvm_host_psci_config.version == PSCI_VERSION(0, 1)) {
+		kvm_host_psci_config.function_ids_0_1 = get_psci_0_1_function_ids();
+		kvm_host_psci_config.enabled_functions_0_1 =
+			(psci_ops.cpu_suspend ? KVM_HOST_PSCI_0_1_CPU_SUSPEND : 0) |
+			(psci_ops.cpu_off ? KVM_HOST_PSCI_0_1_CPU_OFF : 0) |
+			(psci_ops.cpu_on ? KVM_HOST_PSCI_0_1_CPU_ON : 0) |
+			(psci_ops.migrate ? KVM_HOST_PSCI_0_1_MIGRATE : 0);
+	}
 	return true;
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 08dc9de69314..0d6f4aa39621 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -22,9 +22,8 @@ void kvm_hyp_cpu_resume(unsigned long r0);
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
 
 /* Config options set by the host. */
-__ro_after_init u32 kvm_host_psci_version;
-__ro_after_init struct psci_0_1_function_ids kvm_host_psci_0_1_function_ids;
-__ro_after_init s64 hyp_physvirt_offset;
+struct kvm_host_psci_config __ro_after_init kvm_host_psci_config;
+s64 __ro_after_init hyp_physvirt_offset;
 
 #define __hyp_pa(x) ((phys_addr_t)((x)) + hyp_physvirt_offset)
 
@@ -54,12 +53,41 @@ static u64 get_psci_func_id(struct kvm_cpu_context *host_ctxt)
 	return func_id;
 }
 
+static inline bool is_psci_0_1_function_enabled(unsigned int fn_bit)
+{
+	return kvm_host_psci_config.enabled_functions_0_1 & fn_bit;
+}
+
+static inline bool is_psci_0_1_cpu_suspend(u64 func_id)
+{
+	return is_psci_0_1_function_enabled(KVM_HOST_PSCI_0_1_CPU_SUSPEND) &&
+	       (func_id == kvm_host_psci_config.function_ids_0_1.cpu_suspend);
+}
+
+static inline bool is_psci_0_1_cpu_on(u64 func_id)
+{
+	return is_psci_0_1_function_enabled(KVM_HOST_PSCI_0_1_CPU_ON) &&
+	       (func_id == kvm_host_psci_config.function_ids_0_1.cpu_on);
+}
+
+static inline bool is_psci_0_1_cpu_off(u64 func_id)
+{
+	return is_psci_0_1_function_enabled(KVM_HOST_PSCI_0_1_CPU_OFF) &&
+	       (func_id == kvm_host_psci_config.function_ids_0_1.cpu_off);
+}
+
+static inline bool is_psci_0_1_migrate(u64 func_id)
+{
+	return is_psci_0_1_function_enabled(KVM_HOST_PSCI_0_1_MIGRATE) &&
+	       (func_id == kvm_host_psci_config.function_ids_0_1.migrate);
+}
+
 static bool is_psci_0_1_call(u64 func_id)
 {
-	return (func_id == kvm_host_psci_0_1_function_ids.cpu_suspend) ||
-	       (func_id == kvm_host_psci_0_1_function_ids.cpu_on) ||
-	       (func_id == kvm_host_psci_0_1_function_ids.cpu_off) ||
-	       (func_id == kvm_host_psci_0_1_function_ids.migrate);
+	return is_psci_0_1_cpu_suspend(func_id) ||
+	       is_psci_0_1_cpu_on(func_id) ||
+	       is_psci_0_1_cpu_off(func_id) ||
+	       is_psci_0_1_migrate(func_id);
 }
 
 static bool is_psci_0_2_call(u64 func_id)
@@ -71,7 +99,7 @@ static bool is_psci_0_2_call(u64 func_id)
 
 static bool is_psci_call(u64 func_id)
 {
-	switch (kvm_host_psci_version) {
+	switch (kvm_host_psci_config.version) {
 	case PSCI_VERSION(0, 1):
 		return is_psci_0_1_call(func_id);
 	default:
@@ -248,12 +276,11 @@ asmlinkage void __noreturn kvm_host_psci_cpu_entry(bool is_cpu_on)
 
 static unsigned long psci_0_1_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
 {
-	if ((func_id == kvm_host_psci_0_1_function_ids.cpu_off) ||
-	    (func_id == kvm_host_psci_0_1_function_ids.migrate))
+	if (is_psci_0_1_cpu_off(func_id) || is_psci_0_1_migrate(func_id))
 		return psci_forward(host_ctxt);
-	else if (func_id == kvm_host_psci_0_1_function_ids.cpu_on)
+	else if (is_psci_0_1_cpu_on(func_id))
 		return psci_cpu_on(func_id, host_ctxt);
-	else if (func_id == kvm_host_psci_0_1_function_ids.cpu_suspend)
+	else if (is_psci_0_1_cpu_suspend(func_id))
 		return psci_cpu_suspend(func_id, host_ctxt);
 	else
 		return PSCI_RET_NOT_SUPPORTED;
@@ -304,7 +331,7 @@ bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt)
 	if (!is_psci_call(func_id))
 		return false;
 
-	switch (kvm_host_psci_version) {
+	switch (kvm_host_psci_config.version) {
 	case PSCI_VERSION(0, 1):
 		ret = psci_0_1_handler(func_id, host_ctxt);
 		break;
-- 
2.29.2.576.ga3fc446d84-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
