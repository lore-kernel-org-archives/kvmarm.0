Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240B8207E09
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 17:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734371892; cv=none; b=lEQEsYep8HiteS0LpAR2daSS7vhKHKmRznLToZv8Ubj96Yyl0DTDBpEYh32ho6/zNqn70RFWVV0n0gzNbVMgk+0gwumPmrsCO/80/dUouKrFZxXwdHce/EzYv3vB5kWhiDnyBSza7ZCzXBeFqQv/H85IGqCnKnEndoX+br20pmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734371892; c=relaxed/simple;
	bh=YMN5nrVnm7MBUS1/MQRoHbk4AumZcaFpRHgZ3PnOdz4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XZepQbctD2zOiy4UvHdS3PQ5tQYuJyU2PMljHcFCH6+MMcbrsCHsOtVzDPgCw01xs+Q/F3ilufz5GbEjy38zMPi27/eK6BqK5q4D/yW4qDnq4ovCYTY3YJD1bhnaA97BDMnOnkHeD/+RB2DmSWirneMsMTVhwtL6k+dJmlpsGyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p4zfs4t2; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p4zfs4t2"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-aa6869e15ebso574476366b.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 09:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734371889; x=1734976689; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IKKtybYMKA7zsu5unQStwbk02cJvQpLoCTe4uFlfQf0=;
        b=p4zfs4t2+excMqTjGOiZVVZuHFDpFTosA0jznoQ9Uar26pTVq4U1kcpL7s1JAPxGJC
         76heIQB/MgkyNga8AtCDFna9Lnu5OCTq8T6jKa0e5rXMjDGLDWLpnftZ7pX3+fHX2+dN
         hwG1HoiQLmmwx2P03/BEheDGC11pZboNnL+DSJM0PVwfnmSVa8QnhsL0I0GEi3/52NDb
         kGPYP1YcVAX45cueUYGkImD0rM1gfdqfDpI12i3rPlp5seoZ97yTIVvfXzxu4kwXBP69
         FaKKTOTBm03dol8wq7LC3Ms1YXYng9MeTZ30KN8x42lujTdeq/ApcOlzvUbPse1O/zMx
         8aKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734371889; x=1734976689;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IKKtybYMKA7zsu5unQStwbk02cJvQpLoCTe4uFlfQf0=;
        b=NOcjb3u+RzLdAmLS8LyYZSJ4XvppJCXn1HAYOPfGBK5c2RC+6cgH17/z1c4oEkCg+/
         nUe2fli890noeIMCMdcm5EgtjHZY1yCk02Rob3itqmRBBxob7mWFWGE+hVMGVLpvwoH7
         +Z74za9z+UWx5KG8OFVoEKzN9KHqYlmFpASHvrlhXGY0z69zJr61HqVVEh1PaB2hKBEC
         0HmiOqkNFHpGduOsVNdD2GDWB1VFVk1JpcG6xq/5d7xH7z34f7LisXFB5wHck+9mnidD
         ka9KUqGn/BYP5gsAgRG+XIEdgIM0/EkfBV4sZRMFoKLisna1tI3oYmJIyJ1nn8qN7miK
         jecg==
X-Forwarded-Encrypted: i=1; AJvYcCUgHMyAjeuMiTJPRhhBfOBK08AvTIPWU25LK4lYDOVMNKZVFF5IXozL6daaXFP3/IOI2GjmfdA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxW+Em51PXcxZOH0GZHvcGyunPU5/PXNEeS4pEf56IheyAo2+ty
	rlxpXgNZbpc5VYk+2YQRAIX28+Wvu0OPHV1xytO0IopMWHkpKLaN8jDgSxSAFbIczyj63gYiE5t
	RTdanwQ==
X-Google-Smtp-Source: AGHT+IGNIsVt310HOq58YI6qOaJU0R9CQoXTaCdBST5eb3fkgxzHsq57oQwvG8ZxTSrd75RDqwWjPK4h1541
X-Received: from edbin5.prod.google.com ([2002:a05:6402:2085:b0:5d2:727b:9b35])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:7da5:b0:aa6:9540:570f
 with SMTP id a640c23a62f3a-aabdc8bd0e0mr21397566b.18.1734371889630; Mon, 16
 Dec 2024 09:58:09 -0800 (PST)
Date: Mon, 16 Dec 2024 17:57:47 +0000
In-Reply-To: <20241216175803.2716565-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216175803.2716565-3-qperret@google.com>
Subject: [PATCH v3 02/18] KVM: arm64: Move enum pkvm_page_state to memory.h
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

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 34 +------------------
 arch/arm64/kvm/hyp/include/nvhe/memory.h      | 33 ++++++++++++++++++
 2 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 8c30362af2b9..25038ac705d8 100644
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
-#define PKVM_PAGE_META_STATES_MASK	(~(BIT(0) | BIT(1)))
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
index ab205c4d6774..c84b24234ac7 100644
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
+#define PKVM_PAGE_META_STATES_MASK	(~(BIT(0) | BIT(1)))
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

