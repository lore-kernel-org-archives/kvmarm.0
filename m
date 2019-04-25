Return-Path: <SRS0=pAxc=S3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD6E9C4321A
	for <kvmarm@archiver.kernel.org>; Thu, 25 Apr 2019 13:49:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 73D3D206C1
	for <kvmarm@archiver.kernel.org>; Thu, 25 Apr 2019 13:49:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 73D3D206C1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25E434A49F;
	Thu, 25 Apr 2019 09:49:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7dKoVR93arpt; Thu, 25 Apr 2019 09:49:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 996134A4AB;
	Thu, 25 Apr 2019 09:49:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2600F4A46F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:49:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qK9oTrU8yDF8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Apr 2019 09:49:26 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CC524A485
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:49:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F20D7A78;
 Thu, 25 Apr 2019 06:49:25 -0700 (PDT)
Received: from big-swifty.cambridge.arm.com (c02v53d0hv2r.cambridge.arm.com
 [10.1.37.80])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EEDFB3F246;
 Thu, 25 Apr 2019 06:49:22 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 4/5] kvm: arm: Skip stage2 huge mappings for unaligned ipa
 backed by THP
Date: Thu, 25 Apr 2019 14:48:55 +0100
Message-Id: <20190425134857.26109-5-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190425134857.26109-1-marc.zyngier@arm.com>
References: <20190425134857.26109-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 Heyi Guo <guoheyi@huawei.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190425134855.q-V4EnjjKs8UrKDVVat6sPiRfqZphHrztrcJu6guiP8@z>

From: Suzuki K Poulose <suzuki.poulose@arm.com>

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
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 27c958306449..a39dcfdbcc65 100644
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
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
