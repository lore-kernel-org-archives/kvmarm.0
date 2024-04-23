Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD43B12EBE7
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884785; cv=none; b=OgbnbTCUyZiZgY+4VcZchdCHS9K+LLqk6B7dQZM9hZ96o+UVoN7j0or5Arlk4ny96b66+mzd5Z3F8iy+jCRDWQpXj362GACpXQ2sWyjALMgAJpaal5Q7QaMVWY2P06mVgsoKwCG+krXTzKanin1p5Z9tS/nTB3axyROsVZkw6X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884785; c=relaxed/simple;
	bh=1/WkX9FO1Xh/fYHjgZW5hJ8mme+q34WTIxwU2wX1A50=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DKp/a5GODdKGvpYGbjecqBsZzoY/SxS8JBdVDOYYtUJRlOJX2X3zfb0Q7IHXKzV9T1ea16fDB252jDsZOLclqi+bBgTOoGe0o0pcbCOp9EB/qBpGwuuHMB0mqNUqyKU9GpRYJyGXBi4s1iYQkg4egVcYwmm2UaFIYoRGPxQLW1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NbpJwBvz; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NbpJwBvz"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-349d779625eso4693207f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884782; x=1714489582; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xYBBjxyJ84ImgYN/xZ9lSGq3tk1iYO6c8fieKtq9YN8=;
        b=NbpJwBvz4dmEe0BKYUqROGCpckLfsqJy7IkHlK57YtHmTIPAGfc1jLTxesqLKs8Q5B
         YyregshjwDwdediVeqtT9SUkoG873a/C0Ts8YgW34ZPrjlpZde4Om19bsx9M31iNfUwB
         E7GBiB81IMGtwxHOr1gG5rCqmBh73+9wnGU+vva0MFs15i6CiuOM523zA14Uze9JH33J
         JcD3KsRrcG1hyr/fFjl4rxAuhbLdQ/1k76oWYzlWMCG5zU7eHyl/CXomHAQ2N3yJyqL9
         9zP6oRRTn3WDW0Bjfc5UKg+ffBRGB29/r1SrDW1pgE/Sjx+Iw0ad+U4IYiCcsk8GEb1X
         2low==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884782; x=1714489582;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xYBBjxyJ84ImgYN/xZ9lSGq3tk1iYO6c8fieKtq9YN8=;
        b=QVQJfdSc8bHQoDGKBFvTuDD0cG83mKfq08F4IQUOY6PQR22rsVSDPA+nh1VtmOnuPH
         eNTKFNd1yp88/vvITxz1CasQ9Dvw2ca7NqSRy11U52Xvd73Z/6KsNN0EBGUuwtaXmxOx
         Lqc8kDZqJ3VNZFgOX87VjSbTRcEpCRVpGN3L+gWNoGNKpvvgAyND3G+LEDrqV6oIu2SG
         Oww9xtX2SvJKiUbL4wtgAF1nxKT52m3/5NoVQNQb6ojC1V+kZ71JWkca407ASKTnASRw
         PmCNZyUwXt9ZlZsAMcx8c2v+njXWfBPTL3pSgNcGjQO8NZf+IpTIHbIUp2qtrGuFxPJQ
         buZA==
X-Gm-Message-State: AOJu0Yy8qbHDnHMAS5tcdVi4r84lmxpn8CE4eW2BxxtJIfWFIlhE4CmZ
	iJ7ySp/g0/dLbgDt9IVnrdYnsFBN9JSC0F0Cat3jYoI1SuEDZMnxfteszKAa+fz0hd26AYzCywq
	hQgs8l5GIsuopGLyXvJuiNF3+yxPr1C2NNFlXlQlUjVwrXJmsGjwziheOPOdQdhIiPOHNu1Kbyo
	jMVabP3uFV44LBFJeuppAeELn+2m4=
X-Google-Smtp-Source: AGHT+IHAgZ2B4F5FC8p3A7m7eT4394UcvPLnAjiEfVc7dCqJATpqg98MXDeT1SiQ2b2XUxgJ0qLSJgrffw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:e584:0:b0:347:c3c7:963a with SMTP id
 l4-20020adfe584000000b00347c3c7963amr34328wrm.13.1713884782110; Tue, 23 Apr
 2024 08:06:22 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:26 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-19-tabba@google.com>
Subject: [PATCH v4 18/30] KVM: arm64: Introduce and use predicates that check
 for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

In order to determine whether or not a VM or vcpu are protected,
introduce helpers to query this state. While at it, use the vcpu
helper to check vcpus protected state instead of the kvm one.

Co-authored-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h      | 8 ++++----
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h | 5 +++++
 arch/arm64/kvm/hyp/nvhe/switch.c       | 6 ++----
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3ba2f301462a..23a117cb3e50 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -211,6 +211,7 @@ typedef unsigned int pkvm_handle_t;
 struct kvm_protected_vm {
 	pkvm_handle_t handle;
 	struct kvm_hyp_memcache teardown_mc;
+	bool enabled;
 };
 
 struct kvm_mpidr_data {
@@ -1300,10 +1301,9 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
 
-static inline bool kvm_vm_is_protected(struct kvm *kvm)
-{
-	return false;
-}
+#define kvm_vm_is_protected(kvm)	(is_protected_kvm_enabled() && (kvm)->arch.pkvm.enabled)
+
+#define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
 
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 20c3f6e13b99..22f374e9f532 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -53,6 +53,11 @@ pkvm_hyp_vcpu_to_hyp_vm(struct pkvm_hyp_vcpu *hyp_vcpu)
 	return container_of(hyp_vcpu->vcpu.kvm, struct pkvm_hyp_vm, kvm);
 }
 
+static inline bool pkvm_hyp_vcpu_is_protected(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	return vcpu_is_protected(&hyp_vcpu->vcpu);
+}
+
 void pkvm_hyp_vm_table_init(void *tbl);
 void pkvm_host_fpsimd_state_init(void);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 136f6ff2edd3..6758cd905570 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -207,7 +207,7 @@ static const exit_handler_fn pvm_exit_handlers[] = {
 
 static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(kvm_vm_is_protected(kern_hyp_va(vcpu->kvm))))
+	if (unlikely(vcpu_is_protected(vcpu)))
 		return pvm_exit_handlers;
 
 	return hyp_exit_handlers;
@@ -226,9 +226,7 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
  */
 static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-
-	if (kvm_vm_is_protected(kvm) && vcpu_mode_is_32bit(vcpu)) {
+	if (unlikely(vcpu_is_protected(vcpu) && vcpu_mode_is_32bit(vcpu))) {
 		/*
 		 * As we have caught the guest red-handed, decide that it isn't
 		 * fit for purpose anymore by making the vcpu invalid. The VMM
-- 
2.44.0.769.g3c40516874-goog

