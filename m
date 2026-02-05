Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1E92FE075
	for <kvmarm@lists.linux.dev>; Thu,  5 Feb 2026 17:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770313505; cv=none; b=dqZp+AuQKndrXUXdQYg8nInWIfi+nutx0QQ16UYGhJ11f0JqdJP6767xDutTGnLUVCOycfvsPmw68TXnX+MjREYfiKj0tS57Qvupveaf2uAQHbCm+9Ddb1we5lw059H1WLw4CWHCKItok0T40y3wbqwZNJmwouBrAiCnmijfsRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770313505; c=relaxed/simple;
	bh=ejTFqTMFddAjJSxNofDGZMsPBuGLMnvsSazmKVAJFuA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UsNHhwkcLR4p7z8sq0UpM8nRRQA6e+FGUBd1teioN4ngWlj7HJTz2r0+Vgci14iTYkaY/uTD5gye24aiu/LJDgxCjfosVHBwBIeJnOL+gt00z0LsS4f29DuWlmtOF+YmCmrKOpaMs/dvfRIPaLeLTKwX0DTKb1oWU/1pZg40L8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 06D815951B;
	Thu,  5 Feb 2026 17:45:01 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id 6FA9920023;
	Thu,  5 Feb 2026 17:44:58 +0000 (UTC)
Date: Thu, 5 Feb 2026 12:45:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 16/30] Documentation: tracing: Add tracing remotes
Message-ID: <20260205124533.28f9db45@gandalf.local.home>
In-Reply-To: <20260131132848.254084-17-vdonnefort@google.com>
References: <20260131132848.254084-1-vdonnefort@google.com>
	<20260131132848.254084-17-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ai6rox4y9oeu64mq8rsp3tccgk3h4zri
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 6FA9920023
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19F1hglx0nqYaYq3VGNOGdk3CDWAUm+/cI=
X-HE-Tag: 1770313498-252966
X-HE-Meta: U2FsdGVkX18zwaurqROMCHQNp3OqM4qNKB4KV04hUkixbjHcIlW16CqVqfzvkQ6giwHsJdwRePGSmw62d5kt/IbdClsbkwvRBb87AbruIoh/y1oPTExmNMgeZjwfI6CyyZm0MrvBUaPrubnuDGgmEGclpEx4IMMUSpGIUbuHz/Zbq0Q0BHODoES6RObwf4JPj3or/WALdQ7kWBu8qgfRIzLi8jd5sfQGAbfx/Fni4+cz9Dr7bBKBAw2/hvR5Y8cZa9A7eQjHQhEq5eg/1tTkJUWqYt7XnYeCnfeW97MqUHz3ZFmeWq0sDqhRhKrljo3vtYSDhLTZduFARiLuyN1puW40aSD1fenUrMWnLKG8hWiMT+AXgSm9U4eQopKK0u/JKV8khmL6U6ztk+cjGEDFZw==

On Sat, 31 Jan 2026 13:28:34 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> Add documentation about the newly introduced tracing remotes framework.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

But in the future, this document should probably go into more details about
what is expected by each callback.

-- Steve


> diff --git a/Documentation/trace/index.rst b/Documentation/trace/index.rst
> index b4a429dc4f7a..d77ffb7e2d08 100644
> --- a/Documentation/trace/index.rst
> +++ b/Documentation/trace/index.rst
> @@ -90,6 +90,17 @@ interactions.
>     user_events
>     uprobetracer
>  
> +Remote Tracing
> +--------------
> +
> +This section covers the framework to read compatible ring-buffers, written by
> +entities outside of the kernel (most likely firmware or hypervisor)
> +
> +.. toctree::
> +   :maxdepth: 1
> +
> +   remotes
> +
>  Additional Resources
>  --------------------
>  
> diff --git a/Documentation/trace/remotes.rst b/Documentation/trace/remotes.rst
> new file mode 100644
> index 000000000000..1f9d764f69aa
> --- /dev/null
> +++ b/Documentation/trace/remotes.rst
> @@ -0,0 +1,66 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +===============
> +Tracing Remotes
> +===============
> +
> +:Author: Vincent Donnefort <vdonnefort@google.com>
> +
> +Overview
> +========
> +Firmware and hypervisors are black boxes to the kernel. Having a way to see what
> +they are doing can be useful to debug both. This is where remote tracing buffers
> +come in. A remote tracing buffer is a ring buffer executed by the firmware or
> +hypervisor into memory that is memory mapped to the host kernel. This is similar
> +to how user space memory maps the kernel ring buffer but in this case the kernel
> +is acting like user space and the firmware or hypervisor is the "kernel" side.
> +With a trace remote ring buffer, the firmware and hypervisor can record events
> +for which the host kernel can see and expose to user space.
> +
> +Register a remote
> +=================
> +A remote must provide a set of callbacks `struct trace_remote_callbacks` whom
> +description can be found below. Those callbacks allows Tracefs to enable and
> +disable tracing and events, to load and unload a tracing buffer (a set of
> +ring-buffers) and to swap a reader page with the head page, which enables
> +consuming reading.
> +
> +.. kernel-doc:: include/linux/trace_remote.h
> +
> +Once registered, an instance will appear for this remote in the Tracefs
> +directory **remotes/**. Buffers can then be read using the usual Tracefs files
> +**trace_pipe** and **trace**.
> +
> +Declare a remote event
> +======================
> +Macros are provided to ease the declaration of remote events, in a similar
> +fashion to in-kernel events. A declaration must provide an ID, a description of
> +the event arguments and how to print the event:
> +
> +.. code-block:: c
> +
> +	REMOTE_EVENT(foo, EVENT_FOO_ID,
> +		RE_STRUCT(
> +			re_field(u64, bar)
> +		),
> +		RE_PRINTK("bar=%lld", __entry->bar)
> +	);
> +
> +Then those events must be declared in a C file with the following:
> +
> +.. code-block:: c
> +
> +	#define REMOTE_EVENT_INCLUDE_FILE foo_events.h
> +	#include <trace/define_remote_events.h>
> +
> +This will provide a `struct remote_event remote_event_foo` that can be given to
> +`trace_remote_register`.
> +
> +Registered events appear in the remote directory under **events/**.
> +
> +Simple ring-buffer
> +==================
> +A simple implementation for a ring-buffer writer can be found in
> +kernel/trace/simple_ring_buffer.c.
> +
> +.. kernel-doc:: include/linux/simple_ring_buffer.h

