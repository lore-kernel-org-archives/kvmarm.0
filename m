Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A60C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 20:04:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C97C4B224;
	Fri,  8 Apr 2022 16:04:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 82uj4Bf8Ynsi; Fri,  8 Apr 2022 16:04:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4A474B188;
	Fri,  8 Apr 2022 16:04:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 825944078F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 16:04:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hm8rO9P2migb for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 16:04:27 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57404400CF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 16:04:27 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2ebebe9f982so17619667b3.17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2022 13:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=vGOzm6wEc5ZJu/z76Pc4OmWnVkDbT1lO/lddjg12IXE=;
 b=rUA6y475P61rM5lqwSb9OqoqNh79eA7sv/HxbLZxdgaSlFH9dShNfu0fq5DzHE503f
 +3zuggND13GYxNUriO9tYaWp4UUfrjqmDXMcALqUPv7QZW3nfS3MwuUaPfx2RvM6p2ht
 OL0IG+mzOtgXulhQkBIIbmfuxSO7QAjjrFmiYmV19FwZbNySvX0ZvnxzD9AAycEcks/F
 zo61SXvyhe3SmzWLuyNcDVr310584XhMjL6tqTL8G8nBGk0dUs8w03sHvp/oRwWPqyVw
 bwDSMtE28u5zx9gVams/JAF3t8OvllyfgbnLAlA8vF9WrZIi7GIFC6KNAkMcOoHV5khT
 tziA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=vGOzm6wEc5ZJu/z76Pc4OmWnVkDbT1lO/lddjg12IXE=;
 b=hrLvhikm7YbY158iGY3PjqwAERj+cHCkqeFkHlFQaI55KZbJCJQM3IMTsFLTQIpLhX
 ZiVdrzZdHVurmK7m7Yt0PWwYpX3phzeJf2pdRd1ugZvtW3J/QIqQB4nl59N3zjxh2Ws8
 GfYz0TsE6mdEIAwlJLf3l5E64WuvOtqKPqzCpRHLXIZKW8AOA/OCVq6qweXJRI0eBOOt
 E2SDkAaC33XtGqPlYT79gbmsEHINhEcOd4URZo2l0R++VJx2m8CZBi51vhyjXrwqa6Yv
 A9gyBEJ/9dERJFY2TzVS75x6xx8FEUXRR3inO8+SwvTlnhyQHqgcsfopIBuZq4PvglVL
 UdIQ==
X-Gm-Message-State: AOAM533fbExbNny8SEcixkZ34pPiahq5s7G9seQUoGAK6Ssgup8RMNZf
 2otSHzgUVav5a8xDLw6bjVVmhgKagfuCBxIDeA==
X-Google-Smtp-Source: ABdhPJy7bDbcYK9hv0FuHXGFrQmgggKoFAeK499e8yZjtgPh0IStbAziEvqq3t6BQ7easKktwaeWTk1bQ/5sq4tOsQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f0ed:c8a:dab7:ecc2])
 (user=kaleshsingh job=sendgmr) by 2002:a5b:246:0:b0:619:5651:3907 with SMTP
 id g6-20020a5b0246000000b0061956513907mr15443681ybp.190.1649448266782; Fri,
 08 Apr 2022 13:04:26 -0700 (PDT)
Date: Fri,  8 Apr 2022 13:03:24 -0700
In-Reply-To: <20220408200349.1529080-1-kaleshsingh@google.com>
Message-Id: <20220408200349.1529080-2-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220408200349.1529080-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v7 1/6] KVM: arm64: Introduce hyp_alloc_private_va_range()
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, kernel-team@android.com,
 Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org, maz@kernel.org,
 Masahiro Yamada <masahiroy@kernel.org>, linux-kernel@vger.kernel.org,
 Changbin Du <changbin.du@intel.com>, linux-arm-kernel@lists.infradead.org,
 surenb@google.com, kvmarm@lists.cs.columbia.edu
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

hyp_alloc_private_va_range() can be used to reserve private VA ranges
in the nVHE hypervisor. Allocations are aligned based on the order of
the requested size.

This will be used to implement stack guard pages for KVM nVHE hypervisor
(nVHE Hyp mode / not pKVM), in a subsequent patch in the series.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
---

Changes in v7:
  - Add Fuad's Reviewed-by and Tested-by tags.

Changes in v6:
  - Update kernel-doc for hyp_alloc_private_va_range()
    and add return description, per Stephen
  - Update hyp_alloc_private_va_range() to return an int error code,
    per Stephen
  - Replace IS_ERR() checks with IS_ERR_VALUE() check, per Stephen
  - Clean up goto, per Stephen

Changes in v5:
  - Align private allocations based on the order of their size, per Marc

Changes in v4:
  - Handle null ptr in hyp_alloc_private_va_range() and replace
    IS_ERR_OR_NULL checks in callers with IS_ERR checks, per Fuad
  - Fix kernel-doc comments format, per Fuad

Changes in v3:
  - Handle null ptr in IS_ERR_OR_NULL checks, per Mark


 arch/arm64/include/asm/kvm_mmu.h |  1 +
 arch/arm64/kvm/mmu.c             | 66 +++++++++++++++++++++-----------
 2 files changed, 45 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 74735a864eee..a50cbb5ba402 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -154,6 +154,7 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 int kvm_share_hyp(void *from, void *to);
 void kvm_unshare_hyp(void *from, void *to);
 int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
+int hyp_alloc_private_va_range(size_t size, unsigned long *haddr);
 int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 			   void __iomem **kaddr,
 			   void __iomem **haddr);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0d19259454d8..3d3efea4e991 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -457,23 +457,22 @@ int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	return 0;
 }
 
-static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
-					unsigned long *haddr,
-					enum kvm_pgtable_prot prot)
+
+/**
+ * hyp_alloc_private_va_range - Allocates a private VA range.
+ * @size:	The size of the VA range to reserve.
+ * @haddr:	The hypervisor virtual start address of the allocation.
+ *
+ * The private virtual address (VA) range is allocated below io_map_base
+ * and aligned based on the order of @size.
+ *
+ * Return: 0 on success or negative error code on failure.
+ */
+int hyp_alloc_private_va_range(size_t size, unsigned long *haddr)
 {
 	unsigned long base;
 	int ret = 0;
 
-	if (!kvm_host_owns_hyp_mappings()) {
-		base = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
-					 phys_addr, size, prot);
-		if (IS_ERR_OR_NULL((void *)base))
-			return PTR_ERR((void *)base);
-		*haddr = base;
-
-		return 0;
-	}
-
 	mutex_lock(&kvm_hyp_pgd_mutex);
 
 	/*
@@ -484,30 +483,53 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
 	 *
 	 * The allocated size is always a multiple of PAGE_SIZE.
 	 */
-	size = PAGE_ALIGN(size + offset_in_page(phys_addr));
-	base = io_map_base - size;
+	base = io_map_base - PAGE_ALIGN(size);
+
+	/* Align the allocation based on the order of its size */
+	base = ALIGN_DOWN(base, PAGE_SIZE << get_order(size));
 
 	/*
 	 * Verify that BIT(VA_BITS - 1) hasn't been flipped by
 	 * allocating the new area, as it would indicate we've
 	 * overflowed the idmap/IO address range.
 	 */
-	if ((base ^ io_map_base) & BIT(VA_BITS - 1))
+	if (!base || (base ^ io_map_base) & BIT(VA_BITS - 1))
 		ret = -ENOMEM;
 	else
-		io_map_base = base;
+		*haddr = io_map_base = base;
 
 	mutex_unlock(&kvm_hyp_pgd_mutex);
 
+	return ret;
+}
+
+static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
+					unsigned long *haddr,
+					enum kvm_pgtable_prot prot)
+{
+	unsigned long addr;
+	int ret = 0;
+
+	if (!kvm_host_owns_hyp_mappings()) {
+		addr = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
+					 phys_addr, size, prot);
+		if (IS_ERR_VALUE(addr))
+			return addr;
+		*haddr = addr;
+
+		return 0;
+	}
+
+	size += offset_in_page(phys_addr);
+	ret = hyp_alloc_private_va_range(size, &addr);
 	if (ret)
-		goto out;
+		return ret;
 
-	ret = __create_hyp_mappings(base, size, phys_addr, prot);
+	ret = __create_hyp_mappings(addr, size, phys_addr, prot);
 	if (ret)
-		goto out;
+		return ret;
 
-	*haddr = base + offset_in_page(phys_addr);
-out:
+	*haddr = addr + offset_in_page(phys_addr);
 	return ret;
 }
 
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
