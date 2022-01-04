Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE62C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jan 2022 19:49:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 611DB49F1B;
	Tue,  4 Jan 2022 14:49:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 69yK9GYY0wcg; Tue,  4 Jan 2022 14:49:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE24F49F06;
	Tue,  4 Jan 2022 14:49:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 542C949EE5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 14:49:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZUcXIYKPbFF4 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jan 2022 14:49:26 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F24D749EE4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 14:49:25 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 e2-20020a25d302000000b0060c57942183so48217446ybf.18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Jan 2022 11:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=IEORO/iYFf2VjFKaMP/KExgfiXLrmBMQvly5qD2u6/4=;
 b=tAhoweIQO71Ze0ID6fg4zlWkqUwdyH18QX3nbcYEDT/xwMwaquKeo+g/Q/ICA47sQJ
 Z9BuOCYXu4JH7/o54egGn+5VR5oO05fFW3ismHUnRRDlcbAMT73Iw7YkhxBYZxd5c7uN
 QTT8vbjWJWuUs53Xyo//0XvptuImAEWRNM469dQpf3/3A+BQ//eOncgt2eHuGcmS4NvM
 eyQujjgrl5GtlrzHFqca/1ZZXIzk72X2Gb06xEFjQjDo1IDG8BRVUtlbdryEq8gnEi3w
 dfTIBVSd6kwfI6HS/j8ujbFYWWC8voXcOtAO8drES2H9SyWnQX2nX1uShG6qWYqol4i8
 VbcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=IEORO/iYFf2VjFKaMP/KExgfiXLrmBMQvly5qD2u6/4=;
 b=rbTaFZnP/JSEIDGjwjFx+GOr/Lf2r6DeDX24JPe1iC8fzgQl/gKMj0Uy+SbeD9q0/+
 XUBU2SumDlFili6D2JeB5sXoeXB2JsZUdmuvm90dI5SfDvUgPvorcFTxSHERfbWk9Fgd
 xQ8fsBv3rcUYO2a3WsWcyEoxSbGg/8h6r5bEhXdPkRB8j6EBuefYDDfPmK7M8wZkP8IK
 qyvQF0b8ft4QdDmJmkkY2l338iQ0qfPU6uo/NaIGDvV4sCf298xZHax2kAKdB1fub4JN
 wPzrBy+IF5Yprepsxl+OAg5ffiZs+hZF5Pzx0QJ5wEimxwHjTOdTGeqpyOkhNo6ygz+l
 2eqQ==
X-Gm-Message-State: AOAM530VpNEX392W00QVpVxOvXlTh8zIPg38FjyI9HncUkqacMVI4g+8
 sVkpgTjWMK/okz34GIAshCFon2sQMNWv
X-Google-Smtp-Source: ABdhPJwaLkymY18bbNos6WDQ6le275/TDkIVa5kitH/PvBr+tgwSlGwMDCePL9Zm6bw7Dtaky1bj7klICSdl
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:2f56:: with SMTP id
 v83mr49594340ybv.94.1641325765316; Tue, 04 Jan 2022 11:49:25 -0800 (PST)
Date: Tue,  4 Jan 2022 19:49:07 +0000
Message-Id: <20220104194918.373612-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v3 00/11] KVM: arm64: Add support for hypercall services
 selection
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hello,

Continuing the discussion from [1], the series tries to add support
for the user-space to elect the hypercall services that it wishes
to expose to the guest, rather than the guest discovering them
unconditionally. The idea employed by the series was taken from
[1] as suggested by Marc Z.

In a broad sense, the idea is similar to the current implementation
of PSCI interface- create a 'firmware psuedo-register' to handle the
firmware revisions. The series extends this idea to all the other
hypercalls such as TRNG (True Random Number Generator), PV_TIME
(Paravirtualized Time), and PTP (Precision Time protocol).

For better categorization and future scaling, these firmware registers
are categorized based on the service call owners, but unlike the
existing firmware psuedo-registers, they hold the features supported
in the form of a bitmap.

The capability, KVM_CAP_ARM_HVC_FW_REG_BMAP, is introduced to announce
this extension, which returns the number of psuedo-firmware
registers supported. During the VM initialization, the registers
holds an upper-limit of the features supported by each one of them.
It's expected that the VMMs discover the features provided by each
register via GET_ONE_REG, and writeback the desired values using
SET_ONE_REG. KVM allows this modification only until the VM has started.

Older VMMs can simply ignore the capability and the hypercall services
will be exposed unconditionally to the guests, thus ensuring backward
compatibility.

The patches are based off of mainline kernel 5.16-rc8, with the selftest
patches from [2] applied.

Patch-1 tracks if the VM has started running, which would be used in the
upcoming patches.

Patch-2 factors out the non-PSCI related interface from psci.c to
hypercalls.c, as the series would extend the list in the upcoming
patches.

Patch-3 introduces the KVM_CAP_ARM_HVC_FW_REG_BMAP capability
definition.

Patch-4 sets up the framework for the bitmap firmware psuedo-registers.
It includes read/write helpers for the registers, and a helper to check
if a particular hypercall service is supported for the guest.
It also adds the register KVM_REG_ARM_STD_HYP_BMAP to support ARM's
standard secure services.

Patch-5 introduces the firmware register, KVM_REG_ARM_STD_HYP_BMAP,
which holds the standard hypervisor services (such as PV_TIME).

Patch-6 introduces the firmware register, KVM_REG_ARM_VENDOR_HYP_BMAP,
which holds the vendor specific hypercall services.

Patch-7,8 Add the necessary documentation for the newly added firmware
registers.

Patch-9 imports the SMCCC definitions from linux/arm-smccc.h into tools/
for further use in selftests.

Patch-10 adds the selftest to test the guest (using 'hvc') and VMM
interfaces (SET/GET_ONE_REG).

Patch-11 adds these firmware registers into the get-reg-list selftest.

[1]: https://lore.kernel.org/kvmarm/874kbcpmlq.wl-maz@kernel.org/T/
[2]: https://lore.kernel.org/kvmarm/YUzgdbYk8BeCnHyW@google.com/

Regards,
Raghavendra

v2 -> v3

Addressed comments by Marc and Andrew:

- Dropped kvm_vcpu_has_run_once() implementation.
- Redifined kvm_vm_has_run_once() as kvm_vm_has_started() in the core
  KVM code that introduces a new field, 'vm_started', to track this.
- KVM_CAP_ARM_HVC_FW_REG_BMAP returns the number of psuedo-firmware
  bitmap registers upon a 'read'. Support for 'write' removed.
- Removed redundant spinlock, 'fw_reg_bmap_enabled' fields from the
  hypercall descriptor structure.
- A separate sub-struct to hold the bitmap info is removed. The bitmap
  info is directly stored in the hypercall descriptor structure
  (struct kvm_hvc_desc).

v1 -> v2

Addressed comments by Oliver (thanks!):

- Introduced kvm_vcpu_has_run_once() and kvm_vm_has_run_once() in the
  core kvm code, rather than relying on ARM specific vcpu->arch.has_run_once.
- Writing to KVM_REG_ARM_PSCI_VERSION is done in hypercalls.c itself,
  rather than separating out to psci.c.
- Introduced KVM_CAP_ARM_HVC_FW_REG_BMAP to enable the extension.
- Tracks the register accesses from VMM to decide whether to sanitize
  a register or not, as opposed to sanitizing upon the first 'write'
  in v1.
- kvm_hvc_call_supported() is implemented using a direct switch-case
  statement, instead of looping over all the registers to pick the
  register for the function-id.
- Replaced the register bit definitions with #defines, instead of enums.
- Removed the patch v1-06/08 that imports the firmware register
  definitions as it's not needed.
- Separated out the documentations in its own patch, and the renaming
  of hypercalls.rst to psci.rst into another patch.
- Add the new firmware registers to get-reg-list KVM selftest.

v1: https://lore.kernel.org/kvmarm/20211102002203.1046069-1-rananta@google.com/
v2: https://lore.kernel.org/kvmarm/20211113012234.1443009-1-rananta@google.com/

Raghavendra Rao Ananta (11):
  KVM: Capture VM start
  KVM: arm64: Factor out firmware register handling from psci.c
  KVM: Introduce KVM_CAP_ARM_HVC_FW_REG_BMAP
  KVM: arm64: Setup a framework for hypercall bitmap firmware registers
  KVM: arm64: Add standard hypervisor firmware register
  KVM: arm64: Add vendor hypervisor firmware register
  Docs: KVM: Add doc for the bitmap firmware registers
  Docs: KVM: Rename psci.rst to hypercalls.rst
  tools: Import ARM SMCCC definitions
  selftests: KVM: aarch64: Introduce hypercall ABI test
  selftests: KVM: aarch64: Add the bitmap firmware registers to
    get-reg-list

 Documentation/virt/kvm/api.rst                |  21 +
 Documentation/virt/kvm/arm/hypercalls.rst     | 128 +++++++
 Documentation/virt/kvm/arm/psci.rst           |  77 ----
 arch/arm64/include/asm/kvm_host.h             |  16 +
 arch/arm64/include/uapi/asm/kvm.h             |  12 +
 arch/arm64/kvm/arm.c                          |   4 +
 arch/arm64/kvm/guest.c                        |   2 +-
 arch/arm64/kvm/hypercalls.c                   | 311 ++++++++++++++-
 arch/arm64/kvm/psci.c                         | 166 --------
 arch/arm64/kvm/pvtime.c                       |   3 +
 arch/arm64/kvm/trng.c                         |   8 +-
 include/kvm/arm_hypercalls.h                  |  19 +
 include/kvm/arm_psci.h                        |   7 -
 include/linux/kvm_host.h                      |   3 +
 include/uapi/linux/kvm.h                      |   1 +
 tools/include/linux/arm-smccc.h               | 188 +++++++++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/get-reg-list.c      |   3 +
 .../selftests/kvm/aarch64/hypercalls.c        | 358 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |   9 +
 21 files changed, 1078 insertions(+), 260 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/hypercalls.rst
 delete mode 100644 Documentation/virt/kvm/arm/psci.rst
 create mode 100644 tools/include/linux/arm-smccc.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/hypercalls.c

-- 
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
