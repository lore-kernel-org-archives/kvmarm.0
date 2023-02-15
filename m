Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28157B
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 16:44:49 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id h5-20020a170902748500b0019aacd1fb04so4010757pll.2
        for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 08:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t8DMcJvXOt1uVMYd5lzHsJnF9jrZA0JOd1Wq9dyU57Y=;
        b=WoRu9NpYfvK6J7R6Hjg/lqXmtWSjFmIjHU2Co8CI2GzDjhbDr+vBMUWmeO1JI0psis
         L86WT9EvkHym4MiCd+N49yB7UaWK4XEkKss6gjM2GjoxmzxLW6DofNQ0BScuDnGDWTkL
         m203gZvFo7D0YemQZg96lVgyrB2rwF3q9QkcSVLcbUGCR7yexx/c0+bAQDYQFYroDKUU
         MZWQByGYoptU9v021DZtiGN1+sbig7mL/ZWIvMCkJMUKZDFvyBBLtyUvouKFwwym4Ib+
         5iJqFRO9/VLw8UKxjgH46tUGdUKGWgry3LhdlTKTaIHzy71rmAqj20l0dfvkyECUsZby
         hvKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t8DMcJvXOt1uVMYd5lzHsJnF9jrZA0JOd1Wq9dyU57Y=;
        b=wJtrziNo2t+eZ5dHdodTR4AQ1VGi+jDYAmOkOjSI9uPfJtft2nQag47UhWPwTLcJLO
         9B803BYPEn2AdsTcQN/Ssf/tDpNp7LaaO1TvlR8MUiiGPAJoESmvbTWoB3b09DN7iQiZ
         JO2m+gnF8CHeuPgZFdJHIFpvevYifI+PvQrQn8kfxqda5qmghAkG+t/xiKOccpdHgyxf
         dCyQGb+PiIh6NQgktKD6gOMewshOqZ9VnbtX8zkCYAHt9rLlx9cSiTzUrgcbvOIXnI0f
         dZ8HU/nYl/hAjsnQmb+EHNNjrCOvKAOs9yrzbK8sKm4fZOzFQYpr+3EbZAronTZP9lB1
         vtzg==
X-Gm-Message-State: AO0yUKX33ouRPkuvFhk3ZsQgptsWAkqYLjIEmQklp/ajD041ek9lJyBo
	C3TGcWhKNebxFttNo0RMnZNWkP+4O2E=
X-Google-Smtp-Source: AK7set9mz6oE4Te7rt9n1BbiU/9ZQWLHMawumtBwjGTY9V0SWl+h2f3S7YMuaoevJRHcJm0SIwnMhfdvhvA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:bf0b:0:b0:4ce:ca8b:432b with SMTP id
 v11-20020a63bf0b000000b004ceca8b432bmr244899pgf.10.1676479488932; Wed, 15 Feb
 2023 08:44:48 -0800 (PST)
Date: Wed, 15 Feb 2023 08:44:47 -0800
In-Reply-To: <Y+yJU2pE4IyuIwOQ@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-2-amoorthy@google.com>
 <Y+yJU2pE4IyuIwOQ@linux.dev>
Message-ID: <Y+0L/x2YgiEgm9bt@google.com>
Subject: Re: [PATCH 1/8] selftests/kvm: Fix bug in how demand_paging_test
 calculates paging rate
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Anish Moorthy <amoorthy@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, James Houghton <jthoughton@google.com>, Ben Gardon <bgardon@google.com>, 
	David Matlack <dmatlack@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 15, 2023, Oliver Upton wrote:
> Hi Anish,
> 
> On Wed, Feb 15, 2023 at 01:16:07AM +0000, Anish Moorthy wrote:
> > Currently we're dividing tv_nsec by 1E8, not 1E9.
> > 
> > Reported-by: James Houghton <jthoughton@google.com>
> > Signed-off-by: Anish Moorthy <amoorthy@google.com>
> > ---
> >  tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> > index b0e1fc4de9e29..6809184ce2390 100644
> > --- a/tools/testing/selftests/kvm/demand_paging_test.c
> > +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> > @@ -194,7 +194,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >  		ts_diff.tv_sec, ts_diff.tv_nsec);
> >  	pr_info("Overall demand paging rate: %f pgs/sec\n",
> >  		memstress_args.vcpu_args[0].pages * nr_vcpus /
> > -		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
> > +		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 1E9));
> 
> Use NSEC_PER_SEC instead so the conversion taking place is immediately
> obvious.

And please post this separately, it's a fix that's independent of the rest of the
series and can/should be applied sooner than later.

Thanks!
