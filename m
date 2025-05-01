Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE5020CCD8
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 16:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746116709; cv=none; b=Eq8jkUPGKXTOxXWgK37oMxe3l0rtVTmCjzb6J94HU0KODS9DGq3uDHU5IfnhzVC8pbw31yA5YCkJIZZRt7X7QQ/KLs/7Hxl/UEELeq8QYZ4FHhdA3o+ZSh6JhCzstLWa6Eis8ywS5I04YpkCuPbB5hbKC36M7S7TFaSlSaL8Hpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746116709; c=relaxed/simple;
	bh=MZX842/TEq7rjwC81wP2go6spu2ZfkhRKugLnYcdJ30=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=VbVK3l+q1eH/slRAv63UfV/OSX4aFWwJfhA+trWHXKefQmarTFUVBnqwCAOZEjSqgDyUFFM7M0wI7tYh6GJe0+k6JOSL8WY3qgydmocmhKWpmK8lHu6TnoRbyzVrPPn1eIbvHIjA4cj8w9mvp5OE/qgQsA0adXyljFgyKjfiEyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Au24G3ON; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Au24G3ON"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43d734da1a3so4354045e9.0
        for <kvmarm@lists.linux.dev>; Thu, 01 May 2025 09:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746116706; x=1746721506; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AI2nSAsFsWzNJdU64PivkZrYjUoeKEX3B/t2Pe5a8FI=;
        b=Au24G3ONk0Ig9VUIgybvq8neBac/WVwZ52idklt1VwzXuiBmFsxeRfHyVuhsqKB7Dj
         BNwt5MP3w+GQrb8lwxgYaJcHkTO0SEr3RRBomVSMlso/6BT2ECGXDxAPQgtcYxxMDX/6
         c9K7MyMJsdiK7Jlml6yp+EruPvML7vlUE9LHQRU8GYNHIm3zgYFMfZ22gicLt1gQ2AuI
         mOmAyar3FpOPxh0BVRExnnol9T8BBOoy+z/7IHwCLU136mYxdfsnr/Ly4ZeaA9vLncZ7
         jD7o3WxRwKV3uEBmbq6adOr1/+lFTbzk5fwytKciwCiq+FrIEwbgEy3UZDLeVXT96t5H
         OGFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746116706; x=1746721506;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AI2nSAsFsWzNJdU64PivkZrYjUoeKEX3B/t2Pe5a8FI=;
        b=IVnzr+wCOuRdh/QT8JHAfb8V0Lsdtt2Rv896JpMTlrg0BY9BRrp1Ali+qlCvD9/GG1
         t2bblQRylPM1t8yISPuxGoHqu83rSfpxvxlr4cQQhJO5EOgeEapfUl91xQ1h0VnchHrh
         y+Vw8vsGS6qh5pFsHAX487Y316gzHN5YRNGA6+0F9UYVh3rwYpxfw2BKc/Lufkq4sM/3
         KBR2sE7BjFb4Nk52A3Ad2iCUk1NS7b39MaYitKxxuhlzOKs+Li5VZ79CGZPNiqPT9rJL
         M5tNkw5kY0ZxFkdrWdxAUGx/1hoDI6oWMVW13pAIQXrLOMDGcpwoRY+/f9lWlMyp3KUb
         AAjg==
X-Forwarded-Encrypted: i=1; AJvYcCXjWEtI6947zhrRXHHu31YVyXndg69q7m2EeVCNxbs4k2xxPFlZ6IIIgv+1LH7LDF2QEGdDjKc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1uxIk8qE/wbP4+4Ah8kWZVhBpUAeqYznKXvKt7FpFT8nDEooE
	hI4M7QQHmcG/t3C/9h51WUn1EEg+gdN/TTuvvf7WvA5jyq4Q+hAavOQ2tc48XT6BnqMUjO/tGo8
	ljURu2aLs1w==
X-Google-Smtp-Source: AGHT+IHsbGCA8+vwhzRHIxkKrjDFt5m58pGdLfYxuW4Tr9qxaJAYAoo9b65Uo8DyDirAhoDJRbJuBViIBI68MA==
X-Received: from wmbjg12.prod.google.com ([2002:a05:600c:a00c:b0:43c:eaf6:525e])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b03:b0:43c:f332:703a with SMTP id 5b1f17b1804b1-441b2696c9fmr76954205e9.31.1746116705959;
 Thu, 01 May 2025 09:25:05 -0700 (PDT)
Date: Thu,  1 May 2025 16:24:50 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <20250501162450.2784043-1-smostafa@google.com>
Subject: [PATCH] KVM: arm64: Fix memory check in host_stage2_set_owner_locked()
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

I found this simple bug while preparing some patches for pKVM.
AFAICT, it should be harmless (besides crashing the kernel if it
was misbehaving)

Fixes: e94a7dea2972 ("KVM: arm64: Move host page ownership tracking to the hyp vmemmap")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2a5284f749b4..e80f3ebd3e2a 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -503,7 +503,7 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
 {
 	int ret;
 
-	if (!addr_is_memory(addr))
+	if (!range_is_memory(addr, addr + size))
 		return -EPERM;
 
 	ret = host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt,
-- 
2.49.0.906.g1f30a19c02-goog

