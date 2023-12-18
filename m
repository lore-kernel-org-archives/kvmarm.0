Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8D84FF6A
	for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 14:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ScoOryAC"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-33666ece1c6so824002f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 06:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702908007; x=1703512807; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RVeSPgnrVagCch9Gfw7vmBqjH7Htt5Ae7divhOxYmU8=;
        b=ScoOryACTY1dEIFqZyDBzCpNFHeibpYvSdFQ+pgBEIHCnKIHOZuMuvJK7bGDvG2ziY
         wKN8B/7q2IddfnoMxmxTjp22+zwgKwauUxMP7+tfXNOWKZ1tnCJUdtU2xXQpWYPmNTrW
         VGef9t7VOuhHK0VwQKim4XdrVFKIA+V+0sWH8nIfwqPlAvxRxPTrIv7GHkUnqnei7Pt5
         mbtQ7qK97ucEBWTJ45GZNWa/DfFR3wsfI5bqr2PgAB7cB2N6k4GoHZAUUxRXnRdvF+Ae
         weImxdn+9Xl/xXTQrnrnaG6Qni/Mh2Brqb7TeFB7dl118SLYwf6RBDXFWw12/4NEYNBB
         eOBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702908007; x=1703512807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RVeSPgnrVagCch9Gfw7vmBqjH7Htt5Ae7divhOxYmU8=;
        b=PMi9lwLNaxxrZClPQ4CTEE9OpuKf5CUmTGqmpYGGAT0DVR0ZqP85rjZ9fcq+oyp24C
         fNgfpJLBlwWCh6dKMX4po7xIk2BVcmebeqJdbDZ7EOPFe89VGNPGhCsax2wKwcNV3euj
         sGFsFmoWv/maGPWbzQ/f1ReSFA455Ug9o6BstP/xRoP3JIGOHmvHclFsZPOLIS8Nsh4n
         azEGyoc8usGvdain12UVvLrTJW+36Z699UIoO+59lcTXP1fgk5ns3rPLM2mOs0w7vBks
         cxu808Go4x99waOYZnn4Rh9BRuPHKoqjEfMnA+Qh3qJOIk45LfOskbyhS94B48/+Hfp+
         oDkg==
X-Gm-Message-State: AOJu0YxlGlIle39ZOIneSimYErnoFBRArf3AADdYGqr/JtpBCY5YMTf6
	blQzRaf4uX/f/akRsMmY3rwU0RPh9VD0DHMiNvY=
X-Google-Smtp-Source: AGHT+IEiB7+Bsh8hl0BeEi1gynzTqms9UzqwBVVufWuvsdpGz2NnU2Nuh5mMuTpa32OSR/46WklHFd6NPUWZmF2MJtg=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:6000:400f:b0:336:6611:7936 with
 SMTP id cp15-20020a056000400f00b0033666117936mr7753wrb.11.1702908007241; Mon,
 18 Dec 2023 06:00:07 -0800 (PST)
Date: Mon, 18 Dec 2023 13:58:59 +0000
In-Reply-To: <20231218135859.2513568-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231218135859.2513568-2-sebastianene@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231218135859.2513568-11-sebastianene@google.com>
Subject: [PATCH v4 09/10] arm64: ptdump: Interpret pKVM ownership annotations
From: Sebastian Ene <sebastianene@google.com>
To: will@kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, catalin.marinas@arm.com, mark.rutland@arm.com, 
	akpm@linux-foundation.org, maz@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, vdonnefort@google.com, 
	qperret@google.com, smostafa@google.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

When pKVM is enabled the software bits are used to keep track of the
page sharing state. Interepret these fields when pKVM is enabled and
print the sharing state. Move the definitions to common pagetable
header.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h          | 26 ++++++++++
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 26 ----------
 arch/arm64/kvm/ptdump.c                       | 47 +++++++++++++++++--
 3 files changed, 69 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 37f2a8532..7f654d4aa 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -87,6 +87,13 @@ typedef u64 kvm_pte_t;
  */
 #define KVM_INVALID_PTE_LOCKED		BIT(10)
 
+/* This corresponds to page-table locking order */
+enum pkvm_component_id {
+	PKVM_ID_HOST,
+	PKVM_ID_HYP,
+	PKVM_ID_FFA,
+};
+
 static inline bool kvm_pte_valid(kvm_pte_t pte)
 {
 	return pte & KVM_PTE_VALID;
@@ -230,6 +237,25 @@ enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_SW3			= BIT(58),
 };
 
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
+	PKVM_PAGE_SHARED_OWNED		= KVM_PGTABLE_PROT_SW0,
+	PKVM_PAGE_SHARED_BORROWED	= KVM_PGTABLE_PROT_SW1,
+	__PKVM_PAGE_RESERVED		= KVM_PGTABLE_PROT_SW0 |
+					  KVM_PGTABLE_PROT_SW1,
+
+	/* Meta-states which aren't encoded directly in the PTE's SW bits */
+	PKVM_NOPAGE,
+};
+
 #define KVM_PGTABLE_PROT_RW	(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
 #define KVM_PGTABLE_PROT_RWX	(KVM_PGTABLE_PROT_RW | KVM_PGTABLE_PROT_X)
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index ca8f76915..677686b86 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -14,25 +14,6 @@
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
-	PKVM_PAGE_SHARED_OWNED		= KVM_PGTABLE_PROT_SW0,
-	PKVM_PAGE_SHARED_BORROWED	= KVM_PGTABLE_PROT_SW1,
-	__PKVM_PAGE_RESERVED		= KVM_PGTABLE_PROT_SW0 |
-					  KVM_PGTABLE_PROT_SW1,
-
-	/* Meta-states which aren't encoded directly in the PTE's SW bits */
-	PKVM_NOPAGE,
-};
-
 #define PKVM_PAGE_STATE_PROT_MASK	(KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
 static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
 						 enum pkvm_page_state state)
@@ -53,13 +34,6 @@ struct host_mmu {
 };
 extern struct host_mmu host_mmu;
 
-/* This corresponds to page-table locking order */
-enum pkvm_component_id {
-	PKVM_ID_HOST,
-	PKVM_ID_HYP,
-	PKVM_ID_FFA,
-};
-
 extern unsigned long hyp_nr_cpus;
 
 int __pkvm_prot_finalize(void);
diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index 0ad7944e5..4296e739f 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -52,6 +52,11 @@ static bool is_fwb_enabled(const struct pg_state *m)
 	return fwb_enabled;
 }
 
+static bool is_pkvm_enabled(const struct pg_state *m)
+{
+	return is_protected_kvm_enabled();
+}
+
 static const struct prot_bits stage2_pte_bits[] = {
 	{
 		.mask	= PTE_VALID,
@@ -113,22 +118,56 @@ static const struct prot_bits stage2_pte_bits[] = {
 		.val	= PTE_S2_MEMATTR(MT_S2_FWB_NORMAL) | PTE_VALID,
 		.set	= "MEM/NORMAL FWB",
 		.feature_on	= is_fwb_enabled,
+	}, {
+		.mask	= KVM_INVALID_PTE_OWNER_MASK | PTE_VALID,
+		.val	= FIELD_PREP_CONST(KVM_INVALID_PTE_OWNER_MASK,
+					   PKVM_ID_HYP),
+		.set	= "HYP",
+	}, {
+		.mask	= KVM_INVALID_PTE_OWNER_MASK | PTE_VALID,
+		.val	= FIELD_PREP_CONST(KVM_INVALID_PTE_OWNER_MASK,
+					   PKVM_ID_FFA),
+		.set	= "FF-A",
+	}, {
+		.mask	= __PKVM_PAGE_RESERVED | PTE_VALID,
+		.val	= PKVM_PAGE_OWNED | PTE_VALID,
+		.set	= "PKVM_PAGE_OWNED",
+		.feature_on	= is_pkvm_enabled,
+	}, {
+		.mask   = __PKVM_PAGE_RESERVED | PTE_VALID,
+		.val	= PKVM_PAGE_SHARED_OWNED | PTE_VALID,
+		.set	= "PKVM_PAGE_SHARED_OWNED",
+		.feature_on     = is_pkvm_enabled,
+	}, {
+		.mask	= __PKVM_PAGE_RESERVED | PTE_VALID,
+		.val	= PKVM_PAGE_SHARED_BORROWED | PTE_VALID,
+		.set	= "PKVM_PAGE_SHARED_BORROWED",
+		.feature_on     = is_pkvm_enabled,
+	}, {
+		.mask	= PKVM_NOPAGE | PTE_VALID,
+		.val	= PKVM_NOPAGE,
+		.set	= "PKVM_NOPAGE",
+		.feature_on     = is_pkvm_enabled,
 	}, {
 		.mask	= KVM_PGTABLE_PROT_SW0,
 		.val	= KVM_PGTABLE_PROT_SW0,
-		.set	= "SW0", /* PKVM_PAGE_SHARED_OWNED */
+		.set    = "SW0",
+		.feature_off	= is_pkvm_enabled,
 	}, {
-		.mask   = KVM_PGTABLE_PROT_SW1,
+		.mask	= KVM_PGTABLE_PROT_SW1,
 		.val	= KVM_PGTABLE_PROT_SW1,
-		.set	= "SW1", /* PKVM_PAGE_SHARED_BORROWED */
+		.set	= "SW1",
+		.feature_off	= is_pkvm_enabled,
 	}, {
-		.mask	= KVM_PGTABLE_PROT_SW2,
+		.mask   = KVM_PGTABLE_PROT_SW2,
 		.val	= KVM_PGTABLE_PROT_SW2,
 		.set	= "SW2",
+		.feature_off	= is_pkvm_enabled,
 	}, {
 		.mask   = KVM_PGTABLE_PROT_SW3,
 		.val	= KVM_PGTABLE_PROT_SW3,
 		.set	= "SW3",
+		.feature_off	= is_pkvm_enabled,
 	},
 };
 
-- 
2.43.0.472.g3155946c3a-goog

