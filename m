Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E203CA4AE
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807785; cv=none; b=t640DZZ7DzSmvlI+kR4U0WSu7mft41ho+LoiIP900LYemFMbhcf87JGxNwq1bC9AbKnRz8+sbIFy7mCMqpf9NGQARLQgkYQ/Yj8M77SnhF5H98mfyZtRXqX21fuuM3qO59M8ayakHlM6ZsWB38TYN8dNPlwrfPyKfHIHT8V0a0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807785; c=relaxed/simple;
	bh=YbA8JaPFtz8gRsLTxw2qoGtAW0nAN+sVhk3TUjQu78g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kmPO8e/6OV+KFLGemai8NiS00WOuehxlEGkrJDkLQpCD2iJGd8CYuBJ3GvMXpmftr+4P5Te1AXsr10Iwr43iB/HT9yyjOKO+LhQ5nq7ntlIYg9jc8HdVUAft8qfHRLj/kJOAaJYlK4vtC4xlOQpUaj49LNRZiDHE1MCWya/pk2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FZRuFnsw; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FZRuFnsw"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4837b7903f3so124181275e9.2
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772807781; x=1773412581; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dmLqPW/eDHkunk54emb2m2JdJcZj8L4sjcALmrPjxRU=;
        b=FZRuFnswWPjknL5Og87D44oaTpUgrX1vilxLU8jES0Uqlw89YibVejbkynOzPPEvhW
         wK+gkKIWMfIuhrxjiAf3KrRf8erplnpVzOOesS35V2wcLNBruNN7rrMzm1CK1xAyjPtS
         DZAqRQaeHeJzWqbowWPXwki4oU1etTkeW3hlm8Rn4XhQ5YYCChewrrxy7uUSbzcRdrUL
         JgqQ4Hk2QES7TkimEw9kxR57GNuX6ysB18nMzRH3XPd5vgnE3I0/4EZeetayjau3BqZU
         COm4gb1Ld7cTJsarFeR4kuufwYmTVlXYThUYHqVvOJbpgx9Bn8IZa/d06m9NJKSW4TAd
         yQIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772807781; x=1773412581;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dmLqPW/eDHkunk54emb2m2JdJcZj8L4sjcALmrPjxRU=;
        b=hHodLqofmz4uLrEXlyB0OArwCdSdOMs2MzMPG2NCfB/bACeNPx1UVOmLtCNYfkGdXU
         MSotwU8pa8PDqdSsKBOcHLZDzuqOPkEiv2gLfwhHQkKHO2ibCo4YCwJQe+Xg0gNjUCd+
         61LXKikZUTD9TY32ODkFFzqOdwkmPehxl13jSdtE5bFL6WOflm7Ke64XfqxYCyib5KEO
         4g1Ui5vJWvNCRTLsGbiKc6hW9j/QCEbHKiz/SnbJQOHugY6y8b9MU6taJoNT+YWiu1OR
         U8cPwj8Vrex0AvRAy3MC693fGgLrO8yydv7g0YzKJVPqwD/yEO9I/g5OlzacdqA7d/5S
         Lx6w==
X-Gm-Message-State: AOJu0YwiQPvCaBSoxlf6ppRmYupv7Ui3E0Knl1EZ341fI0WB8GZYGAgo
	dOOyuySXlnIDH5rdVrZDt9718lnkoqL4bOMwKzGOvVIY0O+HlgUt7oyEgAcprs3UOOfX/rCe6Qe
	foFgHlOqQxOaxwyoXsYUwXg==
X-Received: from wmmr3.prod.google.com ([2002:a05:600c:4243:b0:480:6bfa:f515])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:608f:b0:483:8e43:6dce with SMTP id 5b1f17b1804b1-4852696937cmr36224375e9.29.1772807780854;
 Fri, 06 Mar 2026 06:36:20 -0800 (PST)
Date: Fri,  6 Mar 2026 14:35:32 +0000
In-Reply-To: <20260306143536.339777-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306143536.339777-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306143536.339777-29-vdonnefort@google.com>
Subject: [PATCH v13 28/32] KVM: arm64: Add hyp_enter/hyp_exit events to
 nVHE/pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The hyp_enter and hyp_exit events are logged by the hypervisor any time
it is entered and exited.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2ca264b3db5f..b50ac3bb4bc9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -920,6 +920,9 @@ struct kvm_vcpu_arch {
 
 	/* Per-vcpu TLB for VNCR_EL2 -- NULL when !NV */
 	struct vncr_tlb	*vncr_tlb;
+
+	/* Hyp-readable copy of kvm_vcpu::pid */
+	pid_t pid;
 };
 
 /*
diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
index d6e033c96c52..221a1dacb2f0 100644
--- a/arch/arm64/include/asm/kvm_hypevents.h
+++ b/arch/arm64/include/asm/kvm_hypevents.h
@@ -7,4 +7,43 @@
 #include <nvhe/trace.h>
 #endif
 
+#ifndef __HYP_ENTER_EXIT_REASON
+#define __HYP_ENTER_EXIT_REASON
+enum hyp_enter_exit_reason {
+	HYP_REASON_SMC,
+	HYP_REASON_HVC,
+	HYP_REASON_PSCI,
+	HYP_REASON_HOST_ABORT,
+	HYP_REASON_GUEST_EXIT,
+	HYP_REASON_ERET_HOST,
+	HYP_REASON_ERET_GUEST,
+	HYP_REASON_UNKNOWN	/* Must be last */
+};
+#endif
+
+HYP_EVENT(hyp_enter,
+	HE_PROTO(struct kvm_cpu_context *host_ctxt, u8 reason),
+	HE_STRUCT(
+		he_field(u8, reason)
+		he_field(pid_t, vcpu)
+	),
+	HE_ASSIGN(
+		__entry->reason = reason;
+		__entry->vcpu = __tracing_get_vcpu_pid(host_ctxt);
+	),
+	HE_PRINTK("reason=%s vcpu=%d", __hyp_enter_exit_reason_str(__entry->reason), __entry->vcpu)
+);
+
+HYP_EVENT(hyp_exit,
+	HE_PROTO(struct kvm_cpu_context *host_ctxt, u8 reason),
+	HE_STRUCT(
+		he_field(u8, reason)
+		he_field(pid_t, vcpu)
+	),
+	HE_ASSIGN(
+		__entry->reason = reason;
+		__entry->vcpu = __tracing_get_vcpu_pid(host_ctxt);
+	),
+	HE_PRINTK("reason=%s vcpu=%d", __hyp_enter_exit_reason_str(__entry->reason), __entry->vcpu)
+);
 #endif
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 87a3d28d5f0f..04c43c9eb764 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -707,6 +707,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	if (!cpumask_test_cpu(cpu, vcpu->kvm->arch.supported_cpus))
 		vcpu_set_on_unsupported_cpu(vcpu);
+
+	vcpu->arch.pid = pid_nr(vcpu->pid);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h b/arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h
new file mode 100644
index 000000000000..1258bc84477f
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ARM64_KVM_HYP_NVHE_ARM_SMCCC_H__
+#define __ARM64_KVM_HYP_NVHE_ARM_SMCCC_H__
+
+#include <asm/kvm_hypevents.h>
+
+#include <linux/arm-smccc.h>
+
+#define hyp_smccc_1_1_smc(...)					\
+	do {							\
+		trace_hyp_exit(NULL, HYP_REASON_SMC);		\
+		arm_smccc_1_1_smc(__VA_ARGS__);			\
+		trace_hyp_enter(NULL, HYP_REASON_SMC);		\
+	} while (0)
+
+#define hyp_smccc_1_2_smc(...)					\
+	do {							\
+		trace_hyp_exit(NULL, HYP_REASON_SMC);		\
+		arm_smccc_1_2_smc(__VA_ARGS__);			\
+		trace_hyp_enter(NULL, HYP_REASON_SMC);		\
+	} while (0)
+
+#endif /* __ARM64_KVM_HYP_NVHE_ARM_SMCCC_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
index 802a18b77c56..8813ff250f8e 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
@@ -6,6 +6,18 @@
 
 #include <asm/kvm_hyptrace.h>
 
+static inline pid_t __tracing_get_vcpu_pid(struct kvm_cpu_context *host_ctxt)
+{
+	struct kvm_vcpu *vcpu;
+
+	if (!host_ctxt)
+		host_ctxt = host_data_ptr(host_ctxt);
+
+	vcpu = host_ctxt->__hyp_running_vcpu;
+
+	return vcpu ? vcpu->arch.pid : 0;
+}
+
 #define HE_PROTO(__args...)	__args
 #define HE_ASSIGN(__args...)	__args
 #define HE_STRUCT		RE_STRUCT
diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 94161ea1cd60..1af722771178 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -26,10 +26,10 @@
  * the duration and are therefore serialised.
  */
 
-#include <linux/arm-smccc.h>
 #include <linux/arm_ffa.h>
 #include <asm/kvm_pkvm.h>
 
+#include <nvhe/arm-smccc.h>
 #include <nvhe/ffa.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/memory.h>
@@ -147,7 +147,7 @@ static int ffa_map_hyp_buffers(u64 ffa_page_count)
 {
 	struct arm_smccc_1_2_regs res;
 
-	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
+	hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
 		.a0 = FFA_FN64_RXTX_MAP,
 		.a1 = hyp_virt_to_phys(hyp_buffers.tx),
 		.a2 = hyp_virt_to_phys(hyp_buffers.rx),
@@ -161,7 +161,7 @@ static int ffa_unmap_hyp_buffers(void)
 {
 	struct arm_smccc_1_2_regs res;
 
-	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
+	hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
 		.a0 = FFA_RXTX_UNMAP,
 		.a1 = HOST_FFA_ID,
 	}, &res);
@@ -172,7 +172,7 @@ static int ffa_unmap_hyp_buffers(void)
 static void ffa_mem_frag_tx(struct arm_smccc_1_2_regs *res, u32 handle_lo,
 			     u32 handle_hi, u32 fraglen, u32 endpoint_id)
 {
-	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
+	hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
 		.a0 = FFA_MEM_FRAG_TX,
 		.a1 = handle_lo,
 		.a2 = handle_hi,
@@ -184,7 +184,7 @@ static void ffa_mem_frag_tx(struct arm_smccc_1_2_regs *res, u32 handle_lo,
 static void ffa_mem_frag_rx(struct arm_smccc_1_2_regs *res, u32 handle_lo,
 			     u32 handle_hi, u32 fragoff)
 {
-	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
+	hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
 		.a0 = FFA_MEM_FRAG_RX,
 		.a1 = handle_lo,
 		.a2 = handle_hi,
@@ -196,7 +196,7 @@ static void ffa_mem_frag_rx(struct arm_smccc_1_2_regs *res, u32 handle_lo,
 static void ffa_mem_xfer(struct arm_smccc_1_2_regs *res, u64 func_id, u32 len,
 			  u32 fraglen)
 {
-	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
+	hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
 		.a0 = func_id,
 		.a1 = len,
 		.a2 = fraglen,
@@ -206,7 +206,7 @@ static void ffa_mem_xfer(struct arm_smccc_1_2_regs *res, u64 func_id, u32 len,
 static void ffa_mem_reclaim(struct arm_smccc_1_2_regs *res, u32 handle_lo,
 			     u32 handle_hi, u32 flags)
 {
-	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
+	hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
 		.a0 = FFA_MEM_RECLAIM,
 		.a1 = handle_lo,
 		.a2 = handle_hi,
@@ -216,7 +216,7 @@ static void ffa_mem_reclaim(struct arm_smccc_1_2_regs *res, u32 handle_lo,
 
 static void ffa_retrieve_req(struct arm_smccc_1_2_regs *res, u32 len)
 {
-	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
+	hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
 		.a0 = FFA_FN64_MEM_RETRIEVE_REQ,
 		.a1 = len,
 		.a2 = len,
@@ -225,7 +225,7 @@ static void ffa_retrieve_req(struct arm_smccc_1_2_regs *res, u32 len)
 
 static void ffa_rx_release(struct arm_smccc_1_2_regs *res)
 {
-	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
+	hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
 		.a0 = FFA_RX_RELEASE,
 	}, res);
 }
@@ -728,7 +728,7 @@ static int hyp_ffa_post_init(void)
 	size_t min_rxtx_sz;
 	struct arm_smccc_1_2_regs res;
 
-	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs){
+	hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs){
 		.a0 = FFA_ID_GET,
 	}, &res);
 	if (res.a0 != FFA_SUCCESS)
@@ -737,7 +737,7 @@ static int hyp_ffa_post_init(void)
 	if (res.a2 != HOST_FFA_ID)
 		return -EINVAL;
 
-	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs){
+	hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs){
 		.a0 = FFA_FEATURES,
 		.a1 = FFA_FN64_RXTX_MAP,
 	}, &res);
@@ -788,7 +788,7 @@ static void do_ffa_version(struct arm_smccc_1_2_regs *res,
 	 * first if TEE supports it.
 	 */
 	if (FFA_MINOR_VERSION(ffa_req_version) < FFA_MINOR_VERSION(hyp_ffa_version)) {
-		arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
+		hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
 			.a0 = FFA_VERSION,
 			.a1 = ffa_req_version,
 		}, res);
@@ -824,7 +824,7 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 		goto out_unlock;
 	}
 
-	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
+	hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
 		.a0 = FFA_PARTITION_INFO_GET,
 		.a1 = uuid0,
 		.a2 = uuid1,
@@ -939,7 +939,7 @@ int hyp_ffa_init(void *pages)
 	if (kvm_host_psci_config.smccc_version < ARM_SMCCC_VERSION_1_2)
 		return 0;
 
-	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
+	hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
 		.a0 = FFA_VERSION,
 		.a1 = FFA_VERSION_1_2,
 	}, &res);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index fc5953f31b4b..547d63679022 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -12,6 +12,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_hypevents.h>
 #include <asm/kvm_mmu.h>
 
 #include <nvhe/ffa.h>
@@ -137,6 +138,8 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	hyp_vcpu->vcpu.arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
 
 	hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3 = host_vcpu->arch.vgic_cpu.vgic_v3;
+
+	hyp_vcpu->vcpu.arch.pid = host_vcpu->arch.pid;
 }
 
 static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
@@ -728,7 +731,9 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 
 static void default_host_smc_handler(struct kvm_cpu_context *host_ctxt)
 {
+	trace_hyp_exit(host_ctxt, HYP_REASON_SMC);
 	__kvm_hyp_host_forward_smc(host_ctxt);
+	trace_hyp_enter(host_ctxt, HYP_REASON_SMC);
 }
 
 static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
@@ -815,15 +820,19 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 {
 	u64 esr = read_sysreg_el2(SYS_ESR);
 
+
 	switch (ESR_ELx_EC(esr)) {
 	case ESR_ELx_EC_HVC64:
+		trace_hyp_enter(host_ctxt, HYP_REASON_HVC);
 		handle_host_hcall(host_ctxt);
 		break;
 	case ESR_ELx_EC_SMC64:
+		trace_hyp_enter(host_ctxt, HYP_REASON_SMC);
 		handle_host_smc(host_ctxt);
 		break;
 	case ESR_ELx_EC_IABT_LOW:
 	case ESR_ELx_EC_DABT_LOW:
+		trace_hyp_enter(host_ctxt, HYP_REASON_HOST_ABORT);
 		handle_host_mem_abort(host_ctxt);
 		break;
 	case ESR_ELx_EC_SYS64:
@@ -833,4 +842,6 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 	default:
 		BUG();
 	}
+
+	trace_hyp_exit(host_ctxt, HYP_REASON_ERET_HOST);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index c3e196fb8b18..ab4c7bddb163 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -6,11 +6,12 @@
 
 #include <asm/kvm_asm.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_hypevents.h>
 #include <asm/kvm_mmu.h>
-#include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
 #include <uapi/linux/psci.h>
 
+#include <nvhe/arm-smccc.h>
 #include <nvhe/memory.h>
 #include <nvhe/trap_handler.h>
 
@@ -65,7 +66,7 @@ static unsigned long psci_call(unsigned long fn, unsigned long arg0,
 {
 	struct arm_smccc_res res;
 
-	arm_smccc_1_1_smc(fn, arg0, arg1, arg2, &res);
+	hyp_smccc_1_1_smc(fn, arg0, arg1, arg2, &res);
 	return res.a0;
 }
 
@@ -206,6 +207,7 @@ asmlinkage void __noreturn __kvm_host_psci_cpu_entry(bool is_cpu_on)
 	struct kvm_cpu_context *host_ctxt;
 
 	host_ctxt = host_data_ptr(host_ctxt);
+	trace_hyp_enter(host_ctxt, HYP_REASON_PSCI);
 
 	if (is_cpu_on)
 		boot_args = this_cpu_ptr(&cpu_on_args);
@@ -221,6 +223,7 @@ asmlinkage void __noreturn __kvm_host_psci_cpu_entry(bool is_cpu_on)
 	write_sysreg_el1(INIT_SCTLR_EL1_MMU_OFF, SYS_SCTLR);
 	write_sysreg(INIT_PSTATE_EL1, SPSR_EL2);
 
+	trace_hyp_exit(host_ctxt, HYP_REASON_PSCI);
 	__host_enter(host_ctxt);
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 779089e42681..ca60721501d1 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -7,7 +7,6 @@
 #include <hyp/switch.h>
 #include <hyp/sysreg-sr.h>
 
-#include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
 #include <linux/types.h>
 #include <linux/jump_label.h>
@@ -21,6 +20,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_hypevents.h>
 #include <asm/kvm_mmu.h>
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
@@ -308,10 +308,13 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__debug_switch_to_guest(vcpu);
 
 	do {
+		trace_hyp_exit(host_ctxt, HYP_REASON_ERET_GUEST);
+
 		/* Jump in the fire! */
 		exit_code = __guest_enter(vcpu);
 
 		/* And we're baaack! */
+		trace_hyp_enter(host_ctxt, HYP_REASON_GUEST_EXIT);
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
 	__sysreg_save_state_nvhe(guest_ctxt);
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 0144cd26703e..1ad6a55ba95c 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -364,8 +364,26 @@ static struct trace_remote_callbacks trace_remote_callbacks = {
 	.enable_event		= hyp_trace_enable_event,
 };
 
+static const char *__hyp_enter_exit_reason_str(u8 reason);
+
 #include <asm/kvm_define_hypevents.h>
 
+static const char *__hyp_enter_exit_reason_str(u8 reason)
+{
+	static const char strs[][12] = {
+		"smc",
+		"hvc",
+		"psci",
+		"host_abort",
+		"guest_exit",
+		"eret_host",
+		"eret_guest",
+		"unknown",
+	};
+
+	return strs[min(reason, HYP_REASON_UNKNOWN)];
+}
+
 static void __init hyp_trace_init_events(void)
 {
 	struct hyp_event_id *hyp_event_id = __hyp_event_ids_start;
-- 
2.53.0.473.g4a7958ca14-goog

