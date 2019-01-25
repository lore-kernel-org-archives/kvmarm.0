From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 0/2] KVM: arm/arm64: Add VCPU workarounds firmware register
Date: Fri, 25 Jan 2019 15:07:39 +0000
Message-ID: <20190125150741.184128-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ABDA4A3B8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 10:07:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e+qh4EoYYU01 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jan 2019 10:07:51 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54C494A3A5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 10:07:51 -0500 (EST)
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
Cc: kvm@vger.kernel.org, Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu, Dave Martin <dave.martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

this is a try to address Dave's comments concerning the readability of
the compatiblitiy check of the protection levels.
If picks up the idea of creating a linear scale, where smaller values
mean less protection. Originally the suggestion was to use a signed
encoding, with "unknown" being 0. While this sounds neat, it turns out
to be not very readable and hard to communicate in the ABI
documentation. I don't think it's feasible to establish a forward
looking standard for each and every upcoming firmware workaround
register, so I just moved everything up to avoid negative values.

Please let me know if this makes more sense or what else could be done.

Regarding the states in "workaround 1": At the moment the host kernel side
only reports the availability of the SMC call. "Not available" could
mean both "not needed" or "not implemented (aka. vulnerable)".
If the kernel would separate the last two states, we could propagate
this in the firmware register.
So would we need this in the host side to allow migration from
"workaround available" to "always mitigated, no w/a needed"?

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

 Documentation/virtual/kvm/arm/psci.txt |  21 +++++
 arch/arm/include/asm/kvm_emulate.h     |  10 +++
 arch/arm/include/uapi/asm/kvm.h        |   9 ++
 arch/arm64/include/asm/kvm_emulate.h   |  14 +++
 arch/arm64/include/uapi/asm/kvm.h      |   9 ++
 virt/kvm/arm/psci.c                    | 118 +++++++++++++++++++++----
 6 files changed, 165 insertions(+), 16 deletions(-)

-- 
2.17.1
