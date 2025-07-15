Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DAF2D6406
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 09:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572065; cv=none; b=k0K23tiRva1KI5XG4iOnldz1aC1C89zVcX/1VdMYid0ap7iV4dFIlCuC2fCPw5ocGxpsv6BuZple1ZmEXJ8jL69Jo1Me8c0tkvMdawHjyotRHyT9+VvpqGOvsweTElIqsYshi9QCi5azujIDGOWJJKmmdI7OdAddZFJV5rTp7UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572065; c=relaxed/simple;
	bh=KOsbWmQgjfs61D8HlAyEISk7anlSY+BZ2bEBPLr8lpM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FOgeRfKLEV73/1isZSP/JqFOkrmXCM/cbKBiApAoMtm2WdfhnGJ+w/ESqYjoGsWZ2IDOiJ0IPDZbYyZB58Jvuf/rfJqsPZgOiG9m9B9IY5QZ2xkUT3A6msaOa0ecfgpcgAXPyCr9gUTYiD8SI52blNFaGjOV1KiGAXxKYfAPtMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oR10/yTV; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oR10/yTV"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-451ac1b43c4so29012475e9.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 02:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572062; x=1753176862; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aEKOci68q/+1+5NvCmhg64dST16/3/kdZfJDTw54/Tw=;
        b=oR10/yTVtycDsrfamjIJOMTdeIB70h0UjVdc5FtteKd3tWF3NBUTTikuzGzCq/8BK9
         TcfS/9H9H+cF00L3bviLDfErFzFoqSgmtNo/mGjU2k8XJw4Y1PuMfMmXL0FZfAd2OR1z
         7qfsQmt+hFTEuBEv1noJf4F+Oqb+b8kWH+yh4DiaojjJFmeDsxeo3WFJwhrb83LAVIoX
         XDUf7pR3Kp/3XyadPVl4UPvhAtRirK+VpBxcV4uE53v1RQFjvErI2wVb0wZ4DJ5X6yTT
         o0mVfd+P1eOct2lsLMJ3vdJB6LPwS7alt7llGenl/a/+4NK908kvVRIfdaXNL9FagjLf
         H/Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572062; x=1753176862;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aEKOci68q/+1+5NvCmhg64dST16/3/kdZfJDTw54/Tw=;
        b=bwuaE2uFUrOr/1oHKYdEXgp32ZZkAubAzCtvpusdRKY3SC+6bmOKUJ/WUJEf/37YwT
         mxyL+6t4JP/i1SSEuLTywTWWptuYE3eP9XMRbE3D9fnQihpb+HEMKyFlewcVQyH2caEx
         E4JCJnCZLDbdg2b9RAaulVllhyS8RzVIejsTjluXrjoJy8Sk+PPYzwnmKfvhbmFpjABl
         ZOeBS51j4rPTT1IBN3oL3MbB4Oimm9+t2HqvUgofIm8pbGwCAyfsIne5fHTsZQB2VQMT
         KvD7jcCXl41RleAizmEkST3SuZ5WgWL6uoORsCWaGFQ86y8TpqOR40rDhgug0du4SLNm
         46UQ==
X-Forwarded-Encrypted: i=1; AJvYcCU118Z55KNoaHROXGLIaB+/5rwkaIaqYY2igXw/C6C6zO6Yz+F1q3MGL2+1ga+opbfiY4CYm5A=@lists.linux.dev
X-Gm-Message-State: AOJu0YxbeomcNmhPRRAJcvvUnG5uAxUwGKh3oq9D2esZUaMpr4yy8qcj
	PH/6Hj/uuJ39DVS+rS4Hq6gi627zaBCRdBrcCbxTtboY0hqTmWHO+qL02LEHOmMcrPyHRRqyftA
	+og==
X-Google-Smtp-Source: AGHT+IEELjRi0u+U/t3ZPXir0+vn67lvZW5Zgk9WFpr/aFf+aU4MD6lHSrWdMucnDXEfgpQNrJqHgmlV3A==
X-Received: from wmbji1.prod.google.com ([2002:a05:600c:a341:b0:456:be0:e1e3])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4695:b0:450:d4a6:799e
 with SMTP id 5b1f17b1804b1-454f4259c7cmr132508705e9.20.1752572061578; Tue, 15
 Jul 2025 02:34:21 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:43 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-15-tabba@google.com>
Subject: [PATCH v14 14/21] KVM: x86: Enable guest_memfd mmap for default VM type
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Enable host userspace mmap support for guest_memfd-backed memory when
running KVM with the KVM_X86_DEFAULT_VM type:

* Define kvm_arch_supports_gmem_mmap() for KVM_X86_DEFAULT_VM: Introduce
  the architecture-specific kvm_arch_supports_gmem_mmap() macro,
  specifically enabling mmap support for KVM_X86_DEFAULT_VM instances.
  This macro, gated by CONFIG_KVM_GMEM_SUPPORTS_MMAP, ensures that only
  the default VM type can leverage guest_memfd mmap functionality on
  x86. This explicit enablement prevents CoCo VMs, which use guest_memfd
  primarily for private memory and rely on hardware-enforced privacy,
  from accidentally exposing guest memory via host userspace mappings.

* Select CONFIG_KVM_GMEM_SUPPORTS_MMAP in KVM_X86: Enable the
  CONFIG_KVM_GMEM_SUPPORTS_MMAP Kconfig option when KVM_X86 is selected.
  This ensures that the necessary code for guest_memfd mmap support
  (introduced earlier) is compiled into the kernel for x86. This Kconfig
  option acts as a system-wide gate for the guest_memfd mmap capability.
  It implicitly enables CONFIG_KVM_GMEM, making guest_memfd available,
  and then layers the mmap capability on top specifically for the
  default VM.

These changes make guest_memfd a more versatile memory backing for
standard KVM guests, allowing VMMs to use a unified guest_memfd model
for both private (CoCo) and non-private (default) VMs. This is a
prerequisite for use cases such as running Firecracker guests entirely
backed by guest_memfd and implementing direct map removal for non-CoCo
VMs.

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h | 9 +++++++++
 arch/x86/kvm/Kconfig            | 1 +
 arch/x86/kvm/x86.c              | 3 ++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 543d09fd4bca..e1426adfa93e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2279,9 +2279,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 #ifdef CONFIG_KVM_GMEM
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
 #define kvm_arch_supports_gmem(kvm)  ((kvm)->arch.supports_gmem)
+
+/*
+ * CoCo VMs with hardware support that use guest_memfd only for backing private
+ * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
+ */
+#define kvm_arch_supports_gmem_mmap(kvm)		\
+	(IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&	\
+	 (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM)
 #else
 #define kvm_arch_has_private_mem(kvm) false
 #define kvm_arch_supports_gmem(kvm) false
+#define kvm_arch_supports_gmem_mmap(kvm) false
 #endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index df1fdbb4024b..1ba959b9eadc 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -47,6 +47,7 @@ config KVM_X86
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_PRE_FAULT_MEMORY
 	select KVM_GENERIC_GMEM_POPULATE if KVM_SW_PROTECTED_VM
+	select KVM_GMEM_SUPPORTS_MMAP if X86_64
 	select KVM_WERROR if WERROR
 
 config KVM
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index adbdc2cc97d4..ca99187a566e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12781,7 +12781,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm->arch.vm_type = type;
 	kvm->arch.has_private_mem = (type == KVM_X86_SW_PROTECTED_VM);
-	kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
+	kvm->arch.supports_gmem =
+		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
 	/* Decided by the vendor code for other VM types.  */
 	kvm->arch.pre_fault_allowed =
 		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
-- 
2.50.0.727.gbf7dc18ff4-goog

