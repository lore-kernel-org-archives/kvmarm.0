Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D03051DED42
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 14:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773413194; cv=none; b=bX0ZQ9KwI0FDNo38UX/DCBW/hnd37Y2Pd6NwzGzd6akKH+5F2gPUWR5KtNjdFdkF5aOoJ6etGdUhdfWver65Oy6Ih3hhRKZH7QtY3vKvUHL/3h/9mDZpQWbxFYGCHuem0CN7GzVntvZ/siAihuG7x2MJP+dh3h4i/t4ibPSOZTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773413194; c=relaxed/simple;
	bh=jzqsjmeLNr/xcBs+A5KH2SZFPD7jl0BQuqsT+7ffjNc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JWvfVk4am5CoeZKPaQpVLOyLBVn5P+deL55v60UwvK4PbQVwfwQLRhUw8haAxv3uCf6JrofMICcVjo/1QXKc76JJWqlI2XaEtdxNY8n3bzrHKmKTPC/L4fe4Typ8S/+OCWxUNsSLR3lRtYLAppM1KVep9NuVJTN8HKyEfm8ktzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 235F71CC4;
	Fri, 13 Mar 2026 07:46:26 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6AFB33F7BD;
	Fri, 13 Mar 2026 07:46:28 -0700 (PDT)
From: Ben Horgan <ben.horgan@arm.com>
To: ben.horgan@arm.com
Cc: amitsinght@marvell.com,
	baisheng.gao@unisoc.com,
	baolin.wang@linux.alibaba.com,
	carl@os.amperecomputing.com,
	dave.martin@arm.com,
	david@kernel.org,
	dfustini@baylibre.com,
	fenghuay@nvidia.com,
	gshan@redhat.com,
	james.morse@arm.com,
	jonathan.cameron@huawei.com,
	kobak@nvidia.com,
	lcherian@marvell.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	peternewman@google.com,
	punit.agrawal@oss.qualcomm.com,
	quic_jiles@quicinc.com,
	reinette.chatre@intel.com,
	rohit.mathew@arm.com,
	scott@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	tan.shaopeng@fujitsu.com,
	xhao@linux.alibaba.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	corbet@lwn.net,
	maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	kvmarm@lists.linux.dev,
	zengheng4@huawei.com,
	linux-doc@vger.kernel.org
Subject: [PATCH v6 00/40] arm_mpam: Add KVM/arm64 and resctrl glue code
Date: Fri, 13 Mar 2026 14:45:37 +0000
Message-ID: <20260313144617.3420416-1-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This version of the mpam missing pieces series sees a couple of things
dropped or hidden. Memory bandwith utilization with free-running counters
is dropped in preference of just always using 'mbm_event' mode (ABMC
emulation) which simplifies the code and allows for, in the future,
filtering by read/write traffic. So, for the interim, there is no memory
bandwidth utilization support. CDP is hidden behind config expert as
remount of resctrl fs could potentially lead to out of range PARTIDs being
used and the fix requires a change in fs/resctrl. The setting of MPAM2_EL2
(for pkvm/nvhe) is dropped as too expensive a write for not much value.

There are a couple of 'fixes' at the start of the series which address
problems in the base driver but are only user visible due to this series.

Changelogs in patches

Thanks for all the reviewing and testing so far. Just a bit more to get this
over the line.

There is a small build conflict with the MPAM abmc precursors series [1], which
alters some of the resctrl arch hooks. I will shortly be posting a respin
of that too.

[1] https://lore.kernel.org/lkml/20260225201905.3568624-1-ben.horgan@arm.com/

From James' cover letter:

This is the missing piece to make MPAM usable resctrl in user-space. This has
shed its debugfs code and the read/write 'event configuration' for the monitors
to make the series smaller.

This adds the arch code and KVM support first. I anticipate the whole thing
going via arm64, but if goes via tip instead, the an immutable branch with those
patches should be easy to do.

Generally the resctrl glue code works by picking what MPAM features it can expose
from the MPAM drive, then configuring the structs that back the resctrl helpers.
If your platform is sufficiently Xeon shaped, you should be able to get L2/L3 CPOR
bitmaps exposed via resctrl. CSU counters work if they are on/after the L3. MBWU
counters are considerably more hairy, and depend on hueristics around the topology,
and a bunch of stuff trying to emulate ABMC.
If it didn't pick what you wanted it to, please share the debug messages produced
when enabling dynamic debug and booting with:
| dyndbg="file mpam_resctrl.c +pl"

I've not found a platform that can test all the behaviours around the monitors,
so this is where I'd expect the most bugs.

The MPAM spec that describes all the system and MMIO registers can be found here:
https://developer.arm.com/documentation/ddi0598/db/?lang=en
(Ignored the 'RETIRED' warning - that is just arm moving the documentation around.
 This document has the best overview)


Based on v7.0-rc3

The series can be retrieved from:
https://gitlab.arm.com/linux-arm/linux-bh.git mpam_resctrl_glue_v6

v5 can be found at:
https://lore.kernel.org/linux-arm-kernel/20260224175720.2663924-1-ben.horgan@arm.com/

v4 can be found at:
https://lore.kernel.org/linux-arm-kernel/20260203214342.584712-1-ben.horgan@arm.com/

v3 can be found at:
https://lore.kernel.org/linux-arm-kernel/20260112165914.4086692-1-ben.horgan@arm.com/

v2 can be found at:
https://lore.kernel.org/linux-arm-kernel/20251219181147.3404071-1-ben.horgan@arm.com/

rfc can be found at:
https://lore.kernel.org/linux-arm-kernel/20251205215901.17772-1-james.morse@arm.com/

Ben Horgan (11):
  arm_mpam: Reset when feature configuration bit unset
  arm64/sysreg: Add MPAMSM_EL1 register
  KVM: arm64: Preserve host MPAM configuration when changing traps
  KVM: arm64: Make MPAMSM_EL1 accesses UNDEF
  arm64: mpam: Drop the CONFIG_EXPERT restriction
  arm64: mpam: Initialise and context switch the MPAMSM_EL1 register
  arm_mpam: resctrl: Hide CDP emulation behind CONFIG_EXPERT
  arm_mpam: resctrl: Add rmid index helpers
  arm_mpam: resctrl: Wait for cacheinfo to be ready
  arm_mpam: resctrl: Add monitor initialisation and domain boilerplate
  arm64: mpam: Add initial MPAM documentation

Dave Martin (2):
  arm_mpam: resctrl: Convert to/from MPAMs fixed-point formats
  arm_mpam: resctrl: Add kunit test for control format conversions

James Morse (22):
  arm64: mpam: Context switch the MPAM registers
  arm64: mpam: Re-initialise MPAM regs when CPU comes online
  arm64: mpam: Advertise the CPUs MPAM limits to the driver
  arm64: mpam: Add cpu_pm notifier to restore MPAM sysregs
  arm64: mpam: Add helpers to change a task or cpu's MPAM PARTID/PMG
    values
  KVM: arm64: Force guest EL1 to use user-space's partid configuration
  arm_mpam: resctrl: Add boilerplate cpuhp and domain allocation
  arm_mpam: resctrl: Pick the caches we will use as resctrl resources
  arm_mpam: resctrl: Implement resctrl_arch_reset_all_ctrls()
  arm_mpam: resctrl: Add resctrl_arch_get_config()
  arm_mpam: resctrl: Implement helpers to update configuration
  arm_mpam: resctrl: Add plumbing against arm64 task and cpu hooks
  arm_mpam: resctrl: Add CDP emulation
  arm_mpam: resctrl: Add support for 'MB' resource
  arm_mpam: resctrl: Add support for csu counters
  arm_mpam: resctrl: Allow resctrl to allocate monitors
  arm_mpam: resctrl: Add resctrl_arch_rmid_read()
  arm_mpam: resctrl: Update the rmid reallocation limit
  arm_mpam: resctrl: Add empty definitions for assorted resctrl
    functions
  arm64: mpam: Select ARCH_HAS_CPU_RESCTRL
  arm_mpam: resctrl: Call resctrl_init() on platforms that can support
    resctrl
  arm_mpam: Quirk CMN-650's CSU NRDY behaviour

Shanker Donthineni (4):
  arm_mpam: Add quirk framework
  arm_mpam: Add workaround for T241-MPAM-1
  arm_mpam: Add workaround for T241-MPAM-4
  arm_mpam: Add workaround for T241-MPAM-6

Zeng Heng (1):
  arm_mpam: Ensure in_reset_state is false after applying configuration

 Documentation/arch/arm64/index.rst          |    1 +
 Documentation/arch/arm64/mpam.rst           |   72 +
 Documentation/arch/arm64/silicon-errata.rst |    9 +
 arch/arm64/Kconfig                          |    6 +-
 arch/arm64/include/asm/el2_setup.h          |    3 +-
 arch/arm64/include/asm/mpam.h               |   96 ++
 arch/arm64/include/asm/resctrl.h            |    2 +
 arch/arm64/include/asm/thread_info.h        |    3 +
 arch/arm64/kernel/Makefile                  |    1 +
 arch/arm64/kernel/cpufeature.c              |   21 +-
 arch/arm64/kernel/mpam.c                    |   62 +
 arch/arm64/kernel/process.c                 |    7 +
 arch/arm64/kvm/hyp/include/hyp/switch.h     |   12 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c          |   16 +
 arch/arm64/kvm/sys_regs.c                   |    2 +
 arch/arm64/tools/sysreg                     |    8 +
 drivers/resctrl/Kconfig                     |    9 +-
 drivers/resctrl/Makefile                    |    1 +
 drivers/resctrl/mpam_devices.c              |  303 +++-
 drivers/resctrl/mpam_internal.h             |  104 +-
 drivers/resctrl/mpam_resctrl.c              | 1710 +++++++++++++++++++
 drivers/resctrl/test_mpam_resctrl.c         |  315 ++++
 include/linux/arm_mpam.h                    |   32 +
 23 files changed, 2740 insertions(+), 55 deletions(-)
 create mode 100644 Documentation/arch/arm64/mpam.rst
 create mode 100644 arch/arm64/include/asm/mpam.h
 create mode 100644 arch/arm64/include/asm/resctrl.h
 create mode 100644 arch/arm64/kernel/mpam.c
 create mode 100644 drivers/resctrl/mpam_resctrl.c
 create mode 100644 drivers/resctrl/test_mpam_resctrl.c

-- 
2.43.0

