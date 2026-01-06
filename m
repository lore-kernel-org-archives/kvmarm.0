Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F983161BA
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 09:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767691476; cv=none; b=txMg914asWDxP51wKW0s6D2V11lbVpaS65fJ3Uv1rmRiLUjBH1mo+kV+fav6URSzOVrP8zAW1MboNXryBSG5XxgBry1/v9TTqmFXGAm5sgg3OBD+xFYqNVb8wJN11zsYuZsPFgyqfbXZbbjNGDHTaPhJ1JgeVVnnUPYFd0ADc+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767691476; c=relaxed/simple;
	bh=U4Uc7cfFCbVrFYrK2pc/nN0q0fRyukpzVm5Md8fH1vI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ls4knhbxjZAIG1KJcnO4htmCklh19tzMjSJ4hJwWKtxGPt7hUEwsqiMFu/ct1817s//1bav9HcbpIsCEJOeWyfiafFH2fNUcuXHeoYrJ9BsNGSSM+lnoq8p49oXhHzf391kHI8a2Pexb9s49tU+nlnl8k8HR4S1H4sFq3y1oaI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VXRL+Nag; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VXRL+Nag"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47777158a85so10862425e9.3
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 01:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767691470; x=1768296270; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GnwfbAHF0PCbdtqYfWOE4YUYyRoOfTU/WzuQ296CXfU=;
        b=VXRL+NagyoAeiSJ9RtsSwjZaawvHyiennCtmYhpgD42JCG+LSq3CDSH4BvIngJPlxC
         pp60td1tlFwgmlvA7b++CDk56NqnOkQ8hsoRWv7n9QCNLdFk9QRz4Qc2JvqaBBWtkWqS
         ThNMDN3clfaltJezzIQM0dJNEM2HVEsMhFkFMYn0e6l296GiuVJXoHUoJJBkiNUNNSE4
         CJrFlNHqWLwRWpWsqked6ylp2GkLsXIDSmrCDNVESEFPLRCtZrHwZFHWl9+1Gorckqrd
         /eXHTo+mQDsNHEtv3xNtXB9yh89A69A7+cf7k5UXsgohEfz01l7V0KAY03+k8q7Nx8DL
         w1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767691470; x=1768296270;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GnwfbAHF0PCbdtqYfWOE4YUYyRoOfTU/WzuQ296CXfU=;
        b=UJWAIhxti5tA2yT4hRif7381vqG3r2da4cdMn7/Uo7aj28oZzhzhFem/Z/EQfVnc2z
         eKrDNRYjNZpxCSolMie1sDseFBy240vAjvzQP7Z88aZ0NW8lGNwSkL6Hpt+r4gb8rdjH
         KhwViKGE95eghazKfuHvjvOPZZG3Iyze3t38nUhbxJN1fOV52I4eBDCOaE/YuNre5nQf
         4a365lMFMMGylxgXDa9Ssp6tsPgXB2bxjj5XpI7RnTUxcAYhT41ufASn5snTkeewIIXv
         zw22rId0+sfkt8KsWTHcrzJeMPsBWCJ/2YGXv5LD0p6PZJgGGbS0r8AR7YjJwHyRFsVG
         qniQ==
X-Forwarded-Encrypted: i=1; AJvYcCXp3hUISHMwCUlYkswCpOuwbNP0yoDkjAsACun8URPa/U9yPTBbUflpasYQXnSbWbv+alIe8KA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzO8PdTQVnIy/fOx3qrsSoq0xIIQ9ntjDD/Hr3PQPGklj4GMdST
	aoOgeWCkvbo2CaiLiYvWSBcaH6b1EDiOq6YQeFZZK+zRceYVFRZVBoLuyiFzIDXv88LAReV0Iw9
	fHg==
X-Google-Smtp-Source: AGHT+IFcux+MH2/SnWRN59yd/EeqV0PSeYuceHIifCar56w5WkrXGG2T9nSrUb58DNoCU0or4EnrLtHc9A==
X-Received: from wmbdn5.prod.google.com ([2002:a05:600c:6545:b0:477:9fac:c456])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a16:b0:477:58af:a91d
 with SMTP id 5b1f17b1804b1-47d7f06b874mr27945865e9.5.1767691470261; Tue, 06
 Jan 2026 01:24:30 -0800 (PST)
Date: Tue,  6 Jan 2026 09:24:24 +0000
In-Reply-To: <20260106092425.1529428-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260106092425.1529428-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260106092425.1529428-5-tabba@google.com>
Subject: [PATCH v3 4/5] KVM: selftests: Move page_align() to shared header
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

To avoid code duplication, move page_align() to the shared `kvm_util.h`
header file.

No functional change intended.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
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
2.52.0.351.gbe84eed79e-goog

