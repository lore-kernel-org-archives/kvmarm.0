Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE4C2FB093
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 07:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757402687; cv=none; b=CA695OXmIfhCo84giYBagOCCoOw4ll2rTX963Y2cd72R66Ch58WU2QIcTfdH+DaJOh+PWqGXwNndywSKKcunRzCysew1uy0cVJHpP/ND+kVJu+wBOPOwRlt+3ENOFUW3E1q62tWydKdAMKDFeHVAalE3EsesfwBtGB31qrNkGJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757402687; c=relaxed/simple;
	bh=fGOOQa2CrVeIt/bnLsZAHUHbzVMy9YqZzR8wBqGgcfo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=koxiSwKSqroZtBATQjow5brSoTK2GjCwacRGrx5osVn2vVhOKxymIA3gcDg6deZmCWHaX9YCwPa2l7d9W0aKrPAVRm2KsNVrgPK1vNT4OZyFwATVQCpXyJCFiu7Y5/ZW5Qp7iV7inX1tSq0ptfgC3dZbHZSha2RCnvf2sS+YEkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U1aSEDXc; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U1aSEDXc"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b043abc86fdso419223566b.3
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 00:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757402683; x=1758007483; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HBlatNZogSVtHgRUtoqflxLkmp73EbTbckKY3UHYcxQ=;
        b=U1aSEDXcITo1unLnk/xrD3CDrx2UvN+LZzhzbD83qhccrlfyrZuMBQsmCysdtp8Hhz
         UXMGJDTvgyeJ/7ZNFck8xYPH3RaRmasBGTQSO4qrn7klS6dZt0o1KqCOdbaLeDPZJ6W5
         foadxG0yWAE3nd6rJeD6a4Z28jpY8P74mmtjDhgo8d3Ur0WdQsmqPP37Z28cn6zrcLn3
         8It+1MVH2k+HiWsHqmFgYFWEmd+Zl9MlHZR0d0c2BMkhIHUXs6P/ACVjjk5tCnjxY2km
         6HmF/YD9XRcit/+4oQkRorapwaA/sYz6qslU20+vb9I/WVDGgwC6D+amWjj2Gkf+qAlL
         37EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757402683; x=1758007483;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HBlatNZogSVtHgRUtoqflxLkmp73EbTbckKY3UHYcxQ=;
        b=iSeM5sdFjfKlR7ec9R8TGxXKg1bI/t934YwgaN6ULX0S142yrtpc7Id+tXurh5zOgl
         /51hsbi2n3pv3zwh8RC+WtuIh3SAxNmtsj/CTAav31mai3CDfqAy7WZ0AQf9iiHn3Tkz
         14xvpeQBMixv+whg83uJ3yX8lDc70vMzyZf7jFyleNAU6fNHh0c1rCo9czlwUEHPZYPf
         1us8uTgiVR7KPjHyWojmV5UQZbj8VKTV0pXSqz7vNz/GEm7hOE5w9wtdMPvAC6TbFaPH
         xcZJzCsA0PGXt5MlhjAZ6l0jJG7mLYIxtjM8LJsLqvXMa0OLLnQSKxkqhOHuZjR+/rh9
         F4yg==
X-Gm-Message-State: AOJu0YzmEzFvtbvPkY4ovf74gOj4j3xBejD/idVxN/I5fx9sKi3bsUaj
	5vej3HOfeM8b6jSEvj9NbYqViuCpmiJU+QxTZmy6fGckDUMlq/tkPXYT4Qpd0Ez/I5P71TEOpyq
	habsmPcI7eYUkjrpVJVTvxZ8xr/EZqlCERq1gpRY3YhKMKv5Q00QihA/4RCT+685FL38VibqGCt
	ISrnr5EG26+L2aSqUdIAy55B6ib0L+YQA=
X-Google-Smtp-Source: AGHT+IET6bM6myhOi9tNma3d70x70a1N88PiYCS8MHYHbKBvpAalmvpkEEEA/7N6Lbh2UFnO+rE1yFkjDA==
X-Received: from ejcty8.prod.google.com ([2002:a17:907:c708:b0:b03:84d5:ce15])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:26c7:b0:b04:33a1:7f14
 with SMTP id a640c23a62f3a-b04b1666d4fmr971382466b.35.1757402683174; Tue, 09
 Sep 2025 00:24:43 -0700 (PDT)
Date: Tue,  9 Sep 2025 08:24:33 +0100
In-Reply-To: <20250909072437.4110547-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250909072437.4110547-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909072437.4110547-7-tabba@google.com>
Subject: [PATCH v4 6/9] KVM: arm64: Separate allocation and insertion of pKVM
 VM table entries
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, vdonnefort@google.com, 
	qperret@google.com, sebastianene@google.com, keirf@google.com, 
	smostafa@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The current insert_vm_table_entry() function performs two actions at
once: it finds a free slot in the pKVM VM table and populates it with
the pkvm_hyp_vm pointer.

Refactor this function as a preparatory step for future work that will
require reserving a VM slot and its corresponding handle earlier in the
VM lifecycle, before the pkvm_hyp_vm structure is initialized and ready
to be inserted.

Split the function into a two-phase process:

- A new allocate_vm_table_entry() function finds an empty slot, marks it
  as reserved with a RESERVED_ENTRY placeholder, and returns a handle
  derived from the slot's index.

- The insert_vm_table_entry() function is repurposed to take the handle,
  validate that the corresponding slot is in the reserved state, and
  then populate it with the pkvm_hyp_vm pointer.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 52 ++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 969f6b293234..64b760d30d05 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -192,6 +192,11 @@ static int pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
  */
 #define HANDLE_OFFSET 0x1000
 
+/*
+ * Marks a reserved but not yet used entry in the VM table.
+ */
+#define RESERVED_ENTRY ((void *)0xa110ca7ed)
+
 static unsigned int vm_handle_to_idx(pkvm_handle_t handle)
 {
 	return handle - HANDLE_OFFSET;
@@ -231,6 +236,10 @@ static struct pkvm_hyp_vm *get_vm_by_handle(pkvm_handle_t handle)
 	if (unlikely(idx >= KVM_MAX_PVMS))
 		return NULL;
 
+	/* A reserved entry doesn't represent an initialized VM. */
+	if (unlikely(vm_table[idx] == RESERVED_ENTRY))
+		return NULL;
+
 	return vm_table[idx];
 }
 
@@ -481,7 +490,7 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 	return ret;
 }
 
-static int find_free_vm_table_entry(struct kvm *host_kvm)
+static int find_free_vm_table_entry(void)
 {
 	int i;
 
@@ -494,15 +503,13 @@ static int find_free_vm_table_entry(struct kvm *host_kvm)
 }
 
 /*
- * Allocate a VM table entry and insert a pointer to the new vm.
+ * Reserve a VM table entry.
  *
  * Return a unique handle to the VM on success,
  * negative error code on failure.
  */
-static pkvm_handle_t insert_vm_table_entry(struct kvm *host_kvm,
-					   struct pkvm_hyp_vm *hyp_vm)
+static int allocate_vm_table_entry(void)
 {
-	struct kvm_s2_mmu *mmu = &hyp_vm->kvm.arch.mmu;
 	int idx;
 
 	hyp_assert_lock_held(&vm_table_lock);
@@ -515,10 +522,30 @@ static pkvm_handle_t insert_vm_table_entry(struct kvm *host_kvm,
 	if (unlikely(!vm_table))
 		return -EINVAL;
 
-	idx = find_free_vm_table_entry(host_kvm);
-	if (idx < 0)
+	idx = find_free_vm_table_entry();
+	if (unlikely(idx < 0))
 		return idx;
 
+	vm_table[idx] = RESERVED_ENTRY;
+
+	return idx;
+}
+
+/*
+ * Insert a pointer to the new VM into the VM table.
+ *
+ * Return 0 on success, or negative error code on failure.
+ */
+static int insert_vm_table_entry(struct kvm *host_kvm,
+				 struct pkvm_hyp_vm *hyp_vm,
+				 pkvm_handle_t handle)
+{
+	struct kvm_s2_mmu *mmu = &hyp_vm->kvm.arch.mmu;
+	unsigned int idx;
+
+	hyp_assert_lock_held(&vm_table_lock);
+
+	idx = vm_handle_to_idx(handle);
 	hyp_vm->kvm.arch.pkvm.handle = idx_to_vm_handle(idx);
 
 	/* VMID 0 is reserved for the host */
@@ -528,7 +555,7 @@ static pkvm_handle_t insert_vm_table_entry(struct kvm *host_kvm,
 	mmu->pgt = &hyp_vm->pgt;
 
 	vm_table[idx] = hyp_vm;
-	return hyp_vm->kvm.arch.pkvm.handle;
+	return 0;
 }
 
 /*
@@ -614,6 +641,7 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 	struct pkvm_hyp_vm *hyp_vm = NULL;
 	size_t vm_size, pgd_size;
 	unsigned int nr_vcpus;
+	pkvm_handle_t handle;
 	void *pgd = NULL;
 	int ret;
 
@@ -643,10 +671,16 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 	init_pkvm_hyp_vm(host_kvm, hyp_vm, nr_vcpus);
 
 	hyp_spin_lock(&vm_table_lock);
-	ret = insert_vm_table_entry(host_kvm, hyp_vm);
+	ret = allocate_vm_table_entry();
 	if (ret < 0)
 		goto err_unlock;
 
+	handle = idx_to_vm_handle(ret);
+
+	ret = insert_vm_table_entry(host_kvm, hyp_vm, handle);
+	if (ret)
+		goto err_unlock;
+
 	ret = kvm_guest_prepare_stage2(hyp_vm, pgd);
 	if (ret)
 		goto err_remove_vm_table_entry;
-- 
2.51.0.384.g4c02a37b29-goog

