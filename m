Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F0BC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jun 2022 13:14:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 398814B352;
	Tue,  7 Jun 2022 09:14:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B-X64PbwWLTn; Tue,  7 Jun 2022 09:14:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69AEF4B35D;
	Tue,  7 Jun 2022 09:14:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 726764B316
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 09:14:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YAXMzdx5lmMk for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jun 2022 09:14:34 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D6D24B303
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 09:14:34 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 716986136D;
 Tue,  7 Jun 2022 13:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32D9C34114;
 Tue,  7 Jun 2022 13:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654607672;
 bh=z7H4Y0P+n9b+MhwAEfoY2rl2mv+LI01POH5hYvGA0rk=;
 h=From:To:Cc:Subject:Date:From;
 b=FGs1NhGM48m9rA3QD0i+KRpyMCfwEI7hQuDa6DzgBJwLDI7WK/F9gjVxRRp+Bu263
 awAHIVocX9NvvGfo6432+k0wezHX5Xl2utZnTBc2KKZksRid5a9D4Mde4sHiQFarHS
 17KYoBmdET8gsxCTuFPeD+fKgfUAbkYPpHwgSDMti/lLvkVGtpww3mhFOaK44XSWUy
 rKtCT2HMd4iy2oEGd8GxjgwGl/jQQ9VUzWUvd2zQ6BBgpCCOhVME7Q+g32T1Bg/SWD
 koa9I039SwtKdtpfXbAQNmX+ctbdD+nMTgiLbwBo1cpAOqUiittF5+fMkVC6VzACz6
 AfeA/ug9nbFbg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nyZ2U-00GBUI-HP; Tue, 07 Jun 2022 14:14:30 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
Subject: [PATCH v2 0/3] KVM: arm64: Fix userspace access to HW pending state
Date: Tue,  7 Jun 2022 14:14:24 +0100
Message-Id: <20220607131427.1164881-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 eric.auger@redhat.com, ricarkol@google.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

This is a followup from [1], which aims at fixing userspace access to
interrupt pending state for HW interrupts.

* From v1 [1]:
  - Keep some of the GICv3-specifics around to avoid regressing the
    line vs latch distinction (Eric).

[1] https://lore.kernel.org/r/20220602083025.1110433-1-maz@kernel.org

Marc Zyngier (3):
  KVM: arm64: Don't read a HW interrupt pending state in user context
  KVM: arm64: Replace vgic_v3_uaccess_read_pending with
    vgic_uaccess_read_pending
  KVM: arm64: Warn if accessing timer pending state outside of vcpu
    context

 arch/arm64/kvm/arch_timer.c        |  3 +++
 arch/arm64/kvm/vgic/vgic-mmio-v2.c |  4 +--
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 40 ++----------------------------
 arch/arm64/kvm/vgic/vgic-mmio.c    | 40 +++++++++++++++++++++++++++---
 arch/arm64/kvm/vgic/vgic-mmio.h    |  3 +++
 5 files changed, 46 insertions(+), 44 deletions(-)

-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
