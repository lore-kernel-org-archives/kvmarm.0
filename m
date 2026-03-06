Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2163AE197
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805770; cv=none; b=cmR4KQfnyaJOZF8jrZAa21ddN4lAfsk4XK4GyNMtibDPxOeB4L8cyTdiuCbDF2ljhAE47Lxq4nU00rbTAqstarcIvkwsp2fT/tv3Jn5tFm27/xc+wp5RZ7W5ba0lIriL1CdPHaeVjK6S8PzuV4EVFU/vfS49ogdHcmtTkOm4iUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805770; c=relaxed/simple;
	bh=+Ldh0+/D/HHrWGmCO9GX6+5phztxSLCN39mSxeUJJmE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gf3NOeXix1RaCXBQvjY4CMceUvuC1WhyU4f6rEgsCVq+v/W+nbSzKY9Qfg8oO4lUF04UiV3L4Im96Vuz0Tj1C4sIRS68cGnHDlobSdKvk3vc3A4KGQu5kMbYzNQ1qlrt1GGh0uqvsXYKbWjzEXGg2X25r5BIUHbfpzgKoEqoa0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jfUuLieA; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jfUuLieA"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-483101623e9so87619305e9.3
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805766; x=1773410566; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B+HYtjlbkRRsULmqIMWL6+36I9njVaiGl+dbXdeyjSs=;
        b=jfUuLieAojVEY826QgZfdAxhjHVT0HaQ7AQnXK/ENNHBTfV6sRDgw0hW/wfJD77RoJ
         /GGVbxzNcMRTfjj33EcaY7ucl1s2v+RlBNyDVzEt6IWM+tBFpBR49LWl8vPoaajbVfZV
         k/LdL/7L0CNlLW+l+PGWup4pS9p9BIkHVEKdEb5ab0DtXVSGzGaPGcKQqnaweUn57ykN
         z09RCyez5E8WaHIoE+VE0oFeL2QKmuPbN/VvR7HEWWEslagx/T8AT7kwO1Bx2WrFoguu
         5AJErIEItEnzt8U5g72PDJJcSKbMiWEsLw0OJ0OwCbbOSe/1N34uzJf4/NRz0Hc1R4Jc
         ECmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805766; x=1773410566;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B+HYtjlbkRRsULmqIMWL6+36I9njVaiGl+dbXdeyjSs=;
        b=VRqCAbafwO6huS47QOgkEbngTjBBmBA760OEAKh9y0GvcPdClJSq3Kg58luGu089F7
         PGYQWzb2kteFKgK/v9uqfXMyS9/FIxfSmsl8mtMPCyUB6EFAzftNPklpSrojVYj3XkEM
         Zy7+y19c+IlyrOzb+gLJiVtqdHG/vIEZU3z1OOhxntvRVykkNjHkjk+nTKOq+7Yy7j0x
         0tkcsM9mbSjTiHUTuGBliJm62sgNYIE3vMrB9hoPLUV/DSUgSIZ44Cus8OPtfOAxJw9B
         3SaaardZmcQy1Z9jkZJK+1G8tg1QrzVrgySEP6DWZD233QemAkfwUfWKS6HdWdVPpcQs
         QLDg==
X-Forwarded-Encrypted: i=1; AJvYcCVUmGCUCf5mTHc9VLUByTSJIuTP71BqmT/XfTHFg7Zv902ZhuGfokN4rJDf//Itx9HjkHdmt3g=@lists.linux.dev
X-Gm-Message-State: AOJu0YytQ780pVe5lCDoUJXxyQTWusQBzKam1riwtMyQNWqCbRwuoLDj
	voeLp2SAD3GcC3UWLZNWRzlUYoXj+kMXhLHVxcYhsIYYyMR0QCXjPa4QJc1uTt30R6hbOxsDG5G
	XcQ==
X-Received: from wmgb17.prod.google.com ([2002:a05:600c:1511:b0:480:6b05:6b98])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:45d1:b0:477:7c7d:d9b2
 with SMTP id 5b1f17b1804b1-4852697844emr35672325e9.32.1772805766479; Fri, 06
 Mar 2026 06:02:46 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:29 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-11-tabba@google.com>
Subject: [PATCH v1 10/13] KVM: arm64: Initialize struct kvm_s2_fault
 completely at declaration
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Simplify the initialization of struct kvm_s2_fault in user_mem_abort().

Instead of partially initializing the struct via designated initializers
and then sequentially assigning the remaining fields (like write_fault
and topup_memcache) further down the function, evaluate those
dependencies upfront.

This allows the entire struct to be fully initialized at declaration. It
also eliminates the need for the intermediate fault_data variable and
its associated fault pointer, reducing boilerplate.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 35bcacba5800..2d6e749c1756 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1962,8 +1962,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  bool fault_is_perm)
 {
-	int ret = 0;
-	struct kvm_s2_fault fault_data = {
+	bool write_fault = kvm_is_write_fault(vcpu);
+	bool logging_active = memslot_is_logging(memslot);
+	struct kvm_s2_fault fault = {
 		.vcpu = vcpu,
 		.fault_ipa = fault_ipa,
 		.nested = nested,
@@ -1971,19 +1972,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		.hva = hva,
 		.fault_is_perm = fault_is_perm,
 		.ipa = fault_ipa,
-		.logging_active = memslot_is_logging(memslot),
-		.force_pte = memslot_is_logging(memslot),
-		.s2_force_noncacheable = false,
+		.logging_active = logging_active,
+		.force_pte = logging_active,
 		.prot = KVM_PGTABLE_PROT_R,
+		.fault_granule = fault_is_perm ? kvm_vcpu_trap_get_perm_fault_granule(vcpu) : 0,
+		.write_fault = write_fault,
+		.exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu),
+		.topup_memcache = !fault_is_perm || (logging_active && write_fault),
 	};
-	struct kvm_s2_fault *fault = &fault_data;
 	void *memcache;
+	int ret;
 
-	if (fault->fault_is_perm)
-		fault->fault_granule = kvm_vcpu_trap_get_perm_fault_granule(fault->vcpu);
-	fault->write_fault = kvm_is_write_fault(fault->vcpu);
-	fault->exec_fault = kvm_vcpu_trap_is_exec_fault(fault->vcpu);
-	VM_WARN_ON_ONCE(fault->write_fault && fault->exec_fault);
+	VM_WARN_ON_ONCE(fault.write_fault && fault.exec_fault);
 
 	/*
 	 * Permission faults just need to update the existing leaf entry,
@@ -1991,9 +1991,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * only exception to this is when dirty logging is enabled at runtime
 	 * and a write fault needs to collapse a block entry into a table.
 	 */
-	fault->topup_memcache = !fault->fault_is_perm ||
-				(fault->logging_active && fault->write_fault);
-	ret = prepare_mmu_memcache(fault->vcpu, fault->topup_memcache, &memcache);
+	ret = prepare_mmu_memcache(vcpu, fault.topup_memcache, &memcache);
 	if (ret)
 		return ret;
 
@@ -2001,17 +1999,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * Let's check if we will get back a huge fault->page backed by hugetlbfs, or
 	 * get block mapping for device MMIO region.
 	 */
-	ret = kvm_s2_fault_pin_pfn(fault);
+	ret = kvm_s2_fault_pin_pfn(&fault);
 	if (ret != 1)
 		return ret;
 
-	ret = kvm_s2_fault_compute_prot(fault);
+	ret = kvm_s2_fault_compute_prot(&fault);
 	if (ret) {
-		kvm_release_page_unused(fault->page);
+		kvm_release_page_unused(fault.page);
 		return ret;
 	}
 
-	return kvm_s2_fault_map(fault, memcache);
+	return kvm_s2_fault_map(&fault, memcache);
 }
 
 /* Resolve the access fault by making the page young again. */
-- 
2.53.0.473.g4a7958ca14-goog

