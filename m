From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 0/2] KVM: arm/arm64: Add VCPU workarounds firmware register
Date: Fri, 22 Feb 2019 12:18:16 +0000
Message-ID: <20190222121818.30164-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 918B64A3B3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 07:18:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yD-o3Z1yJygx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 07:18:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D36F64A200
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 07:18:28 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Dave Martin <dave.martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

Aside from a rebase against kvm-arm/next, this update introduces a new
UNAFFECTED value for WORKAROUND_1, which is not used at the moment, but
will become useful with some patches extending the host kernel workaround
code [1]. We add the value to the ABI already.
Also we now require an exact match for the two WORKAROUND_1 levels, as
we can't allow a guest to migrate from a system with an effectively
unknown workaround state to a system which requires an active guest
workaround.
Now tested with actual migration, see below.

Cheers,
Andre

-----------------------------
Workarounds for Spectre variant 2 or 4 vulnerabilities require some help
from the firmware, so KVM implements an interface to provide that for
guests. When such a guest is migrated, we want to make sure we don't
loose the protection the guest relies on.

This introduces two new firmware registers in KVM's GET/SET_ONE_REG
interface, so userland can save the level of protection implemented by
the hypervisor and used by the guest. Upon restoring these registers,
we make sure we don't downgrade and reject any values that would mean
weaker protection.
The protection level is encoding in the lower 4 bits, with smaller
values indicating weaker protection.

Patch 1 implements the two firmware registers, patch 2 adds the
documentation.

ARM(32) is a bit of a pain (again), as the firmware register interface
is shared, but 32-bit does not implement all the workarounds.
For now I stuffed two wrappers into kvm_emulate.h, which doesn't sound
like the best solution. Happy to hear about better solutions.

This has been tested with migration between two Juno systems. Out of the
box they advertise identical workaround levels, and migration succeeds.
However when disabling the A57 cluster on one system, WORKAROUND_1 is
not needed and the host kernel disables this. Migration between the two
now fails, as expected.

Please have a look and comment!

Cheers,
Andre

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2019-January/627791.html

Changelog:
v1 .. v2:
- complete rework of WORKAROUND_2 presentation to use a linear scale,
  dropping the complicated comparison routine

v2 .. v3:
- rebase against latest kvm-arm/next
- introduce UNAFFECTED value for WORKAROUND_1
- require exact match for WORKAROUND_1 levels

Andre Przywara (2):
  KVM: arm/arm64: Add save/restore support for firmware workaround state
  KVM: doc: add API documentation on the KVM_REG_ARM_WORKAROUNDS
    register

 Documentation/virtual/kvm/arm/psci.txt |  24 +++++
 arch/arm/include/asm/kvm_emulate.h     |  10 +++
 arch/arm/include/uapi/asm/kvm.h        |  10 +++
 arch/arm64/include/asm/kvm_emulate.h   |  14 +++
 arch/arm64/include/uapi/asm/kvm.h      |   9 ++
 virt/kvm/arm/psci.c                    | 119 +++++++++++++++++++++----
 6 files changed, 170 insertions(+), 16 deletions(-)

-- 
2.17.1
