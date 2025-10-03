Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5EE224B15
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 13:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498755; cv=none; b=G3QB1Il+r67p3ydVlQGna+rjrgqcE2PzXyGcFa/I1/jMeJ6e3NHp+j44Ll5Yf2EaHTHnKdYHBF28XY5LNsk6H0/hcuJi4TXlgPiLna0dJ5xJ5zNgSKPpRjGA3FR5nodZo9m4RbIgCCGlqo1kLbgp88ii/vdyD9wTdwg0reA/8/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498755; c=relaxed/simple;
	bh=X49FmshLX8HOy0FR+aT3rMqYFXahnrAXs21bSMdcCVI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uH5w85iPt/0So0nAT+Y1q0p2F0r5UpzBO4RvY6JRuJgFS3DRfB08s2qXVwU4GjIkGxdvF9k8Y+lckdDVt9nNAtIXgc0jEoAqvjYBTUGy8mUsAqSDjlTsImMeC+6cOGqUvD2CayDpbxNcc1Q6EHMDisS6W9V9cc7syORo5KtADrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=32vIRuqg; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="32vIRuqg"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3f384f10762so1133155f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 06:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759498749; x=1760103549; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kYaxTGFgJHBLxqvN9L5dqvTFN43LH6gYWiDy8aNjrDk=;
        b=32vIRuqgIGBKInXwobAYlqKgQ9O6VuSEyAbn+eeyD8sGvl8tGn2XsaDbaM1R2/aerY
         upwrm4Q4We0ZjCXdtKZWvhMDvLSuqz5eUg1R9+FxmYihgLfxv37nc4At5Aw5hxFv+17c
         a8t73Nm5xD+TGGilDCyBEeCKY7EhgHGVaVjGtSOy+2uKH9iN2ZGUr/UIWKr3gmOwWl7n
         iuHr83ffv31f5DLjvXLCR3p0nN0FEhfMx4sFf07l9nULaZiO4xD3EG+Sv5Q5AIyYKc66
         G/rLgUxWYlhsM7yesE1KGwChDHBN5QxPJSA8DX2UXwe5MtBB5uyS370XlkbceTqi4pc2
         6WWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759498749; x=1760103549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kYaxTGFgJHBLxqvN9L5dqvTFN43LH6gYWiDy8aNjrDk=;
        b=MC6tNTiEJOlTwZ0Y0B15MNiDAY7jITUoGMbXyS/q4qm8MYkqpkAji0J7yVY6+ya73E
         tYwo8P8uSz/+0O3RkFq9cHFJUUitZtnvHcZAfISjJDhkRhPOw9RPPIRRUqHBO1NyD9Rg
         kUfEPq0D/sxlhfFgwwN5X8YVEWObTKwiFZVtv7g+3go4jA+O2DSj63MwV+ZLtu1lYysy
         7sj7hfjcVDxXsPx39MUybDuLUL0n1cvmOUEjGvncYnXsKLJ7spodWWNum+Yf1RAXBic+
         dIkB1hrAtg1gLeK3pyJp7ZdSemt8k20L3WJYvC8r9juGnsULCcF1zGvmbuE1IITyovAE
         zIWw==
X-Gm-Message-State: AOJu0YzMp3lr0mVzKry1MmML8fRt15Ll/1Zec9BJ9jnkliGfzR2b7W7+
	v4TaWeUelyZp21EOGCeU0SndgeVt89POjSm+qSed9d5i+eqhHyMQTXFkjw9ZR8iOHMXfec/c2EE
	22mnHOv9ukdoco81Bij4bdw==
X-Google-Smtp-Source: AGHT+IEKzB1TeH2GCUCk3DeRZGRRtVVnvZ1dqQmSZ4O8ut99dI6xppsR6ptaX947LdRRickHWtLizPeRbkZDs6ao
X-Received: from wmbjv25.prod.google.com ([2002:a05:600c:5719:b0:46e:2640:aa83])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f84:0:b0:3d9:7021:fff0 with SMTP id ffacd0b85a97d-4256719e3aemr1841373f8f.37.1759498749351;
 Fri, 03 Oct 2025 06:39:09 -0700 (PDT)
Date: Fri,  3 Oct 2025 14:38:10 +0100
In-Reply-To: <20251003133825.2068970-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251003133825.2068970-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003133825.2068970-14-vdonnefort@google.com>
Subject: [PATCH v7 13/28] tracing: Introduce simple_ring_buffer
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a simple implementation of the kernel ring-buffer. This intends to
be used later by ring-buffer remotes such as the pKVM hypervisor, hence
the need for a cut down version (write only) without any dependency.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/simple_ring_buffer.h b/include/linux/simple_ring_buffer.h
new file mode 100644
index 000000000000..f324df2f875b
--- /dev/null
+++ b/include/linux/simple_ring_buffer.h
@@ -0,0 +1,113 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_SIMPLE_RING_BUFFER_H
+#define _LINUX_SIMPLE_RING_BUFFER_H
+
+#include <linux/list.h>
+#include <linux/ring_buffer.h>
+#include <linux/ring_buffer_types.h>
+#include <linux/types.h>
+
+/*
+ * Ideally those struct would stay private but the caller needs to know
+ * the allocation size for simple_ring_buffer_init().
+ */
+struct simple_buffer_page {
+	struct list_head	link;
+	struct buffer_data_page	*page;
+	u64			entries;
+	u32			write;
+	u32			id;
+};
+
+struct simple_rb_per_cpu {
+	struct simple_buffer_page	*tail_page;
+	struct simple_buffer_page	*reader_page;
+	struct simple_buffer_page	*head_page;
+	struct simple_buffer_page	*bpages;
+	struct trace_buffer_meta	*meta;
+	u32				nr_pages;
+
+#define SIMPLE_RB_UNAVAILABLE	0
+#define SIMPLE_RB_READY		1
+#define SIMPLE_RB_WRITING	2
+	u32				status;
+
+	u64				last_overrun;
+	u64				write_stamp;
+
+	struct simple_rb_cbs		*cbs;
+};
+
+/**
+ * simple_ring_buffer_init - Init @cpu_buffer based on @desc
+ *
+ * @cpu_buffer:	A simple_rb_per_cpu buffer to init, allocated by the caller.
+ * @bpages:	Array of simple_buffer_pages, with as many elements as @desc->nr_page_va
+ * @desc:	A ring_buffer_desc
+ *
+ * Returns: 0 on success or -EINVAL if the content of @desc is invalid
+ */
+int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_buffer_page *bpages,
+			    const struct ring_buffer_desc *desc);
+
+/**
+ * simple_ring_buffer_unload - Prepare @cpu_buffer for deletion
+ *
+ * @cpu_buffer:	A simple_rb_per_cpu that will be deleted.
+ */
+void simple_ring_buffer_unload(struct simple_rb_per_cpu *cpu_buffer);
+
+/**
+ * simple_ring_buffer_reserve - Reserve an entry in @cpu_buffer
+ *
+ * @cpu_buffer:	A simple_rb_per_cpu
+ * @length:	Size of the entry in bytes
+ * @timestamp:	Timestamp of the entry
+ *
+ * Returns the address of the entry where to write data or NULL
+ */
+void *simple_ring_buffer_reserve(struct simple_rb_per_cpu *cpu_buffer, unsigned long length,
+				 u64 timestamp);
+
+/**
+ * simple_ring_buffer_commit - Commit the entry reserved with simple_ring_buffer_reserve()
+ *
+ * @cpu_buffer:	The simple_rb_per_cpu where the entry has been reserved
+ */
+void simple_ring_buffer_commit(struct simple_rb_per_cpu *cpu_buffer);
+
+/**
+ * simple_ring_buffer_enable_tracing - Enable or disable writing to @cpu_buffer
+ *
+ * @cpu_buffer: A simple_rb_per_cpu
+ * @enable:	True to enable tracing, False to disable it
+ *
+ * Returns 0 on success or -ENODEV if @cpu_buffer was unloaded
+ */
+int simple_ring_buffer_enable_tracing(struct simple_rb_per_cpu *cpu_buffer, bool enable);
+
+/**
+ * simple_ring_buffer_reset - Reset @cpu_buffer
+ *
+ * @cpu_buffer: A simple_rb_per_cpu
+ *
+ * This will not clear the content of the data, only reset counters and pointers
+ *
+ * Returns 0 on success or -ENODEV if @cpu_buffer was unloaded.
+ */
+int simple_ring_buffer_reset(struct simple_rb_per_cpu *cpu_buffer);
+
+/**
+ * simple_ring_buffer_swap_reader_page - Swap ring-buffer head with the reader
+ *
+ * This function enables consuming reading. It ensures the current head page will not be overwritten
+ * and can be safely read.
+ *
+ * @cpu_buffer: A simple_rb_per_cpu
+ *
+ * Returns 0 on success, -ENODEV if @cpu_buffer was unloaded or -EBUSY if we failed to catch the
+ * head page.
+ */
+int simple_ring_buffer_swap_reader_page(struct simple_rb_per_cpu *cpu_buffer);
+
+#endif
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 99af56d39eaf..918afcc1fcaf 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -1241,4 +1241,7 @@ source "kernel/trace/rv/Kconfig"
 config TRACE_REMOTE
 	bool
 
+config SIMPLE_RING_BUFFER
+	bool
+
 endif # FTRACE
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 6dab341acc46..03d7d80a9436 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -111,4 +111,5 @@ obj-$(CONFIG_TRACEPOINT_BENCHMARK) += trace_benchmark.o
 obj-$(CONFIG_RV) += rv/
 
 obj-$(CONFIG_TRACE_REMOTE) += trace_remote.o
+obj-$(CONFIG_SIMPLE_RING_BUFFER) += simple_ring_buffer.o
 libftrace-y := ftrace.o
diff --git a/kernel/trace/simple_ring_buffer.c b/kernel/trace/simple_ring_buffer.c
new file mode 100644
index 000000000000..20e3cd6071a2
--- /dev/null
+++ b/kernel/trace/simple_ring_buffer.c
@@ -0,0 +1,408 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2025 - Google LLC
+ * Author: Vincent Donnefort <vdonnefort@google.com>
+ */
+
+#include <linux/atomic.h>
+#include <linux/simple_ring_buffer.h>
+
+#include <asm/barrier.h>
+#include <asm/local.h>
+
+enum simple_rb_link_type {
+	SIMPLE_RB_LINK_NORMAL		= 0,
+	SIMPLE_RB_LINK_HEAD		= 1,
+	SIMPLE_RB_LINK_HEAD_MOVING
+};
+
+#define SIMPLE_RB_LINK_MASK ~(SIMPLE_RB_LINK_HEAD | SIMPLE_RB_LINK_HEAD_MOVING)
+
+static void simple_bpage_set_head_link(struct simple_buffer_page *bpage)
+{
+	unsigned long link = (unsigned long)bpage->link.next;
+
+	link &= SIMPLE_RB_LINK_MASK;
+	link |= SIMPLE_RB_LINK_HEAD;
+
+	/*
+	 * Paired with simple_rb_find_head() to order access between the head
+	 * link and overrun. It ensures we always report an up-to-date value
+	 * after swapping the reader page.
+	 */
+	smp_store_release(&bpage->link.next, (struct list_head *)link);
+}
+
+static bool simple_bpage_unset_head_link(struct simple_buffer_page *bpage,
+					 struct simple_buffer_page *dst,
+					 enum simple_rb_link_type new_type)
+{
+	unsigned long *link = (unsigned long *)(&bpage->link.next);
+	unsigned long old = (*link & SIMPLE_RB_LINK_MASK) | SIMPLE_RB_LINK_HEAD;
+	unsigned long new = (unsigned long)(&dst->link) | new_type;
+
+	return try_cmpxchg(link, &old, new);
+}
+
+static void simple_bpage_set_normal_link(struct simple_buffer_page *bpage)
+{
+	unsigned long link = (unsigned long)bpage->link.next;
+
+	WRITE_ONCE(bpage->link.next, (struct list_head *)(link & SIMPLE_RB_LINK_MASK));
+}
+
+static struct simple_buffer_page *simple_bpage_from_link(struct list_head *link)
+{
+	unsigned long ptr = (unsigned long)link & SIMPLE_RB_LINK_MASK;
+
+	return container_of((struct list_head *)ptr, struct simple_buffer_page, link);
+}
+
+static struct simple_buffer_page *simple_bpage_next_page(struct simple_buffer_page *bpage)
+{
+	return simple_bpage_from_link(bpage->link.next);
+}
+
+static void simple_bpage_reset(struct simple_buffer_page *bpage)
+{
+	bpage->write = 0;
+	bpage->entries = 0;
+
+	local_set(&bpage->page->commit, 0);
+}
+
+static void simple_bpage_init(struct simple_buffer_page *bpage, unsigned long page)
+{
+	INIT_LIST_HEAD(&bpage->link);
+	bpage->page = (struct buffer_data_page *)page;
+
+	simple_bpage_reset(bpage);
+}
+
+#define simple_rb_meta_inc(__meta, __inc)		\
+	WRITE_ONCE((__meta), (__meta + __inc))
+
+static bool simple_rb_loaded(struct simple_rb_per_cpu *cpu_buffer)
+{
+	return !!cpu_buffer->bpages;
+}
+
+static int simple_rb_find_head(struct simple_rb_per_cpu *cpu_buffer)
+{
+	int retry = cpu_buffer->nr_pages * 2;
+	struct simple_buffer_page *head;
+
+	head = cpu_buffer->head_page;
+
+	while (retry--) {
+		unsigned long link;
+
+spin:
+		/* See smp_store_release in simple_bpage_set_head_link() */
+		link = (unsigned long)smp_load_acquire(&head->link.prev->next);
+
+		switch (link & ~SIMPLE_RB_LINK_MASK) {
+		/* Found the head */
+		case SIMPLE_RB_LINK_HEAD:
+			cpu_buffer->head_page = head;
+			return 0;
+		/* The writer caught the head, we can spin, that won't be long */
+		case SIMPLE_RB_LINK_HEAD_MOVING:
+			goto spin;
+		}
+
+		head = simple_bpage_next_page(head);
+	}
+
+	return -EBUSY;
+}
+
+int simple_ring_buffer_swap_reader_page(struct simple_rb_per_cpu *cpu_buffer)
+{
+	struct simple_buffer_page *last, *head, *reader;
+	unsigned long overrun;
+	int retry = 8;
+	int ret;
+
+	if (!simple_rb_loaded(cpu_buffer))
+		return -ENODEV;
+
+	reader = cpu_buffer->reader_page;
+
+	do {
+		/* Run after the writer to find the head */
+		ret = simple_rb_find_head(cpu_buffer);
+		if (ret)
+			return ret;
+
+		head = cpu_buffer->head_page;
+
+		/* Connect the reader page around the header page */
+		reader->link.next = head->link.next;
+		reader->link.prev = head->link.prev;
+
+		/* The last page before the head */
+		last = simple_bpage_from_link(head->link.prev);
+
+		/* The reader page points to the new header page */
+		simple_bpage_set_head_link(reader);
+
+		overrun = cpu_buffer->meta->overrun;
+	} while (!simple_bpage_unset_head_link(last, reader, SIMPLE_RB_LINK_NORMAL) && retry--);
+
+	if (!retry)
+		return -EINVAL;
+
+	cpu_buffer->head_page = simple_bpage_from_link(reader->link.next);
+	cpu_buffer->head_page->link.prev = &reader->link;
+	cpu_buffer->reader_page = head;
+	cpu_buffer->meta->reader.lost_events = overrun - cpu_buffer->last_overrun;
+	cpu_buffer->meta->reader.id = cpu_buffer->reader_page->id;
+	cpu_buffer->last_overrun = overrun;
+
+	return 0;
+}
+
+static struct simple_buffer_page *simple_rb_move_tail(struct simple_rb_per_cpu *cpu_buffer)
+{
+	struct simple_buffer_page *tail, *new_tail;
+
+	tail = cpu_buffer->tail_page;
+	new_tail = simple_bpage_next_page(tail);
+
+	if (simple_bpage_unset_head_link(tail, new_tail, SIMPLE_RB_LINK_HEAD_MOVING)) {
+		/*
+		 * Oh no! we've caught the head. There is none anymore and
+		 * swap_reader will spin until we set the new one. Overrun must
+		 * be written first, to make sure we report the correct number
+		 * of lost events.
+		 */
+		simple_rb_meta_inc(cpu_buffer->meta->overrun, new_tail->entries);
+		simple_rb_meta_inc(cpu_buffer->meta->pages_lost, 1);
+
+		simple_bpage_set_head_link(new_tail);
+		simple_bpage_set_normal_link(tail);
+	}
+
+	simple_bpage_reset(new_tail);
+	cpu_buffer->tail_page = new_tail;
+
+	simple_rb_meta_inc(cpu_buffer->meta->pages_touched, 1);
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
+rb_event_add_ts_extend(struct ring_buffer_event *event, u64 delta)
+{
+	event->type_len = RINGBUF_TYPE_TIME_EXTEND;
+	event->time_delta = delta & TS_MASK;
+	event->array[0] = delta >> TS_SHIFT;
+
+	return (struct ring_buffer_event *)((unsigned long)event + 8);
+}
+
+static struct ring_buffer_event *
+simple_rb_reserve_next(struct simple_rb_per_cpu *cpu_buffer, unsigned long length, u64 timestamp)
+{
+	unsigned long ts_ext_size = 0, event_size = rb_event_size(length);
+	struct simple_buffer_page *tail = cpu_buffer->tail_page;
+	struct ring_buffer_event *event;
+	u32 write, prev_write;
+	u64 time_delta;
+
+	time_delta = timestamp - cpu_buffer->write_stamp;
+
+	if (test_time_stamp(time_delta))
+		ts_ext_size = 8;
+
+	prev_write = tail->write;
+	write = prev_write + event_size + ts_ext_size;
+
+	if (unlikely(write > (PAGE_SIZE - BUF_PAGE_HDR_SIZE)))
+		tail = simple_rb_move_tail(cpu_buffer);
+
+	if (!tail->entries) {
+		tail->page->time_stamp = timestamp;
+		time_delta = 0;
+		ts_ext_size = 0;
+		write = event_size;
+		prev_write = 0;
+	}
+
+	tail->write = write;
+	tail->entries++;
+
+	cpu_buffer->write_stamp = timestamp;
+
+	event = (struct ring_buffer_event *)(tail->page->data + prev_write);
+	if (ts_ext_size) {
+		event = rb_event_add_ts_extend(event, time_delta);
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
+void *simple_ring_buffer_reserve(struct simple_rb_per_cpu *cpu_buffer, unsigned long length,
+				 u64 timestamp)
+{
+	struct ring_buffer_event *rb_event;
+
+	if (cmpxchg(&cpu_buffer->status, SIMPLE_RB_READY, SIMPLE_RB_WRITING) != SIMPLE_RB_READY)
+		return NULL;
+
+	rb_event = simple_rb_reserve_next(cpu_buffer, length, timestamp);
+
+	return &rb_event->array[1];
+}
+
+void simple_ring_buffer_commit(struct simple_rb_per_cpu *cpu_buffer)
+{
+	local_set(&cpu_buffer->tail_page->page->commit,
+		  cpu_buffer->tail_page->write);
+	simple_rb_meta_inc(cpu_buffer->meta->entries, 1);
+
+	/*
+	 * Paired with simple_rb_enable_tracing() to ensure data is
+	 * written to the ring-buffer before teardown.
+	 */
+	smp_store_release(&cpu_buffer->status, SIMPLE_RB_READY);
+}
+
+static u32 simple_rb_enable_tracing(struct simple_rb_per_cpu *cpu_buffer, bool enable)
+{
+	u32 prev_status;
+
+	if (enable)
+		return cmpxchg(&cpu_buffer->status, SIMPLE_RB_UNAVAILABLE, SIMPLE_RB_READY);
+
+	/* Wait for the buffer to be released */
+	do {
+		prev_status = cmpxchg_acquire(&cpu_buffer->status,
+					      SIMPLE_RB_READY,
+					      SIMPLE_RB_UNAVAILABLE);
+	} while (prev_status == SIMPLE_RB_WRITING);
+
+	return prev_status;
+}
+
+int simple_ring_buffer_reset(struct simple_rb_per_cpu *cpu_buffer)
+{
+	struct simple_buffer_page *bpage;
+	u32 prev_status;
+	int ret;
+
+	if (!simple_rb_loaded(cpu_buffer))
+		return -ENODEV;
+
+	prev_status = simple_rb_enable_tracing(cpu_buffer, false);
+
+	ret = simple_rb_find_head(cpu_buffer);
+	if (ret)
+		return ret;
+
+	bpage = cpu_buffer->tail_page = cpu_buffer->head_page;
+	do {
+		simple_bpage_reset(bpage);
+		bpage = simple_bpage_next_page(bpage);
+	} while (bpage != cpu_buffer->head_page);
+
+	simple_bpage_reset(cpu_buffer->reader_page);
+
+	cpu_buffer->last_overrun = 0;
+	cpu_buffer->write_stamp = 0;
+
+	cpu_buffer->meta->reader.read = 0;
+	cpu_buffer->meta->reader.lost_events = 0;
+	cpu_buffer->meta->entries = 0;
+	cpu_buffer->meta->overrun = 0;
+	cpu_buffer->meta->read = 0;
+	cpu_buffer->meta->pages_lost = 0;
+	cpu_buffer->meta->pages_touched = 0;
+
+	if (prev_status == SIMPLE_RB_READY)
+		simple_rb_enable_tracing(cpu_buffer, true);
+
+	return 0;
+}
+
+int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_buffer_page *bpages,
+			    const struct ring_buffer_desc *desc)
+{
+	struct simple_buffer_page *bpage = bpages;
+	int i;
+
+	/* At least 1 reader page and two pages in the ring-buffer */
+	if (desc->nr_page_va < 3)
+		return -EINVAL;
+
+	memset(cpu_buffer, 0, sizeof(*cpu_buffer));
+
+	cpu_buffer->bpages = bpages;
+
+	cpu_buffer->meta = (void *)desc->meta_va;
+	memset(cpu_buffer->meta, 0, sizeof(*cpu_buffer->meta));
+	cpu_buffer->meta->meta_page_size = PAGE_SIZE;
+	cpu_buffer->meta->nr_subbufs = cpu_buffer->nr_pages;
+
+	/* The reader page is not part of the ring initially */
+	simple_bpage_init(bpage, desc->page_va[0]);
+	bpage->id = 0;
+
+	cpu_buffer->nr_pages = 1;
+
+	cpu_buffer->reader_page = bpage;
+	cpu_buffer->tail_page = bpage + 1;
+	cpu_buffer->head_page = bpage + 1;
+
+	for (i = 1; i < desc->nr_page_va; i++) {
+		simple_bpage_init(++bpage, desc->page_va[i]);
+
+		bpage->link.next = &(bpage + 1)->link;
+		bpage->link.prev = &(bpage - 1)->link;
+		bpage->id = i;
+
+		cpu_buffer->nr_pages = i + 1;
+	}
+
+	/* Close the ring */
+	bpage->link.next = &cpu_buffer->tail_page->link;
+	cpu_buffer->tail_page->link.prev = &bpage->link;
+
+	/* The last init'ed page points to the head page */
+	simple_bpage_set_head_link(bpage);
+
+	return 0;
+}
+
+void simple_ring_buffer_unload(struct simple_rb_per_cpu *cpu_buffer)
+{
+	if (!simple_rb_loaded(cpu_buffer))
+		return;
+
+	simple_rb_enable_tracing(cpu_buffer, false);
+
+	cpu_buffer->bpages = NULL;
+}
+
+int simple_ring_buffer_enable_tracing(struct simple_rb_per_cpu *cpu_buffer, bool enable)
+{
+	if (!simple_rb_loaded(cpu_buffer))
+		return -ENODEV;
+
+	simple_rb_enable_tracing(cpu_buffer, enable);
+
+	return 0;
+}
-- 
2.51.0.618.g983fd99d29-goog

