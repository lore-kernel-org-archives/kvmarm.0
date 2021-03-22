Return-Path: <SRS0=gWTa=IU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F39FC433C1
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 16:48:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 422296199E
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 16:48:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 422296199E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E54524B377;
	Mon, 22 Mar 2021 12:48:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vc26ZnPlt9QS; Mon, 22 Mar 2021 12:48:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE58F4B380;
	Mon, 22 Mar 2021 12:48:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC54E4B2DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 12:48:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bSPXFS5B1RaA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 12:48:38 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E25004B35B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 12:48:37 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3183460249;
 Mon, 22 Mar 2021 16:48:35 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lONjF-0037Ov-1u; Mon, 22 Mar 2021 16:48:33 +0000
From: Marc Zyngier <maz@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: [PATCH 0/3] KVM:arm64: Proposed host stage-2 improvements
Date: Mon, 22 Mar 2021 16:48:25 +0000
Message-Id: <20210322164828.800662-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: qperret@google.com, catalin.marinas@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu, tabba@google.com,
 ardb@kernel.org, mark.rutland@arm.com, dbrazdil@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 tabba@google.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, seanjc@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

Hi all,

Since Quentin's series is pretty close to final, I though that instead
of asking for additional rework, I'd have a go at it myself. These
patches try to bring some simplifications to the cpufeature
duplication that has been introduced between EL1 and EL2.

This whole infrastructure exists for a single reason: making the
*sanitised* versions of ID_AA64MMFR{0,1}_EL1 available to EL2. On top
of that, the read_ctr macro gets in the way as it needs direct access
to arm64_ftr_reg_ctrel0 to cope with ARM64_MISMATCHED_CACHE_TYPE.

This series tackles the latest point first by taking advantage of the
fact that with pKVM enabled, late CPUs aren't allowed to boot, and
thus that we know the final CTR_EL0 value before KVM starts, no matter
whether there is a mismatch or not. We can thus specialise read_ctr to
do the right thing without requiring access to the EL1 data structure.

Once that's sorted, we can easily simplify the whole infrastructure to
only snapshot the two u64 we need before enabling the protected mode.

Tested on a Synquacer system.

	M.

Marc Zyngier (3):
  KVM: arm64: Constraint KVM's own __flush_dcache_area to protectected
    mode
  KVM: arm64: Generate final CTR_EL0 value when running in Protected
    mode
  KVM: arm64: Drop the CPU_FTR_REG_HYP_COPY infrastructure

 arch/arm64/include/asm/assembler.h      |  9 +++++++++
 arch/arm64/include/asm/cpufeature.h     |  1 -
 arch/arm64/include/asm/kvm_cpufeature.h | 26 -------------------------
 arch/arm64/include/asm/kvm_host.h       |  4 ----
 arch/arm64/include/asm/kvm_hyp.h        |  3 +++
 arch/arm64/kernel/cpufeature.c          | 13 -------------
 arch/arm64/kernel/image-vars.h          |  1 +
 arch/arm64/kvm/hyp/nvhe/cache.S         |  4 ++++
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c       |  6 ++----
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   |  5 ++---
 arch/arm64/kvm/sys_regs.c               | 23 ++--------------------
 arch/arm64/kvm/va_layout.c              |  7 +++++++
 12 files changed, 30 insertions(+), 72 deletions(-)
 delete mode 100644 arch/arm64/include/asm/kvm_cpufeature.h

-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
