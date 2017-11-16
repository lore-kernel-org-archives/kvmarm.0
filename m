From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/7] KVM/ARM fixes for 4.15-rc1
Date: Thu, 16 Nov 2017 17:58:14 +0000
Message-ID: <20171116175821.26544-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68C8F49D2A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Nov 2017 12:56:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rDQ14BYAhovw for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Nov 2017 12:56:15 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4431D406D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Nov 2017 12:56:15 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

Here's a handful of KVM/ARM fixes I've collected over the week:

- Four bugs reported by AKASHI Takahiro who ran the SMATCH static
  analyser on the KVM/ARM code. All great findings! I've split the
  fixes so that they can be backported individually.
- A nice corner case found by Kristina Martsenko on arm64 (which she
  posted separately), which  actually originated from the 32bit port
  (and I've now included a patch plugging that one as well).
- One GICv4 leftover.

I've stashed all of that on my kvm-arm64/fixes-4.15 branch.

Thanks,

	M.

Kristina Martsenko (1):
  arm64: KVM: fix VTTBR_BADDR_MASK BUG_ON off-by-one

Marc Zyngier (6):
  KVM: arm/arm64: vgic-irqfd: Fix MSI entry allocation
  KVM: arm/arm64: vgic: Preserve the revious read from the pending table
  KVM: arm/arm64: vgic-its: Preserve the revious read from the pending
    table
  KVM: arm/arm64: vgic-its: Check result of allocation before use
  KVM: arm/arm64: vgic-v4: Only perform an unmap for valid vLPIs
  arm: KVM: Fix VTTBR_BADDR_MASK BUG_ON off-by-one

 arch/arm/include/asm/kvm_arm.h   | 3 +--
 arch/arm64/include/asm/kvm_arm.h | 3 +--
 virt/kvm/arm/vgic/vgic-irqfd.c   | 3 +--
 virt/kvm/arm/vgic/vgic-its.c     | 4 +++-
 virt/kvm/arm/vgic/vgic-v3.c      | 2 +-
 virt/kvm/arm/vgic/vgic-v4.c      | 6 ++++--
 6 files changed, 11 insertions(+), 10 deletions(-)

-- 
2.14.2
