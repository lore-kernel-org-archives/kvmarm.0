Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C054627469
	for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 16:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ccxq2yOs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696954337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tSjnvG5NwalIEjKIQtTbuCFGAtOMZwRcBRSi/1kopbk=;
	b=Ccxq2yOsQxg6xcSOV3Fw5lVOSPHexLLWdwNcIMvBXmCtDB57X1RV80rbHVa+JqlVEarSu2
	s/bxVkgspiX53ikD11kau1s5YYUBrcVaUZH7rM41sYcOlajcmwHj+2a2CurFgREaexGd7h
	c5zalzT0+J6b5KAqO5e6MfXXzZxAtc0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-oPRxfiy-M9-HLpcPp7FmPw-1; Tue, 10 Oct 2023 12:12:15 -0400
X-MC-Unique: oPRxfiy-M9-HLpcPp7FmPw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f42bcef2acso36192815e9.2
        for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 09:12:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696954334; x=1697559134;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tSjnvG5NwalIEjKIQtTbuCFGAtOMZwRcBRSi/1kopbk=;
        b=fLqUlvxvV6a6Wxu2/RH6TfiBSTstMX09cSCge61jo2AvoglBrH9QiJndDLHQRnlOiW
         fCeitv7AI93JV4wDnUAl+VmT0aBR9ra7sfrHPkgPW4rDE7/lfxZLlUj6Z/tbGF5Cl0GS
         smG6NCgGShVhPDv9aDlap3fLTkLwWQotHgnMEy4KDpw4Oi4CgQ7imp72TP/Yp54sP+/+
         8mq2ixwf9rjWt21YbzRZSyVemfoMXNv6HUjFNEcYou7j/BJkZptMN9mzARSn0oe5fCHF
         dbQswx7onsLlyOZiJjaiWVNHmzUmC74MNE6s1FQqnFy8YH4Z0QidjWDk7FD/QbiX1tyV
         xR2w==
X-Gm-Message-State: AOJu0YytRe5yKfgOhyKZutrDr600FTEb5di4/HhLKUI/c20FZG2hlMc3
	2Lihc3XaZiM40cCBxpF3yoBOCnB8DvrDa67rs9iU3TtqqW67fs+M6W4+s6yLb45eNDw1ADGMdlW
	1A7QFEpjdoia3s6tS
X-Received: by 2002:a05:6000:cb:b0:321:7050:6fb6 with SMTP id q11-20020a05600000cb00b0032170506fb6mr14952074wrx.67.1696954334575;
        Tue, 10 Oct 2023 09:12:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHiVZprh6ZRHMJLcnBs1Xd6l1wpOAVgISEZ4kCScvw7gLyV/CxwFTkly37MyRE2XBOpVqncfw==
X-Received: by 2002:a05:6000:cb:b0:321:7050:6fb6 with SMTP id q11-20020a05600000cb00b0032170506fb6mr14952042wrx.67.1696954334151;
        Tue, 10 Oct 2023 09:12:14 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id j16-20020adff010000000b0032008f99216sm13043941wro.96.2023.10.10.09.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 09:12:13 -0700 (PDT)
Message-ID: <ce964b43f926708f30c85640591b2fc62397b719.camel@redhat.com>
Subject: Re: [PATCH v2 4/5] perf kvm: Support sampling guest callchains
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Tianyi Liu <i.pear@outlook.com>, seanjc@google.com, pbonzini@redhat.com,
  peterz@infradead.org, mingo@redhat.com, acme@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, namhyung@kernel.org, 
	irogers@google.com, adrian.hunter@intel.com
Date: Tue, 10 Oct 2023 19:12:11 +0300
In-Reply-To: <SY4P282MB108433024762F1F292D47C2A9DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
References: <SY4P282MB1084ECBCC1B176153B9E2A009DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
	 <SY4P282MB108433024762F1F292D47C2A9DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

У нд, 2023-10-08 у 22:57 +0800, Tianyi Liu пише:
> This patch provides support for sampling guests' callchains.
> 
> The signature of `get_perf_callchain` has been modified to explicitly
> specify whether it needs to sample the host or guest callchain.
> Based on the context, it will distribute the sampling request to one of
> `perf_callchain_user`, `perf_callchain_kernel`, or `perf_callchain_guest`.
> 
> The reason for separately implementing `perf_callchain_user` and
> `perf_callchain_kernel` is that the kernel may utilize special unwinders
> such as `ORC`. However, for the guest, we only support stackframe-based
> unwinding, so the implementation is generic and only needs to be
> separately implemented for 32-bit and 64-bit.
> 
> Signed-off-by: Tianyi Liu <i.pear@outlook.com>
> ---
>  arch/x86/events/core.c     | 56 +++++++++++++++++++++++++++++++-------
>  include/linux/perf_event.h |  3 +-
>  kernel/bpf/stackmap.c      |  8 +++---
>  kernel/events/callchain.c  | 27 +++++++++++++++++-
>  kernel/events/core.c       |  7 ++++-
>  5 files changed, 84 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 185f902e5..ea4c86175 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -2758,11 +2758,6 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
>  	struct unwind_state state;
>  	unsigned long addr;
>  
> -	if (perf_guest_state()) {
> -		/* TODO: We don't support guest os callchain now */
> -		return;
> -	}
> -
>  	if (perf_callchain_store(entry, regs->ip))
>  		return;
>  
> @@ -2778,6 +2773,52 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
>  	}
>  }
>  
> +static inline void
> +perf_callchain_guest32(struct perf_callchain_entry_ctx *entry)
> +{
> +	struct stack_frame_ia32 frame;
> +	const struct stack_frame_ia32 *fp;
> +
> +	fp = (void *)perf_guest_get_frame_pointer();
> +	while (fp && entry->nr < entry->max_stack) {
> +		if (!perf_guest_read_virt(&fp->next_frame, &frame.next_frame,
This should be fp->next_frame.
> +			sizeof(frame.next_frame)))
> +			break;
> +		if (!perf_guest_read_virt(&fp->return_address, &frame.return_address,
Same here.
> +			sizeof(frame.return_address)))
> +			break;
> +		perf_callchain_store(entry, frame.return_address);
> +		fp = (void *)frame.next_frame;
> +	}
> +}
> +
> +void
> +perf_callchain_guest(struct perf_callchain_entry_ctx *entry)
> +{
> +	struct stack_frame frame;
> +	const struct stack_frame *fp;
> +	unsigned int guest_state;
> +
> +	guest_state = perf_guest_state();
> +	perf_callchain_store(entry, perf_guest_get_ip());
> +
> +	if (guest_state & PERF_GUEST_64BIT) {
> +		fp = (void *)perf_guest_get_frame_pointer();
> +		while (fp && entry->nr < entry->max_stack) {
> +			if (!perf_guest_read_virt(&fp->next_frame, &frame.next_frame,
Same here.
> +				sizeof(frame.next_frame)))
> +				break;
> +			if (!perf_guest_read_virt(&fp->return_address, &frame.return_address,
And here.

> +				sizeof(frame.return_address)))
> +				break;
> +			perf_callchain_store(entry, frame.return_address);
> +			fp = (void *)frame.next_frame;
> +		}
> +	} else {
> +		perf_callchain_guest32(entry);
> +	}
> +}

For symmetry, maybe it makes sense to have perf_callchain_guest32 and perf_callchain_guest64
and then make perf_callchain_guest call each? No strong opinion on this of course.


> +
>  static inline int
>  valid_user_frame(const void __user *fp, unsigned long size)
>  {
> @@ -2861,11 +2902,6 @@ perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs
>  	struct stack_frame frame;
>  	const struct stack_frame __user *fp;
>  
> -	if (perf_guest_state()) {
> -		/* TODO: We don't support guest os callchain now */
> -		return;
> -	}
> -
>  	/*
>  	 * We don't know what to do with VM86 stacks.. ignore them for now.
>  	 */
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index d0f937a62..a2baf4856 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1545,9 +1545,10 @@ DECLARE_PER_CPU(struct perf_callchain_entry, perf_callchain_entry);
>  
>  extern void perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs);
>  extern void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs);
> +extern void perf_callchain_guest(struct perf_callchain_entry_ctx *entry);
>  extern struct perf_callchain_entry *
>  get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
> -		   u32 max_stack, bool crosstask, bool add_mark);
> +		   bool host, bool guest, u32 max_stack, bool crosstask, bool add_mark);
>  extern int get_callchain_buffers(int max_stack);
>  extern void put_callchain_buffers(void);
>  extern struct perf_callchain_entry *get_callchain_entry(int *rctx);
> diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
> index 458bb80b1..2e88d4639 100644
> --- a/kernel/bpf/stackmap.c
> +++ b/kernel/bpf/stackmap.c
> @@ -294,8 +294,8 @@ BPF_CALL_3(bpf_get_stackid, struct pt_regs *, regs, struct bpf_map *, map,
>  	if (max_depth > sysctl_perf_event_max_stack)
>  		max_depth = sysctl_perf_event_max_stack;
>  
> -	trace = get_perf_callchain(regs, 0, kernel, user, max_depth,
> -				   false, false);
> +	trace = get_perf_callchain(regs, 0, kernel, user, true, false,
> +				   max_depth, false, false);
>  
>  	if (unlikely(!trace))
>  		/* couldn't fetch the stack trace */
> @@ -420,8 +420,8 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
>  	else if (kernel && task)
>  		trace = get_callchain_entry_for_task(task, max_depth);
>  	else
> -		trace = get_perf_callchain(regs, 0, kernel, user, max_depth,
> -					   false, false);
> +		trace = get_perf_callchain(regs, 0, kernel, user, true, false,
> +					   max_depth, false, false);
>  	if (unlikely(!trace))
>  		goto err_fault;
>  
> diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
> index 1273be843..7e80729e9 100644
> --- a/kernel/events/callchain.c
> +++ b/kernel/events/callchain.c
> @@ -45,6 +45,10 @@ __weak void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
>  {
>  }
>  
> +__weak void perf_callchain_guest(struct perf_callchain_entry_ctx *entry)
> +{
> +}
> +
>  static void release_callchain_buffers_rcu(struct rcu_head *head)
>  {
>  	struct callchain_cpus_entries *entries;
> @@ -178,11 +182,12 @@ put_callchain_entry(int rctx)
>  
>  struct perf_callchain_entry *
>  get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
> -		   u32 max_stack, bool crosstask, bool add_mark)
> +		   bool host, bool guest, u32 max_stack, bool crosstask, bool add_mark)
>  {
>  	struct perf_callchain_entry *entry;
>  	struct perf_callchain_entry_ctx ctx;
>  	int rctx;
> +	unsigned int guest_state;
>  
>  	entry = get_callchain_entry(&rctx);
>  	if (!entry)
> @@ -194,6 +199,26 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
>  	ctx.contexts       = 0;
>  	ctx.contexts_maxed = false;
>  
> +	guest_state = perf_guest_state();
> +	if (guest_state) {
> +		if (!guest)
> +			goto exit_put;
> +		if (user && (guest_state & PERF_GUEST_USER)) {
> +			if (add_mark)
> +				perf_callchain_store_context(&ctx, PERF_CONTEXT_GUEST_USER);
> +			perf_callchain_guest(&ctx);
> +		}
> +		if (kernel && !(guest_state & PERF_GUEST_USER)) {
> +			if (add_mark)
> +				perf_callchain_store_context(&ctx, PERF_CONTEXT_GUEST_KERNEL);
> +			perf_callchain_guest(&ctx);
> +		}
> +		goto exit_put;
> +	}
> +
> +	if (unlikely(!host))
> +		goto exit_put;
> +
>  	if (kernel && !user_mode(regs)) {
>  		if (add_mark)
>  			perf_callchain_store_context(&ctx, PERF_CONTEXT_KERNEL);
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index eaba00ec2..b3401f403 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -7559,6 +7559,8 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
>  {
>  	bool kernel = !event->attr.exclude_callchain_kernel;
>  	bool user   = !event->attr.exclude_callchain_user;
> +	bool host   = !event->attr.exclude_host;
> +	bool guest  = !event->attr.exclude_guest;
>  	/* Disallow cross-task user callchains. */
>  	bool crosstask = event->ctx->task && event->ctx->task != current;
>  	const u32 max_stack = event->attr.sample_max_stack;
> @@ -7567,7 +7569,10 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
>  	if (!kernel && !user)
>  		return &__empty_callchain;
>  
> -	callchain = get_perf_callchain(regs, 0, kernel, user,
> +	if (!host && !guest)
> +		return &__empty_callchain;
> +
> +	callchain = get_perf_callchain(regs, 0, kernel, user, host, guest,
>  				       max_stack, crosstask, true);
>  	return callchain ?: &__empty_callchain;
>  }


Best regards,
	Maxim Levitsky


