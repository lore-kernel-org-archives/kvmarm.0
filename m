Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53952B9BC
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 13:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730727136; cv=none; b=BQQBUCR0yiu3CeNN7w59YXPK2/HczB1CidrwJtYi5NynZUftw5JQ/gJCxai2cvp+7XCg3JhFfmPEApypkDajHiwr4NcoZp0p7IJSTGdFKz2VhILCSjHYmRPXts+S9K94U9wiFmsY96riwYGRNy5KcTXrvWGCAvYztVPvEoMvZ2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730727136; c=relaxed/simple;
	bh=JCsNEOwCob5F3IJKkBqX1lBcmUqiGgMoJBMXxpVz9bc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JwWubX41oLlRDrrE8uHygXog9uZ5FQZ+0Lx5v6jR8vl6OLRSBPeFoY8m38ppCpoNe5gKajIC0h/49QEetsCL0Vc9Ft/EsWxdncpSr5ANwhlcYFQXhA1d01aWpzC8RvfQKJ4Zk9BBL0Uk58gQrW24M24WRXgTBlc42h1L4m7Nh2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZWjTjeUw; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZWjTjeUw"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e7f633af02so57375767b3.3
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 05:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730727133; x=1731331933; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PKkm6+349ykGA9NvXy7LF0BQjMAqTfQ2kTd431L999Q=;
        b=ZWjTjeUwPkdYFBahyI0/VzddOzTS53JyPRaHkLgGYvuPAd3beuBQ5IAQ93jHbdRDTj
         tnM1YiO5W2t3DIh8WvB4dAM2RjLsA6npB9YPb0lst1aoLyuuAehzdrHFQP+G21tXq5pN
         04SVqG+r8M2wXaHLrfQLqGllZRe89578skixNNz9eG3nvT/mvQ2yR2sVlMYBZQrjvN1f
         xfqVEMBrPCQQ58EhzG0VWFnrtDELsGc6oicaKgZVZjHgEeCoPVwMv1AJ/dFHjfc/feoD
         xB0T4jRB1BZQ8NudgjKIwbul9AyN0+PNUdMWDHW3dIaPJ/Cp344tVbdEj9KDRd0O+32D
         bQzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730727133; x=1731331933;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PKkm6+349ykGA9NvXy7LF0BQjMAqTfQ2kTd431L999Q=;
        b=jpI4FqEK1mYidUd2voY52HXBNS/7iLUYvA5l+sD9m9iGlAwmXk63LjBrRrxwPVhroK
         fH4D02tpST6O4P54MK9PvqrskWqS4/DSBPOZgqbROk++fUv1YbdUO9Uw1SolPus2PZDJ
         upkQPI9yAspHpfLkmL5eEkkEZpkmQ1n9Tfre3zc97RJsl+CBzcFUF0oEk3sTUU8kWPgU
         Ulp8mXiWYHVTWOc7oHIKDSm3p3qDURZNHsDndu9Q4yviwRYvMGb5Q6NcLnQZwfIhVtE1
         AWZahsRRQxURc9l75hXLWvyAp+LQaiZjDv8huBbDX8QJopVLEHaiCDja3qbiOpRlMBcU
         e+Sg==
X-Forwarded-Encrypted: i=1; AJvYcCU2EG/gH8saLPBXjLrCg3zNIssGWPms6CMF7lIMkShDitg5ITEG/MP7ifWapPWy5mkq9Lqajuo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxQKB/Hx594wU7Bi2tfNGXanCS9TW7MX3zHMWdXxnnWz4kqkexC
	3YJ+P/vjU3dbgW6E2a3kLADi8K5NjGqFOOWyZPDDUJy/0Q2DUqSy8hyY2zNOdD0x3NyqpCiPMZV
	V2Wh0EQ==
X-Google-Smtp-Source: AGHT+IEeIacQkmxOu92UwsFG/d4mBUfXOkjaaTFyk9RQX+gm0U4bljU3gFu+U2mMY/h3tB6h+FVJRJ+qoRNf
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a5b:f0f:0:b0:e2e:2cba:ac1f with SMTP id
 3f1490d57ef6-e3087bd5414mr144751276.6.1730727132285; Mon, 04 Nov 2024
 05:32:12 -0800 (PST)
Date: Mon,  4 Nov 2024 13:31:48 +0000
In-Reply-To: <20241104133204.85208-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241104133204.85208-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241104133204.85208-3-qperret@google.com>
Subject: [PATCH 02/18] KVM: arm64: Move enum pkvm_page_state to memory.h
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
2.47.0.163.g1226f6d8fa-goog

