Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F653F1ADB
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 15:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779290850; cv=none; b=OD2cEJWdam51pPMr77PcHR+2L3JgRogE8H2x4WiFa1+FZODcq2UR3rTu+wSn+wdxiaVNokBxiXmEPlJrRmRY1CFxsvaOHR3DIAXyR4eT5uHev6Dx9mJCuB9JucZCILOQfGVrvuz3SSv1s93ZppcRaQyiZuDp6Ba/tJAnYSJZuZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779290850; c=relaxed/simple;
	bh=4ObEevpDUIXnEHwmDrA6opRiS0ArMDCfNLtPtxSaqn0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ut/YTVvtBCx1cutPp4lf2wqnR/5ganhd55qTgEQ7PqbacVj2/Q6elbpWMGZS0r2LGhuXbyOsGCM/imuIIHYi+A6J5OJLXOw95IXlDnC9cm+o6mouy/9D9vgGvSwKxDRRvsNbd2vzA6UnaX13KngS4It6ZOvtyac0k4m7Dq+q/kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FypV6txx; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FypV6txx"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-44a52d5e572so3768875f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 08:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779290847; x=1779895647; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qkKunDQZvI08nof+q8MgWgSW0KD/IKDntvHrSyk6bE8=;
        b=FypV6txxkIvsY2ATcL0DuNCt4QGeiD6jVY7+JOjlnQBRPrzz+T3ylnCaoPN1STXZGr
         SHlbG3fZmDeN0iBNWXlXRG5WzW+Ph9xOBcplnnFbYE3Gyag0K4geUR4HRw6KshbxeidH
         GpAeTHgzcH5jEL0raeinm5LjTSFwDt0I9APWJCRMmgukC5Cj7t5GUdU7WYcuHMl5/H7s
         nfTsGcKuYpuQmfrPtgW9rdYyv9jlMFn1iAuwR3C4uvGPZPq1Qtj5qzPT2M9tG1KFQ0BR
         ME0Xvcaumcwe6+qxoT2l2+BllVt5Sz+o+JMKyvFPRnZS8jXf55oiedxKQsKWVz1k7OMg
         +zkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290847; x=1779895647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qkKunDQZvI08nof+q8MgWgSW0KD/IKDntvHrSyk6bE8=;
        b=iFO2OMloMAwlQEdpUhDSSwl+seoyRQoDidKsfkh2npiYZnwDDY0H7dduJa2mY2Jdo+
         R3c+RxWsKcjY3qSgYJT2o1ofTx1AGp4f3HAzZCXV7fDv++5lnpjy6FF6rp/2lWnnjsbE
         0sGoDho+tvZOeBynQdd3Whv9VWYu08sF76dU/b1WYN00qBU1nfYbns/4RInpyfngvKMt
         nY0RjXoMrcypjbbimAAbV3RYUfI3V9fjqHQ7CP4bmVcOp+4epFHfT5dCGYE/9jOhFzrD
         AMuz2bM+IPd0ufmjQn33ccToI8ecxf8FRBy7MX9CBC15xmgRlUFkdrCcmKZoHZNZupei
         nsJw==
X-Forwarded-Encrypted: i=1; AFNElJ/ySxQicW43D6/IQoBS6eXXLZnyGhI6WMBqu+RCfVSRD3UJjNAfmXjqS1jwReBLy904JS3dLBo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx35dIKQv4OjK10Zdi6k3G6mTOAwl81FHqZdFc0q8EONvGX7AU+
	2wfUOlxBcL9WKq6W7InDXXotvuBlZiMhCYO90ZSn5TSiAD+YHVgGvSqjm3G2cvBFaz8iMRdcOa8
	3xB20J/fBH6vqCXObEk5kXQ==
X-Received: from wrsa4.prod.google.com ([2002:adf:fac4:0:b0:44d:a2de:25c7])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1389:b0:48f:fe2a:107c with SMTP id 5b1f17b1804b1-49001285b87mr253544245e9.6.1779290847092;
 Wed, 20 May 2026 08:27:27 -0700 (PDT)
Date: Wed, 20 May 2026 16:26:45 +0100
In-Reply-To: <20260520152650.4107895-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520152650.4107895-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
Message-ID: <20260520152650.4107895-13-vdonnefort@google.com>
Subject: [PATCH 12/17] KVM: arm64: Filter out non-kernel addresses in kern_hyp_va
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
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

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 01e9c72d6aa7..8d608292d48c 100644
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
2.54.0.631.ge1b05301d1-goog

