Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94912293C70
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 11:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058828; cv=none; b=S7jeKW1uQab1c/cUgE1JFBy586/2osAbkDPMsP/6SsKwBKyjn3tH51VtrHw2g7ScsX+iWQbPPnYFX9SzmfbfL5EH5OLifPjAfIdGptmOkoO6iaimuTqHPaQFjuRvVRATomGhAhC85RLMBkNQaJoQBbgvZ+xn40InBJlAd0+lPBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058828; c=relaxed/simple;
	bh=i1677ulQ+FpX23BeUODESVUylvYUsyZh0fRA+XWc+Qc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KnFnQA0hhf7TegR+FS6cs1yMHCd4qVTqLcXYLW4sHDkLcMk+RO1SIEaBY+RYYqGyWEe62xzWc1zA7P5nVUqqYi8+FZM6dlxafTteSMsatkKgS7TPjfM3IOVIz1pxO1xs9idRhesyRkkXIkrm5CI8n3hDvfJi0gKx3Qdu98L8UD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j/vyKkR0; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j/vyKkR0"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4538a2f4212so28976865e9.2
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 04:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058825; x=1752663625; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P8CqTX/re2H78xoOHzX7zO0o4O1lOtYkxCnG9hu+yv8=;
        b=j/vyKkR0HMkApP49+5BgconrRVMGHX/C9TU3X0XW2L0ApXS8q/Or4TFhut2vjMU1CL
         DIrFsfVg7Xa/OeyN87xLrYwfooxleLLi6tvEj8k8URfKibO/8iEMFnrMQh1+ncSabPcV
         zOURWHb/TJ//Z/QCV0C7YNTIxbweCAj43YESDbquV8WcH7umsmIHkiSo/x1spa2Y8Fh7
         t2CxZ5E9M5weaT4gMeyWgs1Lo/vbp9mNRQZVJO8BPQss3O8tMJ0eeCw8UEbLqYH8gPl4
         UVpP83FaSZfOZXvyRGcJG6pmVDQHJlxjchJ9hAtfDWPXmJJqd4UBEPRm0cwQjqbxThVH
         4D4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058825; x=1752663625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P8CqTX/re2H78xoOHzX7zO0o4O1lOtYkxCnG9hu+yv8=;
        b=bl77lN2CrzBRyEaOigOcZAc3AY5QZ1ghtb5f31aMuJRD4T654RmcMgZvXsEyZHIaW3
         WI/rfMqJo2Zxv6OAuDxZ0P9LhtFQwEvD1koZ2BpMif0GSpy9RrzUMgQ2oqqnP5D9KMht
         5rPXH6Xl/Vb7K8LYb+O3XLIsSO96LjAy2iIGKN5ic9Ef219wrD6/hyc/gCZDMzX1jDXg
         as3JLZKJquA+gvLPGKjEN7w10utz5u70SDl/c9q3jrYIgncEE1o5JwCaNwStzwDwnSAc
         t44Zu1y79Ja4f9a94VUYPngAaEdzbPJ741iZHb8ZjYDpBo/szLcBDpBBv9VyIPQCGORA
         rj+w==
X-Forwarded-Encrypted: i=1; AJvYcCW2m1vgsZf3K1zqLANKdRDmTi89A+HIAs/QayfYJ2vzG8ntbFk/ohO8EkXwpCqtc0RpAiHEz/M=@lists.linux.dev
X-Gm-Message-State: AOJu0YwXxZFQfhlWzEk3Rpf8bzGtmb8D8xI1cg6LvUeOyxK5UcvhDi0I
	1n5AcKvyFt1qlD8x3au8ItWvZ17UOwyBm9hguS3cM/n7ij9Auit8pXiqwMJ6LXXMKGhu7o55NZj
	OeQ==
X-Google-Smtp-Source: AGHT+IEHnvYYUOmRrnCbtHPzW+od4gurhsCdgI0yOzILiG8n/NWLWOC3y08BZEdPiw1VxjNfEp1TbYfLTQ==
X-Received: from wmbdz10.prod.google.com ([2002:a05:600c:670a:b0:442:ea0c:c453])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:46cc:b0:451:dee4:cd08
 with SMTP id 5b1f17b1804b1-454d53d5ec2mr16682175e9.23.1752058824847; Wed, 09
 Jul 2025 04:00:24 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:43 +0100
In-Reply-To: <20250709105946.4009897-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-18-tabba@google.com>
Subject: [PATCH v13 17/20] KVM: arm64: Enable host mapping of shared
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

Enable host userspace mmap support for guest_memfd-backed memory on
arm64. This change provides arm64 with the capability to map guest
memory at the host directly from guest_memfd:

* Define kvm_arch_supports_gmem_mmap() for arm64: The
  kvm_arch_supports_gmem_mmap() macro is defined for arm64 to be true if
  CONFIG_KVM_GMEM_SUPPORTS_MMAP is enabled. For existing arm64 KVM VM
  types that support guest_memfd, this enables them to use guest_memfd
  with host userspace mappings. This provides a consistent behavior as
  there are currently no arm64 CoCo VMs that rely on guest_memfd solely
  for private, non-mappable memory. Future arm64 VM types can override
  or restrict this behavior via the kvm_arch_supports_gmem_mmap() hook
  if needed.

* Select CONFIG_KVM_GMEM_SUPPORTS_MMAP in arm64 Kconfig.

* Enforce KVM_MEMSLOT_GMEM_ONLY for guest_memfd on arm64: Compile and
  runtime checks are added to ensure that if guest_memfd is enabled on
  arm64, KVM_GMEM_SUPPORTS_MMAP must also be enabled. This means
  guest_memfd-backed memory slots on arm64 are currently only supported
  if they are intended for shared memory use cases (i.e.,
  kvm_memslot_is_gmem_only() is true). This design reflects the current
  arm64 KVM ecosystem where guest_memfd is primarily being introduced
  for VMs that support shared memory.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++++
 arch/arm64/kvm/Kconfig            | 1 +
 arch/arm64/kvm/mmu.c              | 8 ++++++++
 3 files changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d27079968341..bd2af5470c66 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1675,5 +1675,9 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
 void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1);
 void check_feature_map(void);
 
+#ifdef CONFIG_KVM_GMEM
+#define kvm_arch_supports_gmem(kvm) true
+#define kvm_arch_supports_gmem_mmap(kvm) IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP)
+#endif
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 713248f240e0..28539479f083 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -37,6 +37,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select KVM_GMEM_SUPPORTS_MMAP
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 71f8b53683e7..b92ce4d9b4e0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2274,6 +2274,14 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
 		return -EFAULT;
 
+	/*
+	 * Only support guest_memfd backed memslots with mappable memory, since
+	 * there aren't any CoCo VMs that support only private memory on arm64.
+	 */
+	BUILD_BUG_ON(IS_ENABLED(CONFIG_KVM_GMEM) && !IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP));
+	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
+		return -EINVAL;
+
 	hva = new->userspace_addr;
 	reg_end = hva + (new->npages << PAGE_SHIFT);
 
-- 
2.50.0.727.gbf7dc18ff4-goog

