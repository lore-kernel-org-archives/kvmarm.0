Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAFC2E92B4
	for <kvmarm@lists.linux.dev>; Mon,  8 Sep 2025 23:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757373185; cv=none; b=Tv2Kb7U3o3+z8hjxwVAZWaL9t2EOXc6sHLghp0j8qM70sk0IZPuNFQTKWOnclo/IaiJEVOkpKiD+Etn4X2Gnp78zyyonVCMrV501DaHk3q/YfAs6CdVxda0WBzU8bXaU8f5MqfrZIytsdTkQlbTXSyc9mbR0Lpsl+yUueym/89w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757373185; c=relaxed/simple;
	bh=pak7E63ByXmvft2YjYHpDwKjJ8C0PRzTeUjBBGFFwfI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=msqszv+Uc3X5rMtREfhTfDajVp3IW4UNKKIaWH1b54dW/k4tWAZT+gC1hvQ+EcJQLcOc1xQIhQpLHutnZzbkWtSfANL0JP9zk3X+bcETKoT5Ppb6JNSn/qTifTuq0MgklyAIajWYdP+IDpadmgO/UrMQQ5elAMG+Ps+3K40wy8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06F5F13A9C6;
	Mon,  8 Sep 2025 23:13:00 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id 8BFCD20024;
	Mon,  8 Sep 2025 23:12:57 +0000 (UTC)
Date: Mon, 8 Sep 2025 19:13:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 02/24] ring-buffer: Introduce ring-buffer remotes
Message-ID: <20250908191343.70aec65c@gandalf.local.home>
In-Reply-To: <20250821081412.1008261-3-vdonnefort@google.com>
References: <20250821081412.1008261-1-vdonnefort@google.com>
	<20250821081412.1008261-3-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ni7ydp9qrbpt8wgjrstbwwnyqtmr8gbj
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 8BFCD20024
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19spjhfSY8UjKtitQgQ6eGgmVn5ZRZnrII=
X-HE-Tag: 1757373177-398356
X-HE-Meta: U2FsdGVkX1+IYfgT6MRlvk2osIuZXjZrIlcJ4j9/jdqdanGEhbZpZhCkTpcCHolekSvIfER4UCHritpDYKSNxXgeJHqJ4HFNi+KSq85REf37ElikqMQ6enV+we450+7K3/zRwvh3tzoU7hK8b8RkMPcS01+e25BZJtT2vPtAg89pc47YLCh+ATrC5dFyupHwG+ffe8rj9YC5oUtdktmWy+uf6QV05vyZnBq60DRLd762Jv9bKMP0uAX+xN1XtX59B2qr+VZRXRqL3s5QelwxrIDGbc5C5hrUH+iqYvqKWKiSVN3T/L9jqWqw5z4P/aAxnhKoWd14umpKUdFJzHSrdxJxP+WXbLKj

On Thu, 21 Aug 2025 09:13:50 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

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

If this allocates, then it should have "alloc" in its name too. Why isn't this:

#define ring_buffer_alloc_remote(remote)			\

?

> +})
>  #endif /* _LINUX_RING_BUFFER_H */
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 064005c9347e..8044cb23ef88 100644
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
> @@ -2296,6 +2300,40 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
>  	return -ENOMEM;
>  }
> 


> +int ring_buffer_poll_remote(struct trace_buffer *buffer, int cpu)
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

The above can be replaced by:

		guard(raw_spinlock)(&cpu_buffer->reader_lock);

> +		if (rb_read_remote_meta_page(cpu_buffer))
> +			rb_wakeups(buffer, cpu_buffer);
> +		raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);

Then we don't need the unlock.

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

Ditto.

> +		rb_read_remote_meta_page(buffer->buffers[cpu]);
> +		raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
> +	}
> +
> +	for_each_buffer_cpu(buffer, cpu) {
> +		cpu_buffer = buffer->buffers[cpu];
> +
> +		raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);

Ditto.

-- Steve


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
> @@ -6600,6 +6801,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
>  	unsigned int commit;
>  	unsigned int read;
>  	u64 save_timestamp;
> +	bool force_memcpy;
>  
>  	if (!cpumask_test_cpu(cpu, buffer->cpumask))
>  		return -1;
> @@ -6637,6 +6839,8 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
>  	/* Check if any events were dropped */
>  	missed_events = cpu_buffer->lost_events;
>  
> +	force_memcpy = cpu_buffer->mapped || cpu_buffer->remote;
> +
>  	/*
>  	 * If this page has been partially read or
>  	 * if len is not big enough to read the rest of the page or
> @@ -6646,7 +6850,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
>  	 */
>  	if (read || (len < (commit - read)) ||
>  	    cpu_buffer->reader_page == cpu_buffer->commit_page ||
> -	    cpu_buffer->mapped) {
> +	    force_memcpy) {
>  		struct buffer_data_page *rpage = cpu_buffer->reader_page->page;
>  		unsigned int rpos = read;
>  		unsigned int pos = 0;
> @@ -7222,7 +7426,7 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
>  	unsigned long flags, *subbuf_ids;
>  	int err;
>  
> -	if (!cpumask_test_cpu(cpu, buffer->cpumask))
> +	if (!cpumask_test_cpu(cpu, buffer->cpumask) || buffer->remote)
>  		return -EINVAL;
>  
>  	cpu_buffer = buffer->buffers[cpu];

