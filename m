Return-Path: <SRS0=PgOR=PF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F52C433EF
	for <kvmarm@archiver.kernel.org>; Sun, 17 Oct 2021 10:21:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2F54261246
	for <kvmarm@archiver.kernel.org>; Sun, 17 Oct 2021 10:21:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2F54261246
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D335D4B133;
	Sun, 17 Oct 2021 06:21:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YISHDLNA4pKj; Sun, 17 Oct 2021 06:21:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF5134B13A;
	Sun, 17 Oct 2021 06:21:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CAD94B136
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Oct 2021 06:20:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OBD+gXTiymMs for <kvmarm@lists.cs.columbia.edu>;
 Sun, 17 Oct 2021 06:20:58 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 717D94B0BA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Oct 2021 06:20:58 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A96F961179;
 Sun, 17 Oct 2021 10:20:57 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mc3Hj-00HJDf-3l; Sun, 17 Oct 2021 11:20:55 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andrew Jones <drjones@redhat.com>,
 Raghavendra Rao Ananta <rananta@google.com>,
 James Morse <james.morse@arm.com>
Subject: Re: [PATCH v8 00/15] KVM: arm64: selftests: Introduce arch_timer
 selftest
Date: Sun, 17 Oct 2021 11:20:52 +0100
Message-Id: <163446603339.1611630.4034254294571112301.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007233439.1826892-1-rananta@google.com>
References: <20211007233439.1826892-1-rananta@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, drjones@redhat.com, rananta@google.com,
 james.morse@arm.com, kvm@vger.kernel.org, pshier@google.com,
 linux-kernel@vger.kernel.org, oupton@google.com, catalin.marinas@arm.com,
 ricarkol@google.com, will@kernel.org, jingzhangos@google.com,
 kvmarm@lists.cs.columbia.edu, reijiw@google.com,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Thu, 7 Oct 2021 23:34:24 +0000, Raghavendra Rao Ananta wrote:
> The patch series adds a KVM selftest to validate the behavior of
> ARM's generic timer (patch-14). The test programs the timer IRQs
> periodically, and for each interrupt, it validates the behaviour
> against the architecture specifications. The test further provides
> a command-line interface to configure the number of vCPUs, the
> period of the timer, and the number of iterations that the test
> has to run for.
> 
> [...]

Applied to next, thanks!

[01/15] KVM: arm64: selftests: Add MMIO readl/writel support
        commit: 88ec7e258b70eed5e532d32115fccd11ea2a6287
[02/15] tools: arm64: Import sysreg.h
        commit: 272a067df3c89f6f2176a350f88661625a2c8b3b
[03/15] KVM: arm64: selftests: Use read/write definitions from sysreg.h
        commit: 272a067df3c89f6f2176a350f88661625a2c8b3b
[04/15] KVM: arm64: selftests: Introduce ARM64_SYS_KVM_REG
        commit: b3c79c6130bcfdb0ff3819077deaddce981a0718
[05/15] KVM: arm64: selftests: Add support for cpu_relax
        commit: 740826ec02a65a5b25335fddfe8bce4ac99c7a11
[06/15] KVM: arm64: selftests: Add basic support for arch_timers
        commit: d977ed39940231839f6856637fe24f41860f7969
[07/15] KVM: arm64: selftests: Add basic support to generate delays
        commit: 80166904655976bb9babc48fd283c2bba5799920
[08/15] KVM: arm64: selftests: Add support to disable and enable local IRQs
        commit: 5c636d585cfd0d01a89b18fced77a07ab2ef386a
[09/15] KVM: arm64: selftests: Maintain consistency for vcpuid type
        commit: 0226cd531c587e0cd51e5ce5622051d319182506
[10/15] KVM: arm64: selftests: Add guest support to get the vcpuid
        commit: 17229bdc86c9e618e8832b5ca8451e367e07511b
[11/15] KVM: arm64: selftests: Add light-weight spinlock support
        commit: 414de89df1ec453ff4adb9d77ffd596096cb44bd
[12/15] KVM: arm64: selftests: Add basic GICv3 support
        commit: 28281652f90acc138f8b4bae8a3bf8cf1ce0d29e
[13/15] KVM: arm64: selftests: Add host support for vGIC
        commit: 250b8d6cb3b0312341304fa323b82355d656c018
[14/15] KVM: arm64: selftests: Add arch_timer test
        commit: 4959d8650e9f4095a5df6e578377d850f1b94d2f
[15/15] KVM: arm64: selftests: arch_timer: Support vCPU migration
        commit: 61f6fadbf9bd6694c72e40d9fa186ceff730ef33

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
