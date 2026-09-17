Received: from mta0.migadu.com (out-125.mta0.migadu.com [91.218.175.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545D6363C48
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 09:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636720; cv=none; b=pz82jV2kOlcuGW1quNeKQxvhi7FGBJVVzyHSlMEG4p/EfK0ghJp+CbsikJV7b9Cc9rM6jdO/6R+ivI7NyXWGZHI3uxuyzlBXhZXJtrxsuA7izhtIvG23vh474rMMuDdukhQlp9MHhZtxK1y3zjyxgtYiprP8n+QJ9ztZ144xVZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636720; c=relaxed/simple;
	bh=BDabPLEAy+F0bC1m2aFAySlST0o2PCUlunhb/0Rg9F0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pY9hPDzK1T4voWBKcuB4LaX1VxUlIJuo+cxnczZxkVH97Wb1/LXzjpRBEZ4b293qkv26dInsAD9PZGjz4/DnHBwP8VJkhRVDjr+fWhuSd6+G/mqbdCQnoRTj+uZWt9kDiN1h2kkFHdjN/ZTj0jWrX9d6NofANSRBbAhGfrchRlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oleqo3rd; arc=none smtp.client-ip=91.218.175.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oleqo3rd"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=BDabPLEAy+F0bC1m2aFAySlST0o2PCUlunhb/0Rg9F0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789636716; v=1; x=1790241516;
 b=oleqo3rdDIL06DQxUICjC1cc39hspR0N98Kge6Qy1idNp8VNeZRcqy2S/W98xWSl1v5Y1G1x
 aoDjevkaKfBfQLV2utglGKxxD33wEnJiN/sbUgWLik7iG7o7AIm5S9FTdMjm/gED1McMZi531gy
 Lmpa0C8WhBbG2dQHb16oohb8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 6582ff640713eed0;
	Thu, 17 Sep 2026 09:18:36 +0000
X-Mizu-Trace-ID: 6582ff640713eed0
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	qperret@google.com,
	vdonnefort@google.com,
	martijnbogaard@google.com,
	seiden@linux.ibm.com,
	tabba@google.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/4] KVM: arm64: Move the IPA limit rule into kvm_get_ipa_max()
Date: Thu, 17 Sep 2026 10:18:23 +0100
Message-Id: <20260917091826.2639205-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260917091826.2639205-1-fuad.tabba@linux.dev>
References: <20260917091826.2639205-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the rule kvm_set_ipa_limit() applies to PARange into a helper
beside kvm_get_parange(), which bounds the same field by a different
rule, so the hypervisor can size a guest's IPA space by it.

No functional change intended.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 15 +++++++++++++++
 arch/arm64/kvm/reset.c               | 12 +-----------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 41a8687938eb6..8096b0bf381c2 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -48,6 +48,21 @@ static inline u64 kvm_get_parange(u64 mmfr0)
 	return parange;
 }
 
+/*
+ * The largest IPA size a VM can be given. Unlike VTCR_EL2.PS
+ * (kvm_get_parange()), it isn't clamped to the kernel's PA configuration.
+ */
+static inline u32 kvm_get_ipa_max(u64 mmfr0)
+{
+	unsigned int parange = cpuid_feature_extract_unsigned_field(mmfr0,
+				ID_AA64MMFR0_EL1_PARANGE_SHIFT);
+
+	if (!kvm_lpa2_is_enabled() && PAGE_SIZE != SZ_64K)
+		parange = min(parange, (unsigned int)ID_AA64MMFR0_EL1_PARANGE_48);
+
+	return id_aa64mmfr0_parange_to_phys_shift(parange);
+}
+
 typedef u64 kvm_pte_t;
 
 #define KVM_PTE_VALID			BIT(0)
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 10eb7249aa9e8..757adbce2faac 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -231,19 +231,9 @@ u32 get_kvm_ipa_limit(void)
 
 int __init kvm_set_ipa_limit(void)
 {
-	unsigned int parange;
 	u64 mmfr0;
 
 	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
-	parange = cpuid_feature_extract_unsigned_field(mmfr0,
-				ID_AA64MMFR0_EL1_PARANGE_SHIFT);
-	/*
-	 * IPA size beyond 48 bits for 4K and 16K page size is only supported
-	 * when LPA2 is available. So if we have LPA2, enable it, else cap to 48
-	 * bits, in case it's reported as larger on the system.
-	 */
-	if (!kvm_lpa2_is_enabled() && PAGE_SIZE != SZ_64K)
-		parange = min(parange, (unsigned int)ID_AA64MMFR0_EL1_PARANGE_48);
 
 	/*
 	 * Check with ARMv8.5-GTG that our PAGE_SIZE is supported at
@@ -264,7 +254,7 @@ int __init kvm_set_ipa_limit(void)
 		return -EINVAL;
 	}
 
-	kvm_ipa_limit = id_aa64mmfr0_parange_to_phys_shift(parange);
+	kvm_ipa_limit = kvm_get_ipa_max(mmfr0);
 	kvm_info("IPA Size Limit: %d bits%s\n", kvm_ipa_limit,
 		 ((kvm_ipa_limit < KVM_PHYS_SHIFT) ?
 		  " (Reduced IPA size, limited VM/VMM compatibility)" : ""));
-- 
2.39.5

