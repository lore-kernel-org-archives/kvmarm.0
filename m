Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3632032F772
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 12:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764246139; cv=none; b=aszlpBi/tgKptTBX0dVWUr7UCUnvuexoLl09uLYIywXcR/bHyzhW0VQR+hyFmHBCIUIS01iySWbzrM5uafew1KDKpcm1HEta+BwGFNqhPmLJPwnu1VATxlsDMi2p2FmXT6vJU9d1dIZLIoO+s1AzRMYvFWPzNF0Oe7418u87AOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764246139; c=relaxed/simple;
	bh=Bv03HTAEwBs6qivY1aAC21w+h/aSsQhB6yAZsxK9/tE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QFaYEgGc6OVqbNTE3MwK0TOANh8XqhGwh2GIETdFLQECsdHC65x9fJWSVgh5rhYrB1bNRIHqM4xnkS7Aw63VbLTmrcnbj0FwO+OBgwOTmHztlhYQB6kMBNJWkvo4HndwqaTJZw7ci6JuZmNidQn/ynbj/Ey16mehGg7YhwxOMNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A3AEEXHM; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A3AEEXHM"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4779b432aecso4220195e9.0
        for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 04:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764246136; x=1764850936; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P0wJO5vV2lK/fO4Afzg49DdO91IUwV4uHMwdgGwAU7A=;
        b=A3AEEXHMuPcXyxpuNkwjeWYQjMd48AQMpmrOmAjnKonN8UYD83L70MHG+ngRcUlQNy
         5Hwlpor8ut+ZWxnfNnG3pikGD9pNMuxmRFs3nD/f/PUpnFp2mxVJ+SLO5oCEBLW7OXaD
         8LNZ34Ln64Etymxfq88j2ZJB7aLHfhzP5IdbPujRJNTMQMQOFrJfeSP5TN3L7R/uAlWD
         FQcNFQZhtxuYwSfyU0InhThbp2my1pMuaBIGS8LjebJJcFyTNT4Ct159G2lhbIs05ftZ
         Tn6p1aXaO3dbBky2TuAT3ssmTWyV1A2va+NxtfOJXvA9Ehq29AYllRXZ2rffMulJ95jZ
         aEdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764246136; x=1764850936;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P0wJO5vV2lK/fO4Afzg49DdO91IUwV4uHMwdgGwAU7A=;
        b=d9UY769VPhq0Vqob3G0C5//fISvZQDz2APugbh+XP18j/MYodsuFwdv4LSgEc8Xqxi
         Lc3y2VKSaT9Ai1zs+PSlhGq8i+3A9LkazRkn3AdA+jZJ/2HoYqbEr9RjiKpibNllEh07
         ykU8C/Q//sIyLALDSZdmBzQo381SNfW4BYDE5s6dg13wPHmQSetJjQHYHiaIbodKg1Ag
         1tMythq7XMhB62Z8bzBksdlwMY3NMenpcPtFB7mzSd1AFwGIcxKbhN70oY7noGlZ9c3o
         bYxI77szp4pEo9HT8li2H4lUUUNCPKApmig/O/nJLGfokHtvau1ayg9B6zQb8Msk6tJa
         P+/g==
X-Gm-Message-State: AOJu0Ywan+gOu2m7npmcX8EaPWaq2xxw8hzUZHqqUzMGZPgpjH3iSlC4
	T8VtG9n5sXeimxdFiCAGU0axt7a8tqFuryFmdzC/Ktl9RThzsF64c6igsAmc1eZN1FhrbQdj9g+
	ZrCp01dELT3JdoSYyP2eo5V+DyD+rUZy48zJKgy8silTaapd1l6tw+6v5HnKh1j1eoCpIZVi+7N
	PCGqea1ge8k60DpOuar3oMAujU1hk61uA=
X-Google-Smtp-Source: AGHT+IGVtx5zzqqRmyzyliqynf3VcT/FvMKF3RNUJTbpXA9UYgwsZe54duelP0na7/gXBebJWiULjm2O2Q==
X-Received: from wmgp1.prod.google.com ([2002:a05:600c:2041:b0:477:9f92:40da])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e93:b0:471:9da:5232
 with SMTP id 5b1f17b1804b1-477c10e1ccdmr242794015e9.15.1764246136570; Thu, 27
 Nov 2025 04:22:16 -0800 (PST)
Date: Thu, 27 Nov 2025 12:22:10 +0000
In-Reply-To: <20251127122210.4111702-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251127122210.4111702-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251127122210.4111702-6-tabba@google.com>
Subject: [PATCH v1 5/5] KVM: arm64: Use kvm_has_mte() in pKVM trap initialization
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

When initializing HCR traps in protected mode, use kvm_has_mte() to
check for MTE support rather than kvm_has_feat(kvm, ID_AA64PFR1_EL1,
MTE, IMP).

kvm_has_mte() provides a more comprehensive check:
 - kvm_has_feat() only checks if MTE is in the guest's ID register view
   (i.e., what we advertise to the guest)
 - kvm_has_mte() checks both system_supports_mte() AND whether
   KVM_ARCH_FLAG_MTE_ENABLED is set for this VM instance

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 43bde061b65d..f2060ca66e5d 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -82,7 +82,7 @@ static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
 	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, IMP))
 		val &= ~(HCR_AMVOFFEN);
 
-	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, MTE, IMP)) {
+	if (!kvm_has_mte(kvm)) {
 		val |= HCR_TID5;
 		val &= ~(HCR_DCT | HCR_ATA);
 	}
-- 
2.52.0.487.g5c8c507ade-goog

