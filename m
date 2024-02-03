Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907EB79C3
	for <kvmarm@lists.linux.dev>; Sat,  3 Feb 2024 00:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706918971; cv=none; b=luV4DfCkSvHfGY0CJ9ByMcD3hwDOpHqx7tWVQL1cyGw8llDN/nao5v9Srn6T0pKQnmlB3wRWtQeLlGtZdiIE1tRlAUTWgBGeiSfdXB27fwp05CfdHhWTLkvUbTU6UqTYi+ZszM4d8yK93FeKtIIJZSYJ01gwYEHXB01UxnAcGoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706918971; c=relaxed/simple;
	bh=WLkUW0/Unoe62tn0PAI8vXH8dvOJolXpQGzrHPU+8WU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rOXY9NMtUQMeB7vISyemwyqqW+InFgaCBLP1uxj270rI4FVnTM8ecYPnimxw5fj125Nj3mV+dpC2mtQMhg2/pkcBvWCvl6yWPnR0C8rfPw7u74cb6pKABQlshdF+BL1eq8NB/CL0lfO6Vfw8mIp2J8V6u3N7bf8n0XMDhFOpvpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1Wx8mrsn; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1Wx8mrsn"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b269b172so4659278276.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Feb 2024 16:09:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706918968; x=1707523768; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CwvKSfH4xv/NatBnDCESKILLStQmhSJKJagouj3ct64=;
        b=1Wx8mrsnMaNM2bcqEzwMFKl0sVBPVSwc9Cocpe1mZWRqOaJ1n3vewDpP4nI2IBpgtD
         EwNoTORmfQbEyC4QlNFIImMcki1DK0knRFMgGvao0/uENXDJYGqO1dKIi4MyeTQ7kfIe
         JxTH/05+5hytQo4gqD3gnfJasZ/jpz0r8iTPY4J6GeNVPpyXNMd2CNCnJTPYje39qIQl
         ao0lwZrimdqQL35Tn0ENzqSMZr2q8OqyM5UIBvjnHvH0Y23iSOELGCqu3gKbTsuofrPB
         ltpTzZo36ETsFS9Y0H64XhFXzP+f1HvJn9AZ6Pqhp67am+x7C2imrS0v6yGu+EwvqCzM
         Bk0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706918968; x=1707523768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CwvKSfH4xv/NatBnDCESKILLStQmhSJKJagouj3ct64=;
        b=Ae2QPdKGSa4Np8n28t9NiFNdx8wII3chhUozLBvUyJHbWABPnBpottafLHn3RuKuMp
         R5EIbWbXVrRSY61/5UJxhrgFjmzOqKBqcivShDLTmDL+mMF4GrkmFJ67QPfbGyH/iG62
         YRq6e+mZ1mx6nbU9l/01I3yGH6ZVwTj9OsYkgvP4I6Oy70dPNB8lcMlTMuNhNfq4BU1B
         ScxRm9aFuwQUm3Y6qvZTNr+eNzpvV5hDOHL3jJjL8uwZhG307AZ4FN/+U9S0cmIvOspz
         sGi1sGSsxz1HvKHF12Z6lP92yt5nMd2KJP/LpJNg00a1mRn9WwSEJlPMgr5T90NN2UdL
         6B4A==
X-Gm-Message-State: AOJu0Yz57Hl5rEUfdxxTwKxwPThxsj0jzYz8Oyby8CLmglTkgpz5Iy5A
	0o5uYmO4ura6PT6FtGh0KleM8PLV6T/3F/9VRBd3E7Tu/pXbzNgjZBFklP54jObeE0SPsx4bEjx
	Zyg==
X-Google-Smtp-Source: AGHT+IFuvqEiFXNSQKUMPqjc73s/NvoLgkLdyu0SSnFN41+IjHOkDf5OlEYBJH0O9B2BnRrsucGfLCjldz4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ce90:0:b0:dc6:deca:8122 with SMTP id
 x138-20020a25ce90000000b00dc6deca8122mr35402ybe.5.1706918968697; Fri, 02 Feb
 2024 16:09:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:09:10 -0800
In-Reply-To: <20240203000917.376631-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240203000917.376631-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203000917.376631-5-seanjc@google.com>
Subject: [PATCH v8 04/10] KVM: selftests: Add support for allocating/managing
 protected guest memory
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Peter Gonda <pgonda@google.com>

Add support for differentiating between protected (a.k.a. private, a.k.a.
encrypted) memory and normal (a.k.a. shared) memory for VMs that support
protected guest memory, e.g. x86's SEV.  Provide and manage a common
bitmap for tracking whether a given physical page resides in protected
memory, as support for protected memory isn't x86 specific, i.e. adding a
arch hook would be a net negative now, and in the future.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Originally-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 25 +++++++++++++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 22 +++++++++++++---
 2 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index d9dc31af2f96..a82149305349 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -46,6 +46,7 @@ typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
 struct userspace_mem_region {
 	struct kvm_userspace_memory_region2 region;
 	struct sparsebit *unused_phy_pages;
+	struct sparsebit *protected_phy_pages;
 	int fd;
 	off_t offset;
 	enum vm_mem_backing_src_type backing_src_type;
@@ -573,6 +574,13 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		uint64_t guest_paddr, uint32_t slot, uint64_t npages,
 		uint32_t flags, int guest_memfd_fd, uint64_t guest_memfd_offset);
 
+#ifndef vm_arch_has_protected_memory
+static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
+{
+	return false;
+}
+#endif
+
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
@@ -836,10 +844,23 @@ const char *exit_reason_str(unsigned int exit_reason);
 
 vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 			     uint32_t memslot);
-vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			      vm_paddr_t paddr_min, uint32_t memslot);
+vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+				vm_paddr_t paddr_min, uint32_t memslot,
+				bool protected);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
 
+static inline vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+					    vm_paddr_t paddr_min, uint32_t memslot)
+{
+	/*
+	 * By default, allocate memory as protected for VMs that support
+	 * protected memory, as the majority of memory for such VMs is
+	 * protected, i.e. using shared memory is effectively opt-in.
+	 */
+	return __vm_phy_pages_alloc(vm, num, paddr_min, memslot,
+				    vm_arch_has_protected_memory(vm));
+}
+
 /*
  * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
  * loads the test binary into guest memory and creates an IRQ chip (x86 only).
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a53caf81eb87..ea677aa019ef 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -717,6 +717,7 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
 
 	sparsebit_free(&region->unused_phy_pages);
+	sparsebit_free(&region->protected_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
 	if (region->fd >= 0) {
@@ -1098,6 +1099,8 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	}
 
 	region->unused_phy_pages = sparsebit_alloc();
+	if (vm_arch_has_protected_memory(vm))
+		region->protected_phy_pages = sparsebit_alloc();
 	sparsebit_set_num(region->unused_phy_pages,
 		guest_paddr >> vm->page_shift, npages);
 	region->region.slot = slot;
@@ -1924,6 +1927,10 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 			region->host_mem);
 		fprintf(stream, "%*sunused_phy_pages: ", indent + 2, "");
 		sparsebit_dump(stream, region->unused_phy_pages, 0);
+		if (region->protected_phy_pages) {
+			fprintf(stream, "%*sprotected_phy_pages: ", indent + 2, "");
+			sparsebit_dump(stream, region->protected_phy_pages, 0);
+		}
 	}
 	fprintf(stream, "%*sMapped Virtual Pages:\n", indent, "");
 	sparsebit_dump(stream, vm->vpages_mapped, indent + 2);
@@ -2025,6 +2032,7 @@ const char *exit_reason_str(unsigned int exit_reason)
  *   num - number of pages
  *   paddr_min - Physical address minimum
  *   memslot - Memory region to allocate page from
+ *   protected - True if the pages will be used as protected/private memory
  *
  * Output Args: None
  *
@@ -2036,8 +2044,9 @@ const char *exit_reason_str(unsigned int exit_reason)
  * and their base address is returned. A TEST_ASSERT failure occurs if
  * not enough pages are available at or above paddr_min.
  */
-vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			      vm_paddr_t paddr_min, uint32_t memslot)
+vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+				vm_paddr_t paddr_min, uint32_t memslot,
+				bool protected)
 {
 	struct userspace_mem_region *region;
 	sparsebit_idx_t pg, base;
@@ -2050,8 +2059,10 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 		paddr_min, vm->page_size);
 
 	region = memslot2region(vm, memslot);
+	TEST_ASSERT(!protected || region->protected_phy_pages,
+		    "Region doesn't support protected memory");
+
 	base = pg = paddr_min >> vm->page_shift;
-
 	do {
 		for (; pg < base + num; ++pg) {
 			if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
@@ -2070,8 +2081,11 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 		abort();
 	}
 
-	for (pg = base; pg < base + num; ++pg)
+	for (pg = base; pg < base + num; ++pg) {
 		sparsebit_clear(region->unused_phy_pages, pg);
+		if (protected)
+			sparsebit_set(region->protected_phy_pages, pg);
+	}
 
 	return base * vm->page_size;
 }
-- 
2.43.0.594.gd9cf4e227d-goog

