Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89516C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 17:26:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F41C64BDBB;
	Thu, 24 Feb 2022 12:26:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fYF2az61RTAk; Thu, 24 Feb 2022 12:26:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84C984BD83;
	Thu, 24 Feb 2022 12:26:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46E3F4BD3A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:26:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jTsMH9mZEvdv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 12:26:07 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 86DF14BD33
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:26:07 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 e7-20020a17090a4a0700b001bc5a8c533eso1738659pjh.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 09:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=5Ny1Q9o1DH3vUqhRTmZugJ8ecAooD8oCu9bG8GcZG5g=;
 b=AMkSiIAbv28C9s3534CeAzvP41t3i9zYDrUhSKV/GA3Cg+sV66ia3Q5uqP4PKb7OO7
 wAhn6S/lI9YaIBd+pTgFHXr0WM3wL3VuXqz/KFRIFYaf8RWi+FxtuLbTPfmlkuBkX7zf
 ZS19r3R1vEzr8k0RfTI9Pk6AT26AmwETZOJgvE4HnVw9f+fq+Y01pXGR8Krot1YskYcN
 meo6tVZozIQlOMu+Lu9h81oOwwfIW+Wj9tKK5oQvXDRfJA6Qujt98KUnGgHi3v3ZNaJQ
 yV2CaMGkebo6JECAYLdfal3LzYb9F6FhxGm3DK64ZnGrVuLiPV6C1HS8j2PpfOGpkAwg
 6d0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=5Ny1Q9o1DH3vUqhRTmZugJ8ecAooD8oCu9bG8GcZG5g=;
 b=P+cHtgZAEnudds9Yw03+eHM+mXu5Jv9zJGhGEyK+khP/Cw2WHabC5TX0QpcmGYKiSo
 Jd8RXdqNH7xzjBkJ83Ogm1+u8Ez7CiFhNs0GIcWN/KBPc2M3LmvZXo68QsrJMmNAMkK6
 22gMsu/OdzbRSd4tfDosdb1Zvs+I8XC6ZjPCsguYVIkVgyRwg9tnAQv1fT0zvMj62IGo
 7Xn4iG3tAmhziBLuhOLSMtL2JFwIG47Znq78oIstzz97VO9CwbUuIbRB6M+aX94KvZyZ
 /ZswgKH+Rl3HpD1JUoYI0SeLHn0+2gpBCRsOKIIYwkB0sucE4BvxnuAr6cySYFxuBl5b
 EU7w==
X-Gm-Message-State: AOAM532hkFEIoM6618jfe0Ii0ANlJyTs1CnfRkwwY7rtEHCbo5XuFeGN
 /3u3s/AU70XZ9LIIWYlXLHL358HbZvLd
X-Google-Smtp-Source: ABdhPJwnohW5A3uggSBCdW9O8Nv3B8wp5qqKcNw8tPsPI6pD9WxbKGiIR8gcGQ9h/3es0ugh4EeX4XMihRl0
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90b:4f43:b0:1bc:7e5c:e024 with SMTP id
 pj3-20020a17090b4f4300b001bc7e5ce024mr94032pjb.0.1645723565741; Thu, 24 Feb
 2022 09:26:05 -0800 (PST)
Date: Thu, 24 Feb 2022 17:25:46 +0000
Message-Id: <20220224172559.4170192-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 00/13] KVM: arm64: Add support for hypercall services
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

During the VM initialization, the registers holds an upper-limit of
the features supported by each one of them. It's expected that the
userspace discover the features provided by each register via GET_ONE_REG,
and writeback the desired values using SET_ONE_REG. KVM allows this
modification only until the VM has started.

Older VMMs can simply ignore the capability and the hypercall services
will be exposed unconditionally to the guests, thus ensuring backward
compatibility.

Since these registers, including the old ones such as
KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_[1|2] maintain its state per-VM. Thus
accessing them via KVM_[GET|SET]_ONE_REG for every vCPU is redundant.
To optimize this, the series also introduces the capability
KVM_CAP_ARM_REG_SCOPE. If enabled, KVM_GET_REG_LIST will advertise the
registers that are VM-scoped by dynamically modifying the register
encoding. KVM_REG_ARM_SCOPE_* helper macros are introduced to decode
the same. By learning this, userspace can access such registers only once.

The patches are based off of mainline kernel 5.17-rc5, with the selftest
patches from [2] applied.

Patch-1 factors out the non-PSCI related interface from psci.c to
hypercalls.c, as the series would extend the list in the upcoming
patches.

Patch-2 introduces the KVM_CAP_ARM_REG_SCOPE capability.

Patch-3 provides helpers to encode existing registers withe the scope
information. The only users in the patch would be the registers,
KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_[1|2]

Patch-4 tracks if the VM has started running, which would be used in the
upcoming patches.

Patch-5 sets up the framework for the bitmap firmware psuedo-registers.
It includes read/write helpers for the registers, and a helper to check
if a particular hypercall service is supported for the guest.
It also adds the register KVM_REG_ARM_STD_HYP_BMAP to support ARM's
standard secure services.

Patch-6 introduces the firmware register, KVM_REG_ARM_STD_HYP_BMAP,
which holds the standard hypervisor services (such as PV_TIME).

Patch-7 introduces the firmware register, KVM_REG_ARM_VENDOR_HYP_BMAP,
which holds the vendor specific hypercall services.

Patch-8,9 Add the necessary documentation for the newly added firmware
registers.

Patch-10 imports the SMCCC definitions from linux/arm-smccc.h into tools/
for further use in selftests.

Patch-11,12 adds the selftest to test the guest (using 'hvc') and
userspace interfaces (SET/GET_ONE_REG).

Patch-13 adds these firmware registers into the get-reg-list selftest.

[1]: https://lore.kernel.org/kvmarm/874kbcpmlq.wl-maz@kernel.org/T/
[2]: https://lore.kernel.org/kvmarm/YUzgdbYk8BeCnHyW@google.com/

Regards,
Raghavendra

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

Raghavendra Rao Ananta (13):
  KVM: arm64: Factor out firmware register handling from psci.c
  KVM: arm64: Introduce KVM_CAP_ARM_REG_SCOPE
  KVM: arm64: Encode the scope for firmware registers
  KVM: arm64: Capture VM's first run
  KVM: arm64: Setup a framework for hypercall bitmap firmware registers
  KVM: arm64: Add standard hypervisor firmware register
  KVM: arm64: Add vendor hypervisor firmware register
  Docs: KVM: Add doc for the bitmap firmware registers
  Docs: KVM: Rename psci.rst to hypercalls.rst
  tools: Import ARM SMCCC definitions
  selftests: KVM: aarch64: Introduce hypercall ABI test
  selftests: KVM: aarch64: hypercalls: Test with KVM_CAP_ARM_REG_SCOPE
  selftests: KVM: aarch64: Add the bitmap firmware registers to
    get-reg-list

 Documentation/virt/kvm/api.rst                |  16 +
 Documentation/virt/kvm/arm/hypercalls.rst     | 124 +++++
 Documentation/virt/kvm/arm/psci.rst           |  77 ---
 arch/arm64/include/asm/kvm_host.h             |  30 ++
 arch/arm64/include/uapi/asm/kvm.h             |  22 +
 arch/arm64/kvm/arm.c                          |  23 +-
 arch/arm64/kvm/guest.c                        |  82 +++-
 arch/arm64/kvm/hypercalls.c                   | 301 +++++++++++-
 arch/arm64/kvm/psci.c                         | 166 -------
 include/kvm/arm_hypercalls.h                  |  17 +
 include/kvm/arm_psci.h                        |   7 -
 include/uapi/linux/kvm.h                      |   1 +
 tools/include/linux/arm-smccc.h               | 188 ++++++++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/get-reg-list.c      |   3 +
 .../selftests/kvm/aarch64/hypercalls.c        | 443 ++++++++++++++++++
 17 files changed, 1243 insertions(+), 259 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/hypercalls.rst
 delete mode 100644 Documentation/virt/kvm/arm/psci.rst
 create mode 100644 tools/include/linux/arm-smccc.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/hypercalls.c

-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
