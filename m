Return-Path: <SRS0=4x2k=Y7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 829D8C43331
	for <kvmarm@archiver.kernel.org>; Thu,  7 Nov 2019 16:04:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 459EB218AE
	for <kvmarm@archiver.kernel.org>; Thu,  7 Nov 2019 16:04:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 459EB218AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB3034ACA7;
	Thu,  7 Nov 2019 11:04:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F2Fj8e1eH8G4; Thu,  7 Nov 2019 11:04:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA8874ACA5;
	Thu,  7 Nov 2019 11:04:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B93FE4ACAB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Nov 2019 11:04:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8vpleHFXA1p5 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Nov 2019 11:04:24 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 92B534AC83
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Nov 2019 11:04:24 -0500 (EST)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by cheepnis.misterjones.org with esmtpsa
 (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128) (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iSkGk-0008Bm-6O; Thu, 07 Nov 2019 17:04:22 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] KVM: arm64: Reduce occurence of GICv4 doorbells on
 non-oversubscribed systems
Date: Thu,  7 Nov 2019 16:04:10 +0000
Message-Id: <20191107160412.30301-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
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

As I was cleaning up some of the GICv4 code to make way for GICv4.1 it
occured to me that we could drastically reduce the impact of the GICv4
doorbells on systems that are not oversubscribed (each vcpu "owns" a
physical CPU).

The technique borrows its logic from the way we disable WFE trapping
when a vcpu is the only process on the CPU run-queue. If this vcpu is
the target of VLPIs, it is then beneficial not to trap blocking WFIs
and to leave the vcpu waiting for interrupts in guest state.

All we need to do here is to track whether VLPIs are associated to a
vcpu (which is easily done by using a counter that we update on MAPI,
DISCARD and MOVI).

It has been *very lightly* tested on a D05, and behaved pretty well in
my limited test cases (I get almost no doorbell at all in the non
oversubscribed case, and the usual hailstorm as soon as there is
oversubscription). I'd welcome some testing on more current HW.

Marc Zyngier (2):
  KVM: vgic-v4: Track the number of VLPIs per vcpu
  KVM: arm64: Opportunistically turn off WFI trapping when using direct
    LPI injection

 arch/arm/include/asm/kvm_emulate.h   | 4 ++--
 arch/arm64/include/asm/kvm_emulate.h | 9 +++++++--
 include/linux/irqchip/arm-gic-v4.h   | 2 ++
 virt/kvm/arm/arm.c                   | 4 ++--
 virt/kvm/arm/vgic/vgic-init.c        | 1 +
 virt/kvm/arm/vgic/vgic-its.c         | 3 +++
 virt/kvm/arm/vgic/vgic-v4.c          | 2 ++
 7 files changed, 19 insertions(+), 6 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
