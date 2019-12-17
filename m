Return-Path: <SRS0=Hq6c=2H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C795C2D0D1
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 20:40:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0D2422176D
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 20:40:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D2422176D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACD734AEC2;
	Tue, 17 Dec 2019 15:40:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PfJkCUqY0Q0g; Tue, 17 Dec 2019 15:40:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87C274AC7E;
	Tue, 17 Dec 2019 15:40:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 017634A800
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 15:40:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5OSyoJImz3jt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Dec 2019 15:40:44 -0500 (EST)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52C9E4A389
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 15:40:44 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
 by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 17 Dec 2019 12:40:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; d="scan'208";a="389952569"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga005.jf.intel.com with ESMTP; 17 Dec 2019 12:40:42 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: James Hogan <jhogan@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v4 00/19] KVM: Dynamically size memslot arrays
Date: Tue, 17 Dec 2019 12:40:22 -0800
Message-Id: <20191217204041.10815-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Cc: linux-arm-kernel@lists.infradead.org, Wanpeng Li <wanpengli@tencent.com>,
 =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

The end goal of this series is to dynamically size the memslot array so
that KVM allocates memory based on the number of memslots in use, as
opposed to unconditionally allocating memory for the maximum number of
memslots.  On x86, each memslot consumes 88 bytes, and so with 2 address
spaces of 512 memslots, each VM consumes ~90k bytes for the memslots.
E.g. given a VM that uses a total of 30 memslots, dynamic sizing reduces
the memory footprint from 90k to ~2.6k bytes.

The changes required to support dynamic sizing are relatively small,
e.g. are essentially contained in patches 17/19 and 18/19.

Patches 2-16 clean up the memslot code, which has gotten quite crusty,
especially __kvm_set_memory_region().  The clean up is likely not strictly
necessary to switch to dynamic sizing, but I didn't have a remotely
reasonable level of confidence in the correctness of the dynamic sizing
without first doing the clean up.

The only functional change in v4 is the addition of an x86-specific bug
fix in x86's handling of KVM_MR_MOVE.  The bug fix is not directly related
to dynamically allocating memslots, but it has subtle and hidden conflicts
with the cleanup patches, and the fix is higher priority than anything
else in the series, i.e. should be merged first.

On non-x86 architectures, v3 and v4 should be functionally equivalent,
the only non-x86 change in v4 is the dropping of a "const" in
kvm_arch_commit_memory_region().

v4:
  - Add patch 01 to fix an x86 rmap/lpage bug, and patches 10 and 11 to
    resolve hidden conflicts with the bug fix.
  - Collect tags [Christian, Marc, Philippe].
  - Rebase to kvm/queue, commit e41a90be9659 ("KVM: x86/mmu: WARN if
    root_hpa is invalid when handling a page fault").
v3:
  - Fix build errors on PPC and MIPS due to missed params during
    refactoring [kbuild test robot].
  - Rename the helpers for update_memslots() and add comments describing
    the new algorithm and how it interacts with searching [Paolo].
  - Remove the unnecessary and obnoxious warning regarding memslots being
    a flexible array [Paolo].
  - Fix typos in the changelog of patch 09/15 [Christoffer].
  - Collect tags [Christoffer].

v2:
  - Split "Drop kvm_arch_create_memslot()" into three patches to move
    minor functional changes to standalone patches [Janosch].
  - Rebase to latest kvm/queue (f0574a1cea5b, "KVM: x86: fix ...")
  - Collect an Acked-by and a Reviewed-by

Sean Christopherson (19):
  KVM: x86: Allocate new rmap and large page tracking when moving
    memslot
  KVM: Reinstall old memslots if arch preparation fails
  KVM: Don't free new memslot if allocation of said memslot fails
  KVM: PPC: Move memslot memory allocation into prepare_memory_region()
  KVM: x86: Allocate memslot resources during prepare_memory_region()
  KVM: Drop kvm_arch_create_memslot()
  KVM: Explicitly free allocated-but-unused dirty bitmap
  KVM: Refactor error handling for setting memory region
  KVM: Move setting of memslot into helper routine
  KVM: Drop "const" attribute from old memslot in commit_memory_region()
  KVM: x86: Free arrays for old memslot when moving memslot's base gfn
  KVM: Move memslot deletion to helper function
  KVM: Simplify kvm_free_memslot() and all its descendents
  KVM: Clean up local variable usage in __kvm_set_memory_region()
  KVM: Provide common implementation for generic dirty log functions
  KVM: Ensure validity of memslot with respect to kvm_get_dirty_log()
  KVM: Terminate memslot walks via used_slots
  KVM: Dynamically size memslot array based on number of used slots
  KVM: selftests: Add test for KVM_SET_USER_MEMORY_REGION

 arch/mips/include/asm/kvm_host.h              |   2 +-
 arch/mips/kvm/mips.c                          |  71 +-
 arch/powerpc/include/asm/kvm_ppc.h            |  17 +-
 arch/powerpc/kvm/book3s.c                     |  22 +-
 arch/powerpc/kvm/book3s_hv.c                  |  36 +-
 arch/powerpc/kvm/book3s_pr.c                  |  20 +-
 arch/powerpc/kvm/booke.c                      |  17 +-
 arch/powerpc/kvm/powerpc.c                    |  15 +-
 arch/s390/include/asm/kvm_host.h              |   2 +-
 arch/s390/kvm/kvm-s390.c                      |  23 +-
 arch/x86/include/asm/kvm_page_track.h         |   3 +-
 arch/x86/kvm/mmu/page_track.c                 |  15 +-
 arch/x86/kvm/x86.c                            | 114 +---
 include/linux/kvm_host.h                      |  48 +-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  30 +
 .../selftests/kvm/set_memory_region_test.c    | 142 ++++
 virt/kvm/arm/arm.c                            |  48 +-
 virt/kvm/arm/mmu.c                            |  20 +-
 virt/kvm/kvm_main.c                           | 621 ++++++++++++------
 22 files changed, 736 insertions(+), 535 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/set_memory_region_test.c

-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
