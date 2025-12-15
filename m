Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CE333891B
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 15:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765813541; cv=none; b=ItrfXQvOW1M+az5sIIN6TJi+l6HTyfQaSmNGcEOVsY05GP3H3VTbxdAZqElGV2bfDAGHxbRlzrVhkPgPzoZRQ74d4b1v3ldOHIF2LWYMv7XjclocMNPe9BIMAlz12Fu2ZbbsAvUZh2IR5G71bbCrQGPgsS8hLDP0FH/zVNLFZ8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765813541; c=relaxed/simple;
	bh=ayln4Fw+8UlRvvb+n2Kfq+LyehdpOH5myyhVGffmoAA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ff7re98zY10hW6VhFKewzcgKZxxkIP/lL8j0yWBd8Vqy2fSB+6P1EbIG5oes0fatsaBO7ySt3UU36oKIex8cM+OGKxAIW5emjC0YPnGoQcW7NraGWtIRQo17aKqnKXJuh3WiFo80HfM25aG17Z1p5GZwvAhA/T8u6R9xaSVGWL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=35uGCw7X; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="35uGCw7X"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-430f79b8d4dso815338f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 07:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765813538; x=1766418338; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VGTJpqAtjnaQAGGRy8gsotmE8IXAZ0B2ScsPjP/ESd0=;
        b=35uGCw7XrD6Xyuwb0A1QFcE1+t6vaNHpk49FOWCRKzvqFSCj/9X/lHISjhHRT9OsVv
         ArQfH3vdmdYTVvvAE5q4yNANdE57X0jcj7NTPIKwJ13d5upICE6mfdbn7MTiTuecKwxu
         bxdXMs7Ig/QCqN8Qno14vI+8S+DgFWGc58hriPVyHmljhw5HxXAG2ragmspEOSzXiUJ0
         iFwGZXQyj977SIB97tXkZf18B18L2Vw9t2dq4AxyeOAGVUxxFDJpFe3iHh49FlX7imj0
         Wp/h3xLcxt1NtHVevjD9rNrrNSXhj4Ed3rmQYhr9WNXkGfW5g4Eaf2V47VQo9Si3/xl5
         j+Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765813538; x=1766418338;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VGTJpqAtjnaQAGGRy8gsotmE8IXAZ0B2ScsPjP/ESd0=;
        b=vZMnnyF7rdJpkwq5dtm87qsfnTSsHQZSp0HsbJRjVHX5n9CMYOfpaiJYgcOZ9qicqv
         +jDUY463p5oSJ3CqsWH4u/fN5H6dgCzSTtezUrWWXQRoQVD7mnL53dzKxwX0ThdgRREN
         DX42K+qG06PB7R5TeJhy62IS1yewvhG2R8QkWJqyarTnrRga8u+BsLabOLvt67Cw+QSo
         2s+76h7XDYSFjozfmXG0EmrrqH2fKgls24FSQJM2EUd18Mr6oRu5nAxWdVWNSz6Lz1Zp
         7rZ/xap0HPHWLMpkhCEIl2W6cI++5YmZW2l7s5L2WLkLWCjqiPl9bKYBB/YWLy2RJUL1
         7jAg==
X-Gm-Message-State: AOJu0YwW/ojzY/9tlO677IXeiSeHwal5VujFnlpfbYeztGYAC+7dMZMT
	YZxcpL3kkumTseVjXejHEhwZZdz8H+85xnhRm9dLaTld/njYqpw9X4ftJHIvKAq7B057+j2KQpb
	GtgKv1CeQHtq92scjmaL+qqPasNMcUbK/0lcLPwtSSW0Ig+lScbLCrwaKSyDvQJVqLgSl7jNbIS
	xz8VOL0aZhJmfx8OebTA7naWpeEQQbVLg=
X-Google-Smtp-Source: AGHT+IF1MpRc9WCV4iNqOeKkM/bPydRIafajA/wmrsGONtcLwMuxj9cblPfLQA8xrv+eJQIjYXzjtyAfRA==
X-Received: from wrbfv11.prod.google.com ([2002:a05:6000:2c0b:b0:430:f798:7803])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2307:b0:431:32f:3140
 with SMTP id ffacd0b85a97d-431032f322amr854887f8f.12.1765813538338; Mon, 15
 Dec 2025 07:45:38 -0800 (PST)
Date: Mon, 15 Dec 2025 15:45:32 +0000
In-Reply-To: <20251215154533.3154405-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251215154533.3154405-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215154533.3154405-5-tabba@google.com>
Subject: [PATCH v1 4/5] KVM: selftests: Move page_align() to shared header
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
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

