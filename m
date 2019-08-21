Return-Path: <SRS0=ht6V=WR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88013C3A59E
	for <kvmarm@archiver.kernel.org>; Wed, 21 Aug 2019 15:37:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1F46A2339E
	for <kvmarm@archiver.kernel.org>; Wed, 21 Aug 2019 15:37:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F46A2339E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F7674A5C1;
	Wed, 21 Aug 2019 11:37:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uKYYAeIi3x3p; Wed, 21 Aug 2019 11:37:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BE474A5AA;
	Wed, 21 Aug 2019 11:37:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB0B24A574
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Aug 2019 11:37:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7rL2MEWiXLgR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Aug 2019 11:37:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A28D4A529
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Aug 2019 11:37:13 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C3FB337;
 Wed, 21 Aug 2019 08:37:13 -0700 (PDT)
Received: from e112269-lin.arm.com (e112269-lin.cambridge.arm.com
 [10.1.196.133])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 609123F718;
 Wed, 21 Aug 2019 08:37:11 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 00/10] arm64: Stolen time support
Date: Wed, 21 Aug 2019 16:36:46 +0100
Message-Id: <20190821153656.33429-1-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, linux-doc@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, Steven Price <steven.price@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
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

This series add support for paravirtualized time for arm64 guests and
KVM hosts following the specification in Arm's document DEN 0057A:

https://developer.arm.com/docs/den0057/a

It implements support for stolen time, allowing the guest to
identify time when it is forcibly not executing.

It doesn't implement support for Live Physical Time (LPT) as there are
some concerns about the overheads and approach in the above
specification, and I expect an updated version of the specification to
be released soon with just the stolen time parts.

NOTE: Patches 8 and 9 will conflict with Mark Rutland's series[1] cleaning
up the SMCCC conduit. I do feel that the addition of an _invoke() call
makes a number of call sites cleaner and it should be possible to
integrate both this and Mark's other cleanups.

[1] https://lore.kernel.org/linux-arm-kernel/20190809132245.43505-1-mark.rutland@arm.com/

Also available as a git tree:
git://linux-arm.org/linux-sp.git stolen_time/v3

Changes from v2:
https://lore.kernel.org/lkml/20190819140436.12207-1-steven.price@arm.com/
 * Switched from using gfn_to_hva_cache to a new macro kvm_put_guest()
   that can provide the single-copy atomicity required (on arm64). This
   macro is added in patch 4.
 * Tidied up the locking for kvm_update_stolen_time().
   pagefault_disable() was unnecessary and the caller didn't need to
   take kvm->srcu as the function does it itself.
 * Removed struct kvm_arch_pvtime from the arm implementation, replaced
   instead with inline static functions which are empty for arm.
 * Fixed a few checkpatch --strict warnings.

Changes from v1:
https://lore.kernel.org/lkml/20190802145017.42543-1-steven.price@arm.com/
 * Host kernel no longer allocates the stolen time structure, instead it
   is allocated by user space. This means the save/restore functionality
   can be removed.
 * Refactored the code so arm has stub implementations and to avoid
   initcall
 * Rebased to pick up Documentation/{virt->virtual} change
 * Bunch of typo fixes

Christoffer Dall (1):
  KVM: arm/arm64: Factor out hypercall handling from PSCI code

Steven Price (9):
  KVM: arm64: Document PV-time interface
  KVM: arm64: Implement PV_FEATURES call
  KVM: Implement kvm_put_guest()
  KVM: arm64: Support stolen time reporting via shared structure
  KVM: Allow kvm_device_ops to be const
  KVM: arm64: Provide a PV_TIME device to user space
  arm/arm64: Provide a wrapper for SMCCC 1.1 calls
  arm/arm64: Make use of the SMCCC 1.1 wrapper
  arm64: Retrieve stolen time as paravirtualized guest

 Documentation/virt/kvm/arm/pvtime.txt | 100 ++++++++++++++
 arch/arm/include/asm/kvm_host.h       |  30 +++++
 arch/arm/kvm/Makefile                 |   2 +-
 arch/arm/kvm/handle_exit.c            |   2 +-
 arch/arm/mm/proc-v7-bugs.c            |  13 +-
 arch/arm64/include/asm/kvm_host.h     |  28 +++-
 arch/arm64/include/asm/paravirt.h     |   9 +-
 arch/arm64/include/asm/pvclock-abi.h  |  17 +++
 arch/arm64/include/uapi/asm/kvm.h     |   8 ++
 arch/arm64/kernel/cpu_errata.c        |  80 ++++-------
 arch/arm64/kernel/paravirt.c          | 148 +++++++++++++++++++++
 arch/arm64/kernel/time.c              |   3 +
 arch/arm64/kvm/Kconfig                |   1 +
 arch/arm64/kvm/Makefile               |   2 +
 arch/arm64/kvm/handle_exit.c          |   4 +-
 include/kvm/arm_hypercalls.h          |  43 ++++++
 include/kvm/arm_psci.h                |   2 +-
 include/linux/arm-smccc.h             |  58 ++++++++
 include/linux/cpuhotplug.h            |   1 +
 include/linux/kvm_host.h              |  28 +++-
 include/linux/kvm_types.h             |   2 +
 include/uapi/linux/kvm.h              |   2 +
 virt/kvm/arm/arm.c                    |  11 ++
 virt/kvm/arm/hypercalls.c             |  68 ++++++++++
 virt/kvm/arm/psci.c                   |  84 +-----------
 virt/kvm/arm/pvtime.c                 | 182 ++++++++++++++++++++++++++
 virt/kvm/kvm_main.c                   |   6 +-
 27 files changed, 780 insertions(+), 154 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/pvtime.txt
 create mode 100644 arch/arm64/include/asm/pvclock-abi.h
 create mode 100644 include/kvm/arm_hypercalls.h
 create mode 100644 virt/kvm/arm/hypercalls.c
 create mode 100644 virt/kvm/arm/pvtime.c

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
