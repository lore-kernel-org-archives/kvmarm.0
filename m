Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E256451B169
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864971; cv=none; b=fD7YyL53FoSARO0JSHD7161wy27sIdKXjmd9Vk77gPrI4JLCE7NlOqv3kAFRxXwaLd6QkYCYBO5t6u/idJuDAvcxKM4XecsbloFZnvulEenSN3XajCS+Bps3l8zGXZBjsRPfSdB3dlkkMu3baXCoOWup1EwHyLO0Nj6vfjLnXyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864971; c=relaxed/simple;
	bh=pA/kUG5G+XixkpcPIZ/hO75Hclh96cuVsC4bqcJ3asQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TScsWEvtUJV3uCjOkTIE4D/Q39eXWwedLxAj3qRPD+6M/J/liYgDWPBTOz5wZguippaayEJ+EhGIO3ifTerh1AXf0o+DuzhUd9nxw/CX82itfSm3gBD/17D52KY5l9Eq3HM7FxCBMKkeOYjTL34sjBrEwJtWgvZQ5c1rzs7gq+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K3Gn1iRx; arc=none smtp.client-ip=209.85.208.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K3Gn1iRx"
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6ac670bc8ceso6189527a12.0
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790864960; x=1791469760; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DMwyr7ObjfHzk7BXLAxnkaVV3ek7lYDy19xVV+TQO8I=;
        b=K3Gn1iRxr3XH9X7EIKO90BlyiAC7pyma1J0Y9HdpDfzCk6ur8l8ghdzic3P68Xml8a
         JJ0kKTaDRQejHIPS05KgRSAge3n3cKvS+9rBXwJYHvvfMo4e1B+7T12BC3plapxG13Lj
         anbvTRVrQkWz/gzkTp/TQcHQtvxRWrckA5N68pZj9NJ8OOTBjKrCD+Xmkv6Wibqm8hhE
         wDRrIz1odSFJlREuUXl7ctIKP3mm71Js0lyOL5QgZL8ZaGjKD0AegbjsukLHC3Pl1Vg8
         FkD8P4svOD4oNJWic68GSxapM+P/rELY8Xk0JV0dl/thzc3nQvuAwmgMbeMArmbwR5oX
         wmbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790864960; x=1791469760;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DMwyr7ObjfHzk7BXLAxnkaVV3ek7lYDy19xVV+TQO8I=;
        b=SqF7ZNwNlyty7sOJc0sL/BYUdAayO+dNPUAfreH8vzqfk5A7zmlwxw52/oqPfYGszG
         Zsd64IF6mKhmXw5i8bj14d4/X9etTlofUpuJHhZf9nRp13lBYHnFmpGk48KAXw+6oDR2
         Kpb07q1d/nSgKIqNUexYQ+aCEDi7ZkqFweXRIH8rf3iJ2Kl37tjD4K7Sa5v+B0GU/6La
         j+fmtRpog3WdPsmyNlOaCURVZRYxvGxIJ8rcquTiItyVHbTss3HEpceMlTfPCXi/cV88
         WVkmxCgDAJgIt1jY+0GPkZKApWBYLKpTjInryDIqxjX3i5qGW+CmcyimRBUb1h1Yky9h
         md1A==
X-Forwarded-Encrypted: i=1; AKwUvBzTDnrr41WLtDIk6nW3YRCDLxadkjIJ56iOa17vO980fMe/Q9ipyxWyyt9N//nd03rYxFQuPEQ=@lists.linux.dev
X-Gm-Message-State: AFq9FYIX2UZrFpD+dqQd8CKW60MgB0/ceVZ30jWXBYgG7VBbiDYGNKXq
	KhdclonJ9GgdFvlrZAmP5HO4eITwDRDSzBmQ0hMFnmwVsiqHeJLdp61ORbogNyMnKdYRlGiSvm9
	E12KFtPE6Y/61i2Hc7imCgw==
X-Received: from edrc14.prod.google.com ([2002:aa7:d60e:0:b0:6ad:22cb:6f0])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3609:b0:6ac:af31:24f3 with SMTP id 4fb4d7f45d1cf-6ae19953e3emr4386105a12.31.1790864959647;
 Thu, 01 Oct 2026 07:29:19 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:28:49 +0100
In-Reply-To: <20261001142849.3367614-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001142849.3367614-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001142849.3367614-19-vdonnefort@google.com>
Subject: [PATCH v6 18/18] KVM: arm64: Alloc simple_buffer_page using pKVM hyp allocator
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
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
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  2 +-
 arch/arm64/kvm/hyp/nvhe/trace.c    | 63 +++++++++++++++++-------------
 arch/arm64/kvm/hyp_trace.c         | 15 ++++++-
 3 files changed, 50 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index af348e008f52..7a6435725dfe 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -907,7 +907,7 @@ DEFINE_KVM_HOST_HCALL(ulong, __pkvm_hyp_reclaimable,
 DEFINE_KVM_HOST_HCALL(int, __tracing_load,
 	void __kern *, desc_hva, size_t, desc_size)
 {
-	return __tracing_load(desc_hva, desc_size);
+	return errno_to_smccc(__tracing_load(desc_hva, desc_size));
 }
 
 DEFINE_KVM_HOST_HCALL0(void, __tracing_unload)
diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index 7acb81ae0e6a..0d7e4db0c3e1 100644
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
 
 	trace_buffer->bpages_backing_start = NULL;
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
@@ -197,17 +215,8 @@ static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_siz
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
index 44937e257375..5bc881d6f343 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -13,6 +13,7 @@
 #include <asm/kvm_host.h>
 #include <asm/kvm_hyptrace.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_pkvm.h>
 
 #include "hyp_trace.h"
 
@@ -151,11 +152,18 @@ static void __unshare_page(unsigned long va)
 
 static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_buffer, size_t size)
 {
-	int nr_bpages = (PAGE_ALIGN(size) / PAGE_SIZE) + 1;
 	size_t backing_size;
+	int nr_bpages;
 	void *start;
 	int ret;
 
+	if (is_protected_kvm_enabled()) {
+		trace_buffer->desc->bpages_backing_start = 0;
+		trace_buffer->desc->bpages_backing_size = 0;
+		return 0;
+	}
+
+	nr_bpages = (PAGE_ALIGN(size) / PAGE_SIZE) + 1;
 	backing_size = PAGE_ALIGN(sizeof(struct simple_buffer_page) * nr_bpages *
 				  num_possible_cpus());
 
@@ -177,6 +185,9 @@ static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_
 
 static void hyp_trace_buffer_free_bpages_backing(struct hyp_trace_buffer *trace_buffer)
 {
+	if (!trace_buffer->desc->bpages_backing_start)
+		return;
+
 	free_pages_exact((void *)trace_buffer->desc->bpages_backing_start,
 			 trace_buffer->desc->bpages_backing_size);
 }
@@ -269,7 +280,7 @@ static struct trace_buffer_desc *hyp_trace_load(unsigned long size, void *priv)
 	if (ret)
 		goto err_free_buffer;
 
-	ret = kvm_call_hyp_nvhe(__tracing_load, desc, desc_size);
+	ret = pkvm_call_hyp_req(__tracing_load, desc, desc_size);
 	if (ret)
 		goto err_unload_pages;
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

