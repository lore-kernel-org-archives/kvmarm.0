Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BC023BCEA
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 12:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740399339; cv=none; b=rQ1uaI4M39kZlRP9ImSgugl7UAH+mA6a1c52tFoAL7xVYj4zhaqFhMxu4Nz5WVVRBQh/YiPWgAOTbcyag0GaFtKeOdYSp2/o5YMGcROuV3tgKbxyXPUogt8nrYoDBGOC/2I+CCJ9Mxc/wxaCWG3E5nBerd/+f3wjrpDrlOdtVGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740399339; c=relaxed/simple;
	bh=cgfv6W+bmX/DgxBsbqaabh/60mejqSNjYTJAjvocRpc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KmaovMSyc/qU99KTALhoHtg3eIHXVtWNJFN00odwEcFgGgspp1Qc+TUmKe9hJMRYyFv0aS9x1ELFmXkTLWFFGtBIOKen6VJlsSWR+aTQWtu8P17JDxIszOn3KXfemBqIBoz3TPNrwXkm8thGhbOHAsuV91a1Jso8wHsgXUr1qho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U8VJGU2u; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U8VJGU2u"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4394c747c72so18249905e9.1
        for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 04:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740399334; x=1741004134; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aUpfaQpj04iJFsYYTcEuP7scbGKL/aNHjshEDK/nRSA=;
        b=U8VJGU2u/sAgf3a/RSbZL55XVUYUVdiUG2wwZM9Mg2K82cK2TZM2b+8Hr846ER90pV
         h5sjHahPEVh7S4OzDPv909N50xa/rC4aUfA5tIc57WUvmOMgzg6XfEU5bC6YSaabthwC
         KdFMMho3zEEGqHpUO0WMdtyHvCUmMCXFVDRxFCkYQ6XAO3twX7cctU633RoedFdMEvOK
         0xwsYlVv5aNMubzlU6R2/hQcLL8YXXyBHDP2z9R3YRyStgrktkxvTRziMFGIz+HClG9C
         aGl4kXR13YI2er3AHChaGue3w4ARU73qsNxnxZp2MTdEf44DFKMIVO8OX+cs2uPYLCm2
         /l3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740399334; x=1741004134;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aUpfaQpj04iJFsYYTcEuP7scbGKL/aNHjshEDK/nRSA=;
        b=sHFEBboHJWEQM3Jya9+t7WOP9FGuSmWBMNqoGPVQe2UfEENGhej7OrYeCqfrVwJyue
         5YvARx02uyWpWEm6AffxvCyG4l89NyaSmIubnvr6zBwsDVY6juHW4na50cFVxJMOgqn1
         nfR4xvCAG1MUZjQcK82itCuwdEC8NRt6olYmcjZvA6/xexj27mGSflsPP6NVTPJX2vE4
         H0FGz9fGO1fRcPK+aOqWfXSMJACMErLXiAjjDwYToExNYwjsZnYw+D9D+kLdFh0HTc38
         FH6gbMUobU9FsbkNfZJxWrt98H/57Z54DUQjRpEWeCmY8NdmEuNdjwKWP6mZg3QzymVq
         /aYw==
X-Gm-Message-State: AOJu0Yyl+SIycCvRPcX8BbGCs55UuPo9J9jPFF7Vo6yNJf6LG9tYDANC
	rtem2y5uhg+GpxTfqR19lvokgrUgxgDx+5O+omMbRqy43m50DNQzAvBgzQFTkkNWKCG7ulOSsbH
	xYEXpdswwehC8GplY8A==
X-Google-Smtp-Source: AGHT+IHgUPH89QePxBj29K/nOYsLmMYjAgZct1FEMGw34skcpaq0UyS4hmX+PAG9Ke/XH2yyDW17L/TIM8+hJ8y8
X-Received: from wmbep9.prod.google.com ([2002:a05:600c:8409:b0:439:65f0:b039])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:19c9:b0:439:9a5b:87d4 with SMTP id 5b1f17b1804b1-439ae1f3a3dmr102587245e9.13.1740399334225;
 Mon, 24 Feb 2025 04:15:34 -0800 (PST)
Date: Mon, 24 Feb 2025 12:13:47 +0000
In-Reply-To: <20250224121353.98697-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250224121353.98697-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250224121353.98697-6-vdonnefort@google.com>
Subject: [PATCH 05/11] KVM: arm64: Add tracing support for the pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

When running with protected mode, the host has very little knowledge
about what is happening in the hypervisor. Of course this is an
essential feature for security but nonetheless, that piece of code
growing with more responsibilities, we need now a way to debug and
profile it. Tracefs by its reliatility, versatility and support for
user-space is the perfect tool.

There's no way the hypervisor could log events directly into the host
tracefs ring-buffers. So instead let's use our own, where the hypervisor
is the writer and the host the reader.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index bec227f9500a..b5893e0afe8e 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -87,6 +87,10 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
+	__KVM_HOST_SMCCC_FUNC___pkvm_load_tracing,
+	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_tracing,
+	__KVM_HOST_SMCCC_FUNC___pkvm_enable_tracing,
+	__KVM_HOST_SMCCC_FUNC___pkvm_swap_reader_tracing,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_hyptrace.h b/arch/arm64/include/asm/kvm_hyptrace.h
new file mode 100644
index 000000000000..7da6a248c7fa
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_hyptrace.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ARM64_KVM_HYPTRACE_H_
+#define __ARM64_KVM_HYPTRACE_H_
+#include <asm/kvm_hyp.h>
+
+#include <linux/ring_buffer.h>
+
+/*
+ * Host donations to the hypervisor to store the struct hyp_buffer_page.
+ */
+struct hyp_buffer_pages_backing {
+	unsigned long start;
+	size_t size;
+};
+
+struct hyp_trace_desc {
+	struct hyp_buffer_pages_backing	backing;
+	struct trace_page_desc		page_desc;
+
+};
+#endif
diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
new file mode 100644
index 000000000000..bf74a6ee322d
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ARM64_KVM_HYP_NVHE_TRACE_H
+#define __ARM64_KVM_HYP_NVHE_TRACE_H
+#include <asm/kvm_hyptrace.h>
+
+/* Internal struct exported for hyp-constants.c */
+struct hyp_buffer_page {
+	struct list_head	list;
+	struct buffer_data_page	*page;
+	u64			entries;
+	u32			write;
+	u32			id;
+};
+
+#ifdef CONFIG_TRACING
+void *tracing_reserve_entry(unsigned long length);
+void tracing_commit_entry(void);
+
+int __pkvm_load_tracing(unsigned long desc_va, size_t desc_size);
+void __pkvm_teardown_tracing(void);
+int __pkvm_enable_tracing(bool enable);
+int __pkvm_swap_reader_tracing(unsigned int cpu);
+#else
+static inline void *tracing_reserve_entry(unsigned long length) { return NULL; }
+static inline void tracing_commit_entry(void) { }
+
+static inline int __pkvm_load_tracing(unsigned long desc_va, size_t desc_size) { return -ENODEV; }
+static inline void __pkvm_teardown_tracing(void) { }
+static inline int __pkvm_enable_tracing(bool enable) { return -ENODEV; }
+static inline int __pkvm_swap_reader_tracing(unsigned int cpu) { return -ENODEV; }
+#endif
+#endif
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 323e992089bd..40f243c44cf5 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -28,7 +28,7 @@ hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
-hyp-obj-$(CONFIG_TRACING) += clock.o
+hyp-obj-$(CONFIG_TRACING) += clock.o trace.o
 hyp-obj-y += $(lib-objs)
 
 ##
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2c37680d954c..ced0a161d56e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -18,6 +18,7 @@
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 #include <nvhe/pkvm.h>
+#include <nvhe/trace.h>
 #include <nvhe/trap_handler.h>
 
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
@@ -570,6 +571,35 @@ static void handle___pkvm_teardown_vm(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_teardown_vm(handle);
 }
 
+static void handle___pkvm_load_tracing(struct kvm_cpu_context *host_ctxt)
+{
+	 DECLARE_REG(unsigned long, desc_hva, host_ctxt, 1);
+	 DECLARE_REG(size_t, desc_size, host_ctxt, 2);
+
+	 cpu_reg(host_ctxt, 1) = __pkvm_load_tracing(desc_hva, desc_size);
+}
+
+static void handle___pkvm_teardown_tracing(struct kvm_cpu_context *host_ctxt)
+{
+	__pkvm_teardown_tracing();
+
+	cpu_reg(host_ctxt, 1) = 0;
+}
+
+static void handle___pkvm_enable_tracing(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(bool, enable, host_ctxt, 1);
+
+	cpu_reg(host_ctxt, 1) = __pkvm_enable_tracing(enable);
+}
+
+static void handle___pkvm_swap_reader_tracing(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(unsigned int, cpu, host_ctxt, 1);
+
+	cpu_reg(host_ctxt, 1) = __pkvm_swap_reader_tracing(cpu);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -609,6 +639,10 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
+	HANDLE_FUNC(__pkvm_load_tracing),
+	HANDLE_FUNC(__pkvm_teardown_tracing),
+	HANDLE_FUNC(__pkvm_enable_tracing),
+	HANDLE_FUNC(__pkvm_swap_reader_tracing),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
new file mode 100644
index 000000000000..4611cef64566
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -0,0 +1,558 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Google LLC
+ * Author: Vincent Donnefort <vdonnefort@google.com>
+ */
+
+#include <nvhe/clock.h>
+#include <nvhe/mem_protect.h>
+#include <nvhe/mm.h>
+#include <nvhe/trace.h>
+
+#include <asm/percpu.h>
+#include <asm/kvm_mmu.h>
+#include <asm/local.h>
+
+struct hyp_rb_per_cpu {
+	struct trace_buffer_meta	*meta;
+	struct hyp_buffer_page		*tail_page;
+	struct hyp_buffer_page		*reader_page;
+	struct hyp_buffer_page		*head_page;
+	struct hyp_buffer_page		*bpages;
+	u32				nr_pages;
+	u32				status;
+	u64				last_overrun;
+	u64				write_stamp;
+};
+
+#define HYP_RB_UNAVAILABLE	0
+#define HYP_RB_READY		1
+#define HYP_RB_WRITING		2
+
+static struct hyp_buffer_pages_backing hyp_buffer_pages_backing;
+static DEFINE_PER_CPU(struct hyp_rb_per_cpu, trace_rb);
+static DEFINE_HYP_SPINLOCK(trace_rb_lock);
+
+#define HYP_BPAGE_LINK_HEAD	1UL
+#define HYP_BPAGE_LINK_MASK	~HYP_BPAGE_LINK_HEAD
+
+static bool hyp_bpage_try_shunt_link(struct hyp_buffer_page *bpage, struct hyp_buffer_page *dst,
+				     unsigned long old_flags, unsigned long flags)
+{
+	unsigned long *ptr = (unsigned long *)(&bpage->list.next);
+	unsigned long old = (*ptr & HYP_BPAGE_LINK_MASK) | old_flags;
+	unsigned long new = (unsigned long)(&dst->list) | flags;
+
+	return cmpxchg(ptr, old, new) == old;
+}
+
+static void hyp_bpage_set_link_flag(struct hyp_buffer_page *bpage, unsigned long flag)
+{
+	bpage->list.next = (struct list_head *)
+		(((unsigned long)bpage->list.next & HYP_BPAGE_LINK_MASK) | flag);
+}
+
+static struct hyp_buffer_page *hyp_bpage_from_link(struct list_head *list)
+{
+	unsigned long ptr = (unsigned long)list & HYP_BPAGE_LINK_MASK;
+
+	return container_of((struct list_head *)ptr, struct hyp_buffer_page, list);
+}
+
+static struct hyp_buffer_page *hyp_bpage_next_page(struct hyp_buffer_page *bpage)
+{
+	return hyp_bpage_from_link(bpage->list.next);
+}
+
+static bool hyp_bpage_is_head(struct hyp_buffer_page *bpage)
+{
+	return (unsigned long)bpage->list.prev->next & HYP_BPAGE_LINK_HEAD;
+}
+
+static void hyp_bpage_reset(struct hyp_buffer_page *bpage)
+{
+	bpage->write = 0;
+	bpage->entries = 0;
+
+	local_set(&bpage->page->commit, 0);
+}
+
+static int hyp_bpage_init(struct hyp_buffer_page *bpage, unsigned long hva)
+{
+	void *hyp_va = (void *)kern_hyp_va(hva);
+	int ret;
+
+	ret = hyp_pin_shared_mem(hyp_va, hyp_va + PAGE_SIZE);
+	if (ret)
+		return ret;
+
+	INIT_LIST_HEAD(&bpage->list);
+	bpage->page = (struct buffer_data_page *)hyp_va;
+
+	hyp_bpage_reset(bpage);
+
+	return 0;
+}
+
+#define hyp_rb_meta_inc(__meta, __inc)		\
+	WRITE_ONCE((__meta), (__meta + __inc))
+
+static bool hyp_rb_loaded(struct hyp_rb_per_cpu *cpu_buffer)
+{
+	return !!cpu_buffer->bpages;
+}
+
+static int hyp_rb_swap_reader(struct hyp_rb_per_cpu *cpu_buffer)
+{
+	struct hyp_buffer_page *last, *head, *reader;
+	unsigned long overrun;
+
+	if (!hyp_rb_loaded(cpu_buffer))
+		return -ENODEV;
+
+	head = cpu_buffer->head_page;
+	reader = cpu_buffer->reader_page;
+
+	do {
+		/* Run after the writer to find the head */
+		while (!hyp_bpage_is_head(head))
+			cpu_buffer->head_page = head = hyp_bpage_next_page(head);
+
+		/* Connect the reader page around the header page */
+		reader->list.next = head->list.next;
+		reader->list.prev = head->list.prev;
+
+		/* The last page before the head */
+		last = hyp_bpage_from_link(reader->list.next);
+
+		/* The reader page points to the new header page */
+		hyp_bpage_set_link_flag(reader, HYP_BPAGE_LINK_HEAD);
+
+		overrun = smp_load_acquire(&cpu_buffer->meta->overrun);
+	} while (!hyp_bpage_try_shunt_link(last, reader, HYP_BPAGE_LINK_HEAD, 0));
+
+	cpu_buffer->head_page = hyp_bpage_from_link(reader->list.next);
+	cpu_buffer->head_page->list.prev = &reader->list;
+	cpu_buffer->reader_page = head;
+	cpu_buffer->meta->reader.lost_events = overrun - cpu_buffer->last_overrun;
+	cpu_buffer->meta->reader.id = cpu_buffer->reader_page->id;
+	cpu_buffer->last_overrun = overrun;
+
+	return 0;
+}
+
+static struct hyp_buffer_page *hyp_rb_move_tail(struct hyp_rb_per_cpu *cpu_buffer)
+{
+	struct hyp_buffer_page *tail, *new_tail;
+
+	tail = cpu_buffer->tail_page;
+	new_tail = hyp_bpage_next_page(tail);
+
+	if (hyp_bpage_try_shunt_link(tail, new_tail, HYP_BPAGE_LINK_HEAD, 0)) {
+		/*
+		 * Oh no! we've caught the head. There is none anymore and swap_reader will spin
+		 * until we set the new one. Overrun must be written first, to make sure we report
+		 * the correct number of lost events.
+		 */
+		hyp_rb_meta_inc(cpu_buffer->meta->overrun, new_tail->entries);
+		hyp_rb_meta_inc(meta_pages_lost(cpu_buffer->meta), 1);
+
+		smp_store_release(&new_tail->list.next,
+				  (unsigned long)new_tail->list.next | HYP_BPAGE_LINK_HEAD);
+	}
+
+	hyp_bpage_reset(new_tail);
+	cpu_buffer->tail_page = new_tail;
+
+	hyp_rb_meta_inc(meta_pages_touched(cpu_buffer->meta), 1);
+
+	return new_tail;
+}
+
+static unsigned long rb_event_size(unsigned long length)
+{
+	struct ring_buffer_event *event;
+
+	return length + RB_EVNT_HDR_SIZE + sizeof(event->array[0]);
+}
+
+static struct ring_buffer_event *
+rb_add_ts_extend(struct ring_buffer_event *event, u64 delta)
+{
+	event->type_len = RINGBUF_TYPE_TIME_EXTEND;
+	event->time_delta = delta & TS_MASK;
+	event->array[0] = delta >> TS_SHIFT;
+
+	return (struct ring_buffer_event *)((unsigned long)event + 8);
+}
+
+static struct ring_buffer_event *
+hyp_rb_reserve_next(struct hyp_rb_per_cpu *cpu_buffer, unsigned long length)
+{
+	unsigned long ts_ext_size = 0, event_size = rb_event_size(length);
+	struct hyp_buffer_page *tail = cpu_buffer->tail_page;
+	struct ring_buffer_event *event;
+	u32 write, prev_write;
+	u64 ts, time_delta;
+
+	ts = trace_clock();
+
+	time_delta = ts - cpu_buffer->write_stamp;
+
+	if (test_time_stamp(time_delta))
+		ts_ext_size = 8;
+
+	prev_write = tail->write;
+	write = prev_write + event_size + ts_ext_size;
+
+	if (unlikely(write > BUF_PAGE_SIZE))
+		tail = hyp_rb_move_tail(cpu_buffer);
+
+	if (!tail->entries) {
+		tail->page->time_stamp = ts;
+		time_delta = 0;
+		ts_ext_size = 0;
+		write = event_size;
+		prev_write = 0;
+	}
+
+	tail->write = write;
+	tail->entries++;
+
+	cpu_buffer->write_stamp = ts;
+
+	event = (struct ring_buffer_event *)(tail->page->data + prev_write);
+	if (ts_ext_size) {
+		event = rb_add_ts_extend(event, time_delta);
+		time_delta = 0;
+	}
+
+	event->type_len = 0;
+	event->time_delta = time_delta;
+	event->array[0] = event_size - RB_EVNT_HDR_SIZE;
+
+	return event;
+}
+
+void *tracing_reserve_entry(unsigned long length)
+{
+	struct hyp_rb_per_cpu *cpu_buffer = this_cpu_ptr(&trace_rb);
+	struct ring_buffer_event *rb_event;
+
+	if (cmpxchg(&cpu_buffer->status, HYP_RB_READY, HYP_RB_WRITING) != HYP_RB_READY)
+		return NULL;
+
+	rb_event = hyp_rb_reserve_next(cpu_buffer, length);
+
+	return &rb_event->array[1];
+}
+
+void tracing_commit_entry(void)
+{
+	struct hyp_rb_per_cpu *cpu_buffer = this_cpu_ptr(&trace_rb);
+
+	local_set(&cpu_buffer->tail_page->page->commit,
+		  cpu_buffer->tail_page->write);
+	hyp_rb_meta_inc(cpu_buffer->meta->entries, 1);
+
+	/*
+	 * Paired with hyp_rb_disable_writing() to ensure data is
+	 * written to the ring-buffer before teardown.
+	 */
+	smp_store_release(&cpu_buffer->status, HYP_RB_READY);
+}
+
+static void hyp_rb_disable_writing(struct hyp_rb_per_cpu *cpu_buffer)
+{
+	u32 prev_status;
+
+	/* Wait for the buffer to be released */
+	do {
+		prev_status = cmpxchg_acquire(&cpu_buffer->status,
+					      HYP_RB_READY,
+					      HYP_RB_UNAVAILABLE);
+	} while (prev_status == HYP_RB_WRITING);
+}
+
+static int hyp_rb_enable_writing(struct hyp_rb_per_cpu *cpu_buffer)
+{
+	if (!hyp_rb_loaded(cpu_buffer))
+		return -ENODEV;
+
+	cmpxchg(&cpu_buffer->status, HYP_RB_UNAVAILABLE, HYP_RB_READY);
+
+	return 0;
+}
+
+static void hyp_rb_teardown(struct hyp_rb_per_cpu *cpu_buffer)
+{
+	int i;
+
+	if (!hyp_rb_loaded(cpu_buffer))
+		return;
+
+	hyp_rb_disable_writing(cpu_buffer);
+
+	hyp_unpin_shared_mem((void *)cpu_buffer->meta,
+			     (void *)(cpu_buffer->meta) + PAGE_SIZE);
+
+	for (i = 0; i < cpu_buffer->nr_pages; i++) {
+		struct hyp_buffer_page *bpage = &cpu_buffer->bpages[i];
+
+		if (!bpage->page)
+			continue;
+
+		hyp_unpin_shared_mem((void *)bpage->page,
+				     (void *)bpage->page + PAGE_SIZE);
+	}
+
+	cpu_buffer->bpages = 0;
+}
+
+static bool hyp_rb_fits_backing(u32 nr_pages, struct hyp_buffer_page *start)
+{
+	unsigned long max = hyp_buffer_pages_backing.start +
+			    hyp_buffer_pages_backing.size;
+	struct hyp_buffer_page *end = start + nr_pages;
+
+	return (unsigned long)end <= max;
+}
+
+static int hyp_rb_init(struct rb_page_desc *pdesc, struct hyp_buffer_page *start,
+		       struct hyp_rb_per_cpu *cpu_buffer)
+{
+	struct hyp_buffer_page *bpage = start;
+	int i, ret;
+
+	/* At least 1 reader page and one head */
+	if (pdesc->nr_page_va < 2)
+		return -EINVAL;
+
+	/* nr_page_va + 1 must fit nr_pages */
+	if (pdesc->nr_page_va >= U32_MAX)
+		return -EINVAL;
+
+	if (!hyp_rb_fits_backing(pdesc->nr_page_va, start))
+		return -EINVAL;
+
+	if (hyp_rb_loaded(cpu_buffer))
+		return -EBUSY;
+
+	cpu_buffer->bpages = start;
+
+	cpu_buffer->meta = (struct trace_buffer_meta *)kern_hyp_va(pdesc->meta_va);
+	ret = hyp_pin_shared_mem((void *)cpu_buffer->meta,
+				 ((void *)cpu_buffer->meta) + PAGE_SIZE);
+	if (ret)
+		return ret;
+
+	memset(cpu_buffer->meta, 0, sizeof(*cpu_buffer->meta));
+	cpu_buffer->meta->meta_page_size = PAGE_SIZE;
+	cpu_buffer->meta->nr_subbufs = cpu_buffer->nr_pages;
+
+	/* The reader page is not part of the ring initially */
+	ret = hyp_bpage_init(bpage, pdesc->page_va[0]);
+	if (ret)
+		goto err;
+
+	cpu_buffer->nr_pages = 1;
+
+	cpu_buffer->reader_page = bpage;
+	cpu_buffer->tail_page = bpage + 1;
+	cpu_buffer->head_page = bpage + 1;
+
+	for (i = 1; i < pdesc->nr_page_va; i++) {
+		ret = hyp_bpage_init(++bpage, pdesc->page_va[i]);
+		if (ret)
+			goto err;
+
+		bpage->list.next = &(bpage + 1)->list;
+		bpage->list.prev = &(bpage - 1)->list;
+		bpage->id = i;
+
+		cpu_buffer->nr_pages = i + 1;
+	}
+
+	/* Close the ring */
+	bpage->list.next = &cpu_buffer->tail_page->list;
+	cpu_buffer->tail_page->list.prev = &bpage->list;
+
+	/* The last init'ed page points to the head page */
+	hyp_bpage_set_link_flag(bpage, HYP_BPAGE_LINK_HEAD);
+
+	cpu_buffer->last_overrun = 0;
+
+	return 0;
+
+err:
+	hyp_rb_teardown(cpu_buffer);
+
+	return ret;
+}
+
+static int hyp_setup_bpage_backing(struct hyp_trace_desc *desc)
+{
+	unsigned long start = kern_hyp_va(desc->backing.start);
+	size_t size = desc->backing.size;
+	int ret;
+
+	if (hyp_buffer_pages_backing.size)
+		return -EBUSY;
+
+	if (!PAGE_ALIGNED(start) || !PAGE_ALIGNED(size))
+		return -EINVAL;
+
+	ret = __pkvm_host_donate_hyp(hyp_virt_to_pfn((void *)start), size >> PAGE_SHIFT);
+	if (ret)
+		return ret;
+
+	memset((void *)start, 0, size);
+
+	hyp_buffer_pages_backing.start = start;
+	hyp_buffer_pages_backing.size = size;
+
+	return 0;
+}
+
+static void hyp_teardown_bpage_backing(void)
+{
+	unsigned long start = hyp_buffer_pages_backing.start;
+	size_t size = hyp_buffer_pages_backing.size;
+
+	if (!size)
+		return;
+
+	memset((void *)start, 0, size);
+
+	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(start), size >> PAGE_SHIFT));
+
+	hyp_buffer_pages_backing.start = 0;
+	hyp_buffer_pages_backing.size = 0;
+}
+
+int __pkvm_swap_reader_tracing(unsigned int cpu)
+{
+	int ret = 0;
+
+	if (cpu >= hyp_nr_cpus)
+		return -EINVAL;
+
+	hyp_spin_lock(&trace_rb_lock);
+	ret = hyp_rb_swap_reader(per_cpu_ptr(&trace_rb, cpu));
+	hyp_spin_unlock(&trace_rb_lock);
+
+	return ret;
+}
+
+static void __pkvm_teardown_tracing_locked(void)
+{
+	int cpu;
+
+	hyp_assert_lock_held(&trace_rb_lock);
+
+	for (cpu = 0; cpu < hyp_nr_cpus; cpu++) {
+		struct hyp_rb_per_cpu *cpu_buffer = per_cpu_ptr(&trace_rb, cpu);
+
+		hyp_rb_teardown(cpu_buffer);
+	}
+
+	hyp_teardown_bpage_backing();
+}
+
+void __pkvm_teardown_tracing(void)
+{
+	hyp_spin_lock(&trace_rb_lock);
+	__pkvm_teardown_tracing_locked();
+	hyp_spin_unlock(&trace_rb_lock);
+}
+
+static bool rb_page_desc_fits_desc(struct rb_page_desc *pdesc,
+				   unsigned long desc_end)
+{
+	unsigned long *end;
+
+	/* Check we can at least read nr_pages */
+	if ((unsigned long)&pdesc->nr_page_va >= desc_end)
+		return false;
+
+	end = &pdesc->page_va[pdesc->nr_page_va];
+
+	return (unsigned long)end <= desc_end;
+}
+
+int __pkvm_load_tracing(unsigned long desc_hva, size_t desc_size)
+{
+	struct hyp_trace_desc *desc = (struct hyp_trace_desc *)kern_hyp_va(desc_hva);
+	struct trace_page_desc *trace_pdesc = &desc->page_desc;
+	struct hyp_buffer_page *bpage_backing_start;
+	struct rb_page_desc *pdesc;
+	int ret, cpu;
+
+	if (!desc_size || !PAGE_ALIGNED(desc_hva) || !PAGE_ALIGNED(desc_size))
+		return -EINVAL;
+
+	ret = __pkvm_host_donate_hyp(hyp_virt_to_pfn((void *)desc),
+				     desc_size >> PAGE_SHIFT);
+	if (ret)
+		return ret;
+
+	hyp_spin_lock(&trace_rb_lock);
+
+	ret = hyp_setup_bpage_backing(desc);
+	if (ret)
+		goto err;
+
+	bpage_backing_start = (struct hyp_buffer_page *)hyp_buffer_pages_backing.start;
+
+	for_each_rb_page_desc(pdesc, cpu, trace_pdesc) {
+		struct hyp_rb_per_cpu *cpu_buffer;
+		int cpu;
+
+		ret = -EINVAL;
+		if (!rb_page_desc_fits_desc(pdesc, desc_hva + desc_size))
+			break;
+
+		cpu = pdesc->cpu;
+		if (cpu >= hyp_nr_cpus)
+			break;
+
+		cpu_buffer = per_cpu_ptr(&trace_rb, cpu);
+
+		ret = hyp_rb_init(pdesc, bpage_backing_start, cpu_buffer);
+		if (ret)
+			break;
+
+		bpage_backing_start += pdesc->nr_page_va;
+	}
+
+err:
+	if (ret)
+		__pkvm_teardown_tracing_locked();
+
+	hyp_spin_unlock(&trace_rb_lock);
+
+	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn((void *)desc),
+				       desc_size >> PAGE_SHIFT));
+	return ret;
+}
+
+int __pkvm_enable_tracing(bool enable)
+{
+	int cpu, ret = enable ? -EINVAL : 0;
+
+	hyp_spin_lock(&trace_rb_lock);
+	for (cpu = 0; cpu < hyp_nr_cpus; cpu++) {
+		struct hyp_rb_per_cpu *cpu_buffer = per_cpu_ptr(&trace_rb, cpu);
+
+		if (enable) {
+			if (!hyp_rb_enable_writing(cpu_buffer))
+				ret = 0;
+		} else {
+			hyp_rb_disable_writing(cpu_buffer);
+		}
+
+	}
+	hyp_spin_unlock(&trace_rb_lock);
+
+	return ret;
+}
-- 
2.48.1.601.g30ceb7b040-goog

