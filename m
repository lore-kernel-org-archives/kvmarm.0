Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EE83128B5
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 09:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767691474; cv=none; b=JKNqrNOtT3OPn6nL7sUdQkuC3YcUC9iuYyDg4JVfATsLvdC0GpbhVV0n7dPXHtn4YQQpGzji6ZlVkcGWBJ1JQdSKWcQMmPANj/h7P+gySc/y3rhNyEjFd+XOhWAJj/vYOMQTQfDfAvOrBCwHm9ny0HRcsKsvzjZBAkdydXgT1MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767691474; c=relaxed/simple;
	bh=KEPsyHYvNUPbRxGvG9QC9U7StdlbPwsF3guoMEOlj/0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nZN8mcFtvUwGUIkBJ7q5P/FDvQVxyFOMuE9TDV4tHtkvBhNgrKxUVXMD7brcQp0AzpFAg9Psayof91bLUCudME49GrbRJiIAUIptZ1is44bStp+N0ks3+ScX/RYDl5LyimaoWvChlsc8KGT2Px+rEH6r5xvXkLG83oDLX+FLEM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IYa2XgdS; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IYa2XgdS"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477a1e2b372so6196765e9.2
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 01:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767691468; x=1768296268; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/BHQuplAEgEU3wnDUhoItFqsIohZcJhUp7mBGwtJYNU=;
        b=IYa2XgdSEmjAAfnnOkXsHN9to9nRYIXg9Pu2KJjFJLJfJQKfRic4rg9VYfuJqCYN1J
         zcIWCaMxZHgMoRLRdF8dBBpqdfJUc3pOrXRLBjVaB/JOd7dJkl0JgSQDr0WNO0dAFjXs
         //GLXp/ELsOpi0CXhtNQnW0XhgxmF/ucbJPlVirBZzmaKGBE4OCHIJKIsh8Rx1yIIqs4
         2EJ+w7sPZpYl7WtJZC5LOFtzxBYsAbvN2Ya9H2Jjv5739lvW5HSMWcWAsDOBIQmT7BHP
         +TXjIw7BxCf2MtUMuaREvmCS9SjLPBzsmJIv2ljHhPFa6ER3DaYRfv0sBENcv5Ll9xd0
         DXAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767691468; x=1768296268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/BHQuplAEgEU3wnDUhoItFqsIohZcJhUp7mBGwtJYNU=;
        b=ZZS9lWvF403Ig9UoUhMfZWMUP6anWiOjouzTnC5M3febQ3Y1nyWNtQ2jZibMig19LZ
         RfXDCzJAvhvqlUSEo1OZAuDEK/vDkLP0XwkHO+IUnyYq/PdfNcGlTr+4hhQmvBvfoOko
         cvk1wrxxHyeEi6JgXxT7LVjo/rA6hmQEjfA6zwIQxt5nhYQpfiGftlfsOmoY9cE7HUb3
         gPf3vtsRcEKvJqqnkiVTW3eXbbRGGjO5EFtt8qGDdpxwIT0CuR3YrNmIxAVjZ63ifaEj
         VGl1/gWLu2hSAevyfHdsye/eTXqtWeZTf5yzQNORIHkLkVOwzQB9PQLutYLIN4W2XwEC
         iCnw==
X-Forwarded-Encrypted: i=1; AJvYcCWA4rMfzzfBxoF9LGmsrdtZ91X5AoUxkdjmrYB2o7coBeI8kk2Y7gj0E546Auxr96x0ceJyYFY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzTimpIL30v8dFo7lxgM9r80p2Q5Zx269U0VADbTI8s2ybL/THd
	hEQWuKMyR535lUh7rvrETpuIo7fmZ/ZsD1P/WHk15OS1qlLlJV3fQcDsjNtp+uC/Fcy912iJath
	qaw==
X-Google-Smtp-Source: AGHT+IEg8lPbC98Q9JebA2jYPeK+hKxfS04QHQm5CsFqWbT7d+JjvRp5WM7FCPdf80Bu6YTWW9INVq/0XA==
X-Received: from wmbju16.prod.google.com ([2002:a05:600c:56d0:b0:477:9945:466d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b27:b0:475:da1a:5418
 with SMTP id 5b1f17b1804b1-47d7f062feamr25842635e9.1.1767691468308; Tue, 06
 Jan 2026 01:24:28 -0800 (PST)
Date: Tue,  6 Jan 2026 09:24:22 +0000
In-Reply-To: <20260106092425.1529428-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260106092425.1529428-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260106092425.1529428-3-tabba@google.com>
Subject: [PATCH v3 2/5] KVM: arm64: selftests: Fix incorrect rounding in page_align()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The implementation of `page_align()` in `processor.c` calculates
alignment incorrectly for values that are already aligned. Specifically,
`(v + vm->page_size) & ~(vm->page_size - 1)` aligns to the *next* page
boundary even if `v` is already page-aligned, potentially wasting a page
of memory.

Fix the calculation to use standard alignment logic: `(v + vm->page_size
- 1) & ~(vm->page_size - 1)`.

Fixes: 7a6629ef746d ("kvm: selftests: add virt mem support for aarch64")
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
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
2.52.0.351.gbe84eed79e-goog

