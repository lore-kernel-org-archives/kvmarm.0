Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8922A19755A
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 08:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724748365; cv=none; b=F46y4OYNGxqCotvLEZxMDHBXyfR4EgDc5iO6U6dLsfY/xWRQIOTvw0BMYSEpbRvf10xpf6PUrizpxy2nrpI1jtg1Qvo/PU9/ki8DU+b3fYAZQFP9lnvyCiux2Fz050+q2hkkwMHhNUavxrg5sII/ybCXh21KvhtfjbpiBk/GB50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724748365; c=relaxed/simple;
	bh=rW4KThwpJcSUGe+zBRStz3LoS+Yrc62B6qn/kvm1tnY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TbglHo0jFRiS+MLhIkuOqtbok/hvEkMXxYs7RRoDKWjZFLbrHqAn5xDgwzt/chAkB+NvugRyWLBmJyP4pjRPdrJDkAQilHjBlGO5O0YKV4lGsS3Qf9PzPXf4xMk5lhwS6Bzv8v9NAkP9hDhzileEC+UNgUotMXJVsVVe2e1tezM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UyflJ89o; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UyflJ89o"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4280cf2be19so46730535e9.3
        for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 01:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724748361; x=1725353161; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qHaBqPUlgT6qnyCbEa6vL0OJSmkVD7LDCxRnIPOMbIU=;
        b=UyflJ89onqckLx3tPrNUUnXjSthEr4tz0MxVn3yA1af8ogqK47KByN0N4U1+EIe1bc
         d6jDQv2DBLyRlN3DGR7cXuO8q+Z/fJV0Bk182kIOTHByYHasSsgBxkm7w1FTmVcjlf0a
         gltHQn/8yZaskX+86YXO2tfwJedXTd3eAz4vRV4tP64DAdXmf3slFbCOHyvWVSNsqdxY
         3HD+nhEL09Is8RUvn9h9rRArXvxi9zJJSydXgmy4hmONg309bo1H/fFNRJdwdvBoigpv
         RJFkiLmQC6gC/z9e3YibPUXUcjrZV/H1ItjIyAC/RTQQOd+MdHc1BibaYMkAogiY9wNm
         p/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724748361; x=1725353161;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qHaBqPUlgT6qnyCbEa6vL0OJSmkVD7LDCxRnIPOMbIU=;
        b=BKo/tJGUjk5S5MKwMeqMsePvoHUFeB+fKovMWyT/oBKuZ+TGJ3WyPUMeaNgBpCoDIn
         DRmyEZnPSfUhHGFdC/0BGBEMt3cw/JtFS7M4PlrFRcQYhZDO0DvF+LtLgzXrFlUN7C/b
         KML+KEQ/C9m3BtuTOc21qXUar7CN6Hi35j4imACAIxJYmUgztZqMRApJ6gNZJMkOlRzd
         +CqiiG6GOjWqpXK3IxMhVTLFSfKASB/7s0fOAGCnvKsrfRS3XyypCrllaz4Z7HliysSm
         tnv/nc22jH5ZL9jyKvvpyP6coywowcLt4a3uhNLi7kBkkoQopECTxUL44XeOcs8vnT9a
         fkXQ==
X-Gm-Message-State: AOJu0YzTEbWEEzSw1KQc5NY58FxLmaMWUFJWHNowLhi8hpyjsbGrtms4
	r1g6SOuU+92gLoZ6gB4NNquUUBIhNh0P0VaaA9+GPyBew30WDhH1R6Bu9hz/rgXEtGOAkxTjgPi
	0c9cjEVdTZD1mpwcc3WpwHRNRAw==
X-Google-Smtp-Source: AGHT+IHzzuDH/k8rfAfEy4UzTB9FgnKzMzrhIE9XYpvk5ywCd80RVuOo02flrqzP8m1RupJ/VQidebZdm/+KpSkrGqw=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:4f51:b0:425:7ac6:96fe with
 SMTP id 5b1f17b1804b1-42acc8a549fmr653265e9.0.1724748361028; Tue, 27 Aug 2024
 01:46:01 -0700 (PDT)
Date: Tue, 27 Aug 2024 08:45:44 +0000
In-Reply-To: <20240827084549.45731-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240827084549.45731-1-sebastianene@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240827084549.45731-2-sebastianene@google.com>
Subject: [PATCH v9 1/5] KVM: arm64: Move pagetable definitions to common header
From: Sebastian Ene <sebastianene@google.com>
To: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com, 
	ardb@kernel.org, catalin.marinas@arm.com, christophe.leroy@csgroup.eu, 
	james.morse@arm.com, vdonnefort@google.com, mark.rutland@arm.com, 
	maz@kernel.org, oliver.upton@linux.dev, rananta@google.com, 
	ryan.roberts@arm.com, sebastianene@google.com, shahuang@redhat.com, 
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

In preparation for using the stage-2 definitions in ptdump, move some of
these macros in the common header.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 42 ++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 42 ----------------------------
 2 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 19278dfe7978..03f4c3d7839c 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -59,6 +59,48 @@ typedef u64 kvm_pte_t;
 
 #define KVM_PHYS_INVALID		(-1ULL)
 
+#define KVM_PTE_LEAF_ATTR_LO		GENMASK(11, 2)
+
+#define KVM_PTE_LEAF_ATTR_LO_S1_ATTRIDX	GENMASK(4, 2)
+#define KVM_PTE_LEAF_ATTR_LO_S1_AP	GENMASK(7, 6)
+#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RO		\
+	({ cpus_have_final_cap(ARM64_KVM_HVHE) ? 2 : 3; })
+#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RW		\
+	({ cpus_have_final_cap(ARM64_KVM_HVHE) ? 0 : 1; })
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
+#define KVM_PTE_LEAF_ATTR_HI		GENMASK(63, 50)
+
+#define KVM_PTE_LEAF_ATTR_HI_SW		GENMASK(58, 55)
+
+#define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
+
+#define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
+
+#define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
+
+#define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
+					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
+					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
+
+#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
+#define KVM_MAX_OWNER_ID		1
+
+/*
+ * Used to indicate a pte for which a 'break-before-make' sequence is in
+ * progress.
+ */
+#define KVM_INVALID_PTE_LOCKED		BIT(10)
+
 static inline bool kvm_pte_valid(kvm_pte_t pte)
 {
 	return pte & KVM_PTE_VALID;
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9e2bbee77491..c3e9d77bba23 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -17,48 +17,6 @@
 #define KVM_PTE_TYPE_PAGE		1
 #define KVM_PTE_TYPE_TABLE		1
 
-#define KVM_PTE_LEAF_ATTR_LO		GENMASK(11, 2)
-
-#define KVM_PTE_LEAF_ATTR_LO_S1_ATTRIDX	GENMASK(4, 2)
-#define KVM_PTE_LEAF_ATTR_LO_S1_AP	GENMASK(7, 6)
-#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RO		\
-	({ cpus_have_final_cap(ARM64_KVM_HVHE) ? 2 : 3; })
-#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RW		\
-	({ cpus_have_final_cap(ARM64_KVM_HVHE) ? 0 : 1; })
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
-#define KVM_PTE_LEAF_ATTR_HI		GENMASK(63, 50)
-
-#define KVM_PTE_LEAF_ATTR_HI_SW		GENMASK(58, 55)
-
-#define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
-
-#define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
-
-#define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
-
-#define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
-					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
-					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
-
-#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
-#define KVM_MAX_OWNER_ID		1
-
-/*
- * Used to indicate a pte for which a 'break-before-make' sequence is in
- * progress.
- */
-#define KVM_INVALID_PTE_LOCKED		BIT(10)
-
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable_walker	*walker;
 
-- 
2.46.0.295.g3b9ea8a38a-goog

