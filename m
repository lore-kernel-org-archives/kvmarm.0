Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,RCVD_DOTEDU_SUSP,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4440EC4363A
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 15:57:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9299622409
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 15:57:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9299622409
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B38F84B4F8;
	Mon, 26 Oct 2020 11:57:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fQEx+PsFdcUb; Mon, 26 Oct 2020 11:57:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACBD84B4FE;
	Mon, 26 Oct 2020 11:57:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 068EC4B4F6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 11:57:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uasoj0WlNksy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 11:57:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FA704B4D9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 11:57:40 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E5F11042;
 Mon, 26 Oct 2020 08:57:40 -0700 (PDT)
Received: from e112269-lin.arm.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7EC673F719;
 Mon, 26 Oct 2020 08:57:37 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v4 0/2] MTE support for KVM guest
Date: Mon, 26 Oct 2020 15:57:25 +0000
Message-Id: <20201026155727.36685-1-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Dave Martin <Dave.Martin@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Steven Price <steven.price@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
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

This series adds support for Arm's Memory Tagging Extension (MTE) to
KVM, allowing KVM guests to make use of it. This builds on the existing
user space support already in v5.10-rc1, see [1] for an overview.

[1] https://lwn.net/Articles/834289/

Changes since v3[2]:

 * Rebased on v5.10-rc1 (required updating KVM_CAP number).

 * Clarified redundant test for system_supports_mte() with a comment.

 * Added Reviewed-by tags from Andrew - thanks!

[2] https://lore.kernel.org/r/20200925093607.3051-1-steven.price%40arm.com

Haibo plans to start looking at the QEMU support for this. I believe
what is in this series should be sufficient, but there is still some
concern that we need more kernel support for easily accessing the tags
for migrating the VM. I don't expect any extra support to change the
interfaces defined here, but rather build on them. My only reservation
would be whether we want to expose the KVM_CAP before everything is
ready.

Steven Price (2):
  arm64: kvm: Save/restore MTE registers
  arm64: kvm: Introduce MTE VCPU feature

 arch/arm64/include/asm/kvm_emulate.h       |  3 +++
 arch/arm64/include/asm/kvm_host.h          |  7 +++++++
 arch/arm64/include/asm/sysreg.h            |  3 ++-
 arch/arm64/kvm/arm.c                       |  9 +++++++++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 14 ++++++++++++++
 arch/arm64/kvm/mmu.c                       | 20 ++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c                  | 20 +++++++++++++++-----
 include/uapi/linux/kvm.h                   |  1 +
 8 files changed, 71 insertions(+), 6 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
