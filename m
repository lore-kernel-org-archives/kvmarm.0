Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00C52EAB88
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 16:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757434224; cv=none; b=ko7V+ssm6SlXY5+hcX1Kv9hspgTYe6pVQCq17+AatVl3dwhDyu6uUg+prEFfp1/LREN+ZukMERTJ+wS1Nnk49SqXKlGuvgycKIL6anQ17L6JEgUWkB+yX9dBDZzKFKNSq/H0PG9ijwAJ2Y4tJ9EeANqvoCRZvgGdZG0P8Eh2Y7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757434224; c=relaxed/simple;
	bh=bvmtY118txyjfxnCSpGNzanxwErszIEgZjkDshuNbJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QMH6FNETw1CBQZtJnDRUZNBJzmOBjVGE5gbk8EVQWMxJ2IryUO146+rbVgr2BjzHWyk4gFEyb4AhSC1DDWSlAl3orWVHDYw4D7rUk64sG/wSuywUgt8YzJGPY/hcBqLYidZ9+CWw1FiqoHcc0ylXtNhdv9StP4UoonfkZBAEhkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xd2+qh9c; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xd2+qh9c"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3dad6252eacso2666844f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 09:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757434221; x=1758039021; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J+NppKLzVrIsIoSaivdIxFGudWC05VGLRO9K0C3DxKA=;
        b=Xd2+qh9cPjfwfUxr6gKOgQrPFLbI4dSevJVm6QDQzDBT75p/TrO9fDEJGAVWTd3+j5
         UZ1wztpXuKpwCXael2GOT0bbC3g2fjiMe/ABpHp0/B3nxotimLT4YZAs6NnUfufrEaxI
         QspqDM6LRbXsnsdAca8VQB50PIKA6Mun4KYwsrEIsiMe06INjLZiHLPWeQqLuaCgZ9mM
         k7gmjMW3ABWo1J/abQwLGeS5Q2TzKSRW9p9k8iLr4DVJRFtNCQfuXUufQqj92JGBqPHq
         gDI4xWx4mz5FprDbQdit+23YhlBu+zaqz4Ah1DoeDJdsreql1k8HqZ3AUJkEV9WF3ePZ
         xXEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757434221; x=1758039021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+NppKLzVrIsIoSaivdIxFGudWC05VGLRO9K0C3DxKA=;
        b=GNDOw6xNpjJl/qTyVjauvj2U8PX1/2rXRe5HrMxuj1KohP6YS9SCAyBmnRjp67ikzn
         6bpJtORRPA4eft9c1DKEyUw61ORymrNb855zXMWUnXlM3uRwZ+5kuvJwC4KuekDkDh5m
         r3mrwBgE77NZzCtX9OMDRNRrI0gyaonGzdYskkypmUe4pLb6zV0iEGv6csbXucvh4tWe
         TgxcTtM2aoxE1iVjCJtX+Mh73eBzQ4+iLNlzJuXoOYHf6DxskMrxVo+n7hdG6yatZXHb
         rj0H+t3dHYha4gxPKDAmjxexPKNjUQ5WLCsohAs1KM0U9TFyfOVCAmXJJohLD/wda3ss
         RQ1g==
X-Forwarded-Encrypted: i=1; AJvYcCUQYxs0381WemUxjvw69ZWa036DbiBPdJRRl4RqQ61kHWscMv/NkVA/tbq5aB3mVaEnQZT4aaA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwppNrICDMRoc7Cq7krmFJpXFn9QCJyuxfzJIjDazUf9qz6XSlp
	0fYeDzBQ+6p0JKCKmtW9Wwtx9YYAoYb8orqsaeRwFni8PyomvFgFOiOfQ5dc88cknA==
X-Gm-Gg: ASbGncsSENdkoDnax4BKiolgXSh2oP6A0yG/4Q5bVD/1ZUQoNmq5shP7jg7yUaoxs9G
	5a/1BTUHrboOY9jBhykiNRcY27VMj2SJgeswAsOnBwc0tarP1248jAki/jrW9kB7eKtBFfKeOHP
	PjCypRiSE/idMoI3xfechFawJAruSnoBhnmthLzuF0m7mfcKSbFCsmm7uFQB4G0ScTXdNdhZyEu
	2UJHWrSLdBiV/1QEl/DGFbUQOVLKvd5ukcsoeTID+XrO5lCincSDDbSDHNDi/TfQ2L/lD/S1muT
	eG9RSQefZuNB+G6WRn7aYhgNJ16jtYgF3Ix/91DaPdYrNUlvbno/aZdMuf9IaSQa03yZzD9f9Bs
	u7ZQWHHgcXMz+0g1cn7aqE/iw7yQ7+eUHQHjNTLAsyecLaMMoe5xD2KcrCsCkE9tubxNXcUHOFP
	igm7zk
X-Google-Smtp-Source: AGHT+IEcQIe0OC8lSfD+aiR6eeprIeDl6s8EC4O8tczqPnzu992yeZRmguAnbDmw2y0KnALeXMKgPg==
X-Received: by 2002:a05:6000:1449:b0:3e4:ea11:f7df with SMTP id ffacd0b85a97d-3e64392b8c4mr12530932f8f.40.1757434220628;
        Tue, 09 Sep 2025 09:10:20 -0700 (PDT)
Received: from google.com (211.29.195.35.bc.googleusercontent.com. [35.195.29.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e752238910sm3069080f8f.41.2025.09.09.09.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 09:10:19 -0700 (PDT)
Date: Tue, 9 Sep 2025 17:10:16 +0100
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
Message-ID: <aMBRaPzjR4OJVIWn@google.com>
References: <20250821081412.1008261-1-vdonnefort@google.com>
 <20250821081412.1008261-4-vdonnefort@google.com>
 <20250908193606.47143d09@gandalf.local.home>
 <aMAYvA9LSvfxvt_C@google.com>
 <20250909093848.402674b7@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909093848.402674b7@gandalf.local.home>

On Tue, Sep 09, 2025 at 09:38:48AM -0400, Steven Rostedt wrote:
> On Tue, 9 Sep 2025 13:08:28 +0100
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> > > > +		rb_desc = __next_ring_buffer_desc(rb_desc);  
> > > 
> > > Is there no check to make sure that the cpu mask matches what the rb_desc
> > > will have?  
> > 
> > The function is filling rb_desc[], based on the cpumask input, so both will
> > match when returning from this function.
> > It is then easy to handle the case where some CPUs are not part of the cpumask.
> > See remote_test_load() where for_each_ring_buffer_desc() iterates over all the
> > CPUs from the trace_desc but uses rb_desc->cpu.
> > 
> > Is it what you meant?
> 
> I'm more worried about the allocation not being big enough for the rb_desc
> being filled. I just noticed that the trace_remote_register() function is
> missing a kerneldoc header. Please add one and specify what the parameters
> are for as well as their requirements.
> 
> It's fine to state that the allocation of desc must match what the cpumask
> is. But the lack of comments about what the function does and what is
> expected of the parameters makes it hard to know if it is performing
> properly.

Ok, will do!

I could also add a desc_size parameter to make sure we won't overflow the given
desc?

> 
> -- Steve
