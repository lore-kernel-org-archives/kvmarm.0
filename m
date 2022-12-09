Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76EA2C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 01:53:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5D464B9DC;
	Thu,  8 Dec 2022 20:53:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u3xquzMquSbQ; Thu,  8 Dec 2022 20:53:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5F8E4B9E1;
	Thu,  8 Dec 2022 20:53:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20D074B9CF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 20:53:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r6imYviBQsnk for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 20:53:25 -0500 (EST)
Received: from out-57.mta0.migadu.com (out-57.mta0.migadu.com [91.218.175.57])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB99E4B9C0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 20:53:25 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v2 0/7] KVM: selftests: Fixes for ucall pool + page_fault_test
Date: Fri,  9 Dec 2022 01:52:59 +0000
Message-Id: <20221209015307.1781352-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

The combination of the pool-based ucall implementation + page_fault_test
resulted in some 'fun' bugs. As has always been the case, KVM selftests
is a house of cards.

Small series to fix up the issues on kvm/queue. Patches 1-2 can probably
be squashed into Paolo's merge resolution, if desired.

Tested on Ampere Altra and a Skylake box, since there was a decent
amount of munging in architecture-generic code.

v1 -> v2:
 - Collect R-b from Sean (thanks!)
 - Use a common routine for split and contiguous VA spaces, with
   commentary on why arm64 is different since we all get to look at it
   now. (Sean)
 - Don't identity map the ucall MMIO hole
 - Fix an off-by-one issue in the accounting of virtual memory,
   discovered in fighting with #2
 - Fix an infinite loop in ucall_alloc(), discovered fighting with the
   ucall_init() v. kvm_vm_elf_load() ordering issue

Mark Brown (1):
  KVM: selftests: Fix build due to ucall_uninit() removal

Oliver Upton (6):
  KVM: selftests: Setup ucall after loading program into guest memory
  KVM: selftests: Mark correct page as mapped in virt_map()
  KVM: selftests: Correctly initialize the VA space for TTBR0_EL1
  KVM: arm64: selftests: Don't identity map the ucall MMIO hole
  KVM: selftests: Allocate ucall pool from MEM_REGION_DATA
  KVM: selftests: Avoid infinite loop if ucall_alloc() fails

 .../selftests/kvm/aarch64/page_fault_test.c   |  9 +++-
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 .../testing/selftests/kvm/lib/aarch64/ucall.c |  6 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 53 ++++++++++++++++---
 .../testing/selftests/kvm/lib/ucall_common.c  | 14 +++--
 5 files changed, 68 insertions(+), 15 deletions(-)


base-commit: 89b2395859651113375101bb07cd6340b1ba3637
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
