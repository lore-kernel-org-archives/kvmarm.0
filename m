Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8CA4C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 21 Feb 2022 15:35:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 425B74B1D2;
	Mon, 21 Feb 2022 10:35:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iP8AEVkbCMQg; Mon, 21 Feb 2022 10:35:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD709411D2;
	Mon, 21 Feb 2022 10:35:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B01D4B1AA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 10:35:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eT4-YlRhx4-p for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Feb 2022 10:35:33 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5701B4B1A2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 10:35:33 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id C84E4B80E9B;
 Mon, 21 Feb 2022 15:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDA5C340E9;
 Mon, 21 Feb 2022 15:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645457730;
 bh=QO2/ryxLIgGlo+m7rgzQ3B0LtbknnIDgKAJPKHdFKU4=;
 h=From:To:Cc:Subject:Date:From;
 b=jEBBU1bviEgJZ/CCJj+GZpBOMNpULxnno6LRkAGUsAQEkQuyVXDVPwfxxcuITpnJN
 YMYzZkqhKRyZRkrCBQGikswgPq36HeLjoI8E/Ppd/yJN3lCnr2vzWeIeQPzoco0psK
 ZFOKDodfgzYC4DBvHlCtD+Dv4AtRAj9TfopBne/xekytebN2IEzmpE3oEiiekrkYMF
 6/4y8O29CTfkcwHdQwd7TuJiTDxmt6l0q0cqo9Cov9OQFG6nhIAFv0EBvurGROL1Ey
 bLRGf64zUrPXzfodiuMF6W3ps+z1KI/g34xC+TRfhfNt2Ncc7IzEKGSLX6c/EhymZ2
 zRV05Jk0R+eqw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 0/3] Plumb PSCI SYSTEM_RESET2 call for guests
Date: Mon, 21 Feb 2022 15:35:21 +0000
Message-Id: <20220221153524.15397-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
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

Hi all,

Here's version two of the patches I posted at the end of last week:

  https://lore.kernel.org/r/20220217184001.11753-1-will@kernel.org

The only change is to the comments and ABI documentation, so that we
refer to the PSCI spec instead of describing the arguments to RESET2.

Cheers,

Will

Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>

--->8

Will Deacon (3):
  KVM: arm64: Bump guest PSCI version to 1.1
  KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the guest
  KVM: arm64: Indicate SYSTEM_RESET2 in kvm_run::system_event flags
    field

 Documentation/virt/kvm/api.rst    |  5 +++
 arch/arm64/include/uapi/asm/kvm.h |  7 ++++
 arch/arm64/kvm/psci.c             | 58 +++++++++++++++++++++++++------
 include/kvm/arm_psci.h            |  3 +-
 include/uapi/linux/psci.h         |  4 +++
 5 files changed, 66 insertions(+), 11 deletions(-)

-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
