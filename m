Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE303BFE2B;
	Mon,  6 Jul 2026 06:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783317961; cv=none; b=JOv19GydvV+mTlpgM+VERFlGlumTtwG3u+bEoPAGomj7QRJdZtmZaCYs1tMcbnl8bB2toA+KUSIHt0Fi3hi9qMInbMYT54DuvW8p5p18ngS2uvv63ES6Q9hW57UPktjDNsuYOiAGXJrJT/A9IkPBpdY5xuQ5Nzbp/moZEu6FVaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783317961; c=relaxed/simple;
	bh=aHZizbhEAfqrPA0yo/xctJ8q0zfUR7Ra2y+sLtJarAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwPODfCPVQdr6FVA5g0na+8pcwhf4vChkmPbwBtyAS3rObSY6LgYrzMzk7P0hF9V/fIK1Rhtdd7xSnlirU9KbhIn1XqVGWKCXj6/1x+2yRcgRw1lNZUUzfLSw2lENLSPHVkBz/YAQ8L90HrV1Bih+hXQr5zK6Stv6wIG5cVkl8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V3zjjBqd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V3zjjBqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425311F000E9;
	Mon,  6 Jul 2026 06:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783317959;
	bh=W0GTpGojCkTLTigXJjUWY8A7Bx3gwP5wr1YCstPCEu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V3zjjBqdcv8eoKzWoxHaUZNJXnhzGnVJ6LDlGEJ0g/uoEjoFlGJF93F7LnFvAzwV1
	 ZBoUn5L0SHty3yrfyEXpodJLyNpLg9ibW1FD6o19jfXV6Mg8PkyG3vA4bDbyRbWl7k
	 aYfp4Y3Gd4HMjFmfHABdZ2ib3xuZGeb219FrxQF6xeTtaBTK5EUv5SlOjZD9KwMrdm
	 9O++XOLGiT8/DkGqOnnMoCJugcTTEiJOuSWAxMqrv/PSfrYbEIBaMAxPoEvPCJZL/j
	 YbdPph+0mAX3ay04g4PWU7ERX+vPDrchXGh8sqfvzNb3hUlOly9QrJ01d/pvD89OWm
	 weNWhxvBWxVkw==
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
Subject: [PATCH v5 10/10] arm64: realm: Expose the CCA shared granule size through mem_encrypt ops
Date: Mon,  6 Jul 2026 11:34:32 +0530
Message-ID: <20260706060432.1375570-11-aneesh.kumar@kernel.org>
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
 arch/arm64/kernel/rsi.c              | 13 ++++++++++-
 arch/arm64/mm/mem_encrypt.c          | 32 ++++++++++++++++++++++++----
 3 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/mem_encrypt.h b/arch/arm64/include/asm/mem_encrypt.h
index f6325f30e844..5018581fed87 100644
--- a/arch/arm64/include/asm/mem_encrypt.h
+++ b/arch/arm64/include/asm/mem_encrypt.h
@@ -9,6 +9,7 @@ struct device;
 struct arm64_mem_crypt_ops {
 	int (*encrypt)(unsigned long addr, int numpages);
 	int (*decrypt)(unsigned long addr, int numpages);
+	size_t (*cc_shared_granule_size)(void);
 };
 
 int arm64_mem_crypt_ops_register(const struct arm64_mem_crypt_ops *ops);
@@ -17,6 +18,9 @@ int set_memory_encrypted(unsigned long addr, int numpages);
 int set_memory_decrypted(unsigned long addr, int numpages);
 int __set_memory_enc_dec(unsigned long addr, int numpages, bool encrypt);
 
+#define mem_cc_shared_granule_size mem_cc_shared_granule_size
+size_t mem_cc_shared_granule_size(void);
+
 static inline bool force_dma_unencrypted(struct device *dev)
 {
 	return is_realm_world();
diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index f52f240bb44c..54fb929067c9 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -20,6 +20,7 @@
 
 static struct realm_config config;
 static struct kobject *cca_kobj;
+static unsigned long ipa_state_change_granule_size;
 
 unsigned long prot_ns_shared;
 EXPORT_SYMBOL(prot_ns_shared);
@@ -168,9 +169,17 @@ static int realm_set_memory_decrypted(unsigned long addr, int numpages)
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
@@ -180,7 +189,7 @@ static int realm_register_memory_enc_ops(void)
 
 /* we need an aligned struct for rsi_host_call. slab is not yet ready */
 static struct rsi_host_call hostconf_call __initdata;
-static unsigned long __maybe_unused __init get_ipa_state_change_alignment(void)
+static unsigned long __init get_ipa_state_change_alignment(void)
 {
 	long ret;
 	unsigned long shared_granule_size;
@@ -230,6 +239,8 @@ void __init arm64_rsi_init(void)
 		return;
 	if (WARN_ON(rsi_get_realm_config(lm_alias(&config))))
 		return;
+
+	ipa_state_change_granule_size = get_ipa_state_change_alignment();
 	prot_ns_shared = __phys_to_pte_val(BIT(config.ipa_bits - 1));
 
 	if (arm64_ioremap_prot_hook_register(realm_ioremap_hook))
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
-- 
2.43.0

