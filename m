Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F64EC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 12:21:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D97549F13;
	Thu, 27 Jan 2022 07:21:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y9VtBuj-tr1b; Thu, 27 Jan 2022 07:21:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31B9C49F0E;
	Thu, 27 Jan 2022 07:21:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7D3949F07
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 07:21:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bn0cflAMbXG0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 07:21:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F5B449F05
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 07:21:06 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 835B3113E;
 Thu, 27 Jan 2022 04:21:05 -0800 (PST)
Received: from eglon.cambridge.arm.com (unknown [10.1.196.218])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 669513F7D8;
 Thu, 27 Jan 2022 04:21:04 -0800 (PST)
From: James Morse <james.morse@arm.com>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/4] KVM: arm64: A510 errata workaround and fixes for
 fixup_guest_exit()
Date: Thu, 27 Jan 2022 12:20:48 +0000
Message-Id: <20220127122052.1584324-1-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
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

Hello!

Changes since v1:
 * Moved the SPSR_EL2 fixup into a helper called earlier
 * Use final cap
 * Dropped the IS_ENABLED() check

---

Early Cortex-A510 parts have a nasty erratum where two ERETs,
pointer-auth and software step conspire to corrupt SPSR_EL2. A
guest can only trigger this when it is being stepped by EL2, which
gives EL2 the opportunity to work around the erratum. Patch 4 does
this, the SDEN is available from:
https://developer.arm.com/documentation/SDEN2397239/900

Patches 2 and 3 fix two issues with the adjacent code where a stale
esr value could be used to alter the ELR_EL2 when an IRQ synchronises
an SError, and when an HVC synchronises an SError, the HVC may be
handled twice, (not just execute twice).


There are three series that would add the Cortex-A510 part macros. I've picked
Anshuman's patch that does this, on the assumption that makes someone's life
easier. I haven't spotted that patch on the arm64/for-next/fixes branch, so
I've not included the hash in the prerequisite field of the CC-stable.

Let me know if you want this reposted once that value is known.

This series is based on v5.17-rc1 and can be retrieved from:
https://git.gitlab.arm.com/linux-arm/linux-jm.git a510_errata/kvm_bits/v2


Thanks,

James

Anshuman Khandual (1):
  arm64: Add Cortex-A510 CPU part definition

James Morse (3):
  KVM: arm64: Avoid consuming a stale esr value when SError occur
  KVM: arm64: Stop handle_exit() from handling HVC twice when an SError
    occurs
  KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata

 Documentation/arm64/silicon-errata.rst  |  2 ++
 arch/arm64/Kconfig                      | 16 ++++++++++++++++
 arch/arm64/include/asm/cputype.h        |  2 ++
 arch/arm64/kernel/cpu_errata.c          |  8 ++++++++
 arch/arm64/kvm/handle_exit.c            |  8 ++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 23 +++++++++++++++++++++--
 arch/arm64/tools/cpucaps                |  1 +
 7 files changed, 58 insertions(+), 2 deletions(-)

-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
