Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D14BC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 04:19:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5476E4C3CA;
	Tue, 22 Feb 2022 23:19:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eHD7md1qIEts; Tue, 22 Feb 2022 23:19:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 500E84C3CE;
	Tue, 22 Feb 2022 23:19:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4FB04C3CB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0h9u-VrvzUFW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 23:19:02 -0500 (EST)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 517F44C3CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:02 -0500 (EST)
Received: by mail-io1-f73.google.com with SMTP id
 t72-20020a6bc34b000000b0063d7b2c24ecso13052063iof.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 20:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=rh/Pz7GShqLz5FQCLq9qwfWYqDB5jRhpe8UhyldNSc4=;
 b=l+cbCeQKyO8uknj64WCHlw/fpPURvdhvPLS4dVuTMTc8RIkeSAFNotw+gq/vQspKG6
 fye1+QK2f/bGEG1dRabgbbnOVIs/yd+eKVtM+S4VoceT1CcEwLFKx2QLyEACBc/vUGS4
 CzzVu2nFr1UOaIwl4XKOhZrshMWsuInlN/2Da24wc5oxkMZNdI5Jnx6kJJlmOW4W7o6Z
 bp0ZLHNuAWACEd2dC7wy4IWg2m7vE2GjrJCM4z9oJ4YTLNU3PVuxV32+Arf0E75eY8fj
 idTs/G/Mc6FbnyluIfqOc46IT8Dj4GUw5kthBZr3fPHJ3s+4LtdMhurUqDTxb34z9NGy
 qwMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=rh/Pz7GShqLz5FQCLq9qwfWYqDB5jRhpe8UhyldNSc4=;
 b=qoWxJz7cbcJA3PGeJDMbFJI1+sc5+AahzFxt4kM7ysj114e6PQ2MW7byj0r4QRJs+P
 hTlLw724jWa3YTM9GZYeC8A4NI4AKaT8+eNGK1S0HtGyN/y0wYHYjcEVfiOD1zLvlN0B
 FOBN3Y42wXKsZ1AN5feCsT2ry4GQwIAcOO8JWjyiW1L5a1VHeLE6B7stJ8wQ2UYkX6IQ
 wRzQ6N5mQ2yKNs82McFBcrWJf94qEmoxxp9GJn2Rr2568ax30VTT2O36vex3lMn9AgZP
 Y3TS1kDcB/ecZDhtmR7MmS1mYbnrKXKyrfoLOeHDZVY0wnF0sxK9u4yfCCZ4wt9W67+F
 U96A==
X-Gm-Message-State: AOAM531D4gt8a9vswzvuSkCa8amGYc4iJIDpKojTlRXJKE5Q4zJ8sQ85
 uVu8hP7hf49BG1S8wOcvn9AF1GqvquRUQdFIPgsJ59cvOblqoqDXJ+6e+snoVOkJekguPrlQdBf
 1cnGM7nvUJKN1AkOWzThYCTqiOcWzL37qJnJRJZvtbPloAcKj4unqt8VlyXt7gD+vfIcb2w==
X-Google-Smtp-Source: ABdhPJy1y64EgXE0D245F1bV1sdlGSK5971KnecjSD+vgnQFtsqE52fORA3Oa3hV4wWYMKsTBvpS1ErwXMk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:205:0:b0:638:57c4:d51 with
 SMTP id
 5-20020a6b0205000000b0063857c40d51mr21682341ioc.66.1645589941479; Tue, 22 Feb
 2022 20:19:01 -0800 (PST)
Date: Wed, 23 Feb 2022 04:18:25 +0000
Message-Id: <20220223041844.3984439-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 00/19] KVM: arm64: Implement PSCI SYSTEM_SUSPEND
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Atish Patra <atishp@atishpatra.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>
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

The PSCI v1.0 specification describes a call, SYSTEM_SUSPEND, which
allows software to request that the system be placed into the lowest
possible power state and await an IMPLEMENTATION DEFINED wakeup event.
This call is optional in v1.0 and v1.1. KVM does not currently support
it in the v1.0 implementation.

This series adds support for the PSCI SYSTEM_SUSPEND call to KVM/arm64.
By default, KVM will treat the call as equivalent to CPU_SUSPEND,
wherein KVM handles the call as a guest WFI. However, this series also
introduces an opt-in for the SYSTEM_SUSPEND call to exit to userspace.
VMMs may use the event as a hint to save the VM to resume at a later
time, freeing up system resources. Userspace can decide at the time of
the exit whether or not to honor the SYSTEM_SUSPEND call.

Patch 1 is a small cleanup already present in kvmarm/next, but the
series depends on it so it has been included to guarantee the series
builds.

Patches 2-3 adds an additional check to the CPU_ON PSCI call. As Reiji
noted, PSCI implementations can return INVALID_ADDRESS if it is
determined that the provided entry address does not exist in the guest
address space.

Patch 4 is another small cleanup to generically filter SMC64 calls when
running an AArch32 EL1, avoiding the need to add a special case for the
new PSCI call introduced in this series.

Patches 5-6 add support for tracking a vCPU's power state using
KVM_MP_STATE_* values. This is significant as the series introduces an
additional power state, which cannot be represented by the
`vcpu->arch.power_off` boolean.

Patch 7 is a nitpick regarding the naming of a KVM_REQ_ handler.

Patches 8-9 provide the default implementation of PSCI SYSTEM_SUSPEND by
synchronously resetting the calling vCPU and entering WFI.

Patches 10-12 introduce a new MP state, KVM_MP_STATE_SUSPENDED, which
implements 'sticky' suspension. If userspace puts a vCPU in this state,
it will exit to userspace for every recognized wakeup event (pending
interrupt). When userspace is satisfied that a VM should resume, it must
explicitly unpark the vCPU by marking it runnable again. This is useful
for userspace to implement PSCI SYSTEM_SUSPEND if it decides to trap the
call.

Patch 13 extends upon the implementation of PSCI SYSTEM_SUSPEND,
granting userspace the opt-in capability of exiting to userspace on such
a call. *NOTE* KVM_SYSTEM_EVENT_SUSPEND breaks away from the semantics
of other system events. Userspace is required to manipulate the vCPU to
either reset it or reject the call. Other PSCI calls that exit set an
SMCCC return value before exiting, but doing so would clobber all of the
pending reset state. I wanted to avoid adding additional API to convey
the reset context to userspace so it may simply be expressed in the
architected state.

Patch 14 increments the reported PSCI version to 1.1, as KVM already
meets the requirements.

Patches 15-18 rework the PSCI selftest to make it amenable to additional
test cases

Lastly, patch 19 tests that the KVM_SYSTEM_EVENT_SUSPEND exits are
working as intended, and that KVM rejects invalid calls to PSCI
SYSTEM_SUSPEND.

This series applies cleanly to v5.17-rc5. Testing was performed with the
included selftest and suspending a QEMU guest (i.e. no system event
exits) on an Ampere Altra machine.

v2: https://patchwork.kernel.org/project/kvm/cover/20210923191610.3814698-1-oupton@google.com/

v2 -> v3:
 - rebase to 5.17-rc5
 - Reject CPU_ON and SYSTEM_SUSPEND calls that provide an invalid IPA
   (Reiji)
 - do *not* defer WFI as a requested event (Marc)
 - Add support for userspace filtering of wakeup events if SUSPEND exits
   are enabled (Marc)
 - Bump the reported PSCI verision to v1.1 (Marc)

Oliver Upton (19):
  KVM: arm64: Drop unused param from kvm_psci_version()
  KVM: arm64: Create a helper to check if IPA is valid
  KVM: arm64: Reject invalid addresses for CPU_ON PSCI call
  KVM: arm64: Clean up SMC64 PSCI filtering for AArch32 guests
  KVM: arm64: Dedupe vCPU power off helpers
  KVM: arm64: Track vCPU power state using MP state values
  KVM: arm64: Rename the KVM_REQ_SLEEP handler
  KVM: arm64: Add reset helper that accepts caller-provided reset state
  KVM: arm64: Implement PSCI SYSTEM_SUSPEND
  KVM: Create helper for setting a system event exit
  KVM: arm64: Return a value from check_vcpu_requests()
  KVM: arm64: Add support for userspace to suspend a vCPU
  KVM: arm64: Add support KVM_SYSTEM_EVENT_SUSPEND to PSCI
    SYSTEM_SUSPEND
  KVM: arm64: Raise default PSCI version to v1.1
  selftests: KVM: Rename psci_cpu_on_test to psci_test
  selftests: KVM: Create helper for making SMCCC calls
  selftests: KVM: Use KVM_SET_MP_STATE to power off vCPU in psci_test
  selftests: KVM: Refactor psci_test to make it amenable to new tests
  selftests: KVM: Test SYSTEM_SUSPEND PSCI call

 Documentation/virt/kvm/api.rst                |  62 ++++-
 arch/arm64/include/asm/kvm_host.h             |  27 ++-
 arch/arm64/include/asm/kvm_mmu.h              |   9 +
 arch/arm64/kvm/arm.c                          |  88 +++++--
 arch/arm64/kvm/psci.c                         | 129 ++++++++---
 arch/arm64/kvm/reset.c                        |  45 ++--
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |   2 +-
 arch/riscv/kvm/vcpu_sbi_v01.c                 |   4 +-
 arch/x86/kvm/x86.c                            |   6 +-
 include/kvm/arm_psci.h                        |   9 +-
 include/linux/kvm_host.h                      |   7 +
 include/uapi/linux/kvm.h                      |   4 +
 tools/testing/selftests/kvm/.gitignore        |   2 +-
 tools/testing/selftests/kvm/Makefile          |   2 +-
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  | 121 ----------
 .../testing/selftests/kvm/aarch64/psci_test.c | 218 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  22 ++
 .../selftests/kvm/lib/aarch64/processor.c     |  25 ++
 tools/testing/selftests/kvm/steal_time.c      |  13 +-
 19 files changed, 571 insertions(+), 224 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/psci_test.c

-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
