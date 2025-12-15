Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AE5341079
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 16:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765817521; cv=none; b=IgIzqPaHMSQ+2YzVvQIfv9n2/H4ZDSXxOKxLMB9nXw+oIx9Oo4WpsYFtv+fp0ICDjSAKDp7/LpbMaRatJqWrtjvjtYubjIuD2Il/xxThlyyH3N9x5OOi8R8sdKEHiAaGQj3H4NZc/WbYiPrXgERu2LjLHa2qKrUBSAE+2aHOL/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765817521; c=relaxed/simple;
	bh=/VCI7DQ+7GTI8zeB2aLIPeI3jA56WcE85XhXuFDRCp4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BFKhqvjrPsKEUBDN/HIgWzU12wl0tJA3cIe9uJTyiha0Sjv0kTc/oleWS8BvCk0r700RNIFLvi7U+1UmdAMkCVFdQeM9n5ZNoji2JPns7bSCCQdMd5B0wcaEzf2Etoo4eQM6MSEvtUKNtuLaqIQIwmYWpZuRfJglfL7mj5Jx2Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zQgjiz07; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zQgjiz07"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477a11d9e67so19312775e9.2
        for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 08:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765817518; x=1766422318; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YA7YNO0BIUCF/IaZgjS1+s+NSnXmnEjkXZMNklvVQWE=;
        b=zQgjiz07oGI3p3UQl3yyEa1t4H8gpazSxqTQoVytS4HQRgQpY2hUYYtFwJAeibt9kH
         OMlXgaHWc0cuejCLoFSNYBB1El6yUO7BXOku5v4adHlDnXa21tVtfNOuj7+tn4InhEH9
         TFLUMTJr0LcUTJ6UKiRX0mz9bjLMWrIT6OiArXnRF4e+Fh30iaADwTl5jN6fiUYwXVik
         5XYyiYxE674iB98xEhM7i2YZAHaK8yPg9Y1D5HzIVvY9mp/bQBgU4fzIk+qZoGi7hZ3D
         vHpoSZHhObcwi3kYjuDgMfxz6zP75NRH5nJTICXp9X91Nv+x/tJFPxvfwA80WExcL2Nm
         FyHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765817518; x=1766422318;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YA7YNO0BIUCF/IaZgjS1+s+NSnXmnEjkXZMNklvVQWE=;
        b=m5ceDddFxa3KLeeVUpUaMOiTdhk8i+MpI+I4LXjh4E7Dm3lTGmTwQD5MkRduq/DxbM
         XEf+7yyRIlUJJya62KfnGV7aNt6SWdTFvkqm+Q2HqdcXStTrD5SBY/Eil1mjXbjc4yL/
         L7SQivAcOjZxwEA2qneSykpOCT40KvJXIvbs1Yf4dQZjWPpP6GPb5fU12KWJsbN0u161
         OwTOJuHRUPbC0YtpuJmQv+/kc/Lu5hYmmfjfDoPjGrY3fMunvmAm9gKuMf7cElLAveXP
         +ocefGTKBBrIFd/mnvFRD8WhZsvYIVDdXoDowWI79wJbh5w6sK0dOZRxZcVXd2SGQhkU
         g9vA==
X-Forwarded-Encrypted: i=1; AJvYcCWzJvNd9AVshQbpv/C5lif/CxO+lXDMmBHtUw1fnzvPHn3q94lC9sefieHNiEnmVZYTPITesLE=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywzp6ZaOZYOMSKNlszWFAj4XcfNpriC8eTfbQbeShKT/2zQlKUu
	pmOASYkdWCsoSXTftNJY5GOmaYx93X3THh7iKeIXHrlc3GAWu39fVCubbd8ByGZZWRwqLPBCALd
	BDA==
X-Google-Smtp-Source: AGHT+IHUB40lOCD80Q5A00V1WQKvc1RxNXM54i1GatM+tLTBSJUgVajSxluMfJ5vbUhuhTOMyPxhV+F0hQ==
X-Received: from wmpo35.prod.google.com ([2002:a05:600c:33a3:b0:477:14b1:69d7])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a012:b0:479:3a88:de5e
 with SMTP id 5b1f17b1804b1-47a8f92029emr95871135e9.37.1765817518200; Mon, 15
 Dec 2025 08:51:58 -0800 (PST)
Date: Mon, 15 Dec 2025 16:51:52 +0000
In-Reply-To: <20251215165155.3451819-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251215165155.3451819-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215165155.3451819-3-tabba@google.com>
Subject: [PATCH v2 2/5] KVM: arm64: selftests: Fix incorrect rounding in page_align()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
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

Fixes: 7a6629ef746d ("kvm: selftests: add virt mem support for aarch64")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/lib/arm64/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 5b379da8cb90..607a4e462984 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -23,7 +23,7 @@ static vm_vaddr_t exception_handlers;
 
 static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
 {
-	return (v + vm->page_size) & ~(vm->page_size - 1);
+	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
 }
 
 static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
-- 
2.52.0.239.gd5f0c6e74e-goog

