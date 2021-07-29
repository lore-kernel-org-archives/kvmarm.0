Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B43C43214
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 00:10:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C2E2A6104F
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 00:10:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C2E2A6104F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40A634B099;
	Wed, 28 Jul 2021 20:10:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HC9ujPnbXGaJ; Wed, 28 Jul 2021 20:10:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F334D4AEE2;
	Wed, 28 Jul 2021 20:10:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACE564B085
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 20:10:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4v3YL1JanEh5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jul 2021 20:10:22 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CABB49FA6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 20:10:22 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 g11-20020a25ae4b0000b02905792fb55b0bso4871646ybe.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 17:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=99c49L3+Zl3kTX1nRDP8/rKylEgF5wqgIgkpMRASmII=;
 b=JmEO2+LXxq988dTps+aeUhSs0bf98qApbIvIkf7ClPa4CjiDW1P8gP1rtqLACjbrjP
 NjceCXXENlgjVsIoMcJQCEqt6mkyFP3/+Y1FMaUVpc87LvbUxcsLDRMEVPSK8C+M9DTm
 pkoqtURFI4JmgLgrdjl5FzsF8Hs385rkndtLujMFF74ZAXFOLlTgg4Ag/MHvpGS0nN82
 rMdkmmUF32HiiVJ5+TpcomXEaLwFkLZIv2TFRdBkrDPSHJxuEObuHGZr3+fdWETj4XSl
 u+MwyMF5sdheDC5pgAhCQNNOIsgZKT0z9ujZedqS4XgwIFY3OWaWfA1ZFUojYMuDhJIZ
 yBLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=99c49L3+Zl3kTX1nRDP8/rKylEgF5wqgIgkpMRASmII=;
 b=bRzcr2v3XcbFgYRCvSlmbSbBhrXtkMXf8RKbm0/tta+u353igj5MUs8Y+eusIAAVzQ
 OrGt81M6mx5IzaKLCONDs93vihofia8Bh37IcFpcTOB5H/jJzpIgVLOMXPc+K+sgo8De
 YDsdrOXa2fE86EvtrWSYqzLEAyBBt/AFbIIV8NS4vSzqJLNfLQjZFJ4uLM+efmBhr7wG
 qxTQ8UUFIwD6X6UxvV6Xv7cQtePcWSvbtxyi8qGSLa0LlXRzycUA07fqlIMuZuKa2q3D
 7usHV8v/pDI8Qz2+0GNSaFX2LeKUkL3/rGAva56Uhrt1aSqzSrrtP8XbVzE6GhRBpT5+
 4pLg==
X-Gm-Message-State: AOAM530lv1/GY5b2lGexjvL9W0zesy5RQxNJbKuzpsgb4YUG0EhPIfsu
 5nT87xLVEeDVzNybrR3dAYZAX6fSBYI=
X-Google-Smtp-Source: ABdhPJyZ/XhRiHsl9K9UxY9ljR0tWMoMUszGG7V7+fEQHJUTUHMgWx388Q0SI6yFWBEjHdAGcb/X/ywvpiY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:dc50:: with SMTP id
 y77mr3336332ybe.484.1627517421452; 
 Wed, 28 Jul 2021 17:10:21 -0700 (PDT)
Date: Thu, 29 Jul 2021 00:09:59 +0000
Message-Id: <20210729001012.70394-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v4 00/13] KVM: Add idempotent controls for migrating system
 counter state
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

KVM's current means of saving/restoring system counters is plagued with
temporal issues. At least on ARM64 and x86, we migrate the guest's
system counter by-value through the respective guest system register
values (cntvct_el0, ia32_tsc). Restoring system counters by-value is
brittle as the state is not idempotent: the host system counter is still
oscillating between the attempted save and restore. Furthermore, VMMs
may wish to transparently live migrate guest VMs, meaning that they
include the elapsed time due to live migration blackout in the guest
system counter view. The VMM thread could be preempted for any number of
reasons (scheduler, L0 hypervisor under nested) between the time that
it calculates the desired guest counter value and when KVM actually sets
this counter state.

Despite the value-based interface that we present to userspace, KVM
actually has idempotent guest controls by way of system counter offsets.
We can avoid all of the issues associated with a value-based interface
by abstracting these offset controls in new ioctls. This series
introduces new vCPU device attributes to provide userspace access to the
vCPU's system counter offset.

Patch 1 adopts Paolo's suggestion, augmenting the KVM_{GET,SET}_CLOCK
ioctls to provide userspace with a (host_tsc, realtime) instant. This is
essential for a VMM to perform precise migration of the guest's system
counters.

Patches 2-3 add support for x86 by shoehorning the new controls into the
pre-existing synchronization heuristics.

Patches 4-5 implement a test for the new additions to
KVM_{GET,SET}_CLOCK.

Patch 6 fixes some assertions in the kvm device attribute helpers.

Patches 7-8 implement at test for the tsc offset attribute introduced in
patch 3.

Patch 9 adds a device attribute for the arm64 virtual counter-timer
offset.

Patch 10 extends the test from patch 8 to cover the arm64 virtual
counter-timer offset.

Patch 11 adds a device attribute for the arm64 physical counter-timer
offset. Currently, this is implemented as a synthetic register, forcing
the guest to trap to the host and emulating the offset in the fast exit
path. Later down the line we will have hardware with FEAT_ECV, which
allows the hypervisor to perform physical counter-timer offsetting in
hardware (CNTPOFF_EL2).

Patch 12 extends the test from patch 8 to cover the arm64 physical
counter-timer offset.

Patch 13 introduces a benchmark to measure the overhead of emulation in
patch 11.

This series was tested on both an Ampere Mt. Jade and Haswell systems.

Physical counter benchmark
--------------------------

The following data was collected by running 10000 iterations of the
benchmark test from Patch 6 on an Ampere Mt. Jade reference server, A 2S
machine with 2 80-core Ampere Altra SoCs. Measurements were collected
for both VHE and nVHE operation using the `kvm-arm.mode=` command-line
parameter.

nVHE
----

+--------------------+--------+---------+
|       Metric       | Native | Trapped |
+--------------------+--------+---------+
| Average            | 54ns   | 148ns   |
| Standard Deviation | 124ns  | 122ns   |
| 95th Percentile    | 258ns  | 348ns   |
+--------------------+--------+---------+

VHE
---

+--------------------+--------+---------+
|       Metric       | Native | Trapped |
+--------------------+--------+---------+
| Average            | 53ns   | 152ns   |
| Standard Deviation | 92ns   | 94ns    |
| 95th Percentile    | 204ns  | 307ns   |
+--------------------+--------+---------+

This series applies cleanly to kvm/queue at the following commit:

8ad5e63649ff ("KVM: Don't take mmu_lock for range invalidation unless necessary")

v1 -> v2:
  - Reimplemented as vCPU device attributes instead of a distinct ioctl.
  - Added the (realtime, host_tsc) instant support to KVM_{GET,SET}_CLOCK
  - Changed the arm64 implementation to broadcast counter
    offset values to all vCPUs in a guest. This upholds the
    architectural expectations of a consistent counter-timer across CPUs.
  - Fixed a bug with traps in VHE mode. We now configure traps on every
    transition into a guest to handle differing VMs (trapped, emulated).

v2 -> v3:
  - Added documentation for additions to KVM_{GET,SET}_CLOCK
  - Added documentation for all new vCPU attributes
  - Added documentation for suggested algorithm to migrate a guest's
    TSC(s)
  - Bug fixes throughout series
  - Rename KVM_CLOCK_REAL_TIME -> KVM_CLOCK_REALTIME

v3 -> v4:
  - Added patch to address incorrect device helper assertions (Drew)
  - Carried Drew's r-b tags where appropriate
  - x86 selftest cleanup
  - Removed stale kvm_timer_init_vhe() function
  - Removed unnecessary GUEST_DONE() from selftests

v1: https://lore.kernel.org/kvm/20210608214742.1897483-1-oupton@google.com/
v2: https://lore.kernel.org/r/20210716212629.2232756-1-oupton@google.com
v3: https://lore/kernel.org/r/20210719184949.1385910-1-oupton@google.com

Oliver Upton (13):
  KVM: x86: Report host tsc and realtime values in KVM_GET_CLOCK
  KVM: x86: Refactor tsc synchronization code
  KVM: x86: Expose TSC offset controls to userspace
  tools: arch: x86: pull in pvclock headers
  selftests: KVM: Add test for KVM_{GET,SET}_CLOCK
  selftests: KVM: Fix kvm device helper ioctl assertions
  selftests: KVM: Add helpers for vCPU device attributes
  selftests: KVM: Introduce system counter offset test
  KVM: arm64: Allow userspace to configure a vCPU's virtual offset
  selftests: KVM: Add support for aarch64 to system_counter_offset_test
  KVM: arm64: Provide userspace access to the physical counter offset
  selftests: KVM: Test physical counter offsetting
  selftests: KVM: Add counter emulation benchmark

 Documentation/virt/kvm/api.rst                |  42 +-
 Documentation/virt/kvm/devices/vcpu.rst       | 101 +++++
 Documentation/virt/kvm/locking.rst            |  11 +
 arch/arm64/include/asm/kvm_host.h             |   1 +
 arch/arm64/include/asm/kvm_hyp.h              |   2 -
 arch/arm64/include/asm/sysreg.h               |   1 +
 arch/arm64/include/uapi/asm/kvm.h             |   2 +
 arch/arm64/kvm/arch_timer.c                   | 140 ++++--
 arch/arm64/kvm/arm.c                          |   4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  23 +
 arch/arm64/kvm/hyp/include/hyp/timer-sr.h     |  26 ++
 arch/arm64/kvm/hyp/nvhe/switch.c              |   2 -
 arch/arm64/kvm/hyp/nvhe/timer-sr.c            |  21 +-
 arch/arm64/kvm/hyp/vhe/timer-sr.c             |  27 ++
 arch/x86/include/asm/kvm_host.h               |   4 +
 arch/x86/include/uapi/asm/kvm.h               |   4 +
 arch/x86/kvm/x86.c                            | 422 ++++++++++++++----
 include/kvm/arm_arch_timer.h                  |   2 -
 include/uapi/linux/kvm.h                      |   7 +-
 tools/arch/x86/include/asm/pvclock-abi.h      |  48 ++
 tools/arch/x86/include/asm/pvclock.h          | 103 +++++
 tools/testing/selftests/kvm/.gitignore        |   3 +
 tools/testing/selftests/kvm/Makefile          |   4 +
 .../kvm/aarch64/counter_emulation_benchmark.c | 215 +++++++++
 .../selftests/kvm/include/aarch64/processor.h |  24 +
 .../testing/selftests/kvm/include/kvm_util.h  |  11 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  44 +-
 .../kvm/system_counter_offset_test.c          | 206 +++++++++
 .../selftests/kvm/x86_64/kvm_clock_test.c     | 206 +++++++++
 29 files changed, 1548 insertions(+), 158 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/timer-sr.h
 create mode 100644 tools/arch/x86/include/asm/pvclock-abi.h
 create mode 100644 tools/arch/x86/include/asm/pvclock.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
 create mode 100644 tools/testing/selftests/kvm/system_counter_offset_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_clock_test.c

-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
