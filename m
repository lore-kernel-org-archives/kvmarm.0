Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD2425E816
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 21:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757454431; cv=none; b=YRlO4ATK/q9as/Gd14o71ZE3oGZZRmTOrzyOzVniqlCu9RHMlMQKwPFISDFUGlzheZTRML3Bh2XUrHUVYkpRbprSCaZ8o+AfpEKkIxNYM7bu63sw+L2NGNIDcJXUtG8KAUE71ymahXFv3Chk6qfJHAI2W7SKUzijs1OUCTqq3YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757454431; c=relaxed/simple;
	bh=5UNVEqM0SA3LiwvwtQD9PCp1Z2RCknate6LOsHyQXXc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QoKUPVwdLobloTPKdR46bI2rWllqTQcuiBPMfQmPcccmLqCgdhXKY2IAOLqdDzNsTVaWc5gjKHFIfLXX8I0sDSC+z8LwYI7NYyylDVRYkdrCCGFn1/SY+OizLTVqvzX+p2ATVhKBEdhx4BtvpbtBBg0Iw51UmOWpUekw/D5xO5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E31F140119;
	Tue,  9 Sep 2025 21:47:06 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id F1A102F;
	Tue,  9 Sep 2025 21:47:02 +0000 (UTC)
Date: Tue, 9 Sep 2025 17:47:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 06/24] tracing: Add events to trace remotes
Message-ID: <20250909174750.72be9bbc@gandalf.local.home>
In-Reply-To: <20250821081412.1008261-7-vdonnefort@google.com>
References: <20250821081412.1008261-1-vdonnefort@google.com>
	<20250821081412.1008261-7-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7ej5srhi7m6dgtzrcpzb7hsqh8cx9fhr
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: F1A102F
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+a22/GqU1qf8xhKUjNZ3RQSMe8o75J0/I=
X-HE-Tag: 1757454422-816481
X-HE-Meta: U2FsdGVkX1+MvwcffwkTYY4ptHTCjtVWAhsGAZBNw+vbcSDhGOmJ57KfO9RcRgJyDZ7EMrHLo//as4KF2ZC7464Edt85xLb32cnKLFN690CNFKswW4Bz3sjDMJN1RrqzpF7mk143fnM1ZtLJSfThUbqWXcvj3Zg1Lu9AxVbp41YNt6DG5haSE/V1tiaKAj/2e0X+WCTO9Lf0X6lRMxGO8TRxXK/mlnv8xXdxBXd8kCltiEIFf0LsNw5Ycq2HHG8zVEfoFYFr57k1wrlzWpuzmMY7SvwVs+bIvAvytdIqtaLvCHQR1r90l/Clh7yLvQbsvk1lSpG27MYvzlTzDWhENKoRw42PjCZq

On Thu, 21 Aug 2025 09:13:54 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

> @@ -265,16 +272,19 @@ static struct trace_remote_iterator *trace_remote_iter(struct trace_remote *remo
>  static bool trace_remote_iter_next(struct trace_remote_iterator *iter)
>  {
>  	struct trace_buffer *trace_buffer = iter->remote->trace_buffer;
> +	struct ring_buffer_event *rb_evt;
>  	int cpu = iter->cpu;
>  
>  	if (cpu != RING_BUFFER_ALL_CPUS) {
>  		if (ring_buffer_empty_cpu(trace_buffer, cpu))
>  			return false;
>  
> -		if (!ring_buffer_peek(trace_buffer, cpu, &iter->ts, &iter->lost_events))
> +		rb_evt = ring_buffer_peek(trace_buffer, cpu, &iter->ts, &iter->lost_events);
> +		if (!rb_evt)
>  			return false;
>  
>  		iter->evt_cpu = cpu;
> +		iter->evt = (struct remote_event_hdr *)&rb_evt->array[1];

Hmm, shouldn't this use ring_buffer_event_data(rb_evt) instead?

If the events get big, then it would be array[2]. But the
ring_buffer_event_data() hides that detail.

>  		return true;
>  	}
>  
> @@ -286,7 +296,8 @@ static bool trace_remote_iter_next(struct trace_remote_iterator *iter)
>  		if (ring_buffer_empty_cpu(trace_buffer, cpu))
>  			continue;
>  
> -		if (!ring_buffer_peek(trace_buffer, cpu, &ts, &lost_events))
> +		rb_evt = ring_buffer_peek(trace_buffer, cpu, &ts, &lost_events);

Ditto.

> +		if (!rb_evt)
>  			continue;
>  
>  		if (ts >= iter->ts)
> @@ -294,14 +305,18 @@ static bool trace_remote_iter_next(struct trace_remote_iterator *iter)
>  
>  		iter->ts = ts;
>  		iter->evt_cpu = cpu;
> +		iter->evt = (struct remote_event_hdr *)&rb_evt->array[1];

Ditto.

-- Steve

>  		iter->lost_events = lost_events;
>  	}
>  
>  	return iter->ts != U64_MAX;
>  }
>  
> +static struct remote_event *trace_remote_find_event(struct trace_remote *remote, unsigned short id);
> +
>  static int trace_remote_iter_print(struct trace_remote_iterator *iter)
>  {
> +	struct remote_event *evt;
>  	unsigned long usecs_rem;
>  	u64 ts = iter->ts;
>  
