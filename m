Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D99E44682F
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 16:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785513796; cv=none; b=gX/pl1EYbmnjroRjaLyTOBZQzF/0HKDA+ZQpPthcqeVd+HoU+xDuCV1egh3wNgjAnibKCLQXFxyTqbPSsYxwkePWd84V+qkZCPr+pM6YRCi/QnkLvMFDrQhn76k0Qk5Yo0fBB/7aZ2+v29Qm2BUGHfEV+muTKnqdxsTjEVqk2F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785513796; c=relaxed/simple;
	bh=u9Davee5jFiswlNbcoaGtA170sZ3bUH0duryUAj/cpQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H4iZcaaCG6PSwIkvbKazZQmMFP1SSULauYac7Ck0U4p8V+wb9sR+yDkRtW0bJr4yezX6AMZHbm9fzTMxxLBkHvabtht5SeVIUWH5ipDeB4v0e+8e2roZI57uQ99jBhKEiOQFjbQkjp3ks8nFeR28UGely89rsDgeiVig1DSjIOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TOv9HNF7; arc=none smtp.client-ip=209.85.214.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TOv9HNF7"
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cf6acd760cso12911825ad.3
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 09:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785513794; x=1786118594; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LEYbd8TAWmmMUBeZ9IrKbK+p5wVI9/TTz658UxtH1do=;
        b=TOv9HNF7dsJO3YSQB6U49qerzifMncPsKLChYOkJFossmlvhvueyPuJGS36X+nGkf3
         VCz/gqxDhhbjY+LuuqG3QzbfabhWOGKLtMVor+j9iVbuEkNuhcUdGPTQx4AfdFKzvV7R
         t/BkZ4LvGQOVb9P4y9Jeu/qIyFGFxbC8IkAC8n/Bhsu21ZJF6kMHXcKvflzH7oFqScWW
         j9AGZpVYH7c6oFgSQXLBz9ovH47SNoyYT26Gr37rVC3czreU/bpT5P9LXHUEdJnnzcEp
         MJM+INu91ZdaFBIb4VnFU9+kjfUUgCvxmNNvtS+yRzBtUAx0BjfEZUThaZDB5x9SRlX7
         2voQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785513794; x=1786118594;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LEYbd8TAWmmMUBeZ9IrKbK+p5wVI9/TTz658UxtH1do=;
        b=gIXNfehHrtJ94jVB/V+4l59TKlQo99v5afKGWN34Dbok6097UieYlaiDWhWUB7l/Xx
         5u6ZLwa/9CFEF5wZi3SUOwnCYwFiorIgwpmKMZL84kYvxdqnuRLkjIgKQduhC9x+jjSA
         730l8NzZ7JavdY+e60bRn01FXi9jKWDgU9LSlDalUfl5671ryGmZ5GILVCBURpe0jVd5
         4fIA3XpHCfET/RJDXpSKyrzBu3+hhgZkYih1qc/ZkKEjT20A8zObpW5vTFdM/rzCaPvs
         X0ViV+igJXm3y2J6SrW5KstFJauX1Pekc77kFinkLdzKBkSQBpquQclUGja4YYzRb6kk
         zWEg==
X-Gm-Message-State: AOJu0Ywj+WLzP8dmYvtSA6uAF3tfXG6zpMnTF7Rzq8flnsDzZWqraNH3
	dqGUPsQ2eqOJ38r/GExbyq5jVKRWHRKljoHPH0BuOrVhMQwP0zD5+Gn+iBZ6pgP4Bu65R9Uq+Y7
	REXiwlQ==
X-Received: from plhz17.prod.google.com ([2002:a17:902:d9d1:b0:2ce:ab97:2844])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:184d:b0:2cc:a853:1311
 with SMTP id d9443c01a7336-2d05247edd2mr4778715ad.47.1785513793428; Fri, 31
 Jul 2026 09:03:13 -0700 (PDT)
Date: Fri, 31 Jul 2026 09:03:12 -0700
In-Reply-To: <amzFnPEikFTHhW9X@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260730191908.2084803-1-seanjc@google.com> <20260730191908.2084803-4-seanjc@google.com>
 <20260730193350.60B801F000E9@smtp.kernel.org> <amzFnPEikFTHhW9X@google.com>
Message-ID: <amzHQKmGxFf3aeYp@google.com>
Subject: Re: [PATCH 3/9] KVM: selftests: Affine child tasks to other pCPUs in
 hardware disable test
From: Sean Christopherson <seanjc@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 31, 2026, Sean Christopherson wrote:
> On Thu, Jul 30, 2026, sashiko-bot@kernel.org wrote:
> > > diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
> > > index 3147f5c97e943..1bcbd13e99947 100644
> > > --- a/tools/testing/selftests/kvm/hardware_disable_test.c
> > > +++ b/tools/testing/selftests/kvm/hardware_disable_test.c
> > [ ... ]
> > > @@ -84,16 +85,11 @@ static void run_test(u32 run)
> > [ ... ]
> > >  		check_create_thread(&threads[i], NULL, run_vcpu, vcpu);
> > > -		check_set_affinity(threads[i], &cpu_set);
> > > +		check_set_affinity(threads[i], &child_cpu_set);
> > >  
> > >  		for (j = 0; j < SLEEPING_THREAD_NUM; ++j) {
> > >  			check_create_thread(&throw_away, NULL, sleeping_thread,
> > >  					    (void *)NULL);
> > > -			check_set_affinity(throw_away, &cpu_set);
> > > +			check_set_affinity(throw_away, &child_cpu_set);
> > >  		}
> > >  	}
> > [ ... ]
> > > @@ -147,12 +143,30 @@ void wait_for_child_setup(pid_t pid)
> > [ ... ]
> > > +static void setup_child_cpu_set(void)
> > > +{
> > > +	int cpu;
> > > +
> > > +	kvm_sched_getaffinity(0, sizeof(child_cpu_set), &child_cpu_set);
> > > +
> > > +	if (CPU_COUNT(&child_cpu_set) < 2)
> > > +		return;
> > > +
> > > +	cpu = pin_task_to_random_cpu(pthread_self(), &child_cpu_set);
> > > +	CPU_CLR(cpu, &child_cpu_set);
> > > +
> > > +	while (CPU_COUNT(&child_cpu_set) > VCPU_NUM)
> > > +		CPU_CLR(kvm_pick_random_cpu(&child_cpu_set), &child_cpu_set);
> > > +}
> > 
> > [Severity: Medium]
> > Since setup_child_cpu_set() pins the parent thread to a single random CPU
> > prior to spawning children, won't the newly created threads in run_test()
> > inherit this single-CPU affinity upon creation?
> > 
> > Because check_create_thread() spawns the threads before their affinity is
> > explicitly updated to child_cpu_set, they might immediately begin executing
> > on the exact same CPU as the parent.
> 
> Yeah, I was trying to avoid this since pthread_attr_setaffinity_np() is only
> available with __USE_GNU.
> 
> > Could this result in the child threads starving the parent on that single CPU
> > before the parent gets a chance to execute check_set_affinity()? This seems
> > like it might heavily delay the migration and trigger the same CPU contention
> > that this patch aims to fix.
> 
> After far too much testing, the problem isn't direct CPU contention, AFAICT it's
> due to incurring cross-node NUMA penalties, and presumably scheduler contention
> when the pool of possible CPUs to run on is huge.
> 
> I tried a bunch of fancy approaches, e.g. making parent, child, and grandchildren
> all mutually exclusive, and while the fanciness can provide marginal benefits when
> pthread_attr_setaffinity_np() isn't available, all that really matters is that the
> worker threads get affined before they start doing work.

Oh, and I also ruled out wakeup latency, i.e. this isn't the same underlying cause
that prompted 0297cdc12a87 ("KVM: selftests: Add option to rseq test to override
/dev/cpu_dma_latency").
