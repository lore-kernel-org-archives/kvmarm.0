Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDC71E2609
	for <kvmarm@lists.linux.dev>; Tue,  3 Dec 2024 10:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733222264; cv=none; b=noiHoC2QbVXNx/kEwfoYVnU5pLw1QJRmT0vnZvihRxgZnvenC3q2iVTFfUKrk6v3tN9DEhmnjcyovZVjn5wE4EKBhO+3rR0PUJMrJCn9J8AsFdwdOL2xT+5my6X4rUlLJOVQGQHTu+2+I2p+5/rbh4WsVchciiO13n0n0g0X3xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733222264; c=relaxed/simple;
	bh=8zlhOfilNBPHbTyk82/DPjfRWwwj3ZA1xBzeIbJgyAc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uOGBcLba92AB/S2SRqQ7hU476GQafE/eQR6ZfSn5luxXhUk7e1ds0d0SBCEI7+uGrKQqeGvHaxVEcjAJB+qcoiBBvH+Z/d6lhk0OYI2fEa6UHkQJEgdfmmet01W8xsZLQZdeN8vqT1igjVzeh8GfpsvpVZc4o7OwQN5Fl4p9EgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D3kGU3Bb; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D3kGU3Bb"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5d10f6dfcfaso191707a12.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Dec 2024 02:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733222261; x=1733827061; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8VefaN+uYOgTsW1Gl3aOfwIF+ybrZqn9BRXod1CkyGg=;
        b=D3kGU3BbbP8pQjt3GoQqUwN2gB0KKMaA56GIQJJebkQ/FIHCiAnUWcYARz48CfKaCB
         Kq60y9cWQOzKXU9qa1GtgCS1DVZ0XaUtdJM3PjaChCb3YDYN61PxL8ePp/EU+TRya7ll
         N44aiI5kyi82Lk78JCsAojgtisJ+KbI6acJsOFev0W3R4Hi7JhasfTLb+IY7ADffNR14
         nA9lBjwPKyg55mNIMVdElWplP6BHVZd8fowKEk7iGsT/EbLKkVcBte6vxrLzy9ssNM5N
         mXPOJYWG7Q+3nxBH7rlwHNIEFKkbahF+3CheBR1+vUtq360C9iILIC7r9uBToDuiyLp/
         nApg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733222261; x=1733827061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8VefaN+uYOgTsW1Gl3aOfwIF+ybrZqn9BRXod1CkyGg=;
        b=lEMm2hkhWWx4PkwRcg/Xex9Pw6e4h6/3r0EPfL2S5lyrEtHKLJ9k+Ji203FfQ3zUgP
         3PlvPQfD1RGSkbz4Wwstz3YRVjyMOS3WkF5LJ6nhTPtCTPGrw5Xux0K8OW3QXWm8vwrU
         S7JX+D8m7RksTf5hmY19EW3dkW2JIQ4nlve9jDSwEcNGCHBMuf2wRGs3kSBDWITVkCKw
         hI4kDel7tyLkcGYuyso/fAYtf02XkjOV6L8gkJxhRrB3SHL1L1Cxa2mBqlRetZXxQiSG
         zv8inBysujbCv1qDdQcmxgJdJ8X2+gYG8nwEjpBRJ8/n+s377RFv6CVKivjIXLvHjWJj
         P/2w==
X-Forwarded-Encrypted: i=1; AJvYcCXUiMF+yY0E1yWNxwDVGM+8juZqzll0ieQuBPLvbKsq1TnnRpKkhBGU12yYCoDaHTdG7QpZ60g=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3HjCl0RZxSkQjdIfjrQturB9V3fbjJxMKyVjQgXIy4qdHCURB
	Eq+Jz0GdkI8ILJONy+WWfaO74BvOYUUhbJDCj0pQTlq72qMyLLnE2++6n2QSgOcP+F/R7AAndfp
	gzxYDQA==
X-Google-Smtp-Source: AGHT+IGE5QTCAH5U7r3oFdzIO1ntikDg2nD7iaMmA+2JXan6nFEy0acuL36E+ffU/jQD6HNvAgowxLrE1pEQ
X-Received: from edxa18.prod.google.com ([2002:a05:6402:13d2:b0:5cf:b86e:9cac])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:51d0:b0:5d0:d84c:abb3
 with SMTP id 4fb4d7f45d1cf-5d10cb7f906mr1537351a12.26.1733222261602; Tue, 03
 Dec 2024 02:37:41 -0800 (PST)
Date: Tue,  3 Dec 2024 10:37:19 +0000
In-Reply-To: <20241203103735.2267589-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241203103735.2267589-3-qperret@google.com>
Subject: [PATCH v2 02/18] KVM: arm64: Move enum pkvm_page_state to memory.h
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
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 35 +------------------
 arch/arm64/kvm/hyp/include/nvhe/memory.h      | 34 ++++++++++++++++++
 2 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index ca3177481b78..25038ac705d8 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -11,43 +11,10 @@
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
-	BUG_ON(state & PKVM_PAGE_META_STATES_MASK);
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
index ab205c4d6774..6dfeb000371c 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -7,6 +7,40 @@
 
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
+	BUG_ON(state & PKVM_PAGE_META_STATES_MASK);
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
2.47.0.338.g60cca15819-goog

