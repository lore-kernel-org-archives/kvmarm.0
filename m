Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896333168F5
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 08:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767946959; cv=none; b=C1dD++DtQ92ficXSuG54jYI2JU1YGGOwkkdjqSEEVvpDhR9r3OARvFIgc6WFmXOGSd7WWdInDeoQEHUFCRrHO008oUO1fkmTY1bCR2YJnK72SFpi+0SOUf3M3qLoJhIgwL0iD6vjy/v49yIgIzmMwLk5FDB0vFUmMSYCdSQjYOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767946959; c=relaxed/simple;
	bh=w96ilePjNJnlQ+ySS5jk59GZnLjBMn9Q5Jdzxz6KvAk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kFBL9Wjfi27pk4s2SRTHsGcd4ByFkArRLx9CjXi2zhoQ8VyQJ1UJj0tLg5EZldMP2WB15a8cTV4YzDa8ZOi7aiI0EFX8VxaQlictNoQFnk1tNs0im1sSJ5/btm0wzKZgb5MJ7gQ9OjFUA9daceKuYb4buyDNZXsrBvykAabUTE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wnkZw+Zi; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wnkZw+Zi"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4776079ada3so38332875e9.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Jan 2026 00:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767946944; x=1768551744; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pq9O7d6wzhTity1EvTGcuuOU01Kl/XBUCmwyUjTCy1A=;
        b=wnkZw+ZijikAN5k4Zq0HWDEhxyz7crZ55yEu/4/eTqiOygxqlK0jZVvoeKv3ZkoGc1
         vuyKgB9cL6ajffxsWF401ucg2zXPx12sVlwmZt1x03UWdWttq2odYa1p23gyhF9Gh94s
         KNm4Cra/YwBbhiRC/UINX8L7x2r9nE9FguYq/sMJ0e+HNVKsRwRHcfCjRJzv1Xm2akbF
         YQAyIokMSxHrU3soM+WF9FH4ipnowB+rTvg6D6yq9zxcPaKLvA6WTFxVBXx/hzvu5ArA
         TMX7bHBmNadjFmbRFo6mZaVCdU2ESrKuYvhU+CtkbKBtg6vlgIKgIoudq6JTF3jzeYLX
         oDOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767946944; x=1768551744;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pq9O7d6wzhTity1EvTGcuuOU01Kl/XBUCmwyUjTCy1A=;
        b=SVbIhf44aAyty6ZIHba5YpYVgTOcG7d7IZCu6xi41dHxC5CHwog+V3g8R11L7EnrlS
         jwyUb+u/epiC+bQuSBdPn1VOA4pqVHOsl8nvizj+CGDiYiXEAlRgFIJ9SzLa/wLInVEO
         61QwhORt8IXXYcqhScVwpfPCcC08e702QydLBQuGmS+QHtePCqhjJY4QUWE+C7eH7J7t
         tyyyhMmtgyf7LCnho86k221iqilKTw2aYg+V7vvlhW6Nk2cnbN07L/ccVp+497SiptQu
         LY7Uld1/bErz1UUW3tlSJv0rLy5ooWasK+Nni7+6Wjxq4eHDYtipTH5YyKKuUE1MlaTJ
         3fyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZ/W7JqKK7KoZyFXPL4hyh+qEFyq1CpGevPmCCBUctohO+hxmqF1fcOo0YLESEfNWywtufSwI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwBUaCEltpU6VKU/SyfroMScc0ZHuI6MlXB7a5DQNe6XC0gOjWw
	2WfzvzXN/W52oUtd2JO3vZczkmNxDWhoSpKIXWaSxhNgAr+RWU1FGI2oHRi1cPLzFo2QISGBHxE
	jTA==
X-Google-Smtp-Source: AGHT+IGWTLfUDmVjhmRk/6xaUs6XXjTDY4nThSKMpmNBWodgPyJb8+1XA5L2Dn6202jXo8K9XP5BtW0DRQ==
X-Received: from wrbew19.prod.google.com ([2002:a05:6000:2413:b0:430:f703:f9cb])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4709:b0:479:1348:c614
 with SMTP id 5b1f17b1804b1-47d84b41b2dmr100673355e9.26.1767946943756; Fri, 09
 Jan 2026 00:22:23 -0800 (PST)
Date: Fri,  9 Jan 2026 08:22:17 +0000
In-Reply-To: <20260109082218.3236580-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260109082218.3236580-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109082218.3236580-5-tabba@google.com>
Subject: [PATCH v4 4/5] KVM: selftests: Move page_align() to shared header
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	atish.patra@linux.dev, itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, 
	seanjc@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

To avoid code duplication, move page_align() to the shared `kvm_util.h`
header file. Rename it to vm_page_align(), to make it clear that the
alignment is done with respect to the guest's base page size.

No functional change intended.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h    | 5 +++++
 tools/testing/selftests/kvm/lib/arm64/processor.c | 7 +------
 tools/testing/selftests/kvm/lib/riscv/processor.c | 7 +------
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 81f4355ff28a..747effa614f1 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1258,6 +1258,11 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
 	return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
 }
 
+static inline uint64_t vm_page_align(struct kvm_vm *vm, uint64_t v)
+{
+	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
+}
+
 /*
  * Arch hook that is invoked via a constructor, i.e. before exeucting main(),
  * to allow for arch-specific setup that is common to all tests, e.g. computing
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 607a4e462984..1605dc740d1e 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -21,11 +21,6 @@
 
 static vm_vaddr_t exception_handlers;
 
-static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
-{
-	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
-}
-
 static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	unsigned int shift = (vm->pgtable_levels - 1) * (vm->page_shift - 3) + vm->page_shift;
@@ -115,7 +110,7 @@ static uint64_t __maybe_unused ptrs_per_pte(struct kvm_vm *vm)
 
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
-	size_t nr_pages = page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size;
+	size_t nr_pages = vm_page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size;
 
 	if (vm->pgd_created)
 		return;
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index d5e8747b5e69..401245fe31db 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -26,11 +26,6 @@ bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
 	return !ret && !!value;
 }
 
-static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
-{
-	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
-}
-
 static uint64_t pte_addr(struct kvm_vm *vm, uint64_t entry)
 {
 	return ((entry & PGTBL_PTE_ADDR_MASK) >> PGTBL_PTE_ADDR_SHIFT) <<
@@ -68,7 +63,7 @@ static uint64_t pte_index(struct kvm_vm *vm, vm_vaddr_t gva, int level)
 
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
-	size_t nr_pages = page_align(vm, ptrs_per_pte(vm) * 8) / vm->page_size;
+	size_t nr_pages = vm_page_align(vm, ptrs_per_pte(vm) * 8) / vm->page_size;
 
 	if (vm->pgd_created)
 		return;
-- 
2.52.0.457.g6b5491de43-goog

