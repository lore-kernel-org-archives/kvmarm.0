Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641973BADAA
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 17:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360473; cv=none; b=ubspBNk+tF68b+SiHCiI58MKq3ZOpeP+ChFS/Y+P3tqwttb9wAI5EfAtAgtf40VIX7Taq1h6u/6RSiqx/jsdFKNPx/mD1oTGXITiwX/sZjp3T9gSC78fQNKV4XsREMcICBhjk9Ms2vKkK6mdeLlF+4ESX2+R1rOoGJ4YfVMQzwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360473; c=relaxed/simple;
	bh=vxy/D5a/tXj5OhyJ4fTQR6isBOiBT49XV6LLjZ84VUI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DpL8it94jOGF/sB63gBEfqpD0Q9PsfuMKBbc9PSx0/xLtYr10UnyyJXgWUgxB/42ig/r5WUWNvEk9/2BbT24A4gphLo1/jBCXEedM+cW2WjbRClvfG8x4nW7SgkKOnjngZo8dgpONMPe7w+ITfNYvDItG7VBIRu/mwvNmhP6+jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vk/1PKCK; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vk/1PKCK"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493caa3c54eso28610345e9.2
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 10:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783360470; x=1783965270; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mMzZELxNMWkvZmpbYeYedfqqEOctYU5iyYuamj2u6LM=;
        b=vk/1PKCKgtv0rG/OJpnFuNjHClwyP91TKb246M8/sJavi9seHmzmUeHKDL9hPUMu1x
         VnfmHGBCChXoKL2PryGgLDp41W8mzfTiOlAAvllbPMr7nwLEjFCdZAI2yNYnK/2+CdJ3
         XwrD0SfKFES3K4FZH9y15z6n0cQOe+1X2Vo/GmCDUEMcMtZj+ls6dC/eIT6umIwwlp++
         2pHGrNmJSgzEVQxrMBlFMfOw4Eli75cdpQmA3u6N0zKN/VO8sieWifc7ljp6iETJdt5d
         VX0hX3e2qyNThaa0mOWrSpi7fTDMkr0ZK7FLJe5iqp/3M3J5U48nPrRUpm3iTa7p9GRt
         avSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360470; x=1783965270;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mMzZELxNMWkvZmpbYeYedfqqEOctYU5iyYuamj2u6LM=;
        b=AvLLMR06zaP6Pujwts2WsbHnvLzv+Ci/Ekbm8L/Qwthb9BZoequykXolkUjFkOyWuK
         rvKMGxWZaDtYTopvLq/D8sP6rWIOsgXAIUzKc3JX/tP7hmiH2vgwJDIzA4opfyMKNR+5
         193shbGIO8UMZTaS+5Jjr7cvJmoTU9PW+qP9AARcDPLbktki8FxAgc75hHrAtZSw+GFY
         sq8B0VFaP5x6L0+3EF4qakp6Bk10BuaFVidLhreK78P5WaySSf90ckZZ0gdou3upYwaV
         nOWaS7kugEPTi+0skF6dk4V3rqvSQ003cumcNdpD3xIBIDa+/ktJKbst1GLqXmWIPshn
         jiAg==
X-Forwarded-Encrypted: i=1; AHgh+RpWsY1Jdjq92IOBnRcXA96YJ5TB/fgcS7xwXVC53PcBw4D+k1ZD82Nq36+vS55kAYcOknwVE00=@lists.linux.dev
X-Gm-Message-State: AOJu0YxUPy3vE35IdUt0w5bc2KDpK+/WpGj2nVY/9eLKTvNacGORbQIw
	TrYm4BZTG5omVmvYK8NcqRsu4RkYQlgdGNeHnm9/dawGTTlOVpR49VezXFJ+aybY6HQq0erxJkf
	CJ/5ruYlVAYAXD6ZKFyWs8w==
X-Received: from wmhf18.prod.google.com ([2002:a7b:cc12:0:b0:492:4659:9cd8])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:19c6:b0:493:b03c:5650 with SMTP id 5b1f17b1804b1-493df06d8cdmr18355405e9.19.1783360469509;
 Mon, 06 Jul 2026 10:54:29 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:54:04 +0100
In-Reply-To: <20260706175415.2604046-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260706175415.2604046-8-vdonnefort@google.com>
Subject: [PATCH v2 07/18] KVM: arm64: Add pkvm_hyp_req infrastructure
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
index 870f7870bb62..0be1469e7874 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -203,6 +203,95 @@ struct pkvm_mapping {
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
index e2c8714e8ccc..5ba8b81b8c6c 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -16,6 +16,9 @@
 
 #include "hyp_constants.h"
 
+#define CREATE_TRACE_POINTS
+#include "trace_pkvm.h"
+
 DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 
 static struct memblock_region *hyp_memory = kvm_nvhe_sym(hyp_memory);
@@ -617,3 +620,25 @@ bool pkvm_force_reclaim_guest_page(phys_addr_t phys)
 
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
2.55.0.rc2.803.g1fd1e6609c-goog

