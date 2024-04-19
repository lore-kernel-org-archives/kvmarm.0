Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1118746453
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513608; cv=none; b=mb3fBiZZe0V+sZ+1178QqNUBYkPpWuGP37cyORCWcsK5etys8e9tP5gmk5vNUgCBptvyVDoG/mtxrjverYLCaGYZIUVhkiDmIaFdup9ZE/ebhIJJowXA8VTbGD5HLBYdB7an94bB0EjeuOt9loHuRWOpZs4fmeOF1rXV8pHyFTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513608; c=relaxed/simple;
	bh=aQl+3P9AfqonTzgeDdtHDnFcvSOAmRRmkAK4rET0uXw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PgTd86/dwMEPIqbj2EtX+0PXNssF3JXgYXSARKUbNzadqSEB/v5QfsB4kLYRzIpe7se/KlCIroXnTIyLESSwlqHoCxxoXPEGCsvxlZlwK3RKS2jOGgSh565Y96DCoS+XxVAHjuViP5G6LwJLl6NsUBEgBMPALM30vqf0lxaP7gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KcoqifFZ; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KcoqifFZ"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61ab7fc5651so32939967b3.2
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513606; x=1714118406; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0oOFADo/lIxLfuUXFGgWHGl/IkioDx7wkAvSf1CNhTI=;
        b=KcoqifFZI2C6/dCgDXRUAJ7cFVa8aD6+OD51TguxNi14PTY7d+L+ueeFhyLOpDdCEm
         08JHr9KgFtXqfx1jyuDyGhpiptYdQNwy2zX48WIUEin+OfTV2tA13WCyKG0etnX1MbAf
         dinZsX0nl9UpUe8f5/9TFG6Xhn5nYHdfCDE3x/sCmtlnwXZ7BB4idDupdK1lIC8AOpqF
         TvpOVIIUaBCfFU1vgQ6ubpzZXHsZEq10JpT5R7fKUg0kFbug9kUi8f8I+x0GO9t0DOik
         fA5KhvVEqGyEmKeINVb4FDeFR5CkKJzZUNSbrHIXYE7dquLn4R9dbuA7KC4D6e/QO5lw
         vbwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513606; x=1714118406;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0oOFADo/lIxLfuUXFGgWHGl/IkioDx7wkAvSf1CNhTI=;
        b=YjZRfWmHvka9tSatzAUg3wnI/TrFQC/GHkAc2pCP/JoXII2C7BoW62za1RjZe1pR8r
         xYtqC2ed0fTqWn/toGK6sDKKrB1am6Hrd0+s0oIcLrZqRR5xxv+tJlrdsPYKFZ9U0Tsf
         B1fldY2sR0nZPlNQkMS+RXNzr36nKqPhoionoBBTfdAbLHttoeHntOk2foLOf7w6zzd4
         7sQID8y0upbwIOOY678IKW4GM6ZXepHjHHZ4efVs4ppy9Gm9hMutOtJGXLLwoNQbAoz8
         M3iczKSjUg5j8t7CG56PD4bGfyF0/l1t5gL6wrzsqH4o5/xnWNaY73lmrXueSB83xunt
         hMFg==
X-Gm-Message-State: AOJu0YxybNR1tfaE0h0RmC7blLzMNTci3mbRHna6qxOEJrGzUp8EiXh+
	+GZZXj7kl4fRwdf7dTTOnKo2ksTfMFk80/zQQxhp425OAD+d7Iu16F03HWgMET6ZyGs5PiRabfF
	yBt2xrNON5ex93kc4EzYI+tyxY3ekH/0A7nC0PjS/1XxVLqws5N9qOD55bHkuxXb+p4HInNueDU
	5CH2YnsRHMiluy5IsoyRRBRD76iPo=
X-Google-Smtp-Source: AGHT+IEXkiMMtxInXNSj3D7vB7ZNkttkATENAv+o2HZ7oFUmoi3JUdAViaqWsBvhSSeovzcC4eWIKU7/HQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:ce54:0:b0:dc7:5c0d:f177 with SMTP id
 x81-20020a25ce54000000b00dc75c0df177mr351969ybe.6.1713513606091; Fri, 19 Apr
 2024 01:00:06 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:20 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-11-tabba@google.com>
Subject: [PATCH v3 10/31] KVM: arm64: Do not map the host fpsimd state to hyp
 in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

pKVM maintains its own state at EL2 for tracking the host fpsimd
state. Therefore, no need to map and share the host's view with
it.

Signed-off-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 ---
 arch/arm64/kvm/fpsimd.c           | 31 ++++---------------------------
 arch/arm64/kvm/reset.c            |  1 -
 3 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4609d1b9ddde..74dc5a60f171 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -663,8 +663,6 @@ struct kvm_vcpu_arch {
 	struct kvm_guest_debug_arch vcpu_debug_state;
 	struct kvm_guest_debug_arch external_debug_state;
 
-	struct task_struct *parent_task;
-
 	/* VGIC state */
 	struct vgic_cpu vgic_cpu;
 	struct arch_timer_cpu timer_cpu;
@@ -1262,7 +1260,6 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
-void kvm_vcpu_unshare_task_fp(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
 {
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index d5837d65e4a1..63a6f82934a6 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -14,19 +14,6 @@
 #include <asm/kvm_mmu.h>
 #include <asm/sysreg.h>
 
-void kvm_vcpu_unshare_task_fp(struct kvm_vcpu *vcpu)
-{
-	struct task_struct *p = vcpu->arch.parent_task;
-	struct user_fpsimd_state *fpsimd;
-
-	if (!is_protected_kvm_enabled() || !p)
-		return;
-
-	fpsimd = &p->thread.uw.fpsimd_state;
-	kvm_unshare_hyp(fpsimd, fpsimd + 1);
-	put_task_struct(p);
-}
-
 /*
  * Called on entry to KVM_RUN unless this vcpu previously ran at least
  * once and the most recent prior KVM_RUN for this vcpu was called from
@@ -38,28 +25,18 @@ void kvm_vcpu_unshare_task_fp(struct kvm_vcpu *vcpu)
  */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 {
-	int ret;
-
 	struct user_fpsimd_state *fpsimd = &current->thread.uw.fpsimd_state;
+	int ret;
 
-	kvm_vcpu_unshare_task_fp(vcpu);
+	/* pKVM has its own tracking of the host fpsimd state. */
+	if (is_protected_kvm_enabled())
+		return 0;
 
 	/* Make sure the host task fpsimd state is visible to hyp: */
 	ret = kvm_share_hyp(fpsimd, fpsimd + 1);
 	if (ret)
 		return ret;
 
-	/*
-	 * We need to keep current's task_struct pinned until its data has been
-	 * unshared with the hypervisor to make sure it is not re-used by the
-	 * kernel and donated to someone else while already shared -- see
-	 * kvm_vcpu_unshare_task_fp() for the matching put_task_struct().
-	 */
-	if (is_protected_kvm_enabled()) {
-		get_task_struct(current);
-		vcpu->arch.parent_task = current;
-	}
-
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 68d1d05672bd..1b7b58cb121f 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -151,7 +151,6 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	void *sve_state = vcpu->arch.sve_state;
 
-	kvm_vcpu_unshare_task_fp(vcpu);
 	kvm_unshare_hyp(vcpu, vcpu + 1);
 	if (sve_state)
 		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
-- 
2.44.0.769.g3c40516874-goog

