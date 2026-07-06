Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763473AA4E7
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 17:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360478; cv=none; b=e8VbQFl/FQbrxfJUly5jFSWhVA5NrCGfp07gztXSfneWp5mhk0m3lIH/+JCRCZdcJ18K5R13JsiQR7NtNHQsyirF+ZkFYAoDeHnO0L8LA2JBKd9nhotB+K+ZVmSLlzjhwmqzVlogmFFRWs++F9d8lb6bUD1g03qgJ4UIhouyuH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360478; c=relaxed/simple;
	bh=1l3eu1+K2r9TtYEldHQ8j1tAL54oFcz5GRC68hR0CTk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jqReMKTxHzsRajNOruLYY+iwSXSeL8xCOAIbn2aEZ/59HjnfgcLZukcGR/GmnyADfRdap0DQ1GLoCDu98arssU+aM9sv3UvN0EnuxaB5pzi+oatjsdni/ww1UN1VN/0zEFugM6bdRv3BOHB0IwbCFWJWhwSaVHzZEUMJAsw1kCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DUM9yFwj; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DUM9yFwj"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493bab443f7so487355e9.0
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 10:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783360476; x=1783965276; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zboxgN5bMNXSf6lrUmEWx4BFr4AoapL6ahNKlrvd4RE=;
        b=DUM9yFwjipexiD3FmdyWUq/L78eo+fLVc+lLvxSPa79fyQ9UOgHtGNnSkbQvcX/9JJ
         fYI5keSQMec0yNNs9nliUjKocZwl2oM9zFzToSVW522m59HNnPq4wqWCYmr3Kf2oJxwY
         hh9PWhSUF/Qj09MMMte+75iqpdcHpCPyqbYnEiwHyHwEgCwd40R0ce0YOnC1ieFj41AA
         NVBSxZhLxNyY+0fUqGYtQeOutbj/KHdIFNVESaKNOfo/cstVR1j4saRKsf8eyfSVYMIJ
         P/QyDHe08mPELmWqk/XNWsYWgMQzl1wb1nWHa6Bt/rKVBNoFO0y20OQ/qL7NookQotG4
         10sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360476; x=1783965276;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zboxgN5bMNXSf6lrUmEWx4BFr4AoapL6ahNKlrvd4RE=;
        b=Ed22MVsgxobEGPfTBNpyicqWI4uj9cyFhtxpVkW7lX0/P+rlZRhJH1J4MN3FWo2qQ3
         e3HqJTxjZyC+OROKle3nUh2TND7XM6KP50NXbeAx/+aTAiW1Z6wVXhQ6CAwO5gNfDaMx
         bD/aue55aX1gOWJZ+gh5/kmCZXmU5euMgbcCDlDwYLnOIG9iBTD29gfom+Y8pCgmuVhG
         CUq1Z32VeiMnU+HIpZlzH7+BLh53pxPX/7LhpuMUDkUlaMwyrgcVFZ6xriEDRoAbMVZ2
         hrgFXkqJzcYMkubSvvmXrXilIxLQJdEg3vVuNujDXl2pr/mUvAObKqtuFcUrQp/Zb0ch
         4BYQ==
X-Forwarded-Encrypted: i=1; AHgh+RqKxkqHjcdZ7XI9sAnMtaN/HS4FezryjQKZXhQbqSWxdqq4yFXl1f5lFDfH2pBlww6feR3/poI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWC41onQbDw4s+Bj3oc8nzDui7IpRYkdlohlnXaqwtSmtGoXqF
	Q+Bw4WUqnao+lkbVZomAj7PEsJ7JI1duhRISVzHqaC0IGUAI5oSRDUyor22Ky8JMcboRYkwXaQ4
	XswE87v+GRY3XKSKff0Et7g==
X-Received: from wmbfp12.prod.google.com ([2002:a05:600c:698c:b0:493:bc2d:feac])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1993:b0:492:6f5c:fd8c with SMTP id 5b1f17b1804b1-493decec719mr17728345e9.15.1783360475525;
 Mon, 06 Jul 2026 10:54:35 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:54:09 +0100
In-Reply-To: <20260706175415.2604046-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260706175415.2604046-13-vdonnefort@google.com>
Subject: [PATCH v2 12/18] KVM: arm64: Filter out non-kernel addresses in kern_hyp_va
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
2.55.0.rc2.803.g1fd1e6609c-goog

