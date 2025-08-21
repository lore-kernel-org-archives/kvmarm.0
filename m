Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D287E2FC027
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 21:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810075; cv=none; b=a6ND9VRjrsXlvVzn0iuyKs6qbjM6W0QSAVLNxO36X672tXIc3ckYS/RHMgLNYsIDWTVHn5TYhYY7kOxb9yd7gISHaV1nj8W/gV73PmLh3BREs8GaoMqF1GK/s9pxvTW69cFK6nJ1WnCEDbDg80ON8evinnWhbPdh/CVRBKkYZeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810075; c=relaxed/simple;
	bh=ztqVo6NA34foMRWPPxfCFK7i38/nXKR/2OW2xBZ5Cz4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SHzrjVJORoiQw1UYYLsGP5QwHUICmJwQEsyewtPSN5VrlZ9BYAa/+0AN9AE0Q3XdA1AHZ8IUMxtvzvIpeH4+6t9v8tg0leT4WMcFaLQENgeySpOPJfUA1EzSkBouZbyxxRQsvwjZP3D/QHI/3RCUFFMZ5EiFiX3jrQKXa2ZJKog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D7EPqQ3z; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D7EPqQ3z"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-325228e9c12so52523a91.1
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 14:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755810073; x=1756414873; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=raIzGhW7lpJoGFirZ1c9kEw1ZuKCVqeLv2nD/b2/YKU=;
        b=D7EPqQ3zm2n2wS3xLbjJR0ML7AlFUsggqqh6/Kre1VBfSdJIeNuIh+FrfWVgKF8trX
         Q74+bAyK4IMl2pITzXBCwzS0agqoHH7xoJR0vHNzxKVFao70pcWBUYxwC06p3qyDG9aF
         j8EOMBBz3gatzgIUCJ8M++UzlEwPEtmZvIh2UVVegmcocYPw2i0591NUK1vay0fGxP7f
         zM6G/65pYFK9u4Y2c3acCb63y0pKAxGWPMVwZWjIpMoBbC8LBjrsHub/GOvNVuVoDXRp
         N54nrUoGb51AmRBRCjbDT+jHwBBu/PudhqBDZjYrkYikt/s7pb9eA5tS5ox1PgZ12/FN
         MTVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810073; x=1756414873;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=raIzGhW7lpJoGFirZ1c9kEw1ZuKCVqeLv2nD/b2/YKU=;
        b=BDDO9T8e4nSO41ctVFnAgi+xqouX5EkxxHjSI2dsTNql35q/nK0wzx+Y9aaB6G46Hh
         2GutzxNOBehIEiAJEtbEWKFisd7pCYj1BRNf/OmsK6fTRp3b+neEcOx/6k+WZkQ0tn+Z
         cLXvKMBfvMPSkcugGPquN/sfZFTpOphrPjnPPE91GRzgn2CLlKb0Me87pPOZZ20RrK+s
         Yxc/fl0uLjI0n6wEcRpzKJf60ovQtPt22Rpvp4V8rOofq4cK1+GuCyoRkWc8v++H049S
         1A3WKhIScmiwmhimDd8Gc3ybOxHjxoe2gQFFW7BHo9yMNdbtBDUlt4Oyzyt97qBpwD2U
         lETA==
X-Forwarded-Encrypted: i=1; AJvYcCX6//v9+1XpV6nGDRFdQ1jcESdHOFibI70SCQIBhJ5bc5jSwLo0x9m5deAkMAQmGBXrzuQ0h/M=@lists.linux.dev
X-Gm-Message-State: AOJu0YxxsR4gPfSyN/2wbmlhb0BnQxueXqUd2MAaVdXm7DryJkMX+C9N
	mhSEIqzr8NBb7D8gDFClBghfY7rsREyMJlSvn4UVQj6EPcFRE0elG2JWuXCOtDqjv0XHYcJOXex
	cXv8u1g==
X-Google-Smtp-Source: AGHT+IFblgzDSGtA8EPOlO44N2jRty+RipPpxQzb/XSsK78s9IItTWN33FoV1VAgZIXu+UmzYrewPt9GIfA=
X-Received: from pjgg5.prod.google.com ([2002:a17:90b:57c5:b0:321:76a2:947c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d4e:b0:321:1348:4438
 with SMTP id 98e67ed59e1d1-324eed210damr5152464a91.7.1755810073194; Thu, 21
 Aug 2025 14:01:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:00:42 -0700
In-Reply-To: <20250821210042.3451147-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821210042.3451147-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821210042.3451147-17-seanjc@google.com>
Subject: [RFC PATCH 16/16] KVM: arm64: Don't bother nullifying "vma" in mem
 abort path
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that the local "vma" in kvm_gather_fault_vma_info() will naturally go
out of scope when mmap_lock is dropped, don't bother nullifying the
variable.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ea326d66f027..435582e997ce 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1559,9 +1559,6 @@ static int kvm_gather_fault_vma_info(struct kvm_vcpu *vcpu,
 	fault->vma.vm_flags = vma->vm_flags;
 	fault->vma.is_cacheable = kvm_vma_is_cacheable(vma);
 
-	/* Don't use the VMA after the unlock -- it may have vanished */
-	vma = NULL;
-
 	/*
 	 * Read mmu_invalidate_seq so that KVM can detect if the results of
 	 * vma_lookup() or __kvm_faultin_pfn() become stale prior to
-- 
2.51.0.261.g7ce5a0a67e-goog

