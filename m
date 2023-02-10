Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC40863AB
	for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 16:55:15 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id r126-20020a632b84000000b004393806c06eso2806455pgr.4
        for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 08:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/T7AMdhFLGitDXHZ5/TfRi2ULQMYcZwnIbHev2XdwW0=;
        b=W9p/dZOcq6Yrc4yvBEoJQaIdVvvUWQFCmtOwR8Yajzr08GgV7Sj0rLyD/x8KqLBZMr
         DfL5q09Qgs7SmvILLDxBUmZmVXD4M8nPzD+BwiuyarUPAdmIi93tCwxnjPXLqHPb9UG+
         HO9E1/VvCqpuwyn0wyC5OZrbDykhAbicVPfxq0EDMpkWSQKA08UULhfQ8kecC1Ay3Jl5
         rb1z5UZzHJMVoeMg7S6UhPIAZ6ZwJAoXI2LUps9b2YaSakDa+7jRzwL31yRUrL/hY9vC
         WAyc09K7uHelvmpX6OcLVlAni+u6lRCHwV9pBGss0VRWxNnc/PjV76/MSSX/nMtWwHAu
         Webg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/T7AMdhFLGitDXHZ5/TfRi2ULQMYcZwnIbHev2XdwW0=;
        b=h8mfS+kW6a6XioPL+TLQdYL1MYGelmMStaHwRcqKrBC9WtGkf62TpNwunlTEEBdwz4
         HPifDLfnkj4iznR3+uom6qOJra4if1EscaAAhNXMwjaYnNwdFGka12gK6KNvVhzYk//I
         Lr4CkzbbYY0f6WPCnLJn6HRg0zKApoqJvvW1os8gCRDVf8hmGiAGHTu5d9mPHIQ1sHF+
         cIstK788T5pCLo2Bj0kTvF9zyIIGYKmTuPgy3cjXOlGYN/Q3WOvc58cne1lQfkyuZ2Ud
         xT5uAEWn9o27yZvnvdwSRRi5L1ALm8mghPpQly1b1zby6gTxSdXWjFDH+EQImV+Zdmdv
         4W6w==
X-Gm-Message-State: AO0yUKUuDtuRMGs387MCFiQPiROWYNe7HPdfXtPcKbJb7IhzRF+ddpxE
	B0xEb+V9nYKvqK/kxQtQRul5mWJfnxNH8N4=
X-Google-Smtp-Source: AK7set8EEM2vPuWTtNSdApk5kfdc5jxhS8S3smtK3/eWyLn1K5CRolTI3MKSZV4+jhJat0Wcjkt5P+MgOeWbLGU=
X-Received: from zaidcloud.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5325])
 (user=zalbassam job=sendgmr) by 2002:a17:90a:280a:b0:231:1912:b40d with SMTP
 id e10-20020a17090a280a00b002311912b40dmr2050226pjd.116.1676048115339; Fri,
 10 Feb 2023 08:55:15 -0800 (PST)
Date: Fri, 10 Feb 2023 11:54:52 -0500
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210165500.2292608-1-zalbassam@google.com>
Subject: [PATCH v2 0/8] perf: arm: Make PMUv3 driver available for aarch32
From: Zaid Al-Bassam <zalbassam@google.com>
To: Jesus Sanchez-Palencia <jesussanp@google.com>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu
Cc: Zaid Al-Bassam <zalbassam@google.com>
Content-Type: text/plain; charset="UTF-8"

Currently, PMUv3 driver is only available for ARMv8 aarch64 platforms,
ARMv8 platorms running in aarch32 mode dont have access to the driver.
This is, especially, a problem for ARMv8 platforms that only have
aarch32 support, like the Cortex-A32.

Make the PMUv3 driver available to arm arch (ARMv8 aarch32) by moving
the PMUv3 driver from arm64 to drivers, that makes the driver common
to both arm and arm64 architectures, then add PMUv3 arm Support.

The main work in this patchset was made a while back by Marc Zyngier
in [1]. This patchset rebases Marc's patches to the latest kernel
revision and adds additional patches to accommodate the changes in the
kernel since Marc wrote the patches.

This is the v2 of the patch series [v1]. This version of the patchset
was created by Marc Zyngier and I picked it up from [2].

Changes in v2:
- Flattened the nested switches in the arm_pmuv3.h for arm.
- Removed wrappers and added stubs for the PMU KVM functions for arm.
- Added PMU version abstractions.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm/pmuv3-32bit
[2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=arm/pmuv3

[v1] https://lore.kernel.org/all/20230126204444.2204061-1-zalbassam@google.com/

Thank you,
Zaid Al-Bassam

Marc Zyngier (5):
  arm64: perf: Move PMUv3 driver to drivers/perf
  arm64: perf: Abstract system register accesses away
  ARM: Make CONFIG_CPU_V7 valid for 32bit ARMv8 implementations
  ARM: perf: Allow the use of the PMUv3 driver on 32bit ARM
  ARM: mach-virt: Select PMUv3 driver by default

Zaid Al-Bassam (3):
  perf: pmuv3: Abstract PMU version checks
  perf: pmuv3: Move inclusion of kvm_host.h to the arch-specific helper
  perf: pmuv3: Change GENMASK to GENMASK_ULL

 arch/arm/Kconfig                              |   1 +
 arch/arm/include/asm/arm_pmuv3.h              | 259 ++++++++++++++
 arch/arm/mm/Kconfig                           |   2 +-
 arch/arm64/include/asm/arm_pmuv3.h            | 167 ++++++++++
 arch/arm64/include/asm/perf_event.h           | 249 --------------
 arch/arm64/kernel/Makefile                    |   1 -
 drivers/perf/Kconfig                          |  10 +
 drivers/perf/Makefile                         |   1 +
 .../perf_event.c => drivers/perf/arm_pmuv3.c  | 131 ++------
 include/kvm/arm_pmu.h                         |   2 +-
 include/linux/perf/arm_pmuv3.h                | 315 ++++++++++++++++++
 11 files changed, 787 insertions(+), 351 deletions(-)
 create mode 100644 arch/arm/include/asm/arm_pmuv3.h
 create mode 100644 arch/arm64/include/asm/arm_pmuv3.h
 rename arch/arm64/kernel/perf_event.c => drivers/perf/arm_pmuv3.c (93%)
 create mode 100644 include/linux/perf/arm_pmuv3.h

-- 
2.39.1.581.gbfd45094c4-goog

