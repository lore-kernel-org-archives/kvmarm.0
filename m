Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9E83E485
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513635; cv=none; b=ZN3pTcE6jsEn8k8w+LAqH0WEF9BrYnV1z90Sxggatu7NyQ2dXPypC/qRN1pP+ZwjHiRxpVYiW1JFtFE9cQTa8ZN0hPUYnjF29VY8TRoszO1SccUB4iB2cdEuxsm2U+NxcrIKZ93gZYG6bYqtU1HTNRNzmdW/XiCuTA7jB+J5T80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513635; c=relaxed/simple;
	bh=ACMSkG3FxjivhsUhALMBX27zycxTyjkY3gqJty4NTAE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EMsRFicASo8vejn0G9anUtJ+FiG1bx9dNt/hYwckL6v+SICn1qlG5tqq84IqmlY/f8+VpRvnKWqcZ1qLFz7jZ/soPdyedhe/PKjcXYn2D74DoLdEb22OFU+jGl17KiGnWodEiYHS3PmlUG6ISfTJgtzcP68KDGctoZl+kgC+09w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PlbNEjYg; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PlbNEjYg"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-349e1effeb5so1160869f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513632; x=1714118432; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2vWuvCOvrV0hGDPs9UOCMDUU6bIE68r3Eq7lJla/Tgo=;
        b=PlbNEjYgINb/+Awb2XVMB5NlGayHgnU1UwIWNdMgApfyovao9pWjCl2aF9D0PUPYVO
         xlIy02VO17/GnZCv/Izwf1xZ5DUXmSYKLF5H0sMwrPwfAMDAqPYB9b3dlx4lArSw7psZ
         4f4wCk/rEJZjDK05fDxU8ch58ORNgmNU07nUEgIIiwCNzMH8yy+5vWdn4ufytGmFk0pD
         /N21lXSGdNlsVNEtnk4GMMtle6xbcn16HbhOy7FjP5pLBddu2g0h/WBR+pUTpnEg0Gy7
         z9JoZacO7eLkjcCo3f4SudWPjLsgPlKPP4m7T/14i8WqhGAHRFoVS9SK0ZPV93DdIbuJ
         jPJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513632; x=1714118432;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2vWuvCOvrV0hGDPs9UOCMDUU6bIE68r3Eq7lJla/Tgo=;
        b=pggv+04tSq3l0NPOUpA16AIqi4f+p46hE+jCLHBg9gIhGYqUMMBbF75Lerv9P7A0GA
         ftpGlA4clA4fLNSlpyuPcgBaW3jjWIa+uvv1jlRJaIwW92l9ZVREZTFzXtHXGm6RbQpV
         t4gvo41hcwh8umkTfJDxBincCOKtMUGeV+aTNBqSc3yb2RMBkZp1wpg0o7JfVJQEwcDN
         RBuJdt+sQw/cx62VxFcUn4dXxseKUzhLcMd/PSGZcM1+0BnN8Sk8kvw2It1lmO3zyc/U
         F+qhCsTM3J3HdOOzf9zFBiKhep9lBXrKthrBN0z3ySGBlS6cih1yQurDcm+9n8In6Wh5
         dSBw==
X-Gm-Message-State: AOJu0Yzlawa56bLi39p7mbyeHBx5hcLPbdOGoubT7JKYSjnJcn38V7f/
	ob7ZUtWkqd1pYflTGhk2Rb2DLdaSZdAArusmAQVwHwk330VbvhukCh+MfJ2byHwppoQVc0oWnz8
	NqH3LO9hUpoqvFC/3i/419zOiLyHdDDQjo8W/5os9tM8bFu9znjgFptLjWVVdqiiuiUUM/Tspqb
	7eZ2iP8px0xigvkyidk7h032NU9Jg=
X-Google-Smtp-Source: AGHT+IEurMspycSHGflFCVbEwoD3m/RE5d7DDHfqloF1H0PiMl/RfxwjpOwaLW+4licQgz8xVlsmqx0ing==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:6e0c:0:b0:343:dd8a:bfa1 with SMTP id
 h12-20020a5d6e0c000000b00343dd8abfa1mr11421wrz.4.1713513631821; Fri, 19 Apr
 2024 01:00:31 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:31 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-22-tabba@google.com>
Subject: [PATCH v3 21/31] KVM: arm64: Refactor calculating SVE state size to
 use helpers
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

The main factor for determining the SVE state size is the vector
length, and future patches will need to calculate it without
necessarily having a vcpu as a reference.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0e6c186a6d6c..bf4e8a8d9956 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -854,22 +854,24 @@ struct kvm_vcpu_arch {
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
 			     sve_ffr_offset((vcpu)->arch.sve_max_vl))
 
-#define vcpu_sve_max_vq(vcpu)	sve_vq_from_vl((vcpu)->arch.sve_max_vl)
-
-#define vcpu_sve_state_size(vcpu) ({					\
+#define sve_state_size(sve_max_vl) ({					\
 	size_t __size_ret;						\
-	unsigned int __vcpu_vq;						\
+	unsigned int __vq;						\
 									\
-	if (WARN_ON(!sve_vl_valid((vcpu)->arch.sve_max_vl))) {		\
+	if (WARN_ON(!sve_vl_valid(sve_max_vl))) {			\
 		__size_ret = 0;						\
 	} else {							\
-		__vcpu_vq = vcpu_sve_max_vq(vcpu);			\
-		__size_ret = SVE_SIG_REGS_SIZE(__vcpu_vq);		\
+		__vq = sve_vq_from_vl(sve_max_vl);			\
+		__size_ret = SVE_SIG_REGS_SIZE(__vq);			\
 	}								\
 									\
 	__size_ret;							\
 })
 
+#define vcpu_sve_max_vq(vcpu) sve_vq_from_vl((vcpu)->arch.sve_max_vl)
+
+#define vcpu_sve_state_size(vcpu) sve_state_size((vcpu)->arch.sve_max_vl)
+
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
 				 KVM_GUESTDBG_USE_HW | \
-- 
2.44.0.769.g3c40516874-goog

