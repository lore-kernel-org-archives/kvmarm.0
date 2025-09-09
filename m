Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EFD31B119
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 12:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757419717; cv=none; b=lu4q3cogn9mQ3sO60iCU3YArskou1gYry+XdgzuIRVmPuYGyA1rmNXAXOafKFbHv4cg6kCVtbbuH8iwLlmQ3zMOAFHvHQZh9NcE+n9SSwywDfRKX6iQW/fh6aK/VVR+lRUpL+W3Go2zz/s5BuTNKST5jGCIdy054Ig0JMF6oxY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757419717; c=relaxed/simple;
	bh=e2bY/7qkyaiM/i1NmIYcr9PECxFTLhoEx9C77uMaccw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UkOe09xfdOREL9pUDP6qItZs3Nj3UMKPfpUCam8Us/qxerLEOxeBjtWt7Uzv9kixsaWuSCk9dNbqN2LQAGPL9+INd1kJ+KnhaY32KADJQ42D3I7SxmvCSw4o0ytwAHhbECD5+RRHhZoO+4AecttZOQsrotPCZRjET6meVH/rJj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SrVE4zjE; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SrVE4zjE"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3c6abcfd142so2745248f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 05:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757419713; x=1758024513; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M7vDbC+h+/IIbH/cXwkOmZAco4ey3LkcdIeQn9K9PmM=;
        b=SrVE4zjEXXhtEd4nVYjDPcJyZxl+/XY//BGCR6RsD6uqLV1IQtHe+ob/NzYjRD7DV0
         mFshFbxR3xszARpgdx4UgpStDOSZemMRhd9CHsru96IjJckxtVeAjuMejkvd2isvp9H4
         d1nMoIJr19l86PPVb+MxccW/HlEe2CGla8r4F7idjpGixMMQW5NO+7fx1YP0yRBPj+k1
         ldNqIszjpuur5FIylW1EfXRQVGIG9L8hoPJoqe97GfPDgLKJyWXv2P718F+5Dg1ZiAJ4
         i8PKlbSNJQ7/iHC9nuFLmyDSsn0v/WBnrs00xE1arMt6pKarLH11HKHG85QNfTAFwZ9a
         dRGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757419713; x=1758024513;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M7vDbC+h+/IIbH/cXwkOmZAco4ey3LkcdIeQn9K9PmM=;
        b=saJE86mD3GPcmWow8a5hZ4RsgIBHn/VO7fNbarTprtgzHi63in0djmbK5iGsEXkUDL
         kAQZnWhZ6JA9MWu2E6hw5rPa6FtbMNkRa3onAOLC/g0groY28sNr702DOZ5d2WiYJdkE
         rRaWNEGKSncMZwPf4LMIZPqlR+UmWDP1rjGMdkEAmbD7yWlqMYa9yLrQctXXdO81Lk9A
         WD+9my8pfrZtG7goPfruoVgZHZB5/JbKoldQjBKGeeb1dmZZ1U2DJ/+Rblzdcgilz55h
         noBuBGZv9oRBh17kQauW1QIHIm91oJI9ZfwrO1BGvvOHxHzkwtN2cVYKbcPMxYhlHtej
         xsUw==
X-Forwarded-Encrypted: i=1; AJvYcCVS05EpaJrkfZGLvqS70Zc1P0YiDhZjvy5QmCCWoVvOxuH7huUKZaptklN4nYsvYZObo/HQBa0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyCO7EuoGr8Q9fFf8tJsfVrncVtMwiGbinhjFAd+XZcA+0aPEGL
	smCYAKZB3B5ky8AUMX+ekRs7W/5QJMRksEIo3n2uaBr9EK1rCH3E9Pu4DB045pGyvA==
X-Gm-Gg: ASbGnctS1E63USM/EKga0j+6BPvD8mOfKVkNc91mK6SJKGWnTOmaK6PYsMauOFngswP
	3OyjBiSxD8eRmAQ/dKfcLVFZyFQximuQCL2NFxezhM4efTYYEqwkkGIMEJTrBvwYoyGqTUhWqnl
	QCeIUcqP0fXYLBkTiy4XvL8D9p8eoLPclEiUUfSSD9fwhBpMXED8v6WfDEAfSZbyVyE/IrMfwax
	Y3yrTizshVRgvodZcXcpz1GqSClcTZsBI+FXh8ftelAOCUkOnUneiiFMdvgEsqEZHV6LHtHwnZi
	Ee4OZ54BM2nXUbQpXmSEDEdTy7oQHhGC66YbnM+yfNBxQ47tPLrf0IM9FFvwgXdAMbIizWcmm5d
	gr6yLwD8sGTyZNxd0bcpkWg2pBzsIeiO2IxDqxBwdyzS4DG2UE0yTLqEO0bG3mBsp4ij/ODHpV+
	8RyuCE
X-Google-Smtp-Source: AGHT+IEmpSA1PmUMsgcmd2ZNoedzp7F9aWzukj/yEFhZuO5KFbaj8r4hHCaj2MqwR9Y8LELRFzynbQ==
X-Received: by 2002:a05:6000:2486:b0:3e7:490c:1a2 with SMTP id ffacd0b85a97d-3e7490c049dmr6915730f8f.10.1757419712364;
        Tue, 09 Sep 2025 05:08:32 -0700 (PDT)
Received: from google.com (211.29.195.35.bc.googleusercontent.com. [35.195.29.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7521c9cb9sm2559883f8f.20.2025.09.09.05.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 05:08:31 -0700 (PDT)
Date: Tue, 9 Sep 2025 13:08:28 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 03/24] tracing: Introduce trace remotes
Message-ID: <aMAYvA9LSvfxvt_C@google.com>
References: <20250821081412.1008261-1-vdonnefort@google.com>
 <20250821081412.1008261-4-vdonnefort@google.com>
 <20250908193606.47143d09@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908193606.47143d09@gandalf.local.home>

On Mon, Sep 08, 2025 at 07:36:05PM -0400, Steven Rostedt wrote:
> On Thu, 21 Aug 2025 09:13:51 +0100
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> > A trace remote relies on ring-buffer remotes to read and control
> > compatible tracing buffers, written by entity such as firmware or
> > hypervisor.
> > 
> > Add a Tracefs directory remotes/ that contains all instances of trace
> > remotes. Each instance follows the same hierarchy as any other to ease
> > the support by existing user-space tools.
> > 
> > This currently does not provide any event support, which will come
> > later.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/include/linux/trace_remote.h b/include/linux/trace_remote.h
> > new file mode 100644
> > index 000000000000..de043a6f2fe0
> > --- /dev/null
> > +++ b/include/linux/trace_remote.h
> > @@ -0,0 +1,21 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +#ifndef _LINUX_TRACE_REMOTE_H
> > +#define _LINUX_TRACE_REMOTE_H
> > +
> > +#include <linux/ring_buffer.h>
> > +
> > +struct trace_remote_callbacks {
> > +	struct trace_buffer_desc *
> > +		(*load_trace_buffer)(unsigned long size, void *priv);
> 
> I believe this is one of those cases where the 80 char limit is more of a
> guildline than a rule. It looks better to keep the above as one line.
> 
> > +	void	(*unload_trace_buffer)(struct trace_buffer_desc *desc, void *priv);
> 
> Heck, this is already passed 80 characters ;-)
> 
> > +	int	(*enable_tracing)(bool enable, void *priv);
> > +	int	(*swap_reader_page)(unsigned int cpu, void *priv);
> > +};
> > +
> > +int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs, void *priv);
> > +int trace_remote_alloc_buffer(struct trace_buffer_desc *desc, size_t size,
> > +			      const struct cpumask *cpumask);
> > +void trace_remote_free_buffer(struct trace_buffer_desc *desc);
> > +
> > +#endif
> > diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > index d2c79da81e4f..99af56d39eaf 100644
> > --- a/kernel/trace/Kconfig
> > +++ b/kernel/trace/Kconfig
> > @@ -1238,4 +1238,7 @@ config HIST_TRIGGERS_DEBUG
> >  
> 
> 
> > +
> > +int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs, void *priv)
> > +{
> > +	struct trace_remote *remote;
> > +
> > +	remote = kzalloc(sizeof(*remote), GFP_KERNEL);
> > +	if (!remote)
> > +		return -ENOMEM;
> > +
> > +	remote->cbs = cbs;
> > +	remote->priv = priv;
> > +	remote->trace_buffer_size = 7 << 10;
> > +	remote->poll_ms = 100;
> 
> What's with the magic numbers?

The 7KiB value can be modified with the tracefs file buffer_size_kb.

the 100ms can't be modified. I could either make a tracefs file or just a
trace_remote_set_poll_ms() function so it can be modified after registration.

In all cases, I'll add a TRACE_REMOTE_DEFAULT_XXXX definition at the start of
the file.

> 
> > +	mutex_init(&remote->lock);
> > +
> > +	if (trace_remote_init_tracefs(name, remote)) {
> > +		kfree(remote);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +void trace_remote_free_buffer(struct trace_buffer_desc *desc)
> > +{
> > +	struct ring_buffer_desc *rb_desc;
> > +	int cpu;
> > +
> > +	for_each_ring_buffer_desc(rb_desc, cpu, desc) {
> > +		unsigned int id;
> > +
> > +		free_page(rb_desc->meta_va);
> > +
> > +		for (id = 0; id < rb_desc->nr_page_va; id++)
> > +			free_page(rb_desc->page_va[id]);
> > +	}
> > +}
> > +
> > +int trace_remote_alloc_buffer(struct trace_buffer_desc *desc, size_t size,
> > +			      const struct cpumask *cpumask)
> > +{
> > +	int nr_pages = (PAGE_ALIGN(size) / PAGE_SIZE) + 1;
> > +	struct ring_buffer_desc *rb_desc;
> > +	int cpu;
> > +
> > +	desc->nr_cpus = 0;
> > +	desc->struct_len = offsetof(struct trace_buffer_desc, __data);
> 
> The above is better as:
> 
> 	desc->struct_len = struct_size(desc, __data, 0);
> 
> As it also does some other checks, like make sure __data is a flexible
> array.
> 
> > +
> > +	rb_desc = (struct ring_buffer_desc *)&desc->__data[0];
> > +
> > +	for_each_cpu(cpu, cpumask) {
> > +		unsigned int id;
> > +
> > +		rb_desc->cpu = cpu;
> > +		rb_desc->nr_page_va = 0;
> > +		rb_desc->meta_va = (unsigned long)__get_free_page(GFP_KERNEL);
> > +		if (!rb_desc->meta_va)
> > +			goto err;
> > +
> > +		for (id = 0; id < nr_pages; id++) {
> > +			rb_desc->page_va[id] = (unsigned long)__get_free_page(GFP_KERNEL);
> > +			if (!rb_desc->page_va[id])
> 
> What exactly are these pages allocated for? Is this what the remote will
> use to write to? There should be more comments about how this is used.

Those are the actual ring-buffer data pages. I'll add a comment here.
> 
> > +				goto err;
> > +
> > +			rb_desc->nr_page_va++;
> > +		}
> > +		desc->nr_cpus++;
> > +		desc->struct_len += offsetof(struct ring_buffer_desc, page_va);
> > +		desc->struct_len += sizeof(rb_desc->page_va[0]) * rb_desc->nr_page_va;
> 
> Shouldn't the above be:
> 
> 		desc->struct_len += struct_size(rb_desc, page_va, rb_desc->nr_page_va);
> 
> ?

Yes, that'd look way better.

> 
> > +		rb_desc = __next_ring_buffer_desc(rb_desc);
> 
> Is there no check to make sure that the cpu mask matches what the rb_desc
> will have?

The function is filling rb_desc[], based on the cpumask input, so both will
match when returning from this function.
It is then easy to handle the case where some CPUs are not part of the cpumask.
See remote_test_load() where for_each_ring_buffer_desc() iterates over all the
CPUs from the trace_desc but uses rb_desc->cpu.

Is it what you meant?

> 
> -- Steve
> 
> > +	}
> > +
> > +	return 0;
> > +
> > +err:
> > +	trace_remote_free_buffer(desc);
> > +	return -ENOMEM;
> > +}
> 
