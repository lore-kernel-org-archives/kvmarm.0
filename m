From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 0/2] KVM: arm/arm64: Add VCPU workarounds firmware register
Date: Mon,  7 Jan 2019 12:05:35 +0000
Message-ID: <20190107120537.184252-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B09A4A3C5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jan 2019 07:05:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rmUWE5lGuCAq for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Jan 2019 07:05:56 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDF3C4A3AD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jan 2019 07:05:56 -0500 (EST)
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
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Workarounds for Spectre variant 2 or 4 vulnerabilities require some help
from the firmware, so KVM implements an interface to provide that for
guests. When such a guest is migrated, we want to make sure we don't
loose the protection the guest relies on.

This introduces two new firmware registers in KVM's GET/SET_ONE_REG
interface, so userland can save the level of protection implemented by
the hypervisor and used by the guest. Upon restoring these registers,
we make sure we don't downgrade and reject any values that would mean
weaker protection.
There is some table in the code to describe the valid combinations.

Patch 1 implements the two firmware registers, patch 2 adds the
documentation.

This solution is using two hardcoded firmware registers for that. Not
sure if we should introduce something based on SMCCC instead, which
would allow us to report implementation of any SMCCC based service in a
generic way, or if this would be too generic.

ARM(32) is a bit of a pain (again), as the firmware register interface
is shared, but 32-bit does not implement all the workarounds.
For now I stuffed two wrappers into kvm_emulate.h, which doesn't sound
like the best solution. Happy to hear about better ideas.

This has been tested with a hack to allow faking the protection level
via a debugfs knob, then saving/restoring via some userland tool calling
the GET_ONE_REG/SET_ONE_REG ioctls.

Please have a look and comment!

Cheers,
Andre

Andre Przywara (2):
  KVM: arm/arm64: Add save/restore support for firmware workaround state
  KVM: doc: add API documentation on the KVM_REG_ARM_WORKAROUNDS
    register

 Documentation/virtual/kvm/arm/psci.txt |  20 ++++
 arch/arm/include/asm/kvm_emulate.h     |  10 ++
 arch/arm/include/uapi/asm/kvm.h        |   9 ++
 arch/arm64/include/asm/kvm_emulate.h   |  14 +++
 arch/arm64/include/uapi/asm/kvm.h      |   9 ++
 virt/kvm/arm/psci.c                    | 138 ++++++++++++++++++++++++-
 6 files changed, 198 insertions(+), 2 deletions(-)

-- 
2.17.1
