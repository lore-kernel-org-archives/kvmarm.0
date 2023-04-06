Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3632F29A1
	for <kvmarm@lists.linux.dev>; Thu,  6 Apr 2023 12:52:57 +0000 (UTC)
Received: by mail-ej1-f46.google.com with SMTP id 18so1124334ejo.13
        for <kvmarm@lists.linux.dev>; Thu, 06 Apr 2023 05:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680785575; x=1683377575;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IJscOEPUxerIocq5ivhaFnZ1SHI0paGFj+4RY7CI49c=;
        b=mmi2ytKq+NaQhoDUPRHBUEjRhCCPgZiy7rLgIJXfMFck1daXezUDFfW+f8Ya9qW8Nu
         77o8Nv8mCPZJVOJ/Mw5IkzQ/lVA8K8pLYcnCheg3aUT4rIjJIAXX7Utgjw5MQqmXLhtW
         435VTHVUt6RP3++nMGoeLtublMXBqOmF5FEHQb6o99n31lb7S6WZxLIvcTevt83tl6fV
         cKM/LYDc4weOyCwuDkg3btNjWsl6SyXFBeMGeyFU1GWXKNRtgmCulev2zmpW5HSdx9TQ
         WDUIoKFjlt3z2DEYShN6woFM3WBqXviuTCQLf58p6eWApFbTnPJA8N2vEAKJbmcOE3wx
         8r5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680785575; x=1683377575;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IJscOEPUxerIocq5ivhaFnZ1SHI0paGFj+4RY7CI49c=;
        b=nV8X8AZtVUUUPSflWUCj1eLJS4/Qnp8/xe/hTuNsVd+i7THsSoh+7h+RpD2gJiQenb
         duznG/U7xiK73lNSZ3bWuGGXOLo2vav2T+AdxwMBgQTwYZhEB6ryQivRoH8TLRd/euzY
         viLdkIAn8xqNz2pRvc/wk6wW7DnI1VcB7VdkrdEvioztlm4ryUW6l70+MFBkAVoU4uBK
         A6Xys+b6IH3yI5oc5mKI3/ixC5sJS0lPdExcq4ZS+nFvIwNj8KQfKXQxXd6g0BN/jfiq
         rarIzxTOgJ60b/um02AM1jlgjD4cQFO951ZDdd412316WVA9ummdJ5tIKFzz6TGYh9zj
         qp5Q==
X-Gm-Message-State: AAQBX9c8hWP+2UNDnOFXENyD+VAlqHWurMmpSRNnYyIKrkZuAn3A7qoo
	1aBZ3xi9ka8oDvKbjMzvRNoeEA==
X-Google-Smtp-Source: AKy350ZjSeUi5W/FMFj8cFd3FZ8IBUmJZCdwJjwrxRaSX9z1B2tETRyepfqtj3cs2LAQGBpYvDx5aA==
X-Received: by 2002:a17:906:9be2:b0:931:624b:680c with SMTP id de34-20020a1709069be200b00931624b680cmr6404112ejc.29.1680785575139;
        Thu, 06 Apr 2023 05:52:55 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id rj13-20020a1709076c8d00b00947ccb6150bsm657067ejc.102.2023.04.06.05.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 05:52:54 -0700 (PDT)
Date: Thu, 6 Apr 2023 12:52:51 +0000
From: Quentin Perret <qperret@google.com>
To: Saravana Kannan <saravanak@google.com>
Cc: Marc Zyngier <maz@kernel.org>, David Dai <davidai@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>, kernel-team@android.com,
	linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH 0/6] Improve VM DVFS and task placement behavior
Message-ID: <ZC7Ao1qoNGYXQ9h4@google.com>
References: <20230330224348.1006691-1-davidai@google.com>
 <ZCx97IKjsBibjdGc@linux.dev>
 <86sfdfv0e1.wl-maz@kernel.org>
 <ZC0n0HRsmNJeJZps@google.com>
 <CAGETcx_9SdyCQ5UHhjsnV5+X8arhXoZS2NN-mewtPM3oHuZrkw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGETcx_9SdyCQ5UHhjsnV5+X8arhXoZS2NN-mewtPM3oHuZrkw@mail.gmail.com>

On Wednesday 05 Apr 2023 at 14:07:18 (-0700), Saravana Kannan wrote:
> On Wed, Apr 5, 2023 at 12:48 AM 'Quentin Perret' via kernel-team
> > And I concur with all the above as well. Putting this in the kernel is
> > not an obvious fit at all as that requires a number of assumptions about
> > the VMM.
> >
> > As Oliver pointed out, the guest topology, and how it maps to the host
> > topology (vcpu pinning etc) is very much a VMM policy decision and will
> > be particularly important to handle guest frequency requests correctly.
> >
> > In addition to that, the VMM's software architecture may have an impact.
> > Crosvm for example does device emulation in separate processes for
> > security reasons, so it is likely that adjusting the scheduling
> > parameters ('util_guest', uclamp, or else) only for the vCPU thread that
> > issues frequency requests will be sub-optimal for performance, we may
> > want to adjust those parameters for all the tasks that are on the
> > critical path.
> >
> > And at an even higher level, assuming in the kernel a certain mapping of
> > vCPU threads to host threads feels kinda wrong, this too is a host
> > userspace policy decision I believe. Not that anybody in their right
> > mind would want to do this, but I _think_ it would technically be
> > feasible to serialize the execution of multiple vCPUs on the same host
> > thread, at which point the util_guest thingy becomes entirely bogus. (I
> > obviously don't want to conflate this use-case, it's just an example
> > that shows the proposed abstraction in the series is not a perfect fit
> > for the KVM userspace delegation model.)
> 
> See my reply to Oliver and Marc. To me it looks like we are converging
> towards having shared memory between guest, host kernel and VMM and
> that should address all our concerns.

Hmm, that is not at all my understanding of what has been the most
important part of the feedback so far: this whole thing belongs to
userspace.

> The guest will see a MMIO device, writing to it will trigger the host
> kernel to do the basic "set util_guest/uclamp for the vCPU thread that
> corresponds to the vCPU" and then the VMM can do more on top as/if
> needed (because it has access to the shared memory too). Does that
> make sense?

Not really no. I've given examples of why this doesn't make sense for
the kernel to do this, which still seems to be the case with what you're
suggesting here.

> Even in the extreme example, the stuff the kernel would do would still
> be helpful, but not sufficient. You can aggregate the
> util_guest/uclamp and do whatever from the VMM.
> Technically in the extreme example, you don't need any of this. The
> normal util tracking of the vCPU thread on the host side would be
> sufficient.
>
> Actually any time we have only 1 vCPU host thread per VM, we shouldn't
> be using anything in this patch series and not instantiate the guest
> device at all.

> > So +1 from me to move this as a virtual device of some kind. And if the
> > extra cost of exiting all the way back to userspace is prohibitive (is
> > it btw?),
> 
> I think the "13% increase in battery consumption for games" makes it
> pretty clear that going to userspace is prohibitive. And that's just
> one example.

I beg to differ. We need to understand where these 13% come from in more
details. Is it really the actual cost of the userspace exit? Or is it
just that from userspace the only knob you can play with is uclamp and
that didn't reach the expected level of performance?

If that is the userspace exit, then we can work to optimize that -- it's
a fairly common problem in the virt world, nothing special here.

And if the issue is the lack of expressiveness in uclamp, then that too
is something we should work on, but clearly giving vCPU threads more
'power' than normal host threads is a bit of a red flag IMO. vCPU
threads must be constrained in the same way that userspace threads are,
because they _are_ userspace threads.

> > then we can try to work on that. Maybe something a la vhost
> > can be done to optimize, I'll have a think.
> >
> > > The one thing I'd like to understand that the comment seems to imply
> > > that there is a significant difference in overhead between a hypercall
> > > and an MMIO. In my experience, both are pretty similar in cost for a
> > > handling location (both in userspace or both in the kernel). MMIO
> > > handling is a tiny bit more expensive due to a guaranteed TLB miss
> > > followed by a walk of the in-kernel device ranges, but that's all. It
> > > should hardly register.
> > >
> > > And if you really want some super-low latency, low overhead
> > > signalling, maybe an exception is the wrong tool for the job. Shared
> > > memory communication could be more appropriate.
> >
> > I presume some kind of signalling mechanism will be necessary to
> > synchronously update host scheduling parameters in response to guest
> > frequency requests, but if the volume of data requires it then a shared
> > buffer + doorbell type of approach should do.
> 
> Part of the communication doesn't need synchronous handling by the
> host. So, what I said above.

I've also replied to another message about the scale invariance issue,
and I'm not convinced the frequency based interface proposed here really
makes sense. An AMU-like interface is very likely to be superior.

> > Thinking about it, using SCMI over virtio would implement exactly that.
> > Linux-as-a-guest already supports it IIRC, so possibly the problem
> > being addressed in this series could be 'simply' solved using an SCMI
> > backend in the VMM...
> 
> This will be worse than all the options we've tried so far because it
> has the userspace overhead AND uclamp overhead.

But it doesn't violate the whole KVM userspace delegation model, so we
should start from there and then optimize further if need be.

Thanks,
Quentin
