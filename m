Return-Path: <SRS0=YGC0=PG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29ECCC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 21:12:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 96A516103D
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 21:12:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 96A516103D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 366A54B208;
	Mon, 18 Oct 2021 17:12:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AWBf26RY0-yS; Mon, 18 Oct 2021 17:12:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 437084B1AB;
	Mon, 18 Oct 2021 17:12:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAF7D4B1AD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 17:12:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2Ervlci6mGfd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Oct 2021 17:12:12 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ACEDC4B17C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 17:12:12 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9FE316103D;
 Mon, 18 Oct 2021 21:12:11 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mcZvV-0004Sc-F5; Mon, 18 Oct 2021 22:12:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/5] KVM: arm64: Reorganise vcpu first run
Date: Mon, 18 Oct 2021 22:11:53 +0100
Message-Id: <20211018211158.3050779-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com,
 will@kernel.org, drjones@redhat.com, kernel-team@android.com
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

This is v2 of this series reworking the vcpu first run.

KVM/arm64 relies heavily on a bunch of things to be done on the first
run of the vcpu. We also do a bunch of things on PID change. It turns
out that these two things are pretty similar (the first PID change is
also the first run).

This small series aims at simplifying all that, and to get rid of the
vcpu->arch.has_run_once state. On top of being a decent cleanup, it
also results in a minor performance improvement (my Debian installer
on M1 consistently went from 2:23 down to 2:22, a ~0.6% reduction in
execution time).

* From v1 [1]:
  - Moved the kvm_vcpu_initialized() check into kvm_vcpu_first_run_init()
  - Reorganise the series so that the userspace irqchip static key
    change appears earlier
  - Collected Andrew's RBs

[1] https://lore.kernel/org/r/20211015090822.2994920-1-maz@kernel.org

Marc Zyngier (5):
  KVM: arm64: Move SVE state mapping at HYP to finalize-time
  KVM: arm64: Move kvm_arch_vcpu_run_pid_change() out of line
  KVM: arm64: Restructure the point where has_run_once is advertised
  KVM: arm64: Merge kvm_arch_vcpu_run_pid_change() and
    kvm_vcpu_first_run_init()
  KVM: arm64: Drop vcpu->arch.has_run_once for vcpu->pid

 arch/arm64/include/asm/kvm_host.h | 12 ++-----
 arch/arm64/kvm/arm.c              | 57 +++++++++++++++++--------------
 arch/arm64/kvm/fpsimd.c           | 11 ------
 arch/arm64/kvm/reset.c            | 11 +++++-
 arch/arm64/kvm/vgic/vgic-init.c   |  2 +-
 5 files changed, 46 insertions(+), 47 deletions(-)

-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
