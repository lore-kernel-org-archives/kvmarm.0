Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048912D6603
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 09:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572045; cv=none; b=SfXj79kGXQWhqCau27xi6CpSIPGi+u1Le4x26VJd/uVApFZ4BQanCzmPvKVYJTM690h00qHUkGgONVr6GqbG4hSpWZEpsPaM1V29cysPvCGCalbMItbwPhsumt9LW9sv9yuff0rdCj51T7/mUto8Dcjp5H9XQh6+lpgt8gRJ1EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572045; c=relaxed/simple;
	bh=8drK7wXvtedh2HpFNUcdbXZgnZHxeXsUaLbHtq7/9GA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QiUXjhLkrBMoQ1ylSJt0RAwxp3qpul9ry7+eyij81h369St8+9Bq4+StlUjN5lDirrAuHM4NMdVhzQxqsoxGWR8clgTjOGkXIedHXMD4TCusvcWzeS1LTd6p4QQCH7+qmN+nQdAtNB6S6Fo/25JfxG7byTQnBecltQqR+2rQp5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=heZ/nDJ1; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="heZ/nDJ1"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3af3c860ed7so2304180f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 02:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572042; x=1753176842; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8pudhEgqt6j9GkneYmmruy0SFjYwu+6usi2MMhMEwBI=;
        b=heZ/nDJ1jQhyNKfixxt714Q3e7muXtrkUBVKaAkOlkt28rDb0xmjUpS+k32UQW5eV3
         h3BZcmfun/25Ym0+ubNe4NWfsIIrfnEQmZUmMuwLx/Vq738Ufg+Rt/BxYY3GfYRIsL/g
         1okkDqyFIUkfE/+f8mn/OWEkQ6qxvi4D0ar2EO7TBUKrmu5mnI6nmv08Cbs1FoKP7EJ6
         eBba2QqUzv3UOovFB6OdyQykiBSVwiWloEIBjsT892FDFcqEt0IvcyNgZ0TlnTdoAN72
         7xBI+ZPHSzlmbN6OJSorrtYRoRpzl38XqHKkyuZc0D3oE/eV2xdpPmdGvwZc116/PdvJ
         LYIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572042; x=1753176842;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8pudhEgqt6j9GkneYmmruy0SFjYwu+6usi2MMhMEwBI=;
        b=AJhOes30BMo5p6oNtPFMIo6ovrMRI4E+++wMLn8L8IAkb7oBBUNiqR/3vtjOFqUbCa
         FN9K/gmsb+FSq2p3phRDLSQ+eJKJPORz3LJK71voE/QD/mS4LV+weLFWe0aWaX9/Xfrg
         aFR79htKozxBaO8rBFoJQWbSJoCjcqR0/nXbG/XmMyikTzCBAv8Lt4YfFtfSKWndduWk
         GCzurLKKWNh15i11rN0FA5xG3mEdOWJT24Lr9HrPOyDqwvkv4K1qoG6rv1mIteB1qBOo
         LufmONUp/kK7aiBaZeBNd5qE5vdDysMDYvG7eAyvO95SOEAr9+C0KYAHE7dqb8iToYPj
         7D+g==
X-Forwarded-Encrypted: i=1; AJvYcCXLcVxGgAoVdb0jb9+ixtJFYs+9w7lRCBNTJBc783BH/Iqj+L8gCQw140Tm+7l+ZjV3W/1ch14=@lists.linux.dev
X-Gm-Message-State: AOJu0YzduYCRxZ0y+C6drTT02mhkEZKgF/I4HLqcNrs0HUysX1JRzNva
	X9VMl9z+DSiSa0ogg60ZOT9Rq3iei4A0TswspOUIuF+89NgCtdV7abg/WyKlLaA1po3/pve9tT0
	m9Q==
X-Google-Smtp-Source: AGHT+IFctu0fAkeb8CPBUq72/4rilEf/lWwdMxSroppHEiafl4lyrm/kvgmt1YhMWTR9YyccADVY1z8Y6Q==
X-Received: from wmrm6.prod.google.com ([2002:a05:600c:37c6:b0:456:13a2:2e7e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2207:b0:3a5:8a68:b81b
 with SMTP id ffacd0b85a97d-3b5f2e26cc0mr11225293f8f.44.1752572042216; Tue, 15
 Jul 2025 02:34:02 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:34 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-6-tabba@google.com>
Subject: [PATCH v14 05/21] KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
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
index b201f77fcd49..687392c5bf5d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2323,7 +2323,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	mutex_lock(&kvm->slots_lock);
 
 	memslot = gfn_to_memslot(kvm, params.gfn_start);
-	if (!kvm_slot_can_be_private(memslot)) {
+	if (!kvm_slot_has_gmem(memslot)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -4678,7 +4678,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
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

