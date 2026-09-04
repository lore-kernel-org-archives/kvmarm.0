Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AED47143A;
	Fri,  4 Sep 2026 10:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518156; cv=none; b=Iexdq0BLogUJ3wa4S70iwdAgXwO55IZSUOWJX6/24xXwJSJLF7z+FnAJdTwHLDNFGxtSeWjFktcDzvA8udonY+lGvKxPzzKPi6Qip/VGMb4NcwfmidJh+dCY+YEGHaa3MtfFo+LdqQ3i11e/NL4CvV+uQFj/jet5yI0/y7Q2XJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518156; c=relaxed/simple;
	bh=nd6sf8naTpyYqcNuS3y+EeUYR4Zl5gEmukrd0lFeVSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jP00SoZSDtNlRqU0JtMqx/RNrs8upjF/bevVg7NzEGgezgn+CFQTyUGGZegl1tBzjmm8Mx8SONQ2tf3DGgRoHkXVJ1lfe8I0k6P4++nxSui1seV8WlYIyUzvWCfG6RDOxU9t9NL3xhLgnsRcxUTcTSUfdT/h1UEGwvzV1ZUWi7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ag3TqrjJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ag3TqrjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AAD1F00A3E;
	Fri,  4 Sep 2026 10:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518153;
	bh=u9I2WPocLUacIb6MXv6UW+BXVCGDKNGSQF8ffRh5uJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ag3TqrjJK6NyKSY5HFriLni2RYiMqOyiczi4SedYu9aoxcW7VAiIQmq3OgqnuN+lO
	 t48NCzb9u4ItoAs2nwdCm3BWWbyM8Xvcw4b6JOsIo8nyL+wIOL70dofHXvFQelH2ac
	 rn+fVTW4+VlGbZZYilrDNAqmBV+FoOb6MZh3IgTYfl8Q4U4ujL6wxVBM1KCNyVlsKS
	 nK/KT/uyhGZUhQI6zI29x8SiDyrL1zQquaWzefOINBzcZVtLdxb6pPiclH0+ORPito
	 iSkjUKubJh7FuCBbH0uEHgDigwKXqLbpesSLWU023N2AVQpJipCrJ3qgT24kYgyhoC
	 RwplQVNBH5AaQ==
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
Subject: [PATCH v6 9/9] arm64: realm: Expose the CCA shared granule size through mem_encrypt ops
Date: Fri,  4 Sep 2026 16:04:52 +0530
Message-ID: <20260904103452.1197239-10-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260904103452.1197239-1-aneesh.kumar@kernel.org>
References: <20260904103452.1197239-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CCA guests must align shared/private memory transitions to the size
reported by the host for IPA state changes. This size can be larger than
PAGE_SIZE, so allowing a guest to convert only a PAGE_SIZE-sized subrange
can leave the remaining part of that host-sized range in the wrong state.

Cache the RHI-reported IPA sate change alignment during Realm
initialization and expose it through a new arm64 mem_encrypt callback. Use
PAGE_SIZE as the default shared granule size when no backend callback is
registered.

Validate both the address and byte size passed to set_memory_encrypted()
and set_memory_decrypted() against mem_cc_shared_granule_size() before
calling into the backend. This prevents callers from converting only part
of a host-managed page.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/mem_encrypt.h |  4 ++++
 arch/arm64/mm/mem_encrypt.c          | 32 ++++++++++++++++++++++++----
 drivers/firmware/arm_rmm/rsi.c       | 13 ++++++++++-
 3 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/mem_encrypt.h b/arch/arm64/include/asm/mem_encrypt.h
index ef8b8463e52b..890faeed0eb3 100644
--- a/arch/arm64/include/asm/mem_encrypt.h
+++ b/arch/arm64/include/asm/mem_encrypt.h
@@ -10,6 +10,7 @@ struct device;
 struct arm64_mem_crypt_ops {
 	int (*encrypt)(unsigned long addr, int numpages);
 	int (*decrypt)(unsigned long addr, int numpages);
+	size_t (*cc_shared_granule_size)(void);
 };
 
 int arm64_mem_crypt_ops_register(const struct arm64_mem_crypt_ops *ops);
@@ -18,6 +19,9 @@ int set_memory_encrypted(unsigned long addr, int numpages);
 int set_memory_decrypted(unsigned long addr, int numpages);
 int __set_memory_enc_dec(unsigned long addr, int numpages, bool encrypt);
 
+#define mem_cc_shared_granule_size mem_cc_shared_granule_size
+size_t mem_cc_shared_granule_size(void);
+
 static inline bool force_dma_unencrypted(struct device *dev)
 {
 	return is_realm_world() || is_protected_kvm_guest();
diff --git a/arch/arm64/mm/mem_encrypt.c b/arch/arm64/mm/mem_encrypt.c
index ee3c0ab04384..69783c6a3c08 100644
--- a/arch/arm64/mm/mem_encrypt.c
+++ b/arch/arm64/mm/mem_encrypt.c
@@ -17,8 +17,7 @@
 #include <linux/compiler.h>
 #include <linux/err.h>
 #include <linux/mm.h>
-
-#include <asm/mem_encrypt.h>
+#include <linux/mem_encrypt.h>
 
 static const struct arm64_mem_crypt_ops *crypt_ops;
 
@@ -33,18 +32,43 @@ int arm64_mem_crypt_ops_register(const struct arm64_mem_crypt_ops *ops)
 
 int set_memory_encrypted(unsigned long addr, int numpages)
 {
-	if (likely(!crypt_ops) || WARN_ON(!PAGE_ALIGNED(addr)))
+	unsigned long size = (unsigned long)numpages << PAGE_SHIFT;
+
+	if (likely(!crypt_ops))
 		return 0;
 
+	if (WARN_ON(!IS_ALIGNED(addr, mem_cc_shared_granule_size())))
+		return -EINVAL;
+
+	if (WARN_ON(!IS_ALIGNED(size, mem_cc_shared_granule_size())))
+		return -EINVAL;
+
 	return crypt_ops->encrypt(addr, numpages);
 }
 EXPORT_SYMBOL_GPL(set_memory_encrypted);
 
 int set_memory_decrypted(unsigned long addr, int numpages)
 {
-	if (likely(!crypt_ops) || WARN_ON(!PAGE_ALIGNED(addr)))
+	unsigned long size = (unsigned long)numpages << PAGE_SHIFT;
+
+	if (likely(!crypt_ops))
 		return 0;
 
+	if (WARN_ON(!IS_ALIGNED(addr, mem_cc_shared_granule_size())))
+		return -EINVAL;
+
+	if (WARN_ON(!IS_ALIGNED(size, mem_cc_shared_granule_size())))
+		return -EINVAL;
+
 	return crypt_ops->decrypt(addr, numpages);
 }
 EXPORT_SYMBOL_GPL(set_memory_decrypted);
+
+size_t mem_cc_shared_granule_size(void)
+{
+	if (likely(!crypt_ops) || !crypt_ops->cc_shared_granule_size)
+		return PAGE_SIZE;
+
+	return crypt_ops->cc_shared_granule_size();
+}
+EXPORT_SYMBOL_GPL(mem_cc_shared_granule_size);
diff --git a/drivers/firmware/arm_rmm/rsi.c b/drivers/firmware/arm_rmm/rsi.c
index 2cd53f82432f..eeb797c6c2c7 100644
--- a/drivers/firmware/arm_rmm/rsi.c
+++ b/drivers/firmware/arm_rmm/rsi.c
@@ -19,6 +19,7 @@
 
 static struct realm_config config;
 static struct kobject *cca_kobj;
+static unsigned long ipa_state_change_granule_size;
 
 unsigned long prot_ns_shared;
 EXPORT_SYMBOL(prot_ns_shared);
@@ -155,9 +156,17 @@ static int realm_set_memory_decrypted(unsigned long addr, int numpages)
 	return ret;
 }
 
+static size_t realm_cc_shared_granule_size(void)
+{
+	if (is_realm_world())
+		return ipa_state_change_granule_size;
+	return PAGE_SIZE;
+}
+
 static const struct arm64_mem_crypt_ops realm_crypt_ops = {
 	.encrypt = realm_set_memory_encrypted,
 	.decrypt = realm_set_memory_decrypted,
+	.cc_shared_granule_size = realm_cc_shared_granule_size,
 };
 
 static int realm_register_memory_enc_ops(void)
@@ -167,7 +176,7 @@ static int realm_register_memory_enc_ops(void)
 
 /* we need an aligned struct for rsi_host_call. slab is not yet ready */
 static struct rsi_host_call hostconf_call __initdata;
-static unsigned long __maybe_unused __init get_ipa_state_change_alignment(void)
+static unsigned long __init get_ipa_state_change_alignment(void)
 {
 	long ret;
 	unsigned long shared_granule_size;
@@ -218,6 +227,8 @@ void __init arm64_rsi_init(void)
 		return;
 	if (WARN_ON(rsi_get_realm_config(lm_alias(&config))))
 		return;
+
+	ipa_state_change_granule_size = get_ipa_state_change_alignment();
 	prot_ns_shared = __phys_to_pte_val(BIT(config.ipa_bits - 1));
 
 	if (arm64_ioremap_prot_hook_register(realm_ioremap_hook))
-- 
2.43.0

