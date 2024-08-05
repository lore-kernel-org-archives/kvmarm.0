Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B434717C64
	for <kvmarm@lists.linux.dev>; Mon,  5 Aug 2024 17:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722879221; cv=none; b=Fhl1Bu1sp8KeiRIfWeGlPcXvPgfLr3QSq16Hi5do2izXKhF9bTw4YjHllm0UQaDe645EhkqOjklTeiPuwds+mWVl9m9HF9I8IL5Pq3VQ8DeyiIYTzpblP/lWGSA1ASh6ocsq/NLfkUSn6SglAIDfXm+t0zv5c/WjSsFaOJpuKK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722879221; c=relaxed/simple;
	bh=vFaRohAKdJnJjJExKNWsS0FGBuXWExDXobLKckHoEf4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gtj33e3BM67cNnUsM8c8z5K2VRvbwdleiFO3KU38m9pkSsOYeMza4YrdmE1EN5Z0OlA6xZAyJlUhbELu5ZS4Wqo1M3pq+vzZ6BEhgPSvhSvWdKc57FfgwiWqlPGPKYakE3JL4NjgUmws0Uy6hwd7XK8hMsH2i6JP7ZcMmPFWAbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=37xMMoM1; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="37xMMoM1"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-66619cb2d3eso248009807b3.2
        for <kvmarm@lists.linux.dev>; Mon, 05 Aug 2024 10:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722879218; x=1723484018; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7o5GDkwp6gXD7Ag5TKhOOWoiwmWJhXhYp/ySr1MyDZA=;
        b=37xMMoM1fBP9ufKPcbC/e36ltR525Dfh6xB7aDH4TELLwhZpvkrTaCg0YLupBipmvn
         LmeKgL10KsjmVzoN3had1Wv3+qUeY7aojLeu2XMDH3qC0Jg0/9HbwKLTOEqKUMm2Cn+d
         OBDSn7dQlbzsCxA8hYcLfVny1pu11yH4StPJhD+duLhYCuXq7HBp5UFmwBQfc0lHHn6u
         DXZiKQ4XVi4zB4hf6S73Yk7gRVHgGVxRba9CeaPs0gNzsR71Z0Du0iYXCdkWyqiI21T9
         QwfZEVSXad0VOpJgexcxAYmkrtAu3GDdTzTY2wYQxhQDCf+LJAYyl0d3GSShoUohuyTn
         7bPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722879218; x=1723484018;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7o5GDkwp6gXD7Ag5TKhOOWoiwmWJhXhYp/ySr1MyDZA=;
        b=H5X1GGQy12rS1uFtYH2Ct/vwPOPIY8j/QfgeD+X7lDVfhchyo8iXWFC+AbTWljfsHo
         zACW8EYyiVZBl5FCgRfgxqLcbcnjiEpQa6GzomI07Z1FvHzyFJpgvdNWLKkASaD6bWc/
         nxbAXsaeuNPonVzok1p2tSrcj0dSJqv85DiwWgM1unjoA9mcWEip7Rp1g9g5W5TacyPd
         G2F12zSFcQvKKK3UovQqyroUyBDL7QSuO9wkk82mgVVcNKC2SaSrXLhl0eWvm2GvXVps
         BQM+BwmoaB8AW7rFACQwRIvJZs5MAPO7oDn78IwGlY1QqoH/tD5op1AgZGYmSXGBwWhX
         ERvg==
X-Gm-Message-State: AOJu0YxT3e5BHPhCfAXcFyLny0r/0ZBkrhHXg4+OtjECa3YHbQn46Ml9
	gPqDzham6J9m+px+sspWc8XuO/uk5FZb2Hi1cq8OH36zFxRF7279bcdDQ8aEkfLFkYGlPuQ0t4q
	uBY00UNFDB7TvrYt9bQ==
X-Google-Smtp-Source: AGHT+IHPyckGIi4kdKI3k7q4762ttsHfSQVt4wqG8OiU4OXRVhFpspLXuk0vHXfRQh9ujaF5kihWdUVru8J/4fl2
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a05:690c:39d:b0:62f:f535:f41 with SMTP
 id 00721157ae682-68964e43958mr7337627b3.9.1722879217715; Mon, 05 Aug 2024
 10:33:37 -0700 (PDT)
Date: Mon,  5 Aug 2024 18:32:25 +0100
In-Reply-To: <20240805173234.3542917-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240805173234.3542917-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240805173234.3542917-3-vdonnefort@google.com>
Subject: [RFC PATCH 02/11] ring-buffer: Introducing ring-buffer writer
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

A ring-buffer writer is an entity outside of the kernel (most likely a
firmware or a hypervisor) capable of writing events in a ring-buffer
following the same format as the tracefs ring-buffer.

To setup the ring-buffer on the kernel side, a description of the pages
(struct trace_page_desc) is necessary. A callback (get_reader_page) must
also be provided. It is called whenever it is done reading the previous
reader page.

It is expected from the writer to keep the meta-page updated.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 96d2140b471e..d3ea2b40437c 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -83,21 +83,24 @@ u64 ring_buffer_event_time_stamp(struct trace_buffer *buffer,
 void ring_buffer_discard_commit(struct trace_buffer *buffer,
 				struct ring_buffer_event *event);
 
+struct ring_buffer_writer;
+
 /*
  * size is in bytes for each per CPU buffer.
  */
 struct trace_buffer *
-__ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *key);
+__ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *key,
+		    struct ring_buffer_writer *writer);
 
 /*
  * Because the ring buffer is generic, if other users of the ring buffer get
  * traced by ftrace, it can produce lockdep warnings. We need to keep each
  * ring buffer's lock class separate.
  */
-#define ring_buffer_alloc(size, flags)			\
-({							\
-	static struct lock_class_key __key;		\
-	__ring_buffer_alloc((size), (flags), &__key);	\
+#define ring_buffer_alloc(size, flags)				\
+({								\
+	static struct lock_class_key __key;			\
+	__ring_buffer_alloc((size), (flags), &__key, NULL);	\
 })
 
 typedef bool (*ring_buffer_cond_fn)(void *data);
@@ -229,4 +232,70 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 		    struct vm_area_struct *vma);
 int ring_buffer_unmap(struct trace_buffer *buffer, int cpu);
 int ring_buffer_map_get_reader(struct trace_buffer *buffer, int cpu);
+
+#define meta_pages_lost(__meta) \
+	((__meta)->Reserved1)
+#define meta_pages_touched(__meta) \
+	((__meta)->Reserved2)
+
+struct rb_page_desc {
+	int		cpu;
+	int		nr_page_va; /* exclude the meta page */
+	unsigned long	meta_va;
+	unsigned long	page_va[];
+};
+
+struct trace_page_desc {
+	int		nr_cpus;
+	char		__data[]; /* list of rb_page_desc */
+};
+
+static inline
+struct rb_page_desc *__next_rb_page_desc(struct rb_page_desc *pdesc)
+{
+	size_t len = struct_size(pdesc, page_va, pdesc->nr_page_va);
+
+	return (struct rb_page_desc *)((void *)pdesc + len);
+}
+
+#define for_each_rb_page_desc(__pdesc, __cpu, __trace_pdesc)				\
+	for (__pdesc = (struct rb_page_desc *)&((__trace_pdesc)->__data[0]), __cpu = 0;	\
+	     __cpu < (__trace_pdesc)->nr_cpus;						\
+	     __cpu++, __pdesc = __next_rb_page_desc(__pdesc))
+
+static inline
+struct rb_page_desc *rb_page_desc(struct trace_page_desc *trace_pdesc, int cpu)
+{
+	struct rb_page_desc *pdesc;
+	int i;
+
+	if (!trace_pdesc)
+		return NULL;
+
+	for_each_rb_page_desc(pdesc, i, trace_pdesc) {
+		if (pdesc->cpu == cpu)
+			return pdesc;
+	}
+
+	return NULL;
+}
+
+static inline
+void *rb_page_desc_page(struct rb_page_desc *pdesc, int page_id)
+{
+	return page_id > pdesc->nr_page_va ? NULL : (void *)pdesc->page_va[page_id];
+}
+
+struct ring_buffer_writer {
+	struct trace_page_desc	*pdesc;
+	int (*get_reader_page)(int cpu);
+};
+
+int ring_buffer_poll_writer(struct trace_buffer *buffer, int cpu);
+
+#define ring_buffer_reader(writer)				\
+({								\
+	static struct lock_class_key __key;			\
+	__ring_buffer_alloc(0, RB_FL_OVERWRITE, &__key, writer);\
+})
 #endif /* _LINUX_RING_BUFFER_H */
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f4f4dda28077..a07c22254cfd 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -495,6 +495,8 @@ struct ring_buffer_per_cpu {
 	unsigned long			*subbuf_ids;	/* ID to subbuf VA */
 	struct trace_buffer_meta	*meta_page;
 
+	struct ring_buffer_writer	*writer;
+
 	/* ring buffer pages to update, > 0 to add, < 0 to remove */
 	long				nr_pages_to_update;
 	struct list_head		new_pages; /* new pages to add */
@@ -517,6 +519,8 @@ struct trace_buffer {
 
 	struct ring_buffer_per_cpu	**buffers;
 
+	struct ring_buffer_writer	*writer;
+
 	struct hlist_node		node;
 	u64				(*clock)(void);
 
@@ -1626,6 +1630,31 @@ rb_allocate_cpu_buffer(struct trace_buffer *buffer, long nr_pages, int cpu)
 
 	cpu_buffer->reader_page = bpage;
 
+	if (buffer->writer) {
+		struct rb_page_desc *pdesc = rb_page_desc(buffer->writer->pdesc, cpu);
+
+		if (!pdesc)
+			goto fail_free_reader;
+
+		cpu_buffer->writer = buffer->writer;
+		cpu_buffer->meta_page = (struct trace_buffer_meta *)(void *)pdesc->meta_va;
+		cpu_buffer->subbuf_ids = pdesc->page_va;
+		cpu_buffer->nr_pages = pdesc->nr_page_va - 1;
+		atomic_inc(&cpu_buffer->record_disabled);
+		atomic_inc(&cpu_buffer->resize_disabled);
+
+		bpage->page = rb_page_desc_page(pdesc,
+						cpu_buffer->meta_page->reader.id);
+		if (!bpage->page)
+			goto fail_free_reader;
+		/*
+		 * The meta-page can only describe which of the ring-buffer page
+		 * is the reader. There is no need to init the rest of the
+		 * ring-buffer.
+		 */
+		return cpu_buffer;
+	}
+
 	page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL | __GFP_COMP | __GFP_ZERO,
 				cpu_buffer->buffer->subbuf_order);
 	if (!page)
@@ -1663,6 +1692,10 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
 
 	irq_work_sync(&cpu_buffer->irq_work.work);
 
+	if (cpu_buffer->writer)
+		/* the ring_buffer doesn't own the data pages */
+		cpu_buffer->reader_page->page = NULL;
+
 	free_buffer_page(cpu_buffer->reader_page);
 
 	if (head) {
@@ -1693,7 +1726,8 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
  * drop data when the tail hits the head.
  */
 struct trace_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
-					struct lock_class_key *key)
+					struct lock_class_key *key,
+					struct ring_buffer_writer *writer)
 {
 	struct trace_buffer *buffer;
 	long nr_pages;
@@ -1721,6 +1755,10 @@ struct trace_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 	buffer->flags = flags;
 	buffer->clock = trace_clock_local;
 	buffer->reader_lock_key = key;
+	if (writer) {
+		buffer->writer = writer;
+		atomic_inc(&buffer->record_disabled);
+	}
 
 	init_irq_work(&buffer->irq_work.work, rb_wake_up_waiters);
 	init_waitqueue_head(&buffer->irq_work.waiters);
@@ -4468,8 +4506,54 @@ rb_update_iter_read_stamp(struct ring_buffer_iter *iter,
 	}
 }
 
+static bool rb_read_writer_meta_page(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	local_set(&cpu_buffer->entries, READ_ONCE(cpu_buffer->meta_page->entries));
+	local_set(&cpu_buffer->overrun, READ_ONCE(cpu_buffer->meta_page->overrun));
+	local_set(&cpu_buffer->pages_touched, READ_ONCE(meta_pages_touched(cpu_buffer->meta_page)));
+	local_set(&cpu_buffer->pages_lost, READ_ONCE(meta_pages_lost(cpu_buffer->meta_page)));
+	/*
+	 * No need to get the "read" field, it can be tracked here as any
+	 * reader will have to go through a rign_buffer_per_cpu.
+	 */
+
+	return rb_num_of_entries(cpu_buffer);
+}
+
+static struct buffer_page *
+__rb_get_reader_page_from_writer(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	u32 prev_reader;
+
+	if (!rb_read_writer_meta_page(cpu_buffer))
+		return NULL;
+
+	/* More to read on the reader page */
+	if (cpu_buffer->reader_page->read < rb_page_size(cpu_buffer->reader_page))
+		return cpu_buffer->reader_page;
+
+	prev_reader = cpu_buffer->meta_page->reader.id;
+
+	WARN_ON(cpu_buffer->writer->get_reader_page(cpu_buffer->cpu));
+	/* nr_pages doesn't include the reader page */
+	if (cpu_buffer->meta_page->reader.id > cpu_buffer->nr_pages) {
+		WARN_ON(1);
+		return NULL;
+	}
+
+	cpu_buffer->reader_page->page =
+		(void *)cpu_buffer->subbuf_ids[cpu_buffer->meta_page->reader.id];
+	cpu_buffer->reader_page->read = 0;
+	cpu_buffer->read_stamp = cpu_buffer->reader_page->page->time_stamp;
+	cpu_buffer->lost_events = cpu_buffer->meta_page->reader.lost_events;
+
+	WARN_ON(prev_reader == cpu_buffer->meta_page->reader.id);
+
+	return cpu_buffer->reader_page;
+}
+
 static struct buffer_page *
-rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
+__rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct buffer_page *reader = NULL;
 	unsigned long bsize = READ_ONCE(cpu_buffer->buffer->subbuf_size);
@@ -4636,6 +4720,13 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	return reader;
 }
 
+static struct buffer_page *
+rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	return cpu_buffer->writer ? __rb_get_reader_page_from_writer(cpu_buffer) :
+				    __rb_get_reader_page(cpu_buffer);
+}
+
 static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct ring_buffer_event *event;
@@ -5040,7 +5131,7 @@ ring_buffer_read_prepare(struct trace_buffer *buffer, int cpu, gfp_t flags)
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_iter *iter;
 
-	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask) || buffer->writer)
 		return NULL;
 
 	iter = kzalloc(sizeof(*iter), flags);
@@ -5210,6 +5301,9 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct buffer_page *page;
 
+	if (cpu_buffer->writer)
+		return;
+
 	rb_head_page_deactivate(cpu_buffer);
 
 	cpu_buffer->head_page
@@ -5440,6 +5534,49 @@ bool ring_buffer_empty_cpu(struct trace_buffer *buffer, int cpu)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_empty_cpu);
 
+int ring_buffer_poll_writer(struct trace_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long flags;
+
+	if (cpu != RING_BUFFER_ALL_CPUS) {
+		if (!cpumask_test_cpu(cpu, buffer->cpumask))
+			return -EINVAL;
+
+		cpu_buffer = buffer->buffers[cpu];
+
+		raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+		if (rb_read_writer_meta_page(cpu_buffer))
+			rb_wakeups(buffer, cpu_buffer);
+		raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+
+		return 0;
+	}
+
+	/*
+	 * Make sure all the ring buffers are up to date before we start reading
+	 * them.
+	 */
+	for_each_buffer_cpu(buffer, cpu) {
+		cpu_buffer = buffer->buffers[cpu];
+
+		raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+		rb_read_writer_meta_page(buffer->buffers[cpu]);
+		raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	}
+
+	for_each_buffer_cpu(buffer, cpu) {
+		cpu_buffer = buffer->buffers[cpu];
+
+		raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+		if (rb_num_of_entries(cpu_buffer))
+			rb_wakeups(buffer, buffer->buffers[cpu]);
+		raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
 /**
  * ring_buffer_swap_cpu - swap a CPU buffer between two ring buffers
@@ -5691,6 +5828,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	unsigned int commit;
 	unsigned int read;
 	u64 save_timestamp;
+	bool force_memcpy;
 	int ret = -1;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
@@ -5728,6 +5866,8 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	/* Check if any events were dropped */
 	missed_events = cpu_buffer->lost_events;
 
+	force_memcpy = cpu_buffer->mapped || cpu_buffer->writer;
+
 	/*
 	 * If this page has been partially read or
 	 * if len is not big enough to read the rest of the page or
@@ -5737,7 +5877,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	 */
 	if (read || (len < (commit - read)) ||
 	    cpu_buffer->reader_page == cpu_buffer->commit_page ||
-	    cpu_buffer->mapped) {
+	    force_memcpy) {
 		struct buffer_data_page *rpage = cpu_buffer->reader_page->page;
 		unsigned int rpos = read;
 		unsigned int pos = 0;
@@ -6290,7 +6430,7 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 	unsigned long flags, *subbuf_ids;
 	int err = 0;
 
-	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask) || buffer->writer)
 		return -EINVAL;
 
 	cpu_buffer = buffer->buffers[cpu];
-- 
2.46.0.rc2.264.g509ed76dc8-goog

