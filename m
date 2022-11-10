Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFC44C43217
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 01:54:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B4694BA62;
	Wed,  9 Nov 2022 20:54:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GXoXxPxKU3mK; Wed,  9 Nov 2022 20:54:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE56F4BA63;
	Wed,  9 Nov 2022 20:54:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C613C4BA63
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 20:54:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hfih1hK6Zqoj for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2022 20:54:12 -0500 (EST)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 00EF24BA62
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 20:54:11 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668045246;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=031ydeJtovOSU9UK7Zdq7wfix4bS349PsNi9KAdKvDc=;
 b=X3XzqfNXXcRLTeLoYDb82vNYtNnhU2Pdma2Im8vRiBs2PSgzGPRW3QO/JNmqwXuxk0JBuy
 fE77/gDtEDf/U8wyFS+sVBbxcQzFvMs8sb+VLpgHQDZCMdppxhy+n8ex4xzju71p5DNCbA
 FR7K2KcG2xFsRiX7clp/P9Qigd2Ig0g=
From: Oliver Upton <oliver.upton@linux.dev>
To: 
Subject: [RFC PATCH 0/3] KVM: arm64: Allow userspace to trap hypercall ranges
Date: Thu, 10 Nov 2022 01:53:24 +0000
Message-Id: <20221110015327.3389351-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The Arm SMCCC is rather prescriptive in regards to the allocation of
SMCCC function ID ranges. Many of the hypercall ranges have an
associated specification from Arm (FF-A, PSCI, SDEI, etc.) with some
room for vendor-specific implementations.

The ever-expanding hypercall surface leaves a lot of work within KVM for
providing new features. Furthermore, KVM implements its own
vendor-specific ABI, leaving little room for other implementations (like
Hyper-V, for example).

This series takes a stab at both by allowing SMCCC ranges to shunt to
userspace. The meat of the UAPI is a bitmap (conveyed through a VM
capability) that creates trap bits for known SMCCC ranges. Exits are
done by reusing the KVM_EXIT_HYPERCALL interface, with its hilariously
x86-specific kvm_run structure (no longmode here!)

=> We have these new hypercall bitmap registers, why not use that?

The hypercall bitmap registers aren't necessarily aimed at the same
problem. The bitmap registers allow a VMM to preserve the ABI the guest
gets from KVM by default when migrating between hosts. By default KVM
exposes the entire feature set to the guest, whereas user hypercalls
need explicit opt-in from userspace.

TODO:
 - SMCCC_ARCH_FEATURES is pitifully overloaded to allow discovery of
   paravirtualized time features. Queries to SMCCC_ARCH_FEATURES against
   PV time should go to userspace if userspace has PV time trapped.

 - May want to use a completion on reentry for propagating the return
   value to avoid extra ioctls (SMCCC calls can return more than a
   single register value).

Tossing up on the list as an RFC to gauge interest in such an interface.
Gently tested with the included selftest and that's about it.

Applies to v6.1-rc3 + the header relocation [1]. No firm reason for it
besides the fact that I initially did the refactoring as part of this
series and am too lazy to rebase.

[1] https://lore.kernel.org/kvmarm/20221110010603.3382385-1-oliver.upton@linux.dev/

Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev
Cc: kvmarm@lists.cs.columbia.edu

Oliver Upton (3):
  KVM: arm64: Use a generalized accessor for SMCCC args
  KVM: arm64: Allow userspace to trap SMCCC sub-ranges
  KVM: selftests: Test user hypercalls

 arch/arm64/include/asm/kvm_host.h             |   5 +
 arch/arm64/include/asm/kvm_hypercalls.h       |  22 ++-
 arch/arm64/include/uapi/asm/kvm.h             |  15 ++
 arch/arm64/kvm/arm.c                          |  10 ++
 arch/arm64/kvm/hypercalls.c                   |  52 ++++++-
 arch/arm64/kvm/psci.c                         |  14 +-
 arch/arm64/kvm/pvtime.c                       |   2 +-
 arch/arm64/kvm/trng.c                         |   4 +-
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/user_hypercalls.c   | 130 ++++++++++++++++++
 12 files changed, 231 insertions(+), 26 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/user_hypercalls.c

-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
