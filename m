Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC192345CCD
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 15:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771513435; cv=none; b=noBzfcNGEyiVJEc9/NIJY6+LBcyWFcvnMCvM5wBwBTN5iQsKqx7keq92M2NGsSvs8ijdd8UJOfCKNdD5giH093k0hW3S05UjGe3Qw76FxSaoJ4fDP0FZAYvmv6DmPjljfc+vCPa2UOnFKG8WX6Fl2XDzHPHFG3aBeRxcaNtfYB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771513435; c=relaxed/simple;
	bh=9UEzVAfgnsGeqsC7pcxuCcqPWCNNLBtCmP9PfD4HhUo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d4uvmy4zb7SyDeGhBjapNdRnJua2IEyV5+03TgP0LUa5FP+rReZ00nCpPxBKIGpKTL5GX0w4Hi9TXUd5WXqRLc73Sn+BiAdKNswR7EFEnx6v+F3x+s5EUaKrkhxj8I10yKR1e9Qpm8cyIaDLnkbe7miRrOlttpN6EmRq9t2TiAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mMW+ZMOV; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mMW+ZMOV"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-658b82db041so2438063a12.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 07:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771513432; x=1772118232; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KSuD2C5NFQEJ1s/f2WW4h61WSWzcVtPeKoDn90FI5XM=;
        b=mMW+ZMOV1tQHsmACS6TzZJ1PKCR3nZHHfJBIP+LMQY1NBgwitYjfLcQcIXQWPZVtp3
         L5ZOh7Op66Y0q8KhgYsTN/NSn0JLEdqnd1HHyFST4JDcri2EExq0GRLpwXTMggKd31Wy
         UsEYNyqt78jFK/Paw6SxIBKKlC//prTM2LYxvdLD/CfVdmE3qm77lg1NA2xi+hZQfEWJ
         +rp7lt9scnG6bIj4rhKf5f4uz8qiz3d8UVRjK5QMKEme6kpUoFFh3RHhDcan7wYfDiPA
         tpokOURg/WUjUr+xKChYk1NmCHR243uUsou1Rbi7GT8ZURLLt8Eh1794N0GMngoC4FpZ
         5XvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771513432; x=1772118232;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KSuD2C5NFQEJ1s/f2WW4h61WSWzcVtPeKoDn90FI5XM=;
        b=UB01LI/Ic5T6/jS/4q8Kyjn9EhuZPOToYWwa9g3CrWwGbqIigqZkKspd4RGdt2sXHk
         M9SjScOdA6UeDAbohxulWh7BNzZLlh4jdUB7etZPdCyboH0SYjxzFwGJXVtJiJlandlE
         lS8UTpWieHaXjJgFcJpg/OXX0nxRtQU/paWi1THktELq19zgm5RMbBGu4biuyLarivhf
         qTuONmfUlyuCZudKjF4o2A8abiYATyWY7nSMYX+gwkKMIC+LP6hurW/bL3enIQkDYidw
         3DHowbfQJtPAl+EuH56NNtrH+ktYCmYtCDlpygU/JSjO4G90BkKHqSgezLcXZ/EpuQHn
         uIlg==
X-Gm-Message-State: AOJu0YytlVvhXqvQq9j5MJ3RUBPHnt37QsjfJioSHwNVagTiUIqwuwc3
	J0KWrHcEDI/OqYNK9D1B+SlVt9oN8TCN0lENva+rYsbDeweAnGmnGRgKOOowdvooCVtmEhf4LN8
	Pt9gAvOwCQB7KzmwtapnZ1w==
X-Received: from edra19.prod.google.com ([2002:aa7:d913:0:b0:64b:8031:e69a])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:c27:b0:b87:15a7:8603 with SMTP id a640c23a62f3a-b8face4c826mr1457845666b.43.1771513431287;
 Thu, 19 Feb 2026 07:03:51 -0800 (PST)
Date: Thu, 19 Feb 2026 15:03:01 +0000
In-Reply-To: <20260219150307.14538-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260219150307.14538-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
Message-ID: <20260219150307.14538-25-vdonnefort@google.com>
Subject: [PATCH v12 24/30] KVM: arm64: Add trace remote for the nVHE/pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In both protected and nVHE mode, the hypervisor is capable of writing
events into tracefs compatible ring-buffers. Create a trace remote so
the kernel can read those buffers.

This currently doesn't provide any event support which will come later.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index c7f50492f2cf..aad0228f24db 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -76,6 +76,7 @@ if NVHE_EL2_DEBUG
 config NVHE_EL2_TRACING
 	bool
 	depends on TRACING
+	select TRACE_REMOTE
 	default y
 
 config PKVM_DISABLE_STAGE2_ON_PANIC
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 3ebc0570345c..59612d2f277c 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -30,6 +30,8 @@ kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
 kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
 
+kvm-$(CONFIG_NVHE_EL2_TRACING) += hyp_trace.o
+
 always-y := hyp_constants.h hyp-constants.s
 
 define rule_gen_hyp_constants
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6f9f3e8356b6..c71bbb571dc9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -24,6 +24,7 @@
 
 #define CREATE_TRACE_POINTS
 #include "trace_arm.h"
+#include "hyp_trace.h"
 
 #include <linux/uaccess.h>
 #include <asm/ptrace.h>
@@ -2416,6 +2417,10 @@ static int __init init_subsystems(void)
 
 	kvm_register_perf_callbacks();
 
+	err = kvm_hyp_trace_init();
+	if (err)
+		kvm_err("Failed to initialize Hyp tracing\n");
+
 out:
 	if (err)
 		hyp_cpu_pm_exit();
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
new file mode 100644
index 000000000000..2866effe28ec
--- /dev/null
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -0,0 +1,219 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Google LLC
+ * Author: Vincent Donnefort <vdonnefort@google.com>
+ */
+
+#include <linux/trace_remote.h>
+#include <linux/simple_ring_buffer.h>
+
+#include <asm/kvm_host.h>
+#include <asm/kvm_hyptrace.h>
+#include <asm/kvm_mmu.h>
+
+#include "hyp_trace.h"
+
+/* Access to this struct within the trace_remote_callbacks are protected by the trace_remote lock */
+static struct hyp_trace_buffer {
+	struct hyp_trace_desc	*desc;
+	size_t			desc_size;
+} trace_buffer;
+
+static int __map_hyp(void *start, size_t size)
+{
+	if (is_protected_kvm_enabled())
+		return 0;
+
+	return create_hyp_mappings(start, start + size, PAGE_HYP);
+}
+
+static int __share_page(unsigned long va)
+{
+	return kvm_share_hyp((void *)va, (void *)va + 1);
+}
+
+static void __unshare_page(unsigned long va)
+{
+	kvm_unshare_hyp((void *)va, (void *)va + 1);
+}
+
+static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_buffer, size_t size)
+{
+	int nr_bpages = (PAGE_ALIGN(size) / PAGE_SIZE) + 1;
+	size_t backing_size;
+	void *start;
+
+	backing_size = PAGE_ALIGN(sizeof(struct simple_buffer_page) * nr_bpages *
+				  num_possible_cpus());
+
+	start = alloc_pages_exact(backing_size, GFP_KERNEL_ACCOUNT);
+	if (!start)
+		return -ENOMEM;
+
+	trace_buffer->desc->bpages_backing_start = (unsigned long)start;
+	trace_buffer->desc->bpages_backing_size = backing_size;
+
+	return __map_hyp(start, backing_size);
+}
+
+static void hyp_trace_buffer_free_bpages_backing(struct hyp_trace_buffer *trace_buffer)
+{
+	free_pages_exact((void *)trace_buffer->desc->bpages_backing_start,
+			 trace_buffer->desc->bpages_backing_size);
+}
+
+static void hyp_trace_buffer_unshare_hyp(struct hyp_trace_buffer *trace_buffer, int last_cpu)
+{
+	struct ring_buffer_desc *rb_desc;
+	int cpu, p;
+
+	for_each_ring_buffer_desc(rb_desc, cpu, &trace_buffer->desc->trace_buffer_desc) {
+		if (cpu > last_cpu)
+			break;
+
+		__share_page(rb_desc->meta_va);
+		for (p = 0; p < rb_desc->nr_page_va; p++)
+			__unshare_page(rb_desc->page_va[p]);
+	}
+}
+
+static int hyp_trace_buffer_share_hyp(struct hyp_trace_buffer *trace_buffer)
+{
+	struct ring_buffer_desc *rb_desc;
+	int cpu, p, ret = 0;
+
+	for_each_ring_buffer_desc(rb_desc, cpu, &trace_buffer->desc->trace_buffer_desc) {
+		ret = __share_page(rb_desc->meta_va);
+		if (ret)
+			break;
+
+		for (p = 0; p < rb_desc->nr_page_va; p++) {
+			ret = __share_page(rb_desc->page_va[p]);
+			if (ret)
+				break;
+		}
+
+		if (ret) {
+			for (p--; p >= 0; p--)
+				__unshare_page(rb_desc->page_va[p]);
+			break;
+		}
+	}
+
+	if (ret)
+		hyp_trace_buffer_unshare_hyp(trace_buffer, cpu--);
+
+	return ret;
+}
+
+static struct trace_buffer_desc *hyp_trace_load(unsigned long size, void *priv)
+{
+	struct hyp_trace_buffer *trace_buffer = priv;
+	struct hyp_trace_desc *desc;
+	size_t desc_size;
+	int ret;
+
+	if (WARN_ON(trace_buffer->desc))
+		return ERR_PTR(-EINVAL);
+
+	desc_size = trace_buffer_desc_size(size, num_possible_cpus());
+	if (desc_size == SIZE_MAX)
+		return ERR_PTR(-E2BIG);
+
+	desc_size = PAGE_ALIGN(desc_size);
+	desc = (struct hyp_trace_desc *)alloc_pages_exact(desc_size, GFP_KERNEL);
+	if (!desc)
+		return ERR_PTR(-ENOMEM);
+
+	ret = __map_hyp(desc, desc_size);
+	if (ret)
+		goto err_free_desc;
+
+	trace_buffer->desc = desc;
+
+	ret = hyp_trace_buffer_alloc_bpages_backing(trace_buffer, size);
+	if (ret)
+		goto err_free_desc;
+
+	ret = trace_remote_alloc_buffer(&desc->trace_buffer_desc, desc_size, size,
+					cpu_possible_mask);
+	if (ret)
+		goto err_free_backing;
+
+	ret = hyp_trace_buffer_share_hyp(trace_buffer);
+	if (ret)
+		goto err_free_buffer;
+
+	ret = kvm_call_hyp_nvhe(__tracing_load, (unsigned long)desc, desc_size);
+	if (ret)
+		goto err_unload_pages;
+
+	return &desc->trace_buffer_desc;
+
+err_unload_pages:
+	hyp_trace_buffer_unshare_hyp(trace_buffer, INT_MAX);
+
+err_free_buffer:
+	trace_remote_free_buffer(&desc->trace_buffer_desc);
+
+err_free_backing:
+	hyp_trace_buffer_free_bpages_backing(trace_buffer);
+
+err_free_desc:
+	free_pages_exact(desc, desc_size);
+	trace_buffer->desc = NULL;
+
+	return ERR_PTR(ret);
+}
+
+static void hyp_trace_unload(struct trace_buffer_desc *desc, void *priv)
+{
+	struct hyp_trace_buffer *trace_buffer = priv;
+
+	if (WARN_ON(desc != &trace_buffer->desc->trace_buffer_desc))
+		return;
+
+	kvm_call_hyp_nvhe(__tracing_unload);
+	hyp_trace_buffer_unshare_hyp(trace_buffer, INT_MAX);
+	trace_remote_free_buffer(desc);
+	hyp_trace_buffer_free_bpages_backing(trace_buffer);
+	free_pages_exact(trace_buffer->desc, trace_buffer->desc_size);
+	trace_buffer->desc = NULL;
+}
+
+static int hyp_trace_enable_tracing(bool enable, void *priv)
+{
+	return kvm_call_hyp_nvhe(__tracing_enable, enable);
+}
+
+static int hyp_trace_swap_reader_page(unsigned int cpu, void *priv)
+{
+	return kvm_call_hyp_nvhe(__tracing_swap_reader, cpu);
+}
+
+static int hyp_trace_reset(unsigned int cpu, void *priv)
+{
+	return 0;
+}
+
+static int hyp_trace_enable_event(unsigned short id, bool enable, void *priv)
+{
+	return 0;
+}
+
+static struct trace_remote_callbacks trace_remote_callbacks = {
+	.load_trace_buffer	= hyp_trace_load,
+	.unload_trace_buffer	= hyp_trace_unload,
+	.enable_tracing		= hyp_trace_enable_tracing,
+	.swap_reader_page	= hyp_trace_swap_reader_page,
+	.reset			= hyp_trace_reset,
+	.enable_event		= hyp_trace_enable_event,
+};
+
+int __init kvm_hyp_trace_init(void)
+{
+	if (is_kernel_in_hyp_mode())
+		return 0;
+
+	return trace_remote_register("hypervisor", &trace_remote_callbacks, &trace_buffer, NULL, 0);
+}
diff --git a/arch/arm64/kvm/hyp_trace.h b/arch/arm64/kvm/hyp_trace.h
new file mode 100644
index 000000000000..c991b1ec65f1
--- /dev/null
+++ b/arch/arm64/kvm/hyp_trace.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __ARM64_KVM_HYP_TRACE_H__
+#define __ARM64_KVM_HYP_TRACE_H__
+
+#ifdef CONFIG_NVHE_EL2_TRACING
+int kvm_hyp_trace_init(void);
+#else
+static inline int kvm_hyp_trace_init(void) { return 0; }
+#endif
+#endif
-- 
2.53.0.335.g19a08e0c02-goog

