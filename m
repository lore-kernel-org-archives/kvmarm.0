Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707A92FEE06
	for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 16:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769670; cv=none; b=GBpK7Fof1V/8gFOdW+4wrqCJAHoi5sg1NuU/G8LK7dVSwDN4C7y53r5G1NO2c6hkIuMACVCTwBelgF1ygiTvjhQuOQBRI+T/28yqsFfq3fhrKwTBHnqcpXTsrsxC76EeCi3yDxFmYxOL3CmhyrQOO8gIGjmYW3eQj51GjKb2qF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769670; c=relaxed/simple;
	bh=XqEDOOHzbtsev2fOvalNFu/wy33rAet52j1YnkQ4zec=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vAJZD4qid0Oqfm772Fg6FDC8V2nkiw1MLW8+YBbK91tvqdbHJiCH/HbC+TNSjWFeIU02/OAX393YahXHdPeWLqf01FtBJJ8LFty4WJHN7aUTD1rOA8kQxoLv+Dnn49xFP9UYvtrQGLNhf//bL3CRIvlgyL27QDe9zWj8N1iZjEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bu4UtDn0; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bu4UtDn0"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4561611dc2aso10244915e9.0
        for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 09:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769667; x=1753374467; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VJ+SnMbckSSIhN9bCpI/0R+FpsGYVOPeZJ6oIUky9aI=;
        b=Bu4UtDn0CY75CVmXK6SiFZMjryhT/vi5xl/sHUX0cSP4bNmU97GWA6AKTUuYxmpqCk
         1O1iu8nUYF8qWZb/EvzhumH1bxkIM/wreiy1e5UAJr93yayFAqvWxdcnYUAgtC8kAHh7
         a6tcB/OiqqrpDBMgn0BiHDhz1H5dvOcJRLhkusrOLaykdA5McuzZORL41kpwNHt+SwhT
         FsALSdw/s33Dm9IUhhEeXADn3uxz7Umdvr41bgk+3LtDcUKfUiiU6lk39e7Ixl43M2MN
         J1hyQ+24bdPdBLb8PWfucvqJZBSdULjSjCtdBf2+c0hdk+q4BD4K17IMFUHIvwNZMK27
         XWkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769667; x=1753374467;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VJ+SnMbckSSIhN9bCpI/0R+FpsGYVOPeZJ6oIUky9aI=;
        b=TluO8OsjlgYqI0zAJo9YkVYPYfysSRVyqd8V2m9HlJOwdsya5gxKrtYOuhVmRCpJ8I
         MMs+pm0l++7u0PMyvy5JFCteP8T4ql1EVzPVoeLLRBTrm8fb0bYak1lJymiXWUsadnRH
         QG1426yt6iLqGmdwdWchmv8ADpH35r7v5Gz9fSseE48rRKC3MHxTZMFRKxUhDo447wSz
         PwBaOGbaotXyzwMAbtrcStxO6u9L9pftsXRZD2uGgT8/WNpjTyk+dPdxQqpKPiM2IG/s
         igobdQCUexMml5P3eAdVTeFSXPNsnCF3ygESzEn6M4/D2hxwkhKWLWKX1SFDk/puIgk/
         2DDA==
X-Forwarded-Encrypted: i=1; AJvYcCUXxZeg1SA2QqHHKHE9iNO+VJ838LLpz4ScSZKMdd4LjMGCaUb+uME7ZpHCPkpZXR1hbLeJcvE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/ta6xZ8uefoc3hPtjB1BeciVry9vsYwdy3hJ0Cr2w2ichE6LP
	SRr1ZC/0N1pcFiQoT4kBniGLtHg99EU90Yali4kLNc1ccb9hpkYTUlm2lK93nA4xed3ETaI+BTU
	Lbw==
X-Google-Smtp-Source: AGHT+IHEntPmO9DY+DxchMnwOgYv2GREd1oegFwljdQ3Vt27b6YI+20amCtzyHAiGDugFG1DH5Xc3wIVPQ==
X-Received: from wmrm6.prod.google.com ([2002:a05:600c:37c6:b0:456:13a2:2e7e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8188:b0:456:1923:7549
 with SMTP id 5b1f17b1804b1-45634dd8050mr33926905e9.26.1752769666906; Thu, 17
 Jul 2025 09:27:46 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:24 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-15-tabba@google.com>
Subject: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default VM type
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

Acked-by: David Hildenbrand <david@redhat.com>
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
index 12e723bb76cc..4acecfb70811 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -48,6 +48,7 @@ config KVM_X86
 	select KVM_GENERIC_PRE_FAULT_MEMORY
 	select KVM_GMEM if KVM_SW_PROTECTED_VM
 	select KVM_GENERIC_MEMORY_ATTRIBUTES if KVM_SW_PROTECTED_VM
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

