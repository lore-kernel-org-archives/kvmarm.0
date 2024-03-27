Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695F7137772
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560958; cv=none; b=hvUzZa6yLLByfFDr9tTw8dvkjsBZYuUjYYkwjMjqK055ODlnnWqshX2TZajdK4vQdsGsciPWvpLCh0jVKhHrqnNXXkpZzwvj4I6RVlIUeyjogXSUV9UH6fgnw6ynu8t87cDVX950FBmBk81CeqS5YkgWLffBhTc/lW5eArOdQKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560958; c=relaxed/simple;
	bh=B1fRYXMYfNQqZftJvz9Oa8xtTcvZff8OcrLZ1Ed7R4Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nmuZRCj4M4bCwv/6euWerCYfxw8/axODWrIibK8oTUAz8R/5TKsHBeKNPpQ+fo/NQmx29bXgS54jKrjBWBNIPCk+W9fxgm1tPtE+aNc6WxJ/XWduZiPUEl0eWmviLOWRJjM09eC9akm8INaUOkpOqvKKAPYCkUibeoHspEOcX7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ALK+Hwzk; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ALK+Hwzk"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dd169dd4183so39666276.3
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560956; x=1712165756; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RlXAOOJg9Y9yK5aN5lnvJtNnH21w2/6CP+hDb2MGybI=;
        b=ALK+HwzkmrIvjitXfPI0XqxVP1BHktNyznEpdAADLyIYIKmrXeDYeOhN5yprDgGwbO
         4r0wBFb1M0Y9gWVUj3MKs0uJbN7L1kkvcHmpGP9A/keXCE1WNKBvxPh/4faGMVBe15DD
         VWK+iBSTa9ncL5puYVR0J7xLjJng9/McZfxn+T4EtjQv3cNQmN4X5ehK8jO90Ui0pxiM
         Zu/bNkscR5teEM2VUPFthqmfj1gnoEOXioJFWH7v4gvLlnc/jUZMNg7M/10xmzg05Aiy
         K0xFTqrzqDvZ0BSzogwKwoc+o4Cftj/Qt8+QsrbcJNKi3XPA8NDDoe7K+uipPr6q1ER6
         SHWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560956; x=1712165756;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RlXAOOJg9Y9yK5aN5lnvJtNnH21w2/6CP+hDb2MGybI=;
        b=O6t8/0I3wB7Sul7R7YQEaxHdVIE9DL+x68ukIj8UjOwF7bp776E5bHiAfb2KdVxvpt
         sImwg2kJ+jpmBrvV7KpAOORaugbM5XX8X1aD+VuxXIUUtmgTtBSqFKCT5Lu4zta85Hu9
         3n2S0fLwrFkXwz6UqG440nb2CK0VvrykKpdN2kodFBZNUuO7lbCyqFmfmd0DGSHNfOYJ
         vV83ZJ9+bySTGHCt5D8pJay86yxGvhd14hwVcgvIxhtsy0GKe7zEdkeH7saqtA7POuic
         7hATqCTXR66yj9A7fUHcyP6t1P5QmrR9b9s70/yc9KoxpHuET7wtVlur/mCHy6ZRmYjJ
         rkIw==
X-Gm-Message-State: AOJu0YwfDxua1yPtKiiSRoI0iMgnt4trg9g6lR0EtEhFF7RlBaZ/YwQR
	GdFNFjP0h34VtZ2AnfIpFZUk9wlMakEj4ANQ5lPNaQa5IuVmVZtX9Zf59V/nPBZKwCltpqlyspe
	KRvJxJ2D1RDelBZ97g/9Zgzn6lHw0GXc7O5r5OI1bkeYF7Wilr+PmA1mi31bitMnCcEeces151S
	gGp3yyM5eT0+Q/eGNsg5wETo++on8=
X-Google-Smtp-Source: AGHT+IHsER055+GT7nODD33kyRpVbLa6H4SRvzxxSxv/wOyl4l9AXktsnryEiJ5JRXP6t6ULsVeP+33wPw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1607:b0:dda:f314:7e1f with SMTP id
 bw7-20020a056902160700b00ddaf3147e1fmr59201ybb.4.1711560956457; Wed, 27 Mar
 2024 10:35:56 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:34:57 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-11-tabba@google.com>
Subject: [PATCH v1 10/44] KVM: arm64: Introduce predicates to check for
 protected state
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

In order to determine whether or not a VM or (hyp) vCPU are protected,
introduce a helper function to query this state. For now, these will
always return 'false' as the underlying field is never configured.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h      |  6 ++----
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h | 13 +++++++++++++
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9e8a496fb284..7249e88ea13a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -211,6 +211,7 @@ typedef unsigned int pkvm_handle_t;
 struct kvm_protected_vm {
 	pkvm_handle_t handle;
 	struct kvm_hyp_memcache teardown_mc;
+	bool enabled;
 };
 
 struct kvm_mpidr_data {
@@ -1247,10 +1248,7 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
 
-static inline bool kvm_vm_is_protected(struct kvm *kvm)
-{
-	return false;
-}
+#define kvm_vm_is_protected(kvm)	((kvm)->arch.pkvm.enabled)
 
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 82b3d62538a6..c59e16d38819 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -53,6 +53,19 @@ pkvm_hyp_vcpu_to_hyp_vm(struct pkvm_hyp_vcpu *hyp_vcpu)
 	return container_of(hyp_vcpu->vcpu.kvm, struct pkvm_hyp_vm, kvm);
 }
 
+static inline bool vcpu_is_protected(struct kvm_vcpu *vcpu)
+{
+	if (!is_protected_kvm_enabled())
+		return false;
+
+	return vcpu->kvm->arch.pkvm.enabled;
+}
+
+static inline bool pkvm_hyp_vcpu_is_protected(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	return vcpu_is_protected(&hyp_vcpu->vcpu);
+}
+
 void pkvm_hyp_vm_table_init(void *tbl);
 
 int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
-- 
2.44.0.478.gd926399ef9-goog

