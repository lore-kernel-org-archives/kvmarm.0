Return-Path: <SRS0=HiVh=25=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D32C282DD
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jan 2020 13:43:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B0C7206DB
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jan 2020 13:43:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B0C7206DB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 712164AFAC;
	Wed,  8 Jan 2020 08:43:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id enTQVqPEOAIh; Wed,  8 Jan 2020 08:43:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 407604AFAD;
	Wed,  8 Jan 2020 08:43:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FDF74AFAA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jan 2020 08:43:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dJu-XUGgU79L for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jan 2020 08:43:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C2EE4AFA9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jan 2020 08:43:35 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D0DBC31B;
 Wed,  8 Jan 2020 05:43:34 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4A7833F703;
 Wed,  8 Jan 2020 05:43:33 -0800 (PST)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, alexandru.elisei@arm.com
Subject: [PATCHv2 0/3] KVM: arm/arm64: exception injection fixes
Date: Wed,  8 Jan 2020 13:43:21 +0000
Message-Id: <20200108134324.46500-1-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
Cc: stable@vger.kernel.org, will@kernel.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi,

While looking at the KVM code, I realised that our exception injection handling
isn't quite right, as it generates the target PSTATE/CPSR from scratch, and
doesn't handle all bits which need to be (conditionally) cleared or set upon
taking an exception.

The first two patches address this for injecting exceptions into AArch64 and
AArch32 contexts respectively. I've tried to organise the code so that it can
easily be audited against the ARM ARM, and/or extended in future if/when new
bits are added to the SPSRs.

While writing the AArch32 portion I also realised that on an AArch64 host we
don't correctly synthesize the SPSR_{abt,und} seen by the guest, as we copy the
value of SPSR_EL2, and the layouts of those SPSRs differ. The third patch
addresses this by explicitly moving bits into the SPSR_{abt,und} layout.

I'd appreciate any testing people could offer, especially for AArch32 guests
and/or AArch32 hosts, which I'm currently ill equipped to test. Ideally we'd
have some unit tests for this.

These issues don't seem to upset contemporary guests, but they do mean that KVM
isn't providing an architecturally compliant environment in all cases, which is
liable to cause issues in future. Given that, and that the patches are fairly
self-contained, I've marked all three patches for stable.

All three patches can be found on my kvm/exception-state branch [1].

Since v1 [2]:
* Fix host_spsr_to_spsr32() bit preservation
* Fix SPAN polarity; tested with a modified arm64 guest
* Fix DIT preservation on 32-bit hosts
* Add Alex's Reviewed-by to patch 3

Thanks,
Mark.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=kvm/exception-state

Mark Rutland (3):
  KVM: arm64: correct PSTATE on exception entry
  KVM: arm/arm64: correct CPSR on exception entry
  KVM: arm/arm64: correct AArch32 SPSR on exception entry

 arch/arm/include/asm/kvm_emulate.h   |  17 +++++
 arch/arm64/include/asm/kvm_emulate.h |  32 ++++++++++
 arch/arm64/include/asm/ptrace.h      |   1 +
 arch/arm64/include/uapi/asm/ptrace.h |   1 +
 arch/arm64/kvm/inject_fault.c        |  70 +++++++++++++++++++--
 virt/kvm/arm/aarch32.c               | 117 +++++++++++++++++++++++++++++++----
 6 files changed, 220 insertions(+), 18 deletions(-)

-- 
2.11.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
