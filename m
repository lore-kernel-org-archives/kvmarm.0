Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA655311587
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 08:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767946955; cv=none; b=ML6nn7PZDWE2a9NLflpO7p371yWv7DwqW+NSlGZ0dD/UmB0wy0ox3Q8tPD8Klf1vLoldr7jXg5JLLm7eyzPMNTg/tCd87ESyGQE/nD8bK2Otw3yJocXpXae4lc3pBX5K0OyDtncMjwLSQpl8F9MTrfS8C7+obPWvn8tK+G0ocMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767946955; c=relaxed/simple;
	bh=x6qRQWFnnMwvN/oed3S0rLIDrotCBFv7ItG+p4ucujU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CxaPQ1tAZRFYxLhMOm4jdBxfeGnNe459Z3Fj4K4wSRJANm/9fRkSZzeOlhGRfb6zpDHfmmCLTFSIxidUo7787C4Tq44vnBDc/E5IsodB1ILhIsbHAGCO4ReJblyYICrmjWgd0Z94AFgygYuzQ8d2Da8fzTPHnMfArpZrJCUNXfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I73cTSUu; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I73cTSUu"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477563e531cso29257115e9.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Jan 2026 00:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767946942; x=1768551742; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WTwC3FF8o3D1tLIxF1rzohdijBesrjYjdFLpGAMOcJc=;
        b=I73cTSUul6ynK8+9K4PWKaWMvEzqNQqlImUDllJbUVFlh+MGYODA/nfvY5JYID+bAZ
         X2tM4cbrvqy1i5PfYjVRgGiXEShiLYmowYLyKxpC6XFhBTiE8L1u7UdM0RLowfg8OYtB
         KXmvQaPSldHZ8GgXPX65CflWSWV6XOlEUeWsPCera7dDnWreussE7ya2l4rfESF7JuMp
         9DiM7BKixhPpnApU7WQvmoUu6zSJOkmPtEFvEYBpg8vbiH6xe5ngDpFdtVcPle+RCOkw
         Ac5Y3zG0k7+hmac8uI594qZ5p4FNb4pr2DhpI0sHHtOpH3hTo6yUfjR2Rb42kVI1EQt6
         T25Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767946942; x=1768551742;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WTwC3FF8o3D1tLIxF1rzohdijBesrjYjdFLpGAMOcJc=;
        b=kFhhZDLsbUvbNCLpUxNqK46NrwCMaKo3QY85V4YVfQuzggXBiuU2Lgt5+Tx3Pcq0Kw
         eDOVTc5YHa9yPr/bq+yyd1ZSOCq9dyWlZ1fOyHktYok7M+2Jp77xfPn54zaZ4ERIJLCe
         yMiLv5K10RzQKssZ8YOF2a1PdSp8mNbxzv70VDhN6kcGYjHWkWHTIPtRR+XK7vViWWxq
         NKpzC8JzCDtKLlCpwBVKE18sFQxLyrPGcsQKZdyfb0tokDsoP+R23HtB0pjY/N95XNeH
         F6Y/Av1ftalsInzqwDDKKWwsTQvu95TUMGatVdJyMx7r5zIwjThoFpweGa+bg+uOJil/
         PFew==
X-Forwarded-Encrypted: i=1; AJvYcCUCUdTtqzejiIo2TesGADvXlrixNxgT2nQixIgE0+IbR2pQ6aImhiWXjgkEaxY7UuwLRt3IwZM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzlvuDTaZeW5RnKUGclFy8fASLhsbp6eOmMg0sUfFPVUDyhCTCK
	9VrHexDKPKe/L4kb2zlozV7iq/hYf7BpxDz7jYUclhjS+cC0GIkfkICcGoJJ51QumsnFPei8eON
	0RA==
X-Google-Smtp-Source: AGHT+IEbTZ+JAQZIIX5R/diRf8NtI3qcRyEYMj72NqYPRiSA2F4mmy/NK7W30kPtTdFlYjIQg8wuM2wdbA==
X-Received: from wman14.prod.google.com ([2002:a05:600c:6c4e:b0:475:dadb:c8f2])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6287:b0:475:dcbb:7903
 with SMTP id 5b1f17b1804b1-47d84b17b7cmr101603035e9.9.1767946942620; Fri, 09
 Jan 2026 00:22:22 -0800 (PST)
Date: Fri,  9 Jan 2026 08:22:16 +0000
In-Reply-To: <20260109082218.3236580-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260109082218.3236580-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109082218.3236580-4-tabba@google.com>
Subject: [PATCH v4 3/5] KVM: riscv: selftests: Fix incorrect rounding in page_align()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	atish.patra@linux.dev, itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, 
	seanjc@google.com, tabba@google.com
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
2.52.0.457.g6b5491de43-goog

