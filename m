Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830261F4C96
	for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 10:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754907597; cv=none; b=OMukBkgQ0VVEBvAfq4MH7B8tJtwuMHtVfri32fDsPZsrY+uK4XI1Wab92B3Rz1CioWWL1CXLXyjDubGvE0A21L7auzSD8zmD83jqST61XLTwnTTFVBxNFWW/mTYyI92brVz153IUyEY+YBLfffGIuXrJNvYe4kicyvvVoo6LIuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754907597; c=relaxed/simple;
	bh=euhmJ1r2ECRr0/oxDZ5vqvNb0/kdYRnEoKh3l8n6bIw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CClk08lsZloTJ3crADNuin3H1k32mmWTslXhFRyqNL6s+57Myxy78hB08QHsCeNgW3ppUOqyCvPMm4xA62ta+uPGsMwYT2i71EV4S54ZLYsv8xGAVbxe5P5jV56dUJyBIWjiuNskNFdVBgeXVBWawxYuYtoPmBmDTA/JrREHiqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QI1JCnmb; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QI1JCnmb"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b7882c0992so2365148f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 03:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754907594; x=1755512394; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u9urlrOuwfpYC0uyUnrnH4VyPXMAyZOw1Pz1r7m6n6Q=;
        b=QI1JCnmbEKZaCLkFUSEAtxSXlo8qxnQ88MPlL5TNPM8LdxVsWBvxDtnIpQFE9CBZUA
         9Ug0x8UQBLH3D37UgzRAg2bdoOoh52yYKanRdnafN43qTYpPzaIvdbDV+/Q2qd4eEM5s
         9M8/zxFWD3vizTEJZmKnFNdJH92IEXCHyv6UnOMJ5vYZT7AX+LyAX3CDZ9Kvj9FH04Bc
         X8hFKX1F6tNPmocjuIc6vagcgK8ES6QNe7F8LJY+ASTbxpLcrfbG/LnvjLK3iNvnC9Ci
         raOodYT8GtE5FGmXfUkIZwh+SQs90/jegCRhgD3YYRNNMjecqZkDE5QZD6SIQ+F7tzPn
         V+gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754907594; x=1755512394;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u9urlrOuwfpYC0uyUnrnH4VyPXMAyZOw1Pz1r7m6n6Q=;
        b=pse7K5qrWA1UzubeTvowL7tkcOOHdbE+lb1ONJzKHPI7A4mAecXwxD/Lt7pYXK/YFI
         ZvBV/YF5OLWz8hUOOU0KVaWWyDAsxGICjdpyMRbDh+0Ydwc//Rq+al1d9q0mmohPcwZR
         PEPBshx2Fv7CbZYkh7DQF/cYb+2WWColEEsCgyUgxV6Fo8b90aCJGHRiH7AWJia5u61N
         dcGqUX+A2yCrsqIShyAV23biOhgue8YyXoKp31Y+TK1bCJ0hVH49gmtMYr3VJN0l4Rc/
         oRHdgg1XB3UiWvh9tpBCeZGerLvFL5WV3Isknz+7LkFmmwYulvv8hqnxyEZ28HKmULz7
         0ugQ==
X-Gm-Message-State: AOJu0Yx7yH1evHmNytm18+tZ77fYxk0xcoRj6r8iZx++xo9YI3ndAD8f
	1W85ncJlFRQOmtePGGNJolXJVerJQu3vMZKyjL6wklL8h0TKmb7Vi2y0idarf9fzJmC5EHKqoe1
	eQiX93s0t6E45wz3Uw7rDZkaQQpcSNVanmV4kftAR8LZqZy103tMyyQI2sH2iHY3zBFdU/aaIPy
	W5+LeQpXYJEutekDBXDA/fvES1ewkBLsA=
X-Google-Smtp-Source: AGHT+IH03m51ayBE816Ub3cJXS+vuPgcGnbPU+wOh2WUf7Ykyc1/ideNfZdtPCPyixIk+LVkRO+tDsAjxw==
X-Received: from wrou4.prod.google.com ([2002:adf:ed44:0:b0:3b8:d821:9ad7])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:18aa:b0:3a5:2257:17b4
 with SMTP id ffacd0b85a97d-3b900b6a291mr10236647f8f.55.1754907593528; Mon, 11
 Aug 2025 03:19:53 -0700 (PDT)
Date: Mon, 11 Aug 2025 11:19:44 +0100
In-Reply-To: <20250811101947.3637632-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250811101947.3637632-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
Message-ID: <20250811101947.3637632-6-tabba@google.com>
Subject: [PATCH v2 5/8] KVM: arm64: Separate allocation and insertion of pKVM
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
2.50.1.703.g449372360f-goog

