Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF498C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  7 Apr 2022 01:16:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40D564B176;
	Wed,  6 Apr 2022 21:16:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id otijeCdpx8bp; Wed,  6 Apr 2022 21:16:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D052E4B10A;
	Wed,  6 Apr 2022 21:16:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D88A54A014
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 21:16:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZlyoQmOzjwuJ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2022 21:16:13 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2905D49F4E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 21:16:13 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 jz6-20020a17090b14c600b001ca9ea859afso2589087pjb.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Apr 2022 18:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=MMD4aaPWZb3CYrjJlK2cKEPJeYlRrUESs1eJoKlTYIE=;
 b=dhyRXX2892HfcdrLDMBhSYPfjfxtnj9b7k3GpjBXbEPbXDEu+4nkwKEqwWkyc3n/8e
 2vhOZ+/1rLVVNafCBAxduWrDGKiiYsjIhvPCCnxGYdaa8t0Wlg7yfc6y47RJWRZ/GYSs
 gF57aAej+9QMid2rms209UbBcsBC4IhB38vwdqvn2g2oCyQhQsGBOdB7rYCMwRMqTY85
 I2hjybNsIGQo+ksC8l9KG3Oj52I7DWLVLFXoKC0NTkbHukZHHBvz8mrsVUc6XpzWjYqp
 blkS7qR+QyZ3sEY9DGV1e6WPd0PAwC+AnhH6PY3NwC0jGGrIRBCHk5No5CDbkHo+vjEM
 XYLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=MMD4aaPWZb3CYrjJlK2cKEPJeYlRrUESs1eJoKlTYIE=;
 b=0FJqnRawrUJUEj9Z9HNE+s+rxcigm6ngqlWiwZZT9psEZUeYs0s0u+Hp3Q/QAW6jMn
 ibSN9CX/VICJ0KHpiJ3olHgMEL5ijzLoy5A0EcGyBNdK1UjD+L91eDTuN8YwlCj3cidj
 vV/30PHsBJMTxgckZVWkpVtfLqdH4LHj4wgD7DgniJwKx6SqTVu5mxPIL1eOsm956ciG
 jCcz6B0oEqVh9UwKMQqw8HF1ae9dgp7xkEXnUy5qphXe3bDL7pCdTBz41NNFeN45HHJ+
 OnY1sT0obsl+UnVkhNlyMoP8afVmU7G+1TId22J9GS/0R3++CIQ1IZrJPmN6nO26YZCz
 1a0w==
X-Gm-Message-State: AOAM532FIDEctOri9EiIlTViWqKRlaEwh2rvwXGqjjUg5ZlP6c6FnWso
 NEgYUYUug+/5h1F0ia5szVvzqS39gebf
X-Google-Smtp-Source: ABdhPJzOqKEOj/1Mv6B6B6vNFzaxFCRZ5g+ewhwZtNeJsweiH9wITEZTWB5gQ5nkfteBf9SAyU3eR8HgW1q5
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:a94:b0:4fd:c14b:21cb with SMTP id
 b20-20020a056a000a9400b004fdc14b21cbmr11748890pfl.53.1649294172085; Wed, 06
 Apr 2022 18:16:12 -0700 (PDT)
Date: Thu,  7 Apr 2022 01:15:55 +0000
Message-Id: <20220407011605.1966778-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v5 00/10] KVM: arm64: Add support for hypercall services
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
for the userspace to elect the hypercall services that it wishes
to expose to the guest, rather than the guest discovering them
unconditionally. The idea employed by the series was taken from
[1] as suggested by Marc Z.

In a broad sense, the concept is similar to the current implementation
of PSCI interface- create a 'firmware psuedo-register' to handle the
firmware revisions. The series extends this idea to all the other
hypercalls such as TRNG (True Random Number Generator), PV_TIME
(Paravirtualized Time), and PTP (Precision Time protocol).

For better categorization and future scaling, these firmware registers
are categorized based on the service call owners. Also, unlike the
existing firmware psuedo-registers, they hold the features supported
in the form of a bitmap.

During the VM initialization, the registers holds an upper-limit of
the features supported by each one of them. It's expected that the
userspace discover the features provided by each register via GET_ONE_REG,
and writeback the desired values using SET_ONE_REG. KVM allows this
modification only until the VM has started.

Some of the standard function-ids, such as ARM_SMCCC_VERSION_FUNC_ID,
need not be associated with a feature bit. For such ids, the series
introduced an allowed-list, hvc_func_default_allowed_list[], that holds
all such ids. As a result, the functions that are not elected by userspace,
or if they are not a part of this allowed-list, will be denied for when
the guests invoke them.

Older VMMs can simply ignore this interface and the hypercall services
will be exposed unconditionally to the guests, thus ensuring backward
compatibility.

The patches are based off of mainline kernel 5.18-rc1, with the selftest
patches from [2] applied.

Patch-1 factors out the non-PSCI related interface from psci.c to
hypercalls.c, as the series would extend the list in the upcoming
patches.

Patch-2 sets up the framework for the bitmap firmware psuedo-registers.
It includes read/write support for the registers, and a helper to check
if a particular hypercall service is supported for the guest.
It also adds the register KVM_REG_ARM_STD_HYP_BMAP to support ARM's
standard secure services.

Patch-3 introduces the firmware register, KVM_REG_ARM_STD_HYP_BMAP,
which holds the standard hypervisor services (such as PV_TIME).

Patch-4 introduces the firmware register, KVM_REG_ARM_VENDOR_HYP_BMAP,
which holds the vendor specific hypercall services.

Patch-5,6 Add the necessary documentation for the newly added firmware
registers.

Patch-7 imports the SMCCC definitions from linux/arm-smccc.h into tools/
for further use in selftests.

Patch-8 adds the selftest to test the guest (using 'hvc') and userspace
interfaces (SET/GET_ONE_REG).

Patch-9 adds these firmware registers into the get-reg-list selftest.

Patch-10 is unrelated to the series, but adds KVM_REG_ARM_FW_REG(3)
to base_regs[] of get-regs-list selftest for the sake of completion.

[1]: https://lore.kernel.org/kvmarm/874kbcpmlq.wl-maz@kernel.org/T/
[2]: https://lore.kernel.org/kvmarm/YUzgdbYk8BeCnHyW@google.com/

Regards,
Raghavendra

v4 -> v5:

Addressed comments by Oliver (thank you!):

- Rebased the series to accommodate ARM_SMCCC_ARCH_WORKAROUND_3
  and PSCI 1.1 changes, and capturing VM's first run.
- Removed the patches related to register scoping (v4 02/13 and
  03/13). I plan to re-introduce them in its own series.
- Dropped the patch that captures VM's first run.
- Moved the bitmap feature firmware registers to its own CORPOC
  space (0x0016).
- Move the KVM_REG_ARM_*_BIT_MAX definitions from uapi header
  to internal header (arm_hypercalls.h).
- Renamed the hypercall descriptor to 'struct kvm_smccc_features',
  and kvm_hvc_call_supported() to kvm_hvc_call_allowed().
- Introduced an allowed-list to hold the function-ids that aren't
  represented by feature-bits.
- Introduced kvm_psci_func_id_is_valid() to check if a given
  function-id is a valid PSCI id, which is used in
  kvm_hvc_call_allowed().
- Introduced KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT as bit-0 of
  KVM_REG_ARM_VENDOR_HYP_BMAP register and
  KVM_REG_ARM_VENDOR_HYP_BIT_PTP is moved to bit-1.
- Updated the arm-smccc.h import to include the definition of
  ARM_SMCCC_ARCH_WORKAROUND_3.
- Introduced the KVM_REG_ARM_FW_FEAT_BMAP COPROC definition to
  get-reg-list selftest.
- Created a new patch to include KVM_REG_ARM_FW_REG(3) in
  get-reg-list.


v3 -> v4

Addressed comments and took suggestions by Reiji, Oliver, Marc,
Sean and Jim:

- Renamed and moved the VM has run once check to arm64.
- Introduced the capability to dynamically modify the register
  encodings to include the scope information.
- Replaced mutex_lock with READ_ONCE and WRITE_ONCE when the
  bitmaps are accessed.
- The hypercalls selftest re-runs with KVM_CAP_ARM_REG_SCOPE
  enabled.

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
  core kvm code, rather than relying on ARM specific
  vcpu->arch.has_run_once.
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
v3: https://lore.kernel.org/linux-arm-kernel/20220104194918.373612-1-rananta@google.com/
v4: https://lore.kernel.org/lkml/20220224172559.4170192-1-rananta@google.com/

Raghavendra Rao Ananta (10):
  KVM: arm64: Factor out firmware register handling from psci.c
  KVM: arm64: Setup a framework for hypercall bitmap firmware registers
  KVM: arm64: Add standard hypervisor firmware register
  KVM: arm64: Add vendor hypervisor firmware register
  Docs: KVM: Rename psci.rst to hypercalls.rst
  Docs: KVM: Add doc for the bitmap firmware registers
  tools: Import ARM SMCCC definitions
  selftests: KVM: aarch64: Introduce hypercall ABI test
  selftests: KVM: aarch64: Add the bitmap firmware registers to
    get-reg-list
  selftests: KVM: aarch64: Add KVM_REG_ARM_FW_REG(3) to get-reg-list

 Documentation/virt/kvm/api.rst                |  17 +
 Documentation/virt/kvm/arm/hypercalls.rst     | 136 +++++++
 Documentation/virt/kvm/arm/psci.rst           |  77 ----
 arch/arm64/include/asm/kvm_host.h             |  16 +
 arch/arm64/include/uapi/asm/kvm.h             |  16 +
 arch/arm64/kvm/arm.c                          |   1 +
 arch/arm64/kvm/guest.c                        |  10 +-
 arch/arm64/kvm/hypercalls.c                   | 321 +++++++++++++++-
 arch/arm64/kvm/psci.c                         | 183 ----------
 include/kvm/arm_hypercalls.h                  |  22 ++
 include/kvm/arm_psci.h                        |  17 +-
 tools/include/linux/arm-smccc.h               | 193 ++++++++++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/get-reg-list.c      |   9 +
 .../selftests/kvm/aarch64/hypercalls.c        | 344 ++++++++++++++++++
 16 files changed, 1092 insertions(+), 272 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/hypercalls.rst
 delete mode 100644 Documentation/virt/kvm/arm/psci.rst
 create mode 100644 tools/include/linux/arm-smccc.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/hypercalls.c

-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
