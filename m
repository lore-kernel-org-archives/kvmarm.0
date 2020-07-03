Return-Path: <SRS0=Ct8k=AO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E727DC433E0
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 15:55:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D7FE20899
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 15:55:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D7FE20899
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD0884B0EB;
	Fri,  3 Jul 2020 11:55:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6R7I-KQG6wnE; Fri,  3 Jul 2020 11:55:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C54A94B0DE;
	Fri,  3 Jul 2020 11:55:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A11BA4B0DE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2020 11:55:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O1eJ5gEQmeSX for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2020 11:55:08 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 34BDF4B0D8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2020 11:55:08 -0400 (EDT)
Received: from localhost.localdomain (unknown [95.146.230.158])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7EE4420899;
 Fri,  3 Jul 2020 15:55:05 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V5 (RESEND) 0/4] arm64/cpufeature: Introduce ID_PFR2,
 ID_DFR1, ID_MMFR5 and other changes
Date: Fri,  3 Jul 2020 16:55:03 +0100
Message-Id: <159379155800.20268.8910088727326709928.b4-ty@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <1593748297-1965-1-git-send-email-anshuman.khandual@arm.com>
References: <1593748297-1965-1-git-send-email-anshuman.khandual@arm.com>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On Fri, 3 Jul 2020 09:21:33 +0530, Anshuman Khandual wrote:
> These are remaining patches from V4 series which had some pending reviews
> from Suzuki (https://patchwork.kernel.org/cover/11557333/). Also dropped
> [PATCH 15/17] as that will need some more investigation and rework.
> 
> This series applies on 5.8-rc3.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: James Morse <james.morse@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> 
> [...]

Applied to arm64 (for-next/cpufeature), thanks!

[1/4] arm64/cpufeature: Add remaining feature bits in ID_AA64MMFR0 register
      https://git.kernel.org/arm64/c/bc67f10ad1d7
[2/4] arm64/cpufeature: Add remaining feature bits in ID_AA64MMFR1 register
      https://git.kernel.org/arm64/c/853772ba8023
[3/4] arm64/cpufeature: Add remaining feature bits in ID_AA64MMFR2 register
      https://git.kernel.org/arm64/c/356fdfbe8761
[4/4] arm64/cpufeature: Replace all open bits shift encodings with macros
      https://git.kernel.org/arm64/c/8d3154afc10d

-- 
Catalin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
