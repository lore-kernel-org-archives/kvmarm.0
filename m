Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6FF2C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 04:27:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48DAA49ED1;
	Wed,  5 Jan 2022 23:27:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yZ6WxkmmHAcQ; Wed,  5 Jan 2022 23:27:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C23F749F02;
	Wed,  5 Jan 2022 23:27:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14CCE49ECC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:27:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5HorMDi+h+Nm for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 23:27:43 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 69B6749ECA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:27:43 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 d13-20020a63f24d000000b003424f1d4733so859266pgk.21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 20:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=p5OmhDUKTSdXgIVBJTRzlm/yO6iCAGZALwLyAA/W8/E=;
 b=ETqu3qwsfvkFjYpuDO4ArzyBdi/PRKWCriQwI382qxOnkbbd9z3XPiMlOEclkNJKZm
 7/4ePGczV4KlaBOCJyYHbftf1yYtL9FSHSbQ6cxZqLmtBMioPAXHSJywhp4RKh7s6Qvc
 WvNP79elyyGxY+Dtt76C6bqta17smbd4EQN9ui0sPn9B31zpP/KOD64t1f2Mu04oYKT7
 AfqlMO15P1HOzprKvQcYyVC6pNfNqvrXaeS+49hEosZM7l6vNUuzhg9xQk+JFVQB8sXg
 +JFq+jT/12jWiNvmOr/aTdu9m/t7ADYCGedNG1qeoLaNlmSKhhgYQzOVfusR5Pnv8dRG
 WmTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=p5OmhDUKTSdXgIVBJTRzlm/yO6iCAGZALwLyAA/W8/E=;
 b=FbHyu3od4lHwcX2TGFzmtthiL8+sO8+9G5O7YzrbG2nhpTl9NUvJgqsCreQvgaf8uk
 +vadyTXVHPx0VzDqI4i5oY/b5Uu5vKRpRUE8m/+bY/9dc9OHWvL0IzxDu7l+ixEBXoUE
 2vrLB4Dy+7WdLRCgV5K1PtTQ1B2xhskD0xKqCYeXeyft1jkfNSwKPptR54vm57CKroFj
 2PdGdxlzoL3Pn7o5apmg4O1g8F6Q6vpUrkm1HlBbhdr2K0ew81V5SGVeFwBDQBihoBUh
 A3nelcEVhIT0wEMyPHOBJxDCQXF31eZ0toppZx+pKFJlF2F+08IXFt1YUp4KTRbvFLor
 G5Sw==
X-Gm-Message-State: AOAM530mMbXr8kMgwqi5vTvnB9dIbjEQ54n8mLSKBvChWl2xRmHGCrvL
 19vQcMceMkJQwg6yPyh+Kgw21qL049A=
X-Google-Smtp-Source: ABdhPJwjEt0QYayHdlCuhfQf+mqyi1RRsLZUMQCWKjoXCx/27K4Tj8gHRYYYXEL6L5ruxJXGkIxmZyKIrNE=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:dac9:b0:148:a2e7:fb1a with SMTP id
 q9-20020a170902dac900b00148a2e7fb1amr57612181plx.91.1641443262475; Wed, 05
 Jan 2022 20:27:42 -0800 (PST)
Date: Wed,  5 Jan 2022 20:26:42 -0800
Message-Id: <20220106042708.2869332-1-reijiw@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 00/26] KVM: arm64: Make CPU ID registers writable by
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
is inconvenient.

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

This series adds kunit tests for new functions in sys_regs.c (except for
trivial ones), and these tests are enabled with a new configuration
option 'CONFIG_KVM_KUNIT_TEST'.

The series is based on v5.16-rc8 with the patch [3] applied.

v4:
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

[1] https://lore.kernel.org/kvmarm/20211010145636.1950948-1-tabba@google.com/
[2] https://lore.kernel.org/kvm/20201102033422.657391-1-liangpeng10@huawei.com/
[3] https://lore.kernel.org/all/20220104194918.373612-2-rananta@google.com/

Reiji Watanabe (26):
  KVM: arm64: Introduce a validation function for an ID register
  KVM: arm64: Save ID registers' sanitized value per guest
  KVM: arm64: Introduce struct id_reg_info
  KVM: arm64: Make ID_AA64PFR0_EL1 writable
  KVM: arm64: Make ID_AA64PFR1_EL1 writable
  KVM: arm64: Make ID_AA64ISAR0_EL1 writable
  KVM: arm64: Make ID_AA64ISAR1_EL1 writable
  KVM: arm64: Make ID_AA64MMFR0_EL1 writable
  KVM: arm64: Hide IMPLEMENTATION DEFINED PMU support for the guest
  KVM: arm64: Make ID_AA64DFR0_EL1 writable
  KVM: arm64: Make ID_DFR0_EL1 writable
  KVM: arm64: Make MVFR1_EL1 writable
  KVM: arm64: Make ID registers without id_reg_info writable
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
  KVM: arm64: selftests: Introduce id_reg_test

 Documentation/virt/kvm/api.rst                |   12 +
 arch/arm64/include/asm/cpufeature.h           |    3 +-
 arch/arm64/include/asm/kvm_arm.h              |   32 +
 arch/arm64/include/asm/kvm_host.h             |   19 +
 arch/arm64/include/asm/sysreg.h               |    3 +
 arch/arm64/kernel/cpufeature.c                |  228 +++
 arch/arm64/kvm/.kunitconfig                   |    4 +
 arch/arm64/kvm/Kconfig                        |   11 +
 arch/arm64/kvm/arm.c                          |   24 +-
 arch/arm64/kvm/debug.c                        |   13 +-
 arch/arm64/kvm/hyp/vhe/switch.c               |   14 +-
 arch/arm64/kvm/sys_regs.c                     | 1329 +++++++++++++++--
 arch/arm64/kvm/sys_regs_test.c                | 1247 ++++++++++++++++
 arch/arm64/kvm/vgic/vgic-init.c               |    5 +
 include/uapi/linux/kvm.h                      |    1 +
 tools/arch/arm64/include/asm/sysreg.h         |    1 +
 tools/testing/selftests/kvm/.gitignore        |    1 +
 tools/testing/selftests/kvm/Makefile          |    1 +
 .../selftests/kvm/aarch64/id_reg_test.c       | 1239 +++++++++++++++
 19 files changed, 4041 insertions(+), 146 deletions(-)
 create mode 100644 arch/arm64/kvm/.kunitconfig
 create mode 100644 arch/arm64/kvm/sys_regs_test.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/id_reg_test.c


base-commit: d399b107ee49bf5ea0391bd7614d512809e927b0
-- 
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
