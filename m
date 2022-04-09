Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A37EC433FE
	for <kvmarm@archiver.kernel.org>; Sat,  9 Apr 2022 18:46:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65CA54B187;
	Sat,  9 Apr 2022 14:46:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VU2OrWVe9XCL; Sat,  9 Apr 2022 14:46:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 190774B133;
	Sat,  9 Apr 2022 14:46:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B75654B0EF
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rl19uZ2hrEvw for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Apr 2022 14:46:00 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F25A49E44
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:00 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 f18-20020a926a12000000b002be48b02bc6so7619833ilc.17
 for <kvmarm@lists.cs.columbia.edu>; Sat, 09 Apr 2022 11:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=2O5CotoUSOZWSX+DgcMySzP79UQI3Nfk4A4+f0zgD3M=;
 b=N2gl4ry2kPPGTCsnaLq6meOWeqG1zyBXus/SEfje763OmvLx9jreiUAkx5s+8PK4Mz
 ZuXbkfDPs0z8aQGkLgf1T0IB1mUhd2e8Aa1C3M5CO73Q8XULWv3oxi2VWSoUwEvSSex1
 u3zPwuyYKKJeAiWFqrrQsHDZjJ2n1jWIHDTk0ZkCImGf4SUeO5cEDeEZGAxNV1CoTnWl
 nu7nG+DerlFXD3OWn+eVyIC4pIeTACRdFQ1wxKidxA9Rag/q0F9Su8PVyFYIdn+YtoMD
 izxesDdaoRjOfMdcYrZqHHG/7aOO0XsLP9XUKvkhwD7ANibxESAXvpFliZXXz9mPgHWT
 cb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=2O5CotoUSOZWSX+DgcMySzP79UQI3Nfk4A4+f0zgD3M=;
 b=MoK/nFkFGk2k6jx1bjZJsL/iKKY8qoLB4Ta2820sY1odObcEV2BY9ciObUDFPiY+GI
 sWINeCa+MkJex0A+7V1AkVFErMiFbtntHVhD2xICSnl75Z4t9bD3N4JJWRg4j1m+HDIK
 e+AbhgGg+GuR7G3utXHlab0gpi1K9oBMbjvPl28CPiQAjPWCEh8xbaMpPafZtiRL6aVT
 ft9KBvezJJS8GOyo01EiZoJ0C2HSaHcGQjLxx3MKT8I1GjVFxBCbXd82mvmk25i8nh5m
 WO7Rjyc2zwkR2PQjbYoihNQPhi2o4kvxgoVadZOJHkDzZZ1N2txqOX9AyjzlcwwvA1L+
 tMSQ==
X-Gm-Message-State: AOAM532LtADMwpy3NS31eZ8DaDoR2Lt1C3eZczQpxhSQZOZWQYQXIK4H
 10o5g+EBiZEYdFUylKVm9MrNj7VBjFE+NR5ulJZTyhC5T/yGwTdP6H0qIrZAgiDMpsIuMb1+qnA
 385XkJRXo4sH5pOuSAiK9lnMOusmRVsPlZn2+ls6+QO+dRvbMsLQxh+Lwtw+oo88unl0I5w==
X-Google-Smtp-Source: ABdhPJx7mmaiQYRNM78+N4In0mzcOq8mhVFldJrAmdB4tW4+VGr/cmbClLZZLQuRs4be4V33PypTBrX6vFw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:38a3:b0:326:24b9:e196
 with SMTP id
 b35-20020a05663838a300b0032624b9e196mr635674jav.255.1649529959542; Sat, 09
 Apr 2022 11:45:59 -0700 (PDT)
Date: Sat,  9 Apr 2022 18:45:36 +0000
Message-Id: <20220409184549.1681189-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 00/13] KVM: arm64: PSCI SYSTEM_SUSPEND support
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
 pshier@google.com, kvm-riscv@lists.infradead.org, atishp@atishpatra.org,
 pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com
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
possible power state and await a wakeup event. This call is optional
in v1.0 and v1.1. KVM does not currently support this optional call.

This series adds support for the PSCI SYSTEM_SUSPEND call to KVM/arm64.
For reasons best described in patch 8, it is infeasible to correctly
implement PSCI SYSTEM_SUSPEND (or any system-wide event for that matter)
in a split design between kernel/userspace. As such, this series cheaply
exits to userspace so it can decide what to do with the call. This
series also gives userspace some help to emulate suspension with a new
MP state that awaits an unmasked pending interrupt.

Patches 1-6 are small reworks to more easily shoehorn the new features
into the kernel.

Patch 7 stands up the new suspend MP state, allowing userspace to
emulate the PSCI call.

Patch 8 actually allows userspace to enable the PSCI call, which
requires explicit opt-in for the new KVM_EXIT_SYSTEM_EVENT type.

Patches 9-12 clean up the way PSCI is tested in selftests to more easily
add new test cases.

Finally, the last patch actually tests that PSCI SYSTEM_SUSPEND calls
within the guest result in userspace exits.

Applies cleanly to kvmarm/fixes, at the following commit:

  21db83846683 ("selftests: KVM: Free the GIC FD when cleaning up in arch_timer")

This is because there's some patches on the fixes branch that would
cause conflicts with this series otherwise.

Tested with the included selftest and a hacked up kvmtool [1] with support
for the new UAPI.

[1]: https://lore.kernel.org/all/20220311175717.616958-1-oupton@google.com/

v4: http://lore.kernel.org/r/20220311174001.605719-1-oupton@google.com

v4 -> v5:
 - Rebase to kvmarm/fixes (5.18-rc1 + a bit more)
 - Rework system event helper around RISC-V SBI changes (Anup)
 - Don't presume a vCPU has been woken up when it returns from
   kvm_vcpu_wfi(), as there are other situations where the vCPU thread
   unblocks, such as signals. (Reiji)
 - Tighten up comments/docs (Reiji)

Oliver Upton (13):
  KVM: arm64: Don't depend on fallthrough to hide SYSTEM_RESET2
  KVM: arm64: Dedupe vCPU power off helpers
  KVM: arm64: Track vCPU power state using MP state values
  KVM: arm64: Rename the KVM_REQ_SLEEP handler
  KVM: Create helper for setting a system event exit
  KVM: arm64: Return a value from check_vcpu_requests()
  KVM: arm64: Add support for userspace to suspend a vCPU
  KVM: arm64: Implement PSCI SYSTEM_SUSPEND
  selftests: KVM: Rename psci_cpu_on_test to psci_test
  selftests: KVM: Create helper for making SMCCC calls
  selftests: KVM: Use KVM_SET_MP_STATE to power off vCPU in psci_test
  selftests: KVM: Refactor psci_test to make it amenable to new tests
  selftests: KVM: Test SYSTEM_SUSPEND PSCI call

 Documentation/virt/kvm/api.rst                |  76 ++++++-
 arch/arm64/include/asm/kvm_host.h             |  11 +-
 arch/arm64/kvm/arm.c                          | 107 +++++++--
 arch/arm64/kvm/psci.c                         |  66 +++---
 arch/riscv/kvm/vcpu_sbi.c                     |   5 +-
 arch/x86/kvm/x86.c                            |   6 +-
 include/linux/kvm_host.h                      |   2 +
 include/uapi/linux/kvm.h                      |   4 +
 tools/testing/selftests/kvm/.gitignore        |   2 +-
 tools/testing/selftests/kvm/Makefile          |   2 +-
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  | 121 ----------
 .../testing/selftests/kvm/aarch64/psci_test.c | 213 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  22 ++
 .../selftests/kvm/lib/aarch64/processor.c     |  25 ++
 tools/testing/selftests/kvm/steal_time.c      |  13 +-
 virt/kvm/kvm_main.c                           |   8 +
 16 files changed, 493 insertions(+), 190 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/psci_test.c

-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
