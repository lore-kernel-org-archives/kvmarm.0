Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFBAD27E;
	Mon,  9 Mar 2026 10:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773052044; cv=none; b=r2B4/NEiw3/698gUyJ0hd2PJrx5AJwUsfR4tU0kV1IJQ6XZpRqrsO5S7ccrq8IbSq9UEWAmLmCD8G8wDhw3HhIiAtsrJOFBIsQ0fAPD60XRzgkM94vYPNHs6F/XZlNSsGGtP6OViBgI8Ws5IsZmS7mh/oHJx5xGwmjoFTI8Uc/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773052044; c=relaxed/simple;
	bh=U8KMVDhCdCRR46uKVZyF+IY0pUAxZ+MW0TRjxXNFwc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjHhEOJpR1NL/wbeFMt473RbeoftGkRA8S+YrWVoZRhqG+NcKjeP/fT978j0cJCQQEnh4wiD+Mfm0Vkg3fOEWU5hfHEUX4eZZ2SJrOXCqkDCWeNz9ze19DbdNSJPI1lQlw2BBHKWkIrTeXzMBdBHC7I0PgBegTv6f2a50Ik7lqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZkXOP2IF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZkXOP2IF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D118CC2BCB1;
	Mon,  9 Mar 2026 10:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773052044;
	bh=U8KMVDhCdCRR46uKVZyF+IY0pUAxZ+MW0TRjxXNFwc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkXOP2IF+fZeolZeJDoWcCInM9zFsWlI4r2Qqct29NvUYfl2t3NQLL8p5jF1dHxQv
	 namsjETaddjGozCYsIsYLxdVKMO5nliwieQhRoiwzKBiPYJB0u7ouzq2UM+4tJtraJ
	 5ZFtsld42uvOx+LvR6IZzgSMoRQNJxrPMRJ268g5EyrL7EnvHZLiuZaOQDE+svaW6w
	 1l1hqIG08ZHszctDytzL+IQUHKr0t9XIunx313TqyRuC47zS3Y0TY2B9X1JatGZN43
	 oAx/AvfcYTmWjfluiany8Vp4fRU1DyP9HcdYxbv48gN6bD2zNO9YXUpsdfoR68dm4M
	 87BJ1RR4vs53A==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v3 3/3] coco: guest: arm64: Add Realm Host Interface and hostconf RHI
Date: Mon,  9 Mar 2026 15:56:25 +0530
Message-ID: <20260309102625.2315725-4-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260309102625.2315725-1-aneesh.kumar@kernel.org>
References: <20260309102625.2315725-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- describe the Realm Host Interface SMC IDs and result codes in a new
  asm/rhi.h header
- expose struct rsi_host_call plus an rsi_host_call() helper so we can
  invoke SMC_RSI_HOST_CALL from C code
 - add RHI hostconf SMC IDs and helper to query version, features, and IPA
   change alignment
 - derive the realm hypervisor page size during init and abort realm setup
   on invalid alignment

This provides the host page-size discovery needed by previous patch that
align shared buffer allocation/decryption to host requirements.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/mem_encrypt.h |  3 ++
 arch/arm64/include/asm/rhi.h         | 24 +++++++++++++
 arch/arm64/include/asm/rsi.h         |  2 ++
 arch/arm64/include/asm/rsi_cmds.h    | 10 ++++++
 arch/arm64/include/asm/rsi_smc.h     |  7 ++++
 arch/arm64/kernel/Makefile           |  2 +-
 arch/arm64/kernel/rhi.c              | 53 ++++++++++++++++++++++++++++
 arch/arm64/kernel/rsi.c              | 13 +++++++
 arch/arm64/mm/mem_encrypt.c          |  8 +++++
 9 files changed, 121 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/rhi.h
 create mode 100644 arch/arm64/kernel/rhi.c

diff --git a/arch/arm64/include/asm/mem_encrypt.h b/arch/arm64/include/asm/mem_encrypt.h
index 314b2b52025f..5541911eb028 100644
--- a/arch/arm64/include/asm/mem_encrypt.h
+++ b/arch/arm64/include/asm/mem_encrypt.h
@@ -16,6 +16,9 @@ int arm64_mem_crypt_ops_register(const struct arm64_mem_crypt_ops *ops);
 int set_memory_encrypted(unsigned long addr, int numpages);
 int set_memory_decrypted(unsigned long addr, int numpages);
 
+#define mem_decrypt_granule_size mem_decrypt_granule_size
+size_t mem_decrypt_granule_size(void);
+
 int realm_register_memory_enc_ops(void);
 
 static inline bool force_dma_unencrypted(struct device *dev)
diff --git a/arch/arm64/include/asm/rhi.h b/arch/arm64/include/asm/rhi.h
new file mode 100644
index 000000000000..0895dd92ea1d
--- /dev/null
+++ b/arch/arm64/include/asm/rhi.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+
+#ifndef __ASM_RHI_H_
+#define __ASM_RHI_H_
+
+#include <linux/types.h>
+
+#define SMC_RHI_CALL(func)				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
+			   ARM_SMCCC_SMC_64,		\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,\
+			   (func))
+
+unsigned long rhi_get_ipa_change_alignment(void);
+#define RHI_HOSTCONF_VER_1_0		0x10000
+#define RHI_HOSTCONF_VERSION		SMC_RHI_CALL(0x004E)
+
+#define __RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT BIT(0)
+#define RHI_HOSTCONF_FEATURES		SMC_RHI_CALL(0x004F)
+#define RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT	SMC_RHI_CALL(0x0050)
+#endif
diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
index 88b50d660e85..ae54fb3b1429 100644
--- a/arch/arm64/include/asm/rsi.h
+++ b/arch/arm64/include/asm/rsi.h
@@ -67,4 +67,6 @@ static inline int rsi_set_memory_range_shared(phys_addr_t start,
 	return rsi_set_memory_range(start, end, RSI_RIPAS_EMPTY,
 				    RSI_CHANGE_DESTROYED);
 }
+
+unsigned long realm_get_hyp_pagesize(void);
 #endif /* __ASM_RSI_H_ */
diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
index 2c8763876dfb..a341ce0eeda1 100644
--- a/arch/arm64/include/asm/rsi_cmds.h
+++ b/arch/arm64/include/asm/rsi_cmds.h
@@ -159,4 +159,14 @@ static inline unsigned long rsi_attestation_token_continue(phys_addr_t granule,
 	return res.a0;
 }
 
+static inline unsigned long rsi_host_call(struct rsi_host_call *rhi_call)
+{
+	phys_addr_t addr = virt_to_phys(rhi_call);
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RSI_HOST_CALL, addr, &res);
+
+	return res.a0;
+}
+
 #endif /* __ASM_RSI_CMDS_H */
diff --git a/arch/arm64/include/asm/rsi_smc.h b/arch/arm64/include/asm/rsi_smc.h
index e19253f96c94..9ee8b5c7612e 100644
--- a/arch/arm64/include/asm/rsi_smc.h
+++ b/arch/arm64/include/asm/rsi_smc.h
@@ -182,6 +182,13 @@ struct realm_config {
  */
 #define SMC_RSI_IPA_STATE_GET			SMC_RSI_FID(0x198)
 
+struct rsi_host_call {
+	union {
+		u16 imm;
+		u64 padding0;
+	};
+	u64 gprs[31];
+} __aligned(0x100);
 /*
  * Make a Host call.
  *
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 76f32e424065..fcb67f50ea89 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -34,7 +34,7 @@ obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
 			   cpufeature.o alternative.o cacheinfo.o		\
 			   smp.o smp_spin_table.o topology.o smccc-call.o	\
 			   syscall.o proton-pack.o idle.o patching.o pi/	\
-			   rsi.o jump_label.o
+			   rsi.o jump_label.o rhi.o
 
 obj-$(CONFIG_COMPAT)			+= sys32.o signal32.o			\
 					   sys_compat.o
diff --git a/arch/arm64/kernel/rhi.c b/arch/arm64/kernel/rhi.c
new file mode 100644
index 000000000000..d2141b5283e1
--- /dev/null
+++ b/arch/arm64/kernel/rhi.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+
+#include <asm/rsi.h>
+#include <asm/rhi.h>
+
+/* we need an aligned rhicall for rsi_host_call. slab is not yet ready */
+static struct rsi_host_call hyp_pagesize_rhicall;
+unsigned long rhi_get_ipa_change_alignment(void)
+{
+	long ret;
+	unsigned long ipa_change_align;
+
+	hyp_pagesize_rhicall.imm = 0;
+	hyp_pagesize_rhicall.gprs[0] = RHI_HOSTCONF_VERSION;
+	ret = rsi_host_call(&hyp_pagesize_rhicall);
+	if (ret != RSI_SUCCESS)
+		goto err_out;
+
+	if (hyp_pagesize_rhicall.gprs[0] != RHI_HOSTCONF_VER_1_0)
+		goto err_out;
+
+	hyp_pagesize_rhicall.imm = 0;
+	hyp_pagesize_rhicall.gprs[0] = RHI_HOSTCONF_FEATURES;
+	ret = rsi_host_call(&hyp_pagesize_rhicall);
+	if (ret != RSI_SUCCESS)
+		goto err_out;
+
+	if (!(hyp_pagesize_rhicall.gprs[0] & __RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT))
+		goto err_out;
+
+	hyp_pagesize_rhicall.imm = 0;
+	hyp_pagesize_rhicall.gprs[0] = RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT;
+	ret = rsi_host_call(&hyp_pagesize_rhicall);
+	if (ret != RSI_SUCCESS)
+		goto err_out;
+
+	ipa_change_align = hyp_pagesize_rhicall.gprs[0];
+	/* This error needs special handling in the caller */
+	if (ipa_change_align & (SZ_4K - 1))
+		return 0;
+
+	return ipa_change_align;
+
+err_out:
+	/*
+	 * For failure condition assume host is built with 4K page size
+	 * and hence ipa change alignment can be guest PAGE_SIZE.
+	 */
+	return PAGE_SIZE;
+}
diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index c64a06f58c0b..6e35cb947745 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -13,8 +13,10 @@
 #include <asm/io.h>
 #include <asm/mem_encrypt.h>
 #include <asm/rsi.h>
+#include <asm/rhi.h>
 
 static struct realm_config config;
+static unsigned long ipa_change_alignment = PAGE_SIZE;
 
 unsigned long prot_ns_shared;
 EXPORT_SYMBOL(prot_ns_shared);
@@ -138,6 +140,11 @@ static int realm_ioremap_hook(phys_addr_t phys, size_t size, pgprot_t *prot)
 	return 0;
 }
 
+unsigned long realm_get_hyp_pagesize(void)
+{
+	return ipa_change_alignment;
+}
+
 void __init arm64_rsi_init(void)
 {
 	if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_SMC)
@@ -146,6 +153,12 @@ void __init arm64_rsi_init(void)
 		return;
 	if (WARN_ON(rsi_get_realm_config(&config)))
 		return;
+
+	ipa_change_alignment = rhi_get_ipa_change_alignment();
+	/* If we don't get a correct alignment response, don't enable realm */
+	if (!ipa_change_alignment)
+		return;
+
 	prot_ns_shared = BIT(config.ipa_bits - 1);
 
 	if (arm64_ioremap_prot_hook_register(realm_ioremap_hook))
diff --git a/arch/arm64/mm/mem_encrypt.c b/arch/arm64/mm/mem_encrypt.c
index 38c62c9e4e74..f5d64bc29c20 100644
--- a/arch/arm64/mm/mem_encrypt.c
+++ b/arch/arm64/mm/mem_encrypt.c
@@ -59,3 +59,11 @@ int set_memory_decrypted(unsigned long addr, int numpages)
 	return crypt_ops->decrypt(addr, numpages);
 }
 EXPORT_SYMBOL_GPL(set_memory_decrypted);
+
+size_t mem_decrypt_granule_size(void)
+{
+	if (is_realm_world())
+		return max(PAGE_SIZE, realm_get_hyp_pagesize());
+	return PAGE_SIZE;
+}
+EXPORT_SYMBOL_GPL(mem_decrypt_granule_size);
-- 
2.43.0

