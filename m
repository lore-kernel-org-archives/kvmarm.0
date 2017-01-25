From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/3] Fix cache flushing when mapping at stage-2
Date: Wed, 25 Jan 2017 15:36:28 +0000
Message-ID: <1485358591-12278-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DB01405DA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jan 2017 10:36:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h0jxA2T5LRhk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jan 2017 10:36:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4498240064
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jan 2017 10:36:28 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When we fault in a page, we flush it to the PoC (Point of Coherency)
if the faulting vcpu has its own caches off, so that it can observe
the page we just brought it.
    
But if the vcpu has its caches on, we skip that step. Bad things
happen when *another* vcpu tries to access that page with its own
caches disabled. At that point, there is no garantee that the data has
made it to the PoC, and we access stale data.
    
The obvious fix is to always flush to PoC when a page is faulted in,
no matter what the state of the vcpu is.

This leads to additional cleanups, removing the code that was forcing
read-only memslots to be flushed to PoC as well (since the flushing is
now unconditional). Only the first patch is critical, and deserves a
Cc to stable.

Marc Zyngier (3):
  arm/arm64: KVM: Enforce unconditional flush to PoC when mapping to
    stage-2
  arm/arm64: KVM: Stop propagating cacheability status of a faulted page
  arm/arm64: KVM: Get rid of KVM_MEMSLOT_INCOHERENT

 arch/arm/include/asm/kvm_mmu.h   | 12 ++----------
 arch/arm/kvm/mmu.c               | 20 ++++----------------
 arch/arm64/include/asm/kvm_mmu.h |  6 ++----
 include/linux/kvm_host.h         |  1 -
 4 files changed, 8 insertions(+), 31 deletions(-)

-- 
2.1.4
