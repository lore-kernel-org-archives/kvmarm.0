From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/3] arm64: KVM: High memory guest fixes
Date: Wed, 25 Feb 2015 16:55:37 +0000
Message-ID: <1424883340-29940-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E881A4692C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Feb 2015 11:50:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pLhA0cM1yaVo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Feb 2015 11:50:13 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D82504691E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Feb 2015 11:50:13 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.com>
List-Id: kvmarm@lists.cs.columbia.edu

I've been playing with a hacked-up kvmtool that places the memory much
higher than usual, in an effort to emulate what some arm64 platforms
do (typically AMD Seattle).

Unexpectedly (hey, what could possibly go wrong...), I've discovered a
couple of mm related issues, ranging from the host exploding to the
guest being stuck on a page fault. Additionally, I noticed a minor
documentation issue.

With these fixes in, I'm able to run a guest that has its memory
located just under the 40bit limit.

Marc Zyngier (3):
  arm64: KVM: Fix stage-2 PGD allocation to have per-page refcounting
  arm64: KVM: Do not use pgd_index to index stage-2 pgd
  arm64: KVM: Fix outdated comment about VTCR_EL2.PS

 arch/arm/include/asm/kvm_mmu.h   | 10 +++++++++-
 arch/arm/kvm/mmu.c               | 10 +++++-----
 arch/arm64/include/asm/kvm_arm.h |  5 +++--
 arch/arm64/include/asm/kvm_mmu.h | 11 ++++++++++-
 4 files changed, 27 insertions(+), 9 deletions(-)

-- 
2.1.4
