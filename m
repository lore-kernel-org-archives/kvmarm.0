Return-Path: <SRS0=9u6M=GK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD41C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 11:21:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3681823341
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 11:21:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3681823341
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D31AE4B3C2;
	Thu,  7 Jan 2021 06:21:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8IcWwgqRjYOZ; Thu,  7 Jan 2021 06:21:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 179094B3F4;
	Thu,  7 Jan 2021 06:21:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C68664B3BE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 06:21:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yJsrx4jm8Ux6 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jan 2021 06:21:29 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A6B54B3F5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 06:21:25 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id AB59323355;
 Thu,  7 Jan 2021 11:21:24 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kxTM2-005p1o-RZ; Thu, 07 Jan 2021 11:21:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 08/18] KVM: arm64: Declutter host PSCI 0.1 handling
Date: Thu,  7 Jan 2021 11:20:51 +0000
Message-Id: <20210107112101.2297944-9-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107112101.2297944-1-maz@kernel.org>
References: <20210107112101.2297944-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 catalin.marinas@arm.com, dbrazdil@google.com, eric.auger@redhat.com,
 mark.rutland@arm.com, natechancellor@gmail.com, qcai@redhat.com,
 shannon.zhao@linux.alibaba.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org, Qian Cai <qcai@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Shannon Zhao <shannon.zhao@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org,
 Nathan Chancellor <natechancellor@gmail.com>, kvmarm@lists.cs.columbia.edu
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

Although there is nothing wrong with the current host PSCI relay
implementation, we can clean it up and remove some of the helpers
that do not improve the overall readability of the legacy PSCI 0.1
handling.

Opportunity is taken to turn the bitmap into a set of booleans,
and creative use of preprocessor macros make init and check
more concise/readable.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h    | 11 ++--
 arch/arm64/kvm/arm.c                 | 12 +++--
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 77 +++++++---------------------
 3 files changed, 30 insertions(+), 70 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bce2452b305c..8fcfab0c2567 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -241,11 +241,6 @@ struct kvm_host_data {
 	struct kvm_pmu_events pmu_events;
 };
 
-#define KVM_HOST_PSCI_0_1_CPU_SUSPEND	BIT(0)
-#define KVM_HOST_PSCI_0_1_CPU_ON	BIT(1)
-#define KVM_HOST_PSCI_0_1_CPU_OFF	BIT(2)
-#define KVM_HOST_PSCI_0_1_MIGRATE	BIT(3)
-
 struct kvm_host_psci_config {
 	/* PSCI version used by host. */
 	u32 version;
@@ -253,8 +248,10 @@ struct kvm_host_psci_config {
 	/* Function IDs used by host if version is v0.1. */
 	struct psci_0_1_function_ids function_ids_0_1;
 
-	/* Bitmask of functions enabled for v0.1, bits KVM_HOST_PSCI_0_1_*. */
-	unsigned int enabled_functions_0_1;
+	bool psci_0_1_cpu_suspend_implemented;
+	bool psci_0_1_cpu_on_implemented;
+	bool psci_0_1_cpu_off_implemented;
+	bool psci_0_1_migrate_implemented;
 };
 
 extern struct kvm_host_psci_config kvm_nvhe_sym(kvm_host_psci_config);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 836ca763b91d..e207e4541f55 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1603,6 +1603,9 @@ static void init_cpu_logical_map(void)
 		hyp_cpu_logical_map[cpu] = cpu_logical_map(cpu);
 }
 
+#define init_psci_0_1_impl_state(config, what)	\
+	config.psci_0_1_ ## what ## _implemented = psci_ops.what
+
 static bool init_psci_relay(void)
 {
 	/*
@@ -1618,11 +1621,10 @@ static bool init_psci_relay(void)
 
 	if (kvm_host_psci_config.version == PSCI_VERSION(0, 1)) {
 		kvm_host_psci_config.function_ids_0_1 = get_psci_0_1_function_ids();
-		kvm_host_psci_config.enabled_functions_0_1 =
-			(psci_ops.cpu_suspend ? KVM_HOST_PSCI_0_1_CPU_SUSPEND : 0) |
-			(psci_ops.cpu_off ? KVM_HOST_PSCI_0_1_CPU_OFF : 0) |
-			(psci_ops.cpu_on ? KVM_HOST_PSCI_0_1_CPU_ON : 0) |
-			(psci_ops.migrate ? KVM_HOST_PSCI_0_1_MIGRATE : 0);
+		init_psci_0_1_impl_state(kvm_host_psci_config, cpu_suspend);
+		init_psci_0_1_impl_state(kvm_host_psci_config, cpu_on);
+		init_psci_0_1_impl_state(kvm_host_psci_config, cpu_off);
+		init_psci_0_1_impl_state(kvm_host_psci_config, migrate);
 	}
 	return true;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 1f7237e45148..e3947846ffcb 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -43,48 +43,16 @@ struct psci_boot_args {
 static DEFINE_PER_CPU(struct psci_boot_args, cpu_on_args) = PSCI_BOOT_ARGS_INIT;
 static DEFINE_PER_CPU(struct psci_boot_args, suspend_args) = PSCI_BOOT_ARGS_INIT;
 
-static u64 get_psci_func_id(struct kvm_cpu_context *host_ctxt)
-{
-	DECLARE_REG(u64, func_id, host_ctxt, 0);
-
-	return func_id;
-}
-
-static inline bool is_psci_0_1_function_enabled(unsigned int fn_bit)
-{
-	return kvm_host_psci_config.enabled_functions_0_1 & fn_bit;
-}
-
-static inline bool is_psci_0_1_cpu_suspend(u64 func_id)
-{
-	return is_psci_0_1_function_enabled(KVM_HOST_PSCI_0_1_CPU_SUSPEND) &&
-	       (func_id == kvm_host_psci_config.function_ids_0_1.cpu_suspend);
-}
-
-static inline bool is_psci_0_1_cpu_on(u64 func_id)
-{
-	return is_psci_0_1_function_enabled(KVM_HOST_PSCI_0_1_CPU_ON) &&
-	       (func_id == kvm_host_psci_config.function_ids_0_1.cpu_on);
-}
-
-static inline bool is_psci_0_1_cpu_off(u64 func_id)
-{
-	return is_psci_0_1_function_enabled(KVM_HOST_PSCI_0_1_CPU_OFF) &&
-	       (func_id == kvm_host_psci_config.function_ids_0_1.cpu_off);
-}
-
-static inline bool is_psci_0_1_migrate(u64 func_id)
-{
-	return is_psci_0_1_function_enabled(KVM_HOST_PSCI_0_1_MIGRATE) &&
-	       (func_id == kvm_host_psci_config.function_ids_0_1.migrate);
-}
+#define	is_psci_0_1(what, func_id)					\
+	(kvm_host_psci_config.psci_0_1_ ## what ## _implemented &&	\
+	 (func_id) == kvm_host_psci_config.function_ids_0_1.what)
 
 static bool is_psci_0_1_call(u64 func_id)
 {
-	return is_psci_0_1_cpu_suspend(func_id) ||
-	       is_psci_0_1_cpu_on(func_id) ||
-	       is_psci_0_1_cpu_off(func_id) ||
-	       is_psci_0_1_migrate(func_id);
+	return (is_psci_0_1(cpu_suspend, func_id) ||
+		is_psci_0_1(cpu_on, func_id) ||
+		is_psci_0_1(cpu_off, func_id) ||
+		is_psci_0_1(migrate, func_id));
 }
 
 static bool is_psci_0_2_call(u64 func_id)
@@ -94,16 +62,6 @@ static bool is_psci_0_2_call(u64 func_id)
 	       (PSCI_0_2_FN64(0) <= func_id && func_id <= PSCI_0_2_FN64(31));
 }
 
-static bool is_psci_call(u64 func_id)
-{
-	switch (kvm_host_psci_config.version) {
-	case PSCI_VERSION(0, 1):
-		return is_psci_0_1_call(func_id);
-	default:
-		return is_psci_0_2_call(func_id);
-	}
-}
-
 static unsigned long psci_call(unsigned long fn, unsigned long arg0,
 			       unsigned long arg1, unsigned long arg2)
 {
@@ -273,14 +231,14 @@ asmlinkage void __noreturn kvm_host_psci_cpu_entry(bool is_cpu_on)
 
 static unsigned long psci_0_1_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
 {
-	if (is_psci_0_1_cpu_off(func_id) || is_psci_0_1_migrate(func_id))
+	if (is_psci_0_1(cpu_off, func_id) || is_psci_0_1(migrate, func_id))
 		return psci_forward(host_ctxt);
-	else if (is_psci_0_1_cpu_on(func_id))
+	if (is_psci_0_1(cpu_on, func_id))
 		return psci_cpu_on(func_id, host_ctxt);
-	else if (is_psci_0_1_cpu_suspend(func_id))
+	if (is_psci_0_1(cpu_suspend, func_id))
 		return psci_cpu_suspend(func_id, host_ctxt);
-	else
-		return PSCI_RET_NOT_SUPPORTED;
+
+	return PSCI_RET_NOT_SUPPORTED;
 }
 
 static unsigned long psci_0_2_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
@@ -322,20 +280,23 @@ static unsigned long psci_1_0_handler(u64 func_id, struct kvm_cpu_context *host_
 
 bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt)
 {
-	u64 func_id = get_psci_func_id(host_ctxt);
+	DECLARE_REG(u64, func_id, host_ctxt, 0);
 	unsigned long ret;
 
-	if (!is_psci_call(func_id))
-		return false;
-
 	switch (kvm_host_psci_config.version) {
 	case PSCI_VERSION(0, 1):
+		if (!is_psci_0_1_call(func_id))
+			return false;
 		ret = psci_0_1_handler(func_id, host_ctxt);
 		break;
 	case PSCI_VERSION(0, 2):
+		if (!is_psci_0_2_call(func_id))
+			return false;
 		ret = psci_0_2_handler(func_id, host_ctxt);
 		break;
 	default:
+		if (!is_psci_0_2_call(func_id))
+			return false;
 		ret = psci_1_0_handler(func_id, host_ctxt);
 		break;
 	}
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
