Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3E434CE2
	for <kvmarm@lists.linux.dev>; Wed, 31 May 2023 20:20:20 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1b025aaeddbso5555ad.1
        for <kvmarm@lists.linux.dev>; Wed, 31 May 2023 13:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685564420; x=1688156420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xAVHdgjCcaQ5AFDJRIEUK8SLG9WPMFRziVwBFjnP+jM=;
        b=Nv7qOeVLe72ezZKUWypYggz5/CiKmIku+u9LGBbUyELSXM9pYp3g1u3T0UbdxhEV3q
         QVfRW6ok3FxCJAd0prJYv40lre+F4ncLWwKtUKmAvU5w/5dlZzP7EhQ56Zpab66tU9gq
         w3tU7ySe1ggSmHZ6zMDMYcBiJTF8OVngEuZusvPj13k7tVIf6KdjjKT9zRFUNd3qprUU
         UHbGsD13WrpJ2AZPUvit3pseulw0+iCWE1Q31I1q+8yBRj5g9xrYTYUboAL0RmjhOY4C
         KQdMqt9bSNN4RU+EV8hI9Z5ByzEaJ6n66S0nqYhJk5XiqAcQ4gMo3vzybsMyAZ8yHWbL
         j7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685564420; x=1688156420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xAVHdgjCcaQ5AFDJRIEUK8SLG9WPMFRziVwBFjnP+jM=;
        b=fKZhHqCqXtNhJRqjx3Vj44rDOLS8e6aG2LkJjoBkZWDs1NDul/9wfPpBjWEgeS5jRZ
         RI3g2qJpqIJVLbp5EcNwI3m0oHgfVpOvHb3xLoZ9cnTEEqUf4M7cYl3qrmR1s/G+vQgR
         TalHmeXW0cVB+TVOineDy4/eKe5THgL6T/LnnmyyZDcnBkVXy5a9hVx/QcrxMQM+Jdbb
         uuD005HJm5oR4QA4AFvA07EfEnuyg2pVQ2zvJTmXybo1Gciza8zE9+rXSiQIkOwGA+h6
         sOc2dRtZe7qlC3D9s6iC06WbGDvbrbYxI5I0StMPFBOt5u7QXeQ0Ip2l+rXAzNaqXLD0
         subQ==
X-Gm-Message-State: AC+VfDzzNLc2WQhDAsL9WcuQwRlfhyguG1RbkB1+OonI1GlhuI/yXaZ5
	uLeCcYd9Yn4ZZJdxXfg2egxYhMbWhJnX/Mio7veXyQ==
X-Google-Smtp-Source: ACHHUZ6wL7U8V/XkpYOMrfW1mzAy/rgPNBZK5vlJcway9TKqXNM1bfxFTaloddleGXya5qBUG5EQLR0Gp4g46YdCW1Q=
X-Received: by 2002:a17:902:f315:b0:1b0:cea:294e with SMTP id
 c21-20020a170902f31500b001b00cea294emr27790ple.21.1685564419572; Wed, 31 May
 2023 13:20:19 -0700 (PDT)
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
 <86h6rxd3gh.wl-maz@kernel.org> <0075d8a9-2df4-86eb-8171-8995f59904e0@linux.ibm.com>
 <CAP-5=fXo0t+buDrmf7SyTD97gmTWGoDAO2YXWyav+_79O3MZ0w@mail.gmail.com> <a1f27798-0b06-7dc3-028b-038512947306@linux.ibm.com>
In-Reply-To: <a1f27798-0b06-7dc3-028b-038512947306@linux.ibm.com>
From: Ian Rogers <irogers@google.com>
Date: Wed, 31 May 2023 13:20:07 -0700
Message-ID: <CAP-5=fVw3vSEu7yGFDnZi8c3VUFJu_XEZtY9ZcTsD7ip2imR6Q@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] perf/core: Remove pmu linear searching code
To: Thomas Richter <tmricht@linux.ibm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Ravi Bangoria <ravi.bangoria@amd.com>, 
	Nathan Chancellor <nathan@kernel.org>, namhyung@kernel.org, eranian@google.com, 
	acme@kernel.org, mark.rutland@arm.com, jolsa@kernel.org, bp@alien8.de, 
	kan.liang@linux.intel.com, adrian.hunter@intel.com, maddy@linux.ibm.com, 
	x86@kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, sandipan.das@amd.com, ananth.narayan@amd.com, 
	santosh.shukla@amd.com, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 31, 2023 at 2:09=E2=80=AFAM Thomas Richter <tmricht@linux.ibm.c=
om> wrote:
>
> On 5/30/23 16:00, Ian Rogers wrote:
> > ls /sys/devices/*/cpu*
>
> Hi Ian,
>
> here is the output yo requested:
>
> # ls /sys/devices/*/cpu*
> cpu0  cpu3  cpu6         hotplug     modalias  possible  smt
> cpu1  cpu4  cpu7         isolated    offline   present   uevent
> cpu2  cpu5  dispatching  kernel_max  online    rescan    vulnerabilities
> #
>
> In fact it is the same as
> # ls  /sys/devices/system/cpu/
> cpu0  cpu3  cpu6         hotplug     modalias  possible  smt
> cpu1  cpu4  cpu7         isolated    offline   present   uevent
> cpu2  cpu5  dispatching  kernel_max  online    rescan    vulnerabilities
> #
> This directory tree has nothing to do with events for perf, it is
> merely used to support CPU hotplug on s390.
>
> The PMUs on s390 are
> # ls -ld /sys/devices/{cpum_,pai_}*
> drwxr-xr-x 4 root root 0 May 25 15:45 /sys/devices/cpum_cf
> drwxr-xr-x 4 root root 0 May 25 15:45 /sys/devices/cpum_cf_diag
> drwxr-xr-x 4 root root 0 May 25 15:45 /sys/devices/cpum_sf
> drwxr-xr-x 4 root root 0 May 25 15:45 /sys/devices/pai_crypto
> drwxr-xr-x 4 root root 0 May 25 15:45 /sys/devices/pai_ext
> #
>
> I hope his helps.

Thanks Thomas,

The perf tool has a notion of "core" and "other" PMUs - other means
uncore and things like interconnect PMUs. The distinction matters as
PMUs may have a list of CPUs with them, for "other" PMUs the CPU list
(known in the tool as the CPU map) is a suggestion of the CPU to open
events on. For example, on my laptop:
```
$ cat /sys/devices/system/cpu/online
0-15
$ cat /sys/devices/uncore_imc_free_running_0/cpumask
0
```
So I have 16 "CPUs" and the memory controller is suggesting opening
the events on CPU 0. However, if I do:
```
$ sudo perf stat -e 'uncore_imc_free_running_0/data_read/' -C 8 -a -A sleep=
 1

Performance counter stats for 'system wide':

CPU8                 4,617.60 MiB
uncore_imc_free_running_0/data_read/


      1.001094684 seconds time elapsed
```
Then things are good and the event was recorded on CPU 8, even though
the cpumask of the PMU only said CPU 0.

For "core" PMUs the CPU map works differently. A CPU outside of the
map is an error. For example, if I have a heterogeneous system with 2
CPUs, the first CPU on 1 PMU and the second CPU on a different PMU, if
I try to open events for the wrong PMU  type for the CPU then it
should fail. The CPU map should be interpreted as the set of CPUs
events are valid on.

The logic to determine if a PMU is "core" or "other" is here:
https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/tree/tools/p=
erf/util/pmu.c?h=3Dperf-tools-next#n1417
https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/tree/tools/p=
erf/util/pmu.c?h=3Dperf-tools-next#n609

That is, a PMU is a "core" PMU if it is called "cpu" or if there is a
file called "cpus" inside the PMU's sysfs directory. It seems on s390
none of the PMUs are considered "core" and this is why we're having
issues.

Looking at:
https://lore.kernel.org/lkml/20180416132314.33249-1-tmricht@linux.ibm.com/

It would seem to make sense that "cpu", "cpum_cf" and "cpum_sf" should
all cause "is_pmu_core" to return true, From your output I suspect the
issue is that cpum_cf and cpum_sf both lack the "cpus" file - which is
also true on homogeneous x86's "cpu" PMU. We can fix the code with:

```
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 0520aa9fe991..bdc3f3b148fc 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -1414,7 +1414,9 @@ void perf_pmu__del_formats(struct list_head *formats)

bool is_pmu_core(const char *name)
{
-       return !strcmp(name, "cpu") || is_sysfs_pmu_core(name);
+       return !strcmp(name, "cpu") ||
+              !strcmp(name, "cpum_cf") || !strcmp(name, "cpum_sf") ||
+              is_sysfs_pmu_core(name);
}

bool perf_pmu__supports_legacy_cache(const struct perf_pmu *pmu)
```

Wdyt? Thanks,
Ian

> --
> Thomas Richter, Dept 3303, IBM s390 Linux Development, Boeblingen, German=
y
> --
> Vorsitzender des Aufsichtsrats: Gregor Pillen
> Gesch=C3=A4ftsf=C3=BChrung: David Faller
> Sitz der Gesellschaft: B=C3=B6blingen / Registergericht: Amtsgericht Stut=
tgart, HRB 243294
>
