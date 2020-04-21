Return-Path: <SRS0=wisL=6F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CADB2C54FCC
	for <kvmarm@archiver.kernel.org>; Tue, 21 Apr 2020 14:29:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 56E34206D4
	for <kvmarm@archiver.kernel.org>; Tue, 21 Apr 2020 14:29:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="lzpP1FSG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56E34206D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D52A94B151;
	Tue, 21 Apr 2020 10:29:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9d-RMzB7h3JC; Tue, 21 Apr 2020 10:29:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DE284B13C;
	Tue, 21 Apr 2020 10:29:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F6F24B111
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2020 10:29:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CdJNgKhHfMHv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Apr 2020 10:29:29 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 257DE4B106
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2020 10:29:29 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 03F4F206B8;
 Tue, 21 Apr 2020 14:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587479368;
 bh=s5Sab4jJiJDHJIpjD4RvCm2z34zP3dXNvjG8qk3JShE=;
 h=From:To:Cc:Subject:Date:From;
 b=lzpP1FSGfbR/3p7IVdtgVFBf7t6Kgb/fybDrn+J9ySJZy9hpI+kFaRHIz2yOU8hg2
 iFs6Ze2Hxjz3yyrg2ROMU9YOm0b6kqPKS5d1zkqvyTFq9vAZ4aCtJC4y4oFavDrM7G
 n64/U9FpYOqS9ta9AX9SxGMl0ruF1YCwnqJsD1i8=
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 0/8] Relax sanity checking for mismatched AArch32 EL1
Date: Tue, 21 Apr 2020 15:29:14 +0100
Message-Id: <20200421142922.18950-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
 kernel-team@android.com, Anshuman Khandual <anshuman.khandual@arm.com>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Doug Anderson <dianders@chromium.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

Hi folks,

This is version two of the patches I previously posted here:

	https://lore.kernel.org/lkml/20200414213114.2378-1-will@kernel.org/

Changes since v1 include:

  * Typo fixes
  * Added comment to update_32bit_cpu_features() callsite regarding sanitisation
  * Extended comment in final patch to mention KVM
  * Add acks/tested-bys

Cheers,

Will

Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Cc: Doug Anderson <dianders@chromium.org>
Cc: kernel-team@android.com

--->8

Sai Prakash Ranjan (1):
  arm64: cpufeature: Relax check for IESB support

Will Deacon (7):
  arm64: cpufeature: Spell out register fields for ID_ISAR4 and ID_PFR1
  arm64: cpufeature: Add CPU capability for AArch32 EL1 support
  arm64: cpufeature: Remove redundant call to id_aa64pfr0_32bit_el0()
  arm64: cpufeature: Factor out checking of AArch32 features
  arm64: cpufeature: Relax AArch32 system checks if EL1 is 64-bit only
  arm64: cpufeature: Relax checks for AArch32 support at EL[0-2]
  arm64: cpufeature: Add an overview comment for the cpufeature
    framework

 arch/arm64/include/asm/cpucaps.h    |   3 +-
 arch/arm64/include/asm/cpufeature.h |   7 +
 arch/arm64/include/asm/sysreg.h     |  18 ++
 arch/arm64/kernel/cpufeature.c      | 247 +++++++++++++++++++++-------
 arch/arm64/kvm/reset.c              |  12 +-
 5 files changed, 217 insertions(+), 70 deletions(-)

-- 
2.26.1.301.g55bc3eb7cb9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
