Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206A43714E
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 23:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fet2PFSw"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5a7aa816c5bso12505767b3.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Oct 2023 16:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696892943; x=1697497743; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZLpiPFI3YPzDm01qV1AAC709jBrt9uw5FfnkB7hlp+4=;
        b=fet2PFSwigkFyINuV6rreu/gy1yPmLToUXs+bkRXGPDjfCAwoXQzH3c56rLQCsmx+y
         9R+Uk6prmtDWfMr7JlKBJ071zJvoTkq+kMR5c8uJLyXUSCrvrC5FDlx6k3GtbeqkBkhC
         n/7Hpv9mIOJywwFLYdlu2TMx/7q+ocWYvKs5Lq+V109XtXEXzpr9heGxkKV+YFIC+K8+
         ZJ2jogc7ciVx4gUFJGSTCBYD6fIU5Wbb6OBgLPsF0W6lguCyOY8JsBP+dXI5s25xotSq
         UWrBwrRqCBYR1ChhBZgpETynIW3vR2IW6HN/R7MKVP50nV0GNVpcDzVXXqVGcrNN6EYs
         TfAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892943; x=1697497743;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZLpiPFI3YPzDm01qV1AAC709jBrt9uw5FfnkB7hlp+4=;
        b=GmQFYDdmbV4tG8g+sUw1nMV3/2hRo8A0aq1LlGx0AnQuyp1EqJHGRbSt0r3+FJS+6S
         oLranrUO1ggTpqpH7qNqC3g9eVUW2voU9try8lJcvgAIl2MAhE1VqNnzBZ/4fAeLYGIV
         f46tCejc9UVobGDgbxkjOauQTIGSMPibxidOz6g4XIvfdY+dLmIxpkghQiLYk4xCa/UU
         /C3TPMpwiyLExYxHp8eSoK8bjoqwNdCwoFphhjAFlS+Yd0r2pgBCxDQbYwOe1Ld5YCit
         vRjrC4s8QS/zXsJaxQZEIgIC/v/x37FS647LUcIecHtel4yB0SITqHBrv+rSb2TbTF/a
         /9Cg==
X-Gm-Message-State: AOJu0YyNiyBh9uBUAPLfE8nCZUX4PXuGcdSXu+dq2JUSL4zI5cS8MCoL
	QJPewbuKghZXPfhyAUgSQloHLJyqEJy3
X-Google-Smtp-Source: AGHT+IGcBlZxnuX0UFRCSGIDvWQIDNvnaDi8u4W2kj0D6Iqw6z2sjziA898oZvUbAr3eVXKmr1rqX7Svl2bI
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:d4d2:0:b0:d9a:38e4:78b5 with SMTP id
 m201-20020a25d4d2000000b00d9a38e478b5mr40510ybf.5.1696892943019; Mon, 09 Oct
 2023 16:09:03 -0700 (PDT)
Date: Mon,  9 Oct 2023 23:08:46 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <20231009230858.3444834-1-rananta@google.com>
Subject: [PATCH v7 00/12] KVM: arm64: PMU: Allow userspace to limit the number
 of PMCs on vCPU
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

With permission from Reiji Watanabe <reijiw@google.com>, the original
author of the series, I'm posting the v6 with necessary alterations.

The goal of this series is to allow userspace to limit the number
of PMU event counters on the vCPU.  We need this to support migration
across systems that implement different numbers of counters.

The number of PMU event counters is indicated in PMCR_EL0.N.
For a vCPU with PMUv3 configured, its value will be the same as
the current PE by default.  Userspace can set PMCR_EL0.N for the
vCPU to any value even with the current KVM using KVM_SET_ONE_REG.
However, it is practically unsupported, as KVM resets PMCR_EL0.N
to the host value on vCPU reset and some KVM code uses the host
value to identify (un)implemented event counters on the vCPU.

This series will ensure that the PMCR_EL0.N value is preserved
on vCPU reset and that KVM doesn't use the host value
to identify (un)implemented event counters on the vCPU.
This allows userspace to limit the number of the PMU event
counters on the vCPU.

The series is based on kvmarm/next @7e6587baafc0 to include the
vCPU reset and feature flags cleanup/fixes series [1].

Patch 1 adds helper functions to set a PMU for the guest. This
helper will make it easier for the following patches to add
modify codes for that process.

Patch 2 makes the default PMU for the guest set before the first
vCPU reset.

Patch 3 fixes reset_pmu_reg() to ensure that (RAZ) bits of
PMCNTEN{SET,CLR}_EL0, PMINTEN{SET,CLR}_EL1, and
PMOVS{SET,CLR}_EL1 corresponding to unimplemented event
counters on the vCPU are reset to zero.

Patch 4 is a minor refactoring to use the default PMU register reset
function for PMUSERENR_EL0 and PMCCFILTR_EL0.

Patch 5,6 adds a helper to read vCPU's PMCR_EL0 and the number of
counters, respectively.

Patch 7 changes the code to use the guest's PMCR_EL0.N, instead
of the PE's PMCR_EL0.N.

Patch 8 adds support userspace modifying PMCR_EL0.N.

Patch 9-12 adds a selftest to verify reading and writing PMU registers
for implemented or unimplemented PMU event counters on the vCPU.

v7: Thanks, Oliver for the suggestions
- Rebase the series onto kvmarm/next.
- Move the logic to set the default PMU for the guest from
  kvm_reset_vcpu() to __kvm_vcpu_set_target() to deal with the
  error returned.
- Add a helper, kvm_arm_get_num_counters(), to read the number
  of general-purpose counters.
- Use this helper to fix the error reported by kernel test robot [2].

v6: Thanks, Oliver and Shaoqin for the suggestions
- Split the previously defined kvm_arm_set_vm_pmu() into separate
  functions: default arm_pmu and a caller requested arm_pmu.
- Send -EINVAL from kvm_reset_vcpu(), instead of -ENODEV for the
  case where KVM fails to set a default arm_pmu, to remain consistent
  with the existing behavior.
- Drop the v5 patch-5/12 that removes ARMV8_PMU_PMCR_N_MASK and adds
  ARMV8_PMU_PMCR_N. Make corresponding changes to v5 patch-6/12.
- Disregard introducing 'pmcr_n_limit' in kvm->arch as a member to
  be accessed later in 'set_pmcr()'. Instead, directly obtain the
  value by accessing the saved 'arm_pmu'.
- 'set_pmcr()' ignores the error when userspace tries to set PMCR.N
  greater than the hardware limit to keep the existing API behavior.
- 'set_pmcr()' ignores modifications to the register after the VM has
  started and returns a success to userspace.
- Introduce [get|set]_pmcr_n() helpers in the selftest to make
  modifications to the field easier.
- Define the 'vpmu_vm' globally in the selftest, instead of allocating
  it every time a VM is created.
- Use the new printf style __GUEST_ASSERT()s in the selftest. 

v5:
https://lore.kernel.org/all/20230817003029.3073210-1-rananta@google.com/
 - Drop the patches (v4 3,4) related to PMU version fixes as it's
   now being handled in a separate series [3].
 - Switch to config_lock, instead of kvm->lock, while configuring
   the guest PMU.
 - Instead of continuing after a WARN_ON() for the return value of
   kvm_arm_set_vm_pmu() in kvm_arm_pmu_v3_set_pmu(), patch-1 now
   returns from the function immediately with the error code.
 - Fix WARN_ON() logic in kvm_host_pmu_init() (patch v4 9/14).
 - Instead of returning 0, return -ENODEV from the
   kvm_arm_set_vm_pmu() stub function.
 - Do not define the PMEVN_CASE() and PMEVN_SWITCH() macros in
   the selftest code as they are now included in the imported
   arm_pmuv3.h header.
 - Since the (initial) purpose of the selftest is to test the
   accessibility of the counter registers, remove the functional
   test at the end of test_access_pmc_regs(). It'll be added
   later in a separate series.
 - Introduce additional helper functions (destroy_vpmu_vm(),
   PMC_ACC_TO_IDX()) in the selftest for ease of maintenance
   and debugging.
   
v4:
https://lore.kernel.org/all/20230211031506.4159098-1-reijiw@google.com/
 - Fix the selftest bug in patch 13 (Have test_access_pmc_regs() to
   specify pmc index for test_bitmap_pmu_regs() instead of bit-shifted
   value (Thank you Raghavendra for the reporting the issue!).

v3:
https://lore.kernel.org/all/20230203040242.1792453-1-reijiw@google.com/
 - Remove reset_pmu_reg(), and use reset_val() instead. [Marc]
 - Fixed the initial value of PMCR_EL0.N on heterogeneous
   PMU systems. [Oliver]
 - Fixed PMUVer issues on heterogeneous PMU systems.
 - Fixed typos [Shaoqin]

v2:
https://lore.kernel.org/all/20230117013542.371944-1-reijiw@google.com/
 - Added the sys_reg's set_user() handler for the PMCR_EL0 to
   disallow userspace to set PMCR_EL0.N for the vCPU to a value
   that is greater than the host value (and added a new test
   case for this behavior). [Oliver]
 - Added to the commit log of the patch 2 that PMUSERENR_EL0 and
   PMCCFILTR_EL0 have UNKNOWN reset values.

v1:
https://lore.kernel.org/all/20221230035928.3423990-1-reijiw@google.com/

Thank you.
Raghavendra

[1]:
https://lore.kernel.org/all/20230920195036.1169791-1-oliver.upton@linux.dev/
[2]: https://lore.kernel.org/all/202309290607.Qgg05wKw-lkp@intel.com/
[3]:
https://lore.kernel.org/all/20230728181907.1759513-1-reijiw@google.com/

Raghavendra Rao Ananta (2):
  KVM: arm64: PMU: Add a helper to read the number of counters
  tools: Import arm_pmuv3.h

Reiji Watanabe (10):
  KVM: arm64: PMU: Introduce helpers to set the guest's PMU
  KVM: arm64: PMU: Set the default PMU for the guest before vCPU reset
  KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and PMOVS{SET,CLR} on vCPU
    reset
  KVM: arm64: PMU: Don't define the sysreg reset() for
    PM{USERENR,CCFILTR}_EL0
  KVM: arm64: PMU: Add a helper to read a vCPU's PMCR_EL0
  KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based on the associated PMU
  KVM: arm64: PMU: Allow userspace to limit PMCR_EL0.N for the guest
  KVM: selftests: aarch64: Introduce vpmu_counter_access test
  KVM: selftests: aarch64: vPMU register test for implemented counters
  KVM: selftests: aarch64: vPMU register test for unimplemented counters

 arch/arm64/include/asm/kvm_host.h             |   3 +
 arch/arm64/kvm/arm.c                          |  23 +-
 arch/arm64/kvm/pmu-emul.c                     | 102 ++-
 arch/arm64/kvm/sys_regs.c                     | 101 ++-
 include/kvm/arm_pmu.h                         |  18 +
 tools/include/perf/arm_pmuv3.h                | 308 +++++++++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/vpmu_counter_access.c         | 590 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |   1 +
 9 files changed, 1087 insertions(+), 60 deletions(-)
 create mode 100644 tools/include/perf/arm_pmuv3.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c


base-commit: 7e6587baafc0054bd32d9ca5f72af36e36ff1d05
-- 
2.42.0.609.gbb76f46606-goog

