From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 0/5] KVM: arm/arm64: Fix VCPU power management problems
Date: Fri, 25 Jan 2019 10:46:51 +0100
Message-ID: <20190125094656.5026-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 493C54A3A6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 04:47:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 31TiO+uZbwoD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jan 2019 04:47:01 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0277A4A3A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 04:47:00 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This series fixes a number of issues:

 - When powering on and resetting VCPUs, we can be preempted in the
   middle which can lead to guest system register corruption.

 - We were missing support for PSCI ON_PENDING when multiple VCPUs try
   to turn on a target VCPU at the same time.

 - Powering off a VCPU could race with powering on the same VCPU.

 - We unnecesarily panic'ed if we found a non-initialized guest system
   register.

The main approach to fixing all these problems is by using VCPU
requests.

See the individual patches for more details.

Christoffer Dall (3):
  KVM: arm/arm64: Reset the VCPU without preemption and vcpu state
    loaded
  KVM: arm/arm64: Require VCPU threads to turn them self off
  KVM: arm/arm64: Implement PSCI ON_PENDING when turning on VCPUs

Marc Zyngier (2):
  arm/arm64: KVM: Allow a VCPU to fully reset itself
  arm/arm64: KVM: Don't panic on failure to properly reset system
    registers

 arch/arm/include/asm/kvm_host.h   | 22 ++++++++++-
 arch/arm/kvm/coproc.c             |  4 +-
 arch/arm/kvm/reset.c              | 24 ++++++++++++
 arch/arm64/include/asm/kvm_host.h | 23 ++++++++++-
 arch/arm64/kvm/reset.c            | 50 +++++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c         |  4 +-
 virt/kvm/arm/arm.c                | 40 ++++++++++++++-----
 virt/kvm/arm/psci.c               | 64 +++++++++++++++----------------
 8 files changed, 177 insertions(+), 54 deletions(-)

-- 
2.18.0
