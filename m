Return-Path: <SRS0=srdq=LL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB7EC49EA3
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 10:58:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8ACC2613E7
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 10:58:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8ACC2613E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26CA34B08B;
	Thu, 17 Jun 2021 06:58:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mQGUruxU27c3; Thu, 17 Jun 2021 06:58:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA9C14A5A0;
	Thu, 17 Jun 2021 06:58:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4F4E40808
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 06:58:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3aAnkK+MUz71 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jun 2021 06:58:33 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78DB9407F1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 06:58:32 -0400 (EDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G5JnL45XGzXgrg;
 Thu, 17 Jun 2021 18:53:26 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 18:58:28 +0800
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 18:58:28 +0800
From: Yanan Wang <wangyanan55@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, "Quentin
 Perret" <qperret@google.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 <kvmarm@lists.cs.columbia.edu>, <linux-arm-kernel@lists.infradead.org>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 1/4] KVM: arm64: Introduce two cache maintenance callbacks
Date: Thu, 17 Jun 2021 18:58:21 +0800
Message-ID: <20210617105824.31752-2-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210617105824.31752-1-wangyanan55@huawei.com>
References: <20210617105824.31752-1-wangyanan55@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Cc: Catalin Marinas <catalin.marinas@arm.com>
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

To prepare for performing CMOs for guest stage-2 in the fault handlers
in pgtable.c, here introduce two cache maintenance callbacks in struct
kvm_pgtable_mm_ops. We also adjust the comment alignment for the
existing part but make no real content change at all.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 42 +++++++++++++++++-----------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index c3674c47d48c..b6ce34aa44bb 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -27,23 +27,29 @@ typedef u64 kvm_pte_t;
 
 /**
  * struct kvm_pgtable_mm_ops - Memory management callbacks.
- * @zalloc_page:	Allocate a single zeroed memory page. The @arg parameter
- *			can be used by the walker to pass a memcache. The
- *			initial refcount of the page is 1.
- * @zalloc_pages_exact:	Allocate an exact number of zeroed memory pages. The
- *			@size parameter is in bytes, and is rounded-up to the
- *			next page boundary. The resulting allocation is
- *			physically contiguous.
- * @free_pages_exact:	Free an exact number of memory pages previously
- *			allocated by zalloc_pages_exact.
- * @get_page:		Increment the refcount on a page.
- * @put_page:		Decrement the refcount on a page. When the refcount
- *			reaches 0 the page is automatically freed.
- * @page_count:		Return the refcount of a page.
- * @phys_to_virt:	Convert a physical address into a virtual address mapped
- *			in the current context.
- * @virt_to_phys:	Convert a virtual address mapped in the current context
- *			into a physical address.
+ * @zalloc_page:		Allocate a single zeroed memory page.
+ *				The @arg parameter can be used by the walker
+ *				to pass a memcache. The initial refcount of
+ *				the page is 1.
+ * @zalloc_pages_exact:		Allocate an exact number of zeroed memory pages.
+ *				The @size parameter is in bytes, and is rounded
+ *				up to the next page boundary. The resulting
+ *				allocation is physically contiguous.
+ * @free_pages_exact:		Free an exact number of memory pages previously
+ *				allocated by zalloc_pages_exact.
+ * @get_page:			Increment the refcount on a page.
+ * @put_page:			Decrement the refcount on a page. When the
+ *				refcount reaches 0 the page is automatically
+ *				freed.
+ * @page_count:			Return the refcount of a page.
+ * @phys_to_virt:		Convert a physical address into a virtual address
+ *				mapped in the current context.
+ * @virt_to_phys:		Convert a virtual address mapped in the current
+ *				context into a physical address.
+ * @clean_invalidate_dcache:	Clean and invalidate the data cache for the
+ *				specified memory address range.
+ * @invalidate_icache:		Invalidate the instruction cache for the
+ *				specified memory address range.
  */
 struct kvm_pgtable_mm_ops {
 	void*		(*zalloc_page)(void *arg);
@@ -54,6 +60,8 @@ struct kvm_pgtable_mm_ops {
 	int		(*page_count)(void *addr);
 	void*		(*phys_to_virt)(phys_addr_t phys);
 	phys_addr_t	(*virt_to_phys)(void *addr);
+	void		(*clean_invalidate_dcache)(void *addr, size_t size);
+	void		(*invalidate_icache)(void *addr, size_t size);
 };
 
 /**
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
