Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7872AC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  2 Feb 2022 18:43:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D972540C29;
	Wed,  2 Feb 2022 13:43:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f7gJDeyfvKGo; Wed,  2 Feb 2022 13:43:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75B1340F9C;
	Wed,  2 Feb 2022 13:43:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A6B740C29
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Feb 2022 13:43:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FYReS0LvRjeP for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Feb 2022 13:43:32 -0500 (EST)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
 [209.85.215.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA0B140417
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Feb 2022 13:43:31 -0500 (EST)
Received: by mail-pg1-f181.google.com with SMTP id p125so266429pga.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Feb 2022 10:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=SDBZmOfzCxzCugk5jd7ddO5i086r0OhAAAxVBt9bcn4=;
 b=oCI/z/rsP2tCXkQEN/+3HjveKSrAnKOcocJwYaxxXbEW1w/eYlt67jmoJECImLXl6Y
 m+naw7bWdoJmdRnn10lDq1HpA2C5Az22TBA6yOAyuycAtgvmvSp/UQeky9h/lq03T2xw
 lFjkXkSHdF4LLPF0HB4gynXj3rNLfI65rrGnjcnuUumbMu6jj8AaMwam+iUKe7nJpgCo
 iYbJCIHr1SG2YFaExtqHyGZ7n/VHGIJmWCAeqACFxUBHAO5mxQNGVKviHVdOY7eknFJ4
 iKjM6a0XZmYtrfGna/2nc/lbsI0MgMcoJPezmgMWAFHDODU9wJXJBWHksMfgYyj917xU
 GB0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=SDBZmOfzCxzCugk5jd7ddO5i086r0OhAAAxVBt9bcn4=;
 b=bBzLdWvXj9gbQODI4rzqS9vMZ451p3FLmmWbqrV05xqs1JR2deCXdO7NYe77Io0z7t
 Rar5nK4b00AhzQ4FrHM8PYahqd7orBcGwwY0Tv8lwdcvtFJOdI4TgR5ys0fiUXYQtvBV
 2wtmy4Y8Ny/bgjYLrvJ+rf5QWBhD99ujyGB/5oM+YyyOT12KMUg6LPZCYvAqihyaEJ1s
 cC6eRDxxrBPl97hjOX9tUR6QPXYZsygqUQedPsjshywDJ0eB97iYCZbR97UhX/ifUE3J
 djFvwf2bC7EoLdh0WPVvRT8FPcH05rJhEiLOQb62IXsgWdpDgM8q0VxIo2Qqfts0DbCS
 S1cw==
X-Gm-Message-State: AOAM532O7w3u3xvgDYVwAWXIsPS9iVUIL+YlVdWNL8PW7u5MuElHD0PR
 HIKk+NH4q8P7F+re2cFc0XpRug==
X-Google-Smtp-Source: ABdhPJyKY2bmBpNsgwyDJ0PlfhIstJxwGXU5jBuEN8xCwoW4q9qfWAOqxr1alAqmED6qNrXosDZfnA==
X-Received: by 2002:aa7:9682:: with SMTP id f2mr31230350pfk.56.1643827410811; 
 Wed, 02 Feb 2022 10:43:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id p22sm26858049pfo.163.2022.02.02.10.43.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Feb 2022 10:43:30 -0800 (PST)
Date: Wed, 2 Feb 2022 18:43:26 +0000
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 09/17] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <YfrQzoIWyv9lNljh@google.com>
References: <20211111020738.2512932-1-seanjc@google.com>
 <20211111020738.2512932-10-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211111020738.2512932-10-seanjc@google.com>
Cc: Will McVicker <willmcvicker@google.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

+Will and Sami, -most everyone else

On Thu, Nov 11, 2021, Sean Christopherson wrote:
> Use static_call to optimize perf's guest callbacks on arm64 and x86,
> which are now the only architectures that define the callbacks.  Use
> DEFINE_STATIC_CALL_RET0 as the default/NULL for all guest callbacks, as
> the callback semantics are that a return value '0' means "not in guest".
> 
> static_call obviously avoids the overhead of CONFIG_RETPOLINE=y, but is
> also advantageous versus other solutions, e.g. per-cpu callbacks, in that
> a per-cpu memory load is not needed to detect the !guest case.
> 
> Based on code from Peter and Like.
> 
> Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Like Xu <like.xu.linux@gmail.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

...

> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 1c8d341ecc77..b4fd928e4ff8 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6524,12 +6524,23 @@ static void perf_pending_event(struct irq_work *entry)
>  #ifdef CONFIG_GUEST_PERF_EVENTS
>  struct perf_guest_info_callbacks __rcu *perf_guest_cbs;
>  
> +DEFINE_STATIC_CALL_RET0(__perf_guest_state, *perf_guest_cbs->state);
> +DEFINE_STATIC_CALL_RET0(__perf_guest_get_ip, *perf_guest_cbs->get_ip);
> +DEFINE_STATIC_CALL_RET0(__perf_guest_handle_intel_pt_intr, *perf_guest_cbs->handle_intel_pt_intr);

Using __static_call_return0() makes clang's CFI sad on arm64 due to the resulting
function prototype mistmatch, which IIUC, is verified by clang's __cfi_check()
for indirect calls, i.e. architectures without CONFIG_HAVE_STATIC_CALL.

We could fudge around the issue by using stubs, massaging prototypes, etc..., but
that means doing that for every arch-agnostic user of __static_call_return0().

Any clever ideas?  Can we do something like generate a unique function for every
DEFINE_STATIC_CALL_RET0 for CONFIG_HAVE_STATIC_CALL=n, e.g. using typeof() to
get the prototype?

  Kernel panic - not syncing: CFI failure (target: __static_call_return0+0x0/0x8)
  CPU: 0 PID: 1625 Comm: batterystats-wo Tainted: G        W  OE     5.16.0-mainline #1$
  Hardware name: Raven EVT 1.1 (DT)$
  Call trace:$
   dump_backtrace+0xf0/0x130$
   show_stack+0x1c/0x2c$
   dump_stack_lvl+0x68/0x98$
   panic+0x168/0x420$
   __cfi_check_fail+0x58/0x5c$
   __cfi_slowpath_diag+0x150/0x1a4$
   perf_misc_flags+0x74/0xa4$
   perf_prepare_sample+0x50/0x44c$
   perf_event_output_forward+0x5c/0xcc$
   __perf_event_overflow+0xc8/0x188$
   perf_swevent_event+0x7c/0x10c$
   perf_tp_event+0x168/0x298$
   perf_trace_run_bpf_submit+0x8c/0xdc$
   perf_trace_sched_switch+0x180/0x1cc$
   __schedule+0x850/0x924$
   schedule+0x98/0xe0$
   binder_wait_for_work+0x158/0x368$
   binder_thread_read+0x278/0x243c$
   binder_ioctl_write_read+0x120/0x45c$
   binder_ioctl+0x1ac/0xc34$
   __arm64_sys_ioctl+0xa8/0x118$
   invoke_syscall+0x64/0x178$
   el0_svc_common+0x8c/0x100$
   do_el0_svc+0x28/0xa0$
   el0_svc+0x24/0x84$
   el0t_64_sync_handler+0x88/0xec$
   el0t_64_sync+0x1b4/0x1b8$
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
