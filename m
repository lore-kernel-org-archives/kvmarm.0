Return-Path: <SRS0=E56M=ET=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1BD3C61DD8
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 18:26:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 12EDB2222F
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 18:26:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="fTp+FPKB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 12EDB2222F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 845614B615;
	Fri, 13 Nov 2020 13:26:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q4V5DtT6Qt49; Fri, 13 Nov 2020 13:26:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B4C84B6C2;
	Fri, 13 Nov 2020 13:26:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 053264B63F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 13:26:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tui3-Unl7jOz for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Nov 2020 13:26:19 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 09BF74B5DB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 13:26:19 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9A75F206E0;
 Fri, 13 Nov 2020 18:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605291977;
 bh=jlcEFEJGWUtl3jyEnzWstVetGJnJb4qzKEp/RBIjfR0=;
 h=From:To:Cc:Subject:Date:From;
 b=fTp+FPKBhZbEnNNXp+fFOqY3/7ZOuxtKaaJ++58xIcapq8qTdltfZSFYQFcj8iAbB
 TdTkCIedJoPJUOIhMynCmga2jABe9buSfJJlUf7toPa3a3rd6I5mvWSWX85+hXigQN
 9vttp+qV7K3E30vp8KObdHr5lXgbp2BDfaTw6FBE=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kddm3-00APrY-AI; Fri, 13 Nov 2020 18:26:15 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 0/8] KVM: arm64: Disabled PMU handling
Date: Fri, 13 Nov 2020 18:25:54 +0000
Message-Id: <20201113182602.471776-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
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

It recently dawned on me that the way we handle PMU traps when the PMU
is disabled is plain wrong. We consider that handling the registers as
RAZ/WI is a fine thing to do, while the ARMv8 ARM is pretty clear that
that's not OK and that such registers should UNDEF when FEAT_PMUv3
doesn't exist. I went all the way back to the first public version of
the spec, and it turns out we were *always* wrong.

It probably comes from the fact that we used not to trap the ID
registers, and thus were unable to advertise the lack of PMU, but
that's hardly an excuse. So let's fix the damned thing.

This series adds an extra check in the helpers that check for the
validity of the PMU access (most of the registers have to checked
against some enable flags and/or the accessing exception level), and
rids us of the RAZ/WI behaviour.

This enables us to make additional cleanups, to the point where we can
remove the PMU "ready" state that always had very bizarre semantics.
All in all, a negative diffstat, and spec compliant behaviours. What's
not to like?

I've run a few guests with and without PMUs as well as KUT, and
nothing caught fire. The patches are on top of kvmarm/queue.

Marc Zyngier (8):
  KVM: arm64: Add kvm_vcpu_has_pmu() helper
  KVM: arm64: Set ID_AA64DFR0_EL1.PMUVer to 0 when no PMU support
  KVM: arm64: Refuse illegal KVM_ARM_VCPU_PMU_V3 at reset time
  KVM: arm64: Inject UNDEF on PMU access when no PMU configured
  KVM: arm64: Remove PMU RAZ/WI handling
  KVM: arm64: Remove dead PMU sysreg decoding code
  KVM: arm64: Gate kvm_pmu_update_state() on the PMU feature
  KVM: arm64: Get rid of the PMU ready state

 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/pmu-emul.c         | 11 +++----
 arch/arm64/kvm/reset.c            |  4 +++
 arch/arm64/kvm/sys_regs.c         | 51 ++++++++-----------------------
 include/kvm/arm_pmu.h             |  3 --
 5 files changed, 24 insertions(+), 48 deletions(-)

-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
