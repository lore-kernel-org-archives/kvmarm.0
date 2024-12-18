Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFCE156991
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 19:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734550867; cv=none; b=UfAyHHM1wa1HBkKOjiMo90yB0gfmaocSB28uqtWacC3AdFa8w80LRdE3VA8yEM829wVahhWmNhbQ8YkUvdQZ03F9GGSXSz7cS8jROhS9lXtC10Lr+u5wt0Diq7iayS3lx0bvOaqRN0/sPyzsqD1AujbeKa6Wr1j+BTuImoYrSWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734550867; c=relaxed/simple;
	bh=Kg88ZLOSt5DEJULJvuUpLuYaHJObdPA+yjSMbyikhzU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hUE7iQtuyORh9MIYGJM3oWhn773E90UCuX4uUOgswHdnqNPklP+Hfsg75QW3W3hFM7casT4/w8N+VsIpnpnt40c25o5G3Hpnl1avp+6eGjErph3TtcC/aP1xpk1FhUeLL9c7uaBpBxdGwN/uOcewHJlz6rAoehIAkxJgBwT9Mog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y/ds9Ich; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y/ds9Ich"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5d3f0411814so6704518a12.0
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 11:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734550864; x=1735155664; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nRdmYoUKXOUG+sswfkSeT6n5jAc9VmmCt4ArLqZWt3Y=;
        b=y/ds9Ich4Nvj+9OzNKBIimn8HAcHd1asAFGBFWmhL/A5A9cb/Vgb5M0HQsj7nGwOXe
         rJf5N99qBIIJ0M1K+UCn1I8pSFZnPbp08tyi2Mz7ou+Y2ZL97Q1W2GQ7TYoym0YZF6aY
         Wx72HDCR1K2nkJyC2BNpZYrc6PR25RPaH4ET0DC0vmFBknCjmWDyXDwyPxFXJ1333Fs/
         z6WXi6K1KQh9Cb4XDfJKDUXW/UWRqA46W5HMiQ7erjo13EL8EToMWvW892qWfukVSPHd
         ycODFUUJ1l4Jix/rGpg3xJUu6C58okyaK+WaLk8WhIO88KuGszvqFR9y4CAZkd5uJlUV
         t/OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734550864; x=1735155664;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nRdmYoUKXOUG+sswfkSeT6n5jAc9VmmCt4ArLqZWt3Y=;
        b=CpqD30cjhfAORE3Nugwiezcb5wnMXUy51bE0siatTYev6gcziN8EOoTxdkNhY8176l
         25Z20SuNXkibIEfk4E9xZuCC3dcxTXSKrF1cuHpB4G+4xJqu9l76fvtWu5csIaotvZpO
         m+BzFxu/kaq7k/whSCb94A4RBCyVZgozqZffn3J2/Y8nbIRJWvE4/CTcx7dDtU2vU0/9
         d1x09yJvR36gU6JO3cSbKmtuwv6VXwmGr7TGxFzYq8B0o0vw6ZfdQ9tXejH8b6lO2Ank
         hTV9owCy9g+ffPDV6BrzEVq5mfq8k5DOvZYN6c8dFyfh63Oc3IJu6/T3ksoppsJCfYCP
         XE7A==
X-Forwarded-Encrypted: i=1; AJvYcCXyCJb0/pIdmANBXul9WPD979XWRN2s99PavI9CcRICFsvD2IC0P9DGDxDje3C/HotgFjT6MsY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzr/Fvf2uJfFoSmVeK3D3D189SR0mEMykHSsBjdF9O43zDuFC4b
	qNkGA78ZJA1t9mAv4EnSjp3qcKB3lrDl0fPeMlkU3Eqz0FVNsPFOMC8v49DxdaShE9p6CgZJQWV
	kXs7IAQ==
X-Google-Smtp-Source: AGHT+IHvQzDESjuWp5L1AoEov+naUf7YhDv2p3IzRK4XOlwykk+DiFMJtRC57ZjwupiXLJO6FV3a8dSL7apE
X-Received: from edbfj18.prod.google.com ([2002:a05:6402:2b92:b0:5d4:34da:32db])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:528a:b0:5cf:e218:984f
 with SMTP id 4fb4d7f45d1cf-5d7ee3ff473mr4159198a12.27.1734550864372; Wed, 18
 Dec 2024 11:41:04 -0800 (PST)
Date: Wed, 18 Dec 2024 19:40:42 +0000
In-Reply-To: <20241218194059.3670226-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241218194059.3670226-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241218194059.3670226-2-qperret@google.com>
Subject: [PATCH v4 01/18] KVM: arm64: Change the layout of enum pkvm_page_state
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The 'concrete' (a.k.a non-meta) page states are currently encoded using
software bits in PTEs. For performance reasons, the abstract
pkvm_page_state enum uses the same bits to encode these states as that
makes conversions from and to PTEs easy.

In order to prepare the ground for moving the 'concrete' state storage
to the hyp vmemmap, re-arrange the enum to use bits 0 and 1 for this
purpose.

No functional changes intended.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 0972faccc2af..5462faf6bfee 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -24,25 +24,27 @@
  */
 enum pkvm_page_state {
 	PKVM_PAGE_OWNED			= 0ULL,
-	PKVM_PAGE_SHARED_OWNED		= KVM_PGTABLE_PROT_SW0,
-	PKVM_PAGE_SHARED_BORROWED	= KVM_PGTABLE_PROT_SW1,
-	__PKVM_PAGE_RESERVED		= KVM_PGTABLE_PROT_SW0 |
-					  KVM_PGTABLE_PROT_SW1,
+	PKVM_PAGE_SHARED_OWNED		= BIT(0),
+	PKVM_PAGE_SHARED_BORROWED	= BIT(1),
+	__PKVM_PAGE_RESERVED		= BIT(0) | BIT(1),
 
 	/* Meta-states which aren't encoded directly in the PTE's SW bits */
-	PKVM_NOPAGE,
+	PKVM_NOPAGE			= BIT(2),
 };
+#define PKVM_PAGE_META_STATES_MASK	(~__PKVM_PAGE_RESERVED)
 
 #define PKVM_PAGE_STATE_PROT_MASK	(KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
 static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
 						 enum pkvm_page_state state)
 {
-	return (prot & ~PKVM_PAGE_STATE_PROT_MASK) | state;
+	prot &= ~PKVM_PAGE_STATE_PROT_MASK;
+	prot |= FIELD_PREP(PKVM_PAGE_STATE_PROT_MASK, state);
+	return prot;
 }
 
 static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
 {
-	return prot & PKVM_PAGE_STATE_PROT_MASK;
+	return FIELD_GET(PKVM_PAGE_STATE_PROT_MASK, prot);
 }
 
 struct host_mmu {
-- 
2.47.1.613.gc27f4b7a9f-goog

