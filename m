Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E4121129A
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 20:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747774624; cv=none; b=XfvygykVzXg6fnJVHUju48+whTih8r9a6fZrQSq5+BRatckuelHKaZv7s1vlUNz7GnV6CE9RjFJDfEmd5E+3RoJRZw03sQ6kD/fUDCtr31pKaGOUoQXP8t5Ry8jtDoHuSN70GmhxRda7RyrWs2mc30rmxqrKz0FVF5YhTHkEwdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747774624; c=relaxed/simple;
	bh=4NVAqMmE/xJIFdHB7+CceGBJ43TCYvrJvvG0LTTS2Ps=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XpEt7tOQ9b/rk15LbMMGEDjO8BAOwkXinvRLk1c+qqMu2uaGR+Fy7zZO1XZsCmKlQ3w64ZnLlIMySYcGfgdzieBkXaK4xu2Q5iqWENFxV6jok9hd45u548Bcym0nNgult0BKVPXBlZrr3mFv++X7d2NZxonoPXLNdzBigs3uhIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c3eu1HnO; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c3eu1HnO"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30a29af28d1so4876531a91.0
        for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 13:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747774622; x=1748379422; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UKutgaWFEQ+3gu/ouPLFwWIwK8y5oHoRF19CwGZ+S/c=;
        b=c3eu1HnO6ISW6kSmvEkyndLUPq2aLH4ErQls9h75Tj30qoOvluu2YugXSuRu0JdiJM
         ELHagTqW2npjffeixqH9v3AhPl16WsCBh3rsIaQcY5YtvzTWTQRUMEdqWh8Z6Auo01o8
         sls0XrzRahJCRJJgN3Tyg547NCyKlmDLZ/DQ0XOmu4aZ8NRj3SE0GJviRjlgIfj0SKWF
         13KPjgvKUNac2IvH+7lLLSkjKzHaGgfrg3oDOlbLINWvs0hqqfaJAzbvF69Deuin2gnu
         t2yiWA7uKti+yLFnLTNLErSIShy+3lnEecosBUiVlStg6cCONQsjaw1Sj9woYkzXhipS
         eLfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747774622; x=1748379422;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UKutgaWFEQ+3gu/ouPLFwWIwK8y5oHoRF19CwGZ+S/c=;
        b=U/CqU7DhQ1AmNYG4WMrTysqBpjt4gCm6cth405tH5SpGC40L1xlNxy+v+BWoHrQUtd
         lEBMi7q9HpRVKcZAmA0122l94os2DdOLdlFJwgZIX+TY/xP72ZXYgInibmqdudkUZ7Rp
         9hew2OVF7HU+miTn2z8Usdwx5hTRu3blwRseNB69HVE0kwS31fYuzObtpuX2/BtArfvG
         j4YhwpRc/Bua6WpOcFADHRioOj4Zc7qdmjSUlQrdXwroLKaiC6qejDSb5yyRsemveuq2
         g1nhmpLG8e8LKNEMkdFWJ5fFVRaNKyFx85BSBIqTnvZVmlUT+jwzvbPkwsRjndJQMcEv
         JiLw==
X-Forwarded-Encrypted: i=1; AJvYcCXifcszy6x22pmERCDsxvzhDpMOaUV5S8YZRa1Wg9e2kOi9VSchNze5HrJfInIxkfY9cZTwGUY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz45sE1zV8kPuxiNGTgkUBA733lQ3g4Dgfyjpo20oiEF5aIWcCw
	UROyQOXk78dN0DrXMSp2mxKFHBabpYpZKfKn5RMZWUdpHT3wEYCcAutQzzfcz4G/bpBGXicTRbv
	bZOiyTg==
X-Google-Smtp-Source: AGHT+IFjfH39vLCcnXRNh1tmz9SqmTftxmR4IbkXgvupWrNryIrlY6xpDKX1XUbGhNR1KVx0wuk++Q37G+U=
X-Received: from pjbli1.prod.google.com ([2002:a17:90b:48c1:b0:30e:840f:131e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1846:b0:2ff:6488:e01c
 with SMTP id 98e67ed59e1d1-30e7d5bb354mr29441493a91.29.1747774622388; Tue, 20
 May 2025 13:57:02 -0700 (PDT)
Date: Tue, 20 May 2025 13:57:01 -0700
In-Reply-To: <20250520191723.GI16434@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250519185514.2678456-1-seanjc@google.com> <20250519185514.2678456-7-seanjc@google.com>
 <20250520191723.GI16434@noisy.programming.kicks-ass.net>
Message-ID: <aCzsnXPQ0TtKtqu9@google.com>
Subject: Re: [PATCH v2 06/12] sched/wait: Add a waitqueue helper for fully
 exclusive priority waiters
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Matlack <dmatlack@google.com>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, May 20, 2025, Peter Zijlstra wrote:
> On Mon, May 19, 2025 at 11:55:08AM -0700, Sean Christopherson wrote:
> > diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
> > index 51e38f5f4701..03252badb8e8 100644
> > --- a/kernel/sched/wait.c
> > +++ b/kernel/sched/wait.c
> > @@ -47,6 +47,24 @@ void add_wait_queue_priority(struct wait_queue_head *wq_head, struct wait_queue_
> >  }
> >  EXPORT_SYMBOL_GPL(add_wait_queue_priority);
> >  
> > +int add_wait_queue_priority_exclusive(struct wait_queue_head *wq_head,
> > +				      struct wait_queue_entry *wq_entry)
> > +{
> > +	struct list_head *head = &wq_head->head;
> > +
> > +	wq_entry->flags |= WQ_FLAG_EXCLUSIVE | WQ_FLAG_PRIORITY;
> > +
> > +	guard(spinlock_irqsave)(&wq_head->lock);
> > +
> > +	if (!list_empty(head) &&
> > +	    (list_first_entry(head, typeof(*wq_entry), entry)->flags & WQ_FLAG_PRIORITY))
> > +		return -EBUSY;
> > +
> > +	list_add(&wq_entry->entry, head);
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(add_wait_queue_priority_exclusive);
> 
> add_wait_queue_priority() is a GPL export, leading me to believe the
> whole priority thing is _GPL only, should we maintain that?

Oh, yes, definitely.  Simply a goof.
