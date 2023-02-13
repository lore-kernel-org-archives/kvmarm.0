Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDDDA945
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 18:02:40 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id r17-20020a258291000000b008ee1c76c25dso10047971ybk.11
        for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 10:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BpleHRiVR4EUSpy/SWqcPhyAa33jUi6Ury6G4Iecv4I=;
        b=Xf3x5NE/w0sBajJO3lIF+XcSeulIsiq+JSti1HsFZcXt9W4UF2WVlmRhqxG/gZ4UM4
         qns1ntOHn+JM4vvit1JNLjZFCpZ7ThpyP3LXL8gzx7Kg+Leg+He8VDFKIbzRj9cEcZgn
         EPTe5LF1kSPWeNQwzNcJcO5xluJtBkeK4mK+OsCgcYA707gAIflOAip21tDSOCd9Erk8
         7du3jqOVX4IHd2gsXAmzSDU+nxexaMDkt3fquTHsOhl7GEQYk0n3TIa7Wez9A/mmG8+J
         Gj3XOcBCsyWC17uTlFOP9fU8qfipyYTust95sZiU/T6lYjT1tc9AKLDaN94w6cjZVa43
         J8vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BpleHRiVR4EUSpy/SWqcPhyAa33jUi6Ury6G4Iecv4I=;
        b=Xh5XBViMmBpm4dOgh30P6shRmS8ladALT8p8U98pE4ql1qvOO0sano9WAkm7rNmWUs
         U5UtDH/8SAcTlV0J3m71tXt8RB2MuP2GB2TbXG7W4vM/xk+zDfhGwI1ig4uIz85Ikn8y
         sUOJAFsllkkpT7F2xHIh8i5gLuqMVMcLCNCzJOJnEXlYB0rJPcbIBy1daZoT/UY3SNBK
         GtqTQuvo/kmTV0xCYo4CHaJCzddUXLJs5auyoJdYRgVyxEYGs/JiTVEXxUm1sQfwSRjB
         obwNBfFX+6dFNy7D2cFJtOqKxljfuXv7WUNBn0b6tiabmdBLTxo9LzJIOBN+cIu9V71p
         oA9w==
X-Gm-Message-State: AO0yUKVx2DhDT92IEL3S6S+OOamCqsNqL/82E/mUR/L6ZpS9cMtrNyam
	bj4/Q6d9Dqv+NuCVOC/dQQ0YT6riOXUP
X-Google-Smtp-Source: AK7set/E/zEcaIXNhXkditxiEul+rHVKptXA3M+YkUOhAM/c0OQ93NwxXrM31UBY8F1i9LkGUIOld31yR0Y0
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:6d91:0:b0:52e:b80e:f0a9 with SMTP id
 i139-20020a816d91000000b0052eb80ef0a9mr16ywc.10.1676311359266; Mon, 13 Feb
 2023 10:02:39 -0800 (PST)
Date: Mon, 13 Feb 2023 18:02:21 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230213180234.2885032-1-rananta@google.com>
Subject: [PATCH 00/13] Extend the vPMU selftest
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oupton@google.com>, Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

This vPMU KVM selftest series is an extension to the selftests
introduced by Reiji Watanabe in his series aims to limit the number
of PMCs on vCPU from userspace [1].

The idea behind this series is to expand the test coverage to include
the tests that validates actions from userspace, such as allowing or
denying certain events via KVM_ARM_VCPU_PMU_V3_FILTER attribute, KVM's
guarding of the PMU attributes to count EL2/EL3 events, and formal KVM
behavior that enables PMU emulation. The last part validates the guest
expectations of the vPMU by setting up a stress test that force-migrates
multiple vCPUs frequently across random pCPUs in the system, thus
ensuring KVM's management of vCPU PMU contexts correctly.

Patch-1 renames the test file to be more generic.

Patch-2 refactors the existing tests for plugging-in the upcoming tests
easily.

Patch-3 and 4 add helper macros and functions respectively to interact
with the cycle counter.

Patch-5 extends create_vpmu_vm() to accept an array of event filters
as an argument that are to be applied to the VM.

Patch-6 tests the KVM_ARM_VCPU_PMU_V3_FILTER attribute by scripting
various combinations of events that are to be allowed or denied to
the guest and verifying guest's behavior.

Patch-7 adds test to validate KVM's handling of guest requests to count
events in EL2/EL3.

Patch-8 introduces the vCPU migration stress testing by validating cycle
counter and general purpose counter's behavior across vCPU migrations.

Patch-9, 10, and 11 expands the tests in patch-8 to validate
overflow/IRQ functionality, chained events, and occupancy of all the PMU
counters, respectively.

Patch-12 extends create_vpmu_vm() to create multiple vCPUs for the VM.

Patch-13 expands the stress tests for multiple vCPUs.

The series has been tested on hardwares with PMUv8p1 and PMUvp5.

Thank you.
Raghavendra

[1]: https://lore.kernel.org/all/20230203040242.1792453-1-reijiw@google.com/


Raghavendra Rao Ananta (13):
  selftests: KVM: aarch64: Rename vpmu_counter_access.c to vpmu_test.c
  selftests: KVM: aarch64: Refactor the vPMU counter access tests
  tools: arm64: perf_event: Define Cycle counter enable/overflow bits
  selftests: KVM: aarch64: Add PMU cycle counter helpers
  selftests: KVM: aarch64: Consider PMU event filters for VM creation
  selftests: KVM: aarch64: Add KVM PMU event filter test
  selftests: KVM: aarch64: Add KVM EVTYPE filter PMU test
  selftests: KVM: aarch64: Add vCPU migration test for PMU
  selftests: KVM: aarch64: Test PMU overflow/IRQ functionality
  selftests: KVM: aarch64: Test chained events for PMU
  selftests: KVM: aarch64: Add PMU test to chain all the counters
  selftests: KVM: aarch64: Add multi-vCPU support for vPMU VM creation
  selftests: KVM: aarch64: Extend the vCPU migration test to multi-vCPUs

 tools/arch/arm64/include/asm/perf_event.h     |    7 +
 tools/testing/selftests/kvm/Makefile          |    2 +-
 .../kvm/aarch64/vpmu_counter_access.c         |  642 -------
 .../testing/selftests/kvm/aarch64/vpmu_test.c | 1710 +++++++++++++++++
 4 files changed, 1718 insertions(+), 643 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_test.c

-- 
2.39.1.581.gbfd45094c4-goog

