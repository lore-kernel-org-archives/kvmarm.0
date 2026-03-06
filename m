Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C96F3A9D8C
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805767; cv=none; b=aKER3b2IXitu62tPELKodVSlVookUXKy85eVLeON6eYlnc62yRMBYSc92ihQRfb+2iCCxPM+AUExQ288uNU/ik0IQa0KmZ/G/oowSpcxydaefEflGNJpn3WOA+y4kj7x4n6BDf3WUM6R0s864a+9Awd2nfDoGOSPYngFRitTDK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805767; c=relaxed/simple;
	bh=BMbVT7miz8KQ7+AZQDsGiqCWygy7M90I6XCpAU+izv0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nlkLN4mHAzVAUGsUC4T0T6aeB+Lys+XprgkTQXI01iTXhZ6y2zOfnD/oNV86W4PGTmkTAtX/x4NtyJJxhehk/cvpTe7XbIXQIhNTUWplra8tCaJQJ96nlj2re8JJuzPTeAvOLukc1a5nw840g2VMY5d6k6Q69Xrog1e5GJpqZNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2v2eTynn; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2v2eTynn"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b90bb54d034so1024774366b.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805763; x=1773410563; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KT44YeiLTJyOwAcprGitUZ5uZxYG91k2apEts1OjnSo=;
        b=2v2eTynnP/HgBLBP8xZGDq0rP1ga+8pwsUraPXJQINvTjYQcYrEbBc4n2lz2bfuILZ
         mHYoU8mUsQ/asDH4j73lvl/xG/OfgTaDaXNHtScPTkXJsArrJwpPrnvhnVv3dheTVRcv
         Ruf+SiUv76RXkfWu4VzBErjWsVUnodGnksqDtCE40Tr5A7DazhnJfjLpZ7gu/QOliFAh
         HWLdTvd/w0w2h9znNiR3RaypWRyLGTBd4Oa57LnJH2dQ7d6Om2iqX+1YKIWGye5E8/BH
         pOTn+QE/dU+Mps4FsLUDefgAANPCCRtaz01q+AcOHRXIeSDzB7SD/dyfZqCfXHFLCC6H
         hy6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805763; x=1773410563;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KT44YeiLTJyOwAcprGitUZ5uZxYG91k2apEts1OjnSo=;
        b=ZFFH/vL43aTOZkbSXuitsSgrvgmcK8Khszq2JFqGfaLJ25Vj4Q08N0O4jS/RfEJc8W
         EgRbZpPnk5TvYLeOLKIRJsOXGh80+yHf3R0N9Bozcw0GjCTZHYW7fE+12KKDPL6/IA/H
         u+9aKM3s6PSXJM32Bb63i5zpf3Cl4t0fZ1mqzqTi/TTB2yRpf19vfqezeig5/qFL2Rrp
         XUf4b/dAhHuIH+eNm/wj45DxASa0nwl+9O57/yHG/3GVI+417fNYhDDXo0ON6IkMuUJ1
         1zstZD8Zs4W+kFnKhO0PkGaaObKEVS23zAcOhJ6jp7lmSaL6OB2Pn/x451VOM5P5e2yf
         dLYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWurK5pA8sEEZp5WcJqgoW6xe1YvzPc/jpqEVp0Ukm1ejkmKSrx4F1g3TyaEkTj79/6+H20LhA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzVtVs/3UMpleKMpfmnP+k+beNbuDodb7kglLwIIylpDHcqDOk/
	72wxsllihKH7gm/VGc3O5P3i0q01Idx7C70DO20mMmziU74cLIrFgCRT7JLC0akN7mgN5bS3vG8
	Zhg==
X-Received: from ejfw12.prod.google.com ([2002:a17:906:a0c:b0:b94:f06:dc6e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:d54b:b0:b93:5ef5:904f
 with SMTP id a640c23a62f3a-b942d1b1bebmr143967466b.26.1772805762935; Fri, 06
 Mar 2026 06:02:42 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:26 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-8-tabba@google.com>
Subject: [PATCH v1 07/13] KVM: arm64: Simplify nested VMA shift calculation
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

In the kvm_s2_resolve_vma_size() helper, the local variable vma_pagesize
is calculated from vma_shift, only to be used to bound the vma_pagesize
by max_map_size and subsequently convert it back to a shift via __ffs().

Because vma_pagesize and max_map_size are both powers of two, we can
simplify the logic by omitting vma_pagesize entirely and bounding the
vma_shift directly using the shift of max_map_size. This achieves the
same result while keeping the size-to-shift conversion out of the helper
logic.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 833a7f769467..090a906d3a12 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1646,7 +1646,6 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
 				     bool *force_pte, phys_addr_t *ipa)
 {
 	short vma_shift;
-	long vma_pagesize;
 
 	if (*force_pte)
 		vma_shift = PAGE_SHIFT;
@@ -1677,8 +1676,6 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
 		WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
 	}
 
-	vma_pagesize = 1UL << vma_shift;
-
 	if (nested) {
 		unsigned long max_map_size;
 
@@ -1703,8 +1700,7 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
 			max_map_size = PAGE_SIZE;
 
 		*force_pte = (max_map_size == PAGE_SIZE);
-		vma_pagesize = min_t(long, vma_pagesize, max_map_size);
-		vma_shift = __ffs(vma_pagesize);
+		vma_shift = min_t(short, vma_shift, __ffs(max_map_size));
 	}
 
 	return vma_shift;
-- 
2.53.0.473.g4a7958ca14-goog

