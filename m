Return-Path: <SRS0=60hl=6P=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3843C47253
	for <kvmarm@archiver.kernel.org>; Fri,  1 May 2020 10:12:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6887B21973
	for <kvmarm@archiver.kernel.org>; Fri,  1 May 2020 10:12:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="X1YhUQCC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6887B21973
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6EA84B616;
	Fri,  1 May 2020 06:12:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WzXaq27EQL-b; Fri,  1 May 2020 06:12:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C25394B612;
	Fri,  1 May 2020 06:12:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 254E14B5CE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 May 2020 06:12:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YBfd8Qum-GnB for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 May 2020 06:12:14 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E810C4B528
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 May 2020 06:12:13 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id CC8272071C;
 Fri,  1 May 2020 10:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588327932;
 bh=MklRYqz2k5cgg9fDxl/d5X5Bx725+ZQ/Ik6viwGxla4=;
 h=From:To:Cc:Subject:Date:From;
 b=X1YhUQCCR6e8QRgIEHrOJrY2OLaP82i20DIb+Jk+ZKCeEwwvw3Zpb0ro3VcUTEhw4
 gaaZNfih7lrLfPOWi2d/T3xjcde6aAizPmXuK+c1j7yME1SY2dNkQt0+ZatzQuPJ+W
 LFZ0qpF5NDxuEBSFW5mNfRKLlY02LLeFJT5i58ac=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jUSeR-008J3K-7D; Fri, 01 May 2020 11:12:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm fixes for 5.7, take #2
Date: Fri,  1 May 2020 11:12:00 +0100
Message-Id: <20200501101204.364798-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, maskray@google.com,
 mark.rutland@arm.com, ndesaulniers@google.com, will@kernel.org,
 yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Fangrui Song <maskray@google.com>,
 Nick Desaulniers <ndesaulniers@google.com>,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
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

Paolo,

This is the second batch of KVM/arm fixes for 5.7. A compilation fix,
a GICv4.1 fix, plus a couple of sanity checks (SP_EL0 save/restore,
and the sanitising of AArch32 registers).

Note that the pull request I sent a week ago[1] is still valid, and
that this new series is built on top of the previous one.

Please pull,

	M.

[1] https://lore.kernel.org/kvm/20200423154009.4113562-1-maz@kernel.org/

The following changes since commit 446c0768f5509793a0e527a439d4866b24707b0e:

  Merge branch 'kvm-arm64/vgic-fixes-5.7' into kvmarm-master/master (2020-04-23 16:27:33 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.7-2

for you to fetch changes up to 0225fd5e0a6a32af7af0aefac45c8ebf19dc5183:

  KVM: arm64: Fix 32bit PC wrap-around (2020-05-01 09:51:08 +0100)

----------------------------------------------------------------
KVM/arm fixes for Linux 5.7, take #2

- Fix compilation with Clang
- Correctly initialize GICv4.1 in the absence of a virtual ITS
- Move SP_EL0 save/restore to the guest entry/exit code
- Handle PC wrap around on 32bit guests, and narrow all 32bit
  registers on userspace access

----------------------------------------------------------------
Fangrui Song (1):
      KVM: arm64: Delete duplicated label in invalid_vector

Marc Zyngier (3):
      KVM: arm64: Save/restore sp_el0 as part of __guest_enter
      KVM: arm64: vgic-v4: Initialize GICv4.1 even in the absence of a virtual ITS
      KVM: arm64: Fix 32bit PC wrap-around

 arch/arm64/kvm/guest.c           |  7 +++++++
 arch/arm64/kvm/hyp/entry.S       | 23 +++++++++++++++++++++++
 arch/arm64/kvm/hyp/hyp-entry.S   |  1 -
 arch/arm64/kvm/hyp/sysreg-sr.c   | 17 +++--------------
 virt/kvm/arm/hyp/aarch32.c       |  8 ++++++--
 virt/kvm/arm/vgic/vgic-init.c    |  9 ++++++++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  3 ++-
 7 files changed, 49 insertions(+), 19 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
