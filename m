Received: from out-236.mta0.migadu.com (out-236.mta0.migadu.com [91.218.175.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A10194
	for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 00:23:23 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1673395414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D5xfAEmK6VbYRFlnNHDhaBUhTqgSFqiHTqH3/+fHTPQ=;
	b=WFlbHAWIc0zs7pU3bGakD+YbD6DjlilnvKS7Z4K2n3quKoQYoqjGuad2ewHQYlZFFZpgdf
	9Wby05Yg8EbUWk8zD1Q3ZeKGIHJCSZS1EBwVcq1sdj87s/3GdSLb5O4Wf8vk71NrBLzxrq
	D0iPGWjEOekptCy+xy6kIm9zvAuQNoE=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>,
	Reiji Watanabe <reijiw@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/5] KVM: arm64: Hoist S2 PTE definitions into kvm_pgtable.h
Date: Wed, 11 Jan 2023 00:02:56 +0000
Message-Id: <20230111000300.2034799-2-oliver.upton@linux.dev>
In-Reply-To: <20230111000300.2034799-1-oliver.upton@linux.dev>
References: <20230111000300.2034799-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM's definitions for S2 PTEs are scattered between kvm_pgtable.h and
pgtable.c. Keep it all in one place by moving it all into the header.

No functional change intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 34 ++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 34 ----------------------------
 2 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 63f81b27a4e3..8071698cc680 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -39,6 +39,40 @@ typedef u64 kvm_pte_t;
 
 #define KVM_PTE_VALID			BIT(0)
 
+#define KVM_PTE_TYPE			BIT(1)
+#define KVM_PTE_TYPE_BLOCK		0
+#define KVM_PTE_TYPE_PAGE		1
+#define KVM_PTE_TYPE_TABLE		1
+
+#define KVM_PTE_LEAF_ATTR_LO		GENMASK(11, 2)
+
+#define KVM_PTE_LEAF_ATTR_LO_S1_ATTRIDX	GENMASK(4, 2)
+#define KVM_PTE_LEAF_ATTR_LO_S1_AP	GENMASK(7, 6)
+#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RO	3
+#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RW	1
+#define KVM_PTE_LEAF_ATTR_LO_S1_SH	GENMASK(9, 8)
+#define KVM_PTE_LEAF_ATTR_LO_S1_SH_IS	3
+#define KVM_PTE_LEAF_ATTR_LO_S1_AF	BIT(10)
+
+#define KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR	GENMASK(5, 2)
+#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R	BIT(6)
+#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W	BIT(7)
+#define KVM_PTE_LEAF_ATTR_LO_S2_SH	GENMASK(9, 8)
+#define KVM_PTE_LEAF_ATTR_LO_S2_SH_IS	3
+#define KVM_PTE_LEAF_ATTR_LO_S2_AF	BIT(10)
+
+#define KVM_PTE_LEAF_ATTR_HI		GENMASK(63, 51)
+
+#define KVM_PTE_LEAF_ATTR_HI_SW		GENMASK(58, 55)
+
+#define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
+
+#define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
+
+#define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
+					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
+					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
+
 #define KVM_PTE_ADDR_MASK		GENMASK(47, PAGE_SHIFT)
 #define KVM_PTE_ADDR_51_48		GENMASK(15, 12)
 
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b11cf2c618a6..3efe3aca3cb9 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -12,40 +12,6 @@
 #include <asm/stage2_pgtable.h>
 
 
-#define KVM_PTE_TYPE			BIT(1)
-#define KVM_PTE_TYPE_BLOCK		0
-#define KVM_PTE_TYPE_PAGE		1
-#define KVM_PTE_TYPE_TABLE		1
-
-#define KVM_PTE_LEAF_ATTR_LO		GENMASK(11, 2)
-
-#define KVM_PTE_LEAF_ATTR_LO_S1_ATTRIDX	GENMASK(4, 2)
-#define KVM_PTE_LEAF_ATTR_LO_S1_AP	GENMASK(7, 6)
-#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RO	3
-#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RW	1
-#define KVM_PTE_LEAF_ATTR_LO_S1_SH	GENMASK(9, 8)
-#define KVM_PTE_LEAF_ATTR_LO_S1_SH_IS	3
-#define KVM_PTE_LEAF_ATTR_LO_S1_AF	BIT(10)
-
-#define KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR	GENMASK(5, 2)
-#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R	BIT(6)
-#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W	BIT(7)
-#define KVM_PTE_LEAF_ATTR_LO_S2_SH	GENMASK(9, 8)
-#define KVM_PTE_LEAF_ATTR_LO_S2_SH_IS	3
-#define KVM_PTE_LEAF_ATTR_LO_S2_AF	BIT(10)
-
-#define KVM_PTE_LEAF_ATTR_HI		GENMASK(63, 51)
-
-#define KVM_PTE_LEAF_ATTR_HI_SW		GENMASK(58, 55)
-
-#define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
-
-#define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
-
-#define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
-					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
-					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
-
 #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
 #define KVM_MAX_OWNER_ID		1
 
-- 
2.39.0.314.g84b9a713c41-goog

