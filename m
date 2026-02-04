Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D8823C51D
	for <kvmarm@lists.linux.dev>; Wed,  4 Feb 2026 23:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770249104; cv=none; b=Etw1Mgj5POeFriG/KsOGk8AFkNvXAa0NxOiAqkAnO5nYipcd4eci6Up9g3a4xPlJ1N1QazT9o8/e54WoO3VfNoBcY+b8QL+UyoM38pZBgxsS/ds9WB5FqLvUE1B+fH19mcrWb/SWBxBlVt6k1cyn26quIkVKluCC09G9LANar5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770249104; c=relaxed/simple;
	bh=B4hJzFCD0mYAoxrPXqYvKuYW8/bvforh3a/5GDS51Nc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TRr+SkwLYTRaBIgJfhx9syemQoGgj5eneJjk5+gurV7MMUSVFnvYc9Cb3XBi+b/cHGCl+oFmSgjJlmGmoPYqYJq4+I9gE6z5Uwiq/UEq26Ii0ASUKLqBlrgHc0tlEZvY84+51WN50lten+74WievILEkaPX/u0Q6mslaRZbhlas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4060189282;
	Wed,  4 Feb 2026 23:51:41 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id B707820026;
	Wed,  4 Feb 2026 23:51:37 +0000 (UTC)
Date: Wed, 4 Feb 2026 18:52:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 07/30] tracing: Add non-consuming read to trace
 remotes
Message-ID: <20260204185208.646a6d26@gandalf.local.home>
In-Reply-To: <20260131132848.254084-8-vdonnefort@google.com>
References: <20260131132848.254084-1-vdonnefort@google.com>
	<20260131132848.254084-8-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rc897n4neqrzffmy5bwxequx16k9k68r
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: B707820026
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/Ug8nGe0Gf7FQbvjd8QIxY+vOatIo4YEA=
X-HE-Tag: 1770249097-281872
X-HE-Meta: U2FsdGVkX19QuWmWiD0qoMvcPrCDIa66yNvX3WgJTiFEHjFug71lKkUU96DxhEFh/gnacu8eUy7IDlJY7CNNRoCM7qI+ez05asPVIQPqz5k9RlN2Ixt2EktEDnf6LlCsH6oRTq5euDNMn2yHyaiYhRLp69pP3TGoQ6/CfvAj0AGb+p9P/4Jo1uMCiFlsqrryg+Wl03vRC/TI7Sv4235Gqm5idHjF7raddKarS4mzVrKPIKSLNrxxgYhFFuBwWpGBSt9+L+1IX8979Y9IIvl8dnCM8CjSECz5Suzwbcj3H/906qfOg8c/pWMtkIVBeTXw+R46FK6Tt1xPxoUYkf8Bn0UG/moDv+EZ

On Sat, 31 Jan 2026 13:28:25 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> -static struct trace_remote_iterator *trace_remote_iter(struct trace_remote *remote, int cpu)
> +static void __free_ring_buffer_iter(struct trace_remote_iterator *iter, int cpu)
> +{
> +	if (!iter->rb_iter)
> +		return;

Hmm, can't iter->rb_iter be NULL when iter->rb_iters[] is used?

> +
> +	if (cpu != RING_BUFFER_ALL_CPUS) {
> +		ring_buffer_read_finish(iter->rb_iter);
> +		return;
> +	}
> +
> +	for_each_possible_cpu(cpu) {
> +		if (iter->rb_iters[cpu])
> +			ring_buffer_read_finish(iter->rb_iters[cpu]);
> +	}
> +
> +	kfree(iter->rb_iters);
> +}
> +
> +static int __alloc_ring_buffer_iter(struct trace_remote_iterator *iter, int cpu)
> +{
> +	if (cpu != RING_BUFFER_ALL_CPUS) {
> +		iter->rb_iter = ring_buffer_read_start(iter->remote->trace_buffer, cpu, GFP_KERNEL);
> +
> +		return iter->rb_iter ? 0 : -ENOMEM;
> +	}
> +
> +	iter->rb_iters = kcalloc(nr_cpu_ids, sizeof(*iter->rb_iters), GFP_KERNEL);
> +	if (!iter->rb_iters)
> +		return -ENOMEM;
> +
> +	for_each_possible_cpu(cpu) {
> +		iter->rb_iters[cpu] = ring_buffer_read_start(iter->remote->trace_buffer, cpu,
> +							     GFP_KERNEL);
> +		if (!iter->rb_iters[cpu]) {
> +			__free_ring_buffer_iter(iter, RING_BUFFER_ALL_CPUS);

For instance, we call __free_ring_buffer_iter() here, but I don't see
iter->rb_iter being set.

-- Steve


> +			return -ENOMEM;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static struct trace_remote_iterator
> +*trace_remote_iter(struct trace_remote *remote, int cpu, enum tri_type type)
>  {
>  	struct trace_remote_iterator *iter = NULL;
>  	int ret;
>  
>  	lockdep_assert_held(&remote->lock);
>  
> +	if (type == TRI_NONCONSUMING && !trace_remote_loaded(remote))
> +		return NULL;
>  
>  	ret = trace_remote_get(remote, cpu);
>  	if (ret)
> @@ -279,9 +352,21 @@ static struct trace_remote_iterator *trace_remote_iter(struct trace_remote *remo
>  	if (iter) {
>  		iter->remote = remote;
>  		iter->cpu = cpu;
> +		iter->type = type;
>  		trace_seq_init(&iter->seq);
> -		INIT_DELAYED_WORK(&iter->poll_work, __poll_remote);
> -		schedule_delayed_work(&iter->poll_work, msecs_to_jiffies(remote->poll_ms));
> +
> +		switch (type) {
> +		case TRI_CONSUMING:
> +			INIT_DELAYED_WORK(&iter->poll_work, __poll_remote);
> +			schedule_delayed_work(&iter->poll_work, msecs_to_jiffies(remote->poll_ms));
> +			break;
> +		case TRI_NONCONSUMING:
> +			ret = __alloc_ring_buffer_iter(iter, cpu);
> +			break;
> +		}
> +
> +		if (ret)
> +			goto err;
>  
>  		return iter;
>  	}
> @@ -305,10 +390,100 @@ static void trace_remote_iter_free(struct trace_remote_iterator *iter)
>  
>  	lockdep_assert_held(&remote->lock);
>  
> +	switch (iter->type) {
> +	case TRI_CONSUMING:
> +		cancel_delayed_work_sync(&iter->poll_work);
> +		break;
> +	case TRI_NONCONSUMING:
> +		__free_ring_buffer_iter(iter, iter->cpu);
> +		break;
> +	}
> +
>  	kfree(iter);
>  	trace_remote_put(remote);
>  }
>  
> +static void trace_remote_iter_read_start(struct trace_remote_iterator *iter)
> +{
> +	struct trace_remote *remote = iter->remote;
> +	int cpu = iter->cpu;
> +
> +	/* Acquire global reader lock */
> +	if (cpu == RING_BUFFER_ALL_CPUS && iter->type == TRI_CONSUMING)
> +		down_write(&remote->reader_lock);
> +	else
> +		down_read(&remote->reader_lock);
> +
> +	if (cpu == RING_BUFFER_ALL_CPUS)
> +		return;
> +
> +	/*
> +	 * No need for the remote lock here, iter holds a reference on
> +	 * remote->nr_readers
> +	 */
> +
> +	/* Get the per-CPU one */
> +	if (WARN_ON_ONCE(!remote->pcpu_reader_locks))
> +		return;
> +
> +	if (iter->type == TRI_CONSUMING)
> +		down_write(&remote->pcpu_reader_locks[cpu]);
> +	else
> +		down_read(&remote->pcpu_reader_locks[cpu]);
> +}
> +
> +static void trace_remote_iter_read_finished(struct trace_remote_iterator *iter)
> +{
> +	struct trace_remote *remote = iter->remote;
> +	int cpu = iter->cpu;
> +
> +	/* Release per-CPU reader lock */
> +	if (cpu != RING_BUFFER_ALL_CPUS) {
> +		/*
> +		 * No need for the remote lock here, iter holds a reference on
> +		 * remote->nr_readers
> +		 */
> +		if (iter->type == TRI_CONSUMING)
> +			up_write(&remote->pcpu_reader_locks[cpu]);
> +		else
> +			up_read(&remote->pcpu_reader_locks[cpu]);
> +	}
> +
> +	/* Release global reader lock */
> +	if (cpu == RING_BUFFER_ALL_CPUS && iter->type == TRI_CONSUMING)
> +		up_write(&remote->reader_lock);
> +	else
> +		up_read(&remote->reader_lock);
> +}
> +
> +static struct ring_buffer_iter *__get_rb_iter(struct trace_remote_iterator *iter, int cpu)
> +{
> +	return iter->cpu != RING_BUFFER_ALL_CPUS ? iter->rb_iter : iter->rb_iters[cpu];
> +}
> +
> +static struct ring_buffer_event *
> +__peek_event(struct trace_remote_iterator *iter, int cpu, u64 *ts, unsigned long *lost_events)
> +{
> +	struct ring_buffer_event *rb_evt;
> +	struct ring_buffer_iter *rb_iter;
> +
> +	switch (iter->type) {
> +	case TRI_CONSUMING:
> +		return ring_buffer_peek(iter->remote->trace_buffer, cpu, ts, lost_events);
> +	case TRI_NONCONSUMING:
> +		rb_iter = __get_rb_iter(iter, cpu);
> +		rb_evt = ring_buffer_iter_peek(rb_iter, ts);
> +		if (!rb_evt)
> +			return NULL;
> +
> +		*lost_events = ring_buffer_iter_dropped(rb_iter);
> +
> +		return rb_evt;
> +	}
> +
> +	return NULL;
> +}
> +
>  static bool trace_remote_iter_read_event(struct trace_remote_iterator *iter)
>  {
>  	struct trace_buffer *trace_buffer = iter->remote->trace_buffer;
> @@ -318,7 +493,7 @@ static bool trace_remote_iter_read_event(struct trace_remote_iterator *iter)
>  		if (ring_buffer_empty_cpu(trace_buffer, cpu))
>  			return false;
>  
> -		if (!ring_buffer_peek(trace_buffer, cpu, &iter->ts, &iter->lost_events))
> +		if (!__peek_event(iter, cpu, &iter->ts, &iter->lost_events))
>  			return false;
>  
>  		iter->evt_cpu = cpu;
> @@ -333,7 +508,7 @@ static bool trace_remote_iter_read_event(struct trace_remote_iterator *iter)
>  		if (ring_buffer_empty_cpu(trace_buffer, cpu))
>  			continue;
>  
> -		if (!ring_buffer_peek(trace_buffer, cpu, &ts, &lost_events))
> +		if (!__peek_event(iter, cpu, &ts, &lost_events))
>  			continue;
>  
>  		if (ts >= iter->ts)
> @@ -347,6 +522,20 @@ static bool trace_remote_iter_read_event(struct trace_remote_iterator *iter)
>  	return iter->ts != U64_MAX;
>  }
>  
> +static void trace_remote_iter_move(struct trace_remote_iterator *iter)
> +{
> +	struct trace_buffer *trace_buffer = iter->remote->trace_buffer;
> +
> +	switch (iter->type) {
> +	case TRI_CONSUMING:
> +		ring_buffer_consume(trace_buffer, iter->evt_cpu, NULL, NULL);
> +		break;
> +	case TRI_NONCONSUMING:
> +		ring_buffer_iter_advance(__get_rb_iter(iter, iter->evt_cpu));
> +		break;
> +	}
> +}
> +
>  static int trace_remote_iter_print_event(struct trace_remote_iterator *iter)
>  {
>  	unsigned long usecs_rem;
> @@ -369,13 +558,14 @@ static int trace_pipe_open(struct inode *inode, struct file *filp)
>  {
>  	struct trace_remote *remote = inode->i_private;
>  	struct trace_remote_iterator *iter;
> -	int cpu = RING_BUFFER_ALL_CPUS;
> -
> -	if (inode->i_cdev)
> -		cpu = (long)inode->i_cdev - 1;
> +	int cpu = tracing_get_cpu(inode);
>  
>  	guard(mutex)(&remote->lock);
> -	iter = trace_remote_iter(remote, cpu);
> +
> +	iter = trace_remote_iter(remote, cpu, TRI_CONSUMING);
> +	if (IS_ERR(iter))
> +		return PTR_ERR(iter);
> +
>  	filp->private_data = iter;
>  
>  	return IS_ERR(iter) ? PTR_ERR(iter) : 0;
> @@ -410,6 +600,8 @@ static ssize_t trace_pipe_read(struct file *filp, char __user *ubuf, size_t cnt,
>  	if (ret < 0)
>  		return ret;
>  
> +	trace_remote_iter_read_start(iter);
> +
>  	while (trace_remote_iter_read_event(iter)) {
>  		int prev_len = iter->seq.seq.len;
>  
> @@ -418,9 +610,11 @@ static ssize_t trace_pipe_read(struct file *filp, char __user *ubuf, size_t cnt,
>  			break;
>  		}
>  
> -		ring_buffer_consume(trace_buffer, iter->evt_cpu, NULL, NULL);
> +		trace_remote_iter_move(iter);
>  	}
>  
> +	trace_remote_iter_read_finished(iter);
> +
>  	goto copy_to_user;
>  }
>  
> @@ -430,14 +624,123 @@ static const struct file_operations trace_pipe_fops = {
>  	.release	= trace_pipe_release,
>  };
>  
> +static void *trace_next(struct seq_file *m, void *v, loff_t *pos)
> +{
> +	struct trace_remote_iterator *iter = m->private;
> +
> +	++*pos;
> +
> +	if (!iter || !trace_remote_iter_read_event(iter))
> +		return NULL;
> +
> +	trace_remote_iter_move(iter);
> +	iter->pos++;
> +
> +	return iter;
> +}
> +
> +static void *trace_start(struct seq_file *m, loff_t *pos)
> +{
> +	struct trace_remote_iterator *iter = m->private;
> +	loff_t i;
> +

FYI, this is where you take locks for iteration of files.

> +	if (!iter)
> +		return NULL;
> +
> +	if (!*pos) {
> +		iter->pos = -1;
> +		return trace_next(m, NULL, &i);
> +	}
> +
> +	i = iter->pos;
> +	while (i < *pos) {
> +		iter = trace_next(m, NULL, &i);
> +		if (!iter)
> +			return NULL;
> +	}
> +
> +	return iter;
> +}
> +
> +static int trace_show(struct seq_file *m, void *v)
> +{
> +	struct trace_remote_iterator *iter = v;
> +
> +	trace_seq_init(&iter->seq);
> +
> +	if (trace_remote_iter_print_event(iter)) {
> +		seq_printf(m, "[EVENT %d PRINT TOO BIG]\n", iter->evt->id);
> +		return 0;
> +	}
> +
> +	return trace_print_seq(m, &iter->seq);
> +}
> +
> +static void trace_stop(struct seq_file *s, void *v) { }

And stop is where you release the locks.

> +
> +static const struct seq_operations trace_sops = {
> +	.start		= trace_start,
> +	.next		= trace_next,
> +	.show		= trace_show,
> +	.stop		= trace_stop,
> +};
> +
> +static int trace_open(struct inode *inode, struct file *filp)
> +{
> +	struct trace_remote *remote = inode->i_private;
> +	struct trace_remote_iterator *iter = NULL;
> +	int cpu = tracing_get_cpu(inode);
> +	int ret;
> +
> +	if (!(filp->f_mode & FMODE_READ))
> +		return 0;
> +
> +	guard(mutex)(&remote->lock);
> +
> +	iter = trace_remote_iter(remote, cpu, TRI_NONCONSUMING);
> +	if (IS_ERR(iter))
> +		return PTR_ERR(iter);

So if iter is bad we exit out here.

> +
> +	ret = seq_open(filp, &trace_sops);
> +	if (ret) {
> +		trace_remote_iter_free(iter);
> +		return ret;
> +	}
> +
> +	if (iter)

Why test if iter exists here?

> +		trace_remote_iter_read_start(iter);

But still, the above grabs locks in the open, where it can return to user
space while still holding the locks? That's a no-no.

You can use the seq file start and stop for locking.

-- Steve

> +
> +	((struct seq_file *)filp->private_data)->private = (void *)iter;
> +
> +	return 0;
> +}
> +
> +static int trace_release(struct inode *inode, struct file *filp)
> +{
> +	struct trace_remote_iterator *iter;
> +
> +	if (!(filp->f_mode & FMODE_READ))
> +		return 0;
> +
> +	iter = ((struct seq_file *)filp->private_data)->private;
> +	seq_release(inode, filp);
> +
> +	if (!iter)
> +		return 0;
> +
> +	guard(mutex)(&iter->remote->lock);
> +
> +	trace_remote_iter_read_finished(iter);
> +	trace_remote_iter_free(iter);
> +
> +	return 0;
> +}
> +
>  static ssize_t trace_write(struct file *filp, const char __user *ubuf, size_t cnt, loff_t *ppos)
>  {
>  	struct inode *inode = file_inode(filp);
>  	struct trace_remote *remote = inode->i_private;
> -	int cpu = RING_BUFFER_ALL_CPUS;
> -
> -	if (inode->i_cdev)
> -		cpu = (long)inode->i_cdev - 1;
> +	int cpu = tracing_get_cpu(inode);
>  
>  	guard(mutex)(&remote->lock);
>  
> @@ -447,7 +750,11 @@ static ssize_t trace_write(struct file *filp, const char __user *ubuf, size_t cn
>  }
>  
>  static const struct file_operations trace_fops = {
> +	.open		= trace_open,
>  	.write		= trace_write,
> +	.read		= seq_read,
> +	.read_iter	= seq_read_iter,
> +	.release	= trace_release,
>  };
>  
>  static int trace_remote_init_tracefs(const char *name, struct trace_remote *remote)
> @@ -566,6 +873,7 @@ int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs,
>  	remote->trace_buffer_size = 7 << 10;
>  	remote->poll_ms = 100;
>  	mutex_init(&remote->lock);
> +	init_rwsem(&remote->reader_lock);
>  
>  	if (trace_remote_init_tracefs(name, remote)) {
>  		kfree(remote);

