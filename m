Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BC716F271
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 11:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741951125; cv=none; b=jtNoSEGppS140BcD/ZQhkQSR5Hbs7TWS62/qeuP925mtZraQ+A9CFZsrT8FRXMQ3LR46vgigCAVxbTwbFZBdSIbReeul1Vyaw1PmE+A6xk3KR7dr/xdcU+Nw3x+R2/jp9/ZHe8vKp/0/oYaqwO5FKVRQTIeAlP01JfASgfFz7wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741951125; c=relaxed/simple;
	bh=dlFxEMdx0w00/mcwTXAC1P1mNfUKXREVd1TmVvntzbU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ElcWww5BYMvPFP0skECUOyMrh+IIgoU9IBq4KxyC6w3KniGIT0NZnPtSucz2dNMnlJx7MrKg61MeSqSm21bXeMvWegJO0AJcl86vsRdpcLZ508MLRlpgskdMKVo26Rqorez8J8F33YIq2tNTE/TixViW0z9ZS7PFIqwm2EErpOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AwFcmpzu; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AwFcmpzu"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-438da39bb69so15428505e9.0
        for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 04:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741951122; x=1742555922; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=82vwVg0CBFLxNk1y97bWD8aRM0sls0IM+3B5nN7emI4=;
        b=AwFcmpzu3zm5PBgkAl9iExV9x3eoan2Gk8pvAwH4wRWVSILp1KZ982DCaZj+rGTlUQ
         6ui8dC3OvrVadGvI/fKEgvq21rohX8h01+GRsfrva/l0FZh4P2wKKrcgpASq0nxV4FeW
         tNootDpQkesk0hh4c5UGy5J8IWb1NjK+HX7YcYpFF5X7Of/MM1t6OXLn6KBh5XAwiEPr
         jhA5UXdAm2RvU8rOqoqk3+BV337vOaFSYeYJXPeEg7+YgxDb7oa5ewBQE9YCvR5nwT9Q
         tFL/U5PbJmZ83881870KKtNVNBKOyXHO/iph1hTCC3AsB6bZuTi84eEIszXCFmNHA0DC
         6TvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741951122; x=1742555922;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=82vwVg0CBFLxNk1y97bWD8aRM0sls0IM+3B5nN7emI4=;
        b=joV70Lyl/US24lADFN3MY809qTKSkWsTUlEvfgK231TQISSwECTZJ2cXaXtZxH92Cp
         WTyGmIdXsqYtlITl5c2zcmVWr/3vtXBJgBP5uKGhKUxaJLoHvC0C2tIjBimWbIRMHvEQ
         fAPsNXRIIe1qKMoezmOWYANyXZKLC9kjyLJXYmj82qxeg2YXLtD6kLeVY03rlprW/6aM
         EY1PBGCWm1hB1ZoCohx+fu/2JtnF83D4g2IbhWQ7xcT9+KKRgjcOm18e2zlk98MRTOP/
         1xQ5XZZC2Poh/Wp5YZAGMZKObFkwoX77Q2RarDnQdbzFelJYzZLuOllyou9emPMMZn9X
         +91A==
X-Gm-Message-State: AOJu0YyfUhK5kljGqjyHCvJBUZSb70bz68HR5cp8VuS8jZVeg3qGC8t2
	emLlT/dxFFm8gxD9LLF8MS++ofrg8SJSbDZ+tOG8amBjoHaOP8h2MsRDtzfZqWlQE0Cv1ShPLKk
	HnDs5n+Ppj6CchulIPnfbWL95nqBYMS4OP8V7uC64SnUdHU44o10LyhFthXk3dMqBej/e3SQ1Ga
	+WOVyjK32MO6VtkHExthpchKVcRx4=
X-Google-Smtp-Source: AGHT+IFgy0IRKYEui6JFldvaggSnbklu2RRtgsoq5WhXW+8cqly4bSvIDl1pRV1tvV13ltYjlwnhY564FA==
X-Received: from wmbep16.prod.google.com ([2002:a05:600c:8410:b0:43c:f122:1874])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600d:e:b0:43c:ec28:d303
 with SMTP id 5b1f17b1804b1-43d1f0a4287mr27609165e9.5.1741951122171; Fri, 14
 Mar 2025 04:18:42 -0700 (PDT)
Date: Fri, 14 Mar 2025 11:18:31 +0000
In-Reply-To: <20250314111832.4137161-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250314111832.4137161-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250314111832.4137161-4-tabba@google.com>
Subject: [PATCH v3 3/4] KVM: arm64: Factor out pKVM hyp vcpu creation to
 separate function
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, mark.rutland@arm.com, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Move the code that creates and initializes the hyp view of a vcpu
in pKVM to its own function. This is meant to make the transition
to initializing every vcpu individually clearer.

Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pkvm.c | 48 ++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 930b677eb9b0..74cf5d87e77b 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -113,6 +113,24 @@ static void __pkvm_destroy_hyp_vm(struct kvm *host_kvm)
 	free_hyp_memcache(&host_kvm->arch.pkvm.teardown_mc);
 }
 
+static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
+{
+	size_t hyp_vcpu_sz = PAGE_ALIGN(PKVM_HYP_VCPU_SIZE);
+	pkvm_handle_t handle = vcpu->kvm->arch.pkvm.handle;
+	void *hyp_vcpu;
+	int ret;
+
+	hyp_vcpu = alloc_pages_exact(hyp_vcpu_sz, GFP_KERNEL_ACCOUNT);
+	if (!hyp_vcpu)
+		return -ENOMEM;
+
+	ret = kvm_call_hyp_nvhe(__pkvm_init_vcpu, handle, vcpu, hyp_vcpu);
+	if (ret)
+		free_pages_exact(hyp_vcpu, hyp_vcpu_sz);
+
+	return ret;
+}
+
 /*
  * Allocates and donates memory for hypervisor VM structs at EL2.
  *
@@ -125,9 +143,8 @@ static void __pkvm_destroy_hyp_vm(struct kvm *host_kvm)
  */
 static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
 {
-	size_t pgd_sz, hyp_vm_sz, hyp_vcpu_sz;
+	size_t pgd_sz, hyp_vm_sz;
 	struct kvm_vcpu *host_vcpu;
-	pkvm_handle_t handle;
 	void *pgd, *hyp_vm;
 	unsigned long idx;
 	int ret;
@@ -161,33 +178,12 @@ static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
 	if (ret < 0)
 		goto free_vm;
 
-	handle = ret;
+	host_kvm->arch.pkvm.handle = ret;
 
-	host_kvm->arch.pkvm.handle = handle;
-
-	/* Donate memory for the vcpus at hyp and initialize it. */
-	hyp_vcpu_sz = PAGE_ALIGN(PKVM_HYP_VCPU_SIZE);
 	kvm_for_each_vcpu(idx, host_vcpu, host_kvm) {
-		void *hyp_vcpu;
-
-		/* Indexing of the vcpus to be sequential starting at 0. */
-		if (WARN_ON(host_vcpu->vcpu_idx != idx)) {
-			ret = -EINVAL;
-			goto destroy_vm;
-		}
-
-		hyp_vcpu = alloc_pages_exact(hyp_vcpu_sz, GFP_KERNEL_ACCOUNT);
-		if (!hyp_vcpu) {
-			ret = -ENOMEM;
-			goto destroy_vm;
-		}
-
-		ret = kvm_call_hyp_nvhe(__pkvm_init_vcpu, handle, host_vcpu,
-					hyp_vcpu);
-		if (ret) {
-			free_pages_exact(hyp_vcpu, hyp_vcpu_sz);
+		ret = __pkvm_create_hyp_vcpu(host_vcpu);
+		if (ret)
 			goto destroy_vm;
-		}
 	}
 
 	return 0;
-- 
2.49.0.rc1.451.g8f38331e32-goog

