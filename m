Return-Path: <SRS0=9Ttc=O6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC51DC43217
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 15:09:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 886CA60F6E
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 15:09:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 886CA60F6E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CEAF4B0A0;
	Sun, 10 Oct 2021 11:09:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EfpCeUvxoETE; Sun, 10 Oct 2021 11:09:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06DB94B0C0;
	Sun, 10 Oct 2021 11:09:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E920A4B0BE
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 11:09:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t3WaHa8MwGyu for <kvmarm@lists.cs.columbia.edu>;
 Sun, 10 Oct 2021 11:09:25 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB2414B091
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 11:09:25 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id AD94760ED4;
 Sun, 10 Oct 2021 15:09:24 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mZaS2-00FrmD-Eu; Sun, 10 Oct 2021 16:09:22 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/5] KVM: arm64: Assorted vgic-v3 fixes
Date: Sun, 10 Oct 2021 16:09:05 +0100
Message-Id: <20211010150910.2911495-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com,
 joey.gouly@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Joey Gouly <joey.gouly@arm.com>
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

Here's a bunch of vgic-v3 fixes I have been sitting on for some
time. None of them are critical, though some are rather entertaining.

The first one is a leftover from the initial Apple-M1 enablement,
which doesn't advertise the GIC support via ID_AA64PFR0_EL1 (which is
expected, as it only has half a GIC...). We address it by forcefully
advertising the feature if the guest has a GICv3.

The second patch is really fun, and shows how things can go wrong when
they are badly specified. The gist of it is that on systems that
advertise ICH_VTR_EL2.SEIS, we need to fallback to the full GICv3
cpuif emulation. The third patch is an good optimisation on the
previous one, and the fourth a direct consequence of the whole thing.

The last patch are more of a harmless oddity: virtual LPIs happen to
have an active state buried into the pseudocode (and only there). Fun!
Nothing goes wrong with that, but we need to align the emulation to
match the pseudocode.

All of this is only targeting 5.16, and I don't plan to backport any
of it.

* From v1 [1]:

  - Dropped the patch that tried to optimise what to do with an active
    LPI. There is unfortunately a bad corner case in the pseudocode
    that prevents it. Oh well.
    
  - Added an extra patch to help in the case where ICH_HCR_EL2.TDS is
    supported, and that we can use that instead of ICH_HCR_EL2.TC to
    trap only ICC_DIR_EL1. Given the performance improvement, it was
    too hard to ignore it.

[1] https://lore.kernel.org/r/20210924082542.2766170-1-maz@kernel.org

Marc Zyngier (5):
  KVM: arm64: Force ID_AA64PFR0_EL1.GIC=1 when exposing a virtual GICv3
  KVM: arm64: vgic-v3: Work around GICv3 locally generated SErrors
  KVM: arm64: vgic-v3: Reduce common group trapping to ICV_DIR_EL1 when
    possible
  KVM: arm64: vgic-v3: Don't advertise ICC_CTLR_EL1.SEIS
  KVM: arm64: vgic-v3: Align emulated cpuif LPI state machine with the
    pseudocode

 arch/arm64/include/asm/sysreg.h |  3 +++
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 22 ++++++++--------------
 arch/arm64/kvm/sys_regs.c       |  5 +++++
 arch/arm64/kvm/vgic/vgic-v3.c   | 21 ++++++++++++++++++---
 4 files changed, 34 insertions(+), 17 deletions(-)

-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
