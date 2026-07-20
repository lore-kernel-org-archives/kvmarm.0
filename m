Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10CA3DA5AE
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784567740; cv=none; b=DYbs2nQXoK0XSldPGIoq+7zYpNaquFEFGqmN4a3Ah/eLMP8HvG+v3J1R6N7NkGy2J4mS9fwRjgipQWEuchxY+JIR7sp0O7z/i6t/l+RjlQOt/9FHBhxydfvzWMOZJEevzptY7mANlRnQ4433/cxnXKSzHx83aKsGN2g15OMwF7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784567740; c=relaxed/simple;
	bh=r4Rs4AC3XA0thlISEsyDznV55ErJiaitwLLiBH1wb+k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m6nIVQPU55mKHO42IiyRz7K9ac64/ns5CcWJ/t36qGvka+tgndG0ucZCmN4boKN93we1mOf/EDY52PmQcX0rn4l0SR2xSskZp9v3H9YCO5NDfOnR034+fxG0MeM2Fo6qkxAAD/A7AO27OfEGx4R6C4BYYb0jzDnPczduWCXRQl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TbyYnWtW; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TbyYnWtW"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-495474a5fbcso40823365e9.1
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 10:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784567732; x=1785172532; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1S5nupuNnvy1/UCEDFI+j9MKHZfxLvOVR3hoi5nrd1M=;
        b=TbyYnWtWiHWrdBn8Vp180Rpk0tdETtqPEvOAuOCrcldX+YFUOicCZRY20EvV6R/wqT
         NuES1uoxhAZ79jGwOoSe5s5QXYK8nFir0sdzdFSZUm4pF2JZ97M8YLieYsCBVl0K/rTh
         eqe4qH5El5t2vMJrpXyG+1S0GB0cxnv2/K9Q0b0A375OCtqk2PYen5zltAXseSXG61k+
         Kx36RZMdxun+8NHgFwFmpZSmMGN2q7r4MrAn69bTtALSSruSfGqjzRPKzN7t2IvP9k2t
         tyecSkR0iiPB3lLK+RqRcZq4azHVP7eTWGZdiRPKY574Lv4p2IZO5IQqnYEWasqvjz9F
         xt8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784567732; x=1785172532;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1S5nupuNnvy1/UCEDFI+j9MKHZfxLvOVR3hoi5nrd1M=;
        b=QjFtvRHwN6tNg7LgJGfYBmUDxLGY/sR4PBCfhp1NO1oC+PQuXWL74I1KkPayCONZK0
         Erl3Lulp7fOfppOBHdF3t6W3fWmBlKavAl7gT1h9p5G85deXDT4jWCOFqnASjzy6GmlE
         +aNSZUh1L+rf2AU9zoYuPIhoCYcXMx3y5zQjGOU/QMX0uJerFv5Mm1R4oCQ/VpJyBZ4d
         PXNkHH1dy/FSHPae/kcauXXYY+vMh6kGAzHwvEvHHtSh22u/NlWSlmUVpqnmRI/PXc1D
         6ewahuxS5OmqlAIn/532EE8ysRWRnARHSUpxWpPDS9tWARc30bZBMH82/KuS2R6STF56
         5o2w==
X-Forwarded-Encrypted: i=1; AHgh+Ro2sqCHwcPghLJWIlmNIF2mIOvSZNlx8g65aM0+g7AjEbC9MFaK4FFqJkCGwxOLc8t1pmuD6xg=@lists.linux.dev
X-Gm-Message-State: AOJu0YySl7eKc+ekA9WjSaPYSNExkNbL3s6GJb76cn6voHrDP66G1c7c
	Ux7qCMmkqk5uEughzZSNSzxkVnsdfNBMpdrjU+DxfTyj46RptSxcNzjO3p7vLH9WOCBLItlZs/+
	Qi2uheQ9T4yhV3q7NpeyDfg==
X-Received: from wrqo17.prod.google.com ([2002:a5d:4a91:0:b0:470:41ef:7017])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4703:b0:495:4e89:3f30 with SMTP id 5b1f17b1804b1-4954e893f8cmr154472795e9.15.1784567732287;
 Mon, 20 Jul 2026 10:15:32 -0700 (PDT)
Date: Mon, 20 Jul 2026 18:15:07 +0100
In-Reply-To: <20260720171513.1415357-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260720171513.1415357-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260720171513.1415357-12-vdonnefort@google.com>
Subject: [PATCH v3 11/17] KVM: arm64: Filter out non-kernel addresses in kern_hyp_va
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, tabba@google.com, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="UTF-8"

kern_hyp_va() is idempotent for the hypervisor linear space. This is
handy for nVHE hypervisor callers handling kvm_vcpu or kvm_arch
pointers. Those pointers can originate from the hypervisor space (when
protected mode is enabled, we don't trust the kernel and the hypervisor
uses its own copy) or from the kernel space (we do trust the kernel in
"non-protected" nVHE).

This idempotence does not hold for addresses within the hypervisor
private range, like the ones you get from the pKVM heap allocator
(hyp_alloc()). To resolve this, filter out non-kernel addresses based on
PAGE_OFFSET.

Leave the assembly version untouched as it has no current users.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6eae7e7e2a68..d60e5f2de10c 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -126,6 +126,9 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
  * replace the instructions with `nop`s.
  */
 #ifndef __KVM_VHE_HYPERVISOR__
+	if (!is_ttbr1_addr(v))
+		return v;
+
 	asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n"         /* mask with va_mask */
 				    "ror %0, %0, #1\n"         /* rotate to the first tag bit */
 				    "add %0, %0, #0\n"         /* insert the low 12 bits of the tag */
-- 
2.55.0.229.g6434b31f56-goog

