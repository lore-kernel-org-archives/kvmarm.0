Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24C6239E7E
	for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 12:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769864064; cv=none; b=fnwHm374m4/VanJqFtw8cAsqLDWM52aDJMrIQhpGEf/IOxpHWntGqdRsqUOhMqP5qdXGYVqOM5BZR+wbJ9TKM7xVJKEsQDMCx/nnZzTvMRO/9fCbqqbMHsUga2dhzjzAiKOEqVfcmJiTDP+gmZF8zup0+X/uyzD0gK3eX5V3q6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769864064; c=relaxed/simple;
	bh=SfsGBbXvkK2Pji1/B334fbzwCU/3TbY4g0oKDz9nKwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WnRIqjhELpgvBgCtCC4WfPZLiSnR0ItsanfCJEUJrd+Q2AUFrhtFNQKoc0XHmToaDeUGvOHrALDrWdSzyie/uQ0D6xZ0ASDBhbghGWUUUjiZlVDe1zZPgKI2c09ld3NNirUg7u7fAJZwvHGoZUHYUsTnkIpwLIv4S66bVk4fEpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m2wIGTud; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m2wIGTud"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4807068eacbso24866995e9.2
        for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 04:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769864061; x=1770468861; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o2hEtjB3vGUr1RvLvra8FnQ23d7eG/R6cE9Zgtr/AEg=;
        b=m2wIGTudkZzSUcAy+wA1uOqJvQhNnqyrxziwxJzV7konSfxZg+u/5np375xhJNwdiS
         ZScf4QwMjP5j0aQRDSJx6nehTx1W5cb7e1yP+vZEwa5xa4gIENYG/hE0Mh/uPIPP4y6T
         m0WlMe2k390BYJUDfroWBb/O7AMzerDlBgxXUbJ6+6q5hguxbTsJKlemIr2ffaVe3uwV
         1InndgbAyQEYNvWqpIUGMy1oPP3M4xz/OtlyMjPdfMI2g+g7kWVLSPG2kFS/AggBHUyd
         KPiaJgwsDZhCV5QF4F1p0HN56PS5wRu7y1Hh3ov2L94enG+PP0lUxhbiaJRvmYIrFRkz
         X4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769864061; x=1770468861;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o2hEtjB3vGUr1RvLvra8FnQ23d7eG/R6cE9Zgtr/AEg=;
        b=Qj5l4BWlKnN+En4VxXvVuKPKXQGpUnAJY1LNeClDiSsmk5iLbf13YXghqklVXDgkTg
         gCAD4qWmKRayE941hcpz2x5f5NYEtflCdXcwV7VEmTV9Wwkho30FDde4IYhT7UxPDKWU
         lCmMe5PzAGwFj4hZNSJ47V1+ygiHtg+jRLr2GweFzNBYa/pIKxe0zBPKCGRvOC0xHBDT
         rAOE2RUFWMmhoCdAVYXwOpJaFXEPiUP1Ir52heyAYI1jmFwdOfbTQ8BUYDMa0Bl04rWd
         +8xHEqT1+bBIs37++RdrS9xxGRHubLIArT1Ypag3BThqthD2K5qL4i003JsPUI1kzwk/
         /u0w==
X-Forwarded-Encrypted: i=1; AJvYcCVrmSyw+V41D7AOOkiznmK99+urcBuG0q2MNA1XwftMO4Bq9LwnVq4TwEAjZhKsV+3m081kE24=@lists.linux.dev
X-Gm-Message-State: AOJu0YzY2q6snDU+CVmoF+hpSHJxeogFJPffjYRUd47N1sWxX+NtjFpM
	tjeHiWFythj7Nen5z6/EWqO1hfuUEMAWASQG+DceyeAYECCqz7gdnhHgucmGhINrAw==
X-Gm-Gg: AZuq6aJmFmfjPvaiGUCxLhEBdQdnHVak88ZWPFg27KyfYMxKQQ0cRu2tFQcZWBl1M/E
	+osTjqAWX8pyJz0Naavj/bJALvkMI2YzVlER8OcUm/2LGQyt8j7gLnDsl3+upe+s5LisAZmRQGy
	cCqTASCPZSxbIePXrKN1OlGZmBqb8idLGHJs/hCvYaFcOGs2flZxAAfbnMIgoD2SXNzP5o4F2nL
	B05bbb/KUhFki9Gi0wc0eicVwSUnu/iSJEQ5hlcRslv6USGAtxRSM10CbNRjX8uSEtk7AFN1f5v
	MiAEilJXGfB/ZwbL0MCpNLhmlSRf/0/98zLCRnmkp+Ik3kG4j3EgNeo9FrJhJza9iJT+I1S0P8C
	FgZPCs/3DibAGSCDAyBhXH7O5AvsnMcIEsslfPcavMMFhElOnNGdQ3ImE1uJ12xzGmZxCm77/3o
	9NJTfwRcw5ASrDfjqNtK8PbXEIvoAAGd38xfApxa2IvVL1vg5xLA==
X-Received: by 2002:a05:600c:c0cd:b0:471:700:f281 with SMTP id 5b1f17b1804b1-482db623765mr62756295e9.25.1769864060981;
        Sat, 31 Jan 2026 04:54:20 -0800 (PST)
Received: from google.com (44.145.34.34.bc.googleusercontent.com. [34.34.145.44])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e10e483asm28108377f8f.3.2026.01.31.04.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jan 2026 04:54:20 -0800 (PST)
Date: Sat, 31 Jan 2026 12:54:17 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 14/30] tracing: Add a trace remote module for testing
Message-ID: <aX37eRjYBP4WmyS6@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
 <20260126104419.1649811-15-vdonnefort@google.com>
 <20260129113452.190d4d79@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129113452.190d4d79@gandalf.local.home>

On Thu, Jan 29, 2026 at 11:34:52AM -0500, Steven Rostedt wrote:
> On Mon, 26 Jan 2026 10:44:03 +0000
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> > diff --git a/kernel/trace/remote_test.c b/kernel/trace/remote_test.c
> > new file mode 100644
> > index 000000000000..059127489c99
> > --- /dev/null
> > +++ b/kernel/trace/remote_test.c
> > @@ -0,0 +1,259 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2025 - Google LLC
> > + * Author: Vincent Donnefort <vdonnefort@google.com>
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/simple_ring_buffer.h>
> > +#include <linux/trace_remote.h>
> > +#include <linux/tracefs.h>
> > +#include <linux/types.h>
> > +
> > +#define REMOTE_EVENT_INCLUDE_FILE kernel/trace/remote_test_events.h
> > +#include <trace/define_remote_events.h>
> > +
> > +static DEFINE_PER_CPU(struct simple_rb_per_cpu *, simple_rbs);
> > +static struct trace_buffer_desc *remote_test_buffer_desc;
> > +
> > +/*
> > + * The trace_remote lock already serializes accesses from the trace_remote_callbacks.
> > + * However write_event can still race with load/unload.
> > + */
> > +static DEFINE_MUTEX(simple_rbs_lock);
> > +
> > +static int remote_test_load_simple_rb(int cpu, struct ring_buffer_desc *rb_desc)
> > +{
> > +	struct simple_rb_per_cpu *cpu_buffer;
> > +	struct simple_buffer_page *bpages;
> > +	int ret = -ENOMEM;
> > +
> > +	cpu_buffer = kmalloc(sizeof(*cpu_buffer), GFP_KERNEL);
> > +	if (!cpu_buffer)
> > +		return ret;
> > +
> > +	bpages = kmalloc_array(rb_desc->nr_page_va, sizeof(*bpages), GFP_KERNEL);
> > +	if (!bpages)
> > +		goto err_free_cpu_buffer;
> > +
> > +	ret = simple_ring_buffer_init(cpu_buffer, bpages, rb_desc);
> > +	if (ret)
> > +		goto err_free_bpages;
> > +
> > +	scoped_guard(mutex, &simple_rbs_lock)
> > +		*per_cpu_ptr(&simple_rbs, cpu) = cpu_buffer;
> 
> Should there be some kind of check before blindly assigning the cpu_buffer?
> If not, what is the mutex protecting from?

This intends to order accesses with write_event_write(). trace_remote ensures
that load/unload are always balanced, so I don't believe there's anything to
test.

I could add a WARN_ON though. and probably guard(mutex)(&simple_rbs_lock) is
enough.

> 
> 
> > +
> > +	return 0;
> > +
> > +err_free_bpages:
> > +	kfree(bpages);
> > +
> > +err_free_cpu_buffer:
> > +	kfree(cpu_buffer);
> > +
> > +	return ret;
> > +}
> > +
> > +static void remote_test_unload_simple_rb(int cpu)
> > +{
> > +	struct simple_rb_per_cpu *cpu_buffer = *per_cpu_ptr(&simple_rbs, cpu);
> > +	struct simple_buffer_page *bpages;
> > +
> > +	if (!cpu_buffer)
> > +		return;
> > +
> > +	guard(mutex)(&simple_rbs_lock);
> > +
> > +	bpages = cpu_buffer->bpages;
> > +	simple_ring_buffer_unload(cpu_buffer);
> > +	kfree(bpages);
> > +	kfree(cpu_buffer);
> > +	*per_cpu_ptr(&simple_rbs, cpu) = NULL;
> > +}
> > +
> > +static struct trace_buffer_desc *remote_test_load(unsigned long size, void *unused)
> > +{
> > +	struct ring_buffer_desc *rb_desc;
> > +	struct trace_buffer_desc *desc;
> > +	size_t desc_size;
> > +	int cpu, ret;
> > +
> > +	if (WARN_ON(remote_test_buffer_desc))
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	desc_size = trace_buffer_desc_size(size, num_possible_cpus());
> > +	if (desc_size == SIZE_MAX) {
> > +		ret = -E2BIG;
> > +		goto err_unlock_cpus;
> > +	}
> > +
> > +	desc = kmalloc(desc_size, GFP_KERNEL);
> > +	if (!desc) {
> > +		ret = -ENOMEM;
> > +		goto err_unlock_cpus;
> > +	}
> > +
> > +	ret = trace_remote_alloc_buffer(desc, desc_size, size, cpu_possible_mask);
> > +	if (ret)
> > +		goto err_free_desc;
> > +
> > +	for_each_ring_buffer_desc(rb_desc, cpu, desc) {
> > +		ret = remote_test_load_simple_rb(rb_desc->cpu, rb_desc);
> > +		if (ret)
> > +			goto err;
> > +	}
> > +
> > +	remote_test_buffer_desc = desc;
> > +
> > +	return remote_test_buffer_desc;
> > +
> > +err:
> > +	for_each_ring_buffer_desc(rb_desc, cpu, remote_test_buffer_desc)
> > +		remote_test_unload_simple_rb(rb_desc->cpu);
> > +	trace_remote_free_buffer(remote_test_buffer_desc);
> > +
> > +err_free_desc:
> > +	kfree(desc);
> > +
> > +err_unlock_cpus:
> 
> Where was the cpus_read lock taken?
> 
> > +	cpus_read_unlock();
> > +
> > +	return ERR_PTR(ret);
> > +}
> > +
> > +static void remote_test_unload(struct trace_buffer_desc *desc, void *unused)
> > +{
> > +	struct ring_buffer_desc *rb_desc;
> > +	int cpu;
> > +
> > +	if (WARN_ON(desc != remote_test_buffer_desc))
> > +		return;
> > +
> > +	for_each_ring_buffer_desc(rb_desc, cpu, desc)
> > +		remote_test_unload_simple_rb(rb_desc->cpu);
> > +
> > +	remote_test_buffer_desc = NULL;
> > +	trace_remote_free_buffer(desc);
> > +	kfree(desc);
> > +}
> > +
> > +static int remote_test_enable_tracing(bool enable, void *unused)
> > +{
> > +	struct ring_buffer_desc *rb_desc;
> > +	int cpu;
> > +
> > +	if (!remote_test_buffer_desc)
> > +		return -ENODEV;
> > +
> > +	for_each_ring_buffer_desc(rb_desc, cpu, remote_test_buffer_desc)
> > +		WARN_ON(simple_ring_buffer_enable_tracing(*per_cpu_ptr(&simple_rbs, rb_desc->cpu),
> > +							  enable));
> > +	return 0;
> > +}
> > +
> > +static int remote_test_swap_reader_page(unsigned int cpu, void *unused)
> > +{
> > +	struct simple_rb_per_cpu *cpu_buffer;
> > +
> > +	if (cpu >= NR_CPUS)
> > +		return -EINVAL;
> > +
> > +	cpu_buffer = *per_cpu_ptr(&simple_rbs, cpu);
> > +	if (!cpu_buffer)
> > +		return -EINVAL;
> > +
> > +	return simple_ring_buffer_swap_reader_page(cpu_buffer);
> > +}
> > +
> > +static int remote_test_reset(unsigned int cpu, void *unused)
> > +{
> > +	struct simple_rb_per_cpu *cpu_buffer;
> > +
> > +	if (cpu >= NR_CPUS)
> > +		return -EINVAL;
> > +
> > +	cpu_buffer = *per_cpu_ptr(&simple_rbs, cpu);
> > +	if (!cpu_buffer)
> > +		return -EINVAL;
> > +
> > +	return simple_ring_buffer_reset(cpu_buffer);
> > +}
> > +
> > +static int remote_test_enable_event(unsigned short id, bool enable, void *unused)
> > +{
> > +	if (id != REMOTE_TEST_EVENT_ID)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * Let's just use the struct remote_event enabled field that is turned on and off by
> > +	 * trace_remote. This is a bit racy but good enough for a simple test module.
> > +	 */
> > +	return 0;
> > +}
> > +
> > +static ssize_t
> > +write_event_write(struct file *filp, const char __user *ubuf, size_t cnt, loff_t *pos)
> > +{
> > +	struct remote_event_format_selftest *evt_test;
> > +	struct simple_rb_per_cpu *cpu_buffer;
> > +	unsigned long val;
> > +	int ret;
> > +
> > +	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	guard(mutex)(&simple_rbs_lock);
> > +
> > +	if (!remote_event_selftest.enabled)
> > +		return -ENODEV;
> > +
> 
> You want a guard(preempt)(); here...
> 
> > +	cpu_buffer = *this_cpu_ptr(&simple_rbs);
> 
> Otherwise this triggers:
> 
>  BUG: using smp_processor_id() in preemptible [00000000] code: bash/1096
>  caller is write_event_write+0xe0/0x230 [remote_test]
> 
> -- Steve
> 
> > +	if (!cpu_buffer)
> > +		return -ENODEV;
> > +
> > +	evt_test = simple_ring_buffer_reserve(cpu_buffer,
> > +					      sizeof(struct remote_event_format_selftest),
> > +					      trace_clock_global());
> > +	if (!evt_test)
> > +		return -ENODEV;
> > +
> > +	evt_test->hdr.id = REMOTE_TEST_EVENT_ID;
> > +	evt_test->id = val;
> > +
> > +	simple_ring_buffer_commit(cpu_buffer);
> > +
> > +	return cnt;
> > +}
> > +
