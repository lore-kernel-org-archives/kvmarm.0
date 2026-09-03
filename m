Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 269004BB5B9
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451598; cv=none; b=qYuVZ6aSziWBjwIAYPr7HdFqxSin0j16qzGF9aYoZfaHSV3jDyG4oa/pzw5Vhp1VTZ2lcRrmju2jnwnoa3LjM/5l4AFw7jLIxYBYQEjO1/zaDe26mMSzH8Cg6X4D7wNFtPLkHR6rKqZT6xTxF4o9pfK3Dao2cTgIIHPcZmIOuJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451598; c=relaxed/simple;
	bh=HM37sRmR8ELFrusFfw+j9FkVS/6z+h0NmGPWHs3yAyI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=MWivFmn5fJMrURor5X3hDtZMl4AvpDwWNsC8jS9RCAv+Z4lZ5Cw8XUoXW2IJq7RciaLUEJobIllOeIYLi407g7yo+A1whMivp7WegeBcmfI6W4AwH7yf2ba3V/dcJQ/wsnoOErJR0XjC1EpndR8aTGL5N/7SUuw984jn36pJYQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=n8/ehIsl; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="n8/ehIsl"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE9C61596;
	Thu,  3 Sep 2026 09:06:31 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B246C3F673;
	Thu,  3 Sep 2026 09:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451595; bh=HM37sRmR8ELFrusFfw+j9FkVS/6z+h0NmGPWHs3yAyI=;
	h=From:To:Subject:Date:From;
	b=n8/ehIsl3G9J8JsV39vR+cWUgjjRmdG/IIq4cfX+Ln/Z4mQz0BcYdsPI5ahp0TPVC
	 gOyc7mJyohxf+/AQHOX6eBORFNFmuh1LpAS5dAeHrzqEVL+aAvGdlXG7xLlfjR96Ab
	 OrxgU6qXg1r+rrjx3rzkwXzWy01TlGjSXNS99TQE=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	will@kernel.org,
	mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org,
	catalin.marinas@arm.com,
	james.clark@linaro.org
Subject: [RFC PATCH v7 00/28] KVM: arm64: Add Statistical Profiling Extension (SPE) support
Date: Thu,  3 Sep 2026 17:05:55 +0100
Message-ID: <20260903160623.315525-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For a description of the problem, and why using gup doesn't work, see the
previous iteration of the series, version v6 [1].

This series is based on v7.3-rc1.

I've completely changed the approach yet again, but I've kept Reviewed-by tags
for the some of the prerequisite patches. The highlights are:

* The entire memory is effectively pinned at stage 2 before the first VCPU is
run by having userspace use guest_memfd to back VM memory and then doing
KVM_PRE_FAULT_MEMORY on that memory.

This change alone simplifies the code immensly.

* The maximum buffer size does not need to be virtualized since the entire VM
memory is pinned, which means that PMBIDR_EL1 doesn't need to be trapped.
SPE features cannot be completely hidden from the guest, as some of them (most
of them?) add new fields to the records. The end result: PMBIDR_EL1 and
PMSIDR_EL1 don't need to be trapped, so the dependency on FEAT_FGT is dropped.

* It works with the SPE host driver built as a module; KVM requires that the
module is loaded for SPE to be virtualized.

The end result is that KVM support is mostly reduced to the userspace ABI to
configure the feature and context switching the SPE state.


Prerequisites
=============

There are several prerequisites:

* The series depends on KVM_PRE_FAULT_MEMORY being implemented for arm64.
There are two different implementations of that on the mailing list: [2], [3]. I
have chosen to use the series from Jack Thomson [2] (rebased on top of v7.3-rc1
+ the SPE patches) for the simple reason that it doesn't change the way KVM
handles stage 2 faults, and can be cherry-picked *after* the KVM SPE patches, to
allow sashiko to review the SPE patches.

* A patch to explicitely ignore MMU notifiers for guest_memfd-only memslots. The
patch is on Sean's radar to be merged once he finishes fixing a bug in a related
area [4].

I believe that it is possible to have memory unmapped from stage 2 (it involves
automatic NUMA balancing and userspace explicitly setting a mempolicy), but
haven't tested that; the patch codifies that guest_memfd memory should never be
unmapped without userspace requesting it (userspace can unmap the memory from
stage 2 by closing the guest_memfd file descriptor or punching a hole in the
descriptor).

* Patches to add dirty page logging support to guest_memfd-only memslots
(rebased on top of v7.3-rc1 + the SPE patches), as it's impossible today to
change the flags for a guest_memfd-backed memslot. These patches were sent to
the mailing list [5], and as far as I can tell the conclusion was that allowing
dirty page logging is a goal to be pursued for guest_memfd memslots. If we do
decide that dirty page logging for a VM with SPE is useful, I'm planning to
revisit dirty page logging for guest_memfd.

A branch with the prerequisites **after** the SPE series can be found at [6].
The prequisites come after the SPE patches so I can send this series with an
upstream base commit, which allows sashiko to review them.

kvmtool patches are at [7], and kvm-unit-tests are at [8].


How it works
============

1. Userspace sets the KVM_ARM_VCPU_SPE VCPU feature for all VCPUs, configures
the SPE interrupt number (required), assigns a SPE PMU instance to the VM
(required) and then calls KVM_ARM_VCPU_SPE_INIT to finalise configuration. All
of this is done via KVM_SET_DEVICE_ATTR on each VCPU.

Once the VCPU feature is set, KVM_ARM_VCPU_SPE_INIT must be executed before a
VCPU can be run.

2. Userspace uses guest_memfd-backed memslots to represent guest memory, and
pre-maps that memory at stage 2 using KVM_PRE_FAULT_MEMORY.

The order between steps 1 and 2 does not matter.

3. Userspace runs the VCPU(s).

For a VM with SPE, KVM will not check if memslots are backed by guest_memfd,
because KVM cannot know which memslots the guest will use as RAM and which have
a different use, even if they are not read-only. For example, pvtime.

To create a VM with SPE enabled with kvmtool:

# modprobe arm_spe_pmu # If not already loaded or built-in
$ lkvm run --kernel <image> --spe --guest-memfd --name spe-test --params "kpti=off <other_params>"

To test dirty page logging with kvmtool, use the debug interface:

# Create a VM with the name spe-test, as above, then:
$ lkvm debug --name spe-test --enable-dirty-track # to enable dirty page logging
or
$ lkvm debug --name spe-test --disable-dirty-track # to disable dirty page logging

To run the tests from kvm-unit-tests:

$ configure --arch=arm64 --cross-prefix=<cross_compile> --target=kvmtool
$ make clean && make
$ KVMTOOL=<path/to/kvmtool/binary> ./run_tests.sh -g spe


Migration
=========

This is tricky (read: hacky). Relying on KVM fixing up stage 2 faults triggered
SPE attempting to write to memory that is read-only doesn't really work, because
a partial record might be written to the buffer (PMBSR_EL1.DL set). To recover
from this, KVM, or better yet, the VMM, would need to learn to parse the buffer
and rewind PMBPTR_EL1 to the first by after the last complete record.

So what I did instead was to introduce a new hardware exit reason, and have
VCPUs which have the buffer enabled exit to userspace when dirty page logging is
enabled. A VCPU also exits to userspace if the buffer was disabled when dirty
page logging was enabled, and the buffer later becomes enabled, before dirty page
logging is disabled.

When dirty page logging is disabled, the stage 2 permissions are relaxed to
allow writes. The gory details are in patch #27 ("KVM: arm64: Handle dirty page
logging when SPE feature is set").

[1] https://lore.kernel.org/kvmarm/20251114160717.163230-1-alexandru.elisei@arm.com/
[2] https://lore.kernel.org/kvmarm/20260612162354.73378-3-jackabt.amazon@gmail.com/
[3] https://lore.kernel.org/kvmarm/20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org/
[4] https://lore.kernel.org/kvmarm/amPCdAswlk24Xilf@google.com/
[5] https://lore.kernel.org/kvmarm/20260702142912.6395-1-alexandru.elisei@arm.com/
[6] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/kvm-spe-v7
[7] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/kvm-spe-v7
[8] https://gitlab.arm.com/linux-arm/kvm-unit-tests-ae/-/tree/kvm-spe-v7

Alexandru Elisei (26):
  arm64/sysreg: Add the nVM field to PMBLIMITR_EL1
  arm64/sysreg: Define MDCR_EL2.E2PB values
  KVM: arm64: Add CONFIG_KVM_ARM_SPE Kconfig option
  perf: arm_spe_pmu: Move struct arm_spe_pmu to a separate header file
  perf: arm_spe_pmu: Add PMBIDR_EL1 and PMSIDR_EL1 to struct arm_spe_pmu
  KVM: arm64: Add KVM_CAP_ARM_SPE capability
  KVM: arm64: Add KVM_ARM_VCPU_SPE VCPU feature
  HACK! KVM: arm64: Disable SPE virtualization if protected KVM is
    enabled
  HACK! KVM: arm64: Enable SPE virtualization only in VHE mode
  HACK! KVM: arm64: Disable SPE virtualization if nested virt is enabled
  KVM: arm64: Add SPE VCPU device attribute to set the SPE device
  KVM: arm64: Add SPE VCPU device attribute to initialize SPE
  KVM: arm64: Use PMSVer from the assigned SPE instance
  KVM: arm64: Add SPE system registers to VCPU context
  KVM: arm64: Apply a RES0 mask to PMBLIMITR_EL1 writes
  KVM: arm64: config: Use functions from spe.c to test
    FEAT_SPE_{FnE,FDS}
  KVM: arm64: VHE: Context switch SPE state
  KVM: arm64: Allow guest SPE physical timestamps only if kernel allows
    it
  KVM: arm64: Handle SPE maintenance interrupts
  arm64: errata: Disable SPE in KVM
  KVM: arm64: Add kvm-arm.ignore_spe_errata kernel parameter
  arm64: errata: Don't enable guest buffer if misprogrammed
  KVM: arm64: at: Use callback for reading descriptor
  KVM: arm64: Map memory on a SPE stage 2 fault
  KVM: arm64: Handle dirty page logging when SPE feature is set
  KVM: arm64: Allow the creation of a SPE enabled VM

Sudeep Holla (2):
  KVM: arm64: Add a new VCPU device control group for SPE
  KVM: arm64: Add SPE VCPU device attribute to set the interrupt number

 .../admin-guide/kernel-parameters.txt         |   3 +
 Documentation/arch/arm64/silicon-errata.rst   |  37 +
 Documentation/virt/kvm/api.rst                |  19 +-
 Documentation/virt/kvm/devices/vcpu.rst       |  84 +++
 arch/arm64/Kconfig                            |  55 ++
 arch/arm64/include/asm/kvm_asm.h              |   1 +
 arch/arm64/include/asm/kvm_host.h             |  48 +-
 arch/arm64/include/asm/kvm_hyp.h              |  26 +-
 arch/arm64/include/asm/kvm_mmu.h              |   1 +
 arch/arm64/include/asm/kvm_nested.h           |   7 +
 arch/arm64/include/asm/kvm_pgtable.h          |  19 +
 arch/arm64/include/asm/kvm_pkvm.h             |   1 +
 arch/arm64/include/asm/kvm_spe.h              | 150 ++++
 arch/arm64/include/uapi/asm/kvm.h             |   6 +
 arch/arm64/kernel/cpu_errata.c                |  51 ++
 arch/arm64/kvm/Kconfig                        |  10 +
 arch/arm64/kvm/Makefile                       |   1 +
 arch/arm64/kvm/arm.c                          |  98 ++-
 arch/arm64/kvm/at.c                           |  22 +-
 arch/arm64/kvm/config.c                       |  30 +-
 arch/arm64/kvm/guest.c                        |  12 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  34 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |   7 +-
 arch/arm64/kvm/hyp/pgtable.c                  |   8 +
 arch/arm64/kvm/hyp/vhe/Makefile               |   1 +
 arch/arm64/kvm/hyp/vhe/debug-sr.c             |  18 +
 arch/arm64/kvm/hyp/vhe/spe-sr.c               | 212 ++++++
 arch/arm64/kvm/hyp/vhe/switch.c               |   9 +
 arch/arm64/kvm/mmu.c                          |  72 ++
 arch/arm64/kvm/nested.c                       |   7 +-
 arch/arm64/kvm/pkvm.c                         |  27 +
 arch/arm64/kvm/pmu-emul.c                     |  11 +-
 arch/arm64/kvm/spe.c                          | 647 ++++++++++++++++++
 arch/arm64/kvm/sys_regs.c                     | 103 ++-
 arch/arm64/tools/cpucaps                      |   2 +
 arch/arm64/tools/sysreg                       |  11 +-
 drivers/perf/arm_spe_pmu.c                    |  46 +-
 include/linux/perf/arm_spe_pmu.h              |  66 ++
 include/uapi/linux/kvm.h                      |   1 +
 40 files changed, 1849 insertions(+), 116 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_spe.h
 create mode 100644 arch/arm64/kvm/hyp/vhe/spe-sr.c
 create mode 100644 arch/arm64/kvm/spe.c
 create mode 100644 include/linux/perf/arm_spe_pmu.h


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.43.0

