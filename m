Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C2DC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 25 Nov 2021 16:19:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6028A4B187;
	Thu, 25 Nov 2021 11:19:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i3V8yYz7Hyq4; Thu, 25 Nov 2021 11:19:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E6324B15C;
	Thu, 25 Nov 2021 11:19:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 890BC4B139
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Nov 2021 11:19:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mc+5p8lTJrP7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Nov 2021 11:19:08 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F0E84B132
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Nov 2021 11:19:08 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9074160FE7;
 Thu, 25 Nov 2021 16:19:07 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mqHSj-007qd3-84; Thu, 25 Nov 2021 16:19:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm64 fixes for 5.16, take #2
Date: Thu, 25 Nov 2021 16:19:02 +0000
Message-Id: <20211125161902.106749-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, catalin.marinas@arm.com,
 Chris.January@arm.com, tabba@google.com, will@kernel.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chris January <Chris.January@arm.com>, linux-arm-kernel@lists.infradead.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

Here's the second set of fixes for 5.16. The main items are a fix for
an unfortunate signed constant extension, leading to an unbootable
kernel on ARMv8.7 systems. The two other patches are fixes for the
rare cases where we evaluate PSTATE too early on guest exit.

Please pull,

	M.

The following changes since commit fa55b7dcdc43c1aa1ba12bca9d2dd4318c2a0dbf:

  Linux 5.16-rc1 (2021-11-14 13:56:52 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.16-2

for you to fetch changes up to 1f80d15020d7f130194821feb1432b67648c632d:

  KVM: arm64: Avoid setting the upper 32 bits of TCR_EL2 and CPTR_EL2 to 1 (2021-11-25 15:51:25 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 5.16, take #2

- Fix constant sign extension affecting TCR_EL2 and preventing
  running on ARMv8.7 models due to spurious bits being set

- Fix use of helpers using PSTATE early on exit by always sampling
  it as soon as the exit takes place

- Move pkvm's 32bit handling into a common helper

----------------------------------------------------------------
Catalin Marinas (1):
      KVM: arm64: Avoid setting the upper 32 bits of TCR_EL2 and CPTR_EL2 to 1

Marc Zyngier (2):
      KVM: arm64: Save PSTATE early on exit
      KVM: arm64: Move pkvm's special 32bit handling into a generic infrastructure

 arch/arm64/include/asm/kvm_arm.h           |  4 ++--
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 14 ++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  7 ++++++-
 arch/arm64/kvm/hyp/nvhe/switch.c           |  8 +-------
 arch/arm64/kvm/hyp/vhe/switch.c            |  4 ++++
 5 files changed, 27 insertions(+), 10 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
