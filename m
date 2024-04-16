Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0E185953
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261415; cv=none; b=nqQYLVNUYUFXXqL16Mf0E/5wlcIvB34fuRl93XsL6LAH1LhUeDvIv1rw2MhHDmXgxUpfHbkfB/JT/MVzkUdmTAnYxT4+MLvfAIZaIk4UYEnvs10dZ9rZGTvXx2uL0RuM8Kql9GEeiFNIoAX1DF7IrZFyD4D2RHXdiC8onU3zM74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261415; c=relaxed/simple;
	bh=xa6DMyUko5/whuGBpVxEOwVg/jScEL2zS2sJV58flmo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I4BKKmLtnogEoA74c04aT/kkNj6PVqO07mwZ4FwVu1DQ7Ly8jSO2VCdIj6g3qWck6/7Or4N6t4p/ks2CvMYnIT9/51GhWGGzVkBHtRyh9NzsZJjcvbvSo2wJc+ZYUXNiifjoc7rplzbyRQeUFn+6BLBuH1ft1hG19S94Fg+JVnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YB90LGPi; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YB90LGPi"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61890f3180aso52294747b3.2
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261412; x=1713866212; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JYjHsigUFEPDFTnOfHEtbQT3t+/x81DHPTzA/9Q+n5w=;
        b=YB90LGPiCl/+ftv0sNXVbQCoXMrvZSezgloKbTp1eFrxhlj6LhZFoASuHKSkFoc9po
         hsTtzQdYSjsZywJ898DrzOe3wr3yDTBZ6m8joEOCA8mmUxV8nDMnLPYxm7beHLVYaTql
         FplodakgXh1nCbRj9/nfEMAnxFuQvbKeT7t1S3PzNB4pt/H4kpyrIN4L6EVHgAsjAUOZ
         ebCCHzNiibAgYOMTZHCwGEQ5dKkED01PpXM/G60RYrSTyoEKE0IUrsvLHjTLkWHOwDXy
         Ae2+fqPeR4+vfhM83tuL659jGrHmDKRuHgWI4umFG2x0RQXjQ/LYh1q3oub9+uE/2wWE
         XMLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261412; x=1713866212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JYjHsigUFEPDFTnOfHEtbQT3t+/x81DHPTzA/9Q+n5w=;
        b=mwa5BUK3k0JzTQ3JSzjmw68oXMJdJCAGViEnbZjNhqdF9T0qQP9Q0k2nc09qSm1Het
         jS/zStwjq/jkfDTRihisFznVbufaO6UFYMJfyY+Wxmrs6XMUFPspUlQcQVXdQtMTaXEO
         XqBniGz+2mG9mh2vjsX80/ZaqpEAoCSRxAUP1SCsXA8M4w1FGoOgAfSn/vzrypBlbjn6
         7MpdfhXgpha0z+Gj+dVq2LhjqV5+nIK4JOYAOpdFd7o1T5e4N12paGfz/uD5Kru+PldY
         KcsEKVuMv5IidLoNt+Ru0ykRHMT/LBE1mzEoXMxbkYsLzW9vaZircJ2jDiDPWDddXA2c
         mCyg==
X-Gm-Message-State: AOJu0Yxeolp8BcOZ70fqAiQaRBb1VqYvc82V8ABEzDxa+gCnYs/MdONK
	bafyNEQJrUXBD2sQ6/nvO6/h22pqizxlls7mR7NyalXu1sdBzbKaPdqqUHq5/itx8EIRlXP6/vk
	j75DWoFJgOsMAlnfY+J7QP7ifbhSdEA3y5HtbX1GUzek6k1sb4i10UtYn9cnyW5NNRK5tqQYwjH
	W7DzAv8ZYcdQiWIWOSCFllcfEJ6Qw=
X-Google-Smtp-Source: AGHT+IG8fxtZAMDeZqcgi3A7Tl+6D6NqQLqp24T0bEjOM7BnJ1/96CzVwVUntU0L6IjO9prT8iOR3XgcAQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:350a:b0:615:44d5:f6f8 with SMTP id
 fq10-20020a05690c350a00b0061544d5f6f8mr3477448ywb.10.1713261412453; Tue, 16
 Apr 2024 02:56:52 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:55:56 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-6-tabba@google.com>
Subject: [PATCH v2 05/47] KVM: arm64: Fix comment for __pkvm_vcpu_init_traps()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Fix the comment to clarify that __pkvm_vcpu_init_traps()
initializes traps for all VMs in protected mode, and not only
for protected VMs.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index ce88034540bd..6cd12ab389ea 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -208,7 +208,7 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Initialize trap register values for protected VMs.
+ * Initialize trap register values in protected mode.
  */
 void __pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
 {
-- 
2.44.0.683.g7961c838ac-goog

