Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93B6417ACF
	for <kvmarm@lists.linux.dev>; Tue,  9 May 2023 14:23:21 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4BF40FEC;
	Tue,  9 May 2023 07:23:59 -0700 (PDT)
Received: from e126864.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 66C113F663;
	Tue,  9 May 2023 07:23:12 -0700 (PDT)
From: Kristina Martsenko <kristina.martsenko@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Luis Machado <luis.machado@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/11] arm64: Support for Armv8.8 memcpy instructions in userspace
Date: Tue,  9 May 2023 15:22:24 +0100
Message-Id: <20230509142235.3284028-1-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Armv8.8 extension adds new instructions to perform memcpy(), memset() and
memmove() operations in hardware (FEAT_MOPS). This series adds support for
using the new instructions in userspace. More information can be found in the
cover letter for v1:
  https://lore.kernel.org/linux-arm-kernel/20230216160012.272345-1-kristina.martsenko@arm.com/

Changes in v2:
 - Removed booting.rst requirement for HCRX_EL2.MCE2
 - Changed HCRX_EL2 cpucap to be STRICT_BOOT type
 - Changed HCRX_EL2.SMPME to be set for the guest and unset for the host
 - Moved HCRX_EL2 initialization into init_el2_state(), dropped ISB
 - Simplified conditional checks in mops exception handler with XOR
 - Added comments from Arm ARM into mops exception handler
 - Converted cpucaps to use the new ARM64_CPUID_FIELDS() helper
 - Added MOPS to hwcaps kselftest
 - Improved commit messages
 - Rebased onto v6.4-rc1
 - v1: https://lore.kernel.org/linux-arm-kernel/20230216160012.272345-1-kristina.martsenko@arm.com/


Kristina Martsenko (11):
  KVM: arm64: initialize HCRX_EL2
  arm64: cpufeature: detect FEAT_HCX
  KVM: arm64: switch HCRX_EL2 between host and guest
  arm64: mops: document boot requirements for MOPS
  arm64: mops: don't disable host MOPS instructions from EL2
  KVM: arm64: hide MOPS from guests
  arm64: mops: handle MOPS exceptions
  arm64: mops: handle single stepping after MOPS exception
  arm64: mops: detect and enable FEAT_MOPS
  arm64: mops: allow disabling MOPS from the kernel command line
  kselftest/arm64: add MOPS to hwcap test

 .../admin-guide/kernel-parameters.txt         |  3 +
 Documentation/arm64/booting.rst               |  6 ++
 Documentation/arm64/cpu-feature-registers.rst |  2 +
 Documentation/arm64/elf_hwcaps.rst            |  3 +
 arch/arm64/include/asm/el2_setup.h            | 18 +++---
 arch/arm64/include/asm/esr.h                  | 11 +++-
 arch/arm64/include/asm/exception.h            |  1 +
 arch/arm64/include/asm/hwcap.h                |  1 +
 arch/arm64/include/asm/kvm_arm.h              |  4 ++
 arch/arm64/include/uapi/asm/hwcap.h           |  1 +
 arch/arm64/kernel/cpufeature.c                | 23 ++++++++
 arch/arm64/kernel/cpuinfo.c                   |  1 +
 arch/arm64/kernel/entry-common.c              | 11 ++++
 arch/arm64/kernel/idreg-override.c            |  2 +
 arch/arm64/kernel/traps.c                     | 58 +++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  6 ++
 arch/arm64/kvm/sys_regs.c                     |  1 +
 arch/arm64/tools/cpucaps                      |  2 +
 tools/testing/selftests/arm64/abi/hwcap.c     | 22 +++++++
 19 files changed, 167 insertions(+), 9 deletions(-)


base-commit: ac9a78681b921877518763ba0e89202254349d1b
-- 
2.25.1

