Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B04D33A038
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766167924; cv=none; b=X3qbbLfa41W9J+Ph3ZDlGdXLVV95vEfvCCAq/TqifN/VT3iZw8L4rVV2BfXEbathBNAFnbYoc8EOeXOU5IMDTG4Tb3gxTe7Wug2oS2ZiCsMho28NT5yu6jDga8D/yPLHY0/bzgAu4bEWrsGP8DP5KlptZ250alPbp4KXNgsXWOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766167924; c=relaxed/simple;
	bh=9NNzmT2xyu6HStKrqvuYrFQ+CDUXbNz45KJaRmyY0cg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XqXEMdwPj0XpyW1BUl5GNHJuG7NmY7kLj+hqqBAvqIvL81J4N2PM3nJVMVdMjWfWvPh3lQjRV20/PCVCSBU4kDZN+HfVxFmy6YLONb8ehA9ivWIgZDrm2+gWkELePhplF4i/ft8ySmVgb3WhCw2/2UwsYGgtXpcxqvctlVafGic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4E898FEC;
	Fri, 19 Dec 2025 10:11:54 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 00BA63F5CA;
	Fri, 19 Dec 2025 10:11:56 -0800 (PST)
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
	kvmarm@lists.linux.dev
Subject: [PATCH v2 00/45] arm_mpam: Add KVM/arm64 and resctrl glue code
Date: Fri, 19 Dec 2025 18:11:02 +0000
Message-ID: <20251219181147.3404071-1-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

As James is otherwise engaged this version of the MPAM missing pieces comes
from me. I hope this does justice to all his hardwork. The changes that
I've brought to this version are the handling of systems with SME, some rework
of the KVM parts, a few small bug fixes and some tidying.

This may be the first time you are seeing this series as James spared some
of you as the rfc was posted during merge window.

One major departure from the previous snapshot branches referenced in the
base driver series is that the same MPAM setting are used for kernel-space
and user-space. That is, MPAM1_EL1 is set to the same value as MPAM0_EL1
rather than keeping the default value. The advantages of this are that it
is closer to the x86 model where the closid is globally applicable, all
partids are usable from user-space and user-space can't bypass MPAM
controls by doing the work in the kernel. However, this causes some
priority inversion where a high priority task waits to take a mutex held by
another whose resources are restricted by MPAM. It also adds some extra
isb(). I would be interested in opinions/data on the policy for MPAM in
kernel space, i.e how MPAM1_EL1 is set.

Change list in patches.

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


Based on v6.19-rc1
This series can be retrieved from:
https://gitlab.arm.com/linux-arm/linux-bh.git mpam_resctrl_glue_v2

Ben Horgan (7):
  arm_mpam: Stop using uninitialized variables in __ris_msmon_read()
  arm_mpam: Use non-atomic bitops when modifying feature bitmap
  arm64/sysreg: Add MPAMSM_EL1 register
  KVM: arm64: Preserve host MPAM configuration when changing traps
  KVM: arm64: Make MPAMSM_EL1 accesses UNDEF
  arm64: mpam: Initialise and context switch the MPAMSM_EL1 register
  KVM: arm64: Use kernel-space partid configuration for hypercalls

Dave Martin (2):
  arm_mpam: resctrl: Convert to/from MPAMs fixed-point formats
  arm_mpam: resctrl: Add kunit test for control format conversions

James Morse (31):
  arm64: mpam: Context switch the MPAM registers
  arm64: mpam: Re-initialise MPAM regs when CPU comes online
  arm64: mpam: Advertise the CPUs MPAM limits to the driver
  arm64: mpam: Add cpu_pm notifier to restore MPAM sysregs
  arm64: mpam: Add helpers to change a task or cpu's MPAM PARTID/PMG
    values
  KVM: arm64: Force guest EL1 to use user-space's partid configuration
  arm_mpam: resctrl: Add boilerplate cpuhp and domain allocation
  arm_mpam: resctrl: Sort the order of the domain lists
  arm_mpam: resctrl: Pick the caches we will use as resctrl resources
  arm_mpam: resctrl: Implement resctrl_arch_reset_all_ctrls()
  arm_mpam: resctrl: Add resctrl_arch_get_config()
  arm_mpam: resctrl: Implement helpers to update configuration
  arm_mpam: resctrl: Add plumbing against arm64 task and cpu hooks
  arm_mpam: resctrl: Add CDP emulation
  arm_mpam: resctrl: Add rmid index helpers
  arm_mpam: resctrl: Add support for 'MB' resource
  arm_mpam: resctrl: Add support for csu counters
  arm_mpam: resctrl: Pick classes for use as mbm counters
  arm_mpam: resctrl: Pre-allocate free running monitors
  arm_mpam: resctrl: Pre-allocate assignable monitors
  arm_mpam: resctrl: Add kunit test for ABMC/CDP interactions
  arm_mpam: resctrl: Add resctrl_arch_config_cntr() for ABMC use
  arm_mpam: resctrl: Allow resctrl to allocate monitors
  arm_mpam: resctrl: Add resctrl_arch_rmid_read() and
    resctrl_arch_reset_rmid()
  arm_mpam: resctrl: Add resctrl_arch_cntr_read() &
    resctrl_arch_reset_cntr()
  arm_mpam: resctrl: Update the rmid reallocation limit
  arm_mpam: resctrl: Add empty definitions for assorted resctrl
    functions
  arm64: mpam: Select ARCH_HAS_CPU_RESCTRL
  arm_mpam: resctrl: Call resctrl_init() on platforms that can support
    resctrl
  arm_mpam: Generate a configuration for min controls
  arm_mpam: Quirk CMN-650's CSU NRDY behaviour

Jiapeng Chong (1):
  arm_mpam: Remove duplicate linux/srcu.h header

Shanker Donthineni (4):
  arm_mpam: Add quirk framework
  arm_mpam: Add workaround for T241-MPAM-1
  arm_mpam: Add workaround for T241-MPAM-4
  arm_mpam: Add workaround for T241-MPAM-6

 Documentation/arch/arm64/silicon-errata.rst |    9 +
 arch/arm64/Kconfig                          |    6 +-
 arch/arm64/include/asm/el2_setup.h          |    3 +-
 arch/arm64/include/asm/mpam.h               |  104 +
 arch/arm64/include/asm/resctrl.h            |    2 +
 arch/arm64/include/asm/thread_info.h        |    3 +
 arch/arm64/kernel/Makefile                  |    1 +
 arch/arm64/kernel/cpufeature.c              |   21 +-
 arch/arm64/kernel/mpam.c                    |   58 +
 arch/arm64/kernel/process.c                 |    7 +
 arch/arm64/kvm/hyp/include/hyp/switch.h     |   12 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c          |    5 +
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c          |   11 +
 arch/arm64/kvm/sys_regs.c                   |    2 +
 arch/arm64/tools/sysreg                     |    8 +
 drivers/resctrl/Kconfig                     |    9 +-
 drivers/resctrl/Makefile                    |    1 +
 drivers/resctrl/mpam_devices.c              |  314 ++-
 drivers/resctrl/mpam_internal.h             |  128 +-
 drivers/resctrl/mpam_resctrl.c              | 1941 +++++++++++++++++++
 drivers/resctrl/test_mpam_devices.c         |   66 +
 drivers/resctrl/test_mpam_resctrl.c         |  374 ++++
 include/linux/arm_mpam.h                    |   32 +
 23 files changed, 3080 insertions(+), 37 deletions(-)
 create mode 100644 arch/arm64/include/asm/mpam.h
 create mode 100644 arch/arm64/include/asm/resctrl.h
 create mode 100644 arch/arm64/kernel/mpam.c
 create mode 100644 drivers/resctrl/mpam_resctrl.c
 create mode 100644 drivers/resctrl/test_mpam_resctrl.c

-- 
2.43.0

