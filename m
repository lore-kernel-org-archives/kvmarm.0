Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63316C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 11:02:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6BA94C46E;
	Wed, 23 Feb 2022 06:02:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M4K7Ivk78fPD; Wed, 23 Feb 2022 06:02:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD1674C489;
	Wed, 23 Feb 2022 06:02:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB3A149EC2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 11:53:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r0C6-HfDg+NO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 11:53:51 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9520849EC0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 11:53:51 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2d306e372e5so146852667b3.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 08:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=HjTQZhkAd40lRuvS6cRV70Tpnwq9dG8Hrk7s02bufrw=;
 b=l9gvPlFOgpm93Vwqfc4x5Vuvn4H98TzVtnPztFKq1RVJHuCOwjRWnhPGwbxmv2gBju
 qni22+lZAoWeuHyAnrHLkUxmGVg1MGvOPtvysJUTpVnxGE9XNCgdGG3ihOcgDh4Ud0VO
 t81B3SWw8tC8AP32YUnfVl7SNtvpxpe1ER/dZExOrnQ3bwmGSIvoILXJpsKsbYOeEn5X
 eNRw3J9xbd+PwHflrNv9W7603a/Ig+5VqL31ZqaFq/h7ygZQBquGNSxpt5WNmcJEKeuh
 799vMF4hFNUjwmMyaOlRkDXrCuhduGcEePOXQj+fAOq4j8VbFHa6wTIBzVfUzsaX0ujb
 tebQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=HjTQZhkAd40lRuvS6cRV70Tpnwq9dG8Hrk7s02bufrw=;
 b=sBSJsBAIGgfZrPhMHHGRFfTRxHroWvwCSW8D9r7/LNl7ndb+TwnpYDA23tutrN8LWU
 uylpfdrZjvnDsJSNrJA6pU5pEqV9YVkdYjRBPJ0sbwU7d6lB9iMXuIDupw9kv6TXEW59
 igj5wPCjpNyYpKrd+/GgU2ZERx4iNvxRUR4Qxmn2DJnXwXzJ3DyM88H+EYQPYSO37Ooz
 /YNlq99u3/FREHFZIgBdd0weGP9QazB9PdtmgqKPi5yPFsqYZUOlNKQZE8UGjYSULRMW
 OzYqmKe6lwxe57xk0FXtjqLukEyzrSLhAerMUkC/HvQi4kL5vyghT8oAJHUV6hn7vdb9
 CBFw==
X-Gm-Message-State: AOAM531XZBf9b6NmlPzXDY4+1+z5KZJBgpQVTbYK2g5siFgTCfWb/20Q
 msj0lfRpd3/M4edW/Ht+WFrlvYJWE3XwnUw10w==
X-Google-Smtp-Source: ABdhPJxqQdinLFWWaI+jsvW0KvgGVTkFzIldtere0/r0cpO5BgzuX/8Yyc3hdk7P6zZ0tb1mTeOyerwEEGUUJI16nw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5db7:1235:b3dd:cfcb])
 (user=kaleshsingh job=sendgmr) by 2002:a25:4dd7:0:b0:621:a740:3988 with SMTP
 id a206-20020a254dd7000000b00621a7403988mr24600128ybb.58.1645548831008; Tue,
 22 Feb 2022 08:53:51 -0800 (PST)
Date: Tue, 22 Feb 2022 08:51:02 -0800
In-Reply-To: <20220222165212.2005066-1-kaleshsingh@google.com>
Message-Id: <20220222165212.2005066-2-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220222165212.2005066-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v2 1/9] KVM: arm64: Introduce hyp_alloc_private_va_range()
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Wed, 23 Feb 2022 06:02:29 -0500
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 Kalesh Singh <kaleshsingh@google.com>, surenb@google.com,
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

hyp_alloc_private_va_range() can be used to reserve private VA ranges
in the nVHE hypervisor. Also update  __create_hyp_private_mapping()
to allow specifying an alignment for the private VA mapping.

These will be used to implement stack guard pages for KVM nVHE hypervisor
(nVHE Hyp mode / not pKVM), in a subsequent patch in the series.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h |  4 +++
 arch/arm64/kvm/mmu.c             | 61 +++++++++++++++++++++-----------
 2 files changed, 44 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 81839e9a8a24..0b0c71302b92 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -153,6 +153,10 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 int kvm_share_hyp(void *from, void *to);
 void kvm_unshare_hyp(void *from, void *to);
 int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
+unsigned long hyp_alloc_private_va_range(size_t size, size_t align);
+int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
+				size_t align, unsigned long *haddr,
+				enum kvm_pgtable_prot prot);
 int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 			   void __iomem **kaddr,
 			   void __iomem **haddr);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index bc2aba953299..e5abcce44ad0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -457,22 +457,16 @@ int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	return 0;
 }
 
-static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
-					unsigned long *haddr,
-					enum kvm_pgtable_prot prot)
+
+/*
+ * Allocates a private VA range below io_map_base.
+ *
+ * @size:	The size of the VA range to reserve.
+ * @align:	The required alignment for the allocation.
+ */
+unsigned long hyp_alloc_private_va_range(size_t size, size_t align)
 {
 	unsigned long base;
-	int ret = 0;
-
-	if (!kvm_host_owns_hyp_mappings()) {
-		base = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
-					 phys_addr, size, prot);
-		if (IS_ERR_OR_NULL((void *)base))
-			return PTR_ERR((void *)base);
-		*haddr = base;
-
-		return 0;
-	}
 
 	mutex_lock(&kvm_hyp_pgd_mutex);
 
@@ -484,8 +478,8 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
 	 *
 	 * The allocated size is always a multiple of PAGE_SIZE.
 	 */
-	size = PAGE_ALIGN(size + offset_in_page(phys_addr));
-	base = io_map_base - size;
+	base = io_map_base - PAGE_ALIGN(size);
+	base = ALIGN_DOWN(base, align);
 
 	/*
 	 * Verify that BIT(VA_BITS - 1) hasn't been flipped by
@@ -493,20 +487,45 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
 	 * overflowed the idmap/IO address range.
 	 */
 	if ((base ^ io_map_base) & BIT(VA_BITS - 1))
-		ret = -ENOMEM;
+		base = (unsigned long)ERR_PTR(-ENOMEM);
 	else
 		io_map_base = base;
 
 	mutex_unlock(&kvm_hyp_pgd_mutex);
 
+	return base;
+}
+
+int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
+				size_t align, unsigned long *haddr,
+				enum kvm_pgtable_prot prot)
+{
+	unsigned long addr;
+	int ret = 0;
+
+	if (!kvm_host_owns_hyp_mappings()) {
+		addr = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
+					 phys_addr, size, prot);
+		if (IS_ERR_OR_NULL((void *)addr))
+			return PTR_ERR((void *)addr);
+		*haddr = addr;
+
+		return 0;
+	}
+
+	size += offset_in_page(phys_addr);
+	addr = hyp_alloc_private_va_range(size, align);
+	if (IS_ERR_OR_NULL((void *)addr))
+		return PTR_ERR((void *)addr);
+
 	if (ret)
 		goto out;
 
-	ret = __create_hyp_mappings(base, size, phys_addr, prot);
+	ret = __create_hyp_mappings(addr, size, phys_addr, prot);
 	if (ret)
 		goto out;
 
-	*haddr = base + offset_in_page(phys_addr);
+	*haddr = addr + offset_in_page(phys_addr);
 out:
 	return ret;
 }
@@ -537,7 +556,7 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 		return 0;
 	}
 
-	ret = __create_hyp_private_mapping(phys_addr, size,
+	ret = __create_hyp_private_mapping(phys_addr, size, PAGE_SIZE,
 					   &addr, PAGE_HYP_DEVICE);
 	if (ret) {
 		iounmap(*kaddr);
@@ -564,7 +583,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 
 	BUG_ON(is_kernel_in_hyp_mode());
 
-	ret = __create_hyp_private_mapping(phys_addr, size,
+	ret = __create_hyp_private_mapping(phys_addr, size, PAGE_SIZE,
 					   &addr, PAGE_HYP_EXEC);
 	if (ret) {
 		*haddr = NULL;
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
