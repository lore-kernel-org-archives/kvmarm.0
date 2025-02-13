Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A914C1CBEAA
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 15:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460980; cv=none; b=roe528L++/zrudPTlnaPl1hZIOlylr0Vp7IO3HgB2J+NQAkak4ttPIYx2HuhHazRgp8yPkgESLVMtT2/a7FNYnv36ZdzVnBoYLW6gFqNXoQieWSoJc++DhjIQP/Inyiz2cYtpllrOWcy+t41It5O88y9R3ogvq49tM07aDxnMBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460980; c=relaxed/simple;
	bh=rUUmr1qKa0raoRIrehordGqRHzgfGvgm6PX24wnH2XI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=QzPCKRbmISuwbgcklsXavIxHt1ivGG2IBa4OhXGiB7BV8kN0UiqKU+SljJxTWrVIlcAhKEMls3y/8Dtfhl0izEXVSGBLUkx00XV7pXuJ7VvCgcCBvSR9Mdbe7hqGXT8N+cheNSVSZCRDhhVVxssWz6vocvxJSnikYGD+GYWTpkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SSH6PIdN; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SSH6PIdN"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-ab7e9f7381cso116844366b.2
        for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 07:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739460977; x=1740065777; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yY1niH8bXpIvQxfdtYMW2hEB9nSt1maMeFqvo9y07nE=;
        b=SSH6PIdN/cH8G/sWiY6yUAFrXSKWyrujpcNzZ+qRZgx2xHRuEm8lEiKaZoUY0n3rL9
         l/N7Au+SLAKZbwzTCJn+Sd/ENQ2K+z9GK84u0hvfQeW4t6Neslje0+jQKPTFuDA6ajY8
         g3MomVKM7R3aLH3hLkMnhefHRAzaeaWXSnz/4fryeaTDo1JwbHcCVqfyWCVtD9IeGGLf
         kPHDajottu7oNUBn/lDMyvko8stkFU8XezEHiXuysnWjbkC5kH28O+m1xryVDPCs8Cy1
         3RbaTZFcfxO+ZkowJUFyGuotTMFhy3jRcnBOiRGvWUKVYb9DdukTTQ6KuB8ZBHs4hWmJ
         3Qbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739460977; x=1740065777;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yY1niH8bXpIvQxfdtYMW2hEB9nSt1maMeFqvo9y07nE=;
        b=iS5GA+z7I15pr7dKNT8qYFN3ZDLJKJcwdoMnhMo87WtCZ/tUIxR8AKkWZPGXzOothQ
         Q6uFSvzacs7ru2rqiKEV91wR7+UHHjXgvLzLs9TVnYbCyX/bQKSIPbr18SrujstizCYf
         Wj13KBs6PsnuhZM28iv8UCXX+O0aWT71f5CYZ8eFkMtwkfwtOwHb5pybBHFqoFDN0KPa
         FbonTMzKU5lNWxwEQ43i8hrCAdRnlob0xgD+PwctKGQqHLuQhVZECdC48suk8EitPQCx
         uto24K8CJhLmu/pV6qfb3DnnbHcZ5rRwvYPdcvLN3az2FR9e9Vg//Vc3vvSQ5l/EYUe5
         SEdg==
X-Forwarded-Encrypted: i=1; AJvYcCUK3d1RAPwiJbbA78DFPN0zMv4c70iCM/yHPzCV2zsNclaQlS6woHUvVDrLIYSQd7F+bcy6Ndg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyCnXKjjqvHWpNac4icLvohLYaUA9GD4yVeqZQgC3sdR+uyNKHB
	33XDx0txRe8X8xHMP0bL++AaxP4OeMCtDETOn64hiSzClApeLRfaBacQnijPWbcfTr1nA8dY6ys
	7aew7jA==
X-Google-Smtp-Source: AGHT+IGNnBpl+X2qDDZkAqsl1W2uWg0qrWcC8MQ3Hvm0c9bsOTfUcxx6R0kvEkmQWiyS31Y+rdhEd3ntyWG8
X-Received: from ejkk8.prod.google.com ([2002:a17:906:32c8:b0:ab7:bfda:26f5])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:730f:b0:aae:fd36:f511
 with SMTP id a640c23a62f3a-aba501a9d85mr376452566b.47.1739460976992; Thu, 13
 Feb 2025 07:36:16 -0800 (PST)
Date: Thu, 13 Feb 2025 15:36:14 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250213153615.3642515-1-qperret@google.com>
Subject: [PATCH] KVM: arm64: Fix alignment of kvm_hyp_memcache allocations
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Keir Fraser <keirf@google.com>, Ben Simner <ben.simner@cl.cam.ac.uk>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When allocating guest stage-2 page-table pages at EL2, pKVM can consume
pages from the host-provided kvm_hyp_memcache. As pgtable.c expects
zeroed pages, guest_s2_zalloc_page() actively implements this zeroing
with a PAGE_SIZE memset. Unfortunately, we don't check the page
alignment of the host-provided address before doing so, which could
lead to the memset overrunning the page if the host was malicious.

Fix this by simply force-aligning all kvm_hyp_memcache allocations to
page boundaries.

Fixes: 60dfe093ec13 ("KVM: arm64: Instantiate guest stage-2 page-tables at EL2")
Reported-by: Ben Simner <ben.simner@cl.cam.ac.uk>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cfa024de4e3..d9db6dfbad09 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -100,7 +100,7 @@ static inline void push_hyp_memcache(struct kvm_hyp_memcache *mc,
 static inline void *pop_hyp_memcache(struct kvm_hyp_memcache *mc,
 				     void *(*to_va)(phys_addr_t phys))
 {
-	phys_addr_t *p = to_va(mc->head);
+	phys_addr_t *p = to_va(mc->head & PAGE_MASK);
 
 	if (!mc->nr_pages)
 		return NULL;
-- 
2.48.1.502.g6dc24dfdaf-goog

