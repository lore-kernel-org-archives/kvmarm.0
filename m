Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEBD3ED3CF
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 15:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779290845; cv=none; b=agWYtiMPFjgZ6g+kqP69ENK+fxl6bfLOZrrj7mrxKvHLGYbdjfYCanlmG7WQhq7uKuTlWOOpevRME3S9n210fT5gSzQ2RJ35PM9hGsgFR2ptpmQPF8+bp5+JwvQlWLFGK1pnEOHz22HgoD3FGjVBcovjzYfXZjeZBORtasjLRoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779290845; c=relaxed/simple;
	bh=Z+GPeMOIyuRQjk8OVSMpWAFiNsDvUm7QpA0MAo16mio=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VGhFXvwNN65Y4vKuMFEvqnT80fKDmxV1QZI1ZsgGEyyWa1UEhcO6BL8b7X6pBtfJHbqdVGqvnabRA2tlgGKAeL9sBsYnlcgFsIi2tD+InucakHNZN2j9xUGr6MhH7ZZwvLGtGmKcQi6uw2XdDePw85zK1kJa6SBbgt18V7PU31Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D589aiUA; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D589aiUA"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fd33b4921so34298415e9.2
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 08:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779290842; x=1779895642; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5CsSbz5VmSun3+0W9tQSd76FKR2PQ+GU0lVGnBhO2QY=;
        b=D589aiUAiuxOHUsBYdduT2bQjCRq5ff0pw3lDR6113pW8SavqYPie0GJ6FvDwjXqlc
         YRHNh/IiAqMmJJzLEAYTH9jZy5SlUqxfArMKq6tRcJeLjyxzd7btPIYaMfydHxH0Hw5d
         IqPxcYi7g5M3ApBPIhTNGC4OEP7rzXfoKe6PPIT8npr26SHdkSeBIcp+MzS0+iQjuCAK
         Pa7A4oHnpdnzOeEpkEK0kDiYCH4+lkezwAlAFXNryWV1WCv9E2d0PrN/y2XlF1aBsJ/2
         8WVq99xKWFUQ0Pbi79F1UNZJMx/vW92Bt5Z6vzxYJw7486jS/5ELGd2u0hNAnDTSMOzA
         JNOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290842; x=1779895642;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5CsSbz5VmSun3+0W9tQSd76FKR2PQ+GU0lVGnBhO2QY=;
        b=ncUApaSADiAEd+jagErk46USmIFsVnMVAGddpwEjwHmff1tAD9eGZHueqRsBbq4tz/
         SHsIo/sq4itA8w4wA6nfz5xgLLRqCVzeRJRyZBvk4uA1fehiKqTk0ZGwBRbRjYKFCGA2
         X8tp4YiWvmcB8v09ly47jEf9Ur/aRdp6o8q3Peuh/Ak0sNCsTD54tXVPB2zTa/1Mq3Jx
         dz1oh6Bslb1L23MZR5BE4UcNudXvUByKbvSMjdRlTbC0al+mKqWAr2SS9SoVy7GXbQmD
         6QOBAoaxeDITVNuB3nBh/13nBPn2vnIUm7hPNqy7Ejpl5LQzXrjQVP/kfvYIr6JlSwPC
         h9tg==
X-Forwarded-Encrypted: i=1; AFNElJ9Hp+uwj0Zza3CTpZbMTEBkV284ZeGXmZ/gP+MdSJYj1cFJWkH7VawjTWI6na6GyqgU7SArUlw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzGBAfnO2/LtbbGXYYFyE4eK5mPCJ2UybFpTXptqCwZahYKkZwr
	wwZX1puBKcQPmLvOKnRDMhzeC2VvxfqySJD2qpiqMJLBSWuHw40ibXgZneIAporVXW89FZKaDBn
	FiiLsn33B5q6gDO6ukVUwqg==
X-Received: from wmqn21.prod.google.com ([2002:a05:600c:4f95:b0:48a:8fea:9222])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:190d:b0:490:261d:8111 with SMTP id 5b1f17b1804b1-490261d8124mr80908975e9.22.1779290841707;
 Wed, 20 May 2026 08:27:21 -0700 (PDT)
Date: Wed, 20 May 2026 16:26:40 +0100
In-Reply-To: <20260520152650.4107895-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520152650.4107895-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
Message-ID: <20260520152650.4107895-8-vdonnefort@google.com>
Subject: [PATCH 07/17] KVM: arm64: Add pkvm_hyp_req infrastructure
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce a struct pkvm_hyp_req to enable the pKVM hypervisor to request
resources from the host.

Provide serialisation helpers to transport these requests via SMCCC
registers (starting from a2):

  pkvm_hyp_req_to_smccc() to encode into the SMCCC args.
  smccc_to_pkvm_hyp_req() to decode them.

When the hypervisor raises a request, the host must handle it and retry
the HVC. To automate this sequence, introduce the pkvm_call_hyp_req()
macro. This intercepts pending requests, invokes the handler and retries
the HVC.

Additionally, introduce a trace event to track the handling of these
requests.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 879f1667ec67..fb4d140c99cc 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -204,6 +204,95 @@ struct pkvm_mapping {
 	u64 __subtree_last;	/* Internal member for interval tree */
 };
 
+enum pkvm_hyp_req_type {
+	PKVM_HYP_NO_REQ = 0,
+	__PKVM_HYP_REQ_TYPE_MAX,
+};
+
+#define PKVM_HYP_REQ_SMCCC_ARG_SIZE_MAX \
+	(sizeof(struct arm_smccc_res) - offsetof(struct arm_smccc_res, a2) - 1)
+
+struct pkvm_hyp_req {
+	u8 type;
+	union {
+		struct {
+			u32	nr_pages;
+		} mem;
+		struct {
+			/* Helper for SMCCC encoding/decoding */
+			u8	args[PKVM_HYP_REQ_SMCCC_ARG_SIZE_MAX];
+		} args;
+	};
+};
+
+static inline size_t pkvm_hyp_req_arg_size(u8 type)
+{
+	switch (type) {
+	case PKVM_HYP_NO_REQ:
+		return 0;
+	default:
+		WARN_ON(1);
+	}
+
+	return 0;
+}
+
+/* Encode the pending pkvm_hyp_req type into the SMCCC args */
+static inline void
+pkvm_hyp_req_to_smccc(struct kvm_cpu_context *host_ctxt, struct pkvm_hyp_req *req)
+{
+	u8 *dst, type = req->type;
+	size_t size;
+
+	if (type == PKVM_HYP_NO_REQ || type >= __PKVM_HYP_REQ_TYPE_MAX) {
+		host_ctxt->regs.regs[2] = 0;
+		return;
+	}
+
+	size = pkvm_hyp_req_arg_size(type);
+	if (WARN_ON(size > PKVM_HYP_REQ_SMCCC_ARG_SIZE_MAX))
+		return;
+
+	dst = (u8 *)&host_ctxt->regs.regs[2];
+	*dst = type;
+
+	memcpy(dst + 1, &req->args, size);
+}
+
+/* Return true if a pkvm_hyp_req has been decoded from the SMCCC args */
+static inline bool smccc_to_pkvm_hyp_req(struct pkvm_hyp_req *req, struct arm_smccc_res *res)
+{
+	u8 *src = (u8 *)&res->a2;
+	u8 type = *src;
+
+	if (type == PKVM_HYP_NO_REQ || type >= __PKVM_HYP_REQ_TYPE_MAX)
+		return false;
+
+	req->type = type;
+	memcpy(&req->args, src + 1, pkvm_hyp_req_arg_size(type));
+
+	return true;
+}
+
+int __pkvm_handle_smccc_req(struct arm_smccc_res *res);
+
+#define pkvm_call_hyp_req(f, ...)								\
+({												\
+	struct arm_smccc_res res;								\
+	int __ret;										\
+	do {											\
+		__ret = -1;									\
+		arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(f), ##__VA_ARGS__, &res);			\
+		if (WARN_ON(res.a0 != SMCCC_RET_SUCCESS))					\
+			break;									\
+		__ret = res.a1;									\
+		if (!__ret)									\
+			break;									\
+		__ret = __pkvm_handle_smccc_req(&res);						\
+	} while (!__ret);									\
+	__ret;											\
+})
+
 int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			     struct kvm_pgtable_mm_ops *mm_ops);
 void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 7abdc250b633..ce96a6f90bd0 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -16,6 +16,9 @@
 
 #include "hyp_constants.h"
 
+#define CREATE_TRACE_POINTS
+#include "trace_pkvm.h"
+
 DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 
 static struct memblock_region *hyp_memory = kvm_nvhe_sym(hyp_memory);
@@ -108,6 +111,28 @@ static int pkvm_hyp_topup(enum pkvm_topup_id id, unsigned long nr_pages)
 	return res.a1;
 }
 
+static int pkvm_handle_hyp_req(struct pkvm_hyp_req *req)
+{
+	int ret = -EINVAL;
+
+	switch (req->type) {
+	}
+
+	trace_kvm_handle_pkvm_hyp_req(req, ret);
+
+	return ret;
+}
+
+int __pkvm_handle_smccc_req(struct arm_smccc_res *res)
+{
+	struct pkvm_hyp_req req;
+
+	if (smccc_to_pkvm_hyp_req(&req, res))
+		return pkvm_handle_hyp_req(&req);
+
+	return res->a1;
+}
+
 static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
 {
 	if (pkvm_hyp_vm_is_created(kvm)) {
diff --git a/arch/arm64/kvm/trace_pkvm.h b/arch/arm64/kvm/trace_pkvm.h
new file mode 100644
index 000000000000..4bf57c12e7de
--- /dev/null
+++ b/arch/arm64/kvm/trace_pkvm.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#if !defined(_TRACE_PKVM_ARM64_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_PKVM_ARM64_KVM_H
+
+#include <linux/tracepoint.h>
+#include <asm/kvm_pkvm.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM kvm
+
+TRACE_EVENT(kvm_handle_pkvm_hyp_req,
+	TP_PROTO(struct pkvm_hyp_req *req, int ret),
+	TP_ARGS(req, ret),
+
+	TP_STRUCT__entry(
+		__field(u8,	type)
+		__field(int,	ret)
+	),
+
+	TP_fast_assign(
+		__entry->type = req->type;
+		__entry->ret = ret;
+	),
+
+	TP_printk("type: %u ret: %d",
+		  __entry->type, __entry->ret)
+);
+
+#endif /* _TRACE_PKVM_ARM64_KVM_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace_pkvm
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
2.54.0.631.ge1b05301d1-goog

