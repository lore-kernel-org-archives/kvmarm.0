Return-Path: <SRS0=tvNx=YR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F897CA9EBC
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 23:07:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D41EC222BE
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 23:07:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D41EC222BE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C7C14A981;
	Thu, 24 Oct 2019 19:07:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ft-xl4CoeuEg; Thu, 24 Oct 2019 19:07:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 106D54A873;
	Thu, 24 Oct 2019 19:07:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0412C4A81D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 19:07:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yH-kzctXieZt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Oct 2019 19:07:48 -0400 (EDT)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D99C4A53F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 19:07:48 -0400 (EDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
 by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 24 Oct 2019 16:07:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,226,1569308400"; d="scan'208";a="202445828"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
 by orsmga006.jf.intel.com with ESMTP; 24 Oct 2019 16:07:45 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: James Hogan <jhogan@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v3 00/15] KVM: Dynamically size memslot arrays
Date: Thu, 24 Oct 2019 16:07:29 -0700
Message-Id: <20191024230744.14543-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Cc: linux-arm-kernel@lists.infradead.org, Wanpeng Li <wanpengli@tencent.com>,
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
e.g. are essentially contained in patches 14/15 and 15/15.  Patches 1-13
clean up the memslot code, which has gotten quite crusty, especially
__kvm_set_memory_region().  The clean up is likely not strictly necessary
to switch to dynamic sizing, but I didn't have a remotely reasonable
level of confidence in the correctness of the dynamic sizing without first
doing the clean up.

Christoffer, I added your Tested-by to the patches that I was confident
would be fully tested based on the desription of what you tested.  Let me
know if you disagree with any of 'em.

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


Sean Christopherson (15):
  KVM: Reinstall old memslots if arch preparation fails
  KVM: Don't free new memslot if allocation of said memslot fails
  KVM: PPC: Move memslot memory allocation into prepare_memory_region()
  KVM: x86: Allocate memslot resources during prepare_memory_region()
  KVM: Drop kvm_arch_create_memslot()
  KVM: Explicitly free allocated-but-unused dirty bitmap
  KVM: Refactor error handling for setting memory region
  KVM: Move setting of memslot into helper routine
  KVM: Move memslot deletion to helper function
  KVM: Simplify kvm_free_memslot() and all its descendents
  KVM: Clean up local variable usage in __kvm_set_memory_region()
  KVM: Provide common implementation for generic dirty log functions
  KVM: Ensure validity of memslot with respect to kvm_get_dirty_log()
  KVM: Terminate memslot walks via used_slots
  KVM: Dynamically size memslot array based on number of used slots

 arch/mips/include/asm/kvm_host.h      |   2 +-
 arch/mips/kvm/mips.c                  |  69 +--
 arch/powerpc/include/asm/kvm_ppc.h    |  17 +-
 arch/powerpc/kvm/book3s.c             |  22 +-
 arch/powerpc/kvm/book3s_hv.c          |  36 +-
 arch/powerpc/kvm/book3s_pr.c          |  20 +-
 arch/powerpc/kvm/booke.c              |  17 +-
 arch/powerpc/kvm/powerpc.c            |  13 +-
 arch/s390/include/asm/kvm_host.h      |   2 +-
 arch/s390/kvm/kvm-s390.c              |  21 +-
 arch/x86/include/asm/kvm_page_track.h |   3 +-
 arch/x86/kvm/page_track.c             |  15 +-
 arch/x86/kvm/x86.c                    | 101 +----
 include/linux/kvm_host.h              |  46 +-
 virt/kvm/arm/arm.c                    |  48 +-
 virt/kvm/arm/mmu.c                    |  18 +-
 virt/kvm/kvm_main.c                   | 621 +++++++++++++++++---------
 17 files changed, 542 insertions(+), 529 deletions(-)

-- 
2.22.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
