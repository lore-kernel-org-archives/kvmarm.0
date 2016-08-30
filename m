From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 0/2] arm{,64}/kvm: excise redundant cache maintenance
Date: Tue, 30 Aug 2016 17:05:54 +0100
Message-ID: <1472573156-30414-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6056F49B1A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 11:58:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uGwRu2A7rn2H for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2016 11:58:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33C2840FA2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 11:58:07 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

As noted in a jailhouse thread a short while ago [1,2], the presence of the
virtualization extensions implies that page table walks are coherent, and do
not require that updates are cleaned to the PoU.

These patches remove the redundant maintenance and related infrastructure.

As I do not have a suitably configured ARMv7 board, I have not been able to
test the patches myself, and any testing would be appreciated.

Thanks,
Mark.

[1] https://groups.google.com/d/msg/jailhouse-dev/c9Ier7mUNoI/JWUJGyxfAQAJ
[2] https://groups.google.com/d/msg/jailhouse-dev/c9Ier7mUNoI/qagpektgAQAJ

Mark Rutland (2):
  arm/kvm: excise redundant cache maintenance
  arm64/kvm: remove unused stub functions

 arch/arm/include/asm/kvm_mmu.h   | 28 ++--------------------------
 arch/arm/kvm/mmu.c               |  2 --
 arch/arm64/include/asm/kvm_mmu.h |  6 ------
 3 files changed, 2 insertions(+), 34 deletions(-)

-- 
1.9.1
