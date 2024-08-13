Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770303A8CE
	for <kvmarm@lists.linux.dev>; Tue, 13 Aug 2024 14:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723558922; cv=none; b=PDtHOSBACibhUPnGOfvK/iWT2YKvjcEjhHZ0HYWusAKk6RPT0iuMdiNcwCx4FrMrnHGPGGTD7Pfs+VXhcXrlW1GUSSbjpJfOd5uIJkoBj8jGgSPR+rr/o7N12p3Iel6NDL5F9EhyhD5py50LSi4NdvNt8Zwn2qCLaY3OPxOAhbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723558922; c=relaxed/simple;
	bh=SEa1BAOEwFjduz9qiUW+EK1ULp95O6BGGl/eg0TIEO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DG5z/JEqUeeiRl+4JY3obGocSLySkWosiuSw2pLoX0AVs9byXmZEVg7IVdvunZAPsMwJiZd8in+R3k6R+H2IcGHNZAhaG5r7glEtIsTdWou6eAl78eVmfq7UmE1BG2tdYVlJSKKwDDR4eHY8dGK4AREhEX8E6Y/1vnbBX3QuxaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fUjYMIUt; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fUjYMIUt"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-36887ca3da2so2739633f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 13 Aug 2024 07:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723558919; x=1724163719; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uJhazaIqBCEFZJ1umrpl7QIxO4QXyxs3C3nE1KqHzL8=;
        b=fUjYMIUtMCJ0JDLk3nzWZIx064sAAb6WWLMnQbd1kov3DUzIyXJL/75I7AH6wlrzF4
         KKEsgn4adrXCjAAR3/E5Nod3jvhXmgGQC6+Xu6g3DFskBqVQu/fPg0PAhzCClU4RVXcb
         zr5dLTxWM8CoyYtDWzuasJ/L/6FS18WWlWOt8V4NskgK6k/nes18FzIkSuonjvZfHdqL
         V0FAZzVx4eJOJVsuJFNgXPdNlTPK9a5cDZ9o8Cu+55x7TeFYqwx3wmP3LEX6L/wjEf9E
         8mCpLxe59v32NBXuKQQq1GlTCV2HFz0akCKmSpLsUBcIay4mxs2rI/UdHz3BiuvsKMnu
         dJnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723558919; x=1724163719;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uJhazaIqBCEFZJ1umrpl7QIxO4QXyxs3C3nE1KqHzL8=;
        b=ZaJHAE336za9/heeJzaV+1oXtFwRLFXxuuctPbOso8FLqq7hy0tkDylu7rbkfMi+Fy
         Yo3a1ixfJ686cBgPq71ZFdBfFThMUYq7UrXRN2WUUbSdKhmiZDODfSGbza9XQ2pVlxk6
         JUfArmCzcOpqmeV/2bZzGCFRMWabulBvIibvcbwNhs0/ntGaQMJVqFtyaZndKNgPMoOS
         DxFYFFFyVCatraCNPQVWY0biHBr3TaduxbvrRRSXzCUQ+pEs53YBzh72GE/1KWzPHgz8
         sDXS69pvfd/JkUC0Soir9XBZaZhK16mlezm7wjp6H/AmTNpR2dmuyfyqcFgsjDmGhXNp
         5jdA==
X-Forwarded-Encrypted: i=1; AJvYcCWfDmua590fWR3TmjDaKjICWNjqU4YpGXmdeFb9Aofu61gAH968CptHCQPMKe3qLNzHATl3lSpNi1EknZ9S70/quVvRq1BY
X-Gm-Message-State: AOJu0YzRPIjMuFYuzkkUfwpDZGJXbFdpwkajOOXz1xsTYru0flPSeyhM
	CGtwxjwtRibEgUJfexEc49G6HFlbUum/InNqxRHJ5cUPSSVib7heHwL4Q2CM6vopEUpjrBESHIM
	Fkw==
X-Google-Smtp-Source: AGHT+IG8+2xve7yGq/AYBb8rdgjsNxTTvms1qY4v/xoTml5Oy0JCovnHWN+VYX6a+wnmVvRBuoVt/Q==
X-Received: by 2002:a05:6000:1843:b0:367:8383:6305 with SMTP id ffacd0b85a97d-3716cd3124emr2517392f8f.55.1723558918364;
        Tue, 13 Aug 2024 07:21:58 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36e4ecc7a52sm10421401f8f.103.2024.08.13.07.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2024 07:21:57 -0700 (PDT)
Date: Tue, 13 Aug 2024 15:21:54 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, will@kernel.org,
	qperret@google.com, kernel-team@android.com
Subject: Re: [RFC PATCH 02/11] ring-buffer: Introducing ring-buffer writer
Message-ID: <ZrtsAl4zpdMFAN4q@google.com>
References: <20240805173234.3542917-1-vdonnefort@google.com>
 <20240805173234.3542917-3-vdonnefort@google.com>
 <20240806163953.5ec6551a@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806163953.5ec6551a@gandalf.local.home>

Sorry I have been preempted before I can answer here:

On Tue, Aug 06, 2024 at 04:39:53PM -0400, Steven Rostedt wrote:
> On Mon,  5 Aug 2024 18:32:25 +0100
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> > +
> > +#define for_each_rb_page_desc(__pdesc, __cpu, __trace_pdesc)				\
> > +	for (__pdesc = (struct rb_page_desc *)&((__trace_pdesc)->__data[0]), __cpu = 0;	\
> > +	     __cpu < (__trace_pdesc)->nr_cpus;						\
> > +	     __cpu++, __pdesc = __next_rb_page_desc(__pdesc))
> > +
> > +static inline
> > +struct rb_page_desc *rb_page_desc(struct trace_page_desc *trace_pdesc, int cpu)
> > +{
> > +	struct rb_page_desc *pdesc;
> > +	int i;
> > +
> > +	if (!trace_pdesc)
> > +		return NULL;
> > +
> > +	for_each_rb_page_desc(pdesc, i, trace_pdesc) {
> > +		if (pdesc->cpu == cpu)
> 
> Is there a reason for the linear search?
> 
> Why not just:
> 
> 	if (cpu >= trace_pdesc->nr_cpus)
> 		return NULL;
> 
> 	len = struct_size(pdesc, page_va, pdesc->nr_page_va);
> 	pdesc = (void *)&(trace_pdesc->__data[0]);
> 
> 	return pdesc + len * cpu;
> 
> (note I don't think you need to typecast the void pointer).

I supposed we can't assume buffers will be allocated for each CPU, hence the
need to look at each buffer.

> 
> > +			return pdesc;
> > +	}
> > +
> > +	return NULL;
> > +}
> > +
> > +static inline
> > +void *rb_page_desc_page(struct rb_page_desc *pdesc, int page_id)
> > +{
> > +	return page_id > pdesc->nr_page_va ? NULL : (void *)pdesc->page_va[page_id];
> > +}
> > +
> > +struct ring_buffer_writer {
> > +	struct trace_page_desc	*pdesc;
> > +	int (*get_reader_page)(int cpu);
> > +};
> > +
> > +int ring_buffer_poll_writer(struct trace_buffer *buffer, int cpu);
> > +
> > +#define ring_buffer_reader(writer)				\
> > +({								\
> > +	static struct lock_class_key __key;			\
> > +	__ring_buffer_alloc(0, RB_FL_OVERWRITE, &__key, writer);\
> > +})
> >  #endif /* _LINUX_RING_BUFFER_H */
> > diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> > index f4f4dda28077..a07c22254cfd 100644
> > --- a/kernel/trace/ring_buffer.c
> > +++ b/kernel/trace/ring_buffer.c
> > @@ -495,6 +495,8 @@ struct ring_buffer_per_cpu {
> >  	unsigned long			*subbuf_ids;	/* ID to subbuf VA */
> >  	struct trace_buffer_meta	*meta_page;
> >  
> > +	struct ring_buffer_writer	*writer;
> > +
> >  	/* ring buffer pages to update, > 0 to add, < 0 to remove */
> >  	long				nr_pages_to_update;
> >  	struct list_head		new_pages; /* new pages to add */
> > @@ -517,6 +519,8 @@ struct trace_buffer {
> >  
> >  	struct ring_buffer_per_cpu	**buffers;
> >  
> > +	struct ring_buffer_writer	*writer;
> > +
> >  	struct hlist_node		node;
> >  	u64				(*clock)(void);
> >  
> > @@ -1626,6 +1630,31 @@ rb_allocate_cpu_buffer(struct trace_buffer *buffer, long nr_pages, int cpu)
> >  
> >  	cpu_buffer->reader_page = bpage;
> >  
> > +	if (buffer->writer) {
> > +		struct rb_page_desc *pdesc = rb_page_desc(buffer->writer->pdesc, cpu);
> > +
> > +		if (!pdesc)
> > +			goto fail_free_reader;
> > +
> > +		cpu_buffer->writer = buffer->writer;
> > +		cpu_buffer->meta_page = (struct trace_buffer_meta *)(void *)pdesc->meta_va;
> > +		cpu_buffer->subbuf_ids = pdesc->page_va;
> > +		cpu_buffer->nr_pages = pdesc->nr_page_va - 1;
> > +		atomic_inc(&cpu_buffer->record_disabled);
> > +		atomic_inc(&cpu_buffer->resize_disabled);
> > +
> > +		bpage->page = rb_page_desc_page(pdesc,
> > +						cpu_buffer->meta_page->reader.id);
> > +		if (!bpage->page)
> > +			goto fail_free_reader;
> > +		/*
> > +		 * The meta-page can only describe which of the ring-buffer page
> > +		 * is the reader. There is no need to init the rest of the
> > +		 * ring-buffer.
> > +		 */
> > +		return cpu_buffer;
> > +	}
> > +
> >  	page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL | __GFP_COMP | __GFP_ZERO,
> >  				cpu_buffer->buffer->subbuf_order);
> >  	if (!page)
> > @@ -1663,6 +1692,10 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
> >  
> >  	irq_work_sync(&cpu_buffer->irq_work.work);
> >  
> > +	if (cpu_buffer->writer)
> > +		/* the ring_buffer doesn't own the data pages */
> > +		cpu_buffer->reader_page->page = NULL;
> 
> Note, if statements are to have brackets if it's more than one line. That
> even includes comments. So the above should be written either as:
> 
> 	if (cpu_buffer->writer) {
> 		/* the ring_buffer doesn't own the data pages */
> 		cpu_buffer->reader_page->page = NULL;
> 	}
> 
> Or
> 
> 	/* the ring_buffer doesn't own the data pages */
> 	if (cpu_buffer->writer)
> 		cpu_buffer->reader_page->page = NULL;
> 
> For the second version, you should probably add more detail:
> 
> 	/* ring_buffers with writer set do not own the data pages */
> 	if (cpu_buffer->writer)
> 		cpu_buffer->reader_page->page = NULL;
> 
> 
> > +
> >  	free_buffer_page(cpu_buffer->reader_page);
> >  
> >  	if (head) {
> > @@ -1693,7 +1726,8 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
> >   * drop data when the tail hits the head.
> >   */
> >  struct trace_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
> > -					struct lock_class_key *key)
> > +					struct lock_class_key *key,
> > +					struct ring_buffer_writer *writer)
> >  {
> >  	struct trace_buffer *buffer;
> >  	long nr_pages;
> > @@ -1721,6 +1755,10 @@ struct trace_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
> >  	buffer->flags = flags;
> >  	buffer->clock = trace_clock_local;
> >  	buffer->reader_lock_key = key;
> > +	if (writer) {
> > +		buffer->writer = writer;
> 
> Should probably add a comment here:
> 
> 		/* The writer is external and never done by the kernel */
> 
> or something like that.
> 
> > +		atomic_inc(&buffer->record_disabled);
> > +	}
> >  
> 
> -- Steve
>
[...]
