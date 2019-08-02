Return-Path: <SRS0=eGRX=V6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322ECC32753
	for <kvmarm@archiver.kernel.org>; Fri,  2 Aug 2019 10:37:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B8F852087E
	for <kvmarm@archiver.kernel.org>; Fri,  2 Aug 2019 10:37:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8F852087E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4353E4A550;
	Fri,  2 Aug 2019 06:37:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x8NpWcWrHXPM; Fri,  2 Aug 2019 06:37:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DCBA4A54C;
	Fri,  2 Aug 2019 06:37:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B1284A51B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Aug 2019 06:37:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hHihhk9X8P15 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Aug 2019 06:37:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77F444A4CD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Aug 2019 06:37:45 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 087D2344;
 Fri,  2 Aug 2019 03:37:45 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A60B53F71F;
 Fri,  2 Aug 2019 03:37:43 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 James Morse <james.morse@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
 Tangnianyao <tangnianyao@huawei.com>
Subject: [PATCH 0/2] KVM: arm/arm64: Fix guest's PMR synchronization when
 blocking on WFI
Date: Fri,  2 Aug 2019 11:37:07 +0100
Message-Id: <20190802103709.70148-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

It recently came to light that if we run a guest that actively uses
interrupt priorities to block interrupts, vcpus can end-up being
blocked while they shouldn't, leading to an unresponsive guest (a
slightly less than desirable outcome).

Patch #1 fixes the issue (which has been with us since 4.12), which I plan
to take in for 5.3 with immediate backport to stable.

Patch #2 is more of an RFC, as it also impacts the SVN AVIC support. It
moves the kvm_arch_vcpu_blocking callback to happen earlier, leading to
much better performances on ARM, and leading to the above fix to be
applied at the best possible spot. I'd welcome any comment/testing on
this, specially on non-ARM systems.

Marc Zyngier (2):
  KVM: arm/arm64: Sync ICH_VMCR_EL2 back when about to block
  KVM: Call kvm_arch_vcpu_blocking early into the blocking sequence

 include/kvm/arm_vgic.h      |  1 +
 virt/kvm/arm/arm.c          | 11 +++++++++++
 virt/kvm/arm/vgic/vgic-v2.c |  9 ++++++++-
 virt/kvm/arm/vgic/vgic-v3.c |  7 ++++++-
 virt/kvm/arm/vgic/vgic.c    | 11 +++++++++++
 virt/kvm/arm/vgic/vgic.h    |  2 ++
 virt/kvm/kvm_main.c         |  7 +++----
 7 files changed, 42 insertions(+), 6 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
