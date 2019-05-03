Return-Path: <SRS0=WQmE=TD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D447AC43219
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 14:28:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 624FA205ED
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 14:28:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 624FA205ED
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAB2F4A54C;
	Fri,  3 May 2019 10:28:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TFHHEzgtQ-8p; Fri,  3 May 2019 10:28:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A131F4A555;
	Fri,  3 May 2019 10:28:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C1B74A545
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 10:28:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U-Vm3Z4WQYCO for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 May 2019 10:28:00 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F243D4A51B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 10:27:59 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 479FE80D;
 Fri,  3 May 2019 07:27:59 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8CFB33F5C1;
 Fri,  3 May 2019 07:27:57 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v6 0/3] KVM: arm/arm64: Add VCPU workarounds firmware register
Date: Fri,  3 May 2019 15:27:47 +0100
Message-Id: <20190503142750.252793-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Cc: kvm@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
 Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi,

hopefully the final update on this series, rebasing on Catalin's and
Will's arm64/for-next/mitigations branch.
This slightly adjusts the internal names to use "not required"
instead of "unaffected", which is less precise.
As introduced in v5, this one contains the patch to propagate the new
"not required" state for Spectre v2 to KVM and its guests.

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
The protection level is encoded in the lower 4 bits, with smaller
values indicating weaker protection.

ARM(32) is a bit of a pain (again), as the firmware register interface
is shared, but 32-bit does not implement all the workarounds.
For now I stuffed two wrappers into kvm_emulate.h, which doesn't sound
like the best solution. Happy to hear about better solutions.

This has been tested with migration between two Juno systems. Out of the
box they advertise identical workaround levels, and migration succeeds.
However when disabling the A57 cluster on one system, WORKAROUND_1 is
not needed and the host kernel propagates this. Migration now only
succeeds in one direction (from the big/LITTLE configuration to the
A53-only setup).

Please have a look and comment!

This is based upon arm64/for-next/migitations.
Find a git branch here:
{git,http}://linux-arm.org/linux-ap.git branch fw-regs/v6-sysfs

Cheers,
Andre

Changelog:
v5 .. v6:
- rebase on merged sysfs vulnerabilities series
- rename ..._UNAFFECTED to ..._NOT_REQUIRED
- rename ARM64_BP_HARDEN_MITIGATED
- add tags

v4 .. v5:
- add patch to advertise ARM64_BP_HARDEN_MITIGATED state to a guest
- allow migration from KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL to
  (new) KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_UNAFFECTED
- reword API documentation
- return -EINVAL on querying invalid firmware register
- add some comments
- minor fixes according to Eric's review

v3 .. v4:
- clarify API documentation for WORKAROUND_1
- check for unknown bits in userland provided register values
- report proper -ENOENT when register ID is unknown

v2 .. v3:
- rebase against latest kvm-arm/next
- introduce UNAFFECTED value for WORKAROUND_1
- require exact match for WORKAROUND_1 levels

v1 .. v2:
- complete rework of WORKAROUND_2 presentation to use a linear scale,
  dropping the complicated comparison routine

Andre Przywara (3):
  arm64: KVM: Propagate full Spectre v2 workaround state to KVM guests
  KVM: arm/arm64: Add save/restore support for firmware workaround state
  KVM: doc: add API documentation on the KVM_REG_ARM_WORKAROUNDS
    register

 Documentation/virtual/kvm/arm/psci.txt |  31 +++++
 arch/arm/include/asm/kvm_emulate.h     |  10 ++
 arch/arm/include/asm/kvm_host.h        |  12 +-
 arch/arm/include/uapi/asm/kvm.h        |  12 ++
 arch/arm64/include/asm/cpufeature.h    |   6 +
 arch/arm64/include/asm/kvm_emulate.h   |  14 +++
 arch/arm64/include/asm/kvm_host.h      |  16 ++-
 arch/arm64/include/uapi/asm/kvm.h      |  10 ++
 arch/arm64/kernel/cpu_errata.c         |  23 +++-
 virt/kvm/arm/psci.c                    | 149 ++++++++++++++++++++++---
 10 files changed, 257 insertions(+), 26 deletions(-)

-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
