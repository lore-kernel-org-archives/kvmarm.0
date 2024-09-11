Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C8818628F
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 09:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726047065; cv=none; b=SwLGw/A11hM5GsHcS9WGF7B9r1dp9MvgX08x/s/O+Cvi0EOe5aka0LC/IVXs+Ti6vSpf2GwLn1AQTIFBVuUvgIBbN+tS5B4aMqNfa8y1gNpCU4vnN8ZZ/xKQ4LpfUOv7hKaZE02Q0fH+7VKdxU5rJXIEqdriMjrfziAz9G/M+cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726047065; c=relaxed/simple;
	bh=fVrrnqAXINNnmz4l5DTWIioC5ArvYscT0DRv4Dnazu0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VjND69R/vVX9vParyazbcpJ1ba1su8xjAv6LI9kMqYzD3NZxWkFeSllrEkQgN3srzdUNG+BJ1fYQQP4C7meuJb1YSUBaLWiKSnJOn6dun877Wwzkc+7qPfqky0rzChklPIRFWC+CAfXawh0I/j+sWEQ8Eu1HXoncAHEqMS7bOlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OGVVNyak; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OGVVNyak"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6d4426ad833so44858447b3.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 02:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726047061; x=1726651861; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BW6cDyUAZDFLLhBBcBgBD1d1WBUq4v2u9TJ9S5PEGAo=;
        b=OGVVNyakly468wRJSz9Ba+HKDFc2kGDaoRqTIzMFCT2fg9eEn4B0mYQFEQAc6WnY13
         jBMcXweQqgIjKEJBgoDN75HSj5i15Dnd2c516FU5Sgz7yL3OzTf2wK9+NBmVW6aTkKcc
         aKiz6D+FvGCz3Y4yFNOx8N+XfvJvdpabWGsXGLC0WaphlrbZIdTuXkPxliwRXKrtVk5v
         F7uG7B0nmatJoqeAYCgMcJ9+CT3YK3rG43tmZ7ZhrXbslZdCnMXgoPbYE2oGff7JECLA
         x+AjYyQnpUQoYQaU6XvZzP47SEvVkjX7MJuYyFOU4ggrmA59V9RR8GW66OmzmMmd/H6U
         ipnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726047061; x=1726651861;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BW6cDyUAZDFLLhBBcBgBD1d1WBUq4v2u9TJ9S5PEGAo=;
        b=dn5cf7XbSzqAQjayneIRE0qnHuBGy+SLLUyo/ZpxJPpPxHlCDmOg/dC8I1Ylzize5d
         Si2SlbNScwLlOVL+S9xdpUHRe8iXVdjKoI791sXi3xPxWs57UfF5GtZ4kqyVD1PTtVfK
         LSsucz7e5RTTG42WWlv4wY8bK5/M+T/jYeaWxrLP16o73x3S7ih2iNVERkXGHkGZOWI/
         G6RNyaTuyxPD8soM2DH3qctRCkyqrdXCh9PKTS8+updTYXRBc6K+Vg9uZ9fVZFlcIZoP
         aYOaVPf+MIMEzwPS6dQ34iBVp/UiXUMwB5mFBHFEuPporGaHGY5/ZYbaLxHEh+Vsk0pD
         yoFQ==
X-Gm-Message-State: AOJu0Yxcfsu1hJWfnvPwdluUnpv2MZNKnTwFda4SaUXuLjUstSrVYqxu
	mmShdEtcTCl45fQkX15j1cibA5gg/olsrRTXqCSDFuiuTrNSjPPZWyO4mK4BVUY/jBvH7SuMghP
	TDK9/Ftodkn4mgi0cBg==
X-Google-Smtp-Source: AGHT+IGPDUn03DgkkKdYF56UHDvokuhbmUsMW0zoMfLQGSf/Vzy0b/bfrPUfWjum7Fva2mcvgQIVIRFL9OzNKtVB
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a25:e08c:0:b0:e0e:8b26:484e with SMTP
 id 3f1490d57ef6-e1d8c5319c3mr2976276.8.1726047060930; Wed, 11 Sep 2024
 02:31:00 -0700 (PDT)
Date: Wed, 11 Sep 2024 10:30:23 +0100
In-Reply-To: <20240911093029.3279154-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911093029.3279154-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911093029.3279154-8-vdonnefort@google.com>
Subject: [PATCH 07/13] KVM: arm64: Add tracing support for the pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
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
index 2181a11b9d92..d549d7d491c3 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -79,6 +79,10 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
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
index 000000000000..a7c0c73af0e5
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ARM64_KVM_HYP_NVHE_TRACE_H
+#define __ARM64_KVM_HYP_NVHE_TRACE_H
+#include <asm/kvm_hyptrace.h>
+
+/* Internal struct that needs export for hyp-constants.c */
+struct hyp_buffer_page {
+	struct list_head	list;
+	struct buffer_data_page	*page;
+	unsigned long		write;
+	unsigned long		entries;
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
index f43d845f3c4e..1fb3391e122a 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -17,6 +17,7 @@
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 #include <nvhe/pkvm.h>
+#include <nvhe/trace.h>
 #include <nvhe/trap_handler.h>
 
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
@@ -373,6 +374,35 @@ static void handle___pkvm_teardown_vm(struct kvm_cpu_context *host_ctxt)
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
@@ -405,6 +435,10 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_init_vm),
 	HANDLE_FUNC(__pkvm_init_vcpu),
 	HANDLE_FUNC(__pkvm_teardown_vm),
+	HANDLE_FUNC(__pkvm_load_tracing),
+	HANDLE_FUNC(__pkvm_teardown_tracing),
+	HANDLE_FUNC(__pkvm_enable_tracing),
+	HANDLE_FUNC(__pkvm_swap_reader_tracing),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
new file mode 100644
index 000000000000..debb3ee7dd3a
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -0,0 +1,589 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023 Google LLC
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
+#define HYP_RB_PAGE_HEAD		1UL
+#define HYP_RB_PAGE_UPDATE		2UL
+#define HYP_RB_FLAG_MASK		3UL
+
+struct hyp_rb_per_cpu {
+	struct trace_buffer_meta	*meta;
+	struct hyp_buffer_page		*tail_page;
+	struct hyp_buffer_page		*reader_page;
+	struct hyp_buffer_page		*head_page;
+	struct hyp_buffer_page		*bpages;
+	unsigned long			nr_pages;
+	unsigned long			last_overrun;
+	u64				write_stamp;
+	atomic_t			status;
+};
+
+#define HYP_RB_UNAVAILABLE	0
+#define HYP_RB_READY		1
+#define HYP_RB_WRITING		2
+
+static struct hyp_buffer_pages_backing hyp_buffer_pages_backing;
+DEFINE_PER_CPU(struct hyp_rb_per_cpu, trace_rb);
+DEFINE_HYP_SPINLOCK(trace_rb_lock);
+
+static bool rb_set_flag(struct hyp_buffer_page *bpage, int new_flag)
+{
+	unsigned long ret, val = (unsigned long)bpage->list.next;
+
+	ret = cmpxchg((unsigned long *)&bpage->list.next,
+		      val, (val & ~HYP_RB_FLAG_MASK) | new_flag);
+
+	return ret == val;
+}
+
+static struct hyp_buffer_page *rb_hyp_buffer_page(struct list_head *list)
+{
+	unsigned long ptr = (unsigned long)list & ~HYP_RB_FLAG_MASK;
+
+	return container_of((struct list_head *)ptr, struct hyp_buffer_page, list);
+}
+
+static struct hyp_buffer_page *rb_next_page(struct hyp_buffer_page *bpage)
+{
+	return rb_hyp_buffer_page(bpage->list.next);
+}
+
+static bool rb_is_head_page(struct hyp_buffer_page *bpage)
+{
+	return (unsigned long)bpage->list.prev->next & HYP_RB_PAGE_HEAD;
+}
+
+static struct hyp_buffer_page *rb_set_head_page(struct hyp_rb_per_cpu *cpu_buffer)
+{
+	struct hyp_buffer_page *bpage, *prev_head;
+	int cnt = 0;
+
+again:
+	bpage = prev_head = cpu_buffer->head_page;
+	do {
+		if (rb_is_head_page(bpage)) {
+			cpu_buffer->head_page = bpage;
+			return bpage;
+		}
+
+		bpage = rb_next_page(bpage);
+	} while (bpage != prev_head);
+
+	/* We might have race with the writer let's try again */
+	if (++cnt < 3)
+		goto again;
+
+	return NULL;
+}
+
+static int rb_swap_reader_page(struct hyp_rb_per_cpu *cpu_buffer)
+{
+	unsigned long *old_head_link, old_link_val, new_link_val, overrun;
+	struct hyp_buffer_page *head, *reader = cpu_buffer->reader_page;
+
+spin:
+	/* Update the cpu_buffer->header_page according to HYP_RB_PAGE_HEAD */
+	head = rb_set_head_page(cpu_buffer);
+	if (!head)
+		return -ENODEV;
+
+	/* Connect the reader page around the header page */
+	reader->list.next = head->list.next;
+	reader->list.prev = head->list.prev;
+
+	/* The reader page points to the new header page */
+	rb_set_flag(reader, HYP_RB_PAGE_HEAD);
+
+	/*
+	 * Paired with the cmpxchg in rb_move_tail(). Order the read of the head
+	 * page and overrun.
+	 */
+	smp_mb();
+	overrun = READ_ONCE(cpu_buffer->meta->overrun);
+
+	/* Try to swap the prev head link to the reader page */
+	old_head_link = (unsigned long *)&reader->list.prev->next;
+	old_link_val = (*old_head_link & ~HYP_RB_FLAG_MASK) | HYP_RB_PAGE_HEAD;
+	new_link_val = (unsigned long)&reader->list;
+	if (cmpxchg(old_head_link, old_link_val, new_link_val)
+		      != old_link_val)
+		goto spin;
+
+	cpu_buffer->head_page = rb_hyp_buffer_page(reader->list.next);
+	cpu_buffer->head_page->list.prev = &reader->list;
+	cpu_buffer->reader_page = head;
+	cpu_buffer->meta->reader.lost_events = overrun - cpu_buffer->last_overrun;
+	cpu_buffer->meta->reader.id = cpu_buffer->reader_page->id;
+	cpu_buffer->last_overrun = overrun;
+
+	return 0;
+}
+
+static struct hyp_buffer_page *
+rb_move_tail(struct hyp_rb_per_cpu *cpu_buffer)
+{
+	struct hyp_buffer_page *tail_page, *new_tail, *new_head;
+
+	tail_page = cpu_buffer->tail_page;
+	new_tail = rb_next_page(tail_page);
+
+again:
+	/*
+	 * We caught the reader ... Let's try to move the head page.
+	 * The writer can only rely on ->next links to check if this is head.
+	 */
+	if ((unsigned long)tail_page->list.next & HYP_RB_PAGE_HEAD) {
+		/* The reader moved the head in between */
+		if (!rb_set_flag(tail_page, HYP_RB_PAGE_UPDATE))
+			goto again;
+
+		WRITE_ONCE(cpu_buffer->meta->overrun,
+			   cpu_buffer->meta->overrun + new_tail->entries);
+		WRITE_ONCE(meta_pages_lost(cpu_buffer->meta),
+			   meta_pages_lost(cpu_buffer->meta) + 1);
+
+		/* Move the head */
+		rb_set_flag(new_tail, HYP_RB_PAGE_HEAD);
+
+		/* The new head is in place, reset the update flag */
+		rb_set_flag(tail_page, 0);
+
+		new_head = rb_next_page(new_tail);
+	}
+
+	local_set(&new_tail->page->commit, 0);
+
+	new_tail->write = 0;
+	new_tail->entries = 0;
+
+	WRITE_ONCE(meta_pages_touched(cpu_buffer->meta),
+		   meta_pages_touched(cpu_buffer->meta) + 1);
+	cpu_buffer->tail_page = new_tail;
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
+rb_reserve_next(struct hyp_rb_per_cpu *cpu_buffer, unsigned long length)
+{
+	unsigned long ts_ext_size = 0, event_size = rb_event_size(length);
+	struct hyp_buffer_page *tail_page = cpu_buffer->tail_page;
+	struct ring_buffer_event *event;
+	unsigned long write, prev_write;
+	u64 ts, time_delta;
+
+	ts = trace_clock();
+
+	time_delta = ts - cpu_buffer->write_stamp;
+
+	if (test_time_stamp(time_delta))
+		ts_ext_size = 8;
+
+	prev_write = tail_page->write;
+	write = prev_write + event_size + ts_ext_size;
+
+	if (unlikely(write > BUF_PAGE_SIZE))
+		tail_page = rb_move_tail(cpu_buffer);
+
+	if (!tail_page->entries) {
+		tail_page->page->time_stamp = ts;
+		time_delta = 0;
+		ts_ext_size = 0;
+		write = event_size;
+		prev_write = 0;
+	}
+
+	tail_page->write = write;
+	tail_page->entries++;
+
+	cpu_buffer->write_stamp = ts;
+
+	event = (struct ring_buffer_event *)(tail_page->page->data +
+					     prev_write);
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
+	if (atomic_cmpxchg(&cpu_buffer->status, HYP_RB_READY, HYP_RB_WRITING)
+	    == HYP_RB_UNAVAILABLE)
+		return NULL;
+
+	rb_event = rb_reserve_next(cpu_buffer, length);
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
+	WRITE_ONCE(cpu_buffer->meta->entries,
+		   cpu_buffer->meta->entries + 1);
+
+	/* Paired with rb_cpu_disable_writing() */
+	atomic_set_release(&cpu_buffer->status, HYP_RB_READY);
+}
+
+static int rb_page_init(struct hyp_buffer_page *bpage, unsigned long hva)
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
+	local_set(&bpage->page->commit, 0);
+
+	return 0;
+}
+
+static bool rb_cpu_loaded(struct hyp_rb_per_cpu *cpu_buffer)
+{
+	return !!cpu_buffer->bpages;
+}
+
+static void rb_cpu_disable_writing(struct hyp_rb_per_cpu *cpu_buffer)
+{
+	int prev_status;
+
+	/* Wait for the buffer to be released */
+	do {
+		prev_status = atomic_cmpxchg_acquire(&cpu_buffer->status,
+						     HYP_RB_READY,
+						     HYP_RB_UNAVAILABLE);
+	} while (prev_status == HYP_RB_WRITING);
+}
+
+static int rb_cpu_enable_writing(struct hyp_rb_per_cpu *cpu_buffer)
+{
+	if (!rb_cpu_loaded(cpu_buffer))
+		return -ENODEV;
+
+	atomic_cmpxchg(&cpu_buffer->status, HYP_RB_UNAVAILABLE, HYP_RB_READY);
+
+	return 0;
+}
+
+static void rb_cpu_teardown(struct hyp_rb_per_cpu *cpu_buffer)
+{
+	int i;
+
+	if (!rb_cpu_loaded(cpu_buffer))
+		return;
+
+	rb_cpu_disable_writing(cpu_buffer);
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
+static bool rb_cpu_fits_backing(unsigned long nr_pages,
+				struct hyp_buffer_page *start)
+{
+	unsigned long max = hyp_buffer_pages_backing.start +
+			    hyp_buffer_pages_backing.size;
+	struct hyp_buffer_page *end = start + nr_pages;
+
+	return (unsigned long)end <= max;
+}
+
+static bool rb_cpu_fits_desc(struct rb_page_desc *pdesc,
+			     unsigned long desc_end)
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
+static int rb_cpu_init(struct rb_page_desc *pdesc, struct hyp_buffer_page *start,
+		       struct hyp_rb_per_cpu *cpu_buffer)
+{
+	struct hyp_buffer_page *bpage = start;
+	int i, ret;
+
+	/* At least 1 reader page and one head */
+	if (pdesc->nr_page_va < 2)
+		return -EINVAL;
+
+	if (!rb_cpu_fits_backing(pdesc->nr_page_va, start))
+		return -EINVAL;
+
+	if (rb_cpu_loaded(cpu_buffer))
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
+	ret = rb_page_init(bpage, pdesc->page_va[0]);
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
+		ret = rb_page_init(++bpage, pdesc->page_va[i]);
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
+	rb_set_flag(bpage, HYP_RB_PAGE_HEAD);
+
+	cpu_buffer->last_overrun = 0;
+
+	return 0;
+
+err:
+	rb_cpu_teardown(cpu_buffer);
+
+	return ret;
+}
+
+static int rb_setup_bpage_backing(struct hyp_trace_desc *desc)
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
+static void rb_teardown_bpage_backing(void)
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
+	struct hyp_rb_per_cpu *cpu_buffer;
+	int ret = 0;
+
+	if (cpu >= hyp_nr_cpus)
+		return -EINVAL;
+
+	hyp_spin_lock(&trace_rb_lock);
+
+	cpu_buffer = per_cpu_ptr(&trace_rb, cpu);
+	if (!rb_cpu_loaded(cpu_buffer))
+		ret = -ENODEV;
+	else
+		ret = rb_swap_reader_page(cpu_buffer);
+
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
+		rb_cpu_teardown(cpu_buffer);
+	}
+
+	rb_teardown_bpage_backing();
+}
+
+void __pkvm_teardown_tracing(void)
+{
+	hyp_spin_lock(&trace_rb_lock);
+	__pkvm_teardown_tracing_locked();
+	hyp_spin_unlock(&trace_rb_lock);
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
+	ret = rb_setup_bpage_backing(desc);
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
+		if (!rb_cpu_fits_desc(pdesc, desc_hva + desc_size))
+			break;
+
+		cpu = pdesc->cpu;
+		if (cpu >= hyp_nr_cpus)
+			break;
+
+		cpu_buffer = per_cpu_ptr(&trace_rb, cpu);
+
+		ret = rb_cpu_init(pdesc, bpage_backing_start, cpu_buffer);
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
+			if (!rb_cpu_enable_writing(cpu_buffer))
+				ret = 0;
+		} else {
+			rb_cpu_disable_writing(cpu_buffer);
+		}
+
+	}
+	hyp_spin_unlock(&trace_rb_lock);
+
+	return ret;
+}
-- 
2.46.0.598.g6f2099f65c-goog

