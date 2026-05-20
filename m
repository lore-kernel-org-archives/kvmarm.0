Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9923E6385
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 15:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779290857; cv=none; b=e2WDqo6B6aAsoGJgGtrWvfzXXAEAcjgNIYuy6nq+MjFeXkTj1taWRWuOgvJd61/5D7WPcrgxIma9vbhdh/ukW7/f1AtEPAdaCBy1m1G4Ka9LJc5uF/h5f65mBUy2lGQCKkeEVRrJZ3fk/APwmNFz3EVB3RoqXxJkWD7VHXFcsQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779290857; c=relaxed/simple;
	bh=qPig5pYjTfxM4xfRavbt3mcac9z/IWJuxBGNraH9wS4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sfU4sjZeshy9os5XlV6MlD9QTGAeDhT7SD7vdZSzqfcF6Zj5Vr5ubdvxI5s6Ykm7OhjNwzVzCIjz+ivM4MDV018NcgVP3BFEGy9BbN6Oaky5gXik4Bln7NR1L4LjQFhtqf7CjoIUntyGIdNFFMeQgAS2b3Fwtb3Oi6I77uhFHbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S6fr1CpV; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S6fr1CpV"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-bcd55c93265so387883566b.0
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 08:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779290854; x=1779895654; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=30SECTmCnn+4kzr0vbGgOTAIATrBPzmK56JstesJefI=;
        b=S6fr1CpV3J0RrS1vpJKtCBSaBl09AT/uSEYEJWYajBNEXzteM+m0YOmRTomFrlBSl3
         1kk79o8nHMUjDMyINsyxmr8KhcX+e29a3SY3tjPU+nGrwAt++BcxAkNb27MrQWe8TeqV
         nxQHOEVupPuXvCiZKekenuT/+h9lb44NHvS5a7rDRCwe72I+w+/ePLxJXeS2E9s0T/IC
         tPJNB+SRsyz9/evaM2FvqVdfR5PDVm2oeaYPos+TEOMaHOT7hVBMbvac9IjjcAoVjJgJ
         HFoejcp+bamoAUaa+dRTr4+P8yIg8V4I3zewin33ytt/TCJj0h65N1WHqBYNf7J1M62U
         gq8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290854; x=1779895654;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=30SECTmCnn+4kzr0vbGgOTAIATrBPzmK56JstesJefI=;
        b=eErpkPo01Pa0PH3fVK80TPY3UlXbLmJ9xcQXArCRYcOEeVkhZYJBlOb2TmSNB/D0co
         fCqnq8GeUoWMFpq7VbVM+F552wjrJfe1wKAv0c0dp/LlzxLrKsYKaap/q/KhVy2ZjwQl
         bENlyGTg8nXNwH+qy4T+xWCZbo1vzfIWbHXDgwyEp4oJZESzWf3rNIB1vzPHmnte48zT
         MIz22JytiXz7K8GGEXNoFO+hgkpNcEoPilHpvjkMKsJNyAANFXSt4/0yTsUikC0ZY/yv
         WCxENdnbtYG8y8pcxQEU3Dht/yOH7qU7FcUQ15qYcTFtBIvoZr8og7Cd7PxBf8bOSmEE
         2TRw==
X-Forwarded-Encrypted: i=1; AFNElJ+1WnVv/YF2z4A/WrhFTQ0E/w+mZpkpOBgvrPfPfGg4tOJjsgF4110zySOkTRSk3ojCn15OaPA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwnS8A2psx48QTSOgln+hsCSAJePZAGHMD5ihrtGyHiDowFNOfg
	AN2vbfHfirEi5BFvzD0yYsdvyhFghq/75w9yly2klyNIwfFiMREiCfpH0SL37NpsdodjJ6Radee
	ul/OiLAT3ekz7FmJjmK6kCw==
X-Received: from edaa23.prod.google.com ([2002:a05:6402:24d7:b0:687:ae7:6e81])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:7946:b0:bd5:18e8:1ac1 with SMTP id a640c23a62f3a-bd518e822d4mr1267540866b.5.1779290853617;
 Wed, 20 May 2026 08:27:33 -0700 (PDT)
Date: Wed, 20 May 2026 16:26:50 +0100
In-Reply-To: <20260520152650.4107895-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520152650.4107895-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
Message-ID: <20260520152650.4107895-18-vdonnefort@google.com>
Subject: [PATCH 17/17] KVM: arm64: Alloc simple_buffer_page using pKVM hyp allocator
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
index 8d7e44e657eb..376bf0fd2a2d 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -725,7 +725,7 @@ static void handle___tracing_load(struct kvm_cpu_context *host_ctxt)
 	DECLARE_REG(unsigned long, desc_hva, host_ctxt, 1);
 	DECLARE_REG(size_t, desc_size, host_ctxt, 2);
 
-	cpu_reg(host_ctxt, 1) = __tracing_load(desc_hva, desc_size);
+	errno_to_smccc(__tracing_load(desc_hva, desc_size), host_ctxt);
 }
 
 static void handle___tracing_unload(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index a6ca27b18e15..680fe1cdf4a2 100644
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
+
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
 
-	memset(start, 0, size);
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
 
@@ -164,19 +184,20 @@ static int hyp_trace_buffer_load(struct hyp_trace_buffer *trace_buffer,
 	return ret;
 }
 
-static bool hyp_trace_desc_validate(struct hyp_trace_desc *desc, size_t desc_size)
+static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_size)
 {
 	struct ring_buffer_desc *rb_desc;
 	unsigned int cpu;
-	size_t nr_bpages;
 	void *desc_end;
 
+	if (!is_protected_kvm_enabled())
+		return true;
+
 	/*
-	 * Both desc_size and bpages_backing_size are untrusted host-provided
-	 * values. We rely on __pkvm_host_donate_hyp() to enforce their validity.
+	 * desc_size is an untrusted host-provided value. We rely on
+	 * __pkvm_host_donate_hyp() to enforce its validity.
 	 */
 	desc_end = (void *)desc + desc_size;
-	nr_bpages = desc->bpages_backing_size / sizeof(struct simple_buffer_page);
 
 	for_each_ring_buffer_desc(rb_desc, cpu, &desc->trace_buffer_desc) {
 		/* Can we read nr_page_va? */
@@ -187,17 +208,11 @@ static bool hyp_trace_desc_validate(struct hyp_trace_desc *desc, size_t desc_siz
 		if ((void *)rb_desc + struct_size(rb_desc, page_va, rb_desc->nr_page_va) > desc_end)
 			return false;
 
-		/* Overflow bpages backing memory? */
-		if (nr_bpages < rb_desc->nr_page_va)
-			return false;
-
 		if (cpu >= hyp_nr_cpus)
 			return false;
 
 		if (cpu != rb_desc->cpu)
 			return false;
-
-		nr_bpages -= rb_desc->nr_page_va;
 	}
 
 	return true;
@@ -212,8 +227,10 @@ int __tracing_load(unsigned long desc_hva, size_t desc_size)
 	if (ret)
 		return ret;
 
-	if (!hyp_trace_desc_validate(desc, desc_size))
+	if (!hyp_trace_desc_is_valid(desc, desc_size)) {
+		ret = -EINVAL;
 		goto err_release_desc;
+	}
 
 	hyp_spin_lock(&trace_buffer.lock);
 
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 8b7f2bf2fba8..afc8c3ea68f5 100644
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
@@ -262,7 +274,7 @@ static struct trace_buffer_desc *hyp_trace_load(unsigned long size, void *priv)
 	if (ret)
 		goto err_free_buffer;
 
-	ret = kvm_call_hyp_nvhe(__tracing_load, (unsigned long)desc, desc_size);
+	ret = pkvm_call_hyp_req(__tracing_load, (unsigned long)desc, desc_size);
 	if (ret)
 		goto err_unload_pages;
 
-- 
2.54.0.631.ge1b05301d1-goog

