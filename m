Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E04276033
	for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 15:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708441898; cv=none; b=h1vzLNQweTniOI8mqCGOqjRIWvOk6BoflLpuwZw+4ALvOGnQZYOeAwYoChhwiwkFCLlO9GD86sp2wWMMv96L0EU4d6XtOX2iriJ3ghxroZKlXV43+hQwfp4NPsB5bgxu9kOFHtUevFjWyRpwpl+UEH42KQVMtfdKl/4qR8w+6kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708441898; c=relaxed/simple;
	bh=tK68vHtvU4jfzgwQpLeiCDjQItafC4TSz2LntPJnZug=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S28y0VoCqvj1mBwhXENO4QTQnTOHqMC1bgdEpEVlJiknWFXJQnUOWacjkCOEcI8fBIYzDeQy9FBw5fSnv5S0bxXVeYuzQk3Qd+DHHZ0tHa9MqaCfvD85UgjNUXp3iRVj27bK45Vmrbdq65OpEU47hNx+bVweb3+M22xUx/uoUmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=STvPB3UA; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="STvPB3UA"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-40e4478a3afso27361555e9.1
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 07:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708441895; x=1709046695; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cjfo7uNgJv27FUK5l6GgvtACWLoTbWUGGoRS4ldTMrk=;
        b=STvPB3UAN8TKylaxcFhyKYySO7rK305tuQkpM4NIF3XbY+SD5d75ZkqMLde6rvck9Q
         tfY1snV7q86G/+2+4LglZffseKyAf35yC17pkllpVCFcuobQ0Ba6jW1E7dVibQ/4TVk9
         7AjIqSh+OWyQDc1SEKbuz7rTlz10masNoqwGBe3hGHgcEguFMyrJmNs296lcfmDwvup5
         5V0U1a9uodAR/LL8lYGJiJk0HlJTj5pPdMJ+etcrBrpEB31v5ti+vGRQTJJVn9Jdre1A
         04NNoEHx2PXRlXaUXJBTScKZPwNngkyWdPwUjWjRiupf9yfj616sPd3YkL6BSf57aHiL
         x0dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708441895; x=1709046695;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cjfo7uNgJv27FUK5l6GgvtACWLoTbWUGGoRS4ldTMrk=;
        b=sPL3xT/Zc0dJZ5/FhHN6R2NUS/Ub48RP8oumaEh31M04pJUWP/6ZSsMYOKhHLCaHla
         j1Ee5IYZAw5LfyMgCfKaGTYV7xFm2zsXfyHk+Jf0qI0yu7iKtfan0M8DfSBUd15uZFAd
         YNmIfwDg/uWvwqUlIfZo7d/pBgmy9UOWrQ3XYfOiHIb1a7xoEYs9EShmDSS0x5N/biJf
         QOZOXIFjLB4mToHj7O2zvAT47vlfnGYcpiqE9wIqi6zfedud7Ty1WmXfmZEvN9ZXf46o
         g7CJlR9CiAUVdQ7iiFkvalY6F2lbmZOFPCGI3PN26qqBc0GgPC6FnR/cxA3KEA1+UUC0
         /HIw==
X-Gm-Message-State: AOJu0Yz/BsSb/LsX9p48DQFxpSfcS6X4F9BhFpYWbMSpRza9cwSojXlV
	Z0OFjzjA5FZO53Jya+sYyvIuHMcMFjAj8QyddfFQhxOrDIt31dnQ6LVhjmF/KuXXNLyMmkC/3Rn
	1CrLXC8TjEmZlzvvrL4Q2anDxsw==
X-Google-Smtp-Source: AGHT+IHdCZ5TqbTsfSuOqqxhf+xHb2vc1nneU67rDQqtKt9bp2XX4wb5ljOmuGSRDmA2T01yj63B5vDYpWG3ovlQVXU=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:a3a1:b0:410:e4fe:1a1f with
 SMTP id hn33-20020a05600ca3a100b00410e4fe1a1fmr157148wmb.0.1708441894686;
 Tue, 20 Feb 2024 07:11:34 -0800 (PST)
Date: Tue, 20 Feb 2024 15:10:30 +0000
In-Reply-To: <20240220151035.327199-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240220151035.327199-1-sebastianene@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240220151035.327199-2-sebastianene@google.com>
Subject: [PATCH v6 1/6] KVM: arm64: Move pagetable definitions to common header
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, gshan@redhat.com, james.morse@arm.com, 
	mark.rutland@arm.com, maz@kernel.org, oliver.upton@linux.dev, 
	rananta@google.com, ricarkol@google.com, ryan.roberts@arm.com, 
	shahuang@redhat.com, suzuki.poulose@arm.com, will@kernel.org, 
	yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, vdonnefort@google.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for using the stage-2 definitions in ptdump, move some of
these macros in the common header.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 42 ++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 42 ----------------------------
 2 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index cfdf40f734b1..dd759e93084a 100644
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
index ab9d05fcf98b..eb83c8464b36 100644
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
2.44.0.rc0.258.g7320e95886-goog

