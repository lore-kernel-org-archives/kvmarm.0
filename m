Return-Path: <SRS0=r5x+=SR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30EAEC10F12
	for <kvmarm@archiver.kernel.org>; Mon, 15 Apr 2019 11:16:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ABDDD2073F
	for <kvmarm@archiver.kernel.org>; Mon, 15 Apr 2019 11:16:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ABDDD2073F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 121D74A480;
	Mon, 15 Apr 2019 07:16:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DA-dwlGjmpmL; Mon, 15 Apr 2019 07:15:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEF914A4D5;
	Mon, 15 Apr 2019 07:15:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57CE54A483
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 07:15:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O80ijI-FXSFd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Apr 2019 07:15:55 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98F364A480
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 07:15:55 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CAB0980D;
 Mon, 15 Apr 2019 04:15:54 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 07FF23F706;
 Mon, 15 Apr 2019 04:15:52 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v5 0/3] KVM: arm/arm64: Add VCPU workarounds firmware register
Date: Mon, 15 Apr 2019 12:15:39 +0100
Message-Id: <20190415111542.119788-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Cc: kvm@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
 kvmarm@lists.cs.columbia.edu, Steven Price <steven.price@arm.com>,
 Dave Martin <dave.martin@arm.com>, linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190415111539.khQ1ptuIc0f1f1C0GrmymSrvbz48mj6Sl5FBGuBREd0@z>

Hi,

another update, mostly basing upon Jeremy's sysfs vulnerabilites
series[1], which adds the new UNAFFECTED state for WORKAROUND_1.
The new patch 1/3 propagates this state to the guest, so a guest benefits
from the host kernel's knowledge about whether this workaround is needed.
This triggers some changes in patch 2/3, where we properly export this
new state to userland as well, so we can deny migration from NOT_NEEDED to
AVAILABLE, and allow the other way round.
The documentation in patch 3/3 has been reworded to be more precise, so
I dropped Steven's R-b: on this.

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

This is based upon v7 of the "add system vulnerability sysfs entries",
applied on top of 5.1-rc4. Let me know if you want to have a different
base.

Cheers,
Andre

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2019-April/645382.html

Changelog:
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
