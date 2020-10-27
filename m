Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE74FC64E7C
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:16:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B5BAC21D24
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:16:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5BAC21D24
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0BA64B399;
	Tue, 27 Oct 2020 13:16:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u5ZZTeQd0mps; Tue, 27 Oct 2020 13:16:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD1AF4B3E6;
	Tue, 27 Oct 2020 13:16:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82E3D4B3A5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:16:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bX9DiQPvfk4j for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 13:16:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30B294B399
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:16:35 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC422139F;
 Tue, 27 Oct 2020 10:16:33 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 236773F719;
 Tue, 27 Oct 2020 10:16:30 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org
Subject: [RFC PATCH kvmtool v3 0/3] SPE support
Date: Tue, 27 Oct 2020 17:17:32 +0000
Message-Id: <20201027171735.13638-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Cc: will@kernel.org
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

This series adds userspace support for creating a guest which can use SPE.
It requires KVM SPE support which is in the RFC phase, hence why this
series is also RFC. The kvmtool patches can also be found at [1], and the
KVM SPE patches can be found at [2].

To create a guest with SPE support the following steps must be executed:

1. Set the SPE virtual interrupt ID and then initialize the features on
every VCPU.

2. After the guest memory memslots have been created, kvmtool must mlock()
the VMAs backing the memslots.

3. After everything has been copied to the guest's memory, kvmtool must
execute the KVM_ARM_VM_SPE_CTRL(KVM_ARM_VM_SPE_FINALIZE) on the VM fd.

The first patch is a simple update to the Linux headers; the second patch
add a new init list that executes last which is necessary to make sure the
gest memory will not be touched after that; and the third patch contains
the actual SPE support.

[1] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/kvm-spe-v3
[2] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/kvm-spe-v3

Alexandru Elisei (1):
  init: Add last_{init, exit} list macros

Sudeep Holla (2):
  update_headers: Sync kvm UAPI headers with linux 5.10-rc1
  arm64: Add SPE support

 Makefile                                  |   2 +-
 arm/aarch64/arm-cpu.c                     |   2 +
 arm/aarch64/include/asm/kvm.h             |  53 +++++++-
 arm/aarch64/include/kvm/kvm-config-arch.h |   2 +
 arm/aarch64/include/kvm/kvm-cpu-arch.h    |   3 +-
 arm/aarch64/kvm-cpu.c                     |   5 +
 arm/include/arm-common/kvm-config-arch.h  |   1 +
 arm/include/arm-common/spe.h              |   7 +
 arm/spe.c                                 | 154 ++++++++++++++++++++++
 include/kvm/util-init.h                   |   6 +-
 include/linux/kvm.h                       | 117 +++++++++++++++-
 powerpc/include/asm/kvm.h                 |   8 ++
 x86/include/asm/kvm.h                     |  42 +++++-
 13 files changed, 387 insertions(+), 15 deletions(-)
 create mode 100644 arm/include/arm-common/spe.h
 create mode 100644 arm/spe.c

-- 
2.29.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
