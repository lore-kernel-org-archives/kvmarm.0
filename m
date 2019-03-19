From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/2] KVM: arm/arm64: vgic-its: Guest memory access fixes
Date: Tue, 19 Mar 2019 13:30:20 +0000
Message-ID: <20190319133022.10693-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CE094A481
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 09:30:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yNwE+fgVOgfG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Mar 2019 09:30:47 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4208E4A47E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 09:30:47 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

While messing with something completely different, I managed to
trigger a number of RCU warnings, due to the lack of srcu locking
in the ITS code.

Andre partially addressed those last year[1], but there was some
more left.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2018-May/577056.html

Marc Zyngier (2):
  KVM: arm/arm64: vgic-its: Take the srcu lock when writing to guest
    memory
  KVM: arm/arm64: vgic-its: Take the srcu lock when parsing the memslots

 arch/arm/include/asm/kvm_mmu.h   | 11 +++++++++++
 arch/arm64/include/asm/kvm_mmu.h | 11 +++++++++++
 virt/kvm/arm/vgic/vgic-its.c     | 21 ++++++++++++++-------
 3 files changed, 36 insertions(+), 7 deletions(-)

-- 
2.20.1
