Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E970380FD7
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 08:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250206; cv=none; b=MuHQHIC6qeRwKVwoCBW8VWIjhq6KWyxEhfb1H6q2GxVhJm0uOQx80xwI1CY6koVcdeJB+KDRfV6He3CiW9iGgpw3LaMsIE/fbk0C6c9/lhfr3TdouXqtnYRmicRsBGK3LGucpc0N2tdemzWKV1iVfM4Gxt8zXkOAcWpTRlSUnT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250206; c=relaxed/simple;
	bh=sKgEHRHrIjuExlmFyxj63+RjM1A+FuUlGAOoN//KO58=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pYCuupr4wjO2vtpIwnhUPyt3zFdGbNe4fBS0BdASWNfNWYklRpHiXZIZILptvPEAlSNCsuhUGB8uB/Nhjx2d0IHZbq8SF5KsxSmCyK6DOI0cMx2Mv8sHpRHmfl9CIXsGnMZO/WJlAGmxKpCaPtprV9oJlEY7sFDEoTGDInTk3FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MjdJZGZI; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MjdJZGZI"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49b7c1dcc82so3876415e9.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 01:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788250203; x=1788855003; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hdFVyI+iwmCLzmueY5nTTG6ZH9FRTD6xXO0pAOzqdmo=;
        b=MjdJZGZIz5QreGUgRAoOqDT/vgMKuOxUYYPSx2tUCXMZNtI6UfeRGuRsm8oZmwKz7D
         6M+8UknqC38Q36wJNrz1yY4Va8cVZhJaV2wOQx0tM8s2Wp4GU/2Aj9ZBHBLcMdnXvxsL
         px72xEnJ0EIoV6/nOgaDjD11AHVAi/vOYTon0zZnzjYlVDyWEodhmLDrwNDQ05hmC9s6
         t8EQ+eHILGQFoIwbxGQ7hP8F0bvfHJqDRsTHAe1JSzvOqO8fbhSxbk67NmJvExj/YKLt
         bRKSjJWa5IKQyXQicNTtZ2GgB5DKnnWjcOdQDT9NLxcYhuLcT8jqyFjO+Y7fHAPQEAfc
         bA9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250203; x=1788855003;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hdFVyI+iwmCLzmueY5nTTG6ZH9FRTD6xXO0pAOzqdmo=;
        b=lq5/f/RDuTKb3mnqVSJ2XNfdh3YNH5pbSGwSgzYm/TMnnZSO437VsHM86Dae4BdoWZ
         kSvW2B4y38pWp3ODkKHZbg8NQpvj/XYJKUroxaoxV8tI2cxlrNXPaCFrKyKMTTrbaVK8
         kg33aojdlqGt1jW1CKJoPvvSmxNnyzEexTGezsoykw9HqfOvs89H82iIiwn5jyaRIB18
         5iO+VkJZ6+rFInDiQOlbtinHyVgDYucV4srRliFHLKt4ApF8TbbW2lWElRwRqzQX4jyw
         +AJoZRGV8uwjUMhQSM1hnFuoPBFFB8UoZU18nI0tN5ZgBzn3CUw/w+RuWT2mc9zsWZly
         gzSA==
X-Forwarded-Encrypted: i=1; AHgh+Rr/GgDX8pUGHZS2apWZK1WH0oQe7juqJMCW64+bn1e5JJHe5SMMW8OKvlIt7mY63fa4GEnIWok=@lists.linux.dev
X-Gm-Message-State: AFuF++luTZnh4jCgxL4kd3b5eIctIGSP8/EGCW0E6M4hu/abNu3q02j+
	0NRaHuu2oyyAY01uXlFeXuHTgkve7T+D/CT184K5t5PxEuSqWowdyMmCqipw+z59pOxuxZUlqaH
	ScBaPaMCWoP0quDRb0jJdYA==
X-Received: from wmol4.prod.google.com ([2002:a05:600c:47c4:b0:49c:da85:4930])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:8449:b0:49b:96a0:5c00 with SMTP id 5b1f17b1804b1-49b96a05caemr444293575e9.13.1788250202692;
 Tue, 01 Sep 2026 01:10:02 -0700 (PDT)
Date: Tue,  1 Sep 2026 09:09:35 +0100
In-Reply-To: <20260901080941.997769-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260901080941.997769-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260901080941.997769-13-vdonnefort@google.com>
Subject: [PATCH v5 12/18] KVM: arm64: Move hyp_vm refcount into the structure
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for allocating hyp_vm using the pKVM heap allocator
(hyp_alloc()), move its reference count out of the page metadata
(vmemmap) and place it into the structure itself. This transition is
necessary because hyp_alloc() allows multiple small objects to share the
same physical page.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index c904647d2f76..624367d0ef5b 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -41,6 +41,7 @@ struct pkvm_hyp_vm {
 	struct kvm_pgtable pgt;
 	struct kvm_pgtable_mm_ops mm_ops;
 	struct hyp_pool pool;
+	unsigned short refcount;
 	hyp_spinlock_t lock;
 
 	/* Array of the hyp vCPU structures for this VM. */
@@ -65,6 +66,18 @@ static inline bool pkvm_hyp_vm_is_protected(struct pkvm_hyp_vm *hyp_vm)
 	return kvm_vm_is_protected(&hyp_vm->kvm);
 }
 
+static inline void pkvm_hyp_vm_ref_inc(struct pkvm_hyp_vm *hyp_vm)
+{
+	BUG_ON(hyp_vm->refcount == USHRT_MAX);
+	hyp_vm->refcount++;
+}
+
+static inline void pkvm_hyp_vm_ref_dec(struct pkvm_hyp_vm *hyp_vm)
+{
+	BUG_ON(!hyp_vm->refcount);
+	hyp_vm->refcount--;
+}
+
 void pkvm_hyp_vm_table_init(void *tbl);
 
 int __pkvm_reserve_vm(void);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 459bd9eb7e4b..0a041d41b9ea 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -278,7 +278,7 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
 	}
 
 	hyp_vcpu->loaded_hyp_vcpu = this_cpu_ptr(&loaded_hyp_vcpu);
-	hyp_page_ref_inc(hyp_virt_to_page(hyp_vm));
+	pkvm_hyp_vm_ref_inc(hyp_vm);
 unlock:
 	hyp_spin_unlock(&vm_table_lock);
 
@@ -294,7 +294,7 @@ void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	hyp_spin_lock(&vm_table_lock);
 	hyp_vcpu->loaded_hyp_vcpu = NULL;
 	__this_cpu_write(loaded_hyp_vcpu, NULL);
-	hyp_page_ref_dec(hyp_virt_to_page(hyp_vm));
+	pkvm_hyp_vm_ref_dec(hyp_vm);
 	hyp_spin_unlock(&vm_table_lock);
 }
 
@@ -311,7 +311,7 @@ struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle)
 	hyp_spin_lock(&vm_table_lock);
 	hyp_vm = get_vm_by_handle(handle);
 	if (hyp_vm)
-		hyp_page_ref_inc(hyp_virt_to_page(hyp_vm));
+		pkvm_hyp_vm_ref_inc(hyp_vm);
 	hyp_spin_unlock(&vm_table_lock);
 
 	return hyp_vm;
@@ -320,7 +320,7 @@ struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle)
 void put_pkvm_hyp_vm(struct pkvm_hyp_vm *hyp_vm)
 {
 	hyp_spin_lock(&vm_table_lock);
-	hyp_page_ref_dec(hyp_virt_to_page(hyp_vm));
+	pkvm_hyp_vm_ref_dec(hyp_vm);
 	hyp_spin_unlock(&vm_table_lock);
 }
 
@@ -979,7 +979,7 @@ static struct pkvm_hyp_vm *get_pkvm_unref_hyp_vm_locked(pkvm_handle_t handle)
 	hyp_assert_lock_held(&vm_table_lock);
 
 	hyp_vm = get_vm_by_handle(handle);
-	if (!hyp_vm || hyp_page_count(hyp_vm))
+	if (!hyp_vm || hyp_vm->refcount)
 		return NULL;
 
 	return hyp_vm;
-- 
2.55.0.897.gb25b4bd76c-goog

