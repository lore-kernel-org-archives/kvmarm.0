Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA253173A
	for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 17:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VERKU/Kf"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-9de267de2a0so470702266b.3
        for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 09:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700068635; x=1700673435; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cTRruPNWl9dydwy1RolnY7MN//AZ8WOLTxliFM7mi1c=;
        b=VERKU/Kf5hCGmjWs5T2NYwySUP1c7DI1uz21XuID9RChsiuFqgxf3ykfy/s5NKD4Ln
         7E6T7KZ3PdxUcgBa8JrnP2pBItU0L7NVAlDt5POcDOPJRryJap0n3TCUvIpjxucDYohm
         OI5I51QpIj61RYFQAUKmHlYUGogAPpGNeeTx5FL6Di4RLCfCGe6BJ041LSfo7hHwxfue
         rHLtIWQxaSAxZKLdF5QV2TX1iXEBS0JPuzWOIKcC1b60rFzXujMqP2vRe/4gcLdZAodu
         ZcYmrs3zWyqJrtWXr+8fXNE4GxDsYbj5BTCJZbAHrxzQTFZxTmqxQAqaHP2GqEnnpmgy
         UdZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700068635; x=1700673435;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cTRruPNWl9dydwy1RolnY7MN//AZ8WOLTxliFM7mi1c=;
        b=qPzA3+7ozgBeEBEUzZKXu6xrM8iiU44v6lgiFTno/IqgTWOl16KPOdb1HPjtZl+Ktv
         z+bEMZirkIGfzUODG3ajPBL/IYi7ovQD2QirXiM+yBR3MMuSx8bjmE3PfYKSMeZDQuXT
         r/JBIwZc6aOJSNQ06fAZst+8C7QA0VE4Vfb6pntiJfNEajpenXK3Oew0JefwWa1tr7nt
         JvDSxurCo5UAbccpiObvjdHAcCiM2+VnILgcwl6NHCAwOYsSHi80Bnw/gZfbGDOPwpe9
         SahzD1KeBRH2kjy0tOkfqi4t6PM4mCLxkNlmcUlG1oUA2ewDDVJfpu/Kbrm+/HAueXaL
         jiFg==
X-Gm-Message-State: AOJu0Yw/0C5iX1OToXMXZUtCkOfIsPks+/y6gDRg9NZzMRLeRiPv4D7O
	0u/piBu56xiv4C95FCN0EbfX5Ox3NSh4xca5Flw=
X-Google-Smtp-Source: AGHT+IGsNbGDrA60Xa1dYe9ILtVmHQ514rV3j3OHq1AV69tXNThGqDwNIJ6SRVp7ouHANt4Icfonac0rBfGADpZZyaY=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a17:906:6bc9:b0:9c4:1dfa:de9 with
 SMTP id t9-20020a1709066bc900b009c41dfa0de9mr121012ejs.10.1700068635336; Wed,
 15 Nov 2023 09:17:15 -0800 (PST)
Date: Wed, 15 Nov 2023 17:16:39 +0000
In-Reply-To: <20231115171639.2852644-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231115171639.2852644-2-sebastianene@google.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
Message-ID: <20231115171639.2852644-11-sebastianene@google.com>
Subject: [PATCH v3 09/10] arm64: ptdump: Interpret pKVM ownership annotations
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

Add support for interpretting pKVM invalid stage-2 descriptors that hold
ownership information. We use these descriptors to keep track of the
memory donations from the host side.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h          |  7 +++++++
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  7 -------
 arch/arm64/mm/ptdump.c                        | 10 ++++++++++
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 913f34d75b29..938baffa7d4d 100644
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
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 9cfb35d68850..cc2c439ffe75 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -53,13 +53,6 @@ struct host_mmu {
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
diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index ec7f6430f6d7..ffb87237078b 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -273,6 +273,16 @@ static const struct prot_bits stage2_pte_bits[] = {
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
 	}, {
 		.mask	= KVM_PGTABLE_PROT_SW0,
 		.val	= KVM_PGTABLE_PROT_SW0,
-- 
2.43.0.rc0.421.g78406f8d94-goog

