Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811531DFDA1
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 04:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220671; cv=none; b=bf7OErM3l9dRT1D92zGR1ZVDEZYa9BqFSiVkPf66PTBrrN+Lpw2V6ljVukOlRWdGbpl9fRXdlLnZPGxUt+X7QJwDHpiCZ7vmxBannaGQaLXa0c0ZvhbBk0Kj2tvNaYyj/9vfaSzHJNK+6uKzTcfdcFbFzs89wsjKxUD8hgkTBOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220671; c=relaxed/simple;
	bh=eP46jQ+rNHU6ISgY5UQik8NONkiapiV65A0WTIlahXU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qNWCI86YGmVZPlgbrv+8rkjQZ06WhH14l450U3tZy7KI4GjwTZnDL2nF3wnH8uCrzckQOvb4g2MwO7UyJrmIcCFzU6ZA4/nkmqdxDCuBBVY/teh3/FFhRD5W2zeXp7zdaBmZ84O8VWEQA40lNqfXkZspTCOQCRMNndQhvtIX5HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=igZql5Ua; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="igZql5Ua"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-235eefe6a8fso44559005ad.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 21:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220669; x=1750825469; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lktvEP9OF/yBrtwNGnOYj58Kkb3on7duF4eax38mNfc=;
        b=igZql5UayAitCc91cElADfi3TFixQ6mEO/wIMiYxhVHftnIKWrY5XT8JUdkQlK5H7M
         u9+TyIat91Eam+jMqJo8ArEPS0ewE0vMuDgssyz60uUmTuIiGe9nC2sCT/8kE9CY/ZLX
         ipbNrq7O0NPPi4kUdIWGobAl2vFANEYKA+zscl3+1mG1vDCzDnsmIMbjSLvdcM/cmf0S
         09VX117QXqXQWmVmwIrf+16yoPFgoHRCIhS4dJ/PZh4zSZe/c4gf8WDx+hDhSh/gpqi5
         ZLAglF2EoHJEFdlBPJ93aDqntHzsYzX/8Rh1b6Sd/2IpG8RRsVYTYvA1jCdxEZkvhGxE
         0fAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220669; x=1750825469;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lktvEP9OF/yBrtwNGnOYj58Kkb3on7duF4eax38mNfc=;
        b=kgtuQmt0GX3+Q87oHH4H76iMi/Tw/mY7CtWzaMehokrhr4CbVsZds2ZGJ/r/MgHJuu
         qZ+ZK+HfHrE/5W7jo1bhnuN4pfA0hn06IPlsmrIOY72w1+A9ap+kkOKUgfyPobvjyPdm
         cde2kL50xI/72WhvcAOZIl/Gj4F86Rv8wPiZQfpFOB+3wlkfoe7oR1DhomKlUkD+wfNA
         iZfX1cghG15zCS1dHOhFO9W/l464YBKtD0tb1NlxaPQVlBI85vggRUTGEcCVDwESRM8q
         LuT0VxuujJPvUQiCYqWLd+Mj+Jtc6QikaztkZodzQzE5C0DU1AjvKXnHOwT5DXc5HCjf
         syYA==
X-Forwarded-Encrypted: i=1; AJvYcCV+8DG+FmT3CFrwUyAlCGbtleGez3fFFjoPvA1zIpoeQ0YJHqrYsh4I5Zcd0z9N/iYZ1dK3vyM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyv0/Ku67ZV3rT3xo404bEBW3iyjUAyEUrkuRWiLho+M6NnBFa3
	jDiQN7g/Ooz1OxNvnzKDlcRbvtvylKH21LBpXip6zXNkKttO9iu81sSICx7F/kRdcQkanzbIBDK
	HdGHrQRiXo7yHRIJBPHc60A==
X-Google-Smtp-Source: AGHT+IFjtADbYlxljhsDQTOZW3D7A0uJ9AI1mGomIpn2hF7RaxHZsBqEwbheSqwAOtTN5nAEPPlQmENaTESm3DrC
X-Received: from pgbck15.prod.google.com ([2002:a05:6a02:90f:b0:b2c:4bfe:fb79])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:da81:b0:234:a063:e2c1 with SMTP id d9443c01a7336-2366b17b667mr224708415ad.42.1750220668697;
 Tue, 17 Jun 2025 21:24:28 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:10 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-2-jthoughton@google.com>
Subject: [PATCH v3 01/15] KVM: x86/mmu: Move "struct kvm_page_fault"
 definition to asm/kvm_host.h
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Make "struct kvm_page_fault" globally visible via asm/kvm_host.h so that
the structure can be referenced by common KVM.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/include/asm/kvm_host.h | 68 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu/mmu_internal.h | 67 --------------------------------
 2 files changed, 67 insertions(+), 68 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b4a391929cdba..f9d3333f6d64b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -443,7 +443,73 @@ struct kvm_mmu_root_info {
 #define KVM_HAVE_MMU_RWLOCK
 
 struct kvm_mmu_page;
-struct kvm_page_fault;
+
+struct kvm_page_fault {
+	/* arguments to kvm_mmu_do_page_fault.  */
+	const gpa_t addr;
+	const u64 error_code;
+	const bool prefetch;
+
+	/* Derived from error_code.  */
+	const bool exec;
+	const bool write;
+	const bool present;
+	const bool rsvd;
+	const bool user;
+
+	/* Derived from mmu and global state.  */
+	const bool is_tdp;
+	const bool is_private;
+	const bool nx_huge_page_workaround_enabled;
+
+	/*
+	 * Whether a >4KB mapping can be created or is forbidden due to NX
+	 * hugepages.
+	 */
+	bool huge_page_disallowed;
+
+	/*
+	 * Maximum page size that can be created for this fault; input to
+	 * FNAME(fetch), direct_map() and kvm_tdp_mmu_map().
+	 */
+	u8 max_level;
+
+	/*
+	 * Page size that can be created based on the max_level and the
+	 * page size used by the host mapping.
+	 */
+	u8 req_level;
+
+	/*
+	 * Page size that will be created based on the req_level and
+	 * huge_page_disallowed.
+	 */
+	u8 goal_level;
+
+	/*
+	 * Shifted addr, or result of guest page table walk if addr is a gva. In
+	 * the case of VM where memslot's can be mapped at multiple GPA aliases
+	 * (i.e. TDX), the gfn field does not contain the bit that selects between
+	 * the aliases (i.e. the shared bit for TDX).
+	 */
+	gfn_t gfn;
+
+	/* The memslot containing gfn. May be NULL. */
+	struct kvm_memory_slot *slot;
+
+	/* Outputs of kvm_mmu_faultin_pfn().  */
+	unsigned long mmu_seq;
+	kvm_pfn_t pfn;
+	struct page *refcounted_page;
+	bool map_writable;
+
+	/*
+	 * Indicates the guest is trying to write a gfn that contains one or
+	 * more of the PTEs used to translate the write itself, i.e. the access
+	 * is changing its own translation in the guest page tables.
+	 */
+	bool write_fault_to_shadow_pgtable;
+};
 
 /*
  * x86 supports 4 paging modes (5-level 64-bit, 4-level 64-bit, 3-level 32-bit,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index db8f33e4de624..384fc4d0bfec0 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -230,73 +230,6 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
 	return READ_ONCE(nx_huge_pages) && !kvm->arch.disable_nx_huge_pages;
 }
 
-struct kvm_page_fault {
-	/* arguments to kvm_mmu_do_page_fault.  */
-	const gpa_t addr;
-	const u64 error_code;
-	const bool prefetch;
-
-	/* Derived from error_code.  */
-	const bool exec;
-	const bool write;
-	const bool present;
-	const bool rsvd;
-	const bool user;
-
-	/* Derived from mmu and global state.  */
-	const bool is_tdp;
-	const bool is_private;
-	const bool nx_huge_page_workaround_enabled;
-
-	/*
-	 * Whether a >4KB mapping can be created or is forbidden due to NX
-	 * hugepages.
-	 */
-	bool huge_page_disallowed;
-
-	/*
-	 * Maximum page size that can be created for this fault; input to
-	 * FNAME(fetch), direct_map() and kvm_tdp_mmu_map().
-	 */
-	u8 max_level;
-
-	/*
-	 * Page size that can be created based on the max_level and the
-	 * page size used by the host mapping.
-	 */
-	u8 req_level;
-
-	/*
-	 * Page size that will be created based on the req_level and
-	 * huge_page_disallowed.
-	 */
-	u8 goal_level;
-
-	/*
-	 * Shifted addr, or result of guest page table walk if addr is a gva. In
-	 * the case of VM where memslot's can be mapped at multiple GPA aliases
-	 * (i.e. TDX), the gfn field does not contain the bit that selects between
-	 * the aliases (i.e. the shared bit for TDX).
-	 */
-	gfn_t gfn;
-
-	/* The memslot containing gfn. May be NULL. */
-	struct kvm_memory_slot *slot;
-
-	/* Outputs of kvm_mmu_faultin_pfn().  */
-	unsigned long mmu_seq;
-	kvm_pfn_t pfn;
-	struct page *refcounted_page;
-	bool map_writable;
-
-	/*
-	 * Indicates the guest is trying to write a gfn that contains one or
-	 * more of the PTEs used to translate the write itself, i.e. the access
-	 * is changing its own translation in the guest page tables.
-	 */
-	bool write_fault_to_shadow_pgtable;
-};
-
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
 /*
-- 
2.50.0.rc2.692.g299adb8693-goog

