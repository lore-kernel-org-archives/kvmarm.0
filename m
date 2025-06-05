Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E421F582C
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 15:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137896; cv=none; b=olAdOcYelvcvmPlpTYfDoWJpwA+23LevF0z5vjGiI9F6/0yWAW9seE2reF3oFPP7/dqirzFNCGb05/0BmrIt4u+84Ws3+TOXVcNlHB1GPhZP4LYu1NbziAuBkZWuol+y6FXqtACuHrIh2S42fp6uGJkN3JMAvTeEIn0njos7aW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137896; c=relaxed/simple;
	bh=ClqrgboMEAhwsqtCXqqp6SxhBiB6M6InDzTzjwdArXo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z6VuQoKdqe1QpLkEUHdkkFSLLJgmqO2tJ2XwVOQLQc9SmmEGMWUnR/CcBUAi5m2e1TATWCtpyfR9mcKN8Z6CZhzzZBls7IpMFHBM2s1zS3+c6uic2YQiy/e4fKA8M5N7sZaJ2tLVGMu+aSxvMhAlduB8BNigVFv8iDIG7Ik8Zw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WpqlddgM; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WpqlddgM"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a523ce0bb2so706019f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 08:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749137893; x=1749742693; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qe3sWK5q5nK1m5jGk9UWStlvXP6F2F3f83ETUbM9FxM=;
        b=WpqlddgMdbrnkHIL1AH8SqbepAJNHBlcPE8eDhPpoR+nhYMTI5IE1kVYQL6Tn5yxPT
         DAhkIJs01ZPdKrzMNdu8lvcvL3+4FsNYLrqiU374DLLDoQpcTmD+POn9aD2plMZ/67LG
         1Ptwle5iQbdv3j0czP1CpWwh4iAinPkLwfYZTdOpVuw1P0Wnv+ncsqBjBv2SnQRnzOZl
         KsaI38IXBE9lEt3tbUVZRjvg5cfuK6M8bDA+BxRUIkxjfkyEfMMkUQoyxlETGC7j1INj
         hOZqaarHtRQr7bHJneD6I8HmsgryrW2IF+hk6lHKQbNsZJNbQg6x4ihwDxgSVj0/ywVq
         Sn9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749137893; x=1749742693;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qe3sWK5q5nK1m5jGk9UWStlvXP6F2F3f83ETUbM9FxM=;
        b=mC7nNg3g5LcFTDTkuuuASFuBjzWt3t8JFCWmp/U8YCbvgnOpADDKKMmBDrojpAWL/M
         a0EiMjKWiEyob6Cdk11qxTyIu0iVT4qlydRpwasx3Sjb67x7HXE9+R84UnEElkNKTBgX
         9dUTOq3xc9W/hHFX7hSzs07MNHe/211gGj3xD8RFnkQlcsMk99dat4p2+Don2TDtCBe+
         ZyLwR691xEBRB9y/R319GZYCWnGmqBdwY8FV4PBhCNH/Ak6yAGZcDYZJNO2cJHFpqY9o
         dvlEAD6wv3sZz9mcPK3cnelBYYh22g2HoyRSuNWp9NK/+NoTOMxONuyZQgS8YHcOzWU8
         UwLw==
X-Forwarded-Encrypted: i=1; AJvYcCU7pyVrQ9U4ygim48fHQiUS0jQh5dMYpq91juqslMYTd/cnR+R4llKVxOpDqPMu9oF8B2dRB6c=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZmR4Q7EU7qh/oXodu7LvxjWsQVNTQ5axpfqqP1+CTaUQcJL4D
	SJIe1smU6kSvw6Ah4a4p6yoh4dcRfE+BXBGcUy865szf4QlEIV8ZP7JuE3jZZA1T4wHteiNNkqd
	EdA==
X-Google-Smtp-Source: AGHT+IFmcdwhn2LMYNxP+uGrHHW9kSBs4n3ZI9kvbXxMD+ySlDN/PQ/FygdrWVTr0+hjocoxBaJLadObcg==
X-Received: from wmsr2.prod.google.com ([2002:a05:600c:8b02:b0:450:d401:f555])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:588a:0:b0:3a4:d5e8:e352
 with SMTP id ffacd0b85a97d-3a51d924837mr6940909f8f.7.1749137892942; Thu, 05
 Jun 2025 08:38:12 -0700 (PDT)
Date: Thu,  5 Jun 2025 16:37:47 +0100
In-Reply-To: <20250605153800.557144-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250605153800.557144-6-tabba@google.com>
Subject: [PATCH v11 05/18] KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
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

The function kvm_slot_can_be_private() is used to check whether a memory
slot is backed by guest_memfd. Rename it to kvm_slot_has_gmem() to make
that clearer and to decouple memory being private from guest_memfd.

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
index 69bf2ef22ed0..2b6376986f96 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3283,7 +3283,7 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	bool is_private = kvm_slot_can_be_private(slot) &&
+	bool is_private = kvm_slot_has_gmem(slot) &&
 			  kvm_mem_is_private(kvm, gfn);
 
 	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
@@ -4496,7 +4496,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 {
 	int max_order, r;
 
-	if (!kvm_slot_can_be_private(fault->slot)) {
+	if (!kvm_slot_has_gmem(fault->slot)) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return -EFAULT;
 	}
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a7a7dc507336..27759ca6d2f2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2378,7 +2378,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	mutex_lock(&kvm->slots_lock);
 
 	memslot = gfn_to_memslot(kvm, params.gfn_start);
-	if (!kvm_slot_can_be_private(memslot)) {
+	if (!kvm_slot_has_gmem(memslot)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -4688,7 +4688,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	}
 
 	slot = gfn_to_memslot(kvm, gfn);
-	if (!kvm_slot_can_be_private(slot)) {
+	if (!kvm_slot_has_gmem(slot)) {
 		pr_warn_ratelimited("SEV: Unexpected RMP fault, non-private slot for GPA 0x%llx\n",
 				    gpa);
 		return;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6ca7279520cf..d9616ee6acc7 100644
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
2.49.0.1266.g31b7d2e469-goog

