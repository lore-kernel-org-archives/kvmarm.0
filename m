Return-Path: <SRS0=yTkG=SO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32804C282CE
	for <kvmarm@archiver.kernel.org>; Fri, 12 Apr 2019 16:28:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A93ED21872
	for <kvmarm@archiver.kernel.org>; Fri, 12 Apr 2019 16:28:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A93ED21872
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 096DE4A4BB;
	Fri, 12 Apr 2019 12:28:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hns7FKiI9JmI; Fri, 12 Apr 2019 12:28:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C51534A4B9;
	Fri, 12 Apr 2019 12:28:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CBF14A4B9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Apr 2019 12:28:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zUkRKlGj-FYb for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Apr 2019 12:28:25 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB3404A47E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Apr 2019 12:28:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EBAF915AB;
 Fri, 12 Apr 2019 09:28:24 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D022B3F718;
 Fri, 12 Apr 2019 09:28:22 -0700 (PDT)
From: Dave Martin <Dave.Martin@arm.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 00/14] KVM: arm64: SVE cleanups
Date: Fri, 12 Apr 2019 17:28:04 +0100
Message-Id: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
X-Mailer: git-send-email 2.1.4
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>,
 Christoffer Dall <cdall@kernel.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190412162804.Ps_l1nyPz-jA-no-1gHnnTxZddOz9fw2Cmd6Iva8nQI@z>

This series contains some cleanups applicable to the SVE KVM support
patches merged into kvmarm/next.  These arose from Andrew Jones'
review.

Apart from some minor changes to error codes and checking, these are
mostly cosmetic / sytlistic changes only.

Although straightforward, these changes have not been tested yet:
I'm posting them now so that reviewers can make a start on them.

The patches are based on
git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
5d8d4af24460 ("arm64: KVM: Fix system register enumeration")

This series in git:
git://linux-arm.org/linux-dm.git sve-kvm-fixes/v1/head
http://linux-arm.org/git?p=linux-dm.git;a=shortlog;h=refs/heads/sve-kvm-fixes/v1/head

Dave Martin (14):
  arm64/sve: Clarify vq map semantics
  KVM: arm/arm64: Demote kvm_arm_init_arch_resources() to just set up
    SVE
  KVM: arm: Make vcpu finalization stubs into inline functions
  KVM: arm64/sve: sys_regs: Demote redundant vcpu_has_sve() checks to
    WARNs
  KVM: arm64/sve: Clean up UAPI register ID definitions
  KVM: arm64/sve: Miscellaneous tidyups in guest.c
  KVM: arm64/sve: Make register ioctl access errors more consistent
  KVM: arm64/sve: WARN when avoiding divide-by-zero in
    sve_reg_to_region()
  KVM: arm64/sve: Simplify KVM_REG_ARM64_SVE_VLS array sizing
  KVM: arm64/sve: Explain validity checks in set_sve_vls()
  KVM: arm/arm64: Clean up vcpu finalization function parameter naming
  KVM: Clarify capability requirements for KVM_ARM_VCPU_FINALIZE
  KVM: Clarify KVM_{SET,GET}_ONE_REG error code documentation
  KVM: arm64: Clarify access behaviour for out-of-range SVE register
    slice IDs

 Documentation/virtual/kvm/api.txt | 24 ++++++-----
 arch/arm/include/asm/kvm_host.h   | 13 ++++--
 arch/arm64/include/asm/fpsimd.h   |  4 --
 arch/arm64/include/asm/kvm_host.h |  4 +-
 arch/arm64/include/uapi/asm/kvm.h | 32 ++++++++++----
 arch/arm64/kernel/fpsimd.c        |  7 ++-
 arch/arm64/kvm/guest.c            | 91 +++++++++++++++++++++++----------------
 arch/arm64/kvm/reset.c            |  6 +--
 arch/arm64/kvm/sys_regs.c         |  4 +-
 virt/kvm/arm/arm.c                |  2 +-
 10 files changed, 116 insertions(+), 71 deletions(-)

-- 
2.1.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
