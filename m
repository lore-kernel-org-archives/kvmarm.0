Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,RCVD_DOTEDU_SUSP,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCCDEC4363A
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 13:35:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 34A2524670
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 13:35:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="P2JyzTfw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 34A2524670
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D1FA4B505;
	Mon, 26 Oct 2020 09:35:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RIqCSf54Q+lH; Mon, 26 Oct 2020 09:35:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 105314B4FB;
	Mon, 26 Oct 2020 09:35:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74AAB4B4E4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 09:35:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QXvoX+JQdeXx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 09:35:03 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 242024B39A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 09:35:03 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D07C022284;
 Mon, 26 Oct 2020 13:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603719302;
 bh=/7647TEuJSHw4E0GvVdhCJh7X525DLpULuJ4YUPi0HA=;
 h=From:To:Cc:Subject:Date:From;
 b=P2JyzTfwMKv3olGS4DmfWIGe7kgr9IT+Qx8REIzDOqD3kshQn02RYYPtNwEOKijPs
 K2Ef+WDySF7y/YaNNapyu4bbg8zXFbhnSWPloNGBQXG4rFqUVxPWwDzn4bHRiBRLWG
 mD5lZCio6b9mgniKGuDUBbH6hgpfq0Kj/wjfHn68=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kX2eJ-004Kjh-Nx; Mon, 26 Oct 2020 13:34:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 00/11] KVM: arm64: Move PC/ELR/SPSR/PSTATE updatess to EL2
Date: Mon, 26 Oct 2020 13:34:39 +0000
Message-Id: <20201026133450.73304-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com,
 will@kernel.org, qperret@google.com, dbrazdil@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>
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

As we progress towards being able to keep the guest state private to
the nVHE hypervisor, this series aims at moving anything that touches
the registers involved into an exception to EL2.

The general idea is that any update to these registers is driven by a
set of flags passed from EL1 to EL2, and EL2 will deal with the
register update itself, removing the need for EL1 to see the guest
state. It also results in a bunch of cleanup, mostly in the 32bit
department (negative diffstat, yay!).

Of course, none of that has any real effect on security yet. It is
only once we start having a private VCPU structure at EL2 that we can
enforce the isolation. Similarly, there is no policy enforcement, and
a malicious EL1 can still inject exceptions at random points. It can
also give bogus ESR values to the guest. Baby steps.

        M.

Marc Zyngier (11):
  KVM: arm64: Don't adjust PC on SError during SMC trap
  KVM: arm64: Move kvm_vcpu_trap_il_is32bit into kvm_skip_instr32()
  KVM: arm64: Make kvm_skip_instr() and co private to HYP
  KVM: arm64: Move PC rollback on SError to HYP
  KVM: arm64: Move VHE direct sysreg accessors into kvm_host.h
  KVM: arm64: Add basic hooks for injecting exceptions from EL2
  KVM: arm64: Inject AArch64 exceptions from HYP
  KVM: arm64: Inject AArch32 exceptions from HYP
  KVM: arm64: Remove SPSR manipulation primitives
  KVM: arm64: Consolidate exception injection
  KVM: arm64: Get rid of the AArch32 register mapping code

 arch/arm64/include/asm/kvm_emulate.h       |  70 +---
 arch/arm64/include/asm/kvm_host.h          | 115 ++++++-
 arch/arm64/kvm/Makefile                    |   4 +-
 arch/arm64/kvm/aarch32.c                   | 232 -------------
 arch/arm64/kvm/guest.c                     |  28 +-
 arch/arm64/kvm/handle_exit.c               |  23 +-
 arch/arm64/kvm/hyp/aarch32.c               |   4 +-
 arch/arm64/kvm/hyp/exception.c             | 368 +++++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h |  62 ++++
 arch/arm64/kvm/hyp/include/hyp/switch.h    |  17 +
 arch/arm64/kvm/hyp/nvhe/Makefile           |   2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c           |   3 +
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c   |   2 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c            |   2 +
 arch/arm64/kvm/hyp/vhe/Makefile            |   2 +-
 arch/arm64/kvm/hyp/vhe/switch.c            |   3 +
 arch/arm64/kvm/inject_fault.c              | 187 +++++------
 arch/arm64/kvm/mmio.c                      |   2 +-
 arch/arm64/kvm/mmu.c                       |   2 +-
 arch/arm64/kvm/regmap.c                    | 224 -------------
 arch/arm64/kvm/sys_regs.c                  |  83 +----
 21 files changed, 698 insertions(+), 737 deletions(-)
 delete mode 100644 arch/arm64/kvm/aarch32.c
 create mode 100644 arch/arm64/kvm/hyp/exception.c
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
 delete mode 100644 arch/arm64/kvm/regmap.c

-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
