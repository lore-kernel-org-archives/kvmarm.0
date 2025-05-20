Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC6E21516E
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 22:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747779604; cv=none; b=YpHTtK2qPI6EW9r1vgo5VyFNpf8z0vxllsbgqyb2M+eUAkiBYOxDieu8wCPtLBCxht7KFJ6isVzIoKHFJxKswxf1Th5OOxa6/foCJ/l7R3LU5fW+KxNNNOCyg58D48K03EzbUHIwlgfhuvxaeA+hEaHu12NinnJgRc7lW23BIfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747779604; c=relaxed/simple;
	bh=yAGEzQUXdc/wVqTOY22PEJhqYz72ZGCmkjww4aZKXSg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ToxYVjptOq8yk+q+jpV5ye4id0QD+bBZyPCYDmB8hTmDY7IShstWlrQoGwv8b7rLVzO581niJr5wTkFMIXTrDNtEl7O18u8sc0XS4W5aZLCXpPe6LGO8cxMz4JOICVK7DlSVnsVhQ6GYndRAbcNgU9K9MV2cY3/8BXci5dxH4F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TNLGwLWj; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TNLGwLWj"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b00e4358a34so3662705a12.0
        for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 15:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747779602; x=1748384402; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8HKYrw1mX2rWYU9hhnTeFvSQNlJmWd9SuBazr4xA8xE=;
        b=TNLGwLWjEICIjdsnDt2ddY8TEhtlKdc9Q5B3LJHQX1PzjlGga4p2fYLdCBCUpmbd/s
         DrL49C+diDpJ/vr4DqtQorGjFkr1jJ8K4udj9U/cgJVv/xGB2IVtG71CVZOZUJTxyYGH
         ViOC+dJoClNaXuaaH406SR2q6AuKUeSiXAs71vQyQePQD9dxjD2MUbew41SIiaSmR7/x
         TEPP3ARkkbBFWjR+7sjGzTNgt2o34mcQgDz7e4WAO7GzSI0/JD+OBEYvEC/eZRaNEF8P
         OtoCt+dEH9dBw3mq2v8ns6j70Kg9V6yHP+0+EeRnCraRbpq5bXLNSiIJcKz2reDlTdEw
         yULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747779602; x=1748384402;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8HKYrw1mX2rWYU9hhnTeFvSQNlJmWd9SuBazr4xA8xE=;
        b=DzqmGQO7Lg+KdyMst9zIb/o6A+T0Nt73lbu5xd2rNL/arbFQKAFLGiszUqV4qBCKOt
         MJ2dutFacLa7MjNKNecNEWDcXN836fSAELaN16wA4ZPZTWLe4+fTsiEsOP91X2nFc8uC
         Nf+PqkZjirqhvCgR/eHRGSZKMCf5kbL2pr7m6I8CjgkXlUdh5YthUQSCGkg+JGXjlz6x
         QipF2WQD54xa1TkMEAgfJJdgXXO1riPq/VPtRa57cLT0UAc9aja3+HKMEQIEBzx9kb8f
         wLR9R0HjfPlqTD8O2nl9cUtZYWFDIhF7ZIJeHFlL21odBki0sbbsBLM+0MvGxng/apAy
         AWqg==
X-Forwarded-Encrypted: i=1; AJvYcCUcbyk8960P+hpY+HJ1oNLmMxGK0m18ArJV34Y3Cx/Yp28GUGZTFzQQ5pJKligCRm1stHP1DiI=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywa8kQGdttpzfHckBChX5drrNt/AxqD/D37r4hWs99luwRV9acw
	jYVobEiMXrsGbiU0BYOPtmENhupY2PsypjInvu1AmUQabOFoLZGhCgW7VUeup17OJdkjWUF6RZI
	SgRv1ng==
X-Google-Smtp-Source: AGHT+IGm0Qd18FrnDfhlG7/JjUl4lMpy15ihv5+w3UyMikyFwPD+eN8+5DcFhlZu44RxRjwOsuD2Z657iBM=
X-Received: from pjoo5.prod.google.com ([2002:a17:90b:5825:b0:2fc:e37d:85dc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5188:b0:305:5f28:2d5c
 with SMTP id 98e67ed59e1d1-30e7d558d26mr28473120a91.15.1747779602268; Tue, 20
 May 2025 15:20:02 -0700 (PDT)
Date: Tue, 20 May 2025 15:20:00 -0700
In-Reply-To: <20250520191816.GJ16434@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250519185514.2678456-1-seanjc@google.com> <20250519185514.2678456-9-seanjc@google.com>
 <20250520191816.GJ16434@noisy.programming.kicks-ass.net>
Message-ID: <aC0AEJX0FIMl9lDy@google.com>
Subject: Re: [PATCH v2 08/12] sched/wait: Drop WQ_FLAG_EXCLUSIVE from add_wait_queue_priority()
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
> On Mon, May 19, 2025 at 11:55:10AM -0700, Sean Christopherson wrote:
> > Drop the setting of WQ_FLAG_EXCLUSIVE from add_wait_queue_priority() to
> > differentiate it from add_wait_queue_priority_exclusive().  The one and
> > only user add_wait_queue_priority(), Xen privcmd's irqfd_wakeup(),
> > unconditionally returns '0', i.e. doesn't actually operate in exclusive
> > mode.
> 
> I find:
> 
> drivers/hv/mshv_eventfd.c:      add_wait_queue_priority(wqh, &irqfd->irqfd_wait);
> drivers/xen/privcmd.c:  add_wait_queue_priority(wqh, &kirqfd->wait);
> 
> I mean, it might still be true and all, but hyperv seems to also use
> this now.

Oh FFS, another "heavily inspired by KVM".  I should have bribed someone to take
this series when I had the chance.  *sigh*

Unfortunately, the Hyper-V code does actually operate in exclusive mode.  Unless
you have a better idea, I'll tweak the series to:

  1. Drop WQ_FLAG_EXCLUSIVE from add_wait_queue_priority() and have the callers
     explicitly set the flag, 
  2. Add a patch to drop WQ_FLAG_EXCLUSIVE from Xen privcmd entirely.
  3. Introduce add_wait_queue_priority_exclusive() and switch KVM to use it.

That has an added bonus of introducing the Xen change in a dedicated patch, i.e.
is probably a sequence anyways.

Alternatively, I could rewrite the Hyper-V code a la the KVM changes, but I'm not
feeling very charitable at the moment (the complete lack of documentation for
their ioctl doesn't help).
