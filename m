Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E882C2FCFEA
	for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 16:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769659; cv=none; b=uZ5EKweiii4VrFNHtHbNqu7yD6+bJILUaUJdct2EuYDuWPgWSQXCx0FbWPn2mOkErEwNzFrvJUMJlmJ3TYg4y1sO8+ZLhYCRFSvXwHF9jIFn3DPYkNNEJVj/vtbmUti/eHWa24WykbrsbPV1MZC2OYFLXc4tFrFo6XrXB13i+i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769659; c=relaxed/simple;
	bh=Lh7zcolzQTvzQ5YQkOxSFPb16+wGld51zPVFN204Wh8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gIPbluIoOF/ArvoQ1GZ/jX4uua8EoyDVhxnW8TxJ35X5PhagpwcJxPOno2iY4PTN6nIHFYJxi2RP/XgUiAk0M4iGo5pqfU6f2I5bpjNG1aM+Vvyx/nOE6O8OUZmHObnwh6Y1PTQJ2Gu0+EFbwNUmJG5SLKTJD45fU/SwbGA7UdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hVpYzG+0; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hVpYzG+0"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-456013b59c1so6745065e9.3
        for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 09:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769656; x=1753374456; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=40MY/vvpJmbiADAClao3ke/5IWFeIdLJFU+WuHQ/l/o=;
        b=hVpYzG+0wW5Zns6khoJy7rIl1Kc3yh+Yv4Z7E283klPIMGQThlDrtGi7RhL/Bg8z/x
         NhzRFR+2SMZRApDsNC/VklmMro8dv8KRpcEpQ1l9nrwhRZS6+seAJhP5MSe9Sgi1aKJm
         muHYzteNG888lZ+/BTl8tICwXvIgS74X6+dFad8NqGJtZrxe3vFyVg6OOGQFc/GgbL06
         +T1rcEnF6heEhXPq4JaRzoJ1FO7L0PFXejpxdI/5syLBsVyHRUnLGsr/xAn0VhLWCWP8
         O4G1qsw0ZM8mXihYiHU5lSLm9AC8uod2fEgE6RCSW0Px3D1bLkgXyANs4i7ylnKQ00kM
         NdRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769656; x=1753374456;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=40MY/vvpJmbiADAClao3ke/5IWFeIdLJFU+WuHQ/l/o=;
        b=m0hVUnBx6whFecb7BIwU7SsgJwM3Ce+HHHdJ9EinA0dnawKtdYHltT0f4PqcKJ3Mib
         sWkhsYpZwz8ahUL6igud7Qw0i4EwNnRYxHHpefgGw5OfVmsTXiVUW6Zh5K/830+6Xvss
         Xe0t4xpNRPgZ8RMRwbUpfwKOHJlgVSo4DEUCtjq4Hxc+vLbxkxdvDuuQcsf/OJOap4C4
         VSIknZhTbh0SDNTCZEXMzMG7ZKHofFkUxG4z4Lt18k7UOliSawPDBmanlFe+HJ1uOqJs
         y9991VIUZdAIsYPZdFdai97Ih3swMwfhcxl4Mzp36jY7WtWhsmsVl1wxgiRDcbNl7Fxp
         nbrg==
X-Forwarded-Encrypted: i=1; AJvYcCUL1K+lZffIiTtwtz6Xkrx52sORwmS5mn25v6Gsqbs9fVa2CBgeUHGTXjSowkino483fUaaR9A=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQYJtU3F8QreIwh2Eh8Zzu1otn4OFFsXn8cj2UyLQ8/+/32apw
	qf5FwfpzwLCE4acV5DITIlqvhE7p+hj+3IYqls+MzDYNDwgVM1FO8e4V//Kql+7Pt75/+0w26pE
	Agw==
X-Google-Smtp-Source: AGHT+IFqshLSvHttAe4Lj1HDnzLl4Lnf5WcblvOPO7/tgfsdarzrYhcb+6njRaJ/3SSnSoX+pBdbAkr8BA==
X-Received: from wmbjg15.prod.google.com ([2002:a05:600c:a00f:b0:456:2080:97c0])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c0d2:10b0:456:1d93:4365
 with SMTP id 5b1f17b1804b1-4562e32e2dbmr46846485e9.5.1752769656392; Thu, 17
 Jul 2025 09:27:36 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:14 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-5-tabba@google.com>
Subject: [PATCH v15 04/21] KVM: x86: Introduce kvm->arch.supports_gmem
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

Introduce a new boolean member, supports_gmem, to kvm->arch.

Previously, the has_private_mem boolean within kvm->arch was implicitly
used to indicate whether guest_memfd was supported for a KVM instance.
However, with the broader support for guest_memfd, it's not exclusively
for private or confidential memory. Therefore, it's necessary to
distinguish between a VM's general guest_memfd capabilities and its
support for private memory.

This new supports_gmem member will now explicitly indicate guest_memfd
support for a given VM, allowing has_private_mem to represent only
support for private memory.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/svm/svm.c          | 1 +
 arch/x86/kvm/vmx/tdx.c          | 1 +
 arch/x86/kvm/x86.c              | 4 ++--
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bde811b2d303..938b5be03d33 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1348,6 +1348,7 @@ struct kvm_arch {
 	u8 mmu_valid_gen;
 	u8 vm_type;
 	bool has_private_mem;
+	bool supports_gmem;
 	bool has_protected_state;
 	bool pre_fault_allowed;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
@@ -2277,7 +2278,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 #ifdef CONFIG_KVM_GMEM
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
-#define kvm_arch_supports_gmem(kvm) kvm_arch_has_private_mem(kvm)
+#define kvm_arch_supports_gmem(kvm)  ((kvm)->arch.supports_gmem)
 #else
 #define kvm_arch_has_private_mem(kvm) false
 #define kvm_arch_supports_gmem(kvm) false
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ab9b947dbf4f..d1c484eaa8ad 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5181,6 +5181,7 @@ static int svm_vm_init(struct kvm *kvm)
 		to_kvm_sev_info(kvm)->need_init = true;
 
 		kvm->arch.has_private_mem = (type == KVM_X86_SNP_VM);
+		kvm->arch.supports_gmem = (type == KVM_X86_SNP_VM);
 		kvm->arch.pre_fault_allowed = !kvm->arch.has_private_mem;
 	}
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f31ccdeb905b..a3db6df245ee 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -632,6 +632,7 @@ int tdx_vm_init(struct kvm *kvm)
 
 	kvm->arch.has_protected_state = true;
 	kvm->arch.has_private_mem = true;
+	kvm->arch.supports_gmem = true;
 	kvm->arch.disabled_quirks |= KVM_X86_QUIRK_IGNORE_GUEST_PAT;
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 357b9e3a6cef..adbdc2cc97d4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12780,8 +12780,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return -EINVAL;
 
 	kvm->arch.vm_type = type;
-	kvm->arch.has_private_mem =
-		(type == KVM_X86_SW_PROTECTED_VM);
+	kvm->arch.has_private_mem = (type == KVM_X86_SW_PROTECTED_VM);
+	kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
 	/* Decided by the vendor code for other VM types.  */
 	kvm->arch.pre_fault_allowed =
 		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
-- 
2.50.0.727.gbf7dc18ff4-goog

