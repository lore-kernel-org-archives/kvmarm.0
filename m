Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F691E230E
	for <kvmarm@lists.linux.dev>; Tue,  3 Dec 2024 10:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733222263; cv=none; b=cbgznDwDzdVTQmw1iw42TFKajqFhd71B7Gnd66WscqICq3N/YKAQb36XFM+K5Xb4DXAmWGVuGtyi748Wr2uO1OlYAxcoNjEhkV2h+aa6rFYSQd3UiWLdqSDB+cKhl5BeNDfQ3l7nPZ7tcZLTEb/I2Wyuedv+41kw31spmqeIYok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733222263; c=relaxed/simple;
	bh=Az1fJxxv/3DdXwUg7UmHqkk/Q/SdadU+SOIWO9/jJ8M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k6XUBwtZe7V4BVF0IjSvBOFyXLtYxDnJphL4YHlvj08Toh1e4OscX1U6kniwqXOhfpctbY+Fp2N7O7VawOIbFikrWeN2KG3lMc6OMjhdjtlML0dCInBEluvOXKPC8EjWfjcnBxG1I5hKWIf2XVZaQS9BU3Nd0sL97c9+KSmKLxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mgYmRmJc; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mgYmRmJc"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5d0ccbbc4a7so1953106a12.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Dec 2024 02:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733222259; x=1733827059; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zqJAm+kSytYxVvAYW4fxQLPPZZDbz/LJCZvGfh8JEeM=;
        b=mgYmRmJc6mS3xFZ7f5KUhpLFAEsRS9XVJSL4FeTH4wIDcunvOu9s8rpI5zMeNhVCHW
         9Fwl/GNztBRtCgrFdXH7KZNQGup1skfyHmGpvaF3YB4bL6iKDgrCuI/KibaOWmjUSlr4
         CL+RI0DJSeJApJMvYCTHOT3jjDW+Emuqi2YQSJcv7Ccar3QPmCZUI8a3iuTXstZ/TVtf
         LGU+B3TCpqp0/VkoDctFDL0htHMS4xewLUxXiGEEOoUfDpu3u+rKMOc8EwVLGCRUy3uc
         DLo0yYZ4KCAqzI+HUzGvuf7ktm6Bwxk/P1P2hQH1t0ZqahFeqGcYL9wtzdQ05iAeaTeG
         BiUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733222259; x=1733827059;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zqJAm+kSytYxVvAYW4fxQLPPZZDbz/LJCZvGfh8JEeM=;
        b=bOsxx6v2+oZWpy+VHL/r9MciOr1oFX9Zscv0pnjm4futuTu7JG/EYc4pnodzrrFBMG
         NR1kh1VCXZH3is7Og63RvaTZauEl2OPye1H3sH1ezyVmulUjpz1u97nlw1/higDszhSK
         IZNjwVk2PGBGl6qZ0ChAix0Z8dGUvdOYtS99rk4zbKoioyoRCKRtxC53jtjf/nAFuCJ9
         38E8s1ZcTN1y9LyJvx2F4cUq7rMYbXfpmXcupE9vxcvr36e7xjoAUTSEuBWON7QYbjzU
         lKSS3EvpOCj8gIad9wPBwGkHuFJAEwGHIQ/PGD07LmcleZ/GE/b8wK8piKcn33xTs2VJ
         3+vg==
X-Forwarded-Encrypted: i=1; AJvYcCWQ9noh+lkCvo9zos5e2CmGJMWcGr4LFbcV10ODzFMh8Vmx3tPPM21H5dzMkRTTgBLtZtvmlfI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyNPwN5Pycv+QvHvwgUTbApMEp8hyRP+T53QiBl0HN51X6LuRd3
	a70YOXleNQZeCJUeTBvvxH5RJft4ZLPNfvEJwz2yr6eN1Yo3BNbLgYqSQ2BuHUqkaOLXv8JAqvB
	8YJA4rQ==
X-Google-Smtp-Source: AGHT+IEEJ7rK/bdiM0bZrA50MGLa30le76F10afOeSti4NHKLxb/Hx80hARIZU6bFlY0t7qoOHZgeSespPMG
X-Received: from edb10.prod.google.com ([2002:a05:6402:238a:b0:5d0:d98a:2511])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:5186:b0:5d0:214b:9343
 with SMTP id 4fb4d7f45d1cf-5d10cb4f1fcmr1754647a12.4.1733222259494; Tue, 03
 Dec 2024 02:37:39 -0800 (PST)
Date: Tue,  3 Dec 2024 10:37:18 +0000
In-Reply-To: <20241203103735.2267589-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241203103735.2267589-2-qperret@google.com>
Subject: [PATCH v2 01/18] KVM: arm64: Change the layout of enum pkvm_page_state
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

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 0972faccc2af..ca3177481b78 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -24,25 +24,28 @@
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
+#define PKVM_PAGE_META_STATES_MASK	(~(BIT(0) | BIT(1)))
 
 #define PKVM_PAGE_STATE_PROT_MASK	(KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
 static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
 						 enum pkvm_page_state state)
 {
-	return (prot & ~PKVM_PAGE_STATE_PROT_MASK) | state;
+	BUG_ON(state & PKVM_PAGE_META_STATES_MASK);
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
2.47.0.338.g60cca15819-goog

