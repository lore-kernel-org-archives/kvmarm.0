Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F7A5389
	for <kvmarm@lists.linux.dev>; Fri,  7 Oct 2022 23:42:07 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1665186125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fjIY8Z7YBr3tmYx5/J94Gtuu4yXPtVK1vVDelCV7rfM=;
	b=RRZ1MHA3Nh1TCHzLNqbw+h/vkuxo5bVDd1gceq0cYuPZFFz+v5VEizaEEFxwJE7+Ax5pCA
	IEhXq07EqokEJVf+pg9ZH5ZoIwUbjzm7kT4kWFdMgiAX5CZOZAVzuo/yiUi9odTiO2euk2
	NQxb6rR55bdhXTn6a5TwNkrMYRAYerI=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	Ricardo Koller <ricarkol@google.com>,
	David Matlack <dmatlack@google.com>,
	Quentin Perret <qperret@google.com>,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 1/2] KVM: arm64: Work out supported block level at compile time
Date: Fri,  7 Oct 2022 23:41:50 +0000
Message-ID: <20221007234151.461779-2-oliver.upton@linux.dev>
In-Reply-To: <20221007234151.461779-1-oliver.upton@linux.dev>
References: <20221007234151.461779-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221007234150.xUHTCwUicqPgaJPdriFZPcs-YexDnT-NYNhLdt5IuEM@z>

Work out the minimum page table level where KVM supports block mappings
at compile time. While at it, rewrite the comment around supported block
mappings to directly describe what KVM supports instead of phrasing in
terms of what it does not.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 1b098bd4cd37..3252eb50ecfe 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -13,6 +13,18 @@
 
 #define KVM_PGTABLE_MAX_LEVELS		4U
 
+/*
+ * The largest supported block sizes for KVM (no 52-bit PA support):
+ *  - 4K (level 1):	1GB
+ *  - 16K (level 2):	32MB
+ *  - 64K (level 2):	512MB
+ */
+#ifdef CONFIG_ARM64_4K_PAGES
+#define KVM_PGTABLE_MIN_BLOCK_LEVEL	1U
+#else
+#define KVM_PGTABLE_MIN_BLOCK_LEVEL	2U
+#endif
+
 static inline u64 kvm_get_parange(u64 mmfr0)
 {
 	u64 parange = cpuid_feature_extract_unsigned_field(mmfr0,
@@ -58,11 +70,7 @@ static inline u64 kvm_granule_size(u32 level)
 
 static inline bool kvm_level_supports_block_mapping(u32 level)
 {
-	/*
-	 * Reject invalid block mappings and don't bother with 4TB mappings for
-	 * 52-bit PAs.
-	 */
-	return !(level == 0 || (PAGE_SIZE != SZ_4K && level == 1));
+	return level >= KVM_PGTABLE_MIN_BLOCK_LEVEL;
 }
 
 /**
-- 
2.38.0.rc1.362.ged0d419d3c-goog

