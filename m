Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503443164BB
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 09:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767691475; cv=none; b=tb6zYBdvDzSOrV0oFVVteDN1YvVsR1pnEFJR7yHX18ETyjhQZh/dy+fcCMPQhiReiPoaLB7UdYR6wSppdjIbjJFcFGJ+3tSEZQdK06L7Oi5qjEUuDaRKRdkjGwa9Cw0bq9KutD2FdHnMUpGCT7l1HEZQr4YOD9+96+R8l8csCa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767691475; c=relaxed/simple;
	bh=EQHAbDhoMMWd1fJVwjNDq+g85R6n47J4t4SvxSjZdfM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MQtDTa/sdPp6LSfQjqyICnvrrNgLN0ab+iuQWxi9AlUpv4sJbOmhd6+MdwrruCNIL1JljH5qARrDT7fCIal17+OA9khe/+SuTfesjagqP4cJKBBwiwAZ24l6H8Nm9R77Tv5cb5iksGwga72JuIxxKihyMvatSCL6CTdpBaX013E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JkN12g4o; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JkN12g4o"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477a1e2b372so6196935e9.2
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 01:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767691469; x=1768296269; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QWAfw8yq+s9cE6S8gitEzWpZURZyId6sqJW9pySZvio=;
        b=JkN12g4ocuU4vuBA1LClLC/JjjxIeIgN5HPUsdO+W3t5dqA6C7PxBteVKRDF4/EjBC
         fDfXlJWht4RLhoUu6dLiiRXa1VngrQBvVdJ9mwYqWzLkso9RtwQtV5vQA7GWqfB9A2H+
         +YW21+dqzz12+dQSh+PanKF/EEoSbkxdlOaQh+a7gtyrTumKunL7W1F4YsjX1N+Qzu5S
         nQSy4MmBhGHM0JnFtM4eVcuyAaZAl+YhjPp0gmhE8U+5lEYyFqoQC2PTbjHGt1GrSEH6
         i1oLqW1YnxVRocZnJWlnuBhFyttAljWQR5ZuNtZVJefdHbL3ZkZiGU7akRF2Jk2TEAhn
         vr0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767691469; x=1768296269;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QWAfw8yq+s9cE6S8gitEzWpZURZyId6sqJW9pySZvio=;
        b=ZMOMHlelrybalJ7ggCfCedw3tOGBUSF+mnkPKiaM0YSt2wV8dtNPrXtLXNT6Pirpwt
         RGUESd6js0mLm9pKjz7hZn+zxVabCCmm5Of2m2QUjpeZhEQokltxpT4Sr7x1nSqYFGhG
         ZVSz1ejziTpf2r2KIBt2uI7/3z3+t32JOuxZ2/18kx5Zun/lPsJ/bQMGhUBHl9Chq+DP
         aWUbB/+9f2sm0za396dQP4m2Ae0JZE3WutVgE45TXb2VXlbCinP67g04ohFiVimUmxp/
         I14xG8RAepG0DckafRtVfdgS/h6hpRjLR08d7pHMjrCkwJZz8WHjPg+GS4jibCfc/xG+
         ZfTw==
X-Forwarded-Encrypted: i=1; AJvYcCW+sq2AbYHWwlTqddP24SajOwEYznxvfMw1HA1c9DI4fn/N3GJf7OGLTpy63Jc14WhUUTHQw2U=@lists.linux.dev
X-Gm-Message-State: AOJu0YxvCSkLV92DQly8MHlem58nX0jaHqLfvd58Ymq8wj3MI43qUFPR
	Yk3JBQnVVlRKPGTejazp+nqGTgPqzj5GvekT93HG3xNLeEQ1EH+7lV7EouEKiR/cgeQQo0YKD4e
	4RQ==
X-Google-Smtp-Source: AGHT+IGZ6zPBR0nFFmX4Tnz3UVY5AHveG185k93WRJRP+p2A5F0uEf6W3hst4bbUZ2pAc94raYUDWeGeZQ==
X-Received: from wmxb6-n2.prod.google.com ([2002:a05:600d:8446:20b0:47a:9289:c5d8])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:46c4:b0:47d:403e:90c9
 with SMTP id 5b1f17b1804b1-47d7f07031emr25675035e9.11.1767691469448; Tue, 06
 Jan 2026 01:24:29 -0800 (PST)
Date: Tue,  6 Jan 2026 09:24:23 +0000
In-Reply-To: <20260106092425.1529428-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260106092425.1529428-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260106092425.1529428-4-tabba@google.com>
Subject: [PATCH v3 3/5] KVM: riscv: selftests: Fix incorrect rounding in page_align()
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

Fixes: 3e06cdf10520 ("KVM: selftests: Add initial support for RISC-V 64-bit")
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
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
2.52.0.351.gbe84eed79e-goog

