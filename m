Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233CC203D53
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 10:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734346292; cv=none; b=Jrg5DoQcoBx9vtKEalM/N3YAo17fRCBIHTxtTruBPSxyTpmcNwJR4DXU+QZ9wnvCruvnC0/PFWyrri162zxMyNiXIZgbw3h3bIpFcKsFfvWdKp9n5rtCPkZAh69KT5nvjX7yxFBJYjlZQr9INCLPxdVS7wb9O3lPXcksPTuB6ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734346292; c=relaxed/simple;
	bh=pdHQL+RgqV2hHIvwPdLmIM9UWoxFgDpIvOfEhMoI9xU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f7Q+KPKZ+eiJfwIBQdo28QNVzM6AnA4/4+GBrIF9qnfdu9vp2m1a+4cghVTj6tU68b7+yVeSC+7bk198QbxHxzAEMaV5FQmp5PkyDWtx704zF6QpOcazHS7DqYk3Xw3CQoZHnBV1eBmxajBijLHWKc8KK1QCPWEVke/1PJup2YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ayk7BpKp; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ayk7BpKp"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43621907030so36801705e9.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 02:51:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734346290; x=1734951090; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K9lkhbZv94nQzAEPru091ExF96XSPssPaswLVu4E+ps=;
        b=Ayk7BpKph+PiEygqeF4RnRTMI4J5bxE3UYGpgrWygl0XIItXbLhRzDN8okliqx5O3D
         rzcuYYAsg8/75edF8SMW7+qflRk6nDl6Vhzw8Oy4JxcC/LnB8lFKjJzAPSrRuXQRKjAI
         LlG1iNTyi7qv0zpnk4kLhWvfWhDLnyGM/PJ9R2lGGDicY+53uq6ildbPqolbAHivjtNS
         bvjdLXctb4nu0DpVGi3ZKAeCelkv5eIxWydG0WuxfMnuVmVskI1t4rXlcCCryDCbZfok
         hPIguU0RGc+kFRdTqaWrNJnWWxL7LliY9EJWLNcIFnprEZnYlqeWmVm2kLL5jwsW/Xj7
         8yZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734346290; x=1734951090;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K9lkhbZv94nQzAEPru091ExF96XSPssPaswLVu4E+ps=;
        b=XFpsFxs7Aj6rNBDHszK/PwFGWuW9DMQpztG0/BHC5GHLL0oRp5W91DFPBjKPl/UMO0
         jS3Xo9oU24UqBiLb8xsem0pjBJr6MOcxe2a+97qEbEbQyd+buaDu8v6M3AvCQi70PPPN
         n+M9uze+v7nYT4Zqoee3426FQf9Qdvj0d8fe0RUDCqPsk8oDAIuegQS40XXGlcdms5U8
         IAx32l1BF1Omkl6QdD6XAZdjzilEZhN39lr4akY7mn9NV1Dpf7FUsUJBjrSqTf1rSucy
         sbrQAI4HTAWYmCllPlVP3dXl5wu1Mtbh37EvhRP8MWrzDPF4y5XTZ3hBwlLP2UeIRd2T
         r2SQ==
X-Gm-Message-State: AOJu0YzhHDVSEF4/xxpSNSLJXaKDEK7dsVBCylDViHXpCbywuv4iH+JV
	bZevZBEnGrUd3eZPwIiE+k7/r6HOSm4XTuTLEJ2XbSb0CDSzxpoqHStQAmw2mXykmfSvHS+0hEv
	86g2OxT52p/zzPWIhflMw8zgopmhtOTy9gNKaITNqJM/pVad5cX1L1nsZcxWhrIbdoJeHE4t8JX
	FXsnmPaqq1yXwN1f/79pZJi5mA54A=
X-Google-Smtp-Source: AGHT+IESyDEBagJjrpkm2+JYqdqxE5fOYGYPEc2dByMrXgiPzaaS7F/bOwkNg3P5spfnL0ck9YqBisGzEw==
X-Received: from wmna1.prod.google.com ([2002:a05:600c:681:b0:434:a2a5:1fb5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:524c:b0:436:2238:97f6
 with SMTP id 5b1f17b1804b1-4362aa1af5emr93349025e9.1.1734346289797; Mon, 16
 Dec 2024 02:51:29 -0800 (PST)
Date: Mon, 16 Dec 2024 10:50:55 +0000
In-Reply-To: <20241216105057.579031-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216105057.579031-1-tabba@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216105057.579031-16-tabba@google.com>
Subject: [PATCH v5 15/17] KVM: arm64: Remove PtrAuth guest vcpu flag
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The vcpu flag GUEST_HAS_PTRAUTH is always associated with the
vcpu PtrAuth features, which are defined per vm rather than per
vcpu.

Remove the flag, and replace it with checks for the features
instead.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h |  5 -----
 arch/arm64/include/asm/kvm_host.h    |  7 +++----
 arch/arm64/kvm/hyp/nvhe/pkvm.c       | 13 -------------
 arch/arm64/kvm/reset.c               |  4 ----
 4 files changed, 3 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 6602a4c091ac..406e99a452bf 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -691,9 +691,4 @@ static inline bool guest_hyp_sve_traps_enabled(const struct kvm_vcpu *vcpu)
 {
 	return __guest_hyp_cptr_xen_trap_enabled(vcpu, ZEN);
 }
-
-static inline void kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
-{
-	vcpu_set_flag(vcpu, GUEST_HAS_PTRAUTH);
-}
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 69cb88c9ce3e..e6be8fe6627a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -866,10 +866,8 @@ struct kvm_vcpu_arch {
 #define GUEST_HAS_SVE		__vcpu_single_flag(cflags, BIT(0))
 /* SVE config completed */
 #define VCPU_SVE_FINALIZED	__vcpu_single_flag(cflags, BIT(1))
-/* PTRAUTH exposed to guest */
-#define GUEST_HAS_PTRAUTH	__vcpu_single_flag(cflags, BIT(2))
 /* KVM_ARM_VCPU_INIT completed */
-#define VCPU_INITIALIZED	__vcpu_single_flag(cflags, BIT(3))
+#define VCPU_INITIALIZED	__vcpu_single_flag(cflags, BIT(2))
 
 /* Exception pending */
 #define PENDING_EXCEPTION	__vcpu_single_flag(iflags, BIT(0))
@@ -965,7 +963,8 @@ struct kvm_vcpu_arch {
 #define vcpu_has_ptrauth(vcpu)						\
 	((cpus_have_final_cap(ARM64_HAS_ADDRESS_AUTH) ||		\
 	  cpus_have_final_cap(ARM64_HAS_GENERIC_AUTH)) &&		\
-	  vcpu_get_flag(vcpu, GUEST_HAS_PTRAUTH))
+	 (vcpu_has_feature(vcpu, KVM_ARM_VCPU_PTRAUTH_ADDRESS) ||       \
+	  vcpu_has_feature(vcpu, KVM_ARM_VCPU_PTRAUTH_GENERIC)))
 #else
 #define vcpu_has_ptrauth(vcpu)		false
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 956385ee4aa2..b399d69b4b67 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -278,18 +278,6 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 		   allowed_features, KVM_VCPU_MAX_FEATURES);
 }
 
-static void pkvm_vcpu_init_ptrauth(struct pkvm_hyp_vcpu *hyp_vcpu)
-{
-	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
-
-	if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_PTRAUTH_ADDRESS) ||
-	    vcpu_has_feature(vcpu, KVM_ARM_VCPU_PTRAUTH_GENERIC)) {
-		kvm_vcpu_enable_ptrauth(vcpu);
-	} else {
-		vcpu_clear_flag(&hyp_vcpu->vcpu, GUEST_HAS_PTRAUTH);
-	}
-}
-
 static void unpin_host_vcpu(struct kvm_vcpu *host_vcpu)
 {
 	if (host_vcpu)
@@ -359,7 +347,6 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 		goto done;
 
 	pkvm_vcpu_init_sve(hyp_vcpu, host_vcpu);
-	pkvm_vcpu_init_ptrauth(hyp_vcpu);
 done:
 	if (ret)
 		unpin_host_vcpu(host_vcpu);
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 470524b31951..1cfab6a5d8a5 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -211,10 +211,6 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		kvm_vcpu_reset_sve(vcpu);
 	}
 
-	if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_PTRAUTH_ADDRESS) ||
-	    vcpu_has_feature(vcpu, KVM_ARM_VCPU_PTRAUTH_GENERIC))
-		kvm_vcpu_enable_ptrauth(vcpu);
-
 	if (vcpu_el1_is_32bit(vcpu))
 		pstate = VCPU_RESET_PSTATE_SVC;
 	else if (vcpu_has_nv(vcpu))
-- 
2.47.1.613.gc27f4b7a9f-goog

