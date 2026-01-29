Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A12A2EBBB9
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 17:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769706986; cv=none; b=hIq3WVtcMIXYzF86286nHStbTdQ32x7hIzVvC+1r4bQtkEYpdo34Jo+eyrY4AvVYijPC/1HFauVLXB3eo9CyS4rcDdOYfcl1PLCFKDFvOjCg2ETOEwX5Jk0CZjjJn/ABo+GBv0mWQYvwK7stKXpm1FOxvY9qmgXPJeju1DfghvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769706986; c=relaxed/simple;
	bh=DIkei0jGJGVjvv+44OMHHbjC1UWjNUL77TpE3HQ3Xao=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BDdFaZmPeB2OoAqMEmpvZeoWQgmPKo8xkKGJsU1NwhB33dvb59u2T4sNYq6i3zNoyrqUUVGJBgS2CbI29iu6ro9U+ycDtbgyozruYNJn5cqjazLm2pnFUSoxJRIuGfHl7HRJ2zh0zCV25hh6/is+V0zWTqS98w3pfTXrFhAr474=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8751014021A;
	Thu, 29 Jan 2026 17:16:21 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 102F12000F;
	Thu, 29 Jan 2026 17:16:17 +0000 (UTC)
Date: Thu, 29 Jan 2026 12:16:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 16/30] Documentation: tracing: Add tracing remotes
Message-ID: <20260129121629.25d2c0e7@gandalf.local.home>
In-Reply-To: <20260126104419.1649811-17-vdonnefort@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
	<20260126104419.1649811-17-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ep3s1nwcwmudotqgrz3cu4m49n43768g
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 102F12000F
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19OPa/5QA9e3E6X19QE/d51EwPPz+it7TM=
X-HE-Tag: 1769706977-932958
X-HE-Meta: U2FsdGVkX19rPg+Qy8EyT28SApcghYzFdXkz9xvvD7CIbLz103mrT0yJNlOT43RNRaEB2ftg2o3Hy8+zeKfP59e+pxkTjKhBEkbvmdiL0/zaEd/WdFLM/gHZ9TRg/VXh6GmRt8MorrTZ6XTgzcldknrru07NbUwrHldiCv1GmxdLF+yKGZ2O5HwAFb8yHROm+rW/lZCOKjHHxojmSSdpMRdbjDX028QzVSjaOaaQMqJNl0y0UU/rm2lH/b/hR8feFYVOuQJogjWvygcnbvO56WzyMOUHR88rALpeqM4wWwSYi0UbvTsrM3hs+19n6p88zHkpOjuaC8a2jkKmmdenESn4aSk7CDWL3F+GP+Qr8WowJILBub2zV9kEYBd8JRE5

On Mon, 26 Jan 2026 10:44:05 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> Add documentation about the newly introduced tracing remotes framework.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
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
> index 000000000000..e7fb3ee96c30
> --- /dev/null
> +++ b/Documentation/trace/remotes.rst
> @@ -0,0 +1,59 @@
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

Probably should start off with the rationale for remotes. Perhaps start
with something like:

  Firmware and pkvm hypervisors are black boxes to the kernel. Having a way
  to see what they are doing can be useful to debug both. This is where
  remote tracing buffers come in. A remote tracing buffer is a ring buffer
  executed by the firmware or hypervisor into memory that is memory mapped
  to the host kernel. This is similar to how user space memory maps the
  kernel ring buffer but in this case the kernel is acting like user space
  and the firmware or hypervisor is the "kernel" side. With a trace remote
  ring buffer, the firmware and hypervisor can record events for which the
  host kernel can see and expose to user space.

But we can expand on this later. The above should be the minimum added to
allow people to understand why this is being created.

-- Steve

> +A trace remote relies on ring-buffer remotes to read and control compatible
> +tracing buffers, written by entity such as firmware or hypervisor.
> +
> +Once registered, a tracefs instance will appear for this remote in the Tracefs
> +directory **remotes/**. This remote can be read and controlled using the same
> +files as regular Tracefs instances such as **trace_pipe**, **tracing_on** or
> +**trace**.
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
> +Simple ring-buffer
> +==================
> +A simple implementation for a ring-buffer writer can be found in
> +kernel/trace/simple_ring_buffer.c.
> +
> +.. kernel-doc:: include/linux/simple_ring_buffer.h

