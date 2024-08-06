Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5A013A26F;
	Tue,  6 Aug 2024 20:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722976746; cv=none; b=RlFeuyvhz+vjeaarEeYYBnABHRxmrJMuBHBJHH+Y+Mj+i7h7EQGuGK1NlfNRZWowVXHbfIxBjqp3NvWQwytbQDDV5IzIfX+XqaeQOBKVzb/1ZefyriY6Xy+VtCudgkyRa3KKYm48T6kDmws7rgGoq7oGnWZJYr8FW88mSti6bds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722976746; c=relaxed/simple;
	bh=ThW0CaTtj7BOfeXbCo8k74HQIJ6QuhhJrYXDg+LIDxY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jul6gmrEHG6TGS/V6VBnbuizJbSGTt7QIRXaMv8QehNmj0uCCjuDfs01SDr+mzobglRtHTJVOeHty8reHWcSbPd2gJ9RKOYet67NodlQdI1Umbkeccu/bPikAN/Ahy4lxsg9XzBPwcRNPj1h+X98PoFbiFS8PhLCmVfDU/wGfCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1917C32786;
	Tue,  6 Aug 2024 20:39:04 +0000 (UTC)
Date: Tue, 6 Aug 2024 16:39:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, maz@kernel.org,
 oliver.upton@linux.dev, kvmarm@lists.linux.dev, will@kernel.org,
 qperret@google.com, kernel-team@android.com
Subject: Re: [RFC PATCH 02/11] ring-buffer: Introducing ring-buffer writer
Message-ID: <20240806163953.5ec6551a@gandalf.local.home>
In-Reply-To: <20240805173234.3542917-3-vdonnefort@google.com>
References: <20240805173234.3542917-1-vdonnefort@google.com>
	<20240805173234.3542917-3-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  5 Aug 2024 18:32:25 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

> +
> +#define for_each_rb_page_desc(__pdesc, __cpu, __trace_pdesc)				\
> +	for (__pdesc = (struct rb_page_desc *)&((__trace_pdesc)->__data[0]), __cpu = 0;	\
> +	     __cpu < (__trace_pdesc)->nr_cpus;						\
> +	     __cpu++, __pdesc = __next_rb_page_desc(__pdesc))
> +
> +static inline
> +struct rb_page_desc *rb_page_desc(struct trace_page_desc *trace_pdesc, int cpu)
> +{
> +	struct rb_page_desc *pdesc;
> +	int i;
> +
> +	if (!trace_pdesc)
> +		return NULL;
> +
> +	for_each_rb_page_desc(pdesc, i, trace_pdesc) {
> +		if (pdesc->cpu == cpu)

Is there a reason for the linear search?

Why not just:

	if (cpu >= trace_pdesc->nr_cpus)
		return NULL;

	len = struct_size(pdesc, page_va, pdesc->nr_page_va);
	pdesc = (void *)&(trace_pdesc->__data[0]);

	return pdesc + len * cpu;

(note I don't think you need to typecast the void pointer).

> +			return pdesc;
> +	}
> +
> +	return NULL;
> +}
> +
> +static inline
> +void *rb_page_desc_page(struct rb_page_desc *pdesc, int page_id)
> +{
> +	return page_id > pdesc->nr_page_va ? NULL : (void *)pdesc->page_va[page_id];
> +}
> +
> +struct ring_buffer_writer {
> +	struct trace_page_desc	*pdesc;
> +	int (*get_reader_page)(int cpu);
> +};
> +
> +int ring_buffer_poll_writer(struct trace_buffer *buffer, int cpu);
> +
> +#define ring_buffer_reader(writer)				\
> +({								\
> +	static struct lock_class_key __key;			\
> +	__ring_buffer_alloc(0, RB_FL_OVERWRITE, &__key, writer);\
> +})
>  #endif /* _LINUX_RING_BUFFER_H */
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index f4f4dda28077..a07c22254cfd 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -495,6 +495,8 @@ struct ring_buffer_per_cpu {
>  	unsigned long			*subbuf_ids;	/* ID to subbuf VA */
>  	struct trace_buffer_meta	*meta_page;
>  
> +	struct ring_buffer_writer	*writer;
> +
>  	/* ring buffer pages to update, > 0 to add, < 0 to remove */
>  	long				nr_pages_to_update;
>  	struct list_head		new_pages; /* new pages to add */
> @@ -517,6 +519,8 @@ struct trace_buffer {
>  
>  	struct ring_buffer_per_cpu	**buffers;
>  
> +	struct ring_buffer_writer	*writer;
> +
>  	struct hlist_node		node;
>  	u64				(*clock)(void);
>  
> @@ -1626,6 +1630,31 @@ rb_allocate_cpu_buffer(struct trace_buffer *buffer, long nr_pages, int cpu)
>  
>  	cpu_buffer->reader_page = bpage;
>  
> +	if (buffer->writer) {
> +		struct rb_page_desc *pdesc = rb_page_desc(buffer->writer->pdesc, cpu);
> +
> +		if (!pdesc)
> +			goto fail_free_reader;
> +
> +		cpu_buffer->writer = buffer->writer;
> +		cpu_buffer->meta_page = (struct trace_buffer_meta *)(void *)pdesc->meta_va;
> +		cpu_buffer->subbuf_ids = pdesc->page_va;
> +		cpu_buffer->nr_pages = pdesc->nr_page_va - 1;
> +		atomic_inc(&cpu_buffer->record_disabled);
> +		atomic_inc(&cpu_buffer->resize_disabled);
> +
> +		bpage->page = rb_page_desc_page(pdesc,
> +						cpu_buffer->meta_page->reader.id);
> +		if (!bpage->page)
> +			goto fail_free_reader;
> +		/*
> +		 * The meta-page can only describe which of the ring-buffer page
> +		 * is the reader. There is no need to init the rest of the
> +		 * ring-buffer.
> +		 */
> +		return cpu_buffer;
> +	}
> +
>  	page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL | __GFP_COMP | __GFP_ZERO,
>  				cpu_buffer->buffer->subbuf_order);
>  	if (!page)
> @@ -1663,6 +1692,10 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
>  
>  	irq_work_sync(&cpu_buffer->irq_work.work);
>  
> +	if (cpu_buffer->writer)
> +		/* the ring_buffer doesn't own the data pages */
> +		cpu_buffer->reader_page->page = NULL;

Note, if statements are to have brackets if it's more than one line. That
even includes comments. So the above should be written either as:

	if (cpu_buffer->writer) {
		/* the ring_buffer doesn't own the data pages */
		cpu_buffer->reader_page->page = NULL;
	}

Or

	/* the ring_buffer doesn't own the data pages */
	if (cpu_buffer->writer)
		cpu_buffer->reader_page->page = NULL;

For the second version, you should probably add more detail:

	/* ring_buffers with writer set do not own the data pages */
	if (cpu_buffer->writer)
		cpu_buffer->reader_page->page = NULL;


> +
>  	free_buffer_page(cpu_buffer->reader_page);
>  
>  	if (head) {
> @@ -1693,7 +1726,8 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
>   * drop data when the tail hits the head.
>   */
>  struct trace_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
> -					struct lock_class_key *key)
> +					struct lock_class_key *key,
> +					struct ring_buffer_writer *writer)
>  {
>  	struct trace_buffer *buffer;
>  	long nr_pages;
> @@ -1721,6 +1755,10 @@ struct trace_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
>  	buffer->flags = flags;
>  	buffer->clock = trace_clock_local;
>  	buffer->reader_lock_key = key;
> +	if (writer) {
> +		buffer->writer = writer;

Should probably add a comment here:

		/* The writer is external and never done by the kernel */

or something like that.

> +		atomic_inc(&buffer->record_disabled);
> +	}
>  

-- Steve

>  	init_irq_work(&buffer->irq_work.work, rb_wake_up_waiters);
>  	init_waitqueue_head(&buffer->irq_work.waiters);
> @@ -4468,8 +4506,54 @@ rb_update_iter_read_stamp(struct ring_buffer_iter *iter,
>  	}
>  }
>  
> +static bool rb_read_writer_meta_page(struct ring_buffer_per_cpu *cpu_buffer)
> +{
> +	local_set(&cpu_buffer->entries, READ_ONCE(cpu_buffer->meta_page->entries));
> +	local_set(&cpu_buffer->overrun, READ_ONCE(cpu_buffer->meta_page->overrun));
> +	local_set(&cpu_buffer->pages_touched, READ_ONCE(meta_pages_touched(cpu_buffer->meta_page)));
> +	local_set(&cpu_buffer->pages_lost, READ_ONCE(meta_pages_lost(cpu_buffer->meta_page)));
> +	/*
> +	 * No need to get the "read" field, it can be tracked here as any
> +	 * reader will have to go through a rign_buffer_per_cpu.
> +	 */
> +
> +	return rb_num_of_entries(cpu_buffer);
> +}
> +
> +static struct buffer_page *
> +__rb_get_reader_page_from_writer(struct ring_buffer_per_cpu *cpu_buffer)
> +{
> +	u32 prev_reader;
> +
> +	if (!rb_read_writer_meta_page(cpu_buffer))
> +		return NULL;
> +
> +	/* More to read on the reader page */
> +	if (cpu_buffer->reader_page->read < rb_page_size(cpu_buffer->reader_page))
> +		return cpu_buffer->reader_page;
> +
> +	prev_reader = cpu_buffer->meta_page->reader.id;
> +
> +	WARN_ON(cpu_buffer->writer->get_reader_page(cpu_buffer->cpu));
> +	/* nr_pages doesn't include the reader page */
> +	if (cpu_buffer->meta_page->reader.id > cpu_buffer->nr_pages) {
> +		WARN_ON(1);
> +		return NULL;
> +	}
> +
> +	cpu_buffer->reader_page->page =
> +		(void *)cpu_buffer->subbuf_ids[cpu_buffer->meta_page->reader.id];
> +	cpu_buffer->reader_page->read = 0;
> +	cpu_buffer->read_stamp = cpu_buffer->reader_page->page->time_stamp;
> +	cpu_buffer->lost_events = cpu_buffer->meta_page->reader.lost_events;
> +
> +	WARN_ON(prev_reader == cpu_buffer->meta_page->reader.id);
> +
> +	return cpu_buffer->reader_page;
> +}
> +
>  static struct buffer_page *
> -rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
> +__rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
>  {
>  	struct buffer_page *reader = NULL;
>  	unsigned long bsize = READ_ONCE(cpu_buffer->buffer->subbuf_size);
> @@ -4636,6 +4720,13 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
>  	return reader;
>  }
>  
> +static struct buffer_page *
> +rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
> +{
> +	return cpu_buffer->writer ? __rb_get_reader_page_from_writer(cpu_buffer) :
> +				    __rb_get_reader_page(cpu_buffer);
> +}
> +
>  static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
>  {
>  	struct ring_buffer_event *event;
> @@ -5040,7 +5131,7 @@ ring_buffer_read_prepare(struct trace_buffer *buffer, int cpu, gfp_t flags)
>  	struct ring_buffer_per_cpu *cpu_buffer;
>  	struct ring_buffer_iter *iter;
>  
> -	if (!cpumask_test_cpu(cpu, buffer->cpumask))
> +	if (!cpumask_test_cpu(cpu, buffer->cpumask) || buffer->writer)
>  		return NULL;
>  
>  	iter = kzalloc(sizeof(*iter), flags);
> @@ -5210,6 +5301,9 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
>  {
>  	struct buffer_page *page;
>  
> +	if (cpu_buffer->writer)
> +		return;
> +
>  	rb_head_page_deactivate(cpu_buffer);
>  
>  	cpu_buffer->head_page
> @@ -5440,6 +5534,49 @@ bool ring_buffer_empty_cpu(struct trace_buffer *buffer, int cpu)
>  }
>  EXPORT_SYMBOL_GPL(ring_buffer_empty_cpu);
>  
> +int ring_buffer_poll_writer(struct trace_buffer *buffer, int cpu)
> +{
> +	struct ring_buffer_per_cpu *cpu_buffer;
> +	unsigned long flags;
> +
> +	if (cpu != RING_BUFFER_ALL_CPUS) {
> +		if (!cpumask_test_cpu(cpu, buffer->cpumask))
> +			return -EINVAL;
> +
> +		cpu_buffer = buffer->buffers[cpu];
> +
> +		raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
> +		if (rb_read_writer_meta_page(cpu_buffer))
> +			rb_wakeups(buffer, cpu_buffer);
> +		raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
> +
> +		return 0;
> +	}
> +
> +	/*
> +	 * Make sure all the ring buffers are up to date before we start reading
> +	 * them.
> +	 */
> +	for_each_buffer_cpu(buffer, cpu) {
> +		cpu_buffer = buffer->buffers[cpu];
> +
> +		raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
> +		rb_read_writer_meta_page(buffer->buffers[cpu]);
> +		raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
> +	}
> +
> +	for_each_buffer_cpu(buffer, cpu) {
> +		cpu_buffer = buffer->buffers[cpu];
> +
> +		raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
> +		if (rb_num_of_entries(cpu_buffer))
> +			rb_wakeups(buffer, buffer->buffers[cpu]);
> +		raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
> +	}
> +
> +	return 0;
> +}
> +
>  #ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
>  /**
>   * ring_buffer_swap_cpu - swap a CPU buffer between two ring buffers
> @@ -5691,6 +5828,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
>  	unsigned int commit;
>  	unsigned int read;
>  	u64 save_timestamp;
> +	bool force_memcpy;
>  	int ret = -1;
>  
>  	if (!cpumask_test_cpu(cpu, buffer->cpumask))
> @@ -5728,6 +5866,8 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
>  	/* Check if any events were dropped */
>  	missed_events = cpu_buffer->lost_events;
>  
> +	force_memcpy = cpu_buffer->mapped || cpu_buffer->writer;
> +
>  	/*
>  	 * If this page has been partially read or
>  	 * if len is not big enough to read the rest of the page or
> @@ -5737,7 +5877,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
>  	 */
>  	if (read || (len < (commit - read)) ||
>  	    cpu_buffer->reader_page == cpu_buffer->commit_page ||
> -	    cpu_buffer->mapped) {
> +	    force_memcpy) {
>  		struct buffer_data_page *rpage = cpu_buffer->reader_page->page;
>  		unsigned int rpos = read;
>  		unsigned int pos = 0;
> @@ -6290,7 +6430,7 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
>  	unsigned long flags, *subbuf_ids;
>  	int err = 0;
>  
> -	if (!cpumask_test_cpu(cpu, buffer->cpumask))
> +	if (!cpumask_test_cpu(cpu, buffer->cpumask) || buffer->writer)
>  		return -EINVAL;
>  
>  	cpu_buffer = buffer->buffers[cpu];

