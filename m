Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80653CA49C
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 20:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784579736; cv=none; b=PkSTVr3pUnbLcdnFrsqiCxIRNQ+aedUHt9jcqVk8ByR1nZM4Pcpzf1pcdpDS9MLy0enLn805BuoCo+LwiKqh4/tJf6xkysRXz8rlkJHPA9Sc4jyPi+BuR9gq37Xrj2gzyyrBfV1NteXlba7Tnc/WwVCYDpzbIwP7GqvRIiiZCGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784579736; c=relaxed/simple;
	bh=AEIRTgpv3KiZzLgCI7Rlc0YF+p0PrirI6dYHcC7ObJI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tzlBQvGUIIeE7vA/6SC187H5D9rTEq8SsjN4kLVs6vmK6glJauRySIzmZLdVToLSR3fNATJadLxPbaGhlP50Cq7xwIl5o3C7tBNADUjx5bIQEqGhDFTc0xZki+NiclBdymXoEy91jUh5TAX/gMDRTnxZXWksvXpvCToBD8ONuKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NhgdfUo0; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NhgdfUo0"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4955e865174so9682395e9.3
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 13:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784579733; x=1785184533; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LA6BVqbIhEwIMVMXHgwJu8nqjN0TgDEofdIQtGf4DJQ=;
        b=NhgdfUo0n6tMYLZt8eZmICQ843Xg8+V8fNGSFPmICKJW+6fn7ybG9pRhXBXfKXEfOT
         g++Mdb7lSYt+fr+CiyQJj4gpXQG8CKeCvKWhljy9uUmGh4Xn83BbMfsnmSD7DL9zis8X
         BOPgiMgWMBPNE7pNuV5tkpcP3kjZkTMewhgXlBg5ewqmrnaaaOrCXQH5Li2rbcoCocnW
         9lSnoH7oC5bx88gTjw6bBNvZTwjwzP7++f1g21vKTwQdo4MLtDyQx1EQJ4BiyqpsuXiO
         Ancv+NNObUr9lkLq04kMDLjFBCskXqzB1PnWIwSHuli68OjThkZ3OsPeuRWtKzm2TeK6
         J2IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784579733; x=1785184533;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LA6BVqbIhEwIMVMXHgwJu8nqjN0TgDEofdIQtGf4DJQ=;
        b=HFeupQxDi1dUalLXbEueq2Q2rum7MlDenLLAuhY9n94aJQ8WpzGinnSVZFGN/9pSWI
         GN0nMJ+HTRidv4hPRbBxLiWqWrLmX/OTe1WRc/oTsFdn5JrxgSTKONe4mM66KyN3ad4q
         3g1siEQ6KZ4Kqq34lner1M/iiFfbJy1padsfZY6FdTCeaUuG3Mm65ZTcok+hRA3bpk6Z
         J0s3J0j527UYDUZdSxTgmKhFpQCeZ6KAtMP+W40Cw2RGp8N1cawEY/lKyr2o8TLVYE5i
         Uzu/szV2k9pPptjAuQUQYa8cd/NBrt60vxb6tgwfEVjwHYPshCnxPopjeDTlkvl9ZgQY
         EEvA==
X-Forwarded-Encrypted: i=1; AHgh+Rogm7KRjkuWPlPzriMU7L5sSUteP+yYUFFvMgQ05tB5DgG6xwMuTfoQdPcN9ONjgRKwW6lH0P0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzy669nNkLbl17RDMx5gN9GoUIkZliwPtziKYnG4wkMntm/gMNg
	p7eHM8irAuTjQo10H2i0coQw99vr9a5D10eacqFuWivFjADEsRILjTispMr6b41a6//SGPMHvSj
	KWCzCSpRXZKiU+g==
X-Received: from wmpi31.prod.google.com ([2002:a05:600c:4b1f:b0:489:1b01:386f])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:310e:b0:495:52dc:73a1 with SMTP id 5b1f17b1804b1-49552dc776bmr119110015e9.29.1784579732667;
 Mon, 20 Jul 2026 13:35:32 -0700 (PDT)
Date: Mon, 20 Jul 2026 20:35:29 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260720203529.1276355-1-smostafa@google.com>
Subject: [PATCH] KVM: arm64: Optimize protected mode and FWB
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

KVM opportunistically enables FWB if supported by the system for guest
VMs, which allows it to elude cache maintenance for data as they are
forced to be cacheable from stage-2.
In that case, __clean_dcache_guest_page() will immediately return.
However in protected mode, before calling __clean_dcache_guest_page()
it loops over the range and fix_map/unmap it, issuing TLB
invalidations, dsb() and isb() unnecessarily.

This can be optimized by returning early if FWB is supported,
kvm_pgtable_stage2_map() already issues dsb() and tlb invalidation
functions issue dsb() for the unmap path.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 4e329e39a695..6e9229106a25 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -261,6 +261,10 @@ static void __apply_guest_page(void *va, size_t size,
 
 static void clean_dcache_guest_page(void *va, size_t size)
 {
+	/* See __clean_dcache_guest_page() */
+	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
+		return;
+
 	__apply_guest_page(va, size, __clean_dcache_guest_page);
 }
 
-- 
2.55.0.229.g6434b31f56-goog

