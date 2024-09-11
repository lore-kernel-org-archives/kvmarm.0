Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337AE17B51B
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 09:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726047052; cv=none; b=oeoY/ftH4KMUFh3J4OCuWJkeKlBHFVKeQxewsKjz2jPxAkDxU7bF05OKaHJE3Sl8wVH33Iri/yyZYZ5uLtU20Yr9z79ooih9EX1q7ecCbQpYm84uEfVtZoN+CnJ0j3+Lyh4ecpIl3VghGKM96yfyKddux6uAABe3sEdcIudHXdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726047052; c=relaxed/simple;
	bh=rdESoqDkV6dvzVoBnAnk5bpIBGdwqcBkBRK9Adlytzg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o+wqwrBYccHj3gzwAPrQ4j56sRSaBd5QcU4T2hnSkeEOsgw0g9UsRg9o7KdXW/KB1OQAgv4Xrb7MT4AdsMrqbtG3EExS0znftHHsWePjALfmy4L/iAR+6AMb2K82j5Jc37feOyL0YBodEN7uBa44uQcumF7s17zp3MVBfs4vEhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YxgfNF3s; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YxgfNF3s"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6db791c41daso92581877b3.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 02:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726047049; x=1726651849; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bX7fRzDpnNd4zeQVzomecGzzlbCGx2yH+IA4Wh3YhHI=;
        b=YxgfNF3s5VOerdGcndyedJa6DZe+ADY66h9HpmNoD+62RXOsgFx3D7wvljLRc3K8NI
         rPmejvVPREl4S8e1CNjqDz9LKv/7Ct6DUSFJvCnxHXWjiqShc27zhbUuimjJwG7fZSOq
         7BhvXIDgUBT+wjXJ95GuC5XAU7BXURVylRPvwBIMFYK3ImeUBCPab2tb1as0dSP4rRSm
         459Y9ryXna9G6+LgYzZkzR2D9i7Utcs6Cm0O/OWFVRtc0czPXE+pszW2Nfm3XifSj8m5
         dvg0lpK12uliPjy0mRXAMohv9+vjYyqRzCEhI7XQu9wcTrTYfeYtpQ9vzi7pEZeHRKEz
         rzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726047049; x=1726651849;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bX7fRzDpnNd4zeQVzomecGzzlbCGx2yH+IA4Wh3YhHI=;
        b=i8g0krO+wj/p/Qsdnk5Z8kI3kY53rDsftMB3yubwvrSRUgXa+JVXQp+bbbMDrJ5a5R
         fVMowF7q2hEUjP568i7JmnkOlsWrPj6mGB/ubaDvi09x7H8yr8lbBJRzi2pL14QqcH5e
         Y6vrDewYTbnG6hDscL7nj5r3bGgaamMU3B1fZJcJjnDMLC5z8c1H9/WbNZpgiAH3Z743
         bJl+HdKoaxbDFJDK4ujk6M2rpW0B7Ih20pSTKyy8JQJND1RZ/mwFsCYTa9Nfn/OMmnpu
         7iWvAwr3+VsAOMdKiMCFghdq2xf4VynKXdMdSSdQR7zEyb7mQGa4FXSygGxkzZnbCD0t
         5ZGQ==
X-Gm-Message-State: AOJu0YxyGpl5Ccgxlwq+q9l6QNfoZNZKR3qD28+HFDjcSoe+P41PoZ19
	qTGd0HvBy67jmBRfhG8ZyTjWCTxB83cd82DscAcH1iiBP0E9PY9C81WiugYQxUyXV1hwfPiBCAy
	zvpM7eqjTcDDs46PdKA==
X-Google-Smtp-Source: AGHT+IHr95mENntI+XL7TLPinDZ+fi2cz1xAO3aClhDUfpqjW1lhYGfcAWmsh0sAFKdZEZ2hNYgSoyjFvy43lESc
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a05:690c:38c:b0:6af:623c:7694 with SMTP
 id 00721157ae682-6db44a5d200mr11834517b3.0.1726047049319; Wed, 11 Sep 2024
 02:30:49 -0700 (PDT)
Date: Wed, 11 Sep 2024 10:30:18 +0100
In-Reply-To: <20240911093029.3279154-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911093029.3279154-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911093029.3279154-3-vdonnefort@google.com>
Subject: [PATCH 02/13] ring-buffer: Introducing ring-buffer writer
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
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
index fd35d4ec12e1..d78a33b3c96e 100644
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
@@ -228,4 +231,54 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
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
+static inline
+struct rb_page_desc *__first_rb_page_desc(struct trace_page_desc *trace_pdesc)
+{
+	return (struct rb_page_desc *)(&trace_pdesc->__data[0]);
+}
+
+#define for_each_rb_page_desc(__pdesc, __cpu, __trace_pdesc)		\
+	for (__pdesc = __first_rb_page_desc(__trace_pdesc), __cpu = 0;	\
+	     __cpu < (__trace_pdesc)->nr_cpus;				\
+	     __cpu++, __pdesc = __next_rb_page_desc(__pdesc))
+
+struct ring_buffer_writer {
+	struct trace_page_desc	*pdesc;
+	int			(*get_reader_page)(int cpu);
+	int			(*reset)(int cpu);
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
index 7abe671effbf..b05b7a95e3f1 100644
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
 
@@ -1555,6 +1559,42 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	return -ENOMEM;
 }
 
+static struct rb_page_desc *rb_page_desc(struct trace_page_desc *trace_pdesc,
+					 int cpu)
+{
+	struct rb_page_desc *pdesc;
+	size_t len;
+	int i;
+
+	if (!trace_pdesc)
+		return NULL;
+
+	if (cpu >= trace_pdesc->nr_cpus)
+		return NULL;
+
+	pdesc = __first_rb_page_desc(trace_pdesc);
+	len = struct_size(pdesc, page_va, pdesc->nr_page_va);
+	pdesc += len * cpu;
+
+	if (pdesc->cpu == cpu)
+		return pdesc;
+
+	/* Missing CPUs, need to linear search */
+
+	for_each_rb_page_desc(pdesc, i, trace_pdesc) {
+		if (pdesc->cpu == cpu)
+			return pdesc;
+	}
+
+	return NULL;
+}
+
+static void *rb_page_desc_page(struct rb_page_desc *pdesc, int page_id)
+{
+	return page_id > pdesc->nr_page_va ? NULL : (void *)pdesc->page_va[page_id];
+}
+
+
 static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 			     unsigned long nr_pages)
 {
@@ -1614,6 +1654,31 @@ rb_allocate_cpu_buffer(struct trace_buffer *buffer, long nr_pages, int cpu)
 
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
@@ -1651,6 +1716,10 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
 
 	irq_work_sync(&cpu_buffer->irq_work.work);
 
+	/* ring_buffers with writer set do not own the data pages */
+	if (cpu_buffer->writer)
+		cpu_buffer->reader_page->page = NULL;
+
 	free_buffer_page(cpu_buffer->reader_page);
 
 	if (head) {
@@ -1681,7 +1750,8 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
  * drop data when the tail hits the head.
  */
 struct trace_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
-					struct lock_class_key *key)
+					struct lock_class_key *key,
+					struct ring_buffer_writer *writer)
 {
 	struct trace_buffer *buffer;
 	long nr_pages;
@@ -1709,6 +1779,11 @@ struct trace_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 	buffer->flags = flags;
 	buffer->clock = trace_clock_local;
 	buffer->reader_lock_key = key;
+	if (writer) {
+		buffer->writer = writer;
+		/* The writer is external and never done by the kernel */
+		atomic_inc(&buffer->record_disabled);
+	}
 
 	init_irq_work(&buffer->irq_work.work, rb_wake_up_waiters);
 	init_waitqueue_head(&buffer->irq_work.waiters);
@@ -4456,8 +4531,54 @@ rb_update_iter_read_stamp(struct ring_buffer_iter *iter,
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
 static struct buffer_page *
-rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
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
+static struct buffer_page *
+__rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct buffer_page *reader = NULL;
 	unsigned long bsize = READ_ONCE(cpu_buffer->buffer->subbuf_size);
@@ -4624,6 +4745,13 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
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
@@ -5028,7 +5156,7 @@ ring_buffer_read_prepare(struct trace_buffer *buffer, int cpu, gfp_t flags)
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_iter *iter;
 
-	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask) || buffer->writer)
 		return NULL;
 
 	iter = kzalloc(sizeof(*iter), flags);
@@ -5198,6 +5326,22 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct buffer_page *page;
 
+	if (cpu_buffer->writer) {
+		if (!cpu_buffer->writer->reset)
+			return;
+
+		cpu_buffer->writer->reset(cpu_buffer->cpu);
+		rb_read_writer_meta_page(cpu_buffer);
+
+		/* Read related values, not covered by the meta-page */
+		local_set(&cpu_buffer->pages_read, 0);
+		cpu_buffer->read = 0;
+		cpu_buffer->read_bytes = 0;
+		cpu_buffer->last_overrun = 0;
+
+		return;
+	}
+
 	rb_head_page_deactivate(cpu_buffer);
 
 	cpu_buffer->head_page
@@ -5428,6 +5572,49 @@ bool ring_buffer_empty_cpu(struct trace_buffer *buffer, int cpu)
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
@@ -5679,6 +5866,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	unsigned int commit;
 	unsigned int read;
 	u64 save_timestamp;
+	bool force_memcpy;
 	int ret = -1;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
@@ -5716,6 +5904,8 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	/* Check if any events were dropped */
 	missed_events = cpu_buffer->lost_events;
 
+	force_memcpy = cpu_buffer->mapped || cpu_buffer->writer;
+
 	/*
 	 * If this page has been partially read or
 	 * if len is not big enough to read the rest of the page or
@@ -5725,7 +5915,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	 */
 	if (read || (len < (commit - read)) ||
 	    cpu_buffer->reader_page == cpu_buffer->commit_page ||
-	    cpu_buffer->mapped) {
+	    force_memcpy) {
 		struct buffer_data_page *rpage = cpu_buffer->reader_page->page;
 		unsigned int rpos = read;
 		unsigned int pos = 0;
@@ -6278,7 +6468,7 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 	unsigned long flags, *subbuf_ids;
 	int err = 0;
 
-	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask) || buffer->writer)
 		return -EINVAL;
 
 	cpu_buffer = buffer->buffers[cpu];
-- 
2.46.0.598.g6f2099f65c-goog

