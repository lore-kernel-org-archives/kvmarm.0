Return-Path: <SRS0=4kLF=SM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE1FAC282CE
	for <kvmarm@archiver.kernel.org>; Wed, 10 Apr 2019 15:15:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5EEC720820
	for <kvmarm@archiver.kernel.org>; Wed, 10 Apr 2019 15:15:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5EEC720820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF2864A382;
	Wed, 10 Apr 2019 11:15:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UtYOA8gF9Xlw; Wed, 10 Apr 2019 11:15:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 972EB4A474;
	Wed, 10 Apr 2019 11:15:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B94364A3BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 11:15:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dFIk23KuMfxa for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Apr 2019 11:15:22 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B52E4A382
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 11:15:22 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2E30374;
 Wed, 10 Apr 2019 08:15:21 -0700 (PDT)
Received: from en101.cambridge.arm.com (en101.cambridge.arm.com [10.1.196.93])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id
 7B4C33F59C; Wed, 10 Apr 2019 08:15:19 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2] kvm: arm: Skip stage2 huge mappings for unaligned ipa
 backed by THP
Date: Wed, 10 Apr 2019 16:14:57 +0100
Message-Id: <1554909297-6753-1-git-send-email-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.7.4
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org,
 yuzenghui@huawei.com, kvmarm@lists.cs.columbia.edu
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
Message-ID: <20190410151457.z_C98vnRPFAtLabXovQOGTbb0VHT35SHh22Wl2HiXBA@z>

With commit a80868f398554842b14, we no longer ensure that the
THP page is properly aligned in the guest IPA. Skip the stage2
huge mapping for unaligned IPA backed by transparent hugepages.

Fixes: a80868f398554842b14 ("KVM: arm/arm64: Enforce PTE mappings at stage2 when needed")
Reported-by: Eric Auger <eric.auger@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Chirstoffer Dall <christoffer.dall@arm.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: Zheng Xiang <zhengxiang9@huawei.com>
Cc: Andrew Murray <andrew.murray@arm.com>
Cc: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

---
Changes since V1:
 - Zenghui Yu reported that the first version misses the boundary
   check for the end address. Lets reuse the existing helper to
   check it.
---
 virt/kvm/arm/mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 27c9583..a39dcfd 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1781,8 +1781,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * Only PMD_SIZE transparent hugepages(THP) are
 		 * currently supported. This code will need to be
 		 * updated to support other THP sizes.
+		 *
+		 * Make sure the host VA and the guest IPA are sufficiently
+		 * aligned and that the block is contained within the memslot.
 		 */
-		if (transparent_hugepage_adjust(&pfn, &fault_ipa))
+		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE) &&
+		    transparent_hugepage_adjust(&pfn, &fault_ipa))
 			vma_pagesize = PMD_SIZE;
 	}
 
-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
