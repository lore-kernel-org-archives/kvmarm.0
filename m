Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5A8338912
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 15:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765813539; cv=none; b=fMG2iXGWM2E36mTy1DykNxZYnfmHe9LpTTmtxZEDlDvsD4+7g66dEw9cCR80snetlUFUrcgE+fmYi1r4WyBHcewxQZwQ+HJRUedIWcXbzYzahQB9VWX6+vd4dGewG6VCBxqu/RzQXiJF41Ubv5IAtb5EjueNnbOnuzxgCJHOwBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765813539; c=relaxed/simple;
	bh=/VCI7DQ+7GTI8zeB2aLIPeI3jA56WcE85XhXuFDRCp4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UnF+nYMlSUHQu0kLQWpJc0aifN60iBgGThS2mWB8f+HNgVWMfcFkGyeXMSf4LREWo2YRnuNzCi7yrP/OS6tU9xTTIOuPO6t0VJLe0ZkzQZrW3mF4HPkB/lXsXva1T6J+XhWi82lEhgj+WbLOCVguRiEAqwDiE5D3vyxZkQzpHS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dSNBjXB1; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dSNBjXB1"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477cf2230c8so35359035e9.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 07:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765813536; x=1766418336; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YA7YNO0BIUCF/IaZgjS1+s+NSnXmnEjkXZMNklvVQWE=;
        b=dSNBjXB16PeHYM0tVri7yNXliSCqze9Qa/UwfBTCL85HfVDZTBnmZMCF/0x0a/vHMS
         bISvtceJxwh3y3jVsknr1r3Bz2MBWqHyHTxbnjFerxJpv+YbA9LJSYDU2SmrloRzc6UE
         pfCf20GM63qGL4ytu65krFNOlyRJlWc1OUKbeIG64LtPPsQFSn67AUeFOKn7fLFVihHr
         V2IsNj7Z40TBVrKtNevUvPwcuUEfOSFq5tvAb+eQZthbp4xeijQwt3QtPPvolK1q0TnC
         HriR7sr+pyvVO07/IYVTplscaDb+A6dC9udVuJVCRrpZx8DrGI1PPQCKu2fMEUn2JidX
         aomA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765813536; x=1766418336;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YA7YNO0BIUCF/IaZgjS1+s+NSnXmnEjkXZMNklvVQWE=;
        b=VtIJJrnmdepLSyeeFLQJGfj0TIgGOnRJjwJlB18qmqFz3DaJEgwzohwW2vCHrVlo2V
         EIxO69/L0sZ+oPKVzNm3Qs51YEEcZvnTRhuekU8KeIRZUDhtYRXN2duMiZ0awZQHX5cs
         QA2GO0R1UX8aaUIQwmMhvCKNyWtQfOoOEHZsbH2n5tVjGRAdBROuOUQgVuPMhPV6PWzo
         tsoaa4XdfP2JaySl3sMKbXBrrbc1YP3oBQvFbfrQ7wvlb49vm1mTAH/Rg5QcC21C2rP4
         axJ27fBvqn2ZCqlcxMgLTAR7LpCJ7dDfG4mAcHqMp2tFGbnH3bm200LpRuvd7cmzPb/c
         eLNw==
X-Gm-Message-State: AOJu0YyPqwl/ejf+WJSMqTh6amYiA2k1NfSh34Xm2bFDiX4HSIbl2HD1
	XiUOKvb8dAMMbjOIzuo7Vcyl6HcXybVi6ichO17yi79PDhFH+c8ykNXlWT8KCOxxigtXc2CFz+r
	hm7WloD0tmIxpe9W35Msl3HQFUPcEwzsxGj4AIAv72OynImTrn9vLueLxSY+/GZgrAh/7+7+hvq
	DJ9auLrYhAIQpKyXZz1U2GBlmzVM0Nyk4=
X-Google-Smtp-Source: AGHT+IFZI8Oqy0Dwzs46zw2EO/H/+bEzdIN7TuLx6hQsyK4rZ5XHMbC88iQvLEXX9k4sZAwUCKBSJ88lKA==
X-Received: from wmjl2.prod.google.com ([2002:a7b:c342:0:b0:477:1022:3342])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f89:b0:477:7a95:b971
 with SMTP id 5b1f17b1804b1-47a8f90c5b0mr122369655e9.31.1765813536024; Mon, 15
 Dec 2025 07:45:36 -0800 (PST)
Date: Mon, 15 Dec 2025 15:45:30 +0000
In-Reply-To: <20251215154533.3154405-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251215154533.3154405-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215154533.3154405-3-tabba@google.com>
Subject: [PATCH v1 2/5] KVM: arm64: selftests: Fix incorrect rounding in page_align()
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

