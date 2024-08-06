Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273FB38DD8;
	Tue,  6 Aug 2024 20:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722975051; cv=none; b=Tr9fqrtzJAU2oUwLZw8wdysSwqoGdbf9IyObJhRo0YQd96qCqoeOzvuO5Vfe7GCpORpdf2aO6iw1yFMXPcjP0QpEZOchteE4eOLphRMmjSE75U60lQ/Fz0YXlUbZgoV63waM3hb2rKQ88g0xZKCiolonXnqmTevI80E7/QC35zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722975051; c=relaxed/simple;
	bh=uUNBQRadk+vf2STzsAJTCsnMLdf82xV4JJodj0il2jo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VO2fQMlx5BZOaimvBZXRzmWGVOcfVLqFDx7YVoEgNoKqeBNGTwyQ08Z9aNENGpKuFgKqWoSwuBZhj5gGQ0XG1ldcCjV4Vv0OdCkT18s4GiL+mazV8Y7tg2GSm3rpwxj1UTX0jof0ppZi0WH9Ff8E4J63QcdBIq+xgwhhOs0FjqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4912C32786;
	Tue,  6 Aug 2024 20:10:49 +0000 (UTC)
Date: Tue, 6 Aug 2024 16:11:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, maz@kernel.org,
 oliver.upton@linux.dev, kvmarm@lists.linux.dev, will@kernel.org,
 qperret@google.com, kernel-team@android.com
Subject: Re: [RFC PATCH 00/11] Tracefs support for pKVM
Message-ID: <20240806161138.3a91c04a@gandalf.local.home>
In-Reply-To: <20240805173234.3542917-1-vdonnefort@google.com>
References: <20240805173234.3542917-1-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Hi Vincent,

Thanks for sending this!

On Mon,  5 Aug 2024 18:32:23 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

> The growing set of features supported by the hypervisor in protected
> mode necessitates debugging and profiling tools. Tracefs is the
> ideal candidate for this task:
> 
>   * It is simple to use and to script.
> 
>   * It is supported by various tools, from the trace-cmd CLI to the
>     Android web-based perfetto.
> 
>   * The ring-buffer, where are stored trace events consists of linked
>     pages, making it an ideal structure for sharing between kernel and
>     hypervisor.
> 
> This series introduces a method to create events and to generate them
> from the hypervisor (hyp_enter/hyp_exit given as an example) as well as
> a Tracefs user-space interface to read them.
> 
> A presentation was given on this matter during the tracing summit in
> 2022. [1]
> 
> 1. ring-buffer
> --------------
> 
> To setup the per-cpu ring-buffers, a new interface is created:
> 
>   ring_buffer_writer:	Describes what the kernel needs to know about the
> 			writer, that is, the set of pages forming the
> 			ring-buffer and a callback for the reader/head
> 			swapping (enables consuming read)
> 
>   ring_buffer_reader():	Creates a read-only ring-buffer from a
> 			ring_buffer_writer.
> 
> To keep the internals of `struct ring_buffer` in sync with the writer,
> the meta-page is used. It was originally introduced to enable user-space
> mapping of the ring-buffer [1]. In this case, the kernel is not the
> producer anymore but the reader. The function to read that meta-page is:
> 
>   ring_buffer_poll_writer():
> 			Update `struct ring_buffer` based on the writer
> 			meta-page. Wake-up readers if necessary.
> 
> The kernel has to poll the meta-page to be notified of newly written
> events.
> 
> 2. Tracefs interface
> --------------------
> 
> The interface is a hyp/ folder at the root of the tracefs mount point.
> This folder is like an instance and you'll find there a subset of the
> regular Tracefs user-space interface:
> 
>   hyp/

Hmm, do we really need to shorten it? Why not just call it "hypervisor". I
mean tab completion helps with the typing.

>      buffer_size_kb
>      trace_pipe
>      trace_pipe_raw
>      trace
>      per_cpu/
>              cpuX/
>                  trace_pipe
>                  trace_pipe_raw
>      events/
>             hyp/
>                 hyp_enter/
>                           enable
>                           id
> 
> Behind the scenes, kvm/hyp_trace.c must rebuild the tracing hierarchy
> without relying on kernel/trace/trace.c. This is due to fundamental
> differences:
> 
>   * Hypervisor tracing doesn't support trace_array's system-specific
>     features (snapshots, tracers, etc.).
> 
>   * Logged event formats differ (e.g., no PID in hypervisor
>     events).
> 
>   * Buffer operations require specific hypervisor interactions.
> 
> 3. Events
> ---------
> 
> In the hypervisor, "hyp events" can be generated with trace_<event_name>
> in a similar fashion to what the kernel does. They're also created with
> similar macros than the kernel (see kvm_hypevents.h)
> 
> HYP_EVENT("foboar",
> 	HE_PROTO(void),
> 	HE_STRUCT(),
> 	HE_ASSIGN(),
> 	HE_PRINTK(" ")
> )
> 
> Despite the apparent similarities with TRACE_EVENT(), those macros
> internally differs: they must be used in parallel between the hypervisor
> (for the writing part) and the kernel (for the reading part) which makes
> it difficult to share anything with their kernel counterpart.
> 
> Also, events directory isn't using eventfs.
> 
> 4. Few limitations:
> -------------------
> 
> Non consuming reading of the buffer isn't supported (i.e. cat trace) due
> to the lack of support in the ring-buffer meta-page.

Hmm, I don't think it should be hard to support that. I've been looking
into it for the user mapping. But that can be added later. For now, perhaps
"cat trace" just returns -EPERM?

> 
> Tracing must be stopped for the buffer to be reset. i.e. (echo 0 >
> tracing_on; echo 0 > trace)

Hmm, why this?  I haven't looked at the patches yet, but why can't the
write to trace just stop tracing and re-enable it after the reset?

> 

-- Steve
