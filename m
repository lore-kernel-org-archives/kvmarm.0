Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1BE9C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 12 Apr 2022 13:14:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 453B14B2C3;
	Tue, 12 Apr 2022 09:14:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Sy+QVN18XXBz; Tue, 12 Apr 2022 09:14:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91F344B2C6;
	Tue, 12 Apr 2022 09:14:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44D334B285
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:13:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f9ZadW6mWOoG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2022 09:13:56 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D7404B284
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:13:56 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D4354B81D75;
 Tue, 12 Apr 2022 13:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766A5C385A5;
 Tue, 12 Apr 2022 13:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649769233;
 bh=3RoMGxcoj6ldO5clo4J4GuibpjgvSYGpjgzHSrg9Xfk=;
 h=From:To:Cc:Subject:Date:From;
 b=Lnh5aQWvNYQHxAKP1r6WsxA9f0WBWqBHazaF1W6rRIuIKGqYgcIICYIYL8DDoKjJA
 tOFmaVpsmHxoPYni3VCox96Dt7wkieKyGMPHIlFyUZRaSEwyfctKMYctbj3DNreZmL
 32b7YzLZtNhPGSo67xt6vkAvsHhjYJtqw5MY2bNUeDjrWaUvVzV2V5YKjFSaoYX7fm
 IW2lgRUEXiuPBILRE74o9VjafLEx24//QrNoUDbpZHP3vQnG80d/A01WHIY1qHZiNO
 +lRC2M5Bnd3cD0d660fqs/lgTChMhxikEV4tbVlwGhrFcNZuWgqsjaDNVzfgyo1PLb
 3HFj9UoNktOzw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1neGL9-003mvX-2I; Tue, 12 Apr 2022 14:13:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 00/10] arm64: Add initial support for FEAT_WFxT
Date: Tue, 12 Apr 2022 14:12:53 +0100
Message-Id: <20220412131303.504690-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com,
 will@kernel.org, mark.rutland@arm.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
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

The ARMv8.7 WFxT feature is a new take on the good old WFI/WFE
instructions as they behave the same way, only taking an extra timeout
parameter.

This small series aims at adding the minimal support for this feature,
enabling it for both the kernel and KVM.

A potential addition to this series would be to remove the event
generation from the counters, and rely on the timeout where it
matters (spinlocks?). Feedback welcome.

Patches on top of 5.18-rc2, tested of the FVP AEM.

Marc Zyngier (10):
  arm64: Expand ESR_ELx_WFx_ISS_TI to match its ARMv8.7 definition
  arm64: Add RV and RN fields for ESR_ELx_WFx_ISS
  KVM: arm64: Simplify kvm_cpu_has_pending_timer()
  KVM: arm64: Introduce kvm_counter_compute_delta() helper
  KVM: arm64: Handle blocking WFIT instruction
  KVM: arm64: Offer early resume for non-blocking WFxT instructions
  KVM: arm64: Expose the WFXT feature to guests
  arm64: Add HWCAP advertising FEAT_WFXT
  arm64: Add wfet()/wfit() helpers
  arm64: Use WFxT for __delay() when possible

 Documentation/arm64/cpu-feature-registers.rst |  2 +
 Documentation/arm64/elf_hwcaps.rst            |  4 ++
 arch/arm64/include/asm/barrier.h              |  4 ++
 arch/arm64/include/asm/esr.h                  |  8 +++-
 arch/arm64/include/asm/hwcap.h                |  1 +
 arch/arm64/include/asm/kvm_host.h             |  1 +
 arch/arm64/include/uapi/asm/hwcap.h           |  1 +
 arch/arm64/kernel/cpufeature.c                | 13 +++++
 arch/arm64/kernel/cpuinfo.c                   |  1 +
 arch/arm64/kvm/arch_timer.c                   | 47 ++++++++++++-------
 arch/arm64/kvm/arm.c                          |  6 +--
 arch/arm64/kvm/handle_exit.c                  | 30 ++++++++++--
 arch/arm64/kvm/sys_regs.c                     |  2 +
 arch/arm64/lib/delay.c                        | 12 ++++-
 arch/arm64/tools/cpucaps                      |  1 +
 include/kvm/arm_arch_timer.h                  |  2 -
 16 files changed, 106 insertions(+), 29 deletions(-)

-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
