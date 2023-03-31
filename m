Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449961365
	for <kvmarm@lists.linux.dev>; Fri, 31 Mar 2023 01:44:15 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id y144-20020a253296000000b00b69ce0e6f2dso20616721yby.18
        for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 18:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680227054;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eZ4PHHENXGuqsZbHm4mt2XcePTaUKXLCPERF+StGgcM=;
        b=byEvGPUVr2MSf5P2gMsYTojEZ8IMp0gd3j2gxno1q78+AxohjbjcGxpAEoMssVwZgj
         4b5WrBJGFKA9+FQxyIG51iBidiatnl5nq1zCyzxEicJPZy7iwaYYatvfwztSPb1LtbV2
         MLwmR9XXbUjBS1je5hN+ZqgFnZRfC32cNH1JlgVX9QJlNKJszx0LUvy88yBnY9a9zbT+
         FeuIkYxHiyaWGj/fbkvYyfM3FYd3mnfadeO6aoCONqNhr/UrYy4O2YoayrT422de3LVg
         ZLjiUKUFzKXif8MYEXQEK/W9ehyvO9ewkb6j3fpCL7LcTaC4sA4joMfNvb5z2pse8duS
         +qIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680227054;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eZ4PHHENXGuqsZbHm4mt2XcePTaUKXLCPERF+StGgcM=;
        b=atiAuS8vdqKA5d9YHoWv2yt2xwqBPd5GZ33qXPYrp/UOz7yujKaD1EVMaOhSp0CYsO
         UNFdEWlc6micwLAAHXA5NV7fU8cxzuppz3MX6nZsaGwvJr8K83B4W20zop/WaGnLmJvY
         AKY1AxH9d73/75MiHVy4WDxTkN0rNywSWYVyJotv4mOS43Xy6/uwyH5gBtBOrJyz2wPg
         5p1z01OAXNHnGSMqZmpQs/X+5jXxe+4nOaH++8c9DkDQTNQAQ7hLicp8zeg1ZOIUaDar
         KGUW9eysTvU9nZ92L3GDTYWAtz+lTHUqYJwB8fI/sm6ZZFUb2A5ewkOMh0mdbTjrOQAX
         4QKg==
X-Gm-Message-State: AAQBX9fDMBROJCi2X7bNi2gYI/hb1MO87jdq9MudBlVMmWot3Zd6EF5O
	bqDUEgSH3Q6AQ4YOon8zMZqonKTOFIY6
X-Google-Smtp-Source: AKy350bG/63Hbame7qrZpgQm5ciYGaedSqrkJ7v3HnjGyYZlP+kMOXYakagDSafH2bqA/axxUc5jRAxgRqdw
X-Received: from davidai2.mtv.corp.google.com ([2620:15c:211:201:c162:24e8:ec5e:d520])
 (user=davidai job=sendgmr) by 2002:a25:d9d6:0:b0:b80:e387:f6af with SMTP id
 q205-20020a25d9d6000000b00b80e387f6afmr1131177ybg.2.1680227054263; Thu, 30
 Mar 2023 18:44:14 -0700 (PDT)
Date: Thu, 30 Mar 2023 18:43:44 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230331014356.1033759-1-davidai@google.com>
Subject: [RFC PATCH v2 0/6] Improve VM CPUfreq and task placement behavior
From: David Dai <davidai@google.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>, 
	Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, David Dai <davidai@google.com>
Cc: Saravana Kannan <saravanak@google.com>, kernel-team@android.com, linux-pm@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi,

This patch series is a continuation of the talk Saravana gave at LPC 2022
titled "CPUfreq/sched and VM guest workload problems" [1][2][3]. The gist
of the talk is that workloads running in a guest VM get terrible task
placement and CPUfreq behavior when compared to running the same workload
in the host. Effectively, no EAS(Energy Aware Scheduling) for threads
inside VMs. This would make power and performance terrible just by running
the workload in a VM even if we assume there is zero virtualization
overhead.

We have been iterating over different options for communicating between
guest and host, ways of applying the information coming from the
guest/host, etc to figure out the best performance and power improvements
we could get.

The patch series in its current state is NOT meant for landing in the
upstream kernel. We are sending this patch series to share the current
progress and data we have so far. The patch series is meant to be easy to
cherry-pick and test on various devices to see what performance and power
benefits this might give for others.

With this series, a workload running in a VM gets the same task placement
and CPUfreq behavior as it would when running in the host.

As expected, we see significant performance improvement and better
performance/power ratio. If anyone else wants to try this out for your VM
workloads and report findings, that'd be very much appreciated.

The idea is to improve VM CPUfreq/sched behavior by:
- Having guest kernel to do accurate load tracking by taking host CPU
  arch/type and frequency into account.
- Sharing vCPU run queue utilization information with the host so that the
  host can do proper frequency scaling and task placement on the host side.

Results:
========

As of right now, the best results have been with using hypercalls (see more
below first) to communicate between host and guest and treating the vCPU
run queue util similar to util_est on the host side vCPU thread. So that's
what this patch series does.

Let's look at the results for this series first and then look at the other
options we are trying/tried out:

Use cases running Android inside a VM on a Chromebook:
======================================================

PCMark (Emulates real world usecases)
Higher is better
+-------------------+----------+------------+--------+
| Test Case (score) | Baseline | Util_guest | %delta |
+-------------------+----------+------------+--------+
| Weighted Total    |     6136 |       7274 |   +19% |
+-------------------+----------+------------+--------+
| Web Browsing      |     5558 |       6273 |   +13% |
+-------------------+----------+------------+--------+
| Video Editing     |     4921 |       5221 |    +6% |
+-------------------+----------+------------+--------+
| Writing           |     6864 |       8825 |   +29% |
+-------------------+----------+------------+--------+
| Photo Editing     |     7983 |      11593 |   +45% |
+-------------------+----------+------------+--------+
| Data Manipulation |     5814 |       6081 |    +5% |
+-------------------+----------+------------+--------+

PCMark Performance/mAh
Higher is better
+-----------+----------+------------+--------+
|           | Baseline | Util_guest | %delta |
+-----------+----------+------------+--------+
| Score/mAh |       79 |         88 |   +11% |
+-----------+----------+------------+--------+

Roblox
Higher is better
+-----+----------+------------+--------+
|     | Baseline | Util_guest | %delta |
+-----+----------+------------+--------+
| FPS |    18.25 |      28.66 |   +57% |
+-----+----------+------------+--------+

Roblox Frames/mAh
Higher is better
+--------+----------+------------+--------+
|        | Baseline | Util_guest | %delta |
+--------+----------+------------+--------+
| Frames |    91.25 |     114.64 |   +26% |
+--------+----------+------------+--------+

Use cases running a minimal system inside a VM on a Pixel 6:
============================================================

FIO
Higher is better
+----------------------+----------+------------+--------+
| Test Case (avg MB/s) | Baseline | Util_guest | %delta |
+----------------------+----------+------------+--------+
| Seq Write            |     9.27 |       12.6 |   +36% |
+----------------------+----------+------------+--------+
| Rand Write           |     9.34 |       11.9 |   +27% |
+----------------------+----------+------------+--------+
| Seq Read             |      106 |        124 |   +17% |
+----------------------+----------+------------+--------+
| Rand Read            |     33.6 |         35 |    +4% |
+----------------------+----------+------------+--------+

CPU-based ML Inference Benchmark
Lower is better
+-------------------------+----------+------------+--------+
| Test Case (ms)          | Baseline | Util_guest | %delta |
+-------------------------+----------+------------+--------+
| Cached Sample Inference |     2.57 |       1.75 |   -32% |
+-------------------------+----------+------------+--------+
| Small Sample Inference  |      6.8 |       5.57 |   -18% |
+-------------------------+----------+------------+--------+
| Large Sample Inference  |     31.2 |      26.58 |   -15% |
+-------------------------+----------+------------+--------+

These patches expect the host to:
- Affine vCPUs to specific clusters.
- Set vCPU capacity to match the host CPU they are running on.

To make this easy to do/try out, we have put up patches[4][5] to do this on
CrosVM. Once you pick up those patches, you can use options
"--host-cpu-topology" and "--virt-cpufreq" to achieve the above.

The patch series can be broken into:

Patch 1: Add util_guest as an additional PELT signal for host vCPU threads
Patch 2: Hypercall for guest to get current pCPU's frequency
Patch 3: Send vCPU run queue util to host and apply as util_guest
Patch 4: Query pCPU freq table from guest (we'll move this to DT in the
	 future)
Patch 5: Virtual cpufreq driver that uses the hypercalls to send util to
	 host and implement frequency invariance in the guest.

Alternative we have implemented and profiled:
=============================================

util_guest vs uclamp_min
========================

One suggestion at LPC was to use uclamp_min to apply the util info coming
from the guest. As we suspected, it doesn't perform as well because
uclamp_min is not additive, whereas the actual workload on the host CPU due
to the vCPU is additive to the existing workloads on the host. Uclamp_min
also has the undesirable side-effect of threads forked from the vCPU thread
inheriting whatever uclamp_min value the vCPU thread had and then getting
stuck with that uclamp_min value.

Below are some additional benchmark results comparing the uclamp_min
prototype (listed as Uclamp) using the same test environment as before
(including hypercalls).

As before, %delta is always comparing to baseline.

PCMark
Higher is better
+-------------------+----------+------------+--------+--------+--------+
| Test Case (score) | Baseline | Util_guest | %delta | Uclamp | %delta |
+-------------------+----------+------------+--------+--------+--------+
| Weighted Total    |     6136 |       7274 |   +19% |   6848 |   +12% |
+-------------------+----------+------------+--------+--------+--------+
| Web Browsing      |     5558 |       6273 |   +13% |   6050 |    +9% |
+-------------------+----------+------------+--------+--------+--------+
| Video Editing     |     4921 |       5221 |    +6% |   5091 |    +3% |
+-------------------+----------+------------+--------+--------+--------+
| Writing           |     6864 |       8825 |   +29% |   8523 |   +24% |
+-------------------+----------+------------+--------+--------+--------+
| Photo Editing     |     7983 |      11593 |   +45% |   9865 |   +24% |
+-------------------+----------+------------+--------+--------+--------+
| Data Manipulation |     5814 |       6081 |    +5% |   5836 |     0% |
+-------------------+----------+------------+--------+--------+--------+

PCMark Performance/mAh
Higher is better
+-----------+----------+------------+--------+--------+--------+
|           | Baseline | Util_guest | %delta | Uclamp | %delta |
+-----------+----------+------------+--------+--------+--------+
| Score/mAh |       79 |         88 |   +11% |     83 |    +7% |
+-----------+----------+------------+--------+--------+--------+

Hypercalls vs MMIO:
===================
We realize that hypercalls are not the recommended choice for this and we
have no attachment to any communication method as long as it gives good
results.

We started off with hypercalls to see what is the best we could achieve if
we didn't have to context switch into host side userspace.

To see the impact of switching from hypercalls to MMIO, we kept util_guest
and only switched from hypercall to MMIO. So in the results below:
- Hypercall = hypercall + util_guest
- MMIO = MMIO + util_guest

As before, %delta is always comparing to baseline.

PCMark
Higher is better
+-------------------+----------+------------+--------+-------+--------+
| Test Case (score) | Baseline |  Hypercall | %delta |  MMIO | %delta |
+-------------------+----------+------------+--------+-------+--------+
| Weighted Total    |     6136 |       7274 |   +19% |  6867 |   +12% |
+-------------------+----------+------------+--------+-------+--------+
| Web Browsing      |     5558 |       6273 |   +13% |  6035 |    +9% |
+-------------------+----------+------------+--------+-------+--------+
| Video Editing     |     4921 |       5221 |    +6% |  5167 |    +5% |
+-------------------+----------+------------+--------+-------+--------+
| Writing           |     6864 |       8825 |   +29% |  8529 |   +24% |
+-------------------+----------+------------+--------+-------+--------+
| Photo Editing     |     7983 |      11593 |   +45% | 10812 |   +35% |
+-------------------+----------+------------+--------+-------+--------+
| Data Manipulation |     5814 |       6081 |    +5% |  5327 |    -8% |
+-------------------+----------+------------+--------+-------+--------+

PCMark Performance/mAh
Higher is better
+-----------+----------+-----------+--------+------+--------+
|           | Baseline | Hypercall | %delta | MMIO | %delta |
+-----------+----------+-----------+--------+------+--------+
| Score/mAh |       79 |        88 |   +11% |   83 |    +7% |
+-----------+----------+-----------+--------+------+--------+

Roblox
Higher is better
+-----+----------+------------+--------+-------+--------+
|     | Baseline |  Hypercall | %delta |  MMIO | %delta |
+-----+----------+------------+--------+-------+--------+
| FPS |    18.25 |      28.66 |   +57% | 24.06 |   +32% |
+-----+----------+------------+--------+-------+--------+

Roblox Frames/mAh
Higher is better
+------------+----------+------------+--------+--------+--------+
|            | Baseline |  Hypercall | %delta |   MMIO | %delta |
+------------+----------+------------+--------+--------+--------+
| Frames/mAh |    91.25 |     114.64 |   +26% | 103.11 |   +13% |
+------------+----------+------------+--------+--------+--------+

Next steps:
===========
We are continuing to look into communication mechanisms other than
hypercalls that are just as/more efficient and avoid switching into the VMM
userspace. Any inputs in this regard are greatly appreciated.

Thanks,
David & Saravana

Cc: Saravana Kannan <saravanak@google.com>

v1 -> v2:
- Added description for EAS and removed DVFS in coverletter.
- Added a v2 tag to the subject.
- Fixed up the inconsistent "units" between tables.
- Made sure everyone is To/Cc-ed for all the patches in the series.

[1] - https://lpc.events/event/16/contributions/1195/
[2] - https://lpc.events/event/16/contributions/1195/attachments/970/1893/LPC%202022%20-%20VM%20DVFS.pdf
[3] - https://www.youtube.com/watch?v=hIg_5bg6opU
[4] - https://chromium-review.googlesource.com/c/crosvm/crosvm/+/4208668
[5] - https://chromium-review.googlesource.com/c/crosvm/crosvm/+/4288027

David Dai (6):
  sched/fair: Add util_guest for tasks
  kvm: arm64: Add support for get_cur_cpufreq service
  kvm: arm64: Add support for util_hint service
  kvm: arm64: Add support for get_freqtbl service
  dt-bindings: cpufreq: add bindings for virtual kvm cpufreq
  cpufreq: add kvm-cpufreq driver

 .../bindings/cpufreq/cpufreq-virtual-kvm.yaml |  39 +++
 Documentation/virt/kvm/api.rst                |  28 ++
 .../virt/kvm/arm/get_cur_cpufreq.rst          |  21 ++
 Documentation/virt/kvm/arm/get_freqtbl.rst    |  23 ++
 Documentation/virt/kvm/arm/index.rst          |   3 +
 Documentation/virt/kvm/arm/util_hint.rst      |  22 ++
 arch/arm64/include/uapi/asm/kvm.h             |   3 +
 arch/arm64/kvm/arm.c                          |   3 +
 arch/arm64/kvm/hypercalls.c                   |  60 +++++
 drivers/cpufreq/Kconfig                       |  13 +
 drivers/cpufreq/Makefile                      |   1 +
 drivers/cpufreq/kvm-cpufreq.c                 | 245 ++++++++++++++++++
 include/linux/arm-smccc.h                     |  21 ++
 include/linux/sched.h                         |  12 +
 include/uapi/linux/kvm.h                      |   3 +
 kernel/sched/core.c                           |  24 +-
 kernel/sched/fair.c                           |  15 +-
 tools/arch/arm64/include/uapi/asm/kvm.h       |   3 +
 18 files changed, 536 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.yaml
 create mode 100644 Documentation/virt/kvm/arm/get_cur_cpufreq.rst
 create mode 100644 Documentation/virt/kvm/arm/get_freqtbl.rst
 create mode 100644 Documentation/virt/kvm/arm/util_hint.rst
 create mode 100644 drivers/cpufreq/kvm-cpufreq.c

-- 
2.40.0.348.gf938b09366-goog

