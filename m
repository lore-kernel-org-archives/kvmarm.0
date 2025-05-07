Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF99290D9B;
	Wed,  7 May 2025 23:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661635; cv=none; b=kGin8EjVJCxYuOqCJ5xpdOVAljzhzMCn1vJuezJa9ngFAhlhnahGBGE+z6AgKD0zRZV03XF/jbnAq6JyfAp4PZRhHTRtef6hKW0qbzjbmdb/tE5WX17BpAilBvmvhagOeibZhnJq4mDC48nlJOEOKdYBng6Yrx8a1NjzIJuxXUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661635; c=relaxed/simple;
	bh=TWiEotscO9lL+wgcUTl5jDEFCa3yq2c1ynYpgAl4+pA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aMSTRfJD52oeoqDMApL+fxghgHIHAbTR1hLWAnb92VHWkvyNn+joN1VWNhZAlCN1GYkhnG3DJYLDiMG4WSupklSdHVGvvhpKHeGZXDrYCwdoIiWiMTe4PzvBTa1KezP93ZzQnswKK1VgUudKmIfrzHGhO4gs1ED2ldZ0uYUflNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF2BC4CEEF;
	Wed,  7 May 2025 23:47:11 +0000 (UTC)
Date: Wed, 7 May 2025 19:47:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 01/24] ring-buffer: Introduce ring-buffer remotes
Message-ID: <20250507194722.263a8d1e@gandalf.local.home>
In-Reply-To: <20250506164820.515876-2-vdonnefort@google.com>
References: <20250506164820.515876-1-vdonnefort@google.com>
	<20250506164820.515876-2-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  6 May 2025 17:47:57 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:


> diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
> index 56e27263acf8..c0c7f8a0dcb3 100644
> --- a/include/linux/ring_buffer.h
> +++ b/include/linux/ring_buffer.h
> @@ -248,4 +248,67 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
>  		    struct vm_area_struct *vma);
>  int ring_buffer_unmap(struct trace_buffer *buffer, int cpu);
>  int ring_buffer_map_get_reader(struct trace_buffer *buffer, int cpu);
> +
> +#define meta_pages_lost(__meta) \
> +	((__meta)->Reserved1)
> +#define meta_pages_touched(__meta) \
> +	((__meta)->Reserved2)

Hmm, I wonder if this would be worth adding to the user interface?

> +
> +struct ring_buffer_desc {
> +	int		cpu;
> +	unsigned int	nr_page_va; /* excludes the meta page */
> +	unsigned long	meta_va;
> +	unsigned long	page_va[];

	unsigned long page_val[] __counted_by(nr_page_va);

?

Or is this too hidden by the remote?

> +};
> +
> +struct trace_buffer_desc {
> +	int		nr_cpus;
> +	size_t		struct_len;
> +	char		__data[]; /* list of ring_buffer_desc */
> +};
> +
> +static inline struct ring_buffer_desc *__next_ring_buffer_desc(struct ring_buffer_desc *desc)
> +{
> +	size_t len = struct_size(desc, page_va, desc->nr_page_va);
> +
> +	return (struct ring_buffer_desc *)((void *)desc + len);
> +}
> +
> +static inline struct ring_buffer_desc *__first_ring_buffer_desc(struct trace_buffer_desc *desc)
> +{
> +	return (struct ring_buffer_desc *)(&desc->__data[0]);
> +}
> +
> +static inline size_t trace_buffer_desc_size(size_t buffer_size, unsigned int nr_cpus)
> +{
> +	unsigned int nr_pages = (PAGE_ALIGN(buffer_size) / PAGE_SIZE) + 1;

Hmm,

	unsigned int nr_pages = (buffer_size + (PAGE_SIZE - 1)) / PAGE_SIZE;

?

Of course buffer_size of zero is zero here. But is buffer_size of zero what we want?

> +	struct ring_buffer_desc *rbdesc;
> +
> +	return size_add(offsetof(struct trace_buffer_desc, __data),
> +			size_mul(nr_cpus, struct_size(rbdesc, page_va, nr_pages)));
> +}
> +
> +#define for_each_ring_buffer_desc(__pdesc, __cpu, __trace_pdesc)		\
> +	for (__pdesc = __first_ring_buffer_desc(__trace_pdesc), __cpu = 0;	\
> +	     __cpu < (__trace_pdesc)->nr_cpus;					\
> +	     __cpu++, __pdesc = __next_ring_buffer_desc(__pdesc))

Probably should add parenthesis:

#define for_each_ring_buffer_desc(__pdesc, __cpu, __trace_pdesc)		\
	for (__pdesc = __first_ring_buffer_desc(__trace_pdesc), __cpu = 0;	\
	     (__cpu) < (__trace_pdesc)->nr_cpus;					\
	     (__cpu)++, __pdesc = __next_ring_buffer_desc(__pdesc))

Especially if __cpu is passed in as "*pcpu"

> +
> +struct ring_buffer_remote {
> +	struct trace_buffer_desc	*desc;
> +	int				(*swap_reader_page)(unsigned int cpu, void *priv);
> +	int				(*reset)(unsigned int cpu, void *priv);
> +	void				*priv;
> +};
> +
> +int ring_buffer_poll_remote(struct trace_buffer *buffer, int cpu);
> +
> +struct trace_buffer *
> +__ring_buffer_alloc_remote(struct ring_buffer_remote *remote,
> +			   struct lock_class_key *key);
> +
> +#define ring_buffer_remote(remote)				\
> +({								\
> +	static struct lock_class_key __key;			\
> +	__ring_buffer_alloc_remote(remote, &__key);		\
> +})
>  #endif /* _LINUX_RING_BUFFER_H */
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index c0f877d39a24..a96a0b231fee 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -523,6 +523,8 @@ struct ring_buffer_per_cpu {
>  	struct trace_buffer_meta	*meta_page;
>  	struct ring_buffer_cpu_meta	*ring_meta;
>  
> +	struct ring_buffer_remote	*remote;
> +
>  	/* ring buffer pages to update, > 0 to add, < 0 to remove */
>  	long				nr_pages_to_update;
>  	struct list_head		new_pages; /* new pages to add */
> @@ -545,6 +547,8 @@ struct trace_buffer {
>  
>  	struct ring_buffer_per_cpu	**buffers;
>  
> +	struct ring_buffer_remote	*remote;
> +
>  	struct hlist_node		node;
>  	u64				(*clock)(void);
>  
> @@ -2196,6 +2200,41 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
>  	return -ENOMEM;
>  }
>  
> +static struct ring_buffer_desc *ring_buffer_desc(struct trace_buffer_desc *trace_desc, int cpu)
> +{
> +	struct ring_buffer_desc *desc, *end;
> +	size_t len;
> +	int i;
> +
> +	if (!trace_desc)
> +		return NULL;
> +
> +	if (cpu >= trace_desc->nr_cpus)
> +		return NULL;
> +
> +	end = (struct ring_buffer_desc *)((void *)trace_desc + trace_desc->struct_len);
> +	desc = __first_ring_buffer_desc(trace_desc);
> +	len = struct_size(desc, page_va, desc->nr_page_va);
> +	desc = (struct ring_buffer_desc *)((void *)desc + (len * cpu));
> +
> +	if (desc < end && desc->cpu == cpu)
> +		return desc;
> +
> +	/* Missing CPUs, need to linear search */
> +	for_each_ring_buffer_desc(desc, i, trace_desc) {
> +		if (desc->cpu == cpu)
> +			return desc;
> +	}
> +
> +	return NULL;
> +}
> +
> +static void *ring_buffer_desc_page(struct ring_buffer_desc *desc, int page_id)
> +{
> +	return page_id > desc->nr_page_va ? NULL : (void *)desc->page_va[page_id];
> +}
> +
> +
>  static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
>  			     unsigned long nr_pages)
>  {
> @@ -2256,6 +2295,30 @@ rb_allocate_cpu_buffer(struct trace_buffer *buffer, long nr_pages, int cpu)
>  
>  	cpu_buffer->reader_page = bpage;
>  
> +	if (buffer->remote) {
> +		struct ring_buffer_desc *desc = ring_buffer_desc(buffer->remote->desc, cpu);
> +
> +		if (!desc)
> +			goto fail_free_reader;
> +
> +		cpu_buffer->remote = buffer->remote;
> +		cpu_buffer->meta_page = (struct trace_buffer_meta *)(void *)desc->meta_va;
> +		cpu_buffer->subbuf_ids = desc->page_va;
> +		cpu_buffer->nr_pages = desc->nr_page_va - 1;

Probably should add a comment here:

		/* Remote buffers are read only and immutable */

> +		atomic_inc(&cpu_buffer->record_disabled);
> +		atomic_inc(&cpu_buffer->resize_disabled);
> +
> +		bpage->page = ring_buffer_desc_page(desc, cpu_buffer->meta_page->reader.id);
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
>  	if (buffer->range_addr_start) {
>  		/*
>  		 * Range mapped buffers have the same restrictions as memory
> @@ -2333,6 +2396,10 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
>  
>  	irq_work_sync(&cpu_buffer->irq_work.work);
>  
> +	/* remote ring-buffer. We do not own the data pages */
> +	if (cpu_buffer->remote)
> +		cpu_buffer->reader_page->page = NULL;
> +
>  	free_buffer_page(cpu_buffer->reader_page);
>  
>  	if (head) {
> @@ -2355,7 +2422,8 @@ static struct trace_buffer *alloc_buffer(unsigned long size, unsigned flags,
>  					 int order, unsigned long start,
>  					 unsigned long end,
>  					 unsigned long scratch_size,
> -					 struct lock_class_key *key)
> +					 struct lock_class_key *key,
> +					 struct ring_buffer_remote *remote)
>  {
>  	struct trace_buffer *buffer;
>  	long nr_pages;
> @@ -2383,6 +2451,11 @@ static struct trace_buffer *alloc_buffer(unsigned long size, unsigned flags,
>  	buffer->flags = flags;
>  	buffer->clock = trace_clock_local;
>  	buffer->reader_lock_key = key;
> +	if (remote) {
> +		buffer->remote = remote;
> +		/* The writer is remote. This ring-buffer is read-only */
> +		atomic_inc(&buffer->record_disabled);
> +	}
>  
>  	init_irq_work(&buffer->irq_work.work, rb_wake_up_waiters);
>  	init_waitqueue_head(&buffer->irq_work.waiters);
> @@ -2502,7 +2575,7 @@ struct trace_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
>  					struct lock_class_key *key)
>  {
>  	/* Default buffer page size - one system page */
> -	return alloc_buffer(size, flags, 0, 0, 0, 0, key);
> +	return alloc_buffer(size, flags, 0, 0, 0, 0, key, NULL);
>  
>  }
>  EXPORT_SYMBOL_GPL(__ring_buffer_alloc);
> @@ -2529,7 +2602,18 @@ struct trace_buffer *__ring_buffer_alloc_range(unsigned long size, unsigned flag
>  					       struct lock_class_key *key)
>  {
>  	return alloc_buffer(size, flags, order, start, start + range_size,
> -			    scratch_size, key);
> +			    scratch_size, key, NULL);
> +}
> +
> +/**
> + * __ring_buffer_alloc_remote - allocate a new ring_buffer from a remote
> + * @remote: Contains a description of the ring-buffer pages and remote callbacks.
> + * @key: ring buffer reader_lock_key.
> + */
> +struct trace_buffer *__ring_buffer_alloc_remote(struct ring_buffer_remote *remote,
> +						struct lock_class_key *key)
> +{
> +	return alloc_buffer(0, 0, 0, 0, 0, 0, key, remote);
>  }
>  
>  void *ring_buffer_meta_scratch(struct trace_buffer *buffer, unsigned int *size)
> @@ -5278,8 +5362,56 @@ rb_update_iter_read_stamp(struct ring_buffer_iter *iter,
>  	}
>  }
>  
> +static bool rb_read_remote_meta_page(struct ring_buffer_per_cpu *cpu_buffer)
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
>  static struct buffer_page *
> -rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
> +__rb_get_reader_page_from_remote(struct ring_buffer_per_cpu *cpu_buffer)
> +{
> +	u32 prev_reader;
> +
> +	if (!rb_read_remote_meta_page(cpu_buffer))
> +		return NULL;
> +
> +	/* More to read on the reader page */
> +	if (cpu_buffer->reader_page->read < rb_page_size(cpu_buffer->reader_page)) {
> +		if (!cpu_buffer->reader_page->read)
> +			cpu_buffer->read_stamp = cpu_buffer->reader_page->page->time_stamp;
> +		return cpu_buffer->reader_page;
> +	}
> +
> +	prev_reader = cpu_buffer->meta_page->reader.id;
> +
> +	WARN_ON(cpu_buffer->remote->swap_reader_page(cpu_buffer->cpu, cpu_buffer->remote->priv));

Please always use WARN_ON_ONCE() we don't need to spam the console when things go wrong.

> +	/* nr_pages doesn't include the reader page */
> +	if (WARN_ON(cpu_buffer->meta_page->reader.id > cpu_buffer->nr_pages))
> +		return NULL;
> +
> +	cpu_buffer->reader_page->page =
> +		(void *)cpu_buffer->subbuf_ids[cpu_buffer->meta_page->reader.id];
> +	cpu_buffer->reader_page->id = cpu_buffer->meta_page->reader.id;
> +	cpu_buffer->reader_page->read = 0;
> +	cpu_buffer->read_stamp = cpu_buffer->reader_page->page->time_stamp;
> +	cpu_buffer->lost_events = cpu_buffer->meta_page->reader.lost_events;
> +
> +	WARN_ON(prev_reader == cpu_buffer->meta_page->reader.id);
> +
> +	return rb_page_size(cpu_buffer->reader_page) ? cpu_buffer->reader_page : NULL;
> +}

-- Steve
