Return-Path: <SRS0=c4fT=6H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA881C54FD0
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 15:40:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 37FC82075A
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 15:40:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="mTU6Ypol"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37FC82075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A26334B185;
	Thu, 23 Apr 2020 11:40:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Phb7ZZT7cPrs; Thu, 23 Apr 2020 11:40:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2DFD4B28B;
	Thu, 23 Apr 2020 11:40:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5E984B1EE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 11:40:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bUyx1Mf5Rc-f for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2020 11:40:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A86124B1EB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 11:40:32 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8D9902075A;
 Thu, 23 Apr 2020 15:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587656431;
 bh=MzR7Ksg3zN//9VOBpsR8Z+gdJA8z+zcljbVAhZW0Gyc=;
 h=From:To:Cc:Subject:Date:From;
 b=mTU6YpolqaV19yyRc48VQLOC1Jqjzcdyj5HPnQpEz0AYioRan12wH3QPWszCwvuce
 T0l2slm7G+McCqfFgf9SBPzsxti3Kaq0ecuYpmeKeXTSVgmi72EDQ/F7tl9VySE+dv
 FgLrdRgrbi37eP5GL/JHmTk7euKnZ4BuGhYCns+I=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jRdxl-005oPM-Sh; Thu, 23 Apr 2020 16:40:30 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm fixes for 5.7, take #1
Date: Thu, 23 Apr 2020 16:40:01 +0100
Message-Id: <20200423154009.4113562-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 andre.przywara@arm.com, christoffer.dall@arm.com, julien@xen.org,
 yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Julien Grall <julien@xen.org>, kvm@vger.kernel.org,
 =?UTF-8?q?Andr=C3=A9=20Przywara?= <andre.przywara@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

Hi Paolo,

Here is a bunch of fixes for the next -rc, focusing on the PSCI
implementation (spec conformance), and the usual vGIC patches
(preventing userspace from messing with the HW state and plugging a
couple of memory leaks).

Please pull,

	M.

The following changes since commit 8f3d9f354286745c751374f5f1fcafee6b3f3136:

  Linux 5.7-rc1 (2020-04-12 12:35:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.7-1

for you to fetch changes up to 446c0768f5509793a0e527a439d4866b24707b0e:

  Merge branch 'kvm-arm64/vgic-fixes-5.7' into kvmarm-master/master (2020-04-23 16:27:33 +0100)

----------------------------------------------------------------
KVM/arm fixes for Linux 5.7, take #1

- Prevent the userspace API from interacting directly with the HW
  stage of the virtual GIC
- Fix a couple of vGIC memory leaks
- Tighten the rules around the use of the 32bit PSCI functions
  for 64bit guest, as well as the opposite situation (matches the
  specification)

----------------------------------------------------------------
Marc Zyngier (8):
      KVM: arm: vgic: Fix limit condition when writing to GICD_I[CS]ACTIVER
      KVM: arm64: PSCI: Narrow input registers when using 32bit functions
      KVM: arm64: PSCI: Forbid 64bit functions for 32bit guests
      KVM: arm: vgic: Synchronize the whole guest on GIC{D,R}_I{S,C}ACTIVER read
      KVM: arm: vgic: Only use the virtual state when userspace accesses enable bits
      KVM: arm: vgic-v2: Only use the virtual state when userspace accesses pending bits
      Merge branch 'kvm-arm64/psci-fixes-5.7' into kvmarm-master/master
      Merge branch 'kvm-arm64/vgic-fixes-5.7' into kvmarm-master/master

Zenghui Yu (2):
      KVM: arm64: vgic-v3: Retire all pending LPIs on vcpu destroy
      KVM: arm64: vgic-its: Fix memory leak on the error path of vgic_add_lpi()

 virt/kvm/arm/psci.c              |  40 +++++++
 virt/kvm/arm/vgic/vgic-init.c    |  10 +-
 virt/kvm/arm/vgic/vgic-its.c     |  11 +-
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  16 +--
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  28 ++---
 virt/kvm/arm/vgic/vgic-mmio.c    | 228 +++++++++++++++++++++++++++++----------
 virt/kvm/arm/vgic/vgic-mmio.h    |  19 ++++
 7 files changed, 272 insertions(+), 80 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
