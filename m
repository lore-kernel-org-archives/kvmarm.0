Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F213528DF23
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 10:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058800; cv=none; b=i02jFTBz8fz9OuFhyRfcwVFm9tuub/rtpImtdS3xwRuDk42BaTC/7bY7/+Gjyu7hZL4KnlH46Z482PCJ6y5aeOrGbWGv6X/Jf3wK4w0rfOFs3Pv2eiM/oaLgbkJxhSESEfnSGE64+AybywmNos6C1CktDOSvyNpO30F8rDS/eJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058800; c=relaxed/simple;
	bh=dmWH8UBdSFpulXHfw1/tkK5Z8KBvTQ6balgySxZjyX8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P23nCsB6Kl5dHdgg53aQfGoOVgOPp9lB1u/BnEG5LGOo32plYE6vqQY4iex1EcMZQroKOlStlRfIX2vT0pS/pX9sQO+qrRem9fZ4Lez19dnneaFtzZNB4JrdpiNlpsILMC4LsGAyYwx79ix/4qu/w+VrnPjJTwhyR8r4+bCmvYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m1calBVl; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m1calBVl"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45311704cdbso38052355e9.1
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 03:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058797; x=1752663597; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1nerSRvSEN++VGwTZVRhn1CYNqQb3amsSUbSxJbQxyg=;
        b=m1calBVlcmvMCfigCxVyyBRhI66cZsRLPrA3iblsByZ0GFxEtmfPjdmrJVPJs0lL2l
         LPwaZWbenSClcg1NZmKY5Iqg3gxYeUkgFRpZGSDEPaIfIM3riVcWeO50vU3ZBBuyxy+v
         BABVjsZPbOLrj9iLoYu1XNHdlkSXtbT538gK8fqPmxLiFk3MILvgaUHnA2iNOVAlXsYg
         MWYFdaIBcX1x2k97g+hXSC0Hua2Xyos7olvvoUCSDAaQgEuSSp9gzUC2X7j7GkrrzpqE
         lWkUAxXe6z0Of+dbSB9nUxDpobWIBw9BrrzYgjVeLD6PIRcWyvuh/bKTwcalzSBgffKJ
         Ruow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058797; x=1752663597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1nerSRvSEN++VGwTZVRhn1CYNqQb3amsSUbSxJbQxyg=;
        b=s9ndepTIMUowPiyiaqHLKw09CP/hxCD3D5W3b9Qm+kV6ECEYn1l1wEwT5v2tD6oV2D
         qXd5KsFhl3HIyhht49QDOd8EpOXLG8ozfKTMxXe0fdCwp4MSDLnehZup8sW8wrJHHTX7
         1p5fNAud3LiwGNrX1LpqeqsiceQ74bz98890zXpyPGuXsuuc4KBI8duz+GEwhyI0s6rx
         FyJyr4+t84lB1yxcvRagdpdb4NIbimGDY0EMq/6f4f4V5ayKMOpFn0wvuFU+0lBtjRMp
         mh4Lh0kSa16oWtj6Kz1WXnbzLwE6/3oUAzjlIPUGjEw+OJRPbMnLlJQebvCz6usBXgaE
         QvEg==
X-Forwarded-Encrypted: i=1; AJvYcCXhQrtEtwjwSxfQZGcohT1uvPU7lIgGQQ3w3B9W4R8lvipGsZSUTJTWo2vzULOrrF2ZZKRKdMc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeXaxNripNOLfCk5P7wYsUk806+261krZPaW8/mVFgCPY1pCOA
	aYqTlAZkEB92o5fLhzFGdekmi/2Y4vYAqyhWl5O13m9ijgsUl8zTaCtw5SV8RBFcgm4rGLDxDEt
	9Qg==
X-Google-Smtp-Source: AGHT+IF+FiHZUhkzl6RREu2Ok80YnFe3XuoEKaVzjMwloMyacVfiOCCgEgREFNwx/tC/M70jnYp+B4NiNg==
X-Received: from wmbhe3.prod.google.com ([2002:a05:600c:5403:b0:450:da87:cebb])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d03:b0:453:59c2:e4f8
 with SMTP id 5b1f17b1804b1-454d532c1c3mr17202785e9.1.1752058797364; Wed, 09
 Jul 2025 03:59:57 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:30 +0100
In-Reply-To: <20250709105946.4009897-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-5-tabba@google.com>
Subject: [PATCH v13 04/20] KVM: x86: Introduce kvm->arch.supports_gmem
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
index 09f4f6240d9d..ebddedf0a1f2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1342,6 +1342,7 @@ struct kvm_arch {
 	u8 mmu_valid_gen;
 	u8 vm_type;
 	bool has_private_mem;
+	bool supports_gmem;
 	bool has_protected_state;
 	bool pre_fault_allowed;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
@@ -2271,7 +2272,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
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
index 1ad20c273f3b..c227516e6a02 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -625,6 +625,7 @@ int tdx_vm_init(struct kvm *kvm)
 
 	kvm->arch.has_protected_state = true;
 	kvm->arch.has_private_mem = true;
+	kvm->arch.supports_gmem = true;
 	kvm->arch.disabled_quirks |= KVM_X86_QUIRK_IGNORE_GUEST_PAT;
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a9d992d5652f..b34236029383 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12778,8 +12778,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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

