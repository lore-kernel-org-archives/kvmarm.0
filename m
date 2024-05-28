Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2976216EBE2
	for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 12:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716901185; cv=none; b=OSmofTkz3tvXUATMIaYQXIRm8rLrS9BJodQEhQBCZfixGMG6vesU06ZkGmOOj8kHl9bh/o6Y3exakkmcI3hFe2gRxJlGceQ4GfbgsAoI1BUVaFs3l26Dx/2Zjobq5UNKJ3HC12yPfNpSZ5TKGHitF23Zhdl6CCaZD27uHZjXsG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716901185; c=relaxed/simple;
	bh=b93J8VkAlUzexjAir/I5KU+AQpoLiteuuU8SDA5ywYY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X+YKbfv1LQFy5mLFJR9WXlioaIHljr5MTuHu1xZO3lPhH2InERLaDc5/2K2wIBBTy21xxmsynJNNXtQiA0QqWuGOATKl0moYkWi7IO5/Nar2Z3zlruHSHYQZ2v6mG5Nsq3gy9VbtTHxyDfuCBOMKI39YQFkreGEbmpDM+9bzNdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d7nyB3IU; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d7nyB3IU"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df78fddad5dso1429897276.2
        for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 05:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716901183; x=1717505983; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=++8ZcPZ7JmSDdoaVdv9H+c7hOtXhBJRAEHQi6Uobc0k=;
        b=d7nyB3IUl5yImeXETs/D43BvEw9k7UTOqzhYG6O3pRE0tj4Qb70I2Kssx3+AN61nyk
         uyBzu7IkU6V2+7l9fsPfHttO7Y4rmwKstyqK+eWp9cva9D7AEaDSEY21IofvvzQdSMqM
         41xQGDWSzSqOAE+GWtokg0qD5c0xHGwakzaCVGOgn84O00uxjjrdLfYMcgDQNtbHcKWe
         2mVm2nk4cm/zFV4AroDeBmXeUOh/Wo1XqUjTKnNgHHf+FZPFPPnW3VqT6BWeBLBCb2f8
         2tTPm43gMq2y5F9bgk/56ETUB84xsoe6u6TV6bsyhsg4djZHkhOzE8pErzXHhUIDQmBc
         LeAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716901183; x=1717505983;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=++8ZcPZ7JmSDdoaVdv9H+c7hOtXhBJRAEHQi6Uobc0k=;
        b=stVz9AtiO1ebT/riEUgsRHuXJx8kk0GXpjdEqWgFKv9pH4PdqPfqJDodOtS0QDRUAs
         hRLdyMOEFtZGSX93u8tGW+4yAE5qOfdk64BZiwVXG6cgYxl5zwCtwffVp/j9yGRWmAk7
         WLQA3EEhq8Ki+RtuYI2diHl5kvXFR5tWA9fgK8gpfXrU7TUmBy1dags4Dfx7gNRRfS8f
         54e6fuZdbee4Qm8fm3w26wigkz75ba9nm7AkVvkYwF/4HiYk9sL09jF62Tt6rJTpXw9c
         V0w4gMoJyh0/rljqRQrBSoFPL6DKuZnctKZ601awUZ+QEhih9U7t23Bov8DtxOjlF0vH
         2lhg==
X-Gm-Message-State: AOJu0Yz/YlwQQL+88hZXAlqbeboF4dDeV+sA+0ndH6AHf5x20+h00by5
	0SVezLU5lZJkyQ8BObRKubBgsueRr0mbk84vC45n+Doh4fe7n7BLIwg7qKns05MItki2E7yd44P
	6uE6q5mZ7tZh9txNNX1k9j12/Og8P3MFTd4nt6+aQzYQgEK/AGZ9sYhZntQI8kyi89kksEhlxc4
	Ng2VnufVK8NRhN1KJvigJHr3eT0G8=
X-Google-Smtp-Source: AGHT+IEPAeu+KJVWIW2O5bB77nX8DiOlJ1pK44114PVXZ79vL0TmP/aTXBjIhQZT5mdFAlyljkxztiU/Pw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:154a:b0:df7:a1b9:c0cb with SMTP id
 3f1490d57ef6-df7a1b9c281mr1535457276.3.1716901183268; Tue, 28 May 2024
 05:59:43 -0700 (PDT)
Date: Tue, 28 May 2024 13:59:14 +0100
In-Reply-To: <20240528125914.277057-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240528125914.277057-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240528125914.277057-12-tabba@google.com>
Subject: [PATCH v3 11/11] KVM: arm64: Drop sve_cond_update_zcr_vq_*
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

The conditional update likely doesn't help performance, but makes
the code a bit more difficult to read. Remove these macros and
just write directly to ZCR.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
This patch is meant as an RFC, and undoes the previous patch.
Please feel free to accept/drop whichever patches you think make
sense.
---
 arch/arm64/include/asm/fpsimd.h         | 21 ---------------------
 arch/arm64/kvm/fpsimd.c                 |  4 ++--
 arch/arm64/kvm/hyp/include/hyp/switch.h |  3 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  3 ++-
 4 files changed, 6 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 531f805e4643..d5ef1cf34e10 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -219,24 +219,6 @@ static inline void sve_user_enable(void)
 	sysreg_clear_set(cpacr_el1, 0, CPACR_EL1_ZEN_EL0EN);
 }
 
-#define __sve_cond_update_zcr_vq(val, reg, sync)	\
-	do {						\
-		u64 __zcr = read_sysreg_s((reg));	\
-		u64 __new = __zcr & ~ZCR_ELx_LEN_MASK;	\
-		__new |= (val) & ZCR_ELx_LEN_MASK;	\
-		if (__zcr != __new) {			\
-			write_sysreg_s(__new, (reg));	\
-			if (sync)			\
-				isb();			\
-		}					\
-	} while (0)
-
-#define sve_cond_update_zcr_vq(val, reg)		\
-	__sve_cond_update_zcr_vq(val, reg, false)
-
-#define sve_cond_update_zcr_vq_isb(val, reg)		\
-	__sve_cond_update_zcr_vq(val, reg, true)
-
 /*
  * Probing and setup functions.
  * Calls to these functions must be serialised with one another.
@@ -338,9 +320,6 @@ static inline bool sve_vq_available(unsigned int vq) { return false; }
 static inline void sve_user_disable(void) { BUILD_BUG(); }
 static inline void sve_user_enable(void) { BUILD_BUG(); }
 
-#define sve_cond_update_zcr_vq(val, reg) do { } while (0)
-#define sve_cond_update_zcr_vq_isb(val, reg) do { } while (0)
-
 static inline void vec_init_vq_map(enum vec_type t) { }
 static inline void vec_update_vq_map(enum vec_type t) { }
 static inline int vec_verify_vq_map(enum vec_type t) { return 0; }
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index eb21f29d91fc..bf8bf9975951 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -187,8 +187,8 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 			 * role when doing the save from EL2.
 			 */
 			if (!has_vhe())
-				sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1,
-						       SYS_ZCR_EL1);
+				write_sysreg_s(vcpu_sve_max_vq(vcpu) - 1,
+					       SYS_ZCR_EL1);
 		}
 
 		/*
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 162a60bcc27d..800dd4e1bcbe 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -314,7 +314,8 @@ static bool kvm_hyp_handle_mops(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 {
-	sve_cond_update_zcr_vq_isb(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
+	write_sysreg_s(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
+	isb();
 	__sve_restore_state(vcpu_sve_pffr(vcpu),
 			    &vcpu->arch.ctxt.fp_regs.fpsr);
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index cef51fe80aa8..0feacd13b4c2 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -31,7 +31,8 @@ static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
 	 * the guest. The layout of the data when saving the sve state depends
 	 * on the VL, so use a consistent (i.e., the maximum) guest VL.
 	 */
-	sve_cond_update_zcr_vq_isb(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
+	write_sysreg_s(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
+	isb();
 	__sve_save_state(vcpu_sve_pffr(vcpu), &vcpu->arch.ctxt.fp_regs.fpsr);
 	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
 }
-- 
2.45.1.288.g0e0cd299f1-goog

