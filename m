Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEC451FCC4
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864955; cv=none; b=pc8bKzMHaWK/gZO94+KgSvI/Dm/S1D1KWakogrzh7d8ZOiY1IYl25DV79Fp37LPaWo6WCUChqJe2gJKdJOy68CpXUBHXadoZrJGNUNNfbfu8dV3bA2SjPSbiYCK+WBE/FiASC3EXiH1W90KJmcQCmqEWNlxbvK6uOL1T+X+UcPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864955; c=relaxed/simple;
	bh=6Dw2uIK9K6sPzeCEhMoRZE5W1EX+F1pSbMPOfhIDcl0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dUWvNhQABe0grzmGHmMaHkfAfJ0BryC93reabSX/EJ8kOuZSQcCAsNcfm/ugf0Piodv9ZlXhXzwQXYWrGYupSiQOrghpghWeDasgBqA0CnEWFC8Fy2JeKoZcFcGzrWtsohYGvdZa7A6fhR+tP5HT7f3F5Bx4DVRSH36xXnXtRoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cxhUCyrJ; arc=none smtp.client-ip=209.85.221.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cxhUCyrJ"
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48af5a07314so2409687f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790864944; x=1791469744; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pa8ZTcoBrlkO8ERIWs5nnGSkpaHO4t7IfOZdSk/0qCs=;
        b=cxhUCyrJn3LG5J2Nee3lZM+H2WxafBxnj0YI2dD0LCn7yYSX6yXAjfHIEBfEVoY9NP
         0WlefyLqVGN8j4EKKVDVjZ0BMJ6KsBr5Qt7tjc3d0Pe+1LHAdmzhtwRzaAjmyGPP+g41
         Ip9YZi/KHUuyEQc9zCRRYXeOXecewuyjJHSta6jC82qyRq0up2zqIY7TWCT9gUzZ9vhN
         O1JqcURv/nhQoGlOVQ0s1Lu1N+S7RR/WVOq7m1nLCrIm4lAk8CYO+Y1nht6w7T3/Caz8
         ur/FoGEL+VMzM9CqYjZK3A9dqkUavSJbwTAc+Dufal+1yAtttRz5iI35NQC2mPOBZJcO
         Y2sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790864944; x=1791469744;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pa8ZTcoBrlkO8ERIWs5nnGSkpaHO4t7IfOZdSk/0qCs=;
        b=Qn01i4y5aZ7mGY5O6HWTFdlyN0cDBfWEEg9v0/QcUztKKsuzxYYw1JTkmWMA55gHS4
         pvuw4H7+k/Z/u0szayTd2ra39+aLaraoKSqVQY6QgJf2aKN7d8iHtx8JgPCs8JSAx7eO
         xsu4Y/bcdP4OMwm7GhxtcMFBplyMc9Jlu3AZpYnGrubB+GISkE2YyDFK6h6o4IK5q9+y
         YQCYKthYIKfUZ4Ioas+FmYgLWcerFk6cqVnyy/hYaFQ1UHSdKUNtZYuJj66BWx4ARAcv
         BSVbT5QN+VdNEr3LOuU8CaqYw9wp3nPf5A6F2NSto4rtw1/FqULZtO+6vyqACcmJw93e
         4l+w==
X-Forwarded-Encrypted: i=1; AKwUvBwNJasAJPSMtXVMo/l4bQ7qqup+cJucGQEvwrb/htPAveuaHj0e2MZ/Ce/MkprUZ68CmdjGW7A=@lists.linux.dev
X-Gm-Message-State: AFuF++mbuwB8Rkwiyncm9Z+XQEKu4fBtB+NR4IQNdPeHjG3ryqz0DgMi
	mzrW1cUzyfHWFfuJM6cAMd9+VT0BeESsDd6MN7OWzqVWLMraM/8WuvlfmhSrEDrCaDTg/wNm00K
	Qwhp/K7X91d5rS9JP8JDUgA==
X-Received: from wmpo41.prod.google.com ([2002:a05:600c:33a9:b0:4a0:1516:8741])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e8c:b0:4a0:2391:6540 with SMTP id 5b1f17b1804b1-4a023916726mr26771005e9.25.1790864942156;
 Thu, 01 Oct 2026 07:29:02 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:28:37 +0100
In-Reply-To: <20261001142849.3367614-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001142849.3367614-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001142849.3367614-7-vdonnefort@google.com>
Subject: [PATCH v6 06/18] KVM: arm64: Add pkvm_hyp_req infrastructure
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
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
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_pkvm.h | 103 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/pkvm.c             |  25 ++++++++
 arch/arm64/kvm/trace_pkvm.h       |  43 +++++++++++++
 3 files changed, 171 insertions(+)
 create mode 100644 arch/arm64/kvm/trace_pkvm.h

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index beea00e693a0..19bddf261c82 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -205,6 +205,109 @@ struct pkvm_mapping {
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
+	u8 *src = (u8 *)res + offsetof(struct arm_smccc_res, a2);
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
+/**
+ * pkvm_call_hyp_req() - Issue an HVC that can return hypervisor requests
+ * @f: Hypervisor function symbol to call.
+ * @...: Arguments to pass to the hypercall.
+ *
+ * Re-issue an HVC and process any pending hypervisor request until completion
+ * or error.
+ *
+ * Only use this helper for HVCs whose hypervisor handlers format their return
+ * registers with pkvm_hyp_req_to_smccc().
+ *
+ * Return: Result of the hypercall or a negative error if the hyp request
+ * handling failed.
+ */
+#define pkvm_call_hyp_req(f, ...)								\
+({												\
+	struct arm_smccc_res __res;								\
+	int __ret;										\
+	do {											\
+		__ret = -1;									\
+		arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(f), ##__VA_ARGS__, &__res);		\
+		if (WARN_ON(__res.a0 != SMCCC_RET_SUCCESS))					\
+			break;									\
+		__ret = __res.a1;								\
+		if (!__ret)									\
+			break;									\
+		__ret = __pkvm_handle_smccc_req(&__res);					\
+	} while (!__ret);									\
+	__ret;											\
+})
+
 int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			     struct kvm_pgtable_mm_ops *mm_ops);
 void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index e5200731a45b..11d9e2f70cd8 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -16,6 +16,9 @@
 
 #include "hyp_constants.h"
 
+#define CREATE_TRACE_POINTS
+#include "trace_pkvm.h"
+
 DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 
 static struct memblock_region *hyp_memory = kvm_nvhe_sym(hyp_memory);
@@ -594,3 +597,25 @@ bool pkvm_force_reclaim_guest_page(phys_addr_t phys)
 
 	return !ret || ret == -EAGAIN;
 }
+
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
diff --git a/arch/arm64/kvm/trace_pkvm.h b/arch/arm64/kvm/trace_pkvm.h
new file mode 100644
index 000000000000..3966c111e3ad
--- /dev/null
+++ b/arch/arm64/kvm/trace_pkvm.h
@@ -0,0 +1,43 @@
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
+TRACE_DEFINE_ENUM(PKVM_HYP_NO_REQ);
+
+#define PKVM_HYP_REQ_TYPES \
+	{ PKVM_HYP_NO_REQ, "NO_REQ" }
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
+	TP_printk("type: %s ret: %d",
+		  __print_symbolic(__entry->type, PKVM_HYP_REQ_TYPES),
+		  __entry->ret)
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
2.56.0.rc1.315.gc6ed9934b7-goog

