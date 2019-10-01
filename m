Return-Path: <SRS0=C9Vx=X2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC79C352AA
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 09:21:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 632E521927
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 09:21:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 632E521927
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BFA34A6B8;
	Tue,  1 Oct 2019 05:21:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PnBy2m+8iAdt; Tue,  1 Oct 2019 05:21:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B750F4A6A7;
	Tue,  1 Oct 2019 05:21:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47B324A69B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 05:21:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oVOTeg+Mha3j for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Oct 2019 05:21:12 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 519584A678
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 05:21:12 -0400 (EDT)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by cheepnis.misterjones.org with esmtpsa
 (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128) (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iFEL5-00019A-0W; Tue, 01 Oct 2019 11:20:59 +0200
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 0/4] KVM/arm updates for 5.4-rc2
Date: Tue,  1 Oct 2019 10:20:34 +0100
Message-Id: <20191001092038.17097-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
 christoffer.dall@arm.com, yamada.masahiro@socionext.com, yuzenghui@huawei.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Masahiro Yamada <yamada.masahiro@socionext.com>,
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

Paolo, Radim,

Here's the first set of KVM/arm fixes for 5.4. The first three patches
remove a construct which helped us bringing up VHE back in the days,
but which is now more of a confusing historical artefact, better
replaced with static keys that we already have. The last patch fixes
the ftrace include path that so far worked by luck (and has been
addressed in other places in the tree).

Please pull,

       M.

The following changes since commit 92f35b751c71d14250a401246f2c792e3aa5b386:

  KVM: arm/arm64: vgic: Allow more than 256 vcpus for KVM_IRQ_LINE (2019-09-09 12:29:09 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.4-1

for you to fetch changes up to aac60f1a867773de9eb164013d89c99f3ea1f009:

  KVM: arm/arm64: vgic: Use the appropriate TRACE_INCLUDE_PATH (2019-09-11 16:36:19 +0100)

----------------------------------------------------------------
KVM/arm fixes for 5.4, take #1

- Remove the now obsolete hyp_alternate_select construct
- Fix the TRACE_INCLUDE_PATH macro in the vgic code

----------------------------------------------------------------
Marc Zyngier (3):
      arm64: KVM: Drop hyp_alternate_select for checking for ARM64_WORKAROUND_834220
      arm64: KVM: Replace hyp_alternate_select with has_vhe()
      arm64: KVM: Kill hyp_alternate_select()

Zenghui Yu (1):
      KVM: arm/arm64: vgic: Use the appropriate TRACE_INCLUDE_PATH

 arch/arm64/include/asm/kvm_hyp.h | 24 ------------------------
 arch/arm64/kvm/hyp/switch.c      | 17 ++---------------
 arch/arm64/kvm/hyp/tlb.c         | 36 ++++++++++++++++++++++--------------
 virt/kvm/arm/vgic/trace.h        |  2 +-
 4 files changed, 25 insertions(+), 54 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
