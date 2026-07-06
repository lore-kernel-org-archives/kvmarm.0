Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF0E219E8;
	Mon,  6 Jul 2026 06:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783317946; cv=none; b=Unv/qgJn2GnLRRGSRicC2TZcsFCKJDW1ISd5PjKeyXLB+OMYBRh83Za7jSLw+vWoUcjKyO/HbW8BhfKPXE193JKRQNU8toHhQLpOqQ7rhLK3ocFWDqwC633dLIUpBQorZbSf0Y0CJRJNS6ySYezl27CkZ6ITcrpV5AYSejacBkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783317946; c=relaxed/simple;
	bh=IdvH4hikilRZ9R0/nOjIBBDs5VrP9SLSaXOZHjEGwL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NY92q5SLaOPS2WRY0Vxxh3lucq2Fl94UU3tQ74r9svIKSlYiYzOI+KPsC4xG9mXkcC3yXUOLo6YF4gjHjnHJdyOlHRViYzePvmeJC+okgZfg4p4IUkRvxUHi5SPCMaDasYAvLxYLAMKjWud4q/qnQ0vPm4BW8ylJcSUV/MBHmxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WYB3U9wC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WYB3U9wC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98EFD1F000E9;
	Mon,  6 Jul 2026 06:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783317945;
	bh=8jd0pjTKgLDEzucaKbmINUjFuw5BMxXvngk7Lwj7sys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WYB3U9wCoeBsSFsOd+1peL8CBUeqVojORjFSSgl+wIdBzthvvPc1G7Yckf65D55yW
	 jat5Tl8YCcqmzSrWLUZUYbjIKfF0VZ/kNqaKzENJe5yPEHXb5QBHxfWcxJsPp+wK2L
	 NPTY81BkHBc8AQXexOd3kZmd+8OPfsA7NL/XENIHzbnc/kw8Dxb1cSxmhk/SGEBmCs
	 b1YFNZYIDEP3NLWWOYEqxwSzKPIHwYCitaaTvD/HIOhrgk12Oxko23+uTSJ6y5kuR6
	 KSpLsQpouY6wQccm/0TRK//hEX/OzOtUgZWbit963prgLP7NQH48ROUfsaFeKmPpLb
	 kOweSn/RZqD1w==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v5 08/10] arm64: realm: Move Realm memory encryption ops to RSI code
Date: Mon,  6 Jul 2026 11:34:30 +0530
Message-ID: <20260706060432.1375570-9-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260706060432.1375570-1-aneesh.kumar@kernel.org>
References: <20260706060432.1375570-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Realm memory encryption callbacks are CCA-specific. Keep the Realm callback
registration with the RSI initialization code instead of pageattr.c, which
only needs to provide the low-level page-attribute transition helper.

Export __set_memory_enc_dec() within arm64 so the RSI code can wrap it with
the Realm-specific encrypt/decrypt callbacks and warning policy.

No functional changes in this patch.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/mem_encrypt.h |  3 +--
 arch/arm64/kernel/rsi.c              | 34 +++++++++++++++++++++++++
 arch/arm64/mm/pageattr.c             | 38 +---------------------------
 3 files changed, 36 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/include/asm/mem_encrypt.h b/arch/arm64/include/asm/mem_encrypt.h
index 314b2b52025f..f6325f30e844 100644
--- a/arch/arm64/include/asm/mem_encrypt.h
+++ b/arch/arm64/include/asm/mem_encrypt.h
@@ -15,8 +15,7 @@ int arm64_mem_crypt_ops_register(const struct arm64_mem_crypt_ops *ops);
 
 int set_memory_encrypted(unsigned long addr, int numpages);
 int set_memory_decrypted(unsigned long addr, int numpages);
-
-int realm_register_memory_enc_ops(void);
+int __set_memory_enc_dec(unsigned long addr, int numpages, bool encrypt);
 
 static inline bool force_dma_unencrypted(struct device *dev)
 {
diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index 1fb2abd79800..5c566700974c 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -143,6 +143,40 @@ static int realm_ioremap_hook(phys_addr_t phys, size_t size, pgprot_t *prot)
 	return 0;
 }
 
+static int realm_set_memory_encrypted(unsigned long addr, int numpages)
+{
+	int ret = __set_memory_enc_dec(addr, numpages, true);
+
+	/*
+	 * If the request to change state fails, then the only sensible cause
+	 * of action for the caller is to leak the memory
+	 */
+	WARN(ret, "Failed to encrypt memory, %d pages will be leaked",
+	     numpages);
+
+	return ret;
+}
+
+static int realm_set_memory_decrypted(unsigned long addr, int numpages)
+{
+	int ret = __set_memory_enc_dec(addr, numpages, false);
+
+	WARN(ret, "Failed to decrypt memory, %d pages will be leaked",
+	     numpages);
+
+	return ret;
+}
+
+static const struct arm64_mem_crypt_ops realm_crypt_ops = {
+	.encrypt = realm_set_memory_encrypted,
+	.decrypt = realm_set_memory_decrypted,
+};
+
+static int realm_register_memory_enc_ops(void)
+{
+	return arm64_mem_crypt_ops_register(&realm_crypt_ops);
+}
+
 void __init arm64_rsi_init(void)
 {
 	if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_SMC)
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index bbe98ac9ad8c..14b2a3801f40 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -275,9 +275,7 @@ int set_direct_map_default_noflush(struct page *page)
 				 PAGE_SIZE, set_mask, clear_mask);
 }
 
-static int __set_memory_enc_dec(unsigned long addr,
-				int numpages,
-				bool encrypt)
+int __set_memory_enc_dec(unsigned long addr, int numpages, bool encrypt)
 {
 	unsigned long set_prot = 0, clear_prot = 0;
 	phys_addr_t start, end;
@@ -321,40 +319,6 @@ static int __set_memory_enc_dec(unsigned long addr,
 				      __pgprot(PTE_PRESENT_INVALID));
 }
 
-static int realm_set_memory_encrypted(unsigned long addr, int numpages)
-{
-	int ret = __set_memory_enc_dec(addr, numpages, true);
-
-	/*
-	 * If the request to change state fails, then the only sensible cause
-	 * of action for the caller is to leak the memory
-	 */
-	WARN(ret, "Failed to encrypt memory, %d pages will be leaked",
-	     numpages);
-
-	return ret;
-}
-
-static int realm_set_memory_decrypted(unsigned long addr, int numpages)
-{
-	int ret = __set_memory_enc_dec(addr, numpages, false);
-
-	WARN(ret, "Failed to decrypt memory, %d pages will be leaked",
-	     numpages);
-
-	return ret;
-}
-
-static const struct arm64_mem_crypt_ops realm_crypt_ops = {
-	.encrypt = realm_set_memory_encrypted,
-	.decrypt = realm_set_memory_decrypted,
-};
-
-int realm_register_memory_enc_ops(void)
-{
-	return arm64_mem_crypt_ops_register(&realm_crypt_ops);
-}
-
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 {
 	unsigned long addr = (unsigned long)page_address(page);
-- 
2.43.0

