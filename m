Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326F779E2
	for <kvmarm@lists.linux.dev>; Wed,  5 Apr 2023 21:09:21 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id d22so22578772pgw.2
        for <kvmarm@lists.linux.dev>; Wed, 05 Apr 2023 14:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680728960;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6MLGKvl/FzbLKzi4k20FGuOr9OHamYGW4v4bUuCe4Pw=;
        b=n28dxYvaxPfq5JUzsQqU6kb+bImfDaBPK4ACVIjk36q9wbwO2Ix5OhdxzRqVx+gjh7
         vPGDsy2Z/CkVDlg0sacBgvwyhP7Cr0CdN6fmm+V+cxa8+RtEgXZfvRyRNCKyvdMkH3IG
         AZIFu3+14yJXDRgL1cAXUeLDtssdqJhhsK3uUP9LNJOKnlmtgEbiGDaecgZ2kxcyuk+W
         ieFXO/j1UfguA8IRQyx5S+9eNafvz99yFQpPT34J9xYi+XPsnNySq6lG7R9Y+uCWDb48
         YGdH1N2wSkTT52iPU+n1BLdHUrV7R+KBKxYE48TbebgWoPnGhsUXfQZtwsoUmHH5p6Uh
         UXGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680728960;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6MLGKvl/FzbLKzi4k20FGuOr9OHamYGW4v4bUuCe4Pw=;
        b=IDeqy/KOMdx5dhE7U0BSl5P+NDnX6lkoAWvNzRq/08BR85PYxiMaMpH4taDfgq0WgF
         hBCRqO7Kd+1bx6XhabzN8+exqzrlpa6GZHhMn63cIYxHj1/TqX0JrXWdjP2prM8umd1t
         7TJ8IF1EELBy16/RJHr/A9lgC1ScD4hZn6NO6U+sPJ3w45JHDvSHQef4obQP0mdgZWwC
         bUeQi+DEy3d0atWjT9hHu7o31U4u72wh6YqoIbBpTwN6D5bUg3PDPgl0EZDd+dWUEEFq
         UwTeIxBRPwE9XNDyBA3XEUX1D/TwAcpYVSiMjI/vD2lVCIOSZZx6Rge3ThK7nVmV0Oqr
         WKQA==
X-Gm-Message-State: AAQBX9c5MQw8GCzWFN9GCm5yIFMBEOyrpuLo8N9pxg5D2pYg6aYI3zCP
	jVHj10CkTeMwZfKPV8YoeGpu8O9CLWtq5vbYWbR0lw==
X-Google-Smtp-Source: AKy350b0IUXlBzjwLLr6SEpK1cx38ABlr+yVbGlA9Wc0dSXUg0uG5eQHWSVFl7t3uBAdQCZoYdM8DgcCcOXiLa8I580=
X-Received: by 2002:a65:430c:0:b0:514:3d3d:da5a with SMTP id
 j12-20020a65430c000000b005143d3dda5amr427665pgq.3.1680728960348; Wed, 05 Apr
 2023 14:09:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230330224348.1006691-1-davidai@google.com> <20230405080548.GW4253@hirez.programming.kicks-ass.net>
In-Reply-To: <20230405080548.GW4253@hirez.programming.kicks-ass.net>
From: Saravana Kannan <saravanak@google.com>
Date: Wed, 5 Apr 2023 14:08:43 -0700
Message-ID: <CAGETcx-qgKeUQ60VhvW+hYUY-sMh-wX1G8zSwJUFpJ-u7aU6aA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] Improve VM DVFS and task placement behavior
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Dai <davidai@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>, 
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, kernel-team@android.com, 
	linux-pm@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 5, 2023 at 1:06=E2=80=AFAM Peter Zijlstra <peterz@infradead.org=
> wrote:
>
> On Thu, Mar 30, 2023 at 03:43:35PM -0700, David Dai wrote:
> > Hi,
> >
> > This patch series is a continuation of the talk Saravana gave at LPC 20=
22
> > titled "CPUfreq/sched and VM guest workload problems" [1][2][3]. The gi=
st
> > of the talk is that workloads running in a guest VM get terrible task
> > placement and DVFS behavior when compared to running the same workload =
in
> > the host. Effectively, no EAS for threads inside VMs. This would make p=
ower
> > and performance terrible just by running the workload in a VM even if w=
e
> > assume there is zero virtualization overhead.
> >
> > We have been iterating over different options for communicating between
> > guest and host, ways of applying the information coming from the
> > guest/host, etc to figure out the best performance and power improvemen=
ts
> > we could get.
> >
> > The patch series in its current state is NOT meant for landing in the
> > upstream kernel. We are sending this patch series to share the current
> > progress and data we have so far. The patch series is meant to be easy =
to
> > cherry-pick and test on various devices to see what performance and pow=
er
> > benefits this might give for others.
> >
> > With this series, a workload running in a VM gets the same task placeme=
nt
> > and DVFS treatment as it would when running in the host.
> >
> > As expected, we see significant performance improvement and better
> > performance/power ratio. If anyone else wants to try this out for your =
VM
> > workloads and report findings, that'd be very much appreciated.
> >
> > The idea is to improve VM CPUfreq/sched behavior by:
> > - Having guest kernel to do accurate load tracking by taking host CPU
> >   arch/type and frequency into account.
> > - Sharing vCPU run queue utilization information with the host so that =
the
> >   host can do proper frequency scaling and task placement on the host s=
ide.
>
> So, not having actually been send many of the patches I've no idea what
> you've done... Please, eradicate this ridiculous idea of sending random
> people a random subset of a patch series. Either send all of it or none,
> this is a bloody nuisance.

Sorry, that was our intention, but had a scripting error. It's been fixed.

I have a script to use with git send-email's --to-cmd and --cc-cmd
option. It uses get_maintainers.pl to figure out who to email, but it
gets trickier for a patch series that spans maintainer trees.

v2 and later will have everyone get all the patches.

> Having said that; my biggest worry is that you're making scheduler
> internals into an ABI. I would hate for this paravirt interface to tie
> us down.

The only 2 pieces of information shared between host/guest are:

1. Host CPU frequency -- this isn't really scheduler internals and
will map nicely to a virtual cpufreq driver.

2. A vCPU util value between 0 - 1024 where 1024 corresponds to the
highest performance point across all CPUs (taking freq, arch, etc into
consideration). Yes, this currently matches how the run queue util is
tracked, but we can document the interface as "percentage of max
performance capability", but representing it as 0 - 1024 instead of
0-100. That way, even if the scheduler changes how it tracks util in
the future, we can still keep this interface between guest/host and
map it appropriately on the host end.

In either case, we could even have a Windows guest where they might
track vCPU utilization differently and still have this work with the
Linux host with this interface.

Does that sound reasonable to you?

Another option is to convert (2) into a "CPU frequency" request (but
without latching it to values in the CPUfreq table) but it'll add some
unnecessary math (with division) on the guest and host end. But I'd
rather keep it as 0-1024 unless you really want this 2nd option.

-Saravana
