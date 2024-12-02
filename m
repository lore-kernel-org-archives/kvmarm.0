Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0123042AAD
	for <kvmarm@lists.linux.dev>; Mon,  2 Dec 2024 15:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733154493; cv=none; b=O3p0M2uACksPkWzdsSrmarzjVL9cFeCEFgEC0C5Fko1nkC6zkX6tLP5pn1MNmFI66/WVAQrrFUyKgRYGfshb3sdT7zaO4ECsTDEUfXCdh6HY8weIVTzytq+rUZeotDk0WPMzNPXhqUn+0+eKq1BYtyEoyunspYfdGVmrZLTfjyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733154493; c=relaxed/simple;
	bh=50ice6+qOhwiPdpbLsjOnu8b41R5sDJ9wVX7rPZIAS4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kbPDypw8p2jSe+T3YBUFRnKupQAQQ9epm5oadLC+D1xrNCLiLRLOBINj/OVjHCS52y6wXvBzuCyvKFccP23VERL32LbL+bkGInSfVxEHptpc9Y1CL2PHzSwMltOAmX6rZed8mq5Qwa4nGpSkw8OXWmAtIbG25zt/hcBrTwa4McE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dW0Qc6lK; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dW0Qc6lK"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-434a0bf9914so31990895e9.2
        for <kvmarm@lists.linux.dev>; Mon, 02 Dec 2024 07:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733154490; x=1733759290; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nNriDIcshtJkMosS2LovJ2HK/mvE14mb05+LrMMa6to=;
        b=dW0Qc6lK0JvTnJcYimFYveD4W6JnZL4sL35GShC8FjurHm6+/7UK5AlZ8vzCWkLAub
         +Hw4Z1HjrB4hfB0F3jaxH6Yu9IyWnaSV+QJgzVKrV964rzTV12tEXPp01LhvVYplfxU9
         mBEO4tDvtOWGITo0/Y5qqzivZeubmNM9fjFHmxEaywBLvHdjOOuDJ+ItG0JHWBddPbng
         v8cQc8xlAKosCjX2p6WZBpXaaaQEJMNX+uUoNW46leWGg2x2sbilWxhJCnwmm3aPaOEo
         32GtdV5FgsprzoT9N8AH37PJHDOzYX4gUng9CTowcVdsAVbUigxejkm6PL3rZaAnvUjM
         vbSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733154490; x=1733759290;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nNriDIcshtJkMosS2LovJ2HK/mvE14mb05+LrMMa6to=;
        b=peyhbm1P80sRJ7wMJ1DKEFILr6aGuhXo8OK7gfZ3daKPTQZBQ3fNaYVVGOag3mDAKn
         kjTvj2dXLpmsJUZ/AyvUVPHUjvB/uEUbIC6oz6Eeuz61qWKUbZ7bVMjcsSqm63X2GpIl
         OCHyt4UIlp7rf6HuvHOk+bF0LfA3O7kPx1+ySeDmYSONne2hsvf2w4IcgLT/cx8NhzCP
         rL6EmboyR9cD5IPStqzeiU5MlS8Dd7Dz8C5bPO9SZZ7XFTxauTtL/tWLUMS7sSEDt8en
         yd114N9eGIxe3FSa2RaNGdSoByo9vIy5/ufFda6lXmDu1kMINo7pjR4FVZ5HRBspGegN
         j+AA==
X-Gm-Message-State: AOJu0YwA/JX5LfQN/KFyG+tkNIia3EuSXmLOPhpgckJAbkM8i7uCkZk6
	k491N9peT0znFJyNSBUWdI0ptKlDm8vTvSMvzlYdlMue09e0J/MclBClCaoMfkIUkbv5N56GLUI
	oseQD2tTxyh2Q0VUqYL+12f1PEF//J5PkuicHaHvRzJxlKZcPGmk4qWFi00ut9P8F6bz/e6Ghv3
	oNGoPZyL1lL/ra3Vybff+5UpQ49R0=
X-Google-Smtp-Source: AGHT+IFMWiIi0v51OtFih5Zeq632c5WjlhMWfVw/sUtZadDZJoAaiVmEgqqMRPRI8VUya2bOd/51D3qZvQ==
X-Received: from wryi8.prod.google.com ([2002:a05:6000:1ac8:b0:382:321f:137f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:18ac:b0:385:e1a8:e2a1
 with SMTP id ffacd0b85a97d-385e1a8e594mr9562794f8f.3.1733154490186; Mon, 02
 Dec 2024 07:48:10 -0800 (PST)
Date: Mon,  2 Dec 2024 15:47:40 +0000
In-Reply-To: <20241202154742.3611749-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241202154742.3611749-14-tabba@google.com>
Subject: [PATCH v4 13/14] KVM: arm64: Remove PtrAuth guest vcpu flag
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
index c8ab3e59f4b1..dfd031acde31 100644
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
2.47.0.338.g60cca15819-goog

