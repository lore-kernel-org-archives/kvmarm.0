From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH 0/3] KVM: arm64: BUG FIX: Correctly handle zero register
 transfers
Date: Thu, 03 Dec 2015 12:58:39 +0300
Message-ID: <cover.1449136209.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57B3B4999F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 04:57:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zU1EOS6gbnvI for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2015 04:57:17 -0500 (EST)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73EC349973
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 04:57:16 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYS00BH811YMP00@mailout2.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 03 Dec 2015 09:58:46 +0000 (GMT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

ARM64 CPU has zero register which is read-only, with a value of 0.
However, KVM currently incorrectly recognizes it being SP (because
Rt == 31, and in struct user_pt_regs 'regs' array is followed by SP),
resulting in invalid value being read, or even SP corruption on write.

The problem has been discovered by performing an operation

 *((volatile int *)reg) = 0;

which compiles as "str xzr, [xx]", and resulted in strange values being
written.

Pavel Fedin (3):
  KVM: arm64: Correctly handle zero register during MMIO
  KVM: arm64: Correctly handle zero register in system register accesses
  KVM: arm64: Get rid of old vcpu_reg()

 arch/arm/include/asm/kvm_emulate.h   | 12 ++++++
 arch/arm/kvm/mmio.c                  |  5 ++-
 arch/arm/kvm/psci.c                  | 20 ++++-----
 arch/arm64/include/asm/kvm_emulate.h | 18 +++++---
 arch/arm64/kvm/handle_exit.c         |  2 +-
 arch/arm64/kvm/sys_regs.c            | 79 ++++++++++++++++++++----------------
 arch/arm64/kvm/sys_regs.h            |  4 +-
 arch/arm64/kvm/sys_regs_generic_v8.c |  2 +-
 8 files changed, 85 insertions(+), 57 deletions(-)

-- 
2.4.4
