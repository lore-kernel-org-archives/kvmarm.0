Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD8A7E
	for <kvmarm@lists.linux.dev>; Sat, 27 May 2023 19:50:42 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-3f6a6b9bebdso34395e9.0
        for <kvmarm@lists.linux.dev>; Sat, 27 May 2023 12:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685217040; x=1687809040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LtUJ4v++OI133C3lQur1nn4btzIftcEOotoOe/VY9bI=;
        b=h2IaDEykRUyy5myIVn3qgegjA5i6fVdO6k5kQUb3LLZ4aL0/EiLkyNBzKZ0D6r7fG8
         jeP359cYkrIO5+JXb8Cq59Flx9HiZMA3Zg6cDx3oi+iOHyJhR04zt2KLRmYVcsWhOeBf
         WZuRm/quq+pHOMbGpktyFwJv+ZgIeTZl1jeuiHv8Yk+ZJ+ubU8N2BRd87vnpY50dBQR9
         BTjOxTlS+wAMkm9/hMHkHkwqqPHoGKVs1cTM6NlQ1MeD7z3SeBeqlzlgNXkVqssOzNJA
         vtZaM1zeTFRV4Nv15d66NaUXrq/y3q5qHDRD46q7d9khjE21YiCGymo6n1hfHEqBvzAl
         6otg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685217040; x=1687809040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LtUJ4v++OI133C3lQur1nn4btzIftcEOotoOe/VY9bI=;
        b=LXZUvqXeL8kX/Ov2O/TWKxTHkMp1y0ktD2xS2VRKW75UKgl7ILUp611lQw0Ljsw/Dt
         SCBWzK4B/rMTbwVAhQqhoOPstY5p3S/fdGvxI8SIT0GV2aW4L1WWihiKegAj+sukZt9c
         U176rYmjxNV4cfDRyuH7MNcid1M9KySAZiaqKkz18dNrhZMDG4w44mb78l1PwyauLb/3
         pHZ8rtqviudaGfLnQdm+WA/033s4AWwUBXUAV0ubFMoYdB5kHFNd/Og7cMI4+zLJ663q
         GCIINTusjSEeDAUxLGpb3dZLnpHhDuTYququj3Ip23r3HfYrqjxZMi6Zi6yl/sWHFTLr
         cMbg==
X-Gm-Message-State: AC+VfDy+iyVGa9PTHCBPUa3jQyZqyE5EvRWy8rVlib5cyODw2gvN1UE0
	rK6Evcqy7P1cN9vQccwyyVpYgDL6fVN8fG0qBqYS2w==
X-Google-Smtp-Source: ACHHUZ7FxP7iecFmZ9RaQFeLIbhNmx4WGH1ziBGuUIjrPZKMG4Raxil4pkHnfrou6hsED9sXakEEVop5p5RZiY13p4A=
X-Received: by 2002:a05:600c:4f50:b0:3f1:73b8:b5fe with SMTP id
 m16-20020a05600c4f5000b003f173b8b5femr163101wmq.3.1685217040163; Sat, 27 May
 2023 12:50:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230504110003.2548-1-ravi.bangoria@amd.com> <20230504110003.2548-4-ravi.bangoria@amd.com>
 <20230524214133.GA2359762@dev-arch.thelio-3990X> <f02c78e2-34b9-4985-640a-279dae1004a9@amd.com>
 <ZG8KLbZSECiYaKFc@linux.dev> <20230525142031.GU83892@hirez.programming.kicks-ass.net>
 <ZG+FLdP2kkfI1m2Z@linux.dev> <CAP-5=fWYbzmTETgqJ11y22=JaXDM0gnb4qR6KYeRGmFXw08f-Q@mail.gmail.com>
 <86jzwtdhmk.wl-maz@kernel.org> <CAP-5=fVW6KbUbbEfF3mEFvTfFDC5yKSjSpa+w3D55dG3CNUERw@mail.gmail.com>
 <86h6rxd3gh.wl-maz@kernel.org>
In-Reply-To: <86h6rxd3gh.wl-maz@kernel.org>
From: Ian Rogers <irogers@google.com>
Date: Sat, 27 May 2023 12:50:28 -0700
Message-ID: <CAP-5=fXTVgmFcRfYYJraGyNSkDOJqT_HOtkV-bMdjOwLox5rxg@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] perf/core: Remove pmu linear searching code
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Peter Zijlstra <peterz@infradead.org>, 
	Ravi Bangoria <ravi.bangoria@amd.com>, Nathan Chancellor <nathan@kernel.org>, namhyung@kernel.org, 
	eranian@google.com, acme@kernel.org, mark.rutland@arm.com, jolsa@kernel.org, 
	bp@alien8.de, kan.liang@linux.intel.com, adrian.hunter@intel.com, 
	maddy@linux.ibm.com, x86@kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, sandipan.das@amd.com, ananth.narayan@amd.com, 
	santosh.shukla@amd.com, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 27, 2023 at 11:38=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Sat, 27 May 2023 18:00:13 +0100,
> Ian Rogers <irogers@google.com> wrote:
> >
> > On Sat, May 27, 2023 at 6:32=E2=80=AFAM Marc Zyngier <maz@kernel.org> w=
rote:
> > >
> > > On Sat, 27 May 2023 00:00:47 +0100,
> > > Ian Rogers <irogers@google.com> wrote:
> > > >
> > > > On Thu, May 25, 2023 at 8:56=E2=80=AFAM Oliver Upton <oliver.upton@=
linux.dev> wrote:
> > > > >
> > > > > On Thu, May 25, 2023 at 04:20:31PM +0200, Peter Zijlstra wrote:
> > > > > > On Thu, May 25, 2023 at 07:11:41AM +0000, Oliver Upton wrote:
> > > > > >
> > > > > > > The PMUv3 driver does pass a name, but it relies on getting b=
ack an
> > > > > > > allocated pmu id as @type is -1 in the call to perf_pmu_regis=
ter().
> > > > > > >
> > > > > > > What actually broke is how KVM probes for a default core PMU =
to use for
> > > > > > > a guest. kvm_pmu_probe_armpmu() creates a counter w/ PERF_TYP=
E_RAW and
> > > > > > > reads the pmu from the returned perf_event. The linear search=
 had the
> > > > > > > effect of eventually stumbling on the correct core PMU and su=
cceeding.
> > > > > > >
> > > > > > > Perf folks: is this WAI for heterogenous systems?
> > > > > >
> > > > > > TBH, I'm not sure. hetero and virt don't mix very well AFAIK an=
d I'm not
> > > > > > sure what ARM64 does here.
> > > > > >
> > > > > > IIRC the only way is to hard affine things; that is, force vCPU=
 of
> > > > > > 'type' to the pCPU mask of 'type' CPUs.
> > > > >
> > > > > We provide absolutely no illusion of consistency across implement=
ations.
> > > > > Userspace can select the PMU type, and then it is a userspace pro=
blem
> > > > > affining vCPUs to the right pCPUs.
> > > > >
> > > > > And if they get that wrong, we just bail and refuse to run the vC=
PU.
> > > > >
> > > > > > If you don't do that; or let userspace 'override' that, things =
go
> > > > > > sideways *real* fast.
> > > > >
> > > > > Oh yeah, and I wish PMUs were the only problem with these hetero
> > > > > systems...
> > > >
> > > > Just to add some context from what I understand. There are inbuilt
> > > > type numbers for PMUs:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/tree=
/include/uapi/linux/perf_event.h?h=3Dperf-tools-next#n34
> > > > so the PMU generally called /sys/devices/cpu should have type 4 (AR=
M
> > > > give it another name). For heterogeneous ARM there is a single PMU =
and
> > > > the same events are programmed regardless of whether it is a big or=
 a
> > > > little core - the cpumask lists all CPUs.
> > >
> > > I think you misunderstood the way heterogeneous arm64 systems are
> > > described . Each CPU type gets its own PMU type, and its own event
> > > list. Case in point:
> > >
> > > $ grep . /sys/devices/*pmu/{type,cpus}
> > > /sys/devices/apple_avalanche_pmu/type:9
> > > /sys/devices/apple_blizzard_pmu/type:8
> > > /sys/devices/apple_avalanche_pmu/cpus:4-9
> > > /sys/devices/apple_blizzard_pmu/cpus:0-3
> > >
> > > Type 4 (aka PERF_EVENT_RAW) is AFAICT just a way to encode the raw
> > > event number, nothing else.
> >
> > Which PMU will a raw event open on?
>
> On the PMU that matches the current CPU.

Thanks. This should really be captured in the man page. Presumably
that's the behavior with the -1 any CPU, and if a CPU is specified
then the selected PMU will match that CPU?

> > Note, the raw events don't support
> > the extended type that is present in PERF_TYPE_HARDWARE and
> > PERF_TYPE_HW_CACHE:
> > https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/tree/includ=
e/uapi/linux/perf_event.h#n41
> > as the bits are already in use for being just plain config values.
>
> I'm not sure how relevant this is to the numbering of PMUs on arm64.

It matters because on the tool side you can group events, for example
if you are measuring IPC then it makes sense that the instructions and
cycles events are both multiplexed as part of a group. The
instructions and cycles events have a type of PERF_TYPE_HARDWARE as
this is hard coded into the event parser in perf. For perf we may
specify this as:
perf stat -e '{cycles,instructions}' ...
When we open the events on a heterogeneous system the expectation is
we get a group of cycles and instructions for each PMU, the extended
type in the attribute for each event will be set to the type of the
PMU the group is targeting. When we parse the events we have cycles
events per PMU then instructions events per PMU, we then resort and
regroup the events as you can't have a group spanning PMUs except in a
few special cases like software events.

Now let's say we want to do a raw event from the json files, on Intel
let's say we choose the INST_RETIRED.ANY event and we want to measure
it with cycles:
perf stat -e '{cycles,inst_retired.any}' ...
The INST_RETIRED.ANY event will be matched on Intel with the PMUs
"cpu_core" and "cpu_atom" on heterogeneous systems. The cycles event
will be opened on two PMUs and the extended type set to each one. So
we have differing perf_event_attr types, but we know it is valid to
group the events because the raw event encoding's PMU type can be
matched to the extended type of the hardware event.

To better support the wildcard opening, sorting and grouping
operations of events I want to have an ability in the perf tool to map
a type number to a list of PMUs. Mapping a hardware/hw_cache type
number to PMUs should give the set of core PMUs for a heterogeneous
system. On heterogeneous Intel mapping a raw event (type 4) will give
"cpu_core" but it sounds like on ARM, if no sysfs PMU has type number
4, then we should map 4 to the set of core PMUs.

Mapping a type number to a set of perf tool's representation of PMUs
isn't current behavior, but hopefully you can see that ARM's behavior
is differing from Intel's, for which I'd been basing the
implementation so that we can support heterogeneous metrics, etc.

I'm also confused what should be the behavior of something like:
perf stat -e r0 ...
The code is going to open the event on every core PMU with the config set t=
o 0:
https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/tree/tools/p=
erf/util/parse-events.c?h=3Dperf-tools-next#n1485
But perhaps the intent on ARM is that a single raw type event is
opened? It seems the every core PMU behavior is more useful.

> > I suspect not being type 4 is a bug on apple ARM here.
>
> If that's a bug on this machine, it's a bug on all machines, at which
> point it is the de-facto API:
>
> $ grep . /sys/devices/armv8*/{type,cpus}
> /sys/devices/armv8_cortex_a53/type:8
> /sys/devices/armv8_cortex_a72/type:9
> /sys/devices/armv8_cortex_a53/cpus:0-3
> /sys/devices/armv8_cortex_a72/cpus:4-5
>
> See, non-Apple HW. And now for a system with homogeneous CPUs:
>
> $ grep . /sys/devices/armv8*/{type,cpus}
> /sys/devices/armv8_pmuv3_0/type:8
> /sys/devices/armv8_pmuv3_0/cpus:0-159
>
> Still no type 4. I could go on for hours, I have plenty of HW around
> me!

This is good to know, thanks for doing the research. I agree that it
is a de-facto API as this has happened. I'm hoping in the future we
can compress some /sys/devices directories and use them as test input.
It obviously won't be possible to open the events, etc. but we can
test things like the event/metric parsing matches an expectation.

Thanks,
Ian

> So whatever your source of information is, it doesn't match reality.
> Our PMUs are numbered arbitrarily, and have been so for... a very long
> time. At least since perf_pmu_register has supported dynamic
> registration (see 2e80a82a49c4c).
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
