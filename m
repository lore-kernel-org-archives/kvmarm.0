Return-Path: <SRS0=fmje=ZA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10752FA372C
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 17:50:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D96421D7F
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 17:50:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D96421D7F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 271D14ACB0;
	Fri,  8 Nov 2019 12:50:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z225YIC586rT; Fri,  8 Nov 2019 12:50:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB4EE4AECC;
	Fri,  8 Nov 2019 12:50:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7FC14AEC7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 12:50:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1bCgGP3drWxK for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Nov 2019 12:49:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C2D24ACB0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 12:49:59 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1522431B;
 Fri,  8 Nov 2019 09:49:59 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D1ED93F719;
 Fri,  8 Nov 2019 09:49:57 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH 0/3] kvm: arm: VGIC: Fix interrupt group enablement
Date: Fri,  8 Nov 2019 17:49:49 +0000
Message-Id: <20191108174952.740-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
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

In KVM we emulate an ARM Generic Interrupt Controller with a "single
security state", which (unlike most GICs found in silicon) provides
a non-secure operating system with *two* interrupt groups.
Since on bare metal we typically have only one group available, Linux
does not actually care about the groups and will just use the one
provided.

However we claim to support the GIC architecture, and actually have code
to support two groups, so we should aim to support this properly.

As Marc pointed out recently, we don't honour the separate group enable
bits in the GICD_CTLR register, so a guest can't separately enable or
disable the two groups.

Fixing this unfortunately requires more than just to provide storage for
a second bit: So far we were treating the "groupX enable bit" as a
global distributor enable bit, preventing interrupts from being entered
into the list registers at all if the whole thing was disabled.
Now with two separate bits we might need to block one IRQ, while needing
to forward another one, so this neat trick does not work anymore.

Instead we slightly remodel our "interrupt forwarding" mechanism, to
actually get closer to the architecture: Before adding a pending IRQ to
the ap_list, we check whether its configured interrupt group is enabled.
If it's not, we don't add it to the ap_list (yet). Now when later this
group gets enabled, we need to rescan all (pending) IRQs, to add them to
the ap_list and forward them to the guest. This is not really cheap, but
fortunately wouldn't happen too often, so we refrain from employing any
super clever algorithm, at least for now.
Another solution would be to introduce a "disabled_group_list", where
pending, but group-disabled IRQs go to, let me know if I should explore
this further.

Patch 1 prepares the VGIC code to provide storage for the two enable
bits, also extends the MMIO handling to deal with the two bits.
For this patch we still block the "other" group, as we need the
rescanning algorithm in patch 2 to allow enabling of any group later on.
Patch 3 then enables the functionality, when everything is ready.
The split-up is mostly for review purposes, since I expect some
discussion about patch 2. Happy to merge the three into one once we
agreed on the approach.

There is a corresponding kvm-unit-test series to test the FIQ
functionality, since Linux itself won't use this.
This has been tested with Linux (for regressions) and with
kvm-unit-tests, on a GICv2/arm, GICv2/arm64 and GICv3/arm64 machine.

The kvm-unit-tests patches can be found here:
https://lists.cs.columbia.edu/pipermail/kvmarm/2019-November/037853.html
or in the following repo:
https://github.com/Andre-ARM/kvm-unit-tests/commits/gic-group0

This series here can also be found at:
git://linux-arm.org/linux-ap.git

Based on kvmarm/next, commit cd7056ae34af.

Please have a look!

Cheers,
Andre

Andre Przywara (3):
  kvm: arm: VGIC: Prepare for handling two interrupt groups
  kvm: arm: VGIC: Scan all IRQs when interrupt group gets enabled
  kvm: arm: VGIC: Enable proper Group0 handling

 include/kvm/arm_vgic.h           |   7 +-
 virt/kvm/arm/vgic/vgic-debug.c   |   2 +-
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  23 +++---
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  22 +++---
 virt/kvm/arm/vgic/vgic.c         | 130 ++++++++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic.h         |   3 +
 6 files changed, 162 insertions(+), 25 deletions(-)

-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
