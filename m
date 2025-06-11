Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0760F2BD59A
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 13:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648840; cv=none; b=fWlOG9eTQSL+5miiV8RN0/mYhGS6PTmkDoO9Fbwjn1xKCI3mG6JHoRI+udSV7MAAV3rUUniK5ZAEPMY5qThsyUq4oGRZNoXn3EAxJ5QjO8EzR2I4nnq1B/vdQi7JbNLP9J4iRUE93Ds0sqbG0Mw95Uq6LIViI+uHT4STaNfQYjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648840; c=relaxed/simple;
	bh=tYG9no4G4/4JoJdOu43WxRTdUoeN59thOVKVvS8wFCQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BGutFAEX0s0KIClf3tpLdq0ZwB6qmJfPTpBRVbGWxo01l4iaLThF89o49Pf3lfew6c5xr+T6TFC39xmpIrpX5R97XcRz5DAdScKBc6PNz9z0RJlgsupwm97+bsT8dSv0cdWa+0ff9DE5fxAAPSlWORznd50OJsyKwSKNeFsIawM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QxeVvsnU; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QxeVvsnU"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a4eeed54c2so4365864f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 06:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648837; x=1750253637; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0GmgHpBmCA6zvNGFoi1Z/wq5QrRCsY3MSz2+Tp46gs=;
        b=QxeVvsnUKB8H7ihcRhmH/1NqjrzxkPHAr0qKVrAWSU39MbemswzQ8ulZBkOGZMz/vb
         wUzwq8VjJpGT04uvrTEovhu/4ccMLPr1WQLtcDofrLUs+9dyj+/3eu24LYzl83Fk+Efs
         asOPtiPKcLHCRNkh/EXs/2YW90CjZgXDixkeVAIF5fubZ3EWwV1bSqf37iaH8iRTkWqz
         0KR9VyOSOda0YY84Vk6LzDDVwsyjEqsuSLlnKminxSF2O7av5/qRG5Xvu8sye/fC5Adk
         ArBSZUH/FnWivvWc8i3fhFDiA1b7e3E3+4jkYODF0rwNDikm2YrC/smCFpX3MrRU8yKJ
         C/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648837; x=1750253637;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0GmgHpBmCA6zvNGFoi1Z/wq5QrRCsY3MSz2+Tp46gs=;
        b=YHB4Z5gc5HpNdOSlosxSp2nwF7PqLXQiWA+MS4e+FtGCPmAPEPqFLOACIsZbnZBua/
         MkTevUf0wWs+2HI3044grYmkfGVH2er8/M1a695cwRyZm/qyI4Ma1rxYsvZ8T2zFafVS
         0AaZSIOOGRme5/ibRjCLWDVLemoC4y3FscQaXv0+q8XocFvTRb6gWH74Rjpq7kUoofeF
         6incQHMD0M1BQK2Rdg4O1JgVDuzjoj2PLjCBm0Y3mrJ4hKTwLD3tTDSgzrbJc0QaawmZ
         Bi1TT/GYtlWiZQRUfW8JwDDXimz7SKQIHCtYWV/OHkH9mydoL4dLndTVg7Dq9PUorAdJ
         OZzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAPIULKgiZZko9yThtSzaeyhG7K+iFdFLMjiL5jt8gzmx4ycaB3f+3wPVqscDRSa6T4XrZ7dc=@lists.linux.dev
X-Gm-Message-State: AOJu0YygFTVzVNmu2gWXx/nswf9Rpl8GXh3rmKk9jvD3zC01EVyZLxtP
	GhPhX2n1cyPtuaRV70A7qwIjiknRZP6KQM5PhG93O9tpUAJLj3dCdt27MzZRfc5CS680BK7U84j
	/Hg==
X-Google-Smtp-Source: AGHT+IFsqWff+6T7vsnYAkU42VVIgmr2bH+P6xTa1OxLp26jM0y9wIP/2qeKEvMKHtR2cbUL2VHzGV2row==
X-Received: from wmbji2.prod.google.com ([2002:a05:600c:a342:b0:453:910:1a18])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:290d:b0:3a5:2ef8:3512
 with SMTP id ffacd0b85a97d-3a558aa3a1fmr2525369f8f.14.1749648837456; Wed, 11
 Jun 2025 06:33:57 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:24 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-13-tabba@google.com>
Subject: [PATCH v12 12/18] KVM: x86: Enable guest_memfd shared memory for
 non-CoCo VMs
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

Define the architecture-specific macro to enable shared memory support
in guest_memfd for ordinary, i.e., non-CoCo, VM types, specifically
KVM_X86_DEFAULT_VM and KVM_X86_SW_PROTECTED_VM.

Enable the KVM_GMEM_SHARED_MEM Kconfig option if KVM_SW_PROTECTED_VM is
enabled.

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h | 10 ++++++++++
 arch/x86/kvm/Kconfig            |  1 +
 arch/x86/kvm/x86.c              |  3 ++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4bc50c1e21bd..7b9ccdd99f32 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2271,8 +2271,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 #ifdef CONFIG_KVM_GMEM
 #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
+
+/*
+ * CoCo VMs with hardware support that use guest_memfd only for backing private
+ * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
+ */
+#define kvm_arch_supports_gmem_shared_mem(kvm)			\
+	(IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&			\
+	 ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||		\
+	  (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
 #else
 #define kvm_arch_supports_gmem(kvm) false
+#define kvm_arch_supports_gmem_shared_mem(kvm) false
 #endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 9151cd82adab..29845a286430 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -47,6 +47,7 @@ config KVM_X86
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_PRE_FAULT_MEMORY
 	select KVM_GENERIC_GMEM_POPULATE if KVM_SW_PROTECTED_VM
+	select KVM_GMEM_SHARED_MEM if KVM_SW_PROTECTED_VM
 	select KVM_WERROR if WERROR
 
 config KVM
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 401256ee817f..e21f5f2fe059 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12778,7 +12778,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return -EINVAL;
 
 	kvm->arch.vm_type = type;
-	kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
+	kvm->arch.supports_gmem =
+		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
 	/* Decided by the vendor code for other VM types.  */
 	kvm->arch.pre_fault_allowed =
 		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
-- 
2.50.0.rc0.642.g800a2b2222-goog

