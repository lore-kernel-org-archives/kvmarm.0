Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1209C336EE5
	for <kvmarm@lists.linux.dev>; Wed, 28 Jan 2026 20:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769632651; cv=none; b=kTsqiZvylKHD3DSZp3M4SOK6FS+TQ7RdI32uTXmISA7MAA3M8YdkThMw1z2VbywAvVqGpjkzwcL7Lq1267t/Z4PM4+RH/V1QfaGmpttQL4tAr2RMuwpqKLQfpjjhinArsaO/teq307/VKABQOFAwvvzsMr44B474FbKwINdo/aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769632651; c=relaxed/simple;
	bh=Jm4m7VYHo2B5w+oKDpRQcG4TmqtFJUzPeazXZAUKv+s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PJVT09tk6q8l6iERFCwRvhYAPr32fKZ4eEXtZD2FiFeOe9eFWzQsr8Y1sdRKfhgkLXnt5ao4/pi61skM/EoxGIuAsIfqLz5rgsXv/XjLPnMSzmJ2dVFl35vERUFGRlGCVBACTMIChfSq54psone0fVBneMnCxcGgkUjS6Pn7nSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10D87BACBD;
	Wed, 28 Jan 2026 20:37:20 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id 5351D20026;
	Wed, 28 Jan 2026 20:37:16 +0000 (UTC)
Date: Wed, 28 Jan 2026 15:37:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 05/30] tracing: Introduce trace remotes
Message-ID: <20260128153725.56e801c0@gandalf.local.home>
In-Reply-To: <20260126104419.1649811-6-vdonnefort@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
	<20260126104419.1649811-6-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout06
X-Rspamd-Queue-Id: 5351D20026
X-Stat-Signature: scjjj34ejpo8p63oqkqp8pwnu69wo154
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/tQSaCQ/kbHKv4AKesdqQg9at+NZ9UW34=
X-HE-Tag: 1769632636-833049
X-HE-Meta: U2FsdGVkX1+PXL5P+2z0NQATjdCVHVPBqharGA1VqQvqSuXihZKzEDPgQZw69kb71D35qQ8EYpsvHjQlZ/aLjqrnCpGkIMKRhBFjerJdQFeYOTdkm6LDvkFMaToOWRwK3V/P/G5EgUai88UA4Cb3jyqbjqeyR/mwnqrZSpho8PT6+lSvWEuhDcQ/l663XiLRtGS41VzfdXhZ15Zg5idBMUlVXjgcvsZBOgyDnb0C1LP0i2ecq+RVgFqF1b1ixJii/kHsBXfzikzQgjH5RstFvz7zN7OAA8lfj9ElaZJ2Nm1Zk4yTKOsK9cXnYHfETDCHBQ/R0u4IvYJbsDiB7sQ9kxLUAErmajgK

On Mon, 26 Jan 2026 10:43:54 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> diff --git a/include/linux/trace_remote.h b/include/linux/trace_remote.h
> new file mode 100644
> index 000000000000..feb3433c2128
> --- /dev/null
> +++ b/include/linux/trace_remote.h
> @@ -0,0 +1,80 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _LINUX_TRACE_REMOTE_H
> +#define _LINUX_TRACE_REMOTE_H
> +
> +#include <linux/ring_buffer.h>
> +
> +/**
> + * struct trace_remote_callbacks - Callbacks used by Tracefs to control the remote
> + *
> + * @load_trace_buffer:  Called before Tracefs accesses the trace buffer for the first
> + *			time. Must return a &trace_buffer_desc
> + *			(most likely filled with trace_remote_alloc_buffer())
> + * @unload_trace_buffer:
> + *			Called once Tracefs has no use for the trace buffer
> + *			(most likely call trace_remote_free_buffer())
> + * @enable_tracing:	Called on Tracefs tracing_on. It is expected from the
> + *			remote to allow writing.
> + * @swap_reader_page:	Called when Tracefs consumes a new page from a
> + *			ring-buffer. It is expected from the remote to isolate a
> + *			new reader-page from the @cpu ring-buffer.
> + */
> +struct trace_remote_callbacks {
> +	struct trace_buffer_desc *(*load_trace_buffer)(unsigned long size, void *priv);
> +	void	(*unload_trace_buffer)(struct trace_buffer_desc *desc, void *priv);
> +	int	(*enable_tracing)(bool enable, void *priv);
> +	int	(*swap_reader_page)(unsigned int cpu, void *priv);
> +};
> +
> +/**
> + * trace_remote_register() - Register a Tracefs remote
> + *
> + * A trace remote is an entity, outside of the kernel (most likely firmware or
> + * hypervisor) capable of writing events into a Tracefs compatible ring-buffer.
> + * The kernel would then act as a reader.
> + *
> + * The registered remote will be found under the Tracefs directory
> + * remotes/<name>.
> + *
> + * @name:	Name of the remote, used for the Tracefs remotes/ directory.
> + * @cbs:	Set of callbacks used to control the remote.
> + * @priv:	Private data, passed to each callback from @cbs.
> + * @events:	Array of events. &remote_event.name and &remote_event.id must be
> + *		filled by the caller.
> + * @nr_events:	Number of events in the @events array.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs, void *priv);

Nit, but kerneldoc goes before the functions and not before their prototypes.


> +
> +/**
> + * trace_remote_alloc_buffer() - Dynamically allocate a trace buffer
> + *
> + * Helper to dynamically allocate a set of pages (enough to cover @buffer_size)
> + * for each CPU from @cpumask and fill @desc. Most likely called from
> + * &trace_remote_callbacks.load_trace_buffer.
> + *
> + * @desc:		Uninitialized trace_buffer_desc
> + * @desc_size:		Size of the trace_buffer_desc. Must be at least equal to
> + *			trace_buffer_desc_size()
> + * @buffer_size:	Size in bytes of each per-CPU ring-buffer
> + * @cpumask:		CPUs to allocate a ring-buffer for
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int trace_remote_alloc_buffer(struct trace_buffer_desc *desc, size_t desc_size, size_t buffer_size,
> +			      const struct cpumask *cpumask);
> +
> +/**
> + * trace_remote_free_buffer() - Free trace buffer allocated with
> + *				trace_remote_alloc_buffer()
> + *
> + * Most likely called from &trace_remote_callbacks.unload_trace_buffer.
> + *
> + * @desc:	Descriptor of the per-CPU ring-buffers, originally filled by
> + *		trace_remote_alloc_buffer()
> + */
> +void trace_remote_free_buffer(struct trace_buffer_desc *desc);
> +
> +#endif
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index bfa2ec46e075..135edf143073 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -1278,4 +1278,7 @@ config HIST_TRIGGERS_DEBUG
>  
>  source "kernel/trace/rv/Kconfig"
>  
> +config TRACE_REMOTE
> +	bool
> +
>  endif # FTRACE
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index fc5dcc888e13..6e75d710fc25 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -127,4 +127,5 @@ obj-$(CONFIG_FPROBE_EVENTS) += trace_fprobe.o
>  obj-$(CONFIG_TRACEPOINT_BENCHMARK) += trace_benchmark.o
>  obj-$(CONFIG_RV) += rv/
>  
> +obj-$(CONFIG_TRACE_REMOTE) += trace_remote.o
>  libftrace-y := ftrace.o
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 8bd4ec08fb36..1fcbdea992d2 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -9356,7 +9356,7 @@ static struct dentry *tracing_dentry_percpu(struct trace_array *tr, int cpu)
>  	return tr->percpu_dir;
>  }
>  
> -static struct dentry *
> +struct dentry *
>  trace_create_cpu_file(const char *name, umode_t mode, struct dentry *parent,
>  		      void *data, long cpu, const struct file_operations *fops)
>  {
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index b6d42fe06115..fdbcd068ba38 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -680,6 +680,12 @@ struct dentry *trace_create_file(const char *name,
>  				 struct dentry *parent,
>  				 void *data,
>  				 const struct file_operations *fops);
> +struct dentry *trace_create_cpu_file(const char *name,
> +				     umode_t mode,
> +				     struct dentry *parent,
> +				     void *data,
> +				     long cpu,
> +				     const struct file_operations *fops);
>  
>  
>  /**
> diff --git a/kernel/trace/trace_remote.c b/kernel/trace/trace_remote.c
> new file mode 100644
> index 000000000000..3d80ff98fd90
> --- /dev/null
> +++ b/kernel/trace/trace_remote.c
> @@ -0,0 +1,570 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2025 - Google LLC
> + * Author: Vincent Donnefort <vdonnefort@google.com>
> + */
> +
> +#include <linux/kstrtox.h>
> +#include <linux/lockdep.h>
> +#include <linux/mutex.h>
> +#include <linux/tracefs.h>
> +#include <linux/trace_remote.h>
> +#include <linux/trace_seq.h>
> +#include <linux/types.h>
> +
> +#include "trace.h"
> +
> +#define TRACEFS_DIR		"remotes"
> +#define TRACEFS_MODE_WRITE	0640
> +#define TRACEFS_MODE_READ	0440
> +
> +struct trace_remote_iterator {
> +	struct trace_remote		*remote;
> +	struct trace_seq		seq;
> +	struct delayed_work		poll_work;
> +	unsigned long			lost_events;
> +	u64				ts;
> +	int				cpu;
> +	int				evt_cpu;
> +};
> +
> +struct trace_remote {
> +	struct trace_remote_callbacks	*cbs;
> +	void				*priv;
> +	struct trace_buffer		*trace_buffer;
> +	struct trace_buffer_desc	*trace_buffer_desc;
> +	unsigned long			trace_buffer_size;
> +	struct ring_buffer_remote	rb_remote;
> +	struct mutex			lock;
> +	unsigned int			nr_readers;
> +	unsigned int			poll_ms;
> +	bool				tracing_on;
> +};
> +
> +static bool trace_remote_loaded(struct trace_remote *remote)
> +{
> +	return remote->trace_buffer;

Nit, but since you are returning a bool, make it obvious that is what you
want:

	return !!remote->trace_buffer;



> +}
> +
> +static int trace_remote_load(struct trace_remote *remote)
> +{
> +	struct ring_buffer_remote *rb_remote = &remote->rb_remote;
> +
> +	lockdep_assert_held(&remote->lock);
> +
> +	if (trace_remote_loaded(remote))
> +		return 0;
> +
> +	remote->trace_buffer_desc = remote->cbs->load_trace_buffer(remote->trace_buffer_size,
> +								   remote->priv);
> +	if (IS_ERR(remote->trace_buffer_desc))
> +		return PTR_ERR(remote->trace_buffer_desc);

Hmm, on error, should we reset remote->trace_buffer_desc to NULL?

Just to be safe. Could just do:

	struct trace_buffer_desc *desc;

	desc = remote->cbs->load_trace_buffer(remote->trace_buffer_size, remote->priv);
	if (IS_ERR(desc))
		return PTR_ERR(desc);

	rb_remote->desc = desc;


> +
> +	rb_remote->desc = remote->trace_buffer_desc;
> +	rb_remote->swap_reader_page = remote->cbs->swap_reader_page;
> +	rb_remote->priv = remote->priv;
> +	remote->trace_buffer = ring_buffer_alloc_remote(rb_remote);
> +	if (!remote->trace_buffer) {
> +		remote->cbs->unload_trace_buffer(remote->trace_buffer_desc, remote->priv);

		remote->cbs->unload_trace_buffer(desc, remote->priv);

> +		return -ENOMEM;
> +	}

	remote->trace_buffer_desc = desc;

Only set it on success.

> +
> +	return 0;
> +}
> +
> +static void trace_remote_try_unload(struct trace_remote *remote)
> +{
> +	lockdep_assert_held(&remote->lock);
> +
> +	if (!trace_remote_loaded(remote))
> +		return;
> +
> +	/* The buffer is being read or writable */
> +	if (remote->nr_readers || remote->tracing_on)
> +		return;
> +
> +	/* The buffer has readable data */
> +	if (!ring_buffer_empty(remote->trace_buffer))
> +		return;
> +
> +	ring_buffer_free(remote->trace_buffer);
> +	remote->trace_buffer = NULL;
> +	remote->cbs->unload_trace_buffer(remote->trace_buffer_desc, remote->priv);
> +}
> +
> +static int trace_remote_enable_tracing(struct trace_remote *remote)
> +{
> +	int ret;
> +
> +	lockdep_assert_held(&remote->lock);
> +
> +	if (remote->tracing_on)
> +		return 0;
> +
> +	ret = trace_remote_load(remote);
> +	if (ret)
> +		return ret;
> +
> +	ret = remote->cbs->enable_tracing(true, remote->priv);
> +	if (ret) {
> +		trace_remote_try_unload(remote);
> +		return ret;
> +	}
> +
> +	remote->tracing_on = true;
> +
> +	return 0;
> +}
> +
> +static int trace_remote_disable_tracing(struct trace_remote *remote)
> +{
> +	int ret;
> +
> +	lockdep_assert_held(&remote->lock);
> +
> +	if (!remote->tracing_on)
> +		return 0;
> +
> +	ret = remote->cbs->enable_tracing(false, remote->priv);
> +	if (ret)
> +		return ret;
> +
> +	ring_buffer_poll_remote(remote->trace_buffer, RING_BUFFER_ALL_CPUS);
> +	remote->tracing_on = false;
> +	trace_remote_try_unload(remote);

> +
> +	return 0;
> +}
> +
> +static ssize_t
> +tracing_on_write(struct file *filp, const char __user *ubuf, size_t cnt, loff_t *ppos)
> +{
> +	struct trace_remote *remote = filp->private_data;
> +	unsigned long val;
> +	int ret;
> +
> +	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
> +	if (ret)
> +		return ret;
> +
> +	guard(mutex)(&remote->lock);
> +
> +	ret = val ? trace_remote_enable_tracing(remote) : trace_remote_disable_tracing(remote);
> +	if (ret)
> +		return ret;
> +
> +	return cnt;
> +}
> +static int tracing_on_show(struct seq_file *s, void *unused)
> +{
> +	struct trace_remote *remote = s->private;
> +
> +	seq_printf(s, "%d\n", remote->tracing_on);
> +
> +	return 0;
> +}
> +DEFINE_SHOW_STORE_ATTRIBUTE(tracing_on);
> +
> +static ssize_t buffer_size_kb_write(struct file *filp, const char __user *ubuf, size_t cnt,
> +				    loff_t *ppos)
> +{
> +	struct trace_remote *remote = filp->private_data;
> +	unsigned long val;
> +	int ret;
> +
> +	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
> +	if (ret)
> +		return ret;
> +
> +	/* KiB to Bytes */
> +	if (!val || check_shl_overflow(val, 10, &val))
> +		return -EINVAL;
> +
> +	guard(mutex)(&remote->lock);
> +
> +	remote->trace_buffer_size = val;

Should this be allowed to change when it is already loaded?

-- Steve

> +
> +	return cnt;
> +}
> +
> +static int buffer_size_kb_show(struct seq_file *s, void *unused)
> +{
> +	struct trace_remote *remote = s->private;
> +
> +	seq_printf(s, "%lu (%s)\n", remote->trace_buffer_size >> 10,
> +		   trace_remote_loaded(remote) ? "loaded" : "unloaded");
> +
> +	return 0;
> +}
> +DEFINE_SHOW_STORE_ATTRIBUTE(buffer_size_kb);
> +

