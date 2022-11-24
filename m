Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 178A3C43217
	for <kvmarm@archiver.kernel.org>; Thu, 24 Nov 2022 15:28:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F76640298;
	Thu, 24 Nov 2022 10:28:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 58-H3s+pDXKQ; Thu, 24 Nov 2022 10:28:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45C7B40796;
	Thu, 24 Nov 2022 10:28:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D55A403DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Nov 2022 10:28:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lHpVEtAcLt89 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Nov 2022 10:28:25 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D73C4018D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Nov 2022 10:28:25 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3572723A;
 Thu, 24 Nov 2022 07:28:31 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CEA5B3F73B;
 Thu, 24 Nov 2022 07:28:23 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: andrew.jones@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v2 0/2] arm/arm64: teach virt_to_pte_phys()
 about block descriptors
Date: Thu, 24 Nov 2022 15:28:14 +0000
Message-Id: <20221124152816.22305-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
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

I was writing a quick test when I noticed that arm's implementation of
__virt_to_phys(), which ends up calling virt_to_pte_phys(), doesn't handle
block mappings and returns a bogus value. When fixing it I got confused
about mmu_get_pte() and get_pte(), so I (hopefully) improved things by
renaming mmu_get_pte() to follow_pte().

Changes since v1:

- Dropped patch #1 ("lib/vmalloc: Treat virt_to_pte_phys() as returning a
  physical address") because it was incorrect.
- Dropped the check for pte_valid() for the return value of mmu_get_pte() in
  patch #1 because mmu_get_pte() returns NULL for an invalid descriptor.

Lightly tested on a rockpro64 (4k and 64k pages, arm64 and arm, qemu only)
because the changes from the previous version are trivial.

Alexandru Elisei (2):
  arm/arm64: mmu: Teach virt_to_pte_phys() about block descriptors
  arm/arm64: mmu: Rename mmu_get_pte() -> follow_pte()

 lib/arm/asm/mmu-api.h |  2 +-
 lib/arm/mmu.c         | 88 +++++++++++++++++++++++++------------------
 2 files changed, 53 insertions(+), 37 deletions(-)

-- 
2.37.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
