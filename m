Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA43428DB48
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 11:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058821; cv=none; b=fyQkJiUG05OVoBTlXGZOZ3EURImTleGSql0PVs/4Wj71JrBpBgR1Jz7gyDIoK79ZJxEQRMSzwjFbQ8dOtpo0UrLBQPpenxvEop1uAEK8aRBrmk2CQ8BFtoRhmA2ELW6DvE7Hl+HuB3wLulG7gWEeIh0mO+fhdQgPOBjX9HQMkbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058821; c=relaxed/simple;
	bh=kinPDc7HtAYPx5khxZsF2f1P/fjG77CLc7x5v6an+Tk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T6pIAGabtfsgyyPs+gPVJi+0WuK+C8PKZE52eMdK6w2RUjqtMlG37BL7iH1E+dAmtLipGQhwgL9k49NDRwZqOJs5o0MBCE7Tscl2EdVh6wl5iTzNfHZIHJvy8qh87FhtVfYTI12uGaP06/KeWRDyi71iLR5/joy/P7SdBd3qn80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RqXRuNwx; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RqXRuNwx"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-451d3f03b74so30522775e9.3
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 04:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058818; x=1752663618; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2WhXJV0NOaZfsKzvuJvoXjTAaVcvXAEjprzCfGc9Cqs=;
        b=RqXRuNwxHjC+HmONlzmbA5z/bL49eTQ3+tw3CIp1UMK+sUoPelkMmfIBjbM/alfuv2
         /iGB36d4sAn0T9Z44/kfZUQKv1n5YIQKur+YB1WAxaW5HDKIjKaP1yvzu0jcgogLRRNB
         omcoq5V6feuizYkowtDPekUSrOcGr5tqxFtCIBK3nELwr1TLfmCGsGDc37fmyqzeZNzQ
         MCBd1wfYLa4Ty+RFOp8FZOEuB/9KKPSK40FSM/cTrarvimcG5Rv3Ege9RUrLP43LeO23
         8u42TE0nOZfq2XVSDeDglOX5vg7hyEZgPyZ3HLDBGx3Lqokn6ANbx6oxCiPX1uVc1gKv
         DSIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058818; x=1752663618;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2WhXJV0NOaZfsKzvuJvoXjTAaVcvXAEjprzCfGc9Cqs=;
        b=lfVDORaSr4O0alaugKt3cUDt5N6B5qTtKCvOLvevZFz9sxNIFzrzrPa7ZEChF8U64B
         DIjILI+6si7i4SYGGx5ALYml+l9TNh4Vp7Rl2uSaK92cHR4ZYZkrnelAM7C3a5YwdMZQ
         hGx+yDqOoeof4sg6vFuYXkyXRMpU8N0uRjkCE56AD0r0ekSFdfYuY97t66280jqxaiL/
         IhHrE29euKEVdw2MB8xDWPvBeRFQQBOyTA4/Q2hleCKVcsDwKdzx5R0fbvTmetuvY4Id
         CWJFZFWxFLEETtMZX0GL/0GqsT9sVXDCidqgXcW3ekIMruGjEgiQeMXFbOWZOY6U4eNx
         QP5A==
X-Forwarded-Encrypted: i=1; AJvYcCXkU5KdgaWfCrkPBQuEW/B05rgPNZBGKS3IIlr2CTEMbxQvAo+EymOSk4/dpPUhzeup87KwHqY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxaVn7EMSTCNiuePfkjig5W8ifWx6rx9mGynmcW1NXGbCGsixmj
	/qDbuv1TO2jLaK7aI1kaN8KvabDYXds17rnTxU9L1gqBfm4fANbRYam/7rMS0tAJJxW29dnY52O
	YJQ==
X-Google-Smtp-Source: AGHT+IFRmfwj1tVW2Pf/313OFdTAH8ocG2uS68MVPRpJjtbT1vysRBtfwXvD7KGwdqirymBMHgojj2PaXg==
X-Received: from wmos4.prod.google.com ([2002:a05:600c:45c4:b0:440:60ac:3f40])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:548d:b0:454:ac5d:3919
 with SMTP id 5b1f17b1804b1-454d530eb35mr17786035e9.2.1752058818488; Wed, 09
 Jul 2025 04:00:18 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:40 +0100
In-Reply-To: <20250709105946.4009897-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-15-tabba@google.com>
Subject: [PATCH v13 14/20] KVM: x86: Enable guest_memfd mmap for default VM type
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
index 4c764faa12f3..4c89feaa1910 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2273,9 +2273,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
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
index df1fdbb4024b..239637b663dc 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -47,6 +47,7 @@ config KVM_X86
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_PRE_FAULT_MEMORY
 	select KVM_GENERIC_GMEM_POPULATE if KVM_SW_PROTECTED_VM
+	select KVM_GMEM_SUPPORTS_MMAP
 	select KVM_WERROR if WERROR
 
 config KVM
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b34236029383..17c655e5716e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12779,7 +12779,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
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

