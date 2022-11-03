Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF8F4C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 15:05:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E7E049F51;
	Thu,  3 Nov 2022 11:05:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t61VIxjHvqUo; Thu,  3 Nov 2022 11:05:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 058864B286;
	Thu,  3 Nov 2022 11:05:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B68C49F51
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 11:05:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w6wvaWCEGslz for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 11:05:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF3CA41070
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 11:05:14 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27D9D1FB;
 Thu,  3 Nov 2022 08:05:20 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com
 [10.1.196.169])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0FFB13F5A1;
 Thu,  3 Nov 2022 08:05:11 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH v1 0/2] KVM fixes for exotic configurations
Date: Thu,  3 Nov 2022 15:05:05 +0000
Message-Id: <20221103150507.32948-1-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.17.1
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

I've been adding support for FEAT_LPA2 to KVM and as part of that work have been
testing various (84) configurations of HW, host and guest kernels on FVP. This
has thrown up a couple of pre-existing bugs, for which the fixes are provided.

Thanks,
Ryan

Ryan Roberts (2):
  KVM: arm64: Fix kvm init failure when mode!=vhe and VA_BITS=52.
  KVM: arm64: Fix PAR_TO_HPFAR() to work independently of PA_BITS.

 arch/arm64/include/asm/kvm_arm.h |  6 +++++-
 arch/arm64/kvm/arm.c             | 20 +++-----------------
 arch/arm64/kvm/mmu.c             | 28 +++++++++++++++++++++++++++-
 3 files changed, 35 insertions(+), 19 deletions(-)

--
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
