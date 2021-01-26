Return-Path: <SRS0=hkx2=G5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 836F1C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 14:12:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E3DE822B2C
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 14:12:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3DE822B2C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 644CE4B2DA;
	Tue, 26 Jan 2021 09:12:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O0iSh1MECl0k; Tue, 26 Jan 2021 09:12:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B6A94B2D5;
	Tue, 26 Jan 2021 09:12:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9836B4B2D1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 09:12:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dxrIcRpTyWUi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2021 09:12:03 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BE8D4B299
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 09:12:03 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9628113E;
 Tue, 26 Jan 2021 06:12:02 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F22393F68F;
 Tue, 26 Jan 2021 06:12:01 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/2] KVM: arm64: vgic-v3: Misc fixes
Date: Tue, 26 Jan 2021 14:11:54 +0000
Message-Id: <20210126141156.39317-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.0
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

Two minor patches for stuff I found while reviewing Eric's VGIC fixes [1].

First patch should be straightforward documentation update.

I thought of the second patch when I was hacking kvmtool to read GICR_TYPER
from userspace. I was passing the raw MPIDR_EL1 value (the result of
KVM_GET_ONE_REG(MPIDR_EL1)) to KVM_DEV_ARM_VGIC_GRP_REDIST_REGS, which
obviously returned an error code. I started investigating and I thought
that the problem was caused by VGIC_TO_MPIDR not setting the RES1 bit (bit
31) from MPIDR_EL1. I actually wrote a patch to change that when I realized
that the macro wasn't supposed to create a valid MPIDR_EL1 value at all,
because the result of the macro is then compared to
kvm_vcpu_get_mpidr_aff().

I wrote patch #2 hoping that the change in the macro name will prevent
someone else from making the same mistake. On the other hand, using mpidr
to refer to the GICR_TYPER.Affinity_Value fields looks to be well
established in the kernel and in the documentation, so I'm not sure that
changing the macro name is really necessary.

[1] https://lore.kernel.org/kvmarm/20201212185010.26579-1-eric.auger@redhat.com/

Alexandru Elisei (2):
  Documentation: kvm: vgic-v3: Update return code for
    KVM_DEV_ARM_VGIC_GRP_CTRL
  KVM: arm64: vgic-v3: Rename VGIC_TO_MPIDR() to VGIC_TO_MPIDR_AFF()

 Documentation/virt/kvm/devices/arm-vgic-v3.rst |  4 +++-
 arch/arm64/kvm/vgic/vgic-kvm-device.c          | 12 ++++++------
 arch/arm64/kvm/vgic/vgic.h                     | 10 +++++-----
 3 files changed, 14 insertions(+), 12 deletions(-)

-- 
2.30.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
