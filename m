Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF046C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 15:20:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 442B14C50B;
	Thu, 14 Jul 2022 11:20:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zYa7PIqtWGxE; Thu, 14 Jul 2022 11:20:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6545A4C5D6;
	Thu, 14 Jul 2022 11:20:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E93F14C58D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:20:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U6wJEwgagOQI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 11:20:32 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7010E4C543
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:20:32 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 2D77EB82158;
 Thu, 14 Jul 2022 15:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70BEC34114;
 Thu, 14 Jul 2022 15:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657812029;
 bh=O+DzKy3vH5wgni9pdJfjy1s/K44JgKQHToBieSDINlw=;
 h=From:To:Cc:Subject:Date:From;
 b=U2ImmNPRvrXK6TyX0bwS69tnLDZqEkkqTbHE6cFDDXmQPwayZUku9DPWQnIZh1BsS
 DdZoEEldU2Iw6KKQrtR1GbF8pO+YzQGs24cOoPtWA4K9sjwoqlk1ZGudG8jOiw8BKh
 nVeHch+FpPZbvdDVJrcLNqQ/7p7DRviMCVGOAItTefhUFsN7N5U6nkQNCk9ZsPvYh3
 Csck7x/BX/aGG6WB4JnzxaGt7CYi9kijGOOv1WQbJMIXaoZt4rlccRqq+Gt3GUHD/I
 jC/CXe4k0Y0O0v3AcMgIYflcdjnd/30bZQ9VGfVLQSuLu3ru149UdA8FYNuAmYqjeo
 2d8B4nQoBNkxA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oC0df-007UVL-Gs;
 Thu, 14 Jul 2022 16:20:27 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 00/20] KVM: arm64: vgic-v3 userspace access consolidation
 (and other goodies)
Date: Thu, 14 Jul 2022 16:20:04 +0100
Message-Id: <20220714152024.1673368-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 reijiw@google.com, schspa@gmail.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Schspa Shi <schspa@gmail.com>, kernel-team@android.com,
 Oliver Upton <oliver.upton@linux.dev>
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

This is a follow-up to [1], which aims a performing a bunch of
cleanups in the way we expose sysregs to userspace, with a particular
focus on the GICv3 part of that code.

* From v1:
  - A couple of extra cleanups thanks to Reiji's comments
  - A fix for the breakage of the legacy GICv2 address setup
  - Collected RBs from Reiji and Oliver, with thanks.

[1] https://lore.kernel.org/r/20220706164304.1582687-1-maz@kernel.org

Marc Zyngier (20):
  KVM: arm64: Add get_reg_by_id() as a sys_reg_desc retrieving helper
  KVM: arm64: Reorder handling of invariant sysregs from userspace
  KVM: arm64: Introduce generic get_user/set_user helpers for system
    registers
  KVM: arm64: Rely on index_to_param() for size checks on userspace
    access
  KVM: arm64: Consolidate sysreg userspace accesses
  KVM: arm64: Get rid of reg_from/to_user()
  KVM: arm64: vgic-v3: Simplify vgic_v3_has_cpu_sysregs_attr()
  KVM: arm64: vgic-v3: Push user access into
    vgic_v3_cpu_sysregs_uaccess()
  KVM: arm64: vgic-v3: Make the userspace accessors use sysreg API
  KVM: arm64: vgic-v3: Convert userspace accessors over to
    FIELD_GET/FIELD_PREP
  KVM: arm64: vgic-v3: Use u32 to manage the line level from userspace
  KVM: arm64: vgic-v3: Consolidate userspace access for MMIO registers
  KVM: arm64: vgic-v2: Consolidate userspace access for MMIO registers
  KVM: arm64: vgic: Use {get,put}_user() instead of copy_{from.to}_user
  KVM: arm64: vgic-v2: Add helper for legacy dist/cpuif base address
    setting
  KVM: arm64: vgic: Consolidate userspace access for base address
    setting
  KVM: arm64: vgic: Tidy-up calls to vgic_{get,set}_common_attr()
  KVM: arm64: Get rid of find_reg_by_id()
  KVM: arm64: Descope kvm_arm_sys_reg_{get,set}_reg()
  KVM: arm64: Get rid or outdated comments

 arch/arm64/include/asm/kvm_host.h     |   2 -
 arch/arm64/kvm/arm.c                  |  11 +-
 arch/arm64/kvm/sys_regs.c             | 282 +++++++---------
 arch/arm64/kvm/sys_regs.h             |  18 +-
 arch/arm64/kvm/vgic-sys-reg-v3.c      | 462 +++++++++++++++-----------
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 342 ++++++++-----------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    |  10 +-
 arch/arm64/kvm/vgic/vgic-mmio.c       |   6 +-
 arch/arm64/kvm/vgic/vgic-mmio.h       |   4 +-
 arch/arm64/kvm/vgic/vgic.h            |   9 +-
 include/kvm/arm_vgic.h                |   2 +-
 11 files changed, 547 insertions(+), 601 deletions(-)

-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
