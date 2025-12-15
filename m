Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB1C341657
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 16:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765817522; cv=none; b=LLCAh8Zszoe05M5Orcd3CByzimeYlURNQskz7j9FpXqoMc7IUccjpb5NQ3Fq/9lfYNWzeSy9D53c2e89d3cNwLqrYuVquuvJA4JJI3sLTHBuJZLqI7edZ2atlYpkxrAlxu8mvRk0E0RJFEnWVfRVLD6bqSgyEbuvTdmZzxNPt2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765817522; c=relaxed/simple;
	bh=ayln4Fw+8UlRvvb+n2Kfq+LyehdpOH5myyhVGffmoAA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hSXMTydg726E9ejAhvE8Kc7oD3m0hYCosw7E4E7zmCINS58H+dAMNC7Ag4hP3BnLB01E27XkkGQ9UgCJc/5JdEb4AN1NyPWmtoIFmyhrmJBSYB2c59t/CM+73xNaJKlFj6VEQ90Ipkv4JN8/dfKoUQ8nEvNiEbrJ+n2WhhEGA4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sp+U43od; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sp+U43od"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4779da35d27so33280115e9.3
        for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 08:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765817520; x=1766422320; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VGTJpqAtjnaQAGGRy8gsotmE8IXAZ0B2ScsPjP/ESd0=;
        b=Sp+U43odRkxy4jmUeucn5XJ5u70dF5J21uDjNgBGEVrigUL1o5CkQZLNrg1yxS1r1A
         Bt5aURNuKBaDs6cLbekBk7BbCXeOGgLNl/u4wXw/K4Y624FHOYxKbG9Da0ygLoKJEjDa
         P94ZnSugNtJl/XNQLSjEMzi8c0yZvpIuahwyCEeFiSRZ4mMI40X2QNFEx8o+50TMWFYl
         UnZlgTB2PUkq+BN/hOwYxhwvFK5rpH5a8/53iGd35m66Qpg4sOoIwxU4L2AMA6zWil14
         U7tqwn6I9584fw0KQ9ZTjdMZDvQmh3n9niWJ/e9bmMxirjCnP2ub2T+NKSHOCzDKwXND
         nGXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765817520; x=1766422320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VGTJpqAtjnaQAGGRy8gsotmE8IXAZ0B2ScsPjP/ESd0=;
        b=syGZeW41+Cekfopr0jkRAje07OGCnPvSMrruwkDqvUSIoTmNYJzD58fe6SP+FvxyE8
         dFlGdTkeLMjiZWXVnPbRXOfa7EUEEyAmle6Kx7Ev8vIQG8v1ZyzYLS0ou9hq+na++zlo
         5YxLo5VTgVnZl527Xo936LEqICWeUbfCj8S+3S9Ls6SPIugqEqO7ePB/no1GMaZplRhy
         KO6zhz+4FO1+SAZOweHQHn9cmKi2PUt6C28jpeH0YkjZ3jRZ+QCmYv84a0/aqMIbPDOo
         E84GAKCfzDZX1F3LRagRxwxYVtAVKagGBpzgPzUIh6hSqfCMgs9mP4wpTldHnZS9Cezg
         t7UQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7vEXged3tPi9Lm0ooC8uYi5Z8Zfq37vl+VQu5Hp+iuCMnCzRQ7yt4CO8JNfC+OXL1DbS7cwY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxwa2zXXCiGixfyTgzOeAEcHO5eYjL6hP8NbmIG/DEKyA+wl41J
	sy0NuNSarlXxFhYxBnKRfKs2YSdm0rMtrfcL0uWPJH96MnuxTM+k9ttx9WMMFNb1R2YcoxDo5tv
	rog==
X-Google-Smtp-Source: AGHT+IHdmoXymTwmtDhUo4OPKD55NjfIa2ZaYkUMxOGs0DQTenx1wSRtOp2+NPGnkVJnbSiUoA2tLeeLYg==
X-Received: from wmbgz10.prod.google.com ([2002:a05:600c:888a:b0:47a:8fa6:6a57])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f89:b0:477:7a95:b971
 with SMTP id 5b1f17b1804b1-47a8f90c5b0mr124657005e9.31.1765817519823; Mon, 15
 Dec 2025 08:51:59 -0800 (PST)
Date: Mon, 15 Dec 2025 16:51:54 +0000
In-Reply-To: <20251215165155.3451819-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251215165155.3451819-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215165155.3451819-5-tabba@google.com>
Subject: [PATCH v2 4/5] KVM: selftests: Move page_align() to shared header
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

To avoid code duplication, move page_align() to the shared `kvm_util.h`
header file.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h    | 5 +++++
 tools/testing/selftests/kvm/lib/arm64/processor.c | 5 -----
 tools/testing/selftests/kvm/lib/riscv/processor.c | 5 -----
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 81f4355ff28a..dabbe4c3b93f 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1258,6 +1258,11 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
 	return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
 }
 
+static inline uint64_t page_align(struct kvm_vm *vm, uint64_t v)
+{
+	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
+}
+
 /*
  * Arch hook that is invoked via a constructor, i.e. before exeucting main(),
  * to allow for arch-specific setup that is common to all tests, e.g. computing
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 607a4e462984..143632917766 100644
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
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index d5e8747b5e69..f8ff4bf938d9 100644
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
-- 
2.52.0.239.gd5f0c6e74e-goog

