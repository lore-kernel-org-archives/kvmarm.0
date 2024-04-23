Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A40113B7BD
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884798; cv=none; b=i3hRQpy2aIP71Yh2eVx/K3tfOVzWMjlzbqlKp1R4E+TZhV5zEZaI2BfHsuR8hel6ZvtSUWuOHzdQI9dKaCMMViPJjOdzeSh4icrcWAH95iG1IHG3uJcIIpH2ZgtMqDT6HqKRZW+TWDWzVpff3QbNnhYEfd0Cda4XWswMBgdMb8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884798; c=relaxed/simple;
	bh=TwQAfSRbn3LY8w+X90hnbgN5Ymfx7kHarmdIPV+FEZQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QR0POJgl/oBkyhMS4NO20/nzPwx3UZhc5d/RSSYvxJOech5VKZvHaPOoKlcnKZNSxTtLllDriFGL9+xvHXmnVTBZ0NG35vkTV0hssHfIV+7GG/7VvMsk7pHvvmAjLeGQ3rQ7pvx1a7fmMjXHQ4JWDzTx/pC6SM9wUKMtN+MbWIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QT7uvu4z; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QT7uvu4z"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de465062289so12755426276.2
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884796; x=1714489596; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NOxZ5KTuixEl9yHchF6QpX/YqwkaE/fNJT9xow+k8E8=;
        b=QT7uvu4za6J5FfabGVWzMojaqtQMlQLt5ucHxNLKEJ3czOgYdiT1nfu7vU3YsZ69r7
         xYK+VDWyhx9Dq+a1X5B8s5QMiuWE2yhXNzMTR9dgU9vpOMOY8o+fUrlhyFD8OMmPKhXZ
         3QtOZE/WvKdE+oNQluYZFb2ffOcyh/G1WXzTCC2pPgT+Mb8l2kNsPvlXbqMdFPGz+ssf
         Rr8gXIcfqgWflCFa4UupDgkdrwXjZ1Aqwe4SLlzmSvWyrp693qSkL0s7bzWa/0F1ET+c
         ArxwPVt1lJhl3AJl5yLJ3ZPmEyN31kZ3B1cOt/vFhvhLsOetHiy2Rd+i+QvCg8FpTYS2
         5zxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884796; x=1714489596;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NOxZ5KTuixEl9yHchF6QpX/YqwkaE/fNJT9xow+k8E8=;
        b=AE3oa+cudM0d1NQYr8qRN55brPWmxcw1sLHyGeGCe2pkT2at1silSKgDotLIMg02ki
         7/hnrwmOtX/okzju5g1s1WCRPj4SSjtUtK0INUBPW6zt9RJafM0YZqeivF0wJSOjPvcP
         LokkHnOb9Nv07j4haYLhABLCTzH4Ou/UDOvVnU5bglWWoCDyJu/TaI7fTNY42lvcKv8d
         lZTDmxb+L3jhw3QHrj/PFd1mLVrnJhvurPbMdUzHvAqlbchFw/7X6hEfP1hyLFvIJmPt
         IMm4ugzzO/rVoLENpsjbIc/AxNvQe+1F4wJ8Seou0ZFCbbdHJENZ/KU9Fi/bZvbMyBoQ
         YSXg==
X-Gm-Message-State: AOJu0YxqvtvWEiFPfPbigcsdoUpzSTb2SGMHWBOA2LNfTz5KDiiX8m+E
	b/jy1RNUwORSLqYjA5VD8bCU4anzz6wuY2rbfM/nXmBRfSEL2191OH6Y9m8ARShGFXpUH4u+6sG
	RWaqIGbWNnSPzLrDrae6tTeQLWe15f2WrwZbqLVT47lomYHCZtkguGACCdhtDBatEg72GPxzL7D
	kfMFn82/SG6V6TAQ+JTY6qMtah378=
X-Google-Smtp-Source: AGHT+IH5f7dwFv+wE8mTQRkVvN6C36JhQ2TRdzqa0Wa1GcfYK7qn3HYMN0U2EEQVyVVwxXKxvWl14NJHvw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1886:b0:dcc:6065:2b3d with SMTP id
 cj6-20020a056902188600b00dcc60652b3dmr3984569ybb.8.1713884795971; Tue, 23 Apr
 2024 08:06:35 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:32 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-25-tabba@google.com>
Subject: [PATCH v4 24/30] KVM: arm64: Refactor kvm_vcpu_enable_ptrauth() for
 hyp use
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Move kvm_vcpu_enable_ptrauth() to a shared header to be used by
hyp in protected mode.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 5 +++++
 arch/arm64/kvm/reset.c               | 7 +------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 501e3e019c93..48178b1c8362 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -599,4 +599,9 @@ static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
 
 	kvm_write_cptr_el2(val);
 }
+
+static inline void kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
+{
+	vcpu_set_flag(vcpu, GUEST_HAS_PTRAUTH);
+}
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 3d8064bf67c8..c955419582a8 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -105,7 +105,7 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
 		kfree(buf);
 		return ret;
 	}
-	
+
 	vcpu->arch.sve_state = buf;
 	vcpu_set_flag(vcpu, VCPU_SVE_FINALIZED);
 	return 0;
@@ -152,11 +152,6 @@ static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
 		memset(vcpu->arch.sve_state, 0, vcpu_sve_state_size(vcpu));
 }
 
-static void kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
-{
-	vcpu_set_flag(vcpu, GUEST_HAS_PTRAUTH);
-}
-
 /**
  * kvm_reset_vcpu - sets core registers and sys_regs to reset value
  * @vcpu: The VCPU pointer
-- 
2.44.0.769.g3c40516874-goog

