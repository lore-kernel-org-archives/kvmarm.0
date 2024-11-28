Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F097198A11
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 12:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732797347; cv=none; b=i0CvnrKOnlpJeS63YR7NLeQ3CQhWa585kL9L+TMhCZJ6bBRrRkyvcNPckb47DGKspmrfiX3ReI2n71uqitE6TZ+uTcnNAHBu894oo85G3Dlyt72m170Hu/fXFW31CwtKRVpD2Bx3b2WzYHVnmijGfXjNor6yGQ66fJ5tRi6PgWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732797347; c=relaxed/simple;
	bh=QNquABmgtVdCEOrzvTTkxL9NKw+A+gYBpkTO78LVcMo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UyzfxvL41vpksaOR91Cd1N8U9ll5r6UzKGEv9x5VQilIe0VTBiS3ZsINHreHFGqQAusO2c6lswSofUc6EG8YzeJDGx+2/R2ne4HmaWOvs4QqhqitKfU47gh7R3dBaXCLcd65eSSDD2wsmavGSs5zUTwk+3MhHZ15Ph/apZOQFww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QrxzhklX; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QrxzhklX"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-38233ea8c1bso1047990f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 04:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732797344; x=1733402144; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8cW1xQg3A5S2kec6W3gcCXjMo2wpT2RcLePz0Y97Nf4=;
        b=QrxzhklXETxUprVdOpJYsmYceMQJCuI2oteY2705Jt3gyJPYiVu1gTEGEbOgi6CWrk
         TNonHa/pd78aQ5O2r6uk4TSQiJiHdfmADhofRKyYoxTS5XO5+tTmzhKu1d34Zm+QnqtE
         MYe64x0Qhi9Ntm6qdIbn9sbVQtXW45J555Jm+LQooj5C4/x65t8gaie6Lne8koJbFUW8
         BUIPgrktHPttGZgcuDGOzbbLyx4VhKaGsAhVfCxuK8FVooa4Lz61QZVN6lhwPl943y92
         KxGG2xaMZccsTTfasecnO71nbyDzOIu7GkBUclsxfg4zpPdr8UH9oPFbrvW51T5iZv8Y
         +pgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732797344; x=1733402144;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8cW1xQg3A5S2kec6W3gcCXjMo2wpT2RcLePz0Y97Nf4=;
        b=A9zle3rmv7c6WomUmvJBVqk7ng/noO2Bl6qklXJEHe0T9xSZWbeoSiVF+noBVc7/bf
         EAL/UwSYQPNd8RXZS2/qhpdXCbpG/SbXEFe59b5xG97Uc4GnoN1o0l7d2JdVgPfmsSiZ
         4D+/AoZ4Lv+xIU8M+MAsWWao3KvA4hrLjIBbHar6AMV64WptLxizzvDkbhDFD4aOKuW+
         ZpG/RK7Lp+rqA98VptN+eHuuuDG1D2bJPjmgHlkSSeFsYPF7a3dRMQRGsKle1ojTKV4t
         xg7vQEFL5nEhvukTpBvDiGcHOOfC6Mb/SiSz7+caRt3QXrXZx5XJXyoH9G3vD6pAFPZl
         LhSA==
X-Gm-Message-State: AOJu0YzsDBeyEuya39pRdP2iEPHUorMGyoRxSAoRyNBh4FPpM3Pl6840
	8+kt4KyFozWiMbz3NUdVFhYzr9q+a4bJFH0pIhfe5Y54IJUFGhowVfm3WehahpzblL6QeVKjI6e
	QlEdSYjqa1KcRYzk5m9b9ybmQzBS1fZ+xDA72xXYJwYAuzPjOOlDt9VLbAWfo5KpZjU7DFoHPYl
	hQXmr3PcxKTivfr6K0IJxooq6ouE8=
X-Google-Smtp-Source: AGHT+IGGTrA03bJnLdQaVg0s+G7g0LZ8HsrDY7536qPbFY2PR5LidlEiGux8vbzXJNvpQSf2c2hxAHBIrg==
X-Received: from wryf11.prod.google.com ([2002:a05:6000:1a8b:b0:382:4e57:48ec])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1547:b0:382:4b04:a586
 with SMTP id ffacd0b85a97d-385cbd7c54dmr2515942f8f.16.1732797343896; Thu, 28
 Nov 2024 04:35:43 -0800 (PST)
Date: Thu, 28 Nov 2024 12:35:13 +0000
In-Reply-To: <20241128123515.1709777-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128123515.1709777-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128123515.1709777-14-tabba@google.com>
Subject: [PATCH v3 13/15] KVM: arm64: Remove PtrAuth guest vcpu flag
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
 arch/arm64/include/asm/kvm_host.h    |  5 ++---
 arch/arm64/kvm/hyp/nvhe/pkvm.c       | 13 -------------
 arch/arm64/kvm/reset.c               |  4 ----
 4 files changed, 2 insertions(+), 25 deletions(-)

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
index 69cb88c9ce3e..680ecef1d7aa 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -866,8 +866,6 @@ struct kvm_vcpu_arch {
 #define GUEST_HAS_SVE		__vcpu_single_flag(cflags, BIT(0))
 /* SVE config completed */
 #define VCPU_SVE_FINALIZED	__vcpu_single_flag(cflags, BIT(1))
-/* PTRAUTH exposed to guest */
-#define GUEST_HAS_PTRAUTH	__vcpu_single_flag(cflags, BIT(2))
 /* KVM_ARM_VCPU_INIT completed */
 #define VCPU_INITIALIZED	__vcpu_single_flag(cflags, BIT(3))
 
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

