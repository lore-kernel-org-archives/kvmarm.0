Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875A9341648
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 16:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765817522; cv=none; b=EfmIk2gLlc3bIqro8Z+Ther0CIuYarmrEptlUPZ/tinta7yW35NMWdwlew159U/26pI5u3W4JCL+rxRVzBmq/iSrgUp2SrdNqf1dE5IqcRP0xk2FJc1wvwaSi5Yq0GN3WHoPewZrLqF0oJe7eUCjjUm7ux4wFNfp2k3CP9zt+Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765817522; c=relaxed/simple;
	bh=RV/SRDs2NYKR4bNyg9iD41K74i8IniewHpHDgBIC6Q4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=filICBlont5uK7hMYuHklbP4M6fjnc6PnLwhgsql07wLnno9gvoYcpEzCJuuFU6Sm99fHSciKil1kyzAHAOly6Pz2E1FVFiOJX5a78sEDDnlepIYjRm0jj0Mg1lE8HM+wIgnvRcPCGQ3Yw3B4OxLgG+ly3pRtHIszaC7UgJuSjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=themEPCl; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="themEPCl"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4775e00b16fso25892925e9.2
        for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 08:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765817519; x=1766422319; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ozb3WNjr0r/hE1f6GMZd7Idc+wYYTjRgIGjeMMU1tjI=;
        b=themEPCl0w2BLBd+LQV7PxrqZTETCMUoKqDmOgvTvnnEr1VSWEOVMth/XQKEzoraPh
         HGXv+MqRA4/o60V12ERBAhapbs6pKzAbw6Byr7yMlEa7hZTj9l9B534ujCLrdcjfeBH+
         TSsPbYqbRItVnsMtovNsKs/MFBz5uX929AEQNs88U7NZMbdBAK3/QUT5egvxb6ai0TI+
         lINMjhrkWcc6ZckA1h655J2tCiDXB8ZM1vJ/fz/9HGjUBC/piDbqK+McZQPnkJ0ado4Q
         qySBeneHAnCDyehhHGifkwnC90LwRmk66lV5YgVGYIO5DolTHwA1hNHfuuxbZou5Srgk
         Q8qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765817519; x=1766422319;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ozb3WNjr0r/hE1f6GMZd7Idc+wYYTjRgIGjeMMU1tjI=;
        b=GNKa46PEg+9Wi7bBww2YFIyvjKF1JSWtmEo6nSkUUfMcTjh7t3BEVIbVwi40ScSWwc
         dASnVA9PmmfeOx/RCcbgXPPyKjQ2vc7Q2e/IEHv3iGUiA7YKf7V11KUbuwsFXUZEmp0D
         5x1/9nIM6eNYErwJ/j4YUovZuOZ4ytjCPDWdkijVOSCjQWFK+yF0kQ5oYJOWHNm+76mu
         QU+Dw0TFkFGbmHc22GYTmyYz2V4BLxnNfZaL+UflMGy60KmXGEsbqjIuZpXdAgipNwah
         blabUMBnlJC/oNLFIEL4+jtkGa0fmES0QDTKTE0iUIsdyVBGSh50xC0tdHoiDyT156wP
         lFOA==
X-Forwarded-Encrypted: i=1; AJvYcCXztz7a96M5/mBrzxf51S+ndWlkFmaI63zsim79ncvZgNSjbxGB87ERRkq/XzMpUWx7DIrHo/s=@lists.linux.dev
X-Gm-Message-State: AOJu0YwAjl195GqORZKy687xPieT2/qXP8WD/223OIEh7p+bwQgLYZ97
	A0mt6ntoMgdw4U/fngMjw/AEcg5IPk/ei1aRLmQHOy2bgQ5sAEkJSm2efOgGmedTaWDkgiHejnj
	UcA==
X-Google-Smtp-Source: AGHT+IEXfGMQYTlXaZjDRjEyi8ps8t9i1lBXKwi2r5crX0EL+3ytnijgNklZSLLzPd74DIRXBqTJZjRKHA==
X-Received: from wmbil2.prod.google.com ([2002:a05:600c:a582:b0:47a:7fdc:6925])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:35c9:b0:479:3046:6bb3
 with SMTP id 5b1f17b1804b1-47a8f906f07mr127619025e9.23.1765817519032; Mon, 15
 Dec 2025 08:51:59 -0800 (PST)
Date: Mon, 15 Dec 2025 16:51:53 +0000
In-Reply-To: <20251215165155.3451819-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251215165155.3451819-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215165155.3451819-4-tabba@google.com>
Subject: [PATCH v2 3/5] KVM: riscv: selftests: Fix incorrect rounding in page_align()
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

