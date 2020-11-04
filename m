Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599C2C4741F
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE53C20780
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="PTFxrsxx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE53C20780
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 623AE4B7BE;
	Wed,  4 Nov 2020 13:37:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7i607LNUeLBM; Wed,  4 Nov 2020 13:37:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBD084B7AD;
	Wed,  4 Nov 2020 13:37:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43E6F4B7BE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FpnoX3NMcr8M for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:37:30 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 27EC24B781
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:29 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id e2so3294509wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=4axi3BZMWI251/Z2i3b7o8wb6S4cFpifUi2vsGe+rz4=;
 b=PTFxrsxxpSERkmBRu9fPY5EKuAOc5OMAk+oP0QxNUjwk1I4qOAxjjuDjwlbiIQiOi4
 ENPQ8dyCyKiCtZYIUoXP4qNzgO1iQmho4X26GDMojC0ezu7o+eSB9bOWq4XwW/fs9VsO
 GK+U7yFays8yxLyrBp6Ib20GJbzuKSQMyHfvfLWNZ2hziMNn+LNIYgMyU308/fzbV2UF
 OHxgxnoPZgOGtvfH4FD78QPYcZo6KN3V9aMoEobtBl8VI6DoiYPHBWqXUbTXgtrG9Xbp
 WcUVQDUTe6Bb2sVj3CdVNgiY1YkUaOtdTU0HThcbNldjcSi8LHR5ARyKviCnMhX0Jb7t
 IyDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=4axi3BZMWI251/Z2i3b7o8wb6S4cFpifUi2vsGe+rz4=;
 b=UdmTlb/+5m81TsouHblnMsIry5OgI2obXCHEaMEkunZ5ksytZQukf3JDiO3ze4D4dg
 DYyqBGVDB1fYrrVEBBAmpu4XvfugfSwuaDfLlo3szxGrasiZj/QBx/Eamg0rhQ+Ge6cz
 AZS+L4/90vIJjQ60IoO5DShKYh5r7OGq6iB+zg9MNUPrp6bO1B33vY2cj0ff2qJqh9+Y
 9a6WHzleTfov2a73B1694PufQ9NOoGvPq5hbxeoE8WdPSrNJSv3v0eHopSF+tkxBYvzt
 P/gRTh231GM/mYf6fNsy/1xFWuRqPHWg4JF2ONLIyt58Y399fbcmZZDwRA8Dmw+Vrm0x
 9t8A==
X-Gm-Message-State: AOAM530DzaioZA1/nfRYaoWQmlNrXV6wyFHhR9D78aYL0NrOR7taaZNB
 6Pdn3qcA3LCtOo3M1xxlD0U4WiiVEhY3o5Pz
X-Google-Smtp-Source: ABdhPJyT68yOzbnYNGsOmY+iR0h6yG3pNS2GyT+gN1TQUnNhPh79E6sRyGypylEuZinN7xbmJFetAA==
X-Received: by 2002:a1c:5545:: with SMTP id j66mr6336527wmb.31.1604515047599; 
 Wed, 04 Nov 2020 10:37:27 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id s11sm3661835wrm.56.2020.11.04.10.37.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:37:26 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 23/26] kvm: arm64: Intercept host's CPU_SUSPEND PSCI SMCs
Date: Wed,  4 Nov 2020 18:36:27 +0000
Message-Id: <20201104183630.27513-24-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201104183630.27513-1-dbrazdil@google.com>
References: <20201104183630.27513-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

Add a handler of CPU_SUSPEND host PSCI SMCs. When invoked, it determines
whether the requested power state loses context, ie. whether it is
indistinguishable from a WHI or whether it is a deeper sleep state that
behaves like a CPU_OFF+CPU_ON.

If it's the former, it forwards the call to EL3 and returns to the host
after waking up.

If it's the latter, it saves r0,pc of the host into and makes the same
call to EL3 with the hyp CPU entry point. When the core wakes up, EL2
state is initialized before dropping back to EL1.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/arm.c           |  2 ++
 arch/arm64/kvm/hyp/nvhe/psci.c | 49 +++++++++++++++++++++++++++++++++-
 drivers/firmware/psci/psci.c   |  9 -------
 include/uapi/linux/psci.h      |  7 +++++
 4 files changed, 57 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 166975999ead..6fbda652200b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1521,9 +1521,11 @@ static void init_psci(void)
 {
 	extern u32 kvm_nvhe_sym(kvm_host_psci_version);
 	extern u32 kvm_nvhe_sym(kvm_host_psci_function_id)[PSCI_FN_MAX];
+	extern u32 kvm_nvhe_sym(kvm_host_psci_cpu_suspend_feature);
 	int cpu;
 
 	kvm_nvhe_sym(kvm_host_psci_version) = psci_driver_version;
+	kvm_nvhe_sym(kvm_host_psci_cpu_suspend_feature) = psci_cpu_suspend_feature;
 	memcpy(kvm_nvhe_sym(kvm_host_psci_function_id),
 		psci_function_id, sizeof(psci_function_id));
 
diff --git a/arch/arm64/kvm/hyp/nvhe/psci.c b/arch/arm64/kvm/hyp/nvhe/psci.c
index 42ee5effa827..4899c8319bb4 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci.c
@@ -21,6 +21,7 @@
 /* Config options set by the host. */
 u32 kvm_host_psci_version = PSCI_VERSION(0, 0);
 u32 kvm_host_psci_function_id[PSCI_FN_MAX];
+u32 kvm_host_psci_cpu_suspend_feature;
 s64 hyp_physvirt_offset;
 
 #define __hyp_pa(x) ((phys_addr_t)(x) + hyp_physvirt_offset)
@@ -83,6 +84,20 @@ static __noreturn unsigned long psci_forward_noreturn(struct kvm_cpu_context *ho
 	hyp_panic(); /* unreachable */
 }
 
+static bool psci_has_ext_power_state(void)
+{
+	return kvm_host_psci_cpu_suspend_feature & PSCI_1_0_FEATURES_CPU_SUSPEND_PF_MASK;
+}
+
+static bool psci_power_state_loses_context(u32 state)
+{
+	const u32 mask = psci_has_ext_power_state() ?
+					PSCI_1_0_EXT_POWER_STATE_TYPE_MASK :
+					PSCI_0_2_POWER_STATE_TYPE_MASK;
+
+	return state & mask;
+}
+
 static unsigned int find_cpu_id(u64 mpidr)
 {
 	int i;
@@ -106,6 +121,34 @@ static phys_addr_t cpu_entry_pa(void)
 	return kern_va - kimage_voffset;
 }
 
+static int psci_cpu_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
+{
+	u64 power_state = host_ctxt->regs.regs[1];
+	unsigned long pc = host_ctxt->regs.regs[2];
+	unsigned long r0 = host_ctxt->regs.regs[3];
+	hyp_spinlock_t *cpu_lock;
+	struct vcpu_reset_state	*cpu_reset;
+	struct kvm_nvhe_init_params *cpu_params;
+
+	if (!psci_power_state_loses_context(power_state)) {
+		/* This power state has the same semantics as WFI. */
+		return psci_call(PSCI_0_2_FN64_CPU_SUSPEND, 0, 0, 0);
+	}
+
+	cpu_lock = this_cpu_ptr(&psci_cpu_lock);
+	cpu_reset = this_cpu_ptr(&psci_cpu_reset);
+	cpu_params = this_cpu_ptr(&kvm_init_params);
+
+	/* Resuming from this state has the same semantics as CPU_ON. */
+	hyp_spin_lock(cpu_lock);
+	*cpu_reset = (struct vcpu_reset_state){
+		.pc = pc,
+		.r0 = r0,
+	};
+	hyp_spin_unlock(cpu_lock);
+	return psci_call(func_id, power_state, cpu_entry_pa(), __hyp_pa(cpu_params));
+}
+
 static int psci_cpu_off(u64 func_id, struct kvm_cpu_context *host_ctxt)
 {
 	hyp_spinlock_t *cpu_lock = this_cpu_ptr(&psci_cpu_lock);
@@ -193,7 +236,9 @@ static int psci_cpu_on(u64 func_id, struct kvm_cpu_context *host_ctxt)
 
 static unsigned long psci_0_1_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
 {
-	if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_OFF])
+	if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_SUSPEND])
+		return psci_cpu_suspend(func_id, host_ctxt);
+	else if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_OFF])
 		return psci_cpu_off(func_id, host_ctxt);
 	else if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_ON])
 		return psci_cpu_on(func_id, host_ctxt);
@@ -216,6 +261,8 @@ static unsigned long psci_0_2_handler(u64 func_id, struct kvm_cpu_context *host_
 	case PSCI_0_2_FN_SYSTEM_RESET:
 		psci_forward_noreturn(host_ctxt);
 		unreachable();
+	case PSCI_0_2_FN64_CPU_SUSPEND:
+		return psci_cpu_suspend(func_id, host_ctxt);
 	case PSCI_0_2_FN_CPU_OFF:
 		return psci_cpu_off(func_id, host_ctxt);
 	case PSCI_0_2_FN64_CPU_ON:
diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index b6ad237b1518..387e24409da7 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -62,15 +62,6 @@ static psci_fn *invoke_psci_fn;
 
 u32 psci_function_id[PSCI_FN_MAX];
 
-#define PSCI_0_2_POWER_STATE_MASK		\
-				(PSCI_0_2_POWER_STATE_ID_MASK | \
-				PSCI_0_2_POWER_STATE_TYPE_MASK | \
-				PSCI_0_2_POWER_STATE_AFFL_MASK)
-
-#define PSCI_1_0_EXT_POWER_STATE_MASK		\
-				(PSCI_1_0_EXT_POWER_STATE_ID_MASK | \
-				PSCI_1_0_EXT_POWER_STATE_TYPE_MASK)
-
 u32 psci_cpu_suspend_feature;
 static bool psci_system_reset2_supported;
 
diff --git a/include/uapi/linux/psci.h b/include/uapi/linux/psci.h
index 0d52b8dbe8c2..df3d85ce86f7 100644
--- a/include/uapi/linux/psci.h
+++ b/include/uapi/linux/psci.h
@@ -65,6 +65,10 @@
 #define PSCI_0_2_POWER_STATE_AFFL_SHIFT		24
 #define PSCI_0_2_POWER_STATE_AFFL_MASK		\
 				(0x3 << PSCI_0_2_POWER_STATE_AFFL_SHIFT)
+#define PSCI_0_2_POWER_STATE_MASK					\
+				(PSCI_0_2_POWER_STATE_ID_MASK |		\
+				 PSCI_0_2_POWER_STATE_TYPE_MASK |	\
+				 PSCI_0_2_POWER_STATE_AFFL_MASK)
 
 /* PSCI extended power state encoding for CPU_SUSPEND function */
 #define PSCI_1_0_EXT_POWER_STATE_ID_MASK	0xfffffff
@@ -72,6 +76,9 @@
 #define PSCI_1_0_EXT_POWER_STATE_TYPE_SHIFT	30
 #define PSCI_1_0_EXT_POWER_STATE_TYPE_MASK	\
 				(0x1 << PSCI_1_0_EXT_POWER_STATE_TYPE_SHIFT)
+#define PSCI_1_0_EXT_POWER_STATE_MASK					\
+				(PSCI_1_0_EXT_POWER_STATE_ID_MASK |	\
+				 PSCI_1_0_EXT_POWER_STATE_TYPE_MASK)
 
 /* PSCI v0.2 affinity level state returned by AFFINITY_INFO */
 #define PSCI_0_2_AFFINITY_LEVEL_ON		0
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
