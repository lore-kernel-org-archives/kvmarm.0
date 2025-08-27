Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CD62F1FE6
	for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 10:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756290001; cv=none; b=YqbDGYL3S83PsniPQV3R8OhJHphs6xXaXdpp2JQ1AS1eTxmkScMJAu21nYxGnnE4MK/ocnAMqN++xkYrSE/1Uu9D2d5zNd877fL/H6LZxMBFASHGwEsfWa9wFVMw+csa69ojaHNBrmjTZKEOsvUghZYq88RkIGXCsSuSO/be0Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756290001; c=relaxed/simple;
	bh=q8bUXZSvv7ABBMSBh5oS+mDiShF4Cv9QWg19/5hjB5Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jjwKirK3PekYqQ/P/iKcB8mZhm/eEvB/m+4NZiGA1OeOvet+3OZjk/iYCnvO4TSruU87rxiyMbioxgoft2Z3FXjbpoFfDYDQu/8hgUffJr2w3GlqJVIqPfuR+W+WQezmMR21Y+6OZFnwC9aUJcLmsEoirWgufrp65/4PhAuI1ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wz3FWGNr; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wz3FWGNr"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45a1b0b2b5cso47720365e9.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 03:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756289998; x=1756894798; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=15IbCh6FREymugCSrCisKigz25x9k3php32v0CEPWCQ=;
        b=Wz3FWGNrbOQgz5TRekozznyOW3171/Ur4OldcDCqAvaE1q3wXrMpciAW8cDMrRS1AB
         IXSg06f8uQJCtYXiGCpe4sKfZT6TKNLSnrJh+4TzPMkZ1sd83H6gGxOkN8i5805IRqa0
         Vlfz91uKGkn/5X7uPpeuR9rvngKmkx4/R+qzTPfkaELeVKxwR88ZS56cgzMn73Rt94AC
         94kaFPL8nigfHn9ONkuq5lan5dFTMqydLR8+xUDGzqdIdhuJ7hlTENiwynjO8k4fDeqw
         2BDCS3bQfd14prRmUNs9w9JKcgR/Az8YpOwOMd86dq7cv+op6WZjNDj5aXeV/4cV8B7t
         sv6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756289998; x=1756894798;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=15IbCh6FREymugCSrCisKigz25x9k3php32v0CEPWCQ=;
        b=T9bTGksGbgvhejIsYv8nIbdpSCSV+Dfa1LUAXeeZHtp6FdiWEXcQdn28GTNIPL77NX
         AYxPJAOTA8+SEAnF6b5Feq/sp5kHfTymJNXP3eAfWMzz8JXx0vkm59VzlehUpsLjoJ3U
         +Vm36HZzzu2ZSmgdsQH98TNSqcmLF+Tiv4mPmw9WsVv9NVc2m+2V4vPTCGJRQFP0Htww
         3lmCvIX/XSsMEEAkB+DtUKORcF3gpFoXt/DiNprFWrhOotEd64OnDjd4InM5TG9qkS8I
         MKIIuoIWWokuGWc+hPglbBUbxXwwMPDClJUXhKDkIPVsfB7IW+2KAmXuD+vYewGsRCeX
         t4cA==
X-Gm-Message-State: AOJu0YyIiuIUT5tOUzpLEB3i8zKSkJgJWixj/ddZawtF7j3ix/BNvFXQ
	6SYsiPSsD8rBeZCcppcTWQ4UwgG+xcGcCIfvkOQ+y/ll/dBRKkb2DAncWSUoGgaMIhXbGU+WFwe
	LcKbM7TL9tjGNjxcxJImKkGStOXs5uM0lBCG9AMQYvtGDyBcq3xzM4aJxSOZY13SG0uCBLQd1Um
	ihgef9ps8zrYTGxCQ0P56PZL1kdqjrEo0=
X-Google-Smtp-Source: AGHT+IEGZata72ejku0XcOfHTx/eRZ6xhDAnGZ/fNxAG576+6GwC+qli/4vpwJCFJBj4nB3I6znBURvILA==
X-Received: from wmbgz9-n2.prod.google.com ([2002:a05:600c:8889:20b0:45b:6fb3:665a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c48e:b0:45b:5f3d:aa3d
 with SMTP id 5b1f17b1804b1-45b5f6bde93mr79943025e9.21.1756289998235; Wed, 27
 Aug 2025 03:19:58 -0700 (PDT)
Date: Wed, 27 Aug 2025 11:19:46 +0100
In-Reply-To: <20250827101949.4089456-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250827101949.4089456-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250827101949.4089456-7-tabba@google.com>
Subject: [PATCH v3 6/9] KVM: arm64: Separate allocation and insertion of pKVM
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
2.51.0.261.g7ce5a0a67e-goog

