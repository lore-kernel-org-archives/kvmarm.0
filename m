Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BD620E033
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 15:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744817221; cv=none; b=fvX5dL7gPAb0lbG+49InwhelefDZ0gql8LGr6ATGxLlqlU/47FnbHJ9gijonkZXTN1wtfsMKvqPPdU6AnBaUsfppPN5cwpVRki9SNtlxPSUB543n6ISXbXG9o2VXMcmkiWoNcf9S8BZ2gQAgxfBzaATGJeBGmY3uwM3Ty1e0yHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744817221; c=relaxed/simple;
	bh=2VwDODIxhUffdZwjAx4r5VNASzG0d9BWhmRZ0Me6Fuo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=afwVsGrWbezC6gamcSOYMbD/cwBM3oMUXprOPENYONqqEBzwPKM1AU+J9ktlcJbZdKeV3+zuBbd0mknslGmRboKyW5vDK9+0DDmBo8Wrl0/BFz2KT99Z6tStKUiGUuZuAy9NlxyvXrUbJbSECA7k9ywINzo3TiYaLyfrvSYxcAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VnK4BKXx; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VnK4BKXx"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5f435440b1cso3355176a12.3
        for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 08:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744817217; x=1745422017; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sWpGHRaShaKEt1EwgADnEDZtkiEBTsCp5JfVvOy2vqs=;
        b=VnK4BKXx/0cbvj2+ImFLXgSXdyxbmEM18dnqXmGukjuJYl4LfOB04UgJq6qofNl3TQ
         Tmgzkf+yd0Grx3KjlXC6FVZ8Avk/ulXq0eGaF1LJgo2ys8U/TfEoXXJ3sn8PufthiB3d
         XzouHGoIetDBD+DYruX6i3E9j9rtk2JusM+CPNswnJi+guUQgE5I9+dWkJUq+jeG78Tt
         NtDECEoPcFcq+s8XpgjFsJptUVqnp3dqyZIROMYgRO+1p0g6wqQwUUOJTT2usy9g3FMQ
         uylsvcyEDIumSt1VtN+vT8zDMuWomMxhql7bKncQhdfEwUas34ejxgrJJxnhe9GRUX/e
         dT0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744817217; x=1745422017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sWpGHRaShaKEt1EwgADnEDZtkiEBTsCp5JfVvOy2vqs=;
        b=Cj/aaEV1iBwCHM1tsHVX/J2JbmEz2tRaWL4IwL+c86DnaOYj8yrZ6OCQQRdW0bU62n
         yYpymJkoDBdlFlX+BI5jAHuLs41lWXHvJSQAsLHVz2qrQvhTz5jOAQuav6tDJuCht69x
         zHKNSTO1VxEihDf2AHWGQa+AEU6e5fiF+VV0+e2AvljCpZQOqwrrZf473zO4Z/LKr+1K
         03/J6b/WDPUjrf031okJjQNgaWEgNL2pZb3G+kfHWSDBgPz0N4kAS8OvqIpaH8UYxwZX
         1uOXwJVfLP/QvwP5bIA4bryFptbYbA0tEKGv5SiUHor9TpHcbNBR/64NdKKta0AG3foV
         O2Xw==
X-Forwarded-Encrypted: i=1; AJvYcCXqP76wO4OxnyCjj/VUd9rsxHk5FV3bdsuf/xaM+W/YvocHlUB/zcl5BprR4HHybm0JF7zL5ds=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7PUV93pA4u96LsDRhLbnwOLhqLQGWtZaxBX9aHmq0YIgaPenS
	nSjRAjWPhBdES/T1MzNi5qI7fDdzdX3NTIkOfYjtQvjgkHvhcDz/27gkEG3I3uR0+2ncyKR0rIX
	6vVxtOg==
X-Google-Smtp-Source: AGHT+IEoG2AXXZ1tWBUhjh5KrFg0jiFxDBUl8QZtd9ikeeeP7z6vejMB73nvwGYxLNaTouC7ucA8ZutxaU7j
X-Received: from ediq14.prod.google.com ([2002:a50:cc8e:0:b0:5e6:e69f:4a7f])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:34cb:b0:5e5:3643:c8b5
 with SMTP id 4fb4d7f45d1cf-5f4b75c8c33mr1934847a12.30.1744817217576; Wed, 16
 Apr 2025 08:26:57 -0700 (PDT)
Date: Wed, 16 Apr 2025 15:26:43 +0000
In-Reply-To: <20250416152648.2982950-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250416152648.2982950-1-qperret@google.com>
X-Mailer: git-send-email 2.49.0.604.gff1f9ca942-goog
Message-ID: <20250416152648.2982950-4-qperret@google.com>
Subject: [PATCH v2 3/7] KVM: arm64: Use 0b11 for encoding PKVM_NOPAGE
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <tabba@google.com>, 
	Quentin Perret <qperret@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The page ownership state encoded as 0b11 is currently considered
reserved for future use, and PKVM_NOPAGE uses bit 2. In order to
simplify the relocation of the hyp ownership state into the
vmemmap in later patches, let's use the 'reserved' encoding for
the PKVM_NOPAGE state. The struct hyp_page layout isn't guaranteed
stable at all, so there is no real reason to have 'reserved' encodings.

No functional changes intended.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/memory.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 178028172c0b..bf28f9f9de65 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -23,7 +23,6 @@ enum pkvm_page_state {
 	PKVM_PAGE_OWNED			= 0ULL,
 	PKVM_PAGE_SHARED_OWNED		= BIT(0),
 	PKVM_PAGE_SHARED_BORROWED	= BIT(1),
-	__PKVM_PAGE_RESERVED            = BIT(0) | BIT(1),
 
 	/*
 	 * 'Meta-states' are not stored directly in PTE SW bits for hyp and
@@ -31,9 +30,8 @@ enum pkvm_page_state {
 	 * entries). For the host, meta-states are stored directly in the
 	 * struct hyp_page.
 	 */
-	PKVM_NOPAGE			= BIT(2),
+	PKVM_NOPAGE			= BIT(0) | BIT(1),
 };
-#define PKVM_PAGE_META_STATES_MASK	(~__PKVM_PAGE_RESERVED)
 
 #define PKVM_PAGE_STATE_PROT_MASK	(KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
 static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
-- 
2.49.0.604.gff1f9ca942-goog

