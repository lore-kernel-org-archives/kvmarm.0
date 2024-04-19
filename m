Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85FB3E485
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513627; cv=none; b=S2vVdq6igh/z14iP72UFk6LMGkIb8KFKOT8w47UKQX2jFcdXgfA15RnP2Oj/5T1SMHzLiwB4/crzcuSl996T2EbuOJ88PgMyRESQCEkwjdvYYcSzgVX0Is6ItuyXxLSw8Ffv6i+G845TovVOTmQKESxwDVYHuIVxuqTTC8E23/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513627; c=relaxed/simple;
	bh=stCcW8dZHGupiAcwbqgj1VUtnrpmT1wbMAypdzaYObA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ihh2YPq1aQuWy2S+5lqClC2N1HS2LcNnqxND+yHeQY6XOb+uW665XPTAic45GDLNBW/zihSD++QQom3HkXfKI75R3a65J+Q/reAEyJNf4pRFSnwrI8Vda0uQHsmFoujv/njnPr5zeGLV5+GgCVkO8DbkYmW3EXy14iwGNg/mo8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TdLr7cV5; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TdLr7cV5"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-41485831b2dso14460505e9.3
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513624; x=1714118424; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uFOsnqxiSSHZcg/HGtCoQ+BYxgB8+v/V7UhZrUmtfU8=;
        b=TdLr7cV5Hydmp7EpsmhfMMSe5r/Z7SAM6SFtfOMZB/1bYYnsudIE5bx9DYCd3QTScU
         91pIEfAevoSQEyXjtjy/00QCBCNH3e+l4xZIq7yeo/mDxonDuDo4F4QDNKb7Ow2mhc0H
         fSAjPiw+8+dVz05gif7cqidPW4cxYqyY7mWI1+UMZdZj/6zv9JvV84NwHustd+bRGr/B
         pVxrYXyuvwKpOFdb3UX5O1KDLQ6ZVvnHhkjebxKs016cwtG7FHduy/YRwZh+G8tHcxzr
         qpDupHHgHx+n7xB7C9BYGyVCXwVd6ElRyVaHWRSFs3VhfqOsRg8sxK9MSVLa/siFyEUx
         n60Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513624; x=1714118424;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uFOsnqxiSSHZcg/HGtCoQ+BYxgB8+v/V7UhZrUmtfU8=;
        b=w5hMiBZIIjrBut4nqhJ841LLPKDWONZQgrqev50Srda/EwmM/N9DYrQWf1GQAaW0AL
         mr45i7xtq3dYzU7BbpTNunL8Uv1z+c6VuElGC5rYXoyclwZCOFcvaMP6cvalNUmoJkAU
         iTkEjCPQowgIN+o+sIA8FK/O3T071t+IdLfa+mXCFJfQ5Z3BCz3SS7G96SnGf0peRvWz
         QZ0OainroSdQt0U/1tTRNQzRIXGenEVqv2rTHZYC0J/obCTbjw3J5gy4kSvyg51gCql4
         LsB+7e2b2S+qG/HJ8ttQtQoSew88KruDrv3+O0tL69jWdyVyfV8zdpTtNylYY/4OJKQu
         uPYw==
X-Gm-Message-State: AOJu0Yy8kQyEHPqaMmgHB0UG4bCdcCWdW6lRxrxKGBXn0OZdXQnC6Oes
	asic347ZfuJjHE//DOuvoLkB1MgdRe/oFsu1Crox9gqGZbWE9JSakH9TxUPctreIwSMO/U6AG+G
	EnulXJ7/tCQ1EmgE1tkgZCyt8vBuWeEd38v+GEvWgGQyioA5Kogdb6lBxw8e9o/XckquslWIo7s
	FjhAXs4y/OMqrw01v3s58bceVRZ+8=
X-Google-Smtp-Source: AGHT+IEFik5l++XVrhNnuaCObSzEz/A3iWObVmcq3vYpqD+15gqP/UZBCDB5qx6BktMevfsbIFEPiknowA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:35d5:b0:418:d3f4:681c with SMTP id
 r21-20020a05600c35d500b00418d3f4681cmr7746wmq.6.1713513624566; Fri, 19 Apr
 2024 01:00:24 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:28 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-19-tabba@google.com>
Subject: [PATCH v3 18/31] KVM: arm64: Introduce and use predicates that check
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
index 74dc5a60f171..0e6c186a6d6c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -211,6 +211,7 @@ typedef unsigned int pkvm_handle_t;
 struct kvm_protected_vm {
 	pkvm_handle_t handle;
 	struct kvm_hyp_memcache teardown_mc;
+	bool enabled;
 };
 
 struct kvm_mpidr_data {
@@ -1295,10 +1296,9 @@ struct kvm *kvm_arch_alloc_vm(void);
 
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
index 5d2d4d6465e8..41d1ba6de41a 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -209,7 +209,7 @@ static const exit_handler_fn pvm_exit_handlers[] = {
 
 static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(kvm_vm_is_protected(kern_hyp_va(vcpu->kvm))))
+	if (unlikely(vcpu_is_protected(vcpu)))
 		return pvm_exit_handlers;
 
 	return hyp_exit_handlers;
@@ -228,9 +228,7 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
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

