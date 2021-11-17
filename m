Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C932AC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:42:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4885F61BF9
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:42:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4885F61BF9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D12BC4B1E4;
	Wed, 17 Nov 2021 10:42:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dxjvumSHQyY1; Wed, 17 Nov 2021 10:42:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F62D4B1DC;
	Wed, 17 Nov 2021 10:42:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E29094B1CF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:42:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gvEut16BT1IL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:42:10 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2A9D4B154
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:42:10 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54EB31FB;
 Wed, 17 Nov 2021 07:42:10 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 299263F5A1;
 Wed, 17 Nov 2021 07:42:09 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH v5 kvmtool 0/4] arm64: KVM SPE support
Date: Wed, 17 Nov 2021 15:43:52 +0000
Message-Id: <20211117154356.303039-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
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

2. After the guest memory memslots have been created and SPE initialized,
kvmtool will lock the memslot memory using the newly introduced capability.

The first patch is a simple update to the Linux headers; the next two
patches are preparatory patches. SPE support is added in patch number 4.

Changes since v4:

* Removed KVM_ARM_VCPU_SUPPORTED_CPUS ioctl.

[1] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/kvm-spe-v5
[2] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/kvm-spe-v5

Alexandru Elisei (3):
  update_headers: Sync KVM UAPI headers with KVM SPE implementation
  arm/arm64: Make kvm__arch_delete_ram() aarch32/aarch64 specific
  init: Add last_{init, exit} list macros

Sudeep Holla (1):
  arm64: Add SPE support

 Makefile                                  |   2 +
 arm/aarch32/kvm.c                         |   8 +
 arm/aarch64/arm-cpu.c                     |   2 +
 arm/aarch64/include/asm/kvm.h             |  67 +++-
 arm/aarch64/include/kvm/kvm-config-arch.h |   2 +
 arm/aarch64/include/kvm/spe.h             |   7 +
 arm/aarch64/kvm-cpu.c                     |   5 +
 arm/aarch64/kvm.c                         |  19 +
 arm/aarch64/spe.c                         | 129 +++++++
 arm/include/arm-common/kvm-config-arch.h  |   1 +
 arm/kvm-cpu.c                             |   4 +
 arm/kvm.c                                 |   5 -
 include/kvm/util-init.h                   |   6 +-
 include/linux/kvm.h                       | 450 +++++++++++++++++++++-
 powerpc/include/asm/kvm.h                 |  10 +
 x86/include/asm/kvm.h                     |  64 ++-
 16 files changed, 760 insertions(+), 21 deletions(-)
 create mode 100644 arm/aarch32/kvm.c
 create mode 100644 arm/aarch64/include/kvm/spe.h
 create mode 100644 arm/aarch64/spe.c

-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
