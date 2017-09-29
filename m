From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 0/5] kvm_arch_vcpu_runnable related improvements
Date: Fri, 29 Sep 2017 13:30:36 +0200
Message-ID: <20170929113041.24371-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8716C49C2F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Sep 2017 07:30:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yd38I2Uqljmy for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Sep 2017 07:30:34 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F52840651
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Sep 2017 07:30:34 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, cdall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Only patch 5/5 fixes anything, and that's just a theoretical bug,
but, IMHO, this series future-proofs and improves the maintainability
of the code. See https://www.spinics.net/lists/kvm-arm/msg27254.html
for a TL;DR analysis that led to this series.

Thanks,
drew


Andrew Jones (5):
  KVM: arm/arm64: tidy 'should sleep' conditions
  KVM: arm/arm64: replace power_off with mp_state=STOPPED
  KVM: arm/arm64: factor out common wfe/wfi emulation code
  KVM: arm/arm64: improve kvm_arch_vcpu_runnable
  KVM: arm/arm64: kvm_arch_vcpu_runnable: don't miss injected irqs

 Documentation/virtual/kvm/api.txt | 10 +++---
 arch/arm/include/asm/kvm_host.h   |  8 +++--
 arch/arm/kvm/handle_exit.c        | 14 +++------
 arch/arm64/include/asm/kvm_host.h |  8 +++--
 arch/arm64/kvm/handle_exit.c      | 14 +++------
 virt/kvm/arm/arm.c                | 64 +++++++++++++++++++++++++++------------
 virt/kvm/arm/psci.c               | 32 ++++++++------------
 7 files changed, 84 insertions(+), 66 deletions(-)

-- 
2.13.5
