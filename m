From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/2] KVM: arm64: Dynamic IPA cosmetic fixups
Date: Mon,  1 Oct 2018 14:06:54 +0100
Message-ID: <20181001130656.36999-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 366AC4A21B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Oct 2018 09:07:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vK-XXogX1ujS for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Oct 2018 09:07:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7BD240A6E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Oct 2018 09:07:05 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Here's a couple of tiny cleanups I'd like to queue on top of Suzuki's
series. They are purely cosmetic, and just aim at making the code
slightly more readable.

If nobody shouts, I'll stack them on top.

Thanks,

	M.

Marc Zyngier (2):
  KVM: arm/arm64: Rename kvm_arm_config_vm to kvm_arm_setup_stage2
  KVM: arm64: Drop __cpu_init_stage2 on the VHE path

 arch/arm/include/asm/kvm_host.h   |  6 +++++-
 arch/arm64/include/asm/kvm_arm.h  |  2 +-
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/reset.c            |  2 +-
 virt/kvm/arm/arm.c                | 12 +++---------
 5 files changed, 11 insertions(+), 13 deletions(-)

-- 
2.19.0
