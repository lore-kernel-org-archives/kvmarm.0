Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E015115B7
	for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 23:08:30 +0000 (UTC)
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-4f1217f16e9so1232e87.0
        for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 16:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685142509; x=1687734509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aQm0gmotPrah6x+grG9q4OwSJysvwUdj8gXMKuWCdC8=;
        b=GgOh49ZYJZyw5BuVFLr5N/oRkD/zm+nNImmJihXENRaZsCEErJqecQWEEYc2s52/3s
         HNq22GBX/qF+hjvL/I5P9rRnc9bzNwSRQ3eC6b1O+chWp45ABCOxJijHBmMvoAfbHlAp
         h7pg6y37u0ngQnz1VhckNCdMZbu1YszTbEY40LWTZNsuVTY2vSbAfv1WN5DyI3zuZ9Kc
         nqtPjOacAvBoEh1UjCsdDc51h5G6w3WIOYkFN7Ka/k5iVsUlXz5NW+wfMxZdvLUgNGkc
         8oR4HAWQX9H8wlGoz+iKgtMLiJ7/stNfn0+DEbBynOI4raIfEwKS6yG+HBipzBqFBHY3
         sCjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685142509; x=1687734509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aQm0gmotPrah6x+grG9q4OwSJysvwUdj8gXMKuWCdC8=;
        b=baf6aCb9KgrjxTh17hNiknMZ2/USaHacbTRQhM+1BAHHkq1sX0ohScXRPrX4a3lXXh
         of6jhChA0CxnP3fh4n33Mkam0lKOUqEuKstP9PW24iu8Dm+s/2Na+7R44frC9wKOKqe1
         8oiFNaoUldgvrTXLoVjFUZSc0VcnPfIu54FBLqTThaZcrqI0khnUSVGK/pVvGhAWNHWd
         GD34VxRjzGkuKMuOz2qf4avvzyjaGKtyVxdyqorKTac54Gx99gY1CRc8nEI7K/Ee0gKr
         3rodbVxU125tqCit+iRMYCSLz78jErJ0uOEwh5lxWilqKjFS2DgwGkyTfU7DQFCt2EoH
         2zhQ==
X-Gm-Message-State: AC+VfDwEzPz1hVrVWgGVKFDWJXfMKR1T1H/qQFS439EZbxBhPU+RipxT
	Muu2zyW5+GU2jgT/01lFpVV0OnYArS88wufLyEGTLg==
X-Google-Smtp-Source: ACHHUZ7a8zznLZd4lC0AduIo/JFkybDmh4b51Aye1LX/4ZElq5Y8xpY1F0uk+ktmYVc2ax/VATPKbTUA5Vr7GtECDXw=
X-Received: by 2002:a05:600c:3b8d:b0:3f1:9396:6fbf with SMTP id
 n13-20020a05600c3b8d00b003f193966fbfmr67517wms.4.1685142060245; Fri, 26 May
 2023 16:01:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230504110003.2548-1-ravi.bangoria@amd.com> <20230504110003.2548-4-ravi.bangoria@amd.com>
 <20230524214133.GA2359762@dev-arch.thelio-3990X> <f02c78e2-34b9-4985-640a-279dae1004a9@amd.com>
 <ZG8KLbZSECiYaKFc@linux.dev> <20230525142031.GU83892@hirez.programming.kicks-ass.net>
 <ZG+FLdP2kkfI1m2Z@linux.dev>
In-Reply-To: <ZG+FLdP2kkfI1m2Z@linux.dev>
From: Ian Rogers <irogers@google.com>
Date: Fri, 26 May 2023 16:00:47 -0700
Message-ID: <CAP-5=fWYbzmTETgqJ11y22=JaXDM0gnb4qR6KYeRGmFXw08f-Q@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] perf/core: Remove pmu linear searching code
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>, Ravi Bangoria <ravi.bangoria@amd.com>, 
	Nathan Chancellor <nathan@kernel.org>, namhyung@kernel.org, eranian@google.com, 
	acme@kernel.org, mark.rutland@arm.com, jolsa@kernel.org, bp@alien8.de, 
	kan.liang@linux.intel.com, adrian.hunter@intel.com, maddy@linux.ibm.com, 
	x86@kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, sandipan.das@amd.com, ananth.narayan@amd.com, 
	santosh.shukla@amd.com, maz@kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 25, 2023 at 8:56=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Thu, May 25, 2023 at 04:20:31PM +0200, Peter Zijlstra wrote:
> > On Thu, May 25, 2023 at 07:11:41AM +0000, Oliver Upton wrote:
> >
> > > The PMUv3 driver does pass a name, but it relies on getting back an
> > > allocated pmu id as @type is -1 in the call to perf_pmu_register().
> > >
> > > What actually broke is how KVM probes for a default core PMU to use f=
or
> > > a guest. kvm_pmu_probe_armpmu() creates a counter w/ PERF_TYPE_RAW an=
d
> > > reads the pmu from the returned perf_event. The linear search had the
> > > effect of eventually stumbling on the correct core PMU and succeeding=
.
> > >
> > > Perf folks: is this WAI for heterogenous systems?
> >
> > TBH, I'm not sure. hetero and virt don't mix very well AFAIK and I'm no=
t
> > sure what ARM64 does here.
> >
> > IIRC the only way is to hard affine things; that is, force vCPU of
> > 'type' to the pCPU mask of 'type' CPUs.
>
> We provide absolutely no illusion of consistency across implementations.
> Userspace can select the PMU type, and then it is a userspace problem
> affining vCPUs to the right pCPUs.
>
> And if they get that wrong, we just bail and refuse to run the vCPU.
>
> > If you don't do that; or let userspace 'override' that, things go
> > sideways *real* fast.
>
> Oh yeah, and I wish PMUs were the only problem with these hetero
> systems...

Just to add some context from what I understand. There are inbuilt
type numbers for PMUs:
https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/tree/include=
/uapi/linux/perf_event.h?h=3Dperf-tools-next#n34
so the PMU generally called /sys/devices/cpu should have type 4 (ARM
give it another name). For heterogeneous ARM there is a single PMU and
the same events are programmed regardless of whether it is a big or a
little core - the cpumask lists all CPUs. On heterogeneous (aka
hybrid) Intel there are two PMUs, the performance cores have a PMU
called /sys/devices/cpu_core and it has type 4, the atom cores have a
PMU of /sys/devices/cpu_atom and on my Alderlake the type number is 8.
The cpu_core and cpu_atom PMUs list the CPUs that are valid for raw
style events, where the config values in perf_event_attr contains all
of the event programming data. There are also legacy events of
PERF_TYPE_HARDWARE and PERF_TYPE_HW_CACHE where to specify the PMU the
type is encoded in the high (and unused) 32-bits of config - so the
type would be something like PERF_TYPE_HARDWARE and then config would
be "value | (4 << 32)" for the performance core or "value | (8 << 32)"
for the atom.

If the vCPU and pCPUs mappings vary then there is a chance to change
the CPU mask on heterogeneous Intel, but it seems if the event is open
and you move from between core types then things are going to break.

Thanks,
Ian

> > Mark gonna have to look at this.
>
> Cool. I'll go ahead with the KVM cleanup regardless of the outcome.
>
> --
> Thanks,
> Oliver
