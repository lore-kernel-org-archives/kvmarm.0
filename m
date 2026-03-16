Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735383CF67E
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773682538; cv=none; b=SUPfGcWeSxeMHDyHiQO8zVPv+2abYB5PCIppzx06zBYtRe/jsY38Erm9FKKH2fKgOiJbtJtq604U1mB0LCrspstTtg2Jy5DFP3Bh9Z9sT0QNrpXi5MoKb/APObKuTioONwv2X2YPbnIYw7yrKNqTiCVd/vd6AWCy1o5eauCyukI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773682538; c=relaxed/simple;
	bh=KKz9fbZcZR1mjkh27Sdq1u2YhVQ1XtsFBQXXVHQrNX0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BmlTtLYEoow+s/Rqou7Ctv79TCt/qNLYZ3Yo9mqwGAmt5urQsfZjKi6RFASWx/u2gKfuqAIyzhT5N/brPAcbJi1MT1paZUPTLmZlWN+rER9xFSUvj3hQcYrnyNVm9XnNx/83BPBykrBjIeql/znBLFRj9TFWAV5ebPfSHB3DJWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RIiezaG5; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RIiezaG5"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4853efceaddso42649645e9.3
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 10:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773682534; x=1774287334; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8OL7t7B6X78PqYAbrBfjg/doY6RGS0yWRoav+K4LS08=;
        b=RIiezaG5auJhSBKSPCtMPgY+MRXhH4IaxWUjDKnTRkCQgWprYovntx/buYKnBRkuP5
         grEb66TLjQC248Yg4mg8gnjVlnFcMcooDDycs6RZPBTbPxJmFQaOLkVf3OwSnlkLnp7x
         2EilRpQBUSzb5zyDKZW/Yq0WNZCSzpn9O9ct1wu7mLwhx2CKHRq70WYMbCGcm70j7s4H
         rfISOvW2UTiK6dKcMKpRBQaSoauWFfsG+iR//CLtcm0ZAVstTTUBqgTFB6Bc+jHNK5sw
         juYAmwaOSWMfOX/uAq9HaMHfukdhg21aTKpZ4yRJTlOcIStxW2H9GislrPZP+gDxeVgt
         ASiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773682534; x=1774287334;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8OL7t7B6X78PqYAbrBfjg/doY6RGS0yWRoav+K4LS08=;
        b=XUtO0bvRX08CL94Ez/YycW09uybsD2pzG/BFyGjPJAuxlIcuRwZKuFy3e2oIDFeZYj
         C+vfnREMm8ZGXB/y4yOLmM4o4zi2D+uOs61oYKxdILVuEOA23ROdSVPnLTWhZYRRv3Zd
         Cb1WahXHufzABRxTNUE+16yW6Osa54LlO17vYPZbvUavzFEZdbuGYt1APCOv2CM7Kv4d
         5RH4N+s9CjIuNLzJOXu+282zgSSBUGV3u5LKCpmznhXWdFBPcw+Crq/HaY6DejD8KeNE
         +4vIJTaNpq+NzhbbUlB4noftK2m+9Za8ACyIDa3TC1xx1BaA40hDkZ6fnNjC3AjDDu22
         dDyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzmsbB1eTdXUgvp87KgKHmamCYBU6ayRN5qvi1twF4GtvNzixZvkvSNKSm5XsufVGOOF+tUWo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0gDTFa/zhKYrrUML8rTECxW47aFeQ9SOinGZy4EKqVnfNgOE1
	xDvPZJUF+8rayghEGNSZluPIV/2dXsS3nLk+Dbe5/R3MOM2kYzyIdG0y1yd7L08w8GL4xC4HZ96
	DTQ==
X-Received: from wmbf24.prod.google.com ([2002:a05:600c:5958:b0:47e:e922:b080])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:45d3:b0:480:1e40:3d2
 with SMTP id 5b1f17b1804b1-48556705301mr238355675e9.29.1773682533729; Mon, 16
 Mar 2026 10:35:33 -0700 (PDT)
Date: Mon, 16 Mar 2026 17:35:26 +0000
In-Reply-To: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260316-tabba-el2_guard-v1-5-456875a2c6db@google.com>
Subject: [PATCH 05/10] KVM: arm64: Use guard(hyp_spinlock) in pkvm.c
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <linux-arm-kernel@lists.infradead.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <kvmarm@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Cc: Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="utf-8"

Migrate manual hyp_spin_lock() and hyp_spin_unlock() calls managing
the global vm_table_lock to use the guard(hyp_spinlock) macro.

This significantly cleans up validation and error paths during VM
creation and manipulation by eliminating the need for goto labels
and manual unlock procedures on early returns.

Change-Id: I894df69b3cfe053a77dd660dfb70c95640c6d70c
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 122 +++++++++++++++++------------------------
 1 file changed, 51 insertions(+), 71 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 2f029bfe4755..8f901fdead89 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -253,28 +253,23 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
 	if (__this_cpu_read(loaded_hyp_vcpu))
 		return NULL;
 
-	hyp_spin_lock(&vm_table_lock);
+	guard(hyp_spinlock)(&vm_table_lock);
 	hyp_vm = get_vm_by_handle(handle);
 	if (!hyp_vm || hyp_vm->kvm.created_vcpus <= vcpu_idx)
-		goto unlock;
+		return NULL;
 
 	hyp_vcpu = hyp_vm->vcpus[vcpu_idx];
 	if (!hyp_vcpu)
-		goto unlock;
+		return NULL;
 
 	/* Ensure vcpu isn't loaded on more than one cpu simultaneously. */
-	if (unlikely(hyp_vcpu->loaded_hyp_vcpu)) {
-		hyp_vcpu = NULL;
-		goto unlock;
-	}
+	if (unlikely(hyp_vcpu->loaded_hyp_vcpu))
+		return NULL;
 
 	hyp_vcpu->loaded_hyp_vcpu = this_cpu_ptr(&loaded_hyp_vcpu);
 	hyp_page_ref_inc(hyp_virt_to_page(hyp_vm));
-unlock:
-	hyp_spin_unlock(&vm_table_lock);
 
-	if (hyp_vcpu)
-		__this_cpu_write(loaded_hyp_vcpu, hyp_vcpu);
+	__this_cpu_write(loaded_hyp_vcpu, hyp_vcpu);
 	return hyp_vcpu;
 }
 
@@ -282,11 +277,10 @@ void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct pkvm_hyp_vm *hyp_vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
 
-	hyp_spin_lock(&vm_table_lock);
+	guard(hyp_spinlock)(&vm_table_lock);
 	hyp_vcpu->loaded_hyp_vcpu = NULL;
 	__this_cpu_write(loaded_hyp_vcpu, NULL);
 	hyp_page_ref_dec(hyp_virt_to_page(hyp_vm));
-	hyp_spin_unlock(&vm_table_lock);
 }
 
 struct pkvm_hyp_vcpu *pkvm_get_loaded_hyp_vcpu(void)
@@ -299,20 +293,18 @@ struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle)
 {
 	struct pkvm_hyp_vm *hyp_vm;
 
-	hyp_spin_lock(&vm_table_lock);
+	guard(hyp_spinlock)(&vm_table_lock);
 	hyp_vm = get_vm_by_handle(handle);
 	if (hyp_vm)
 		hyp_page_ref_inc(hyp_virt_to_page(hyp_vm));
-	hyp_spin_unlock(&vm_table_lock);
 
 	return hyp_vm;
 }
 
 void put_pkvm_hyp_vm(struct pkvm_hyp_vm *hyp_vm)
 {
-	hyp_spin_lock(&vm_table_lock);
+	guard(hyp_spinlock)(&vm_table_lock);
 	hyp_page_ref_dec(hyp_virt_to_page(hyp_vm));
-	hyp_spin_unlock(&vm_table_lock);
 }
 
 struct pkvm_hyp_vm *get_np_pkvm_hyp_vm(pkvm_handle_t handle)
@@ -613,9 +605,8 @@ static int insert_vm_table_entry(pkvm_handle_t handle,
 {
 	int ret;
 
-	hyp_spin_lock(&vm_table_lock);
+	guard(hyp_spinlock)(&vm_table_lock);
 	ret = __insert_vm_table_entry(handle, hyp_vm);
-	hyp_spin_unlock(&vm_table_lock);
 
 	return ret;
 }
@@ -692,9 +683,8 @@ int __pkvm_reserve_vm(void)
 {
 	int ret;
 
-	hyp_spin_lock(&vm_table_lock);
+	guard(hyp_spinlock)(&vm_table_lock);
 	ret = allocate_vm_table_entry();
-	hyp_spin_unlock(&vm_table_lock);
 
 	if (ret < 0)
 		return ret;
@@ -713,10 +703,9 @@ void __pkvm_unreserve_vm(pkvm_handle_t handle)
 	if (unlikely(!vm_table))
 		return;
 
-	hyp_spin_lock(&vm_table_lock);
+	guard(hyp_spinlock)(&vm_table_lock);
 	if (likely(idx < KVM_MAX_PVMS && vm_table[idx] == RESERVED_ENTRY))
 		remove_vm_table_entry(handle);
-	hyp_spin_unlock(&vm_table_lock);
 }
 
 /*
@@ -815,35 +804,35 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 	if (!hyp_vcpu)
 		return -ENOMEM;
 
-	hyp_spin_lock(&vm_table_lock);
+	scoped_guard(hyp_spinlock, &vm_table_lock) {
+		hyp_vm = get_vm_by_handle(handle);
+		if (!hyp_vm) {
+			ret = -ENOENT;
+			goto err_unmap;
+		}
 
-	hyp_vm = get_vm_by_handle(handle);
-	if (!hyp_vm) {
-		ret = -ENOENT;
-		goto unlock;
+		ret = init_pkvm_hyp_vcpu(hyp_vcpu, hyp_vm, host_vcpu);
+		if (ret)
+			goto err_unmap;
+
+		idx = hyp_vcpu->vcpu.vcpu_idx;
+		if (idx >= hyp_vm->kvm.created_vcpus) {
+			ret = -EINVAL;
+			goto err_unmap;
+		}
+
+		if (hyp_vm->vcpus[idx]) {
+			ret = -EINVAL;
+			goto err_unmap;
+		}
+
+		hyp_vm->vcpus[idx] = hyp_vcpu;
+
+		return 0;
 	}
 
-	ret = init_pkvm_hyp_vcpu(hyp_vcpu, hyp_vm, host_vcpu);
-	if (ret)
-		goto unlock;
-
-	idx = hyp_vcpu->vcpu.vcpu_idx;
-	if (idx >= hyp_vm->kvm.created_vcpus) {
-		ret = -EINVAL;
-		goto unlock;
-	}
-
-	if (hyp_vm->vcpus[idx]) {
-		ret = -EINVAL;
-		goto unlock;
-	}
-
-	hyp_vm->vcpus[idx] = hyp_vcpu;
-unlock:
-	hyp_spin_unlock(&vm_table_lock);
-
-	if (ret)
-		unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
+err_unmap:
+	unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
 	return ret;
 }
 
@@ -866,27 +855,22 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
 	struct kvm *host_kvm;
 	unsigned int idx;
 	size_t vm_size;
-	int err;
 
-	hyp_spin_lock(&vm_table_lock);
-	hyp_vm = get_vm_by_handle(handle);
-	if (!hyp_vm) {
-		err = -ENOENT;
-		goto err_unlock;
+	scoped_guard(hyp_spinlock, &vm_table_lock) {
+		hyp_vm = get_vm_by_handle(handle);
+		if (!hyp_vm)
+			return -ENOENT;
+
+		if (WARN_ON(hyp_page_count(hyp_vm)))
+			return -EBUSY;
+
+		host_kvm = hyp_vm->host_kvm;
+
+		/* Ensure the VMID is clean before it can be reallocated */
+		__kvm_tlb_flush_vmid(&hyp_vm->kvm.arch.mmu);
+		remove_vm_table_entry(handle);
 	}
 
-	if (WARN_ON(hyp_page_count(hyp_vm))) {
-		err = -EBUSY;
-		goto err_unlock;
-	}
-
-	host_kvm = hyp_vm->host_kvm;
-
-	/* Ensure the VMID is clean before it can be reallocated */
-	__kvm_tlb_flush_vmid(&hyp_vm->kvm.arch.mmu);
-	remove_vm_table_entry(handle);
-	hyp_spin_unlock(&vm_table_lock);
-
 	/* Reclaim guest pages (including page-table pages) */
 	mc = &host_kvm->arch.pkvm.teardown_mc;
 	stage2_mc = &host_kvm->arch.pkvm.stage2_teardown_mc;
@@ -917,8 +901,4 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
 	teardown_donated_memory(mc, hyp_vm, vm_size);
 	hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
 	return 0;
-
-err_unlock:
-	hyp_spin_unlock(&vm_table_lock);
-	return err;
 }

-- 
2.53.0.851.ga537e3e6e9-goog

