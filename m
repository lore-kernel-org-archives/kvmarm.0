Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D613264FF
	for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 08:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777020561; cv=none; b=ZEQUklrHm8eC7OrCGI6HZ4Yb+6XWNTEOo8+qcGL06QDILomui/m56R7aVQDwvkRCaMRf3wDv11EMxEWK+5XizdrC7ZjNqAq/5evFJ0k8w9hg48AGtYWrp+UUPrXiV4c90PhoY89tBq7+Wrq6g8zD3qHwGZek/k1R9urBDN6+OY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777020561; c=relaxed/simple;
	bh=BZlWZl/8o8OWASVcp9+fdkbKr43zVFREwf1BJ/L7wFs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ahk7XWdl5+PHICp6w9MJdgUNtwop5BI8rX1l4FPkbk+/sYG6ryNYg2GwZ96j/Dy9w7IheCYL7w7VhJwoLMw6l9DMjbq91qqEDjoKDf21NvDsiaSs5ELbf/aFHsxNJlZ5k8KnY881QkH9Brk/hqfxvmnK/RGWs8E4k4pT00IONLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X2aekhkM; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X2aekhkM"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48a55ecc249so29617985e9.1
        for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 01:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777020555; x=1777625355; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YXnZx3UxHBTbHH5XMnk/ieS8KZZEW34YA9EEjoorokI=;
        b=X2aekhkMou6UOGumRzDWx2WpXJJPuWpAcEwegEk1Blt/SLXgROvkdnFw5yrYLo+k1q
         miu8Zy6nHKXzYNY18t7O2amPjx4EiZ/rnF1I217wMfRRYAfgsyEc5dxT4lGbOoaKOS2B
         Og3O/n5p8bQp9oWVcfGGO19ocNxeWFY19eI7yyuYkE3lhDCd6Qv4qi6TCXFk/56/kgEc
         ssgceGpnW/hHRZzoELOIJZTcV7O4wH7QZTsX93uonhFbMiURTQp1OQdzyF5fgZ28qewq
         gsvdcQG7vPSCjZOnEyHyQG1pPWNwCKfPrrLrW47l+3kDpBbmwx9S8vQ33syW0/V3iz5x
         KYlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777020555; x=1777625355;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YXnZx3UxHBTbHH5XMnk/ieS8KZZEW34YA9EEjoorokI=;
        b=spz4zcXp6kcf7aV79jivOKAaxN6WhKYfz7ULEeVnwwzRGrr7OBqUS0EQZ6dG/tmYzK
         j1FcgurOu/O8r40jWxMrWg10sWq37LdxMpPDJBTBt/ifCIhSwp0uk+UIJbxH8xU+ZnEH
         Lzyp3gYx3I/VLjcIM4qxfQiSAe7P64nXPl7A2+vH0M0zW/7fO0Myzmq0/Yf9yrOciJys
         hKjQhG6G/DsHx9+SefO0+dwrW+Zh2xML8Tig9BAd8Ai1vm1hc1Bs1PkVB7E6OgT7ksLQ
         bseIxW60GVxybvB8XvVVgJexgld8PLqOfazvSTTNEWoQbVYzz38QEhTyDVR7aSVJi/WB
         XCaA==
X-Gm-Message-State: AOJu0Ywoba3bcIQk1XUTyyIpBSGCerKFiH1lWidSEuoiwx12UQqGxSMW
	EjbyvOSYYWNsNVd3SHZHwigc5VD9rCxErP5fOIV2CNUD0LrsmfexOJbbY2YM2F4mDvEHIHPpYRt
	MUHbNXkr1XouqKF/r+3F6WmcuhmZlxUzO3vmw62pOaFfT2MY2aezQtUsxtJS1mNMi0Jc1vYxCRK
	03pxnNmvEhG/2WCXPBoy+YclwWtZZt0So=
X-Received: from wmmu12.prod.google.com ([2002:a05:600c:cc:b0:489:1d25:1a63])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c177:b0:486:fb0b:ad79
 with SMTP id 5b1f17b1804b1-488fb78129emr400550495e9.20.1777020554656; Fri, 24
 Apr 2026 01:49:14 -0700 (PDT)
Date: Fri, 24 Apr 2026 09:49:07 +0100
In-Reply-To: <20260424084908.370776-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260424084908.370776-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424084908.370776-6-tabba@google.com>
Subject: [PATCH 5/6] KVM: arm64: Fix pin leak and publication ordering in __pkvm_init_vcpu()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Cc: tabba@google.com, catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oupton@kernel.org, qperret@google.com, suzuki.poulose@arm.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Two bugs exist in the vCPU initialisation path:

1. If a check fails after hyp_pin_shared_mem() succeeds, the cleanup
   path jumps to 'unlock' without calling unpin_host_vcpu() or
   unpin_host_sve_state(), permanently leaking pin references on the
   host vCPU and SVE state pages.

   Extract a register_hyp_vcpu() helper that performs the checks and
   the store. When register_hyp_vcpu() returns an error, call
   unpin_host_vcpu() and unpin_host_sve_state() inline before falling
   through to the existing 'unlock' label.

2. register_hyp_vcpu() publishes the new vCPU pointer into
   'hyp_vm->vcpus[]' with a bare store, allowing a concurrent caller
   of pkvm_load_hyp_vcpu() to observe a partially initialised vCPU
   object.

   Ensure the store uses smp_store_release() and the load uses
   smp_load_acquire(). While 'vm_table_lock' currently serialises the
   store and the load, these barriers ensure the reader sees the fully
   initialised 'hyp_vcpu' object even if there were a lockless path or
   if the lock's own ordering guarantees were insufficient for nested
   object initialization.

Fixes: 49af6ddb8e5c ("KVM: arm64: Add infrastructure to create and track pKVM instances at EL2")
Reported-by: Ben Simner <ben.simner@cl.cam.ac.uk>
Co-developed-by: Will Deacon <willdeacon@google.com>
Signed-off-by: Will Deacon <willdeacon@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 38 ++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 7ed96d64d611..e7496eb85628 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -266,7 +266,8 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
 	if (hyp_vm->kvm.created_vcpus <= vcpu_idx)
 		goto unlock;
 
-	hyp_vcpu = hyp_vm->vcpus[vcpu_idx];
+	/* Pairs with smp_store_release() in register_hyp_vcpu(). */
+	hyp_vcpu = smp_load_acquire(&hyp_vm->vcpus[vcpu_idx]);
 	if (!hyp_vcpu)
 		goto unlock;
 
@@ -860,12 +861,30 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
  *	     the page-aligned size of 'struct pkvm_hyp_vcpu'.
  * Return 0 on success, negative error code on failure.
  */
+static int register_hyp_vcpu(struct pkvm_hyp_vm *hyp_vm,
+			      struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	unsigned int idx = hyp_vcpu->vcpu.vcpu_idx;
+
+	if (idx >= hyp_vm->kvm.created_vcpus)
+		return -EINVAL;
+
+	if (hyp_vm->vcpus[idx])
+		return -EINVAL;
+
+	/*
+	 * Ensure the hyp_vcpu is initialised before publishing it to
+	 * the vCPU-load path via 'hyp_vm->vcpus[]'.
+	 */
+	smp_store_release(&hyp_vm->vcpus[idx], hyp_vcpu);
+	return 0;
+}
+
 int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 		     unsigned long vcpu_hva)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	struct pkvm_hyp_vm *hyp_vm;
-	unsigned int idx;
 	int ret;
 
 	hyp_vcpu = map_donated_memory(vcpu_hva, sizeof(*hyp_vcpu));
@@ -884,18 +903,11 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 	if (ret)
 		goto unlock;
 
-	idx = hyp_vcpu->vcpu.vcpu_idx;
-	if (idx >= hyp_vm->kvm.created_vcpus) {
-		ret = -EINVAL;
-		goto unlock;
+	ret = register_hyp_vcpu(hyp_vm, hyp_vcpu);
+	if (ret) {
+		unpin_host_vcpu(host_vcpu);
+		unpin_host_sve_state(hyp_vcpu);
 	}
-
-	if (hyp_vm->vcpus[idx]) {
-		ret = -EINVAL;
-		goto unlock;
-	}
-
-	hyp_vm->vcpus[idx] = hyp_vcpu;
 unlock:
 	hyp_spin_unlock(&vm_table_lock);
 
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

