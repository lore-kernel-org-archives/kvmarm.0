Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6115237164
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 12:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753790424; cv=none; b=gy1DttHJ6eD+224qhjvZhTlU1k2KMaYD2+kFvMqhu8fpg+++GxSISrWIfH9kOGoJQ5QzoH6bH/pAg7VnZDhgjyWPbEecTxJwssnOSAQppEy15DxWpbqPAayjZN4pfcO179BlQ1qQ0Herj/7SO7KEgO9289kq3u65BDrgd38fMdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753790424; c=relaxed/simple;
	bh=i+162c6Oo8mMIAIbIXMTwClrFX4h1Ifi6UaCmDwg3lk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rcjBDQQqPp/c42DPDV2GTD6iJ2orcuQLxYg/SpqVCBVauLt3NZ4i0k58IE1Q0dCMvuuo6pwgaFN34WWTFT1NJ/qclkB1jCJwQvwS0NQItmbFKQx7B7/NQ/RnzRrOmTho2u02hp9l6KKUVfnqR0y6wUXTIYhEVH72+IPJwAx06VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H23T488x; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H23T488x"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b7865dc367so1538351f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 05:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753790420; x=1754395220; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oiFlDju6zyHaKAxwihJ7iowwkY2Ht9KG+A4iKs05oDQ=;
        b=H23T488xypWsmuuSUxJLNUndeJ5MQkOOoU/zfCxgN5gyKSwq5rPuRPpKIeXb4Q6Uo4
         Sw/0pfWmx8neiBwxxbIQ7DDkPvLFP4ytlQi4BgrQn8fw5SpWrwCDRfVYo0F5+3SODZt2
         s9W+n/42AN6tExlzSVTOeNDw1T0Ar7iMfY7QKCkdKPHFPFMCLsx5pJwjRGRy06VoJfQ5
         YpXhGWP6B2GOme/ojoJQkd+6EIfMrYoW0vxlRnJNggVC3lP2xplVwi2M2unoEqf31vZo
         Uz/GJ9NjA9y0hAabZ9Du3I9CLng32gcZuG3S+m1hq331Uhz+wNwSbyIEcClQjUKvE1Fa
         Xnng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753790420; x=1754395220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oiFlDju6zyHaKAxwihJ7iowwkY2Ht9KG+A4iKs05oDQ=;
        b=ZLNGy1LIiUA5Gf74/2Qrqoqfmb8AQXKVKPBRfyBadIFp72AiZEIFxOmLDxBDq5WfrO
         NcRcSPAEGmkjcpoyxScFnYCJTKNHd/4yWeTisMvlpAO3RsMJ7pyc7m5fU91+z6mCaMkQ
         WoaR3j7V4H/FIKU1/MswdzUe4ey5L28snimR5WG8DStpB6ZfTeqZ3oV2rJvS6hOuDqxu
         uQ5sEojSfAiyA+XAqABLDsTHsdWU2E3oRMDCviZHNXc9lL9iuomUlwbByhwpYWy41yUy
         MM8KwFMRXv5Mr9+qXk8RaEPROQkofG28z6WeMhSthcFSQE3aOQIee0xmVi64Ue9A3RE6
         TBDQ==
X-Gm-Message-State: AOJu0YyrR1zDNYZrjZONYtky/K+2yR5FrD6J/eGf9P0AfdSUMQaf/N2t
	YIJF/IxW9RyNZmeFHLW2vXr0YE93jQKQxanbl4W2egdLbXxhSiT1NK5YEF6lRvwkWlFjQDOBziu
	VY4gzfnJiG3Zb2WV9FfIbZykl4Tr04kClzbEjSjyCUSNqsgUuxGKbMPwvmfQWy08YxqFI8ct6QN
	VEGEaOzpuwr37hHLmydsvRX3yt7ntEMs8=
X-Google-Smtp-Source: AGHT+IElS4MpP08Tme30k/8QQBtYX8Ukar2Q+S9Sok/Bv77P5UW9cBGFUS/j7P9rFXKjF9pDKUkQHzmBAA==
X-Received: from wrur18.prod.google.com ([2002:a05:6000:1b92:b0:3a3:6eeb:2a27])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:26c1:b0:3b5:e714:9770
 with SMTP id ffacd0b85a97d-3b776733877mr11735997f8f.14.1753790419878; Tue, 29
 Jul 2025 05:00:19 -0700 (PDT)
Date: Tue, 29 Jul 2025 13:00:10 +0100
In-Reply-To: <20250729120014.2799359-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729120014.2799359-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.487.gc89ff58d15-goog
Message-ID: <20250729120014.2799359-6-tabba@google.com>
Subject: [PATCH v1 5/8] KVM: arm64: Separate allocation and insertion of pKVM
 VM table entries
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com, 
	keirf@google.com, smostafa@google.com, tabba@google.com
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
index 969f6b293234..ea9df0b079f1 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -192,6 +192,11 @@ static int pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
  */
 #define HANDLE_OFFSET 0x1000
 
+/*
+ * Marks a reserved but not yet used entry in the VM table.
+ */
+#define RESERVED_ENTRY ((void *) 0xa110ca7ed)
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
2.50.1.487.gc89ff58d15-goog

