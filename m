Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBAB2BD59A
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 13:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648846; cv=none; b=ZUgy+f/QvBDc6kkOMXruGOr9xaeZYsvQEC7YF+f5PjQwG6d0J5hLdHp6Wsa/GknwkMOsf0dcY+DIHRh48hrn6gnLY1lXvdnehfxAhBt/ryZF2j8OCG53FyyigRzpvCn2Zk4TBtosua8XxWWARPrfLhs/KbjVDtIJOaLd2VaCuuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648846; c=relaxed/simple;
	bh=afnwtC3mJv0p/q01Hm03VsZ9g+kofebcwWBhQ+EF1D0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JUWuCmxf8eYchpztcDjrr6bailwj2AL0ym+9vNn4cmeZ/KnTh1W2s9MSzuL4w4wBm8j9cJzZGIOXSu4yo/H6Bd8szfAr+QHOAA19WoHLeOzDy22etByW0Hor6V9ocVRG5uRcjayoYoiA1+dS/Mw6w8Q7mHq52uggVsL9axxGmzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dXkzqcmg; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dXkzqcmg"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-452ff9e054eso22661005e9.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 06:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648843; x=1750253643; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fr60yTRM3Le7KlhcyzAIwAP1RCDbA7i9ZnNcPDG0Gps=;
        b=dXkzqcmgo73fte2gV2jOG35IlnIah7bYS2i09oqU3QHlnoBXHU0YXsuUuSEsfrm2cu
         F29F3nBXc2bbOVdrC7ZCSd5mBIrKiQprMaEXIySzW30xjfL5WGmZJMbqw9VwWdxAegVe
         XL8AO98h6YhFV+LOvM1z4lPzY2XpI2gySnxtqkutFRWCqo8ZdlqxqdlW1l1hrj9109dG
         xy47b4C+u5TyVgHlE0uLrbYGYyuxZLa7+S0wokc1V9iZsyfk7lXdUaDq8tEyojJA2On5
         MMj5+5R+TbhPn58ljIe6wLhFxDu3PAI/jpPX2DN+685VZ+bb98g5lpIW1Y1geVB6q/zI
         GJZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648843; x=1750253643;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fr60yTRM3Le7KlhcyzAIwAP1RCDbA7i9ZnNcPDG0Gps=;
        b=MlcQWLog7A47V8UPpJLryyvN5IleCcCKIceF+VTEDuIMLtzNVx2gIwOGzmV37aT0cn
         3CA9jPHZvQXkNOvvGCXMLO+5+ovlvFp78Y+/zZMD6X37+th8oOg927Tv+9XtLtHCI4iu
         0FCX3KOX1pZwSHdEwFOJzI343jRjN3/ecQVoo3WEhL6d9H6gGQwGGk+yL59DamBntAM9
         21bYxqbxDad0bZqc/uXuvpaGJ53mp9tre5vXa5MnABdw8F0+HLaZVF3kprllnn1lOYtR
         CHtLUie2hh3nMI9LfpAFvYIbdWiyQ8mJ5CYORIgzA4k/g2v/mT+ibZmDN8dIjZ2Gc/+e
         hp9g==
X-Forwarded-Encrypted: i=1; AJvYcCWdSqDPZBr7WKRA7v6oOMB2LG/TaJHDlIwyQfPPUReRFFGXKFb8vgPuIkyJaDNlNxfpS9WCFnI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+nch7Zn0gESd8aIWiXpdIWBldtT4hsKGBHFwFp9Bmd2S1gai1
	5QgCSakPo/SRVTVe38x2nkO5g0rnuBsUbZbQMk26O4iDntl3bKtbPF4k0D3qjprIRPkb5tI5ICe
	pxQ==
X-Google-Smtp-Source: AGHT+IH14t+wSkhybtHuLmzZkceSzcjY9wgExM45VH1zSci1aRvRXa2k0A1lOzdSmzXE1XT7zgcgV0z25g==
X-Received: from wmsd14.prod.google.com ([2002:a05:600c:3ace:b0:43d:1873:dbaf])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:144a:b0:3a5:2cca:6054
 with SMTP id ffacd0b85a97d-3a558691a5amr2274572f8f.4.1749648843428; Wed, 11
 Jun 2025 06:34:03 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:27 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-16-tabba@google.com>
Subject: [PATCH v12 15/18] KVM: arm64: Enable host mapping of shared
 guest_memfd memory
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

Enable the host mapping of guest_memfd-backed memory on arm64.

This applies to all current arm64 VM types that support guest_memfd.
Future VM types can restrict this behavior via the
kvm_arch_gmem_supports_shared_mem() hook if needed.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++++
 arch/arm64/kvm/Kconfig            | 1 +
 arch/arm64/kvm/mmu.c              | 7 +++++++
 3 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6ce2c5173482..0cd26219a12e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1655,5 +1655,9 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
 void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1);
 void check_feature_map(void);
 
+#ifdef CONFIG_KVM_GMEM
+#define kvm_arch_supports_gmem(kvm) true
+#define kvm_arch_supports_gmem_shared_mem(kvm) IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM)
+#endif
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 713248f240e0..87120d46919a 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -37,6 +37,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select KVM_GMEM_SHARED_MEM
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 71f8b53683e7..55ac03f277e0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2274,6 +2274,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
 		return -EFAULT;
 
+	/*
+	 * Only support guest_memfd backed memslots with shared memory, since
+	 * there aren't any CoCo VMs that support only private memory on arm64.
+	 */
+	if (kvm_slot_has_gmem(new) && !kvm_gmem_memslot_supports_shared(new))
+		return -EINVAL;
+
 	hva = new->userspace_addr;
 	reg_end = hva + (new->npages << PAGE_SHIFT);
 
-- 
2.50.0.rc0.642.g800a2b2222-goog

