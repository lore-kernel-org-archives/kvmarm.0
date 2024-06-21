Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECA61527BB
	for <kvmarm@lists.linux.dev>; Fri, 21 Jun 2024 12:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973162; cv=none; b=Kw/MJy/Ou9goJSO6hebviwzbswj3dv1qUsHT7vzFgvGG42CIGrDdOAOEW/RaA+XNuR9ZJKQ2sbAX2SAthJ84QwAW2JmWfr6OS9J/FPOQw9Dg6nR27U/OcboBDj+1+8Z6f6hBZFsihD893/3MVFd2IFczbdAtRc5LDo1j+/I+muk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973162; c=relaxed/simple;
	bh=mWLp97bnyLJ2+7AavbpyV1/kRZY65jdnzLdcMXTuA4c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YUikw/9OccIXxi516rjUdE72eWyY3AW4nlOtyvdk5bMS4alRAXa0mR1bogRaSSRM7qvNSp2ovwmBHCaDhsLan8A76ziVP9i3d07GV5upFifeD5wr4mOSIkbJblgN9kfG/Tp00IrcqUGts4hFlzvVIdJPmMU7Ew3QV/VwGT0dsCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mQlyL0W2; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mQlyL0W2"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6311e0f4db4so35045217b3.3
        for <kvmarm@lists.linux.dev>; Fri, 21 Jun 2024 05:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718973160; x=1719577960; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=25Ic4MRU2k7NJP2f+gMGQe2Juiq+UKR6YPOc7ZYN4C4=;
        b=mQlyL0W2nfRww8KAMuXQ5QQPog29tQfxCRF952S4QdU8gqgk8YYTZuEdPIP1mf/QIG
         dDfGDvIohG/sNn0ZXU9IwRd+YZpNY1v5y9zAKdfzQtw31pdWHkykDghyfWMeGVK54wyM
         QOXUHrRqa+A9z3YNehPdJKIkBFLeikelyyYsospDKTYaHqnKHpUZQ/qV2EhbdkopG55D
         eO/syPdu3BkLPomo5kDavCXBIgQzQ/WMWAA28rVdcc4uYPBEsndu5MUwte6Y/7SzscCo
         c+U9lF8bq9oOsK5zCNFkxLw/ihBotu15kgYnoVOSHrQxpvqXLTSgunAY99UJ3atsDbTW
         95Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718973160; x=1719577960;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=25Ic4MRU2k7NJP2f+gMGQe2Juiq+UKR6YPOc7ZYN4C4=;
        b=Y7KGZHxauJw1YW/hkF3+ZRfcWO9ZJGCe6sx0lCVXm1fCbmGkvGJG3Ajei5x6FuCAP8
         wH5OrV25+muVBVZWf+dmkAKpAg6SHR/IyDtudSJxQbA/lseWvOKTHEBXbbMdGN0/8BsT
         XQT95N3j5JekpUNtkgNFPe9lBDsG01RCshApDlm9Zqzs3nkg8mMTWsdCbI7PLbUa4Sa4
         aJ/jcxmu01jNOaR+mW2LYlQ6vurZ5FdAX6aB+R9yXw2XaGdVaCzhspqrXTsHOfknlhN3
         T/AtoanVHsEgRjEB389e5Hw7bR1S4R/6VHNKeCT+3Trx7uZUXZYtFMo9ooJU/QWdoipX
         sbKw==
X-Gm-Message-State: AOJu0Yx8ShGyXpUZnn5B0dq0QMnTeh/rM7LOKb1JgzmNC9n9i99Uv3Jk
	PPucDVRCZA0kTRHyzdJPcrGKNoEkZ82uMwTYe2udwcm9KE0X0AaeSoZqZjkHOBnrobm67wc2dmv
	RnezR7zK2iubbLrlbIaWs0G8L+g==
X-Google-Smtp-Source: AGHT+IH53+5umEtnQUZLfthMpVgy/4eLzcSoA4+oyiYt9jWf+dLgnKlVM+ZCqYhVt+ZaBFR3R5+UiqwV2rm52Qcsq78=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:690c:7441:b0:627:c0ac:a9e7 with
 SMTP id 00721157ae682-63a8f5246b3mr17861817b3.5.1718973159572; Fri, 21 Jun
 2024 05:32:39 -0700 (PDT)
Date: Fri, 21 Jun 2024 12:32:25 +0000
In-Reply-To: <20240621123230.1085265-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240621123230.1085265-1-sebastianene@google.com>
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
Message-ID: <20240621123230.1085265-2-sebastianene@google.com>
Subject: [PATCH v7 1/6] KVM: arm64: Move pagetable definitions to common header
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
2.45.2.741.gdbec12cfda-goog

