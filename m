Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9331FC0E0
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 19:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734550870; cv=none; b=J9ur55e3mYL/Fk9tYBUQclTYHlM1n7+ShnGaQ7/8IQlESNTHvqhWRAV/lHFn6asV4g2WIFICJnNXIhgkWLl5DTAmhY3Y9o7bo5uAMvym/Grxk9qa0yR224pQaCZFAEKT9AATYqySARHaJQLIKH7prM/IWOGsZtNaoCUQmURI9gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734550870; c=relaxed/simple;
	bh=wc1iDiXd/4DcstEI4OELjDczZ7jUsFXGK/MVejqbsM4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ljbPHl9BCID81tNx2lV2A2JKYtMDXkaA5pTnK14zcRrKEPONkGNfmcjosjl+aM+eUXfZQ/B7Yg7/BqpQEeVIYRptI834R3U9BtuDs0ZgAktUKmElQp2nPDTjyHmHld9/OYmIWj+Ts/CtmF/hzCWJlRuZuTiPe2hpgvvttcqelqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VvwUqnQV; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VvwUqnQV"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-aa63b02c69cso112633466b.0
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 11:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734550867; x=1735155667; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KvnjN4P6SkLUk+22h2Qqv7fPFdw/8dEz5PT/l7XI0hY=;
        b=VvwUqnQVziHsu7VmrBSBQGfVjoxBtOeCMeRVOU97sxVrWRLwdRWrHdRosVRuTEvCy4
         2E5Kgd7Fgag31nyA89/xK2h0C7SSg8Kv87uhhcrMn6URJDBB3BU9QEiUZ0GXDiZ7BvaW
         giuzVRcRLhr+NbGE+0a7jmn5KzGmHHP09Ke2tF3uf7EgDbbjdOl/Td6cILjplZREph5X
         PIceJUH3heLlCPY7eSNN82fnWtdhPfRw3XkuWEj/dhWAUUNfmq7BUPNhCuMd4TP0UQxY
         cIoqhtiOYPwcZFBl3OrraQwENLuyu3bcxPl8UTXpG0/RpLL4JlVkD/Xp+MV4CVYm8eCg
         5CSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734550867; x=1735155667;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KvnjN4P6SkLUk+22h2Qqv7fPFdw/8dEz5PT/l7XI0hY=;
        b=MnWKg+nJbdjf8zEq3WgvXm7KLi3aaRO3NXFn+QUgBJ79eUaJ7DcUkvAuMzKGcsjruA
         gL82gDqAdpOUyLrPFQLpatv1msg7tdXuUUoyupwdd/q6gCBb4NCG8OkIZRyMJXoHJstv
         bW5vZH2erNs2CVxlYaRzZ8iOACmK94L2RKVk9iOsUTzPmulUJqEs6l63lS43X3q8toJL
         QiUYGTj8vLBSZD332BJ8kQ4tKvVjw1qEDiKH9G9dYWDfmzPJOJRCesoG6c/hoC5LZdkT
         jhHQIVg6oIawx4+PrjKHcE+Zblxu7pLh9CL29GyslvflT6i0Glq2vqSdGTQPZ3rZABOL
         LP4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXZNM3w+TH0pqbsFCgUNTZBC3MhPlr6IeqDVjX/sF1XYBbW1jaTcxaoG4ZcfxMhI6eFIYsIA/0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzEd6gMrd20vU/E9C1dkVSnwh4wJkH3tOLkxGRS34fxKZML27hg
	TpAaFgu0D7rvtxRA8mvdQtvRDxFrEQEnTJENi1u/cnzAty1+fXU2WxivEz3/j0IuUyiZoB+LSoW
	ealYVNQ==
X-Google-Smtp-Source: AGHT+IFzaab4WIj+uu0eFb5+RqKYGg9wSGHkRG5sqXUBPbPpIpzkAXtULFRuD1TiGRf7/yopTJZ+yFFS1fDj
X-Received: from ejcvw10.prod.google.com ([2002:a17:907:a70a:b0:aa9:1b4b:489d])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:c23:b0:aa6:8096:2049
 with SMTP id a640c23a62f3a-aac08147180mr54742866b.13.1734550866770; Wed, 18
 Dec 2024 11:41:06 -0800 (PST)
Date: Wed, 18 Dec 2024 19:40:43 +0000
In-Reply-To: <20241218194059.3670226-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241218194059.3670226-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241218194059.3670226-3-qperret@google.com>
Subject: [PATCH v4 02/18] KVM: arm64: Move enum pkvm_page_state to memory.h
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In order to prepare the way for storing page-tracking information in
pKVM's vmemmap, move the enum pkvm_page_state definition to
nvhe/memory.h.

No functional changes intended.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 34 +------------------
 arch/arm64/kvm/hyp/include/nvhe/memory.h      | 33 ++++++++++++++++++
 2 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 5462faf6bfee..25038ac705d8 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -11,42 +11,10 @@
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_pgtable.h>
 #include <asm/virt.h>
+#include <nvhe/memory.h>
 #include <nvhe/pkvm.h>
 #include <nvhe/spinlock.h>
 
-/*
- * SW bits 0-1 are reserved to track the memory ownership state of each page:
- *   00: The page is owned exclusively by the page-table owner.
- *   01: The page is owned by the page-table owner, but is shared
- *       with another entity.
- *   10: The page is shared with, but not owned by the page-table owner.
- *   11: Reserved for future use (lending).
- */
-enum pkvm_page_state {
-	PKVM_PAGE_OWNED			= 0ULL,
-	PKVM_PAGE_SHARED_OWNED		= BIT(0),
-	PKVM_PAGE_SHARED_BORROWED	= BIT(1),
-	__PKVM_PAGE_RESERVED		= BIT(0) | BIT(1),
-
-	/* Meta-states which aren't encoded directly in the PTE's SW bits */
-	PKVM_NOPAGE			= BIT(2),
-};
-#define PKVM_PAGE_META_STATES_MASK	(~__PKVM_PAGE_RESERVED)
-
-#define PKVM_PAGE_STATE_PROT_MASK	(KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
-static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
-						 enum pkvm_page_state state)
-{
-	prot &= ~PKVM_PAGE_STATE_PROT_MASK;
-	prot |= FIELD_PREP(PKVM_PAGE_STATE_PROT_MASK, state);
-	return prot;
-}
-
-static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
-{
-	return FIELD_GET(PKVM_PAGE_STATE_PROT_MASK, prot);
-}
-
 struct host_mmu {
 	struct kvm_arch arch;
 	struct kvm_pgtable pgt;
diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index ab205c4d6774..0964c461da92 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -7,6 +7,39 @@
 
 #include <linux/types.h>
 
+/*
+ * SW bits 0-1 are reserved to track the memory ownership state of each page:
+ *   00: The page is owned exclusively by the page-table owner.
+ *   01: The page is owned by the page-table owner, but is shared
+ *       with another entity.
+ *   10: The page is shared with, but not owned by the page-table owner.
+ *   11: Reserved for future use (lending).
+ */
+enum pkvm_page_state {
+	PKVM_PAGE_OWNED			= 0ULL,
+	PKVM_PAGE_SHARED_OWNED		= BIT(0),
+	PKVM_PAGE_SHARED_BORROWED	= BIT(1),
+	__PKVM_PAGE_RESERVED		= BIT(0) | BIT(1),
+
+	/* Meta-states which aren't encoded directly in the PTE's SW bits */
+	PKVM_NOPAGE			= BIT(2),
+};
+#define PKVM_PAGE_META_STATES_MASK	(~__PKVM_PAGE_RESERVED)
+
+#define PKVM_PAGE_STATE_PROT_MASK	(KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
+static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
+						 enum pkvm_page_state state)
+{
+	prot &= ~PKVM_PAGE_STATE_PROT_MASK;
+	prot |= FIELD_PREP(PKVM_PAGE_STATE_PROT_MASK, state);
+	return prot;
+}
+
+static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
+{
+	return FIELD_GET(PKVM_PAGE_STATE_PROT_MASK, prot);
+}
+
 struct hyp_page {
 	unsigned short refcount;
 	unsigned short order;
-- 
2.47.1.613.gc27f4b7a9f-goog

