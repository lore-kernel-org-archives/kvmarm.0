Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C186AC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:56:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A4304B1D5;
	Tue, 19 Apr 2022 02:56:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GJpTTXhkd9tb; Tue, 19 Apr 2022 02:56:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D4974B1C9;
	Tue, 19 Apr 2022 02:56:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA86C4B1BF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:56:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AMU73KPnJC1K for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:56:26 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0582649F16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:56:25 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 f8-20020a170902ce8800b00158ed29a480so4008517plg.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=wkoi9u8g4m1LxGfuhktGijm/rROXwKkJ/l94ID6QQ0s=;
 b=s5lPS4uGURpGMzkZjvULErheVdF6WRLH3u15uTV1zSgxUqo1/1jhAUlvw7m/7U8mF7
 A+jSrVP1T64l7EdaLGspJd3j3SBGRezaewGH09vzwBij/U9EX6cae1b4ph6NEnYdE8y1
 jmtsksT+ha4slg3ztfTSsuwgilS1JdeZMCrTGz7B95rtuVDcHGCFE79V/04+aeCclkTp
 acfMZxeb4D3kmZUQ/B1ff374PlhwWcvK7Sn6QYA+kL84NgAbCTr5wbGYyW4LkB3IHgXq
 otPyLvUeOqxdTN4NCItY1QPqTwT6/lguQdRrgOZd7oyAdaw3ZCfXZ6o6hA5LaTD/DkKy
 4J5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=wkoi9u8g4m1LxGfuhktGijm/rROXwKkJ/l94ID6QQ0s=;
 b=qKhJUKhto6iFzZzWh9g9Wj4EJ8bZCR8vDMXSyJ+Btv8IgOhmwNfJofUNFqfDJyYWIS
 RX7b1jkmz4IgZP9qnnVGDbKQWl/3oOvmvn9GMNVRPXqpL0RbXSc8Wmx6mB+TKR25YORc
 uKk8NATNToanCsUmz82+u+3jvlrSHp3hSSWaqMxKf5EVHCi70hmbEoutdNMuqMCIgDTN
 kK0xWLNKUWuvHox6Us69zCI258Q8PNswAfOsl80WRhimMF8nXjvXUX1CBXE3WxN0awXV
 zdZDeV5HlBUky1sIKWcEQd+xbimR8OjDc/dy1xl7o2/iGSdTNxLiHYOE0eLaQOKym/7D
 7sXA==
X-Gm-Message-State: AOAM531D8TRDGmE75SHkMgCu/6hXkjDO3G+eb6O3N5bxRiz4KJcOcB2X
 Qd94S6+8URQj59B6vkHEL2k1IS6E4gg=
X-Google-Smtp-Source: ABdhPJx5tMN5gXimylf+ohnUNdKzgoURE02AbOl6iJrP1lekuCon1l1alB3iCyoDzPKPlKpfWADnEwunZhE=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:203:b0:1cb:bfe7:106 with SMTP id
 fy3-20020a17090b020300b001cbbfe70106mr22389528pjb.78.1650351384779; Mon, 18
 Apr 2022 23:56:24 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:06 -0700
Message-Id: <20220419065544.3616948-1-reijiw@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 00/38] KVM: arm64: Make CPU ID registers writable by
 userspace
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

In KVM/arm64, values of ID registers for a guest are mostly same as
its host's values except for bits for feature that KVM doesn't support
and for opt-in features that userspace didn't configure.  Userspace
can use KVM_SET_ONE_REG to a set ID register value, but it fails
if userspace attempts to modify the register value.

This patch series adds support to allow userspace to modify a value of
ID registers (as long as KVM can support features that are indicated
in the registers) so userspace can have more control of configuring
and unconfiguring features for guests.  We need this because we would
like to expose a uniform set/level of features for a group of guests on
systems with different ARM CPUs.  Since some features are not binary
in nature (e.g. AA64DFR0_EL1.BRPs fields indicate number of
breakpoints minus 1), using KVM_ARM_VCPU_INIT to control such features
is inconvenient.  This will be supported only for AArch64 EL1 guests at
least for now.

The patch series is for both VHE and non-VHE, except for protected VMs,
which have a different way of configuring ID registers based on its
different requirements [1].
There was a patch series that tried to achieve the same thing [2].
A few snippets of codes in this series were inspired by or came from [2].

The initial value of ID registers for a vCPU will be the host's value
with bits cleared for unsupported features and for opt-in features that
were not configured. So, the initial value userspace can see (via
KVM_GET_ONE_REG) is the upper limit that can be set for the register.
Any requests to change the value that conflicts with opt-in features'
configuration will fail (e.g. if KVM_ARM_VCPU_PMU_V3 is configured by
KVM_ARM_VCPU_INIT, ID_AA64DFR0_EL1.PMUVER cannot be set to zero.
Otherwise, the initial value of ID_AA64DFR0_EL1.PMUVER will be zero,
and cannot be changed from zero).

When a guest tries to use a CPU feature that is not exposed to the guest,
trapping it (to emulate a real CPU's behavior) would generally be a
desirable behavior (when it is possible with no or little side effects).
The later patches in the series add codes for this.  Only features that
can be trapped independently will be trapped by this series though.

Highest numbered breakpoints must be context aware breakpoints
(as specified by Arm ARM).  If the number of non-context aware
breakpoints for the guest is decreased by userspace (e.g. Lower
ID_AA64DFR0.BRPs keeping ID_AA64DFR0.CTX_CMPs the same), simply
narrowing the breakpoints will be problematic because it will
lead to narrowing context aware breakpoints for the guest. In this
case, KVM will always trap and emulate breakpoints/watchpoints
accesses in that case.

This series adds kunit tests for new functions in sys_regs.c (except for
trivial ones), and these tests are enabled with a new configuration
option 'CONFIG_KVM_KUNIT_TEST'.

The series is based on 5.18-rc3.

Patch 01 introduces arm64_check_features(), which will validate
ID registers based on given arm64_ftr_bits[].

Patch 02 introduces id_regs[] to kvm_arch to save values of ID
registers.

Patches 03-04 introduces structure id_reg_desc to manage the ID register
specific control for the guest.

Patch 05 prohibits modifying values of ID regs for 32bit EL1 guests.

Patches 06-11 introduces id_reg_desc for ID_AA64PFR0_EL1, ID_AA64PFR1_EL1,
ID_AA64ISAR0_EL1, ID_AA64ISAR1_EL1, ID_AA64ISAR2_EL1 and ID_AA64MMFR0_EL1
to make them configurable.

Patches 12-14 take cares emulation of dbgbcr/dbgbvr/dbgwcr when the number
of non-context aware breakpoints are reduced for the guest.

Patches 15-19 introduces id_reg_desc for remaining ID registers to
make them configurable.

Patch 20 switches to use id_reg_desc_table[] for ID registers instead
of sys_reg_descs[].

Patch 21 introduces consistency checking of feature fractional
fields of ID registers at the first KVM_RUN.

Patch 22 introduces a new capability KVM_CAP_ARM_ID_REG_WRITABLE
to identify that ID registers are configurable by userspace.

Patch 23 introduces kunit test cases for sys_reg.c changes.

Patches 24-25 change the way of using vcpu->arch.cptr_el2/mdcr_el2 to
track certain bits of cptr_el2/mdcr_el2 in the vcpu->arch fields and use
them when setting them for the guest.  The following patches will update
the vcpu->arch fields based on available features for the guest.

Patch 26 introduces struct feature_config_ctrl and some helper
functions to enable trapping of features that are disabled for a guest.

Patches 27-31 add feature_config_ctrl for CPU features, which are
used to program configuration registers to trap each of the features.

Patch 32 adds kunit test cases for changes in patches 26-31.

Patch 33 adds a couple of helpers for selftests to extract a field of
ID registers.

Patch 34 adds a selftest to validate reading/writing ID registers.

Patches 35-38 add test cases for dbgbcr/dbgbvr/dbgwcr emulation
to the debug-exceptions test.

v7:
  - Add emulation of dbgbcr/dbgbvr/dbgwcr when the number of non-context
    aware breakpoints are reduced for the guest.
  - Add an array of arm64_ftr_bits to id_reg_desc so that KVM could
    have its own validation policy of ID registers.
  - Don't support configurable ID registers for 32bit EL1 guest.
  - Change the ID register validation function in cpufeature.c to
    accept arm64_ftr_bits as an argument.
  - Don't allocate buffers in kvm_arch for ID registers with CRm==0.
    [Oliver]
  - Change set_default_id_regs() not to walk the entire sys_reg_descs[]
    in the patch-2. [Oliver]
  - Add id_reg_desc for ID_AA64ISAR0_EL1

v6: https://lore.kernel.org/all/20220311044811.1980336-1-reijiw@google.com/
  - Remove entries for all ID register entries from sys_reg_descs[],
    and use id_reg_desc_table[] for ID registers instead. [Oliver]
  - Remove sys_reg field from id_reg_info, add reg_desc (sys_reg_desc)
    field to id_reg_info, and rename 'id_reg_info' to 'id_reg_desc'.
  - Merge the following three patches of v5 into one patch "KVM: arm64:
    Make ID_AA64DFR0_EL1/ID_DFR0_EL1 writable" to accept userspace's
    request to set ID_AA64DFR0_EL1.PMUVER/ID_DFR0_EL1.PERFMON to 0xf
    (they are set to 0 though) even after applying the patch-10. [Oliver]
     patch-10 KVM: arm64: Hide IMPLEMENTATION DEFINED PMU support for the guest
     patch-11 KVM: arm64: Make ID_AA64DFR0_EL1 writable"
     patch-12 KVM: arm64: Make ID_DFR0_EL1 writable"

v5: https://lore.kernel.org/all/20220214065746.1230608-1-reijiw@google.com/
  - Change the return value of kcalloc failure of init_arm64_ftr_bits_kvm
    to -ENOMEM from ENOMEM. [Fuad]
  - Call init_arm64_ftr_bits_kvm from init_cpu_features(). [Ricardo, Fuad]
  - Move is_id_reg() in arch/arm64/kvm/sys_regs.c. [Fuad]
  - Remove frac_ftr_check from feature_frac [Fuad]
  - Rename kvm_id_regs_consistency_check() [Fuad]
  - Add feature_config_ctrl for ID_AA64DFR0_TRACEVER [Fuad]
  - Move changes for kvm_set_id_reg_feature and __modify_kvm_id_reg from
    patch-4 to patch-3. [Fuad]
  - Comment additions and fixes [Fuad]
  - Rename arm64_check_features() [Ricardo]
  - Run arm64_check_features_kvm() for the default guest value [Ricardo]
  - Add ID_AA64MMFR1_EL1.HAFDBS validation
  - Cosmetic fixes

v4: https://lore.kernel.org/all/20220106042708.2869332-1-reijiw@google.com/
  - Make ID registers storage per VM instead of per vCPU. [Marc]
  - Implement arm64_check_features() in arch/arm64/kernel/cpufeature.c
    by using existing codes in the file. [Marc]
  - Use a configuration function to enable traps for disabled
    features. [Marc]
  - Document ID registers become immutable after the first KVM_RUN [Eric]
  - Update ID_AA64PFR0.GIC at the point where a GICv3 is created. [Marc]
  - Get TGranX's bit position by substracting 12 from TGranX_2's bit
    position. [Eric]
  - Don't validate AArch32 ID registers when the system doesn't support
    32bit EL0. [Eric]
  - Add/fixes comments for patches. [Eric]
  - Made bug fixes/improvements of the selftest. [Eric]
  - Added .kunitconfig for arm64 KUnit tests

v3: https://lore.kernel.org/all/20211117064359.2362060-1-reijiw@google.com/
  - Remove ID register consistency checking across vCPUs. [Oliver]
  - Change KVM_CAP_ARM_ID_REG_WRITABLE to
    KVM_CAP_ARM_ID_REG_CONFIGURABLE. [Oliver]
  - Add KUnit testing for ID register validation and trap initialization.
  - Change read_id_reg() to take care of ID_AA64PFR0_EL1.GIC.
  - Add a helper of read_id_reg() (__read_id_reg()) and use the helper
    instead of directly using __vcpu_sys_reg().
  - Change not to run kvm_id_regs_consistency_check() and
    kvm_vcpu_init_traps() for protected VMs.
  - Update selftest to remove test cases for ID register consistency.
    checking across vCPUs and to add test cases for ID_AA64PFR0_EL1.GIC.

v2: https://lore.kernel.org/all/20211103062520.1445832-1-reijiw@google.com/
  - Remove unnecessary line breaks. [Andrew]
  - Use @params for comments. [Andrew]
  - Move arm64_check_features to arch/arm64/kvm/sys_regs.c and
    change that KVM specific feature check function.  [Andrew]
  - Remove unnecessary raz handling from __set_id_reg. [Andrew]
  - Remove sys_val field from the initial id_reg_info and add it
    in the later patch. [Andrew]
  - Call id_reg->init() from id_reg_info_init(). [Andrew]
  - Fix cpuid_feature_cap_perfmon_field() to convert 0xf to 0x0
    (and use it in the following patches).
  - Change kvm_vcpu_first_run_init to set has_run_once to false
    when kvm_id_regs_consistency_check() fails.
  - Add a patch to introduce id_reg_info for ID_AA64MMFR0_EL1,
    which requires special validity checking for TGran*_2 fields.
  - Add patches to introduce id_reg_info for ID_DFR1_EL1 and
    ID_MMFR0_EL1, which are required due to arm64_check_features
    implementation change.
  - Add a new argument, which is a pointer to id_reg_info, for
    id_reg_info's validate().

v1: https://lore.kernel.org/all/20211012043535.500493-1-reijiw@google.com/

[1] https://lore.kernel.org/all/20211010145636.1950948-1-tabba@google.com/
[2] https://lore.kernel.org/all/20201102033422.657391-1-liangpeng10@huawei.com/
[3] https://lore.kernel.org/all/20220127161759.53553-2-alexandru.elisei@arm.com/

Reiji Watanabe (38):
  KVM: arm64: Introduce a validation function for an ID register
  KVM: arm64: Save ID registers' sanitized value per guest
  KVM: arm64: Introduce struct id_reg_desc
  KVM: arm64: Generate id_reg_desc's ftr_bits at KVM init when needed
  KVM: arm64: Prohibit modifying values of ID regs for 32bit EL1 guests
  KVM: arm64: Make ID_AA64PFR0_EL1 writable
  KVM: arm64: Make ID_AA64PFR1_EL1 writable
  KVM: arm64: Make ID_AA64ISAR0_EL1 writable
  KVM: arm64: Make ID_AA64ISAR1_EL1 writable
  KVM: arm64: Make ID_AA64ISAR2_EL1 writable
  KVM: arm64: Make ID_AA64MMFR0_EL1 writable
  KVM: arm64: Add a KVM flag indicating emulating debug regs access is
    needed
  KVM: arm64: Emulate dbgbcr/dbgbvr accesses
  KVM: arm64: Emulate dbgwcr accesses
  KVM: arm64: Make ID_AA64DFR0_EL1/ID_DFR0_EL1 writable
  KVM: arm64: KVM: arm64: Make ID_DFR1_EL1 writable
  KVM: arm64: KVM: arm64: Make ID_MMFR0_EL1 writable
  KVM: arm64: Make MVFR1_EL1 writable
  KVM: arm64: Add remaining ID registers to id_reg_desc_table
  KVM: arm64: Use id_reg_desc_table for ID registers
  KVM: arm64: Add consistency checking for frac fields of ID registers
  KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_CONFIGURABLE capability
  KVM: arm64: Add kunit test for ID register validation
  KVM: arm64: Use vcpu->arch cptr_el2 to track value of cptr_el2 for VHE
  KVM: arm64: Use vcpu->arch.mdcr_el2 to track value of mdcr_el2
  KVM: arm64: Introduce framework to trap disabled features
  KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
  KVM: arm64: Trap disabled features of ID_AA64PFR1_EL1
  KVM: arm64: Trap disabled features of ID_AA64DFR0_EL1
  KVM: arm64: Trap disabled features of ID_AA64MMFR1_EL1
  KVM: arm64: Trap disabled features of ID_AA64ISAR1_EL1
  KVM: arm64: Add kunit test for trap initialization
  KVM: arm64: selftests: Add helpers to extract a field of ID registers
  KVM: arm64: selftests: Introduce id_reg_test
  KVM: arm64: selftests: Test linked breakpoint and watchpoint
  KVM: arm64: selftests: Test breakpoint/watchpoint register access
  KVM: arm64: selftests: Test with every breakpoint/watchpoint
  KVM: arm64: selftests: Test breakpoint/watchpoint changing
    ID_AA64DFR0_EL1

 Documentation/virt/kvm/api.rst                |   16 +
 arch/arm64/include/asm/cpufeature.h           |    3 +-
 arch/arm64/include/asm/kvm_arm.h              |   32 +
 arch/arm64/include/asm/kvm_host.h             |   17 +
 arch/arm64/include/asm/sysreg.h               |   14 +-
 arch/arm64/kernel/cpufeature.c                |   52 +
 arch/arm64/kvm/.kunitconfig                   |    4 +
 arch/arm64/kvm/Kconfig                        |   11 +
 arch/arm64/kvm/arm.c                          |   24 +-
 arch/arm64/kvm/debug.c                        |   20 +-
 arch/arm64/kvm/hyp/vhe/switch.c               |   14 +-
 arch/arm64/kvm/sys_regs.c                     | 2363 +++++++++++++++--
 arch/arm64/kvm/sys_regs_test.c                | 1287 +++++++++
 arch/arm64/kvm/vgic/vgic-init.c               |    9 +
 include/uapi/linux/kvm.h                      |    1 +
 tools/arch/arm64/include/asm/sysreg.h         |    1 +
 tools/testing/selftests/kvm/Makefile          |    1 +
 .../selftests/kvm/aarch64/debug-exceptions.c  |  649 ++++-
 .../selftests/kvm/aarch64/id_reg_test.c       | 1297 +++++++++
 .../selftests/kvm/include/aarch64/processor.h |    5 +
 .../selftests/kvm/lib/aarch64/processor.c     |   27 +
 21 files changed, 5549 insertions(+), 298 deletions(-)
 create mode 100644 arch/arm64/kvm/.kunitconfig
 create mode 100644 arch/arm64/kvm/sys_regs_test.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/id_reg_test.c


base-commit: b3fa05b7ec851be680eb51b20ddda0b195b7cdb8
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
