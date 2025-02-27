Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B723EEC3
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 00:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740616400; cv=none; b=X17/d4yLNSxVvt4ZoVlzYztbtzf3CelgFUbaSUpSiMWg/b35JBWiC9on5TY9pLqb1Ahjx91w3CkI4+2hFTxRXZBBJ4GnEPWrdYeUHva9CyRlpgRz/mzgez+f5F7zLBjZjAnpG8KUrCvJQCZTGkZAyUVuKvSNwTykSL1E/g+4ypc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740616400; c=relaxed/simple;
	bh=261ZPCgnrvvDXYcolm1gc3HyK99Q/XfdlKS2Gd7awrQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G6HegHxg6IUIl5TA7MlIbo2/HRZWfXZoGhDU9ryk69gYbvTkUQSnL1drg1ZwvgxwTLEGL7hFjhdtkPZOPgoau3MD95EowrcIBGPPuvnK78+qnO/wAp+zJrLZHxxu+rGMwoD8QwsV7BkcqZubTBEbJ/zcU7XnZ7Yhv6HubgD9BPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v7hOSCU9; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v7hOSCU9"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-ab77dd2c243so49762666b.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 16:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740616397; x=1741221197; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nP/0ASv3gZv6Dq4JFLJ6V0xk++r2sqgnKrNUADZ27XI=;
        b=v7hOSCU9MjSyte0LKNVxvCa3taQFQmpQmWNhJ16AXo5zaxXl2LV2uTgyBmH2TLyqiY
         rBehjta0NiZf50BGonhPZcpxYLOqpEvS6rTQegj+HKl1JF5c1IHbNGj51tfphuUtrp1H
         q8DERNl8icAeNtUFg9Pj1D0dc3gjnazcloNvwBUeh0vnUvvPyh4aG/IkrbBKpgD+co8g
         8Zd8hBZayb/9uhCpX78rYxr5Bm8J4TDpHnmib0HJDgvikZV+HcDTQlEjW31urzMwLflV
         2k3e+gJ+ER/95WFWi5xJryc8JNyWb4h7Za1Z22XyqM3YjUcCZgDqEeFiRvYBqG/r4Ke6
         6aHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740616397; x=1741221197;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nP/0ASv3gZv6Dq4JFLJ6V0xk++r2sqgnKrNUADZ27XI=;
        b=U5tR4NOLFpaC0rYRO2NYxkleSlfqIcxqTPeYkA976BKCYBnjQ53qDVgpXaw7hnAlF9
         UAGOM+jelodmkZ9zGPXoG6sPviCo5aU5Ei2IXuiZmJ5G2R4BP7wHkRT8+59CZj5/DdNy
         IcvNg7O9eUgJBIs+k5LOqnOhBV5zSwx+hVbxnVdYSBBn9mFH6ju/500RXynDCj+qP6zA
         oeJFoKmNChQYllkWCxxUOmjAySib47SjFzxWePC40ZXGsv6uC4QV5vZFgrNfoJBWqqDJ
         uPGBIug4bVxykhn7o5KtukoGgdE8Fy/o8aemOod1O6xJvbM3dsGffrNca6vvh7IA6M9M
         0lhw==
X-Forwarded-Encrypted: i=1; AJvYcCUlghepUujhUrYVgP+Yng4DrmC9N2bLinqM9ZxNpIk3vbuErcXnxC0y3YMVO4v84xldcXYliYo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzls8R1VcSsYs1Wlk8CEUUADXwo9kVbkTShXT6SCcXqNQPDTKhB
	vD+UdqIib1scIDxZa2bm7gK7euNRFJaBLgsyM1rT2mTMezJgo5dxYz/erftOghGIruKEku6Dspg
	LePo64Q==
X-Google-Smtp-Source: AGHT+IG1YIW+GqBALCieMnU4BqI9X9ToFAuUlbxFKvAcEIATQsa5h/n36+QHjYaFBr4TgnPvu4HEXBtbRBDi
X-Received: from ejcrr23.prod.google.com ([2002:a17:907:8997:b0:abb:9ace:21a3])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:7841:b0:aa6:5eae:7ece
 with SMTP id a640c23a62f3a-abed10179f1mr945776366b.43.1740616396839; Wed, 26
 Feb 2025 16:33:16 -0800 (PST)
Date: Thu, 27 Feb 2025 00:33:06 +0000
In-Reply-To: <20250227003310.367350-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250227003310.367350-1-qperret@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250227003310.367350-3-qperret@google.com>
Subject: [PATCH 2/6] KVM: arm64: Use 0b11 for encoding PKVM_NOPAGE
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The page ownership state encoded as 0b11 is currently considered
reserved for future use, and PKVM_NOPAGE uses bit 2. In order to
simplify the relocation of the hyp ownership state into the
vmemmap in later patches, let's use the 'reserved' encoding for
the PKVM_NOPAGE state. The struct hyp_page layout isn't guaranteed
stable at all, so there is no real reason to have 'reserved' encodings.

No functional changes intended.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/memory.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 34233d586060..642b5e05fe77 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -13,18 +13,15 @@
  *   01: The page is owned by the page-table owner, but is shared
  *       with another entity.
  *   10: The page is shared with, but not owned by the page-table owner.
- *   11: Reserved for future use (lending).
  */
 enum pkvm_page_state {
 	PKVM_PAGE_OWNED			= 0ULL,
 	PKVM_PAGE_SHARED_OWNED		= BIT(0),
 	PKVM_PAGE_SHARED_BORROWED	= BIT(1),
-	__PKVM_PAGE_RESERVED		= BIT(0) | BIT(1),
 
 	/* Meta-states which aren't encoded directly in the PTE's SW bits */
-	PKVM_NOPAGE			= BIT(2),
+	PKVM_NOPAGE			= BIT(0) | BIT(1),
 };
-#define PKVM_PAGE_META_STATES_MASK	(~__PKVM_PAGE_RESERVED)
 
 #define PKVM_PAGE_STATE_PROT_MASK	(KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
 static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
-- 
2.48.1.658.g4767266eb4-goog

