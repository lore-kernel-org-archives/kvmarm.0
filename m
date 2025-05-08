Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F2E3C26;
	Thu,  8 May 2025 00:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746663876; cv=none; b=ZOPHAEuerkX29UaxXz6w4nraFLYc/L0H1yCf5yX4ExVQB2wEN77VlpYE0JAJfHYFg4b0jm5v3IyuXnrE6bSpTCQXHUW4uDeHxm6YZbzbfEe3SNl78e1s3S+3pe4GG8iDExJdTENWFAg57auXp0ZTl2vQUB2Gf+WBVHl9p6D63wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746663876; c=relaxed/simple;
	bh=mDH+ZL79YTMq+Jv0bVy+9Pty09ZB23vy1luG3tCeplI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YDAMg+fBwkeSPfQNIh0Q8SzaoNTOZkbgx2SqTGAGYtTFCsIQyhgWsHi1U7nO9YhAdbcIfna+SaKGk0+NkhAlFVCxbvf9A+EvQOB4s2GjYuuyop1w+Ntbw1nxt+8BYvykb65wU4bviuKpxuizpUmWoAMQOzzPIoBz2IFxyM/2afU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F3CC4CEE2;
	Thu,  8 May 2025 00:24:33 +0000 (UTC)
Date: Wed, 7 May 2025 20:24:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/24] tracing: Introduce trace remotes
Message-ID: <20250507202444.43963c84@gandalf.local.home>
In-Reply-To: <20250506164820.515876-3-vdonnefort@google.com>
References: <20250506164820.515876-1-vdonnefort@google.com>
	<20250506164820.515876-3-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  6 May 2025 17:47:58 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

> +
> +static bool trace_remote_loaded(struct trace_remote *remote)
> +{
> +	return remote->trace_buffer;
> +}
> +
> +static bool trace_remote_busy(struct trace_remote *remote)

Can you add comments to what these functions are doing?

Doesn't need to be kerneldoc (it actually shouldn't be), but describe why
they would return true and why they would return false.

> +{
> +	return trace_remote_loaded(remote) &&
> +		(remote->nr_readers || remote->tracing_on ||
> +		 !ring_buffer_empty(remote->trace_buffer));
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
> +	if (!remote->trace_buffer_desc)
> +		return -ENOMEM;

The error may not be -ENOMEM, have the load_trace_buffer return an ERR_PTR
and then you can return:

	if (IS_ERR(remote->trace_buffer_desc)
		return PTR_ERR(remote->trace_buffer_desc);


> +
> +	rb_remote->desc = remote->trace_buffer_desc;
> +	rb_remote->swap_reader_page = remote->cbs->swap_reader_page;
> +	rb_remote->priv = remote->priv;
> +	remote->trace_buffer = ring_buffer_remote(rb_remote);
> +	if (!remote->trace_buffer) {

Same here.

> +		remote->cbs->unload_trace_buffer(remote->trace_buffer_desc, remote->priv);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +static void trace_remote_unload(struct trace_remote *remote)
> +{
> +	lockdep_assert_held(&remote->lock);
> +
> +	if (!trace_remote_loaded(remote) || trace_remote_busy(remote))
> +		return;

Can this cause leaks? Should trace_remote_unload() return an error value to
let the caller know it wasn't unloaded?

> +
> +	ring_buffer_free(remote->trace_buffer);
> +	remote->trace_buffer = NULL;
> +	remote->cbs->unload_trace_buffer(remote->trace_buffer_desc, remote->priv);
> +}
> +

Short description of what trace_remote_start does.

> +static int trace_remote_start(struct trace_remote *remote)
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
> +		trace_remote_unload(remote);
> +		return ret;
> +	}
> +
> +	remote->tracing_on = true;
> +
> +	return 0;
> +}
> +

Same for stop.

-- Steve

> +static int trace_remote_stop(struct trace_remote *remote)
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
> +	trace_remote_unload(remote);
> +
> +	return 0;
> +}
