Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18FE3BF673
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 17:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360485; cv=none; b=A6xO67VB/OMLRdL2zqRf33TRz17G3tjggnZCjvKVF1IL/gE0SACPVkXCT/VeQhc0g1hmdBBV7MmAGHG9Ax10JvTxhYhD8AFkuqDfbyBMCVC4qYVkhjVRFKzoh9vpBecRb70bIutHuw8ejS51RvDdR3u5AQ289+CqcHWSGG/fhNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360485; c=relaxed/simple;
	bh=wB1yGQ1x0sy5WhxHV6GOFycxHKwgYFBLwf8/X0gK8go=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fm6ohdKKhXGZkVMOZB2IX6h5azTDj6zoIxtPHlcWJ1XOCkpvzcuvxGm+enwBQwhAM2+iS2nwyzOSJhiyfg3X4mcailxXvyuS7yPOGzjiqFW1tZVoYq+jze7V6I/IL1FmltEMl09GUlXXxmfuOeCyPS6ba3LFH53TN8PUpVZn7dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YJxqm4e4; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YJxqm4e4"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-472bdd6f529so1944888f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 10:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783360482; x=1783965282; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DCk9ZbGTB15JZ6tac4qyTJ9t5PWU2IOsxTrNyd76gMU=;
        b=YJxqm4e4khqMGfd+lVCp9YyCoCUkqeu1t4b6z9RyFDI++p3gJUEVdJ4nDandqKPbjS
         LUXrC/JBZN0VAng/YErG9CCoPgc16ykl1GCISc85C1f+IhVjlHbIjOw6NzI9aJMrmjir
         iPx690zEU3pLrQbLRtfWUK6VNaqdAdyKes8detYSViwtHBo0TB/kkZ7VDHN5hiza/E74
         fxgArN9/Ga9DfxII1JgQQzQvhB9mn/dxTjyxT7mpDB5Tliudb55gNWxLRx2BygqFMX9b
         Ty8LhVCK/qtGaFSZIX6PzmedxYGJZ6FrC0nriadrGvcQUnHAEEjfsPQl4UNQIROKKShN
         r7LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360482; x=1783965282;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DCk9ZbGTB15JZ6tac4qyTJ9t5PWU2IOsxTrNyd76gMU=;
        b=KYtuMR64b8zAug9s3w5JstRf55TIksS6xpln1cHBkwEcKMeX1+0AVhahxmzdCT4PKy
         I9tnUq6neU2iSfYh2stdibqSXXtSlFApEkFmiEk7Q9rytYdv9BAUL9ND29l9KpJKA9c6
         5AJTjT9MmBw2A0kLAtcUTg+QL5dlg58SZABYbEVD28Z0o7jd7rMGBAwp7XbSFkpsY8w8
         J1tZtxt3M3lkI2YBlvp3xWE5M5ITay63dq5iur3QJWQIHwnlZtSjkZPPMAe3ft1xJnbg
         72qZUmHRL2QYDFDK5yftUpIBygMnRo3WwqgFuoCeHHA3bzkby2yXWXxT2MyPLE6pQGOD
         KSCg==
X-Forwarded-Encrypted: i=1; AHgh+RovxsHSfjjoJ9jX0Q/+3jG+aM6jwQbXLrBvrj1dxvXabC43rhXMYM1bOdxBzU5XxVu8igFOQn8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyeipD7bXKMiGWzedqBqIn/M5CA3arALjxpc5jqkHA453Z9l0WH
	s9hCusrNcIBVfwDIPRTZLc/q87ZMEWMa9Y+4Ez6TRGTLMm6+Xe9dvvSxouZ/1UDPl9u8G9Q1yhe
	noEtmXULBNZynIRSQQLhQjA==
X-Received: from wrmt10.prod.google.com ([2002:adf:e44a:0:b0:472:2add:c328])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:4644:0:b0:474:9dd3:981 with SMTP id ffacd0b85a97d-47de66b1354mr1301727f8f.26.1783360481992;
 Mon, 06 Jul 2026 10:54:41 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:54:15 +0100
In-Reply-To: <20260706175415.2604046-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260706175415.2604046-19-vdonnefort@google.com>
Subject: [PATCH v2 18/18] KVM: arm64: Alloc simple_buffer_page using pKVM hyp allocator
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In protected mode, transition the allocation of the simple_ring_buffer
structures from the host to the hypervisor using the new pKVM heap
allocator.

Previously, the host allocated and donated a contiguous backing memory
for these structures. In pKVM the hypervisor can now allocate them
dynamically.

Use the pkvm_call_hyp_req() wrapper in the host to invoke
__tracing_load, which automatically handles any top-up requests if the
hypervisor runs out of heap memory during allocation.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 1315129dcd1f..090319bddf86 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -745,7 +745,7 @@ static void handle___tracing_load(struct kvm_cpu_context *host_ctxt)
 	DECLARE_REG(unsigned long, desc_hva, host_ctxt, 1);
 	DECLARE_REG(size_t, desc_size, host_ctxt, 2);
 
-	cpu_reg(host_ctxt, 1) = __tracing_load(desc_hva, desc_size);
+	errno_to_smccc(__tracing_load(desc_hva, desc_size), host_ctxt);
 }
 
 static void handle___tracing_unload(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index 6e716295247a..bcfe06bba29b 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -4,6 +4,7 @@
  * Author: Vincent Donnefort <vdonnefort@google.com>
  */
 
+#include <nvhe/alloc.h>
 #include <nvhe/clock.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
@@ -62,18 +63,34 @@ static void __release_host_mem(void *start, u64 size)
 	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(start), size >> PAGE_SHIFT));
 }
 
-static int hyp_trace_buffer_load_bpage_backing(struct hyp_trace_buffer *trace_buffer,
-					       struct hyp_trace_desc *desc)
+static int hyp_trace_buffer_alloc_bpages(struct hyp_trace_buffer *trace_buffer,
+					 struct hyp_trace_desc *desc)
 {
-	void *start = (void *)kern_hyp_va(desc->bpages_backing_start);
-	size_t size = desc->bpages_backing_size;
+	void *start;
+	size_t size;
 	int ret;
 
-	ret = __admit_host_mem(start, size);
-	if (ret)
-		return ret;
+	if (is_protected_kvm_enabled()) {
+		struct ring_buffer_desc *rb_desc;
+		int cpu;
 
-	memset(start, 0, size);
+		size = 0;
+		for_each_ring_buffer_desc(rb_desc, cpu, &desc->trace_buffer_desc)
+			size += rb_desc->nr_page_va * sizeof(struct simple_buffer_page);
+
+		start = hyp_alloc(size);
+		if (!start)
+			return hyp_alloc_errno();
+	} else {
+		start = (void *)kern_hyp_va(desc->bpages_backing_start);
+		size = desc->bpages_backing_size;
+
+		ret = __admit_host_mem(start, size);
+		if (ret)
+			return ret;
+
+		memset(start, 0, size);
+	}
 
 	trace_buffer->bpages_backing_start = start;
 	trace_buffer->bpages_backing_size = size;
@@ -81,7 +98,7 @@ static int hyp_trace_buffer_load_bpage_backing(struct hyp_trace_buffer *trace_bu
 	return 0;
 }
 
-static void hyp_trace_buffer_unload_bpage_backing(struct hyp_trace_buffer *trace_buffer)
+static void hyp_trace_buffer_free_bpages(struct hyp_trace_buffer *trace_buffer)
 {
 	void *start = trace_buffer->bpages_backing_start;
 	size_t size = trace_buffer->bpages_backing_size;
@@ -89,9 +106,12 @@ static void hyp_trace_buffer_unload_bpage_backing(struct hyp_trace_buffer *trace
 	if (!size)
 		return;
 
-	memset(start, 0, size);
-
-	__release_host_mem(start, size);
+	if (is_protected_kvm_enabled()) {
+		hyp_free(start);
+	} else {
+		memset(start, 0, size);
+		__release_host_mem(start, size);
+	}
 
 	trace_buffer->bpages_backing_start = 0;
 	trace_buffer->bpages_backing_size = 0;
@@ -128,7 +148,7 @@ static void hyp_trace_buffer_unload(struct hyp_trace_buffer *trace_buffer)
 		simple_ring_buffer_unload_mm(per_cpu_ptr(trace_buffer->simple_rbs, cpu),
 					     __unpin_shared_page);
 
-	hyp_trace_buffer_unload_bpage_backing(trace_buffer);
+	hyp_trace_buffer_free_bpages(trace_buffer);
 }
 
 static int hyp_trace_buffer_load(struct hyp_trace_buffer *trace_buffer,
@@ -143,7 +163,7 @@ static int hyp_trace_buffer_load(struct hyp_trace_buffer *trace_buffer,
 	if (hyp_trace_buffer_loaded(trace_buffer))
 		return -EINVAL;
 
-	ret = hyp_trace_buffer_load_bpage_backing(trace_buffer, desc);
+	ret = hyp_trace_buffer_alloc_bpages(trace_buffer, desc);
 	if (ret)
 		return ret;
 
@@ -168,18 +188,16 @@ static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_siz
 {
 	struct ring_buffer_desc *rb_desc;
 	unsigned int cpu;
-	size_t nr_bpages;
 	void *desc_end;
 
 	if (!is_protected_kvm_enabled())
 		return true;
 
 	/*
-	 * Both desc_size and bpages_backing_size are untrusted host-provided
-	 * values. We rely on __pkvm_host_donate_hyp() to enforce their validity.
+	 * desc_size is an untrusted host-provided value. We rely on
+	 * __pkvm_host_donate_hyp() to enforce its validity.
 	 */
 	desc_end = (void *)desc + desc_size;
-	nr_bpages = desc->bpages_backing_size / sizeof(struct simple_buffer_page);
 
 	if (desc->trace_buffer_desc.nr_cpus != hyp_nr_cpus)
 		return false;
@@ -193,17 +211,8 @@ static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_siz
 		if ((void *)rb_desc + struct_size(rb_desc, page_va, rb_desc->nr_page_va) > desc_end)
 			return false;
 
-		/* Overflow bpages backing memory? */
-		if (nr_bpages < rb_desc->nr_page_va)
-			return false;
-
-		if (cpu >= hyp_nr_cpus)
-			return false;
-
 		if (cpu != rb_desc->cpu)
 			return false;
-
-		nr_bpages -= rb_desc->nr_page_va;
 	}
 
 	return true;
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 2411b4c32932..405ccd954524 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -13,6 +13,7 @@
 #include <asm/kvm_host.h>
 #include <asm/kvm_hyptrace.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_pkvm.h>
 
 #include "hyp_trace.h"
 
@@ -157,10 +158,18 @@ static void __unshare_page(unsigned long va)
 
 static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_buffer, size_t size)
 {
-	int nr_bpages = (PAGE_ALIGN(size) / PAGE_SIZE) + 1;
 	size_t backing_size;
+	int nr_bpages;
 	void *start;
 
+	/* pKVM uses hyp_alloc() to allocate struct simple_buffer_page */
+	if (is_protected_kvm_enabled()) {
+		trace_buffer->desc->bpages_backing_start = 0;
+		trace_buffer->desc->bpages_backing_size = 0;
+		return 0;
+	}
+
+	nr_bpages = (PAGE_ALIGN(size) / PAGE_SIZE) + 1;
 	backing_size = PAGE_ALIGN(sizeof(struct simple_buffer_page) * nr_bpages *
 				  num_possible_cpus());
 
@@ -176,6 +185,9 @@ static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_
 
 static void hyp_trace_buffer_free_bpages_backing(struct hyp_trace_buffer *trace_buffer)
 {
+	if (!trace_buffer->desc->bpages_backing_start)
+		return;
+
 	free_pages_exact((void *)trace_buffer->desc->bpages_backing_start,
 			 trace_buffer->desc->bpages_backing_size);
 }
@@ -264,7 +276,7 @@ static struct trace_buffer_desc *hyp_trace_load(unsigned long size, void *priv)
 	if (ret)
 		goto err_free_buffer;
 
-	ret = kvm_call_hyp_nvhe(__tracing_load, (unsigned long)desc, desc_size);
+	ret = pkvm_call_hyp_req(__tracing_load, (unsigned long)desc, desc_size);
 	if (ret)
 		goto err_unload_pages;
 
-- 
2.55.0.rc2.803.g1fd1e6609c-goog

