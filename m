Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BFCC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 14:32:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06AA74BD68;
	Fri, 15 Jul 2022 10:32:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pzFyX8e9ZXxU; Fri, 15 Jul 2022 10:32:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B97D04BDEF;
	Fri, 15 Jul 2022 10:32:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4155B4BD68
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 10:32:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JB-RZD60qA2L for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 10:32:38 -0400 (EDT)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF0004BD36
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 10:32:38 -0400 (EDT)
Received: by mail-pj1-f54.google.com with SMTP id fz10so5826339pjb.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 07:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=KGDc8EbuqC0PvAxCnIwTKvxHYhgAZfQOE+/RAi143ug=;
 b=JCgSYiRX6HA4YO0cyySvx4Bzs0RhBJGyDuDQdzypDWRq6F+EUrMezPWwe6pBZ73dAd
 RIil1PTT1JVXwkO/GPq8J7pKkkIlUqXw66FyY+PFbO2HMF6uHZW1wMwMhjtAB6PhjkEv
 0qii89D5ckU+mD87QNqOlWnP6SLyUNb9gs8XVHiMXJpuul1mKMa/inhbicja9fNM8h6Q
 0oHBLCdQVMZrvJnVVDP9dE9xdiO6LgxvXAG67eued3ZtvkhbkAJyKCyXO7K2BPkIc6x3
 23HcMu1gMWtTgfRsduOFKcOmxZTgjRlkd9Qrid0PSb5xRXusMzxkNShxTgSyBr3vrndt
 wluQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=KGDc8EbuqC0PvAxCnIwTKvxHYhgAZfQOE+/RAi143ug=;
 b=n+n3sQyafZMQeLhvbLt5a5nB5d9F7WWDNEr/c0fHqyBAzBSiD9PYl4Hhas7P+WAorQ
 IhzLPNG9Uj+SW0jBgcmbO5jwCTjeqDk/TyKKMc0W9VZZ0K5spacgpTDxQvLw8jv8azMU
 zv1/p/UGZoPIdb150tVTwO3YXQayFAzDz6+7LY5eoumlI0A14THy+quGQEp/x0SEBMPv
 hU2NRdCsMCvkWGOfkVKMYXufGcqazajTaxWNzK8q+dk5ffyA18jJUOkLGyQRRlQ73IeD
 7cdN7AlnvAdspREbL0hukMEEdrAOS1D3vE1AQq1jF8T0c0r+MJ1Ks8nHJP9vncHZUoOO
 kftw==
X-Gm-Message-State: AJIora81uyt0WCW7YHWdX19M8JKGo3fq+4qGY/v9bvVR3VQzEkIASR01
 uiM40mFrVP3iymnPA2dM5ZZZTg==
X-Google-Smtp-Source: AGRyM1vrP4fMl5xqO1RnpN7iB0+xQmieg3i1s2EH5bpDyK5MEzUlgFWBRCAR7K8wHJxGL+selF7gqA==
X-Received: by 2002:a17:90b:2242:b0:1f0:6d85:e196 with SMTP id
 hk2-20020a17090b224200b001f06d85e196mr16405063pjb.3.1657895557596; 
 Fri, 15 Jul 2022 07:32:37 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 x62-20020a628641000000b0052842527052sm3844497pfd.189.2022.07.15.07.32.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 15 Jul 2022 07:32:37 -0700 (PDT)
Date: Fri, 15 Jul 2022 14:32:33 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] KVM: selftests: Double check on the current CPU in
 rseq_test
Message-ID: <YtF6gVYgMhoiD0Pe@google.com>
References: <20220714080642.3376618-1-gshan@redhat.com>
 <cd5d029c-b396-45ef-917b-92e054659623@redhat.com>
 <YtA3s0VRj3x7vO7B@google.com>
 <be806f9c-861a-8da8-d42e-1d4271c3a326@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <be806f9c-861a-8da8-d42e-1d4271c3a326@redhat.com>
Cc: shan.gavin@gmail.com, kvm@vger.kernel.org, maz@kernel.org,
 linux-kernel@vger.kernel.org, oliver.upton@linux.dev,
 mathieu.desnoyers@efficios.com, linux-kselftest@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

On Fri, Jul 15, 2022, Gavin Shan wrote:
> Hi Paolo and Sean,
> 
> On 7/15/22 1:35 AM, Sean Christopherson wrote:
> > On Thu, Jul 14, 2022, Paolo Bonzini wrote:
> Well, I don't think migration_worker() does correct thing, if I'm understanding
> correctly. The intention seems to force migration on 'main' thread by 'migration'
> thread?  If that is the case, I don't think the following function call has correct
> parameters.
> 
>     r = sched_setaffinity(0, sizeof(allowed_mask), &allowed_mask);
> 
>     it should be something like:
> 
>     r = sched_setaffinity(getpid(), sizeof(allowed_mask), &allowed_mask);
> 
> If we're using sched_setaffinity(0, ...) in the 'migration' thread, the CPU
> affinity of 'main' thread won't be affected. It means 'main' thread can be
> migrated from one CPU to another at any time, even in the following point:
> 
>     int main(...)
>     {
>           :
>           /*
>            * migration can happen immediately after sched_getcpu(). If
>            * CPU affinity of 'main' thread is sticky to one particular
>            * CPU, which 'migration' thread supposes to do, then there
>            * should have no migration.
>            */
>           cpu = sched_getcpu();
>           rseq_cpu = READ_ONCE(__rseq.cpu_id);
>           :
>     }
> 
> So I think the correct fix is to have sched_setaffinity(getpid(), ...) ?
> Please refer to the manpage.
> 
>    https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html
>    'If pid is zero, then the calling thread is used'

Oof, and more explicitly the rest of that sentence clarifies that the result of
getpid() will target the main thread (I assume "main" means thread group leader).

   Specifying pid as 0 will set the attribute for the calling thread, and passing
   the value returned from a call to getpid(2) will set the attribute for the main
   thread of the thread group.

I'm guessing my test worked (in that it reproduced the bug) by virtue of the
scheduler trying to colocate all threads in the process.

In my defense, the die.net copy of the manpages quite clearly uses "process"[1],
but that was fixed in the manpages in 2013[2]!?!!?  So I guess the takeaway is
to use only the official manpages.

Anyways, for the code, my preference would be to snapshot gettid() in main() before
spawning the migration worker.  Same result, but I would rather the test explicitly
target the thread doing rseq instead of relying on (a) getpid() targeting only the
main thread and (b) the main thread always being the rseq thread.  E.g. if for some
reason a future patch moves the rseq code to its own worker thread, then getpid()
would be incorrect.

Thanks for figuring this out!

[1] https://linux.die.net/man/2/sched_setaffinity
[2] 6a7fcf3cc ("sched_setaffinity.2: Clarify that these system calls affect a per-thread attribute")
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
