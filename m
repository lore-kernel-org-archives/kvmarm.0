Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1ADAC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 14:59:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C14C4BA00;
	Fri, 25 Feb 2022 09:59:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Poab9djdOaEJ; Fri, 25 Feb 2022 09:59:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5C504BA80;
	Fri, 25 Feb 2022 09:59:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63AAC4BA09
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 22:39:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LHxFf7xDNltf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 22:39:26 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 115584BA03
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 22:39:26 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id
 a19-20020a25ca13000000b0061db44646b3so2039500ybg.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 19:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=3z7umWzjiaBi0H0VxEKou4UGWFcI8zJgOh8cZtYt5r8=;
 b=cSis1zFbDzg8HujAEb1ym/V6ME+YJ6BjUBqNYot/d81BO3h6D3Zk4WnTOTGc+6rl/a
 A1zpsu/lBasqxVBWEud7ld822jEooEBgrJsZMHuRMEVpfetkVIKN1s3ZYYpUx9+5/prc
 mBkto3DjqaO5JCwqXh801epJZthVVkZyzdjfKtgf6mptDewViPTKTLabmUOSYyPXrDQv
 cRZxkoyy97EAVUdmXTOT7ZsGdSwEwW2Kj8uqeQJUPxPMBB2z1yhVoKxwAqNUN6Inq610
 wbd175TAvAMgG+YXzuUlp1+rLhkDzzcYQgJ93AXxefT4SUK0W9EQew3+ipLub9HkmUPL
 XFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=3z7umWzjiaBi0H0VxEKou4UGWFcI8zJgOh8cZtYt5r8=;
 b=EhszvVSfqQqP9XJL+IQRCAjtGdWDsTW4Gi3/pc08TNRbpVWT+VtVJFNhgMxoVN6z1k
 GitMxGDXKTterKQxbYMjEfaSgNsZLvRZQHEAluxWpcs3NTsv7YyqQ66TqpYQyg+uL66+
 7LZLmYyb890mC9P87wwd9T5QBbsbUtz1Vk2tSOSYf4hJNFaDeubgG12dd2TK6nxDFXHx
 eShbK72YxZDeUUN/LDZZctaeqs436dyeZ8VtgIZQEdLaMAaZ4sMHjj1p4WxgrAiHQOOW
 tnfwAwpVuSr/arIdT3/vby0PZd3EWBXKEIU16tBL5eP64UMtTso5/UYz7gRKsE5VysmI
 hIIg==
X-Gm-Message-State: AOAM5315yd9Opk/K6CGq5XK8d2ZYljMXz2zK5nBmcASpyM/pjYF5HPqz
 fQPTdiJbQXNRwqkeQDXCs66NebY7sk2ZvaXl+A==
X-Google-Smtp-Source: ABdhPJzpCeaHUbNSr0tCnAVkQAGHMc2xtowI3g9fyEbYLjuQ5ZyqNkyEST6Fzl5lL9PO8MaOgXM5S0SNbU3r/dG5Dg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:3a50:90b2:e6a2:9060])
 (user=kaleshsingh job=sendgmr) by 2002:a25:13c6:0:b0:61e:105e:d291 with SMTP
 id 189-20020a2513c6000000b0061e105ed291mr5499552ybt.104.1645760365539; Thu,
 24 Feb 2022 19:39:25 -0800 (PST)
Date: Thu, 24 Feb 2022 19:34:46 -0800
In-Reply-To: <20220225033548.1912117-1-kaleshsingh@google.com>
Message-Id: <20220225033548.1912117-2-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220225033548.1912117-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 1/8] KVM: arm64: Introduce hyp_alloc_private_va_range()
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Fri, 25 Feb 2022 09:59:45 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Kalesh Singh <kaleshsingh@google.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 maz@kernel.org, "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 kernel-team@android.com, surenb@google.com, Mark Brown <broonie@kernel.org>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
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

Changes in v4:
  - Handle null ptr in hyp_alloc_private_va_range() and replace
    IS_ERR_OR_NULL checks in callers with IS_ERR checks, per Fuad
  - Fix kernel-doc comments format, per Fuad

Changes in v3:
  - Handle null ptr in IS_ERR_OR_NULL checks, per Mark

 arch/arm64/include/asm/kvm_mmu.h |  4 ++
 arch/arm64/kvm/mmu.c             | 65 ++++++++++++++++++++------------
 2 files changed, 45 insertions(+), 24 deletions(-)

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
index bc2aba953299..a4868a6fa1c3 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -457,22 +457,17 @@ int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	return 0;
 }
 
-static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
-					unsigned long *haddr,
-					enum kvm_pgtable_prot prot)
+
+/**
+ * hyp_alloc_private_va_range - Allocates a private VA range.
+ * @size:	The size of the VA range to reserve.
+ * @align:	The required alignment for the allocation.
+ *
+ * The private VA range is allocated below io_map_base.
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
 
@@ -484,29 +479,51 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
 	 *
 	 * The allocated size is always a multiple of PAGE_SIZE.
 	 */
-	size = PAGE_ALIGN(size + offset_in_page(phys_addr));
-	base = io_map_base - size;
+	base = io_map_base - PAGE_ALIGN(size);
+	base = ALIGN_DOWN(base, align);
 
 	/*
 	 * Verify that BIT(VA_BITS - 1) hasn't been flipped by
 	 * allocating the new area, as it would indicate we've
 	 * overflowed the idmap/IO address range.
 	 */
-	if ((base ^ io_map_base) & BIT(VA_BITS - 1))
-		ret = -ENOMEM;
+	if (!base || (base ^ io_map_base) & BIT(VA_BITS - 1))
+		base = (unsigned long)ERR_PTR(-ENOMEM);
 	else
 		io_map_base = base;
 
 	mutex_unlock(&kvm_hyp_pgd_mutex);
 
-	if (ret)
-		goto out;
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
+		if (IS_ERR((void *)addr))
+			return PTR_ERR((void *)addr);
+		*haddr = addr;
+
+		return 0;
+	}
+
+	size += offset_in_page(phys_addr);
+	addr = hyp_alloc_private_va_range(size, align);
+	if (IS_ERR((void *)addr))
+		return PTR_ERR((void *)addr);
 
-	ret = __create_hyp_mappings(base, size, phys_addr, prot);
+	ret = __create_hyp_mappings(addr, size, phys_addr, prot);
 	if (ret)
 		goto out;
 
-	*haddr = base + offset_in_page(phys_addr);
+	*haddr = addr + offset_in_page(phys_addr);
 out:
 	return ret;
 }
@@ -537,7 +554,7 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 		return 0;
 	}
 
-	ret = __create_hyp_private_mapping(phys_addr, size,
+	ret = __create_hyp_private_mapping(phys_addr, size, PAGE_SIZE,
 					   &addr, PAGE_HYP_DEVICE);
 	if (ret) {
 		iounmap(*kaddr);
@@ -564,7 +581,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 
 	BUG_ON(is_kernel_in_hyp_mode());
 
-	ret = __create_hyp_private_mapping(phys_addr, size,
+	ret = __create_hyp_private_mapping(phys_addr, size, PAGE_SIZE,
 					   &addr, PAGE_HYP_EXEC);
 	if (ret) {
 		*haddr = NULL;
-- 
2.35.1.574.g5d30c73bfb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
