Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAEAAC43334
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jun 2022 09:29:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 619004B328;
	Fri, 10 Jun 2022 05:29:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IbcSwOWICGmP; Fri, 10 Jun 2022 05:29:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28D2C4B409;
	Fri, 10 Jun 2022 05:29:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 487974B3BF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 05:29:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4-0ONLLapkb4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jun 2022 05:28:59 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2E374B3BD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 05:28:58 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 58E01B8330A;
 Fri, 10 Jun 2022 09:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D61C3411C;
 Fri, 10 Jun 2022 09:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654853336;
 bh=9xlTmpw6VCBquLaHKLCQgiSt5ejkuxi8SpUrfQnqz1Q=;
 h=From:To:Cc:Subject:Date:From;
 b=Yuok9PB4bITWSWXrGjUsnFLgfMUo7ygh8Ir/LxJWiRUpN052A6cxiFV9KoTDx0R/d
 JvpkyZIaLlcu8FA90oL/c1gjpKZ7wghWqshiGVH0M/xt4V5GAqnvRif87mLq5Q8ACg
 HPXOQAfsvZiEt2nSb4qLpnJIKb6ZGbBYk1WNQNYyVA+7UpjFwZPbJXv1PClF/rKOFg
 PK6BPxk+5cNDhOpujYn1d33Io30s4h8DWC4PbZjHGLfjhn9rDsj7Fd4/ZioEuKg4Kp
 xOZ//QGdNC/3ihQX3thCaJmXUBio95JndO4e/+wNosvaLhh3HcCIYqEeQU9tLsk9jE
 1eLrYb38850Jw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nzawn-00H6Dt-HJ; Fri, 10 Jun 2022 10:28:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 00/19] KVM/arm64: Refactoring the vcpu flags
Date: Fri, 10 Jun 2022 10:28:19 +0100
Message-Id: <20220610092838.1205755-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com,
 will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org,
 reijiw@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>
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

This is a iteration on [1], which aims at making the vcpu flags suck a
bit less.

* From v1 [1]:
  - Rebased onto v5.19-rc1
  - Took the first two patches into kvmarm-fixes, included here for
    completeness
  - Additional patch to move system_supports_fpsimd() outside of
    the run path (Reiji)
  - Expanded on comments (Reiji)
  - New kvm_pend_exception() accessor (Fuad)
  - Various bracketing fixups (Reiji)
  - Some renaming (Reiji, Broonie)
  - Collected RBs, with thanks

[1] https://lore.kernel.org/r/20220528113829.1043361-1-maz@kernel.org

Marc Zyngier (19):
  KVM: arm64: Always start with clearing SVE flag on load
  KVM: arm64: Always start with clearing SME flag on load
  KVM: arm64: Drop FP_FOREIGN_STATE from the hypervisor code
  KVM: arm64: Move FP state ownership from flag to a tristate
  KVM: arm64: Add helpers to manipulate vcpu flags among a set
  KVM: arm64: Add three sets of flags to the vcpu state
  KVM: arm64: Move vcpu configuration flags into their own set
  KVM: arm64: Move vcpu PC/Exception flags to the input flag set
  KVM: arm64: Move vcpu debug/SPE/TRBE flags to the input flag set
  KVM: arm64: Move vcpu SVE/SME flags to the state flag set
  KVM: arm64: Move vcpu ON_UNSUPPORTED_CPU flag to the state flag set
  KVM: arm64: Move vcpu WFIT flag to the state flag set
  KVM: arm64: Kill unused vcpu flags field
  KVM: arm64: Convert vcpu sysregs_loaded_on_cpu to a state flag
  KVM: arm64: Warn when PENDING_EXCEPTION and INCREMENT_PC are set
    together
  KVM: arm64: Add build-time sanity checks for flags
  KVM: arm64: Reduce the size of the vcpu flag members
  KVM: arm64: Document why pause cannot be turned into a flag
  KVM: arm64: Move the handling of !FP outside of the fast path

 arch/arm64/include/asm/kvm_emulate.h       |  11 +-
 arch/arm64/include/asm/kvm_host.h          | 203 +++++++++++++++------
 arch/arm64/kvm/arch_timer.c                |   2 +-
 arch/arm64/kvm/arm.c                       |  12 +-
 arch/arm64/kvm/debug.c                     |  25 ++-
 arch/arm64/kvm/fpsimd.c                    |  37 ++--
 arch/arm64/kvm/handle_exit.c               |   2 +-
 arch/arm64/kvm/hyp/exception.c             |  23 ++-
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h  |   6 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h    |  24 +--
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |   4 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c         |   8 +-
 arch/arm64/kvm/hyp/nvhe/switch.c           |   6 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c         |   4 +-
 arch/arm64/kvm/hyp/vhe/switch.c            |   4 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         |   4 +-
 arch/arm64/kvm/inject_fault.c              |  17 +-
 arch/arm64/kvm/reset.c                     |   6 +-
 arch/arm64/kvm/sys_regs.c                  |  12 +-
 19 files changed, 248 insertions(+), 162 deletions(-)

-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
