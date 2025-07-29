Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9C629344A
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 22:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829747; cv=none; b=QFDFt5JkKOHQ1kOEAU+l2oRHlhdTD4w1K1t6fIZodbjFMkSrLqHPIE2+p9cAD8Kiya9EZhuok95b86osvUya1HYwDYqiGf/17Q/pzWrVz42C6QVToLEJSaNlYRSIRUcsZeZqnEoz8HQERogq0FMkCTOlJR4XF2TtGRAW6aMoIe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829747; c=relaxed/simple;
	bh=Sh/IfRFoYWaPKcCYaCpo6wz2Cjf9m+WXMtg9Zp0+6jw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pZbjYTYbPZgriRaHezmdKgdB3zfYA+bri8NJRzhiDxUHnWQAKXt6TxKkBQQpNA1HHUZBi6m+qyjbT5bzXoJgfUy0K5zuvDKLW51Tng5ya200PvqwNtmoMgJ0gKwP7RFvO8Xzvik+v7Iij7m5PkyBmGeBNBeJiuVkkzfGxlbnYOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yoRkVwJg; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yoRkVwJg"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31332dc2b59so5983061a91.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 15:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829745; x=1754434545; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oV6gYTik8qRY3StGmPp/EUp2dAdw3D3Ak3GOGxl25v8=;
        b=yoRkVwJgY6jLCvQHd6l9odnlKwsr1bZFAyODrgZdKJDW/Be3MMis0MExdKLhqU7/s0
         zKeKHKYLT+G1O06EZ9zhn968eq228zmkW+A2u57CphPqv+I32Q3uJ5jIiqQh/hv5OwYo
         6aXgWGa70kM4yCjEUipdqCJWTQJA1f4pUSDJidkDq1o5xa5l9aiVRnfAyluFBsfn3zDk
         9xlXpWtBaGUXRUFMAuuyGVwE6atU6ZLLxHJbhfvpwhhnXuDHJz5gPkv4PLsu5IIoZjLQ
         0ezvQIWs+j+7E9AnCEeKHK96q4qfO2Yr/Im682kZlxczhdYLEmNJVsx0KCkepbC7UBYk
         m7GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829745; x=1754434545;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oV6gYTik8qRY3StGmPp/EUp2dAdw3D3Ak3GOGxl25v8=;
        b=nOX5KPaP3nyruL+6mppNBPRboq0bpvna3jyS9X72Brif2uxrvBj13kxZumcOwnZlBj
         VRmmb1rk6m6udnvI/zX0cvG8ufjZ3zK3fgriZuWaEu1kKuUpuGBxGynwa+i7Hj2Iclk4
         aM9GoP5ESO222MogfJHBrMW54rzqbHv2qwojwmo0Bad6si4ovDgm6ehZ/pNic4YuSHwe
         pq1itpUJB3oX2Q/3cLAx3p78l2KzPhQGesDHZunc0wk+x7cg+9EQH+9CoqkJJPLVu2VX
         VklvmtyGeeHG9FE4dQYiNfva3E8OWzuBmOi8JykVaKr7pGiZKMUL/lQO61PNocn+T9Tk
         aQjw==
X-Forwarded-Encrypted: i=1; AJvYcCVeMatmBqceYp0w80skvaleLfCGuLg/TJaksJ8xvPeaoyHZF8NOT9YqDwdDrje9mioSbQM3hKQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzvfa+30uen+n8a389M5qrBhiKcg3YEougUva5Iy/T3c3xVPX/N
	pnBN0byHU+mS4Nlaj5GrpBIr+JzBHB03fhLFNB6xnshp4b01sZPp9DVSO9M8o9PusLuzMOUa3Q1
	+Abb3+A==
X-Google-Smtp-Source: AGHT+IFUKuUgGE8Xp/j1VSO4HB6WlF8z7V2tvMpDcnp8m/G+j0eEa4knj1wWJuc7IsYN2X0Q+kKp6nFysik=
X-Received: from pjbpv8.prod.google.com ([2002:a17:90b:3c88:b0:31e:998f:7b79])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52c3:b0:31c:15d9:8ae
 with SMTP id 98e67ed59e1d1-31f5de68c89mr1509857a91.33.1753829745204; Tue, 29
 Jul 2025 15:55:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:40 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-10-seanjc@google.com>
Subject: [PATCH v17 09/24] KVM: x86: Enable KVM_GUEST_MEMFD for all 64-bit builds
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Fuad Tabba <tabba@google.com>

Enable KVM_GUEST_MEMFD for all KVM x86 64-bit builds, i.e. for "default"
VM types when running on 64-bit KVM.  This will allow using guest_memfd
to back non-private memory for all VM shapes, by supporting mmap() on
guest_memfd.

Opportunistically clean up various conditionals that become tautologies
once x86 selects KVM_GUEST_MEMFD more broadly.  Specifically, because
SW protected VMs, SEV, and TDX are all 64-bit only, private memory no
longer needs to take explicit dependencies on KVM_GUEST_MEMFD, because
it is effectively a prerequisite.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 +---
 arch/x86/kvm/Kconfig            | 12 ++++--------
 include/linux/kvm_host.h        |  9 ++-------
 virt/kvm/kvm_main.c             |  4 ++--
 4 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7b0f2b3e492d..50366a1ca192 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2276,10 +2276,8 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 		       int tdp_max_root_level, int tdp_huge_page_level);
 
 
-#ifdef CONFIG_KVM_GUEST_MEMFD
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
-#else
-#define kvm_arch_has_private_mem(kvm) false
 #endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index c763446d9b9f..4e43923656d0 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -47,6 +47,7 @@ config KVM_X86
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_PRE_FAULT_MEMORY
 	select KVM_WERROR if WERROR
+	select KVM_GUEST_MEMFD if X86_64
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
@@ -79,16 +80,11 @@ config KVM_WERROR
 
 	  If in doubt, say "N".
 
-config KVM_X86_PRIVATE_MEM
-	select KVM_GENERIC_MEMORY_ATTRIBUTES
-	select KVM_GUEST_MEMFD
-	bool
-
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
 	depends on KVM_X86 && X86_64
-	select KVM_X86_PRIVATE_MEM
+	select KVM_GENERIC_MEMORY_ATTRIBUTES
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
@@ -138,7 +134,7 @@ config KVM_INTEL_TDX
 	bool "Intel Trust Domain Extensions (TDX) support"
 	default y
 	depends on INTEL_TDX_HOST
-	select KVM_X86_PRIVATE_MEM
+	select KVM_GENERIC_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_POPULATE
 	help
 	  Provides support for launching Intel Trust Domain Extensions (TDX)
@@ -162,7 +158,7 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
-	select KVM_X86_PRIVATE_MEM
+	select KVM_GENERIC_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
 	select HAVE_KVM_ARCH_GMEM_POPULATE
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 56ea8c862cfd..4d1c44622056 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -719,11 +719,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-/*
- * Arch code must define kvm_arch_has_private_mem if support for guest_memfd is
- * enabled.
- */
-#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_GUEST_MEMFD)
+#ifndef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 {
 	return false;
@@ -2505,8 +2501,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
-	return IS_ENABLED(CONFIG_KVM_GUEST_MEMFD) &&
-	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
+	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 }
 #else
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index aa86dfd757db..4f57cb92e109 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1588,7 +1588,7 @@ static int check_memory_region_flags(struct kvm *kvm,
 {
 	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
 
-	if (kvm_arch_has_private_mem(kvm))
+	if (IS_ENABLED(CONFIG_KVM_GUEST_MEMFD))
 		valid_flags |= KVM_MEM_GUEST_MEMFD;
 
 	/* Dirty logging private memory is not currently supported. */
@@ -4917,7 +4917,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #endif
 #ifdef CONFIG_KVM_GUEST_MEMFD
 	case KVM_CAP_GUEST_MEMFD:
-		return !kvm || kvm_arch_has_private_mem(kvm);
+		return 1;
 #endif
 	default:
 		break;
-- 
2.50.1.552.g942d659e1b-goog

