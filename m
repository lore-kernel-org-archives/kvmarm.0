Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D02A9C433DB
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 18:53:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1CA5D650A8
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 18:53:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CA5D650A8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ABC84B6D4;
	Fri,  5 Mar 2021 13:53:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wak+if-IGqDH; Fri,  5 Mar 2021 13:53:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FD9B4B6DD;
	Fri,  5 Mar 2021 13:53:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFB3F4B6D0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 13:53:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 42ptvtYUFYs3 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Mar 2021 13:53:01 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE5594B52E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 13:53:01 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9478A65090;
 Fri,  5 Mar 2021 18:53:00 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lIFZK-00HYFA-HR; Fri, 05 Mar 2021 18:52:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 0/8] KVM/arm64 fixes for 5.12, take #1
Date: Fri,  5 Mar 2021 18:52:46 +0000
Message-Id: <20210305185254.3730990-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <87eegtzbch.wl-maz@kernel.org>
References: <87eegtzbch.wl-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 andre.przywara@arm.com, ascull@google.com, catalin.marinas@arm.com,
 christoffer.dall@arm.com, Howard.Zhang@arm.com, justin.he@arm.com,
 mark.rutland@arm.com, qperret@google.com, shameerali.kolothum.thodi@huawei.com,
 suzuki.poulose@arm.com, will@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Jia He <justin.he@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 Howard Zhang <Howard.Zhang@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Here's the first batch of fixes for 5.12. We have a handful of low
level world-switch regressions, a page table walker fix, more PMU
tidying up, and a workaround for systems with creative firmware.

This will need to go on top of the current state of mainline.

Please apply,

	M.

Andrew Scull (1):
      KVM: arm64: Fix nVHE hyp panic host context restore

Jia He (1):
      KVM: arm64: Fix range alignment when walking page tables

Marc Zyngier (4):
      KVM: arm64: Turn kvm_arm_support_pmu_v3() into a static key
      KVM: arm64: Don't access PMSELR_EL0/PMUSERENR_EL0 when no PMU is available
      KVM: arm64: Rename __vgic_v3_get_ich_vtr_el2() to __vgic_v3_get_gic_config()
      KVM: arm64: Workaround firmware wrongly advertising GICv2-on-v3 compatibility

Suzuki K Poulose (1):
      KVM: arm64: nvhe: Save the SPE context early

Will Deacon (1):
      KVM: arm64: Avoid corrupting vCPU context register in guest exit

 arch/arm64/include/asm/kvm_asm.h        |  4 ++--
 arch/arm64/include/asm/kvm_hyp.h        |  8 ++++++-
 arch/arm64/kernel/image-vars.h          |  3 +++
 arch/arm64/kvm/hyp/entry.S              |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  9 +++++---
 arch/arm64/kvm/hyp/nvhe/debug-sr.c      | 12 ++++++++--
 arch/arm64/kvm/hyp/nvhe/host.S          | 15 +++++++------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  6 ++---
 arch/arm64/kvm/hyp/nvhe/switch.c        | 14 +++++++++---
 arch/arm64/kvm/hyp/pgtable.c            |  1 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c         | 40 +++++++++++++++++++++++++++++++--
 arch/arm64/kvm/perf.c                   | 10 +++++++++
 arch/arm64/kvm/pmu-emul.c               | 10 ---------
 arch/arm64/kvm/vgic/vgic-v3.c           | 12 +++++++---
 include/kvm/arm_pmu.h                   |  9 ++++++--
 15 files changed, 116 insertions(+), 39 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
