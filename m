Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD0628B3EC
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 22:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829742; cv=none; b=W0MLfQcToTepx07xbNILiiQEHOWiPMbLEJ6VpumTODI0YhuSTTzFWgrsOGeaQnawmG6BbyRW/S1Wu9SKDLNyTF1xdFVR00K48mf0gNXcb3ae8apfb/gF1hi6spGEnpdoSX3kOPooLKsA9HBnMl9wFUELHffLEf/Nn1JVWu6X+PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829742; c=relaxed/simple;
	bh=hi/18U82wGIIZl2EYW42KIDZYw4mjolrxOlqRIgipOw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CQy+iJahSfdlkPDxygEVfwEZUuQaFWtERNjWLdYBfaqnAGngiSl2TesvWoqYGaFOCi9tUi3rMwOa/IwDALoiB+0CqefpRFuGFcHbKcO7XUuGtA0OwaWFdmmGmXnUccTMWsKEJldLwX26iXTOfqa39QxE8ROYMtlDYvAiXx15/c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M36rlZs4; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M36rlZs4"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b362d101243so4644463a12.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 15:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829740; x=1754434540; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FhtpXawluoN1TztYZndQOy+flGIHfIQx6Vy9IgjwFIs=;
        b=M36rlZs4zkHLWEZNsEhoJSOiXZL3AhCUuLmxuztBIqwHJu3nktAMud3jAcxHheL3eL
         b4JeP0/Gh0Edz52r+T1FtqgNztbEZYxvB7YwjDUNxWaMXbMHJHB+c1tccs4e1OAQmqUb
         UMR913wY1zNfPhg6UGn7Uaa9N2106WXkOueeXekPwbdR5njxO/AzgtNCL1iA/E/VbK/j
         saS1rhmC3BksDJqKiC2E5ZkRxikMu3f1qwYntMX7E+dReLXkMh+OFKmvBJntB5Mqrurm
         bx/J6BL341AZf0Snof6NJ/1csQ/+PABT65snH75lpr91BJIkiVu8AJi+6kxJihigSbz0
         PWfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829740; x=1754434540;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FhtpXawluoN1TztYZndQOy+flGIHfIQx6Vy9IgjwFIs=;
        b=ACkiWMehxYECvEALZXRxRgT7ku8cIDi0xJCB73dmCFpicKmABsxrul2C2CA5JGt/EW
         mASiMfbVkmlbiyqdVtei/hI1rsHOg3u4SiareNjHzXRrPNbGu9mjZyHzshyQcnt0uKO8
         dbc5tux5on3w/CnU+5tcPUblapMJyImKYUX82zcppgNmRn1Z4C/8vT2/40C/nScaVffC
         OfZQnBEFWQVNV/JqwX1qHkcdwAlnrR0kP4gR20f7lKIW14y+cz4IvYu2Is5aKYspVRez
         fkZchDRzK97O36yoroOA7n712DBXMHIiWZa1lXRNu/n9OCYebmKeybDdpDvL1oonOjB5
         KXiA==
X-Forwarded-Encrypted: i=1; AJvYcCVtckGv+wiw7iH1E0IlfRak6j9W8Gc9NwtOFIFge8Bln/mxDrFS4yv5havC8dUj8QS+g5mlmt4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwD6XkKnyBh/mW7KJ8HUmem7JtoUHRPGvkunGFfcZlzV53zzL3R
	7lKbBAkXOi1+OhkMXY++1wT4th+mnIBTVmpEVa968hU6z3JT06TIezGtQEFEDdHo6qqEQ9QgqrZ
	aMCdnAQ==
X-Google-Smtp-Source: AGHT+IHVaYv0c9Xo7sfmO9HlXWVUgQ/03BKk+znZ6UuFoh4T2PuODk3nkbH2GWjiFHs5USAjAtpb3fE9ROQ=
X-Received: from pjbtc16.prod.google.com ([2002:a17:90b:5410:b0:31f:335d:342d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7ca:b0:31f:150:e045
 with SMTP id 98e67ed59e1d1-31f5de942f7mr1332792a91.32.1753829740086; Tue, 29
 Jul 2025 15:55:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:37 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-7-seanjc@google.com>
Subject: [PATCH v17 06/24] KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Fuad Tabba <tabba@google.com>

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
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 4 ++--
 arch/x86/kvm/svm/sev.c   | 4 ++--
 include/linux/kvm_host.h | 2 +-
 virt/kvm/guest_memfd.c   | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6e838cb6c9e1..fdc2824755ee 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3312,7 +3312,7 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	bool is_private = kvm_slot_can_be_private(slot) &&
+	bool is_private = kvm_slot_has_gmem(slot) &&
 			  kvm_mem_is_private(kvm, gfn);
 
 	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
@@ -4551,7 +4551,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 {
 	int max_order, r;
 
-	if (!kvm_slot_can_be_private(fault->slot)) {
+	if (!kvm_slot_has_gmem(fault->slot)) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return -EFAULT;
 	}
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2fbdebf79fbb..7744c210f947 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2365,7 +2365,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	mutex_lock(&kvm->slots_lock);
 
 	memslot = gfn_to_memslot(kvm, params.gfn_start);
-	if (!kvm_slot_can_be_private(memslot)) {
+	if (!kvm_slot_has_gmem(memslot)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -4719,7 +4719,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	}
 
 	slot = gfn_to_memslot(kvm, gfn);
-	if (!kvm_slot_can_be_private(slot)) {
+	if (!kvm_slot_has_gmem(slot)) {
 		pr_warn_ratelimited("SEV: Unexpected RMP fault, non-private slot for GPA 0x%llx\n",
 				    gpa);
 		return;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ddfb6cfe20a6..4c5e0a898652 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -615,7 +615,7 @@ struct kvm_memory_slot {
 #endif
 };
 
-static inline bool kvm_slot_can_be_private(const struct kvm_memory_slot *slot)
+static inline bool kvm_slot_has_gmem(const struct kvm_memory_slot *slot)
 {
 	return slot && (slot->flags & KVM_MEM_GUEST_MEMFD);
 }
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b2b50560e80e..a99e11b8b77f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -643,7 +643,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		return -EINVAL;
 
 	slot = gfn_to_memslot(kvm, start_gfn);
-	if (!kvm_slot_can_be_private(slot))
+	if (!kvm_slot_has_gmem(slot))
 		return -EINVAL;
 
 	file = kvm_gmem_get_file(slot);
-- 
2.50.1.552.g942d659e1b-goog

