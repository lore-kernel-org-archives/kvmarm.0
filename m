Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40B024CEEA
	for <kvmarm@lists.linux.dev>; Wed, 28 Jan 2026 22:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769640738; cv=none; b=fem9imRICM0dwNFMzHO99kSbh7pQn7HuV510eM568kBOUj6uyPofsjtmDPHF3DdE0IRq/1qIE+2y4mTO4qxMISHIBKE9HMU6d5ZjH9wKt2CPwImLnbgRasGwZGnyySmVhdlHwHKmcUk3IoUEHRGMVwOB2L0IdSN4E/AhrFWy664=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769640738; c=relaxed/simple;
	bh=LTMm94JQYptlC06MjDtHWq4m7qlbc5vpOjOdoBAGm8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hEMkNjpZwuMr3cGuRgl1wzUIPn6GblM88DfXaMuPvxuL/R4eovGQ8DP+x2ogZXGh0m/MLNlYYqPBFUT06dLkiKEuWvbFfXAokPlHgzJ3yEatcjp1VEoarp9qvp+JNwlWgi7645gjuuqCqHpF5TFGUN063VxIR6nyf84xNxcVPz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 19DEB1AEBC1;
	Wed, 28 Jan 2026 22:52:07 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 65FAA2000F;
	Wed, 28 Jan 2026 22:52:03 +0000 (UTC)
Date: Wed, 28 Jan 2026 17:52:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 07/30] tracing: Add non-consuming read to trace
 remotes
Message-ID: <20260128175212.18d7eaaa@gandalf.local.home>
In-Reply-To: <20260126104419.1649811-8-vdonnefort@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
	<20260126104419.1649811-8-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: weg3f5wdd37c1fihgjwbs9gyppbsc91x
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 65FAA2000F
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+3h80gV0oK3up2OD9SXbhDKEHnfnt/+Rg=
X-HE-Tag: 1769640723-586116
X-HE-Meta: U2FsdGVkX19VCAD+kPZoE3HVKHmjrjR5m4g7V8TtdkY/ZrxcrNi49DUSKJ4MPcjcBlpwp4DsygwvzF2odOGG5MdkEXYpOFohzK4uXy/q5y980MM7EEyKjle7Hknp1dN+Zb2LWAS+8ji2X2uqcs2/LyrmNDUGsfdh6GJc2CiOUXEZKbNFYbRv5L+TWAdktIg0i03cAMbM7vLL7YisfZUtO86n9/Y/ClK8r1OmrqfdFt7T/fM/sPK3UFfxjD2003BmvKhcZJ8Dm17BpUmqOjvqr6dh5ZuhBx+EA9W3ZKj6JNKweDQCKCLPda7Wk9EbhicYhYHQIsZTNUVyObqpA9gBqjQPOGt2oLQN

On Mon, 26 Jan 2026 10:43:56 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> Allow reading the trace file for trace remotes. This performs a
> non-consuming read of the trace buffer.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/kernel/trace/trace_remote.c b/kernel/trace/trace_remote.c
> index 49c4ae127533..a744bbf48e88 100644
> --- a/kernel/trace/trace_remote.c
> +++ b/kernel/trace/trace_remote.c
> @@ -18,14 +18,25 @@
>  #define TRACEFS_MODE_WRITE	0640
>  #define TRACEFS_MODE_READ	0440
>  
> +enum tri_type {
> +	TRI_CONSUMING,
> +	TRI_NONCONSUMING,
> +};
> +
>  struct trace_remote_iterator {
>  	struct trace_remote		*remote;
>  	struct trace_seq		seq;
>  	struct delayed_work		poll_work;
>  	unsigned long			lost_events;
>  	u64				ts;
> +	union {
> +		struct ring_buffer_iter	**rb_iters;
> +		struct ring_buffer_iter *rb_iter;

I don't care for the union, it can be error prone and for what? 8 bytes?
It's not a fast path and the memory is temporary.

Just make two entries, where one is NULL. That way if there's a mistake and
the wrong one is used it will be pretty obvious that it gets a NULL pointer
dereference than some random error.

> +	};
>  	int				cpu;
>  	int				evt_cpu;
> +	loff_t				pos;
> +	enum tri_type			type;
>  };
>  
>  struct trace_remote {
> @@ -36,6 +47,8 @@ struct trace_remote {
>  	unsigned long			trace_buffer_size;
>  	struct ring_buffer_remote	rb_remote;
>  	struct mutex			lock;
> +	struct rw_semaphore		reader_lock;
> +	struct rw_semaphore		*pcpu_reader_locks;
>  	unsigned int			nr_readers;
>  	unsigned int			poll_ms;
>  	bool				tracing_on;
> @@ -225,6 +238,20 @@ static int trace_remote_get(struct trace_remote *remote, int cpu)
>  	if (ret)
>  		return ret;
>  
> +	if (cpu != RING_BUFFER_ALL_CPUS && !remote->pcpu_reader_locks) {
> +		int lock_cpu;
> +
> +		remote->pcpu_reader_locks = kcalloc(nr_cpu_ids, sizeof(*remote->pcpu_reader_locks),
> +						    GFP_KERNEL);
> +		if (!remote->pcpu_reader_locks) {
> +			trace_remote_try_unload(remote);
> +			return -ENOMEM;
> +		}
> +
> +		for_each_possible_cpu(lock_cpu)
> +			init_rwsem(&remote->pcpu_reader_locks[lock_cpu]);
> +	}
> +
>  	remote->nr_readers++;
>  
>  	return 0;
> @@ -239,6 +266,9 @@ static void trace_remote_put(struct trace_remote *remote)
>  	if (remote->nr_readers)
>  		return;
>  
> +	kfree(remote->pcpu_reader_locks);
> +	remote->pcpu_reader_locks = NULL;
> +
>  	trace_remote_try_unload(remote);
>  }
>  
> @@ -253,6 +283,48 @@ static void __poll_remote(struct work_struct *work)
>  			      msecs_to_jiffies(iter->remote->poll_ms));
>  }
>  
> +static int __alloc_ring_buffer_iter(struct trace_remote_iterator *iter, int cpu)
> +{
> +	bool once = false;
> +
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
> +		if (iter->rb_iters[cpu])
> +			once = true;

Do we really want to succeed if only one cpu passes?

> +	}
> +
> +	return once ? 0 : -ENOMEM;
> +}
> +
> +static void __free_ring_buffer_iter(struct trace_remote_iterator *iter, int cpu)
> +{
> +	if (!iter->rb_iter)
> +		return;
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
>  static struct trace_remote_iterator
>  *trace_remote_iter(struct trace_remote *remote, int cpu, enum tri_type type)
>  {
> @@ -261,6 +333,8 @@ static struct trace_remote_iterator
>  
>  	lockdep_assert_held(&remote->lock);
>  
> +	if (type == TRI_NONCONSUMING && !trace_remote_loaded(remote))
> +		return NULL;
>  
>  	ret = trace_remote_get(remote, cpu);
>  	if (ret)
> @@ -275,9 +349,21 @@ static struct trace_remote_iterator
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
> @@ -301,10 +387,100 @@ static void trace_remote_iter_free(struct trace_remote_iterator *iter)
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
> @@ -314,7 +490,7 @@ static bool trace_remote_iter_read_event(struct trace_remote_iterator *iter)
>  		if (ring_buffer_empty_cpu(trace_buffer, cpu))
>  			return false;
>  
> -		if (!ring_buffer_peek(trace_buffer, cpu, &iter->ts, &iter->lost_events))
> +		if (!__peek_event(iter, cpu, &iter->ts, &iter->lost_events))
>  			return false;
>  
>  		iter->evt_cpu = cpu;
> @@ -329,7 +505,7 @@ static bool trace_remote_iter_read_event(struct trace_remote_iterator *iter)
>  		if (ring_buffer_empty_cpu(trace_buffer, cpu))
>  			continue;
>  
> -		if (!ring_buffer_peek(trace_buffer, cpu, &ts, &lost_events))
> +		if (!__peek_event(iter, cpu, &ts, &lost_events))
>  			continue;
>  
>  		if (ts >= iter->ts)
> @@ -343,7 +519,21 @@ static bool trace_remote_iter_read_event(struct trace_remote_iterator *iter)
>  	return iter->ts != U64_MAX;
>  }
>  
> -static int trace_remote_iter_print(struct trace_remote_iterator *iter)
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
> +static int trace_remote_iter_print_event(struct trace_remote_iterator *iter)
>  {
>  	unsigned long usecs_rem;
>  	u64 ts = iter->ts;
> @@ -371,7 +561,11 @@ static int trace_pipe_open(struct inode *inode, struct file *filp)
>  		cpu = (long)inode->i_cdev - 1;
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
> @@ -406,6 +600,8 @@ static ssize_t trace_pipe_read(struct file *filp, char __user *ubuf, size_t cnt,
>  	if (ret < 0)
>  		return ret;
>  
> +	trace_remote_iter_read_start(iter);
> +
>  	while (trace_remote_iter_read_event(iter)) {
>  		int prev_len = iter->seq.seq.len;
>  
> @@ -414,9 +610,11 @@ static ssize_t trace_pipe_read(struct file *filp, char __user *ubuf, size_t cnt,
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
> @@ -426,6 +624,119 @@ static const struct file_operations trace_pipe_fops = {
>  	.release	= trace_pipe_release,
>  };
>  
> +static void *trace_seq_start(struct seq_file *m, loff_t *pos)

Don't call these "trace_seq_*", as it's confusing as functions that start
with "trace_seq_*" are to be used as API for struct trace_seq instances.

They're static functions, call them s_start() or whatever ;-)

> +{
> +	struct trace_remote_iterator *iter = m->private;
> +	loff_t i = *pos;
> +
> +	if (!iter)
> +		return NULL;
> +
> +	if (iter->pos <= *pos) {
> +		do {
> +			if (!trace_remote_iter_read_event(iter))
> +				return NULL;
> +
> +			trace_remote_iter_move(iter);
> +			iter->pos++;
> +		} while (i--);
> +	}
> +
> +	return iter;
> +}
> +
> +static void *trace_seq_next(struct seq_file *m, void *v, loff_t *pos)
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

BTW, I usually use the next function to increment the start function so
there's not duplicate code.

static void *tri_start(struct seq_file *m, loff_t *pos)
{
	struct trace_remote_iterator *iter = m->private;
	loff_t i = *pos;

	if (!iter)
		return NULL;

	if (iter->pos <= *pos) {
		do {
			iter = tri_next(m, v, pos);
			if (!iter)
				return NULL;
		} while (i--);
	}

	return iter;
}



> +
> +static int trace_seq_show(struct seq_file *m, void *v)
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
> +static void trace_seq_stop(struct seq_file *s, void *v) { }
> +
> +static const struct seq_operations trace_seq_ops = {
> +	.start		= trace_seq_start,
> +	.next		= trace_seq_next,
> +	.show		= trace_seq_show,
> +	.stop		= trace_seq_stop,
> +};
> +
> +static int trace_open(struct inode *inode, struct file *filp)
> +{
> +	struct trace_remote *remote = inode->i_private;
> +	struct trace_remote_iterator *iter = NULL;
> +	int cpu = RING_BUFFER_ALL_CPUS;
> +	int ret;
> +
> +	if (!(filp->f_mode & FMODE_READ))
> +		return 0;
> +
> +	if (inode->i_cdev)
> +		cpu = (long)inode->i_cdev - 1;

Hmm, we probably should use the helper function here. That is make
tracing_get_cpu() non-static and use that. When inode->i_cdev is zero it
returns RING_BUFFER_ALL_CPUS so you don't need to initialize cpu.

It should be used in the other locations too.

-- Steve

> +
> +	guard(mutex)(&remote->lock);
> +
> +	iter = trace_remote_iter(remote, cpu, TRI_NONCONSUMING);
> +	if (IS_ERR(iter))
> +		return PTR_ERR(iter);
> +
> +	ret = seq_open(filp, &trace_seq_ops);
> +	if (ret) {
> +		trace_remote_iter_free(iter);
> +		return ret;
> +	}
> +
> +	if (iter)
> +		trace_remote_iter_read_start(iter);
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
> @@ -443,7 +754,11 @@ static ssize_t trace_write(struct file *filp, const char __user *ubuf, size_t cn
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
> @@ -532,6 +847,7 @@ int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs,
>  	remote->trace_buffer_size = 7 << 10;
>  	remote->poll_ms = 100;
>  	mutex_init(&remote->lock);
> +	init_rwsem(&remote->reader_lock);
>  
>  	if (trace_remote_init_tracefs(name, remote)) {
>  		kfree(remote);

