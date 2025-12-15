Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AED338905
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 15:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765813540; cv=none; b=YeDsGAYcDFQFrqm2uqcD2j1+yGn0RlAuceXWKU5fDFlT2aglEUTpHSCIeX8g6W0UuzNygZaXtltmlYiYCsLfguWzNhHewgXBBH0S88ULRVd4f0DQgNrH1e7zyqTtqKQ0yFqVDmmf5dh5HncP5oCGittmnHK3r8J17bOmbUUnbYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765813540; c=relaxed/simple;
	bh=RV/SRDs2NYKR4bNyg9iD41K74i8IniewHpHDgBIC6Q4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EUhCMZjOxrchqjwq7lmmAtjUx9+on0Kx/WVoDfuysk8t2RzFQ1r10Ua5wt5C10+T31rekZSZsiPxW/xHv5xkeraYwbCBxwZdp3qQ81LgJOuM7P8LUM0oTV9ScPKZEw2kIxkxOD22M2a4UvnqImLm2ErXrQsHZQGls9zzTeNnPhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=242OyDE6; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="242OyDE6"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-430f57cd2caso1377076f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 07:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765813537; x=1766418337; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ozb3WNjr0r/hE1f6GMZd7Idc+wYYTjRgIGjeMMU1tjI=;
        b=242OyDE6Ba7SSG9QHwcO9TG4gNga9FEksmxVptgwJmtk1EAI3ALTYZhax6IY6saAws
         QlaBiEEm1lttSom9pxMim2a4ooL4UZz62dGI2B4aVZxy70MeS3yfk3WcvLuF1VI5sx97
         v37ay00o2FUhJ1EBZnxXWG6Wl+13nXSVQTEAdn6hR01IsCJDusLWzMt4i0K4ZOhZkYIt
         hoqIcxp5CaIDzgEjZzYDTNfzFx5cs72oqXNdNGZEQROpdmJ3l90VW/rXzLxdb1Q/XW6l
         AHLm/hI9GfGcQmZZFesaQ0KtWbkFVacS/SVkaKlA+KdeWCfXUB+pTYNnfdpL5hrDP6WI
         mfKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765813537; x=1766418337;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ozb3WNjr0r/hE1f6GMZd7Idc+wYYTjRgIGjeMMU1tjI=;
        b=FddVdWeZgpv4AOSnVYRG6nrcOjSZ07ue9JD44ZYPYck3473Dz8BVMuBPjEIllOOf9/
         psIQBETukEgRz0E/mia9Gb3fVfM65XVNbwjv/TI+3QUcaM9pbyRSQnm81MIkSb3jl2iL
         WadVZe7srGOrzV4Y0GylXNoDfKxx9A/AwyAFNueIctSTsgZmjC880rzfRsS2H7fj0Pdo
         IKTjP3gQV7T/zVY+4t7EImCgg0UymyYT03F9YMFpJl9P2Hwx2qivPTnLEovvFHxLB/Rr
         aCqawR365XDqWgQCf5/f5mblIMwRAXUe8Mo5jR/ZJzSla+gOUXMvSeUZKFUBe85XSUZ0
         3OSA==
X-Gm-Message-State: AOJu0Yw97DB12bMVLa7OS5jgLps2BMJ65VUE3wgwKWl9ZZj40E60yolr
	tdHGNKhnbkwkluV26CxTFmJIxQ8InXuktocq1vaPn3vlSIJ3ls9l1mmKRNpSONrJ0YIRoaAq+7P
	h/8DHCYNMpZgqRxYJaWwx2e3EGMDiOhG6B4dBmmWhjNFiH9S+dIay8L932nChxFrOf/JnJah27s
	kexaIAq3LuLuUZs1lYKmvdkw8uOu9tHJE=
X-Google-Smtp-Source: AGHT+IE6Tdrp5jnRT9m1s/zDc7qPBnYbwM66Z5F5n+loOLAGYL1YDabSeRQ9nQ3/0AafLWGebzpXgcDS+Q==
X-Received: from wrbbn21.prod.google.com ([2002:a05:6000:615:b0:42f:bb9e:9aff])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:604:b0:42b:3155:21da
 with SMTP id ffacd0b85a97d-42fb44a3a65mr11776269f8f.2.1765813537156; Mon, 15
 Dec 2025 07:45:37 -0800 (PST)
Date: Mon, 15 Dec 2025 15:45:31 +0000
In-Reply-To: <20251215154533.3154405-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251215154533.3154405-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215154533.3154405-4-tabba@google.com>
Subject: [PATCH v1 3/5] KVM: riscv: selftests: Fix incorrect rounding in page_align()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The implementation of `page_align()` in `processor.c` calculates
alignment incorrectly for values that are already aligned. Specifically,
`(v + vm->page_size) & ~(vm->page_size - 1)` aligns to the *next* page
boundary even if `v` is already page-aligned, potentially wasting a page
of memory.

Fix the calculation to use standard alignment logic: `(v + vm->page_size
- 1) & ~(vm->page_size - 1)`.

Fixes: 3e06cdf10520 ("KVM: selftests: Add initial support for RISC-V 64-bit")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/lib/riscv/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 2eac7d4b59e9..d5e8747b5e69 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -28,7 +28,7 @@ bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
 
 static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
 {
-	return (v + vm->page_size) & ~(vm->page_size - 1);
+	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
 }
 
 static uint64_t pte_addr(struct kvm_vm *vm, uint64_t entry)
-- 
2.52.0.239.gd5f0c6e74e-goog

