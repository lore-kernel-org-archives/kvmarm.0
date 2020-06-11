Return-Path: <SRS0=vcVD=7Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49960C433E4
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 09:10:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F28B72078D
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 09:10:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="q1kTyCd8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F28B72078D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD96E4B18D;
	Thu, 11 Jun 2020 05:10:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QiLgyXoPf0R3; Thu, 11 Jun 2020 05:10:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDEBB4B1BB;
	Thu, 11 Jun 2020 05:10:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D54A4B1A5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2020 05:10:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yy2FzHQOZUQ1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Jun 2020 05:10:09 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CBD4F4B111
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2020 05:10:09 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A390420760;
 Thu, 11 Jun 2020 09:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1591866608;
 bh=LEb0TmHs9BwF0am32RadcRA4RU0L0oWhcV5wOopAYI8=;
 h=From:To:Cc:Subject:Date:From;
 b=q1kTyCd8T/68YBv3CRIYzkVpMPW1eVFfsQhmwQGWah+mz+QtZQFif1Ws68NKb1Ewv
 5h33hP+50DG851IfhM3j8LD838jhq44IXS+5sTXtxTnDJ4e+bh7XESwG8QuHZGDUJE
 zliMhna5ReRYb8SpviD876yx5zB7YHXzQKgvvrPE=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jjJDr-0022ZT-4w; Thu, 11 Jun 2020 10:10:07 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm64 fixes for 5.8, take #1
Date: Thu, 11 Jun 2020 10:09:45 +0100
Message-Id: <20200611090956.1537104-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 ascull@google.com, james.morse@arm.com, mark.rutland@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Here's a bunch of fixes that cropped up during the merge window,
mostly falling into two categories: 32bit system register accesses,
and 64bit pointer authentication handling.

Please pull,

	M.

The following changes since commit 8f7f4fe756bd5cfef73cf8234445081385bdbf7d:

  KVM: arm64: Drop obsolete comment about sys_reg ordering (2020-05-28 13:16:57 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.8-1

for you to fetch changes up to 15c99816ed9396c548eed2e84f30c14caccad1f4:

  Merge branch 'kvm-arm64/ptrauth-fixes' into kvmarm-master/next (2020-06-10 19:10:40 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for Linux 5.8, take #1

* 32bit VM fixes:
  - Fix embarassing mapping issue between AArch32 CSSELR and AArch64
    ACTLR
  - Add ACTLR2 support for AArch32
  - Get rid of the useless ACTLR_EL1 save/restore
  - Fix CP14/15 accesses for AArch32 guests on BE hosts
  - Ensure that we don't loose any state when injecting a 32bit
    exception when running on a VHE host

* 64bit VM fixes:
  - Fix PtrAuth host saving happening in preemptible contexts
  - Optimize PtrAuth lazy enable
  - Drop vcpu to cpu context pointer
  - Fix sparse warnings for HYP per-CPU accesses

----------------------------------------------------------------
James Morse (3):
      KVM: arm64: Stop writing aarch32's CSSELR into ACTLR
      KVM: arm64: Add emulation for 32bit guests accessing ACTLR2
      KVM: arm64: Stop save/restoring ACTLR_EL1

Marc Zyngier (9):
      KVM: arm64: Flush the instruction cache if not unmapping the VM on reboot
      KVM: arm64: Save the host's PtrAuth keys in non-preemptible context
      KVM: arm64: Handle PtrAuth traps early
      KVM: arm64: Stop sparse from moaning at __hyp_this_cpu_ptr
      KVM: arm64: Remove host_cpu_context member from vcpu structure
      KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts
      KVM: arm64: Synchronize sysreg state on injecting an AArch32 exception
      KVM: arm64: Move hyp_symbol_addr() to kvm_asm.h
      Merge branch 'kvm-arm64/ptrauth-fixes' into kvmarm-master/next

 arch/arm64/include/asm/kvm_asm.h     | 33 ++++++++++++++++--
 arch/arm64/include/asm/kvm_emulate.h |  6 ----
 arch/arm64/include/asm/kvm_host.h    |  9 +++--
 arch/arm64/include/asm/kvm_mmu.h     | 20 -----------
 arch/arm64/kvm/aarch32.c             | 28 ++++++++++++++++
 arch/arm64/kvm/arm.c                 | 20 ++++++-----
 arch/arm64/kvm/handle_exit.c         | 32 ++----------------
 arch/arm64/kvm/hyp/debug-sr.c        |  4 +--
 arch/arm64/kvm/hyp/switch.c          | 65 ++++++++++++++++++++++++++++++++++--
 arch/arm64/kvm/hyp/sysreg-sr.c       |  8 ++---
 arch/arm64/kvm/pmu.c                 |  8 ++---
 arch/arm64/kvm/sys_regs.c            | 25 +++++++-------
 arch/arm64/kvm/sys_regs_generic_v8.c | 10 ++++++
 13 files changed, 171 insertions(+), 97 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
