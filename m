Return-Path: <SRS0=Vsle=TB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA05C46476
	for <kvmarm@archiver.kernel.org>; Wed,  1 May 2019 09:48:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 87AD62177B
	for <kvmarm@archiver.kernel.org>; Wed,  1 May 2019 09:48:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87AD62177B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FEE24A513;
	Wed,  1 May 2019 05:48:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oVF8FqeWTUTq; Wed,  1 May 2019 05:48:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B4FE4A4FD;
	Wed,  1 May 2019 05:48:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E6F64A4F5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 05:48:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9iijdCnx1Z8X for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 May 2019 05:48:17 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9970B4A4DE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 05:48:17 -0400 (EDT)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id C4F005DC777B751C2BF8;
 Wed,  1 May 2019 17:48:14 +0800 (CST)
Received: from HGHY2Y004646261.china.huawei.com (10.184.12.158) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Wed, 1 May 2019 17:48:07 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH 1/5] KVM: arm/arm64: Introduce helpers for page table enties
 with contiguous bit
Date: Wed, 1 May 2019 09:44:23 +0000
Message-ID: <1556703867-22396-2-git-send-email-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.6.4.windows.1
In-Reply-To: <1556703867-22396-1-git-send-email-yuzenghui@huawei.com>
References: <1556703867-22396-1-git-send-email-yuzenghui@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com,
 linux@armlinux.org.uk
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
Message-ID: <20190501094423.cvj7Dgrn_XgkpXsiLXdoqa3tkJXWK3WJ5MJVmjhDmng@z>

Introduce helpers to manipulate stage2 page table entries - set contiguous
bit in the entry and say whether this entry points to a contiguous block.

The helpers are introduced in preparation for supporting contiguous
hugepages at stage2.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arch/arm/include/asm/kvm_mmu.h   | 22 ++++++++++++++++++++++
 arch/arm64/include/asm/kvm_mmu.h | 20 ++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 31de4ab..80d73ae 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -143,6 +143,28 @@ static inline bool kvm_s2pud_young(pud_t pud)
 	return false;
 }
 
+static inline pte_t kvm_s2pte_mkcont(pte_t pte)
+{
+	BUG();
+	return pte;
+}
+
+static inline bool kvm_s2pte_cont(pte_t pte)
+{
+	return false;
+}
+
+static inline pmd_t kvm_s2pmd_mkcont(pmd_t pmd)
+{
+	BUG();
+	return pmd;
+}
+
+static inline bool kvm_s2pmd_cont(pmd_t pmd)
+{
+	return false;
+}
+
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
 	pte_val(pte) |= L_PTE_S2_RDWR;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index ebeefcf..4afdad9 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -295,6 +295,26 @@ static inline bool kvm_s2pud_young(pud_t pud)
 	return pud_young(pud);
 }
 
+static inline pte_t kvm_s2pte_mkcont(pte_t pte)
+{
+	return pte_mkcont(pte);
+}
+
+static inline bool kvm_s2pte_cont(pte_t pte)
+{
+	return pte_cont(pte);
+}
+
+static inline pmd_t kvm_s2pmd_mkcont(pmd_t pmd)
+{
+	return pmd_mkcont(pmd);
+}
+
+static inline bool kvm_s2pmd_cont(pmd_t pmd)
+{
+	return !!(pmd_val(pmd) & PMD_SECT_CONT);
+}
+
 #define hyp_pte_table_empty(ptep) kvm_page_empty(ptep)
 
 #ifdef __PAGETABLE_PMD_FOLDED
-- 
1.8.3.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
