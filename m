Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DC32DC769
	for <kvmarm@lists.linux.dev>; Tue, 10 Feb 2026 15:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737578; cv=none; b=a/oHQhRsSjn4yz8Vg+JA8LM2o11p0qHG7RYCIwzxuqYu/DCy3yiN5eZxYpGvLdflmHHjZhijI5jvTGVi6N0njZ55qWCetjMLdCw41w/jxV6wyN/jlFSB4z2amLhgsHUg1XHf6J4ZnuhCM0/OjrZPXibgv0Gey+RJuh3EGfNYRLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737578; c=relaxed/simple;
	bh=+zGChlcQec4XugPYdTxIPOQXVVtEsJsEdmxWCqrDT3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iQhPsmf7bhwn7mFOgeH5Ef1EzmkObT6qujgRa/4VG64KkUonvzxZAJpU1my8BCCtOvExxxXseX4pSp5qsRd47QcaDnDS+8riEU0O8MhglMIE0OkPxWw/sYv8SMxtLke0KV4Va1VA9m6HPQWbtnFXhgjtCXVkJd75gZSEZvKTuaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SRHA2B2p; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SRHA2B2p"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4362507f0bcso3558648f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Feb 2026 07:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770737575; x=1771342375; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EUhq8bUSDIK8bU/Cf62PUQLvFL3hrikVLXNMzuDuSOI=;
        b=SRHA2B2p+kC9uwyoRWjgm0KJdRJBlpCP9nzwiVP4Z/wx5F29UslIQLULd8y086R/2g
         g85JX+36pMWvaZMvaFgMKUhEn4yC6FaQJ4jP7gi0+s5SsBLEkRjCy7l+yg7JhrvPXwCi
         1SGWJvTXsiPLttIwKZWctFZ2/aP7HIIjd325zICFDIRBG6+kwO6LxRZtb10VqKv9hJUQ
         fBIp/kJiw1DES4yny8M+vzTmd626lDYwyowtq5fqBnW8vrEY7SI4JJHcaw/En5g8cUMQ
         I3N18scD+9XRO0NgFiHUnklEGUHGlRanpbVf+pEUtz3w7XRPmzUT+LSi37yBPCd3DuSj
         15XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770737575; x=1771342375;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EUhq8bUSDIK8bU/Cf62PUQLvFL3hrikVLXNMzuDuSOI=;
        b=TM+8p4oxKXj7+Hh8b/A4gQ7KJAO58BX35oK4sg9DeyiVT7F1yY4n+pbz5/IToAPQnK
         6MikyT7lgaLGHHgKzqaO4WAEl6U4JPdF39KGz4sU5Vo/pP0/Y6DEIYFGlNS/isN3meSY
         QSoJmP3RJVZgHxxwY8KNg/gl33ZLMAJTF7GogcCQfIZ9WZCRBcAsammYP2oq9IFLvfRQ
         1ARNq6xwoAoIJkgVSx4tfXD7+p5Qf201QMd8Pi1imA2P2JL84d03tm5D64sgEciQkcax
         lVleX9QulZ0CdxkS2cTkRRGb9RyBV4arGSZS3cd0o/1OI97SyoJ/5Wu+3rM3sDb/8fm+
         n6Kg==
X-Forwarded-Encrypted: i=1; AJvYcCUXZywav84IQEKauFhKvZpAEMXcjJwoDmKfsZVLq5etRkkm/oVljNxCEMEc8M42JkSTycQOb3w=@lists.linux.dev
X-Gm-Message-State: AOJu0Yytqe/fVkeDpnOUaY3jMwQv+6LBTSISPYsormbo6PQjtid6U8KZ
	uREkDrU8hW+Bk5ISJJ5zZefqNJmmu/fLUcqdIP1kSHXrR+4GkkqhB7UwAlSHeRQ+Pg==
X-Gm-Gg: AZuq6aJoWxuvOq1bqSlAF/gydqTXD5eAxnnj5oX6xykQVK1dTXDKPcdYZ5Ib8mQYNVD
	9SzqlOjX6+F8gH+pOV58X/4XeOmsH76quTuUO4tYDMGhcJJEoexmGcpVDhmSp/+j6xudwn7rbA9
	/MhfKrKev65Hhyyu/IdK3Pz6OdxmPCo907+zMVg6p0cP4lOuW9QxtDXyLMg6GfSrQ+DPHiJKLxm
	/FqqhQGQtpzqwhbKzrj7teXfKvGh74qtbUQ7hMj4nmSPhnRlQ0nhLExIooqM7BrShmrZMjLZKCg
	uo9d+/zn4BIimDSTz3PbOYPe1jk60xkrGweH/X3CxUMwmIo+ZyJrHBGpOmZ6EnJgEIA/vRiBzUw
	JleFPyagzlNq8bpAcdTkbd5wKML5ODmmwXDR3+VQls5cgPZ/BGPJN1+DNV75ZpsVKibhhK9+Ie+
	HRze/Z02FfZ92jC/+Hm3pLA7AH2JYPkDuTw6NdRMQIaAx1PRQsxuc0qtFpNElGYnm+NyU=
X-Received: by 2002:a05:6000:24c3:b0:436:e875:7911 with SMTP id ffacd0b85a97d-43779e3bab1mr4635624f8f.4.1770737575096;
        Tue, 10 Feb 2026 07:32:55 -0800 (PST)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4376686130csm21600376f8f.1.2026.02.10.07.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 07:32:54 -0800 (PST)
Date: Tue, 10 Feb 2026 15:32:50 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 07/30] tracing: Add non-consuming read to trace
 remotes
Message-ID: <aYtPoil91IX7u_9f@google.com>
References: <20260131132848.254084-1-vdonnefort@google.com>
 <20260131132848.254084-8-vdonnefort@google.com>
 <20260204185208.646a6d26@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204185208.646a6d26@gandalf.local.home>

On Wed, Feb 04, 2026 at 06:52:08PM -0500, Steven Rostedt wrote:
> On Sat, 31 Jan 2026 13:28:25 +0000
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> > -static struct trace_remote_iterator *trace_remote_iter(struct trace_remote *remote, int cpu)
> > +static void __free_ring_buffer_iter(struct trace_remote_iterator *iter, int cpu)
> > +{
> > +	if (!iter->rb_iter)
> > +		return;
> 
> Hmm, can't iter->rb_iter be NULL when iter->rb_iters[] is used?

Arg yes, I missed that when I removed the union. And actually I don't think this
can be called with iter->rb_iter or iter->rb_iter NULL anymore.

> 
> > +
> > +	if (cpu != RING_BUFFER_ALL_CPUS) {
> > +		ring_buffer_read_finish(iter->rb_iter);
> > +		return;
> > +	}
> > +
> > +	for_each_possible_cpu(cpu) {
> > +		if (iter->rb_iters[cpu])
> > +			ring_buffer_read_finish(iter->rb_iters[cpu]);
> > +	}
> > +
> > +	kfree(iter->rb_iters);
> > +}
> > +
> > +static int __alloc_ring_buffer_iter(struct trace_remote_iterator *iter, int cpu)
> > +{
> > +	if (cpu != RING_BUFFER_ALL_CPUS) {
> > +		iter->rb_iter = ring_buffer_read_start(iter->remote->trace_buffer, cpu, GFP_KERNEL);
> > +
> > +		return iter->rb_iter ? 0 : -ENOMEM;
> > +	}
> > +
> > +	iter->rb_iters = kcalloc(nr_cpu_ids, sizeof(*iter->rb_iters), GFP_KERNEL);
> > +	if (!iter->rb_iters)
> > +		return -ENOMEM;
> > +
> > +	for_each_possible_cpu(cpu) {
> > +		iter->rb_iters[cpu] = ring_buffer_read_start(iter->remote->trace_buffer, cpu,
> > +							     GFP_KERNEL);
> > +		if (!iter->rb_iters[cpu]) {
> > +			__free_ring_buffer_iter(iter, RING_BUFFER_ALL_CPUS);
> 
> For instance, we call __free_ring_buffer_iter() here, but I don't see
> iter->rb_iter being set.
> 
> -- Steve
> 
> 
> > +			return -ENOMEM;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +

[...]

> > +static void *trace_next(struct seq_file *m, void *v, loff_t *pos)
> > +{
> > +	struct trace_remote_iterator *iter = m->private;
> > +
> > +	++*pos;
> > +
> > +	if (!iter || !trace_remote_iter_read_event(iter))
> > +		return NULL;
> > +
> > +	trace_remote_iter_move(iter);
> > +	iter->pos++;
> > +
> > +	return iter;
> > +}
> > +
> > +static void *trace_start(struct seq_file *m, loff_t *pos)
> > +{
> > +	struct trace_remote_iterator *iter = m->private;
> > +	loff_t i;
> > +
> 
> FYI, this is where you take locks for iteration of files.
> 
> > +	if (!iter)
> > +		return NULL;
> > +
> > +	if (!*pos) {
> > +		iter->pos = -1;
> > +		return trace_next(m, NULL, &i);
> > +	}
> > +
> > +	i = iter->pos;
> > +	while (i < *pos) {
> > +		iter = trace_next(m, NULL, &i);
> > +		if (!iter)
> > +			return NULL;
> > +	}
> > +
> > +	return iter;
> > +}
> > +
> > +static int trace_show(struct seq_file *m, void *v)
> > +{
> > +	struct trace_remote_iterator *iter = v;
> > +
> > +	trace_seq_init(&iter->seq);
> > +
> > +	if (trace_remote_iter_print_event(iter)) {
> > +		seq_printf(m, "[EVENT %d PRINT TOO BIG]\n", iter->evt->id);
> > +		return 0;
> > +	}
> > +
> > +	return trace_print_seq(m, &iter->seq);
> > +}
> > +
> > +static void trace_stop(struct seq_file *s, void *v) { }
> 
> And stop is where you release the locks.
> 
> > +
> > +static const struct seq_operations trace_sops = {
> > +	.start		= trace_start,
> > +	.next		= trace_next,
> > +	.show		= trace_show,
> > +	.stop		= trace_stop,
> > +};
> > +
> > +static int trace_open(struct inode *inode, struct file *filp)
> > +{
> > +	struct trace_remote *remote = inode->i_private;
> > +	struct trace_remote_iterator *iter = NULL;
> > +	int cpu = tracing_get_cpu(inode);
> > +	int ret;
> > +
> > +	if (!(filp->f_mode & FMODE_READ))
> > +		return 0;
> > +
> > +	guard(mutex)(&remote->lock);
> > +
> > +	iter = trace_remote_iter(remote, cpu, TRI_NONCONSUMING);
> > +	if (IS_ERR(iter))
> > +		return PTR_ERR(iter);
> 
> So if iter is bad we exit out here.
> 
> > +
> > +	ret = seq_open(filp, &trace_sops);
> > +	if (ret) {
> > +		trace_remote_iter_free(iter);
> > +		return ret;
> > +	}
> > +
> > +	if (iter)
> 
> Why test if iter exists here?

We only test IS_ERR. iter will be NULL if the buffer isn't loaded and the
userspace output would be empty. But anyway if I move the locking into
start/stop this line will go away!

> 
> > +		trace_remote_iter_read_start(iter);
> 
> But still, the above grabs locks in the open, where it can return to user
> space while still holding the locks? That's a no-no.
> 
> You can use the seq file start and stop for locking.
> 
> -- Steve
>
[...]
