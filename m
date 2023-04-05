Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97B3622
	for <kvmarm@lists.linux.dev>; Wed,  5 Apr 2023 08:34:10 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso3282267pjc.1
        for <kvmarm@lists.linux.dev>; Wed, 05 Apr 2023 01:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680683650; x=1683275650;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uswkZCNmvnRlVRQCSju2fZnjPjabnOYplQP8HVJ2wjE=;
        b=hDTg9cZ5dgqFve21IhvP0vjH/LT5Qn7NqlC7lp8kDbxvOzwqcjsmIaSgUiFkxF9/rA
         CX6RJ+FZxOinhHJXTmJWHeiM0PU12K7peccwTyhJ8SacTyOawUNsD711ZuiS/VYAiGjD
         JxibN6nFFF/mlX0xY9ioRXj8B1hj/IrRo1VRraKc0O5K/v3oPqUvBr2n5pgr62FnlVaU
         2hRpKMOuYdJLVWz7IDpKKO6Go35uPSTQZUdpvVPnGKhPc+aWLP8aA0Tz8VCWrmG+oJjo
         p54SNKfSHgQ/MCAetv/xg7nmJSwNXLhATwlFTNFdgDWIHq16UuKOooTHU7SDn+oVRjSK
         JQPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680683650; x=1683275650;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uswkZCNmvnRlVRQCSju2fZnjPjabnOYplQP8HVJ2wjE=;
        b=WWh9YQr0t9pKMwvytFm5Q8Va9WGSpHIOByyIqI+r+f/GSKjkekVU5iYhipcXT21JoI
         Q5tq2/f8fVaq5BrXV3G5H/0OnP74bAnikMW8Ozi+hxcG5qj+iqNDsojmIb+Kgqv8dTDW
         jSfMOYEk7Z/O8620KJ4JDr2+dhPiaQrQr2zDFyTyXepErYHTMjPQHzvMjpjoWURhTeeB
         x05LudZwF2yzutSbF/j1lmiKi2s68mmH4FixnY0hkUcOVElIvVhZ2Lz+Gg/dn6JVYx2B
         xwFDS6chVklz3QRgSOZi9VHmYtyFdyUOb7APQ/kfjynn1qIgvgzn7R5/e5CZalZCbALp
         2XWQ==
X-Gm-Message-State: AAQBX9dMqOm78rqPTgtduUhnee6jy5eaaSKe93ank74kpYWFw4ScYNp1
	Te9J1WTanbBnWm3xmbSodetVBxzhDXWXDp/EoYBouA==
X-Google-Smtp-Source: AKy350ZAsaPHdY8c5KE9TLI0KeNHy+W9j9/lSgVgAc0xT/TIw+751YYthPnT3mfZja3e78XtuRBHMTFr1xtbfMMwycs=
X-Received: by 2002:a17:90a:d201:b0:240:d8d8:12c4 with SMTP id
 o1-20020a17090ad20100b00240d8d812c4mr1918429pju.3.1680683649941; Wed, 05 Apr
 2023 01:34:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230330224348.1006691-1-davidai@google.com> <ZCx97IKjsBibjdGc@linux.dev>
 <86sfdfv0e1.wl-maz@kernel.org> <ZC0n0HRsmNJeJZps@google.com>
In-Reply-To: <ZC0n0HRsmNJeJZps@google.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 5 Apr 2023 10:33:58 +0200
Message-ID: <CAKfTPtBaXao2oFjFy7Zx8T6orBgC=+zw7L+mF3My7kOFAvg2Og@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] Improve VM DVFS and task placement behavior
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, David Dai <davidai@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, 
	Sudeep Holla <sudeep.holla@arm.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, kernel-team@android.com, 
	linux-pm@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, 5 Apr 2023 at 09:48, Quentin Perret <qperret@google.com> wrote:
>
> On Tuesday 04 Apr 2023 at 21:49:10 (+0100), Marc Zyngier wrote:
> > On Tue, 04 Apr 2023 20:43:40 +0100,
> > Oliver Upton <oliver.upton@linux.dev> wrote:
> > >
> > > Folks,
> > >
> > > On Thu, Mar 30, 2023 at 03:43:35PM -0700, David Dai wrote:
> > >
> > > <snip>
> > >
> > > > PCMark
> > > > Higher is better
> > > > +-------------------+----------+------------+--------+-------+--------+
> > > > | Test Case (score) | Baseline |  Hypercall | %delta |  MMIO | %delta |
> > > > +-------------------+----------+------------+--------+-------+--------+
> > > > | Weighted Total    |     6136 |       7274 |   +19% |  6867 |   +12% |
> > > > +-------------------+----------+------------+--------+-------+--------+
> > > > | Web Browsing      |     5558 |       6273 |   +13% |  6035 |    +9% |
> > > > +-------------------+----------+------------+--------+-------+--------+
> > > > | Video Editing     |     4921 |       5221 |    +6% |  5167 |    +5% |
> > > > +-------------------+----------+------------+--------+-------+--------+
> > > > | Writing           |     6864 |       8825 |   +29% |  8529 |   +24% |
> > > > +-------------------+----------+------------+--------+-------+--------+
> > > > | Photo Editing     |     7983 |      11593 |   +45% | 10812 |   +35% |
> > > > +-------------------+----------+------------+--------+-------+--------+
> > > > | Data Manipulation |     5814 |       6081 |    +5% |  5327 |    -8% |
> > > > +-------------------+----------+------------+--------+-------+--------+
> > > >
> > > > PCMark Performance/mAh
> > > > Higher is better
> > > > +-----------+----------+-----------+--------+------+--------+
> > > > |           | Baseline | Hypercall | %delta | MMIO | %delta |
> > > > +-----------+----------+-----------+--------+------+--------+
> > > > | Score/mAh |       79 |        88 |   +11% |   83 |    +7% |
> > > > +-----------+----------+-----------+--------+------+--------+
> > > >
> > > > Roblox
> > > > Higher is better
> > > > +-----+----------+------------+--------+-------+--------+
> > > > |     | Baseline |  Hypercall | %delta |  MMIO | %delta |
> > > > +-----+----------+------------+--------+-------+--------+
> > > > | FPS |    18.25 |      28.66 |   +57% | 24.06 |   +32% |
> > > > +-----+----------+------------+--------+-------+--------+
> > > >
> > > > Roblox Frames/mAh
> > > > Higher is better
> > > > +------------+----------+------------+--------+--------+--------+
> > > > |            | Baseline |  Hypercall | %delta |   MMIO | %delta |
> > > > +------------+----------+------------+--------+--------+--------+
> > > > | Frames/mAh |    91.25 |     114.64 |   +26% | 103.11 |   +13% |
> > > > +------------+----------+------------+--------+--------+--------+
> > >
> > > </snip>
> > >
> > > > Next steps:
> > > > ===========
> > > > We are continuing to look into communication mechanisms other than
> > > > hypercalls that are just as/more efficient and avoid switching into the VMM
> > > > userspace. Any inputs in this regard are greatly appreciated.
> > >
> > > We're highly unlikely to entertain such an interface in KVM.
> > >
> > > The entire feature is dependent on pinning vCPUs to physical cores, for which
> > > userspace is in the driver's seat. That is a well established and documented
> > > policy which can be seen in the way we handle heterogeneous systems and
> > > vPMU.
> > >
> > > Additionally, this bloats the KVM PV ABI with highly VMM-dependent interfaces
> > > that I would not expect to benefit the typical user of KVM.
> > >
> > > Based on the data above, it would appear that the userspace implementation is
> > > in the same neighborhood as a KVM-based implementation, which only further
> > > weakens the case for moving this into the kernel.
> > >
> > > I certainly can appreciate the motivation for the series, but this feature
> > > should be in userspace as some form of a virtual device.
> >
> > +1 on all of the above.
>
> And I concur with all the above as well. Putting this in the kernel is
> not an obvious fit at all as that requires a number of assumptions about
> the VMM.
>
> As Oliver pointed out, the guest topology, and how it maps to the host
> topology (vcpu pinning etc) is very much a VMM policy decision and will
> be particularly important to handle guest frequency requests correctly.
>
> In addition to that, the VMM's software architecture may have an impact.
> Crosvm for example does device emulation in separate processes for
> security reasons, so it is likely that adjusting the scheduling
> parameters ('util_guest', uclamp, or else) only for the vCPU thread that
> issues frequency requests will be sub-optimal for performance, we may
> want to adjust those parameters for all the tasks that are on the
> critical path.
>
> And at an even higher level, assuming in the kernel a certain mapping of
> vCPU threads to host threads feels kinda wrong, this too is a host
> userspace policy decision I believe. Not that anybody in their right
> mind would want to do this, but I _think_ it would technically be
> feasible to serialize the execution of multiple vCPUs on the same host
> thread, at which point the util_guest thingy becomes entirely bogus. (I
> obviously don't want to conflate this use-case, it's just an example
> that shows the proposed abstraction in the series is not a perfect fit
> for the KVM userspace delegation model.)
>
> So +1 from me to move this as a virtual device of some kind. And if the
> extra cost of exiting all the way back to userspace is prohibitive (is
> it btw?), then we can try to work on that. Maybe something a la vhost
> can be done to optimize, I'll have a think.
>
> > The one thing I'd like to understand that the comment seems to imply
> > that there is a significant difference in overhead between a hypercall
> > and an MMIO. In my experience, both are pretty similar in cost for a
> > handling location (both in userspace or both in the kernel). MMIO
> > handling is a tiny bit more expensive due to a guaranteed TLB miss
> > followed by a walk of the in-kernel device ranges, but that's all. It
> > should hardly register.
> >
> > And if you really want some super-low latency, low overhead
> > signalling, maybe an exception is the wrong tool for the job. Shared
> > memory communication could be more appropriate.
>
> I presume some kind of signalling mechanism will be necessary to
> synchronously update host scheduling parameters in response to guest
> frequency requests, but if the volume of data requires it then a shared
> buffer + doorbell type of approach should do.
>
> Thinking about it, using SCMI over virtio would implement exactly that.
> Linux-as-a-guest already supports it IIRC, so possibly the problem
> being addressed in this series could be 'simply' solved using an SCMI
> backend in the VMM...

This is what was suggested at LPC:
using virtio-scmi and scmi performance domain in the guest for cpufreq driver
using a vhost user scmi backend in user space
from this vhost userspace backend updates the uclamp min of the vCPU
thread or use another method is this one is not good enough

>
> Thanks,
> Quentin
