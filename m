Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D424D28E5E6
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 11:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058802; cv=none; b=CEUwks+N207mlJckE9czvMUcbi4wkpcnDHwD60klmZFeAOAfeB0f4WvmcIJe6+bbsH2N6jSqJ2GRr/QN40s4i/mmNLCN7P9l71o6cJhxCWyxVX23PBl8Nyd5F8Y5jq6aL6vUFqMiaiBILPoVPxSXK1Uj+Wn5Oyw/TIxFTCty5Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058802; c=relaxed/simple;
	bh=0OuzOJYPGireTSNTxyWHKEmPI2NB+k8Qn2NIiXdBEP8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mfev8dFLTA8Dju6EsyW6hjPzURRQfDKmFFYUuDUv7eElEdPltwZ8j9+SFpVM/Xx2/X5Li2peGZdt5hxbXtElPWGEA+sU8mIHu72Fl9ik7X4LyxgjxWKcAaeNIg7bLCHkSiJ7bhSPImx36wDkvkFmxAEmsz2DC/dNae4nB3W7JhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P4JDT66l; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P4JDT66l"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45311704d22so31591415e9.2
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 04:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058799; x=1752663599; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9AmJt3JSIC2bm90ziNqKjnyGIAyeHrkJLic7hf5RL/M=;
        b=P4JDT66lkDkz0wvzTf4kmKy519fWBJwuMFXpij9+PUGlQCrKb7g4p+cZau2vLtMbaD
         XFoNsLqq37KLp6JHpRr/1priBry1SoLM1vkmju5mbko3OkLbQzScPKX6mnQ+FMLuoCwH
         T8r5VVAC5Jff7BY2xOYY/R6ohsAb0FmCqOguzpL9ipzwgz0738xTnXSpHdy97Bdhu0Ss
         uMazN/CrUrmLGWZY3bJqMXcLXxu38KwjTzTSXAAhVMkDtoT9ufe7Nlmf+3u2mjR+bUml
         V03FIr4Y62hOMPwhUSWHEnZ0OdcUxl8a0HFOtg0fkV5Wkge1lnAQNsrXiPfTED0c1NG0
         5LAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058799; x=1752663599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9AmJt3JSIC2bm90ziNqKjnyGIAyeHrkJLic7hf5RL/M=;
        b=oQ4O/Ved80uFcgUmcq/ddHR1oTnKzoVc1lDEdQPn0YI5SgDtWXdV4kVkDqMowZTLQL
         qizDB2AzIsGpulD0ilFK2pMYV7wNsJpiGJpUaxtYDZNnHG5CVA0b5PkY6vNN5jvRvFWZ
         2JPhDxzm5d83SAMiBljJTM9xBs4T+va0KoiFL6ndhOLCLRQfSoTvlCEby7gsHD0EU/J8
         8/7kDpY2e4UyFJBE9ClWObZqx1cpsDesYR6UHJTxPJhFJLa7e8CPD0BkbreIiLhlnU7A
         G47Urd+9BNLGkgC9F2dFCGWRsOYTp3c+qhbqUI6H2Ai7I8yWwTcoht5XgfNhEcFpm2jJ
         LdUg==
X-Forwarded-Encrypted: i=1; AJvYcCWGCrh5ThPFozK0BXFz2IizI6waGXEIO0Gp6WrsyXLP83uYa3JCy3cpqzoQVA5bpCGS994jExk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9DwbfntA7ZVk8ciwpUXs+pQJIQCtglwgHhPybwepONjRI7Gek
	v7oCympe6eRQyGnm9JmalDlW1Dv1g0pPhfLulR0bkXMyTcLfL6Dub9krXMiCiBajXXgwzBRWFyy
	ksg==
X-Google-Smtp-Source: AGHT+IE+2TZW+dbYocsnC6GGlK4Vi+081qpuZi8IBcmNih0IEcKRjGe3Hl0WX1Ir2nLOlb1Mn2L1NomloA==
X-Received: from wmbjh9.prod.google.com ([2002:a05:600c:a089:b0:442:f9fc:2a02])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:19d1:b0:440:68db:9fef
 with SMTP id 5b1f17b1804b1-454d53eef2dmr17048565e9.20.1752058799393; Wed, 09
 Jul 2025 03:59:59 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:31 +0100
In-Reply-To: <20250709105946.4009897-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-6-tabba@google.com>
Subject: [PATCH v13 05/20] KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
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

Rename kvm_slot_can_be_private() to kvm_slot_has_gmem() to improve
clarity and accurately reflect its purpose.

The function kvm_slot_can_be_private() was previously used to check if a
given kvm_memory_slot is backed by guest_memfd. However, its name
implied that the memory in such a slot was exclusively "private".

As guest_memfd support expands to include non-private memory (e.g.,
shared host mappings), it's important to remove this association. The
new name, kvm_slot_has_gmem(), states that the slot is backed by
guest_memfd without making assumptions about the memory's privacy
attributes.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 4 ++--
 arch/x86/kvm/svm/sev.c   | 4 ++--
 include/linux/kvm_host.h | 2 +-
 virt/kvm/guest_memfd.c   | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4e06e2e89a8f..213904daf1e5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3285,7 +3285,7 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	bool is_private = kvm_slot_can_be_private(slot) &&
+	bool is_private = kvm_slot_has_gmem(slot) &&
 			  kvm_mem_is_private(kvm, gfn);
 
 	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
@@ -4498,7 +4498,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 {
 	int max_order, r;
 
-	if (!kvm_slot_can_be_private(fault->slot)) {
+	if (!kvm_slot_has_gmem(fault->slot)) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return -EFAULT;
 	}
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 459c3b791fd4..ade7a5b36c68 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2319,7 +2319,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	mutex_lock(&kvm->slots_lock);
 
 	memslot = gfn_to_memslot(kvm, params.gfn_start);
-	if (!kvm_slot_can_be_private(memslot)) {
+	if (!kvm_slot_has_gmem(memslot)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -4670,7 +4670,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	}
 
 	slot = gfn_to_memslot(kvm, gfn);
-	if (!kvm_slot_can_be_private(slot)) {
+	if (!kvm_slot_has_gmem(slot)) {
 		pr_warn_ratelimited("SEV: Unexpected RMP fault, non-private slot for GPA 0x%llx\n",
 				    gpa);
 		return;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab1bde048034..ed00c2b40e4b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -614,7 +614,7 @@ struct kvm_memory_slot {
 #endif
 };
 
-static inline bool kvm_slot_can_be_private(const struct kvm_memory_slot *slot)
+static inline bool kvm_slot_has_gmem(const struct kvm_memory_slot *slot)
 {
 	return slot && (slot->flags & KVM_MEM_GUEST_MEMFD);
 }
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index befea51bbc75..6db515833f61 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -654,7 +654,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		return -EINVAL;
 
 	slot = gfn_to_memslot(kvm, start_gfn);
-	if (!kvm_slot_can_be_private(slot))
+	if (!kvm_slot_has_gmem(slot))
 		return -EINVAL;
 
 	file = kvm_gmem_get_file(slot);
-- 
2.50.0.727.gbf7dc18ff4-goog

