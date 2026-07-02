Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5716D3C0621
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 10:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782988763; cv=none; b=dotu+tKeQlVMnHhW/zipdFRhznw6kriVBfXLD8hA3B7ENNby7FcBS0qXQ1b348FWNF3wJLnPhcS5O4Vh9Q3aLQYZgPTYvYkLWL/jJ2maavaEMdMwfzsrg+35lnYN64HzdaF5JcHkzlngsS6EulYy0YOpU2GJddHpZ3AU0Vvatk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782988763; c=relaxed/simple;
	bh=mZQwFtKmuv9JtN9Z5Z7PUOwhh+Ry/isHxQ86Gbb1Aoc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kHgAQWeBX7q2TYhnurzsVCGgFQgXst8ZI7gzyBeYas28HiH+LjHttmqK8u1BejdGI38IZLRFmxlB5AgNSF4o0xkz7r8mFj3cNl2Sk4GYst9HVikrgQnkpHkHshfIX7OED3W+gv6+KkpmFFDxrSPbB5JSQTXYadxCvwMJC4q3t4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gWWM0aWG; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gWWM0aWG"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-493c47a09b5so5683995e9.2
        for <kvmarm@lists.linux.dev>; Thu, 02 Jul 2026 03:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782988761; x=1783593561; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Un4RsCE8ClG46waU3EoWIfi0gOM5MfO/J2aFh49A2VQ=;
        b=gWWM0aWGm48Chnw3UejOBERhGr0JFWMkgqiST4skbMZfxl9rQL8tNDLAgG6RcuUGc+
         daBodsWuPc+lxyZ/8NjvdTsDy9p7xQCVD6L+06p9Mk7U0EdFKU58Lh1SKxdp9op7Jv7O
         pxXKQ/XtvB7l+oOH46gOKXH3wRakDcAuL4ISgJt5V1byw08MA2KJSoqTs0caiC8N0iTq
         dDhq3MhG5FJ9os+CDvZv3ohoXib9xFy5kMrfR1/o/KA3On2wJokXjBrL+uAsgvIEpXIS
         w2fa5aYAOFuKO5ZBe0KAdomCEMylJb0KnRMueX82tFyNJSIdMrc05c4KD+A1XJVU1R1i
         Bndg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782988761; x=1783593561;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Un4RsCE8ClG46waU3EoWIfi0gOM5MfO/J2aFh49A2VQ=;
        b=HkUyxxU8BeZpFarAXSZtGzWSotpZK4QMX5gRJfdNLdjTzs+HgJoLYZPMcgUNRvfPL1
         qbKDkEPBVnnUymwXQnLwXoWyC1R7iK/jxKNI6fHUR1AyipA6DOWwbKJ/VELR6x3OmMAG
         nH4etFaeTqBIJsvjiGJTjJr8EL8wID/hzfqwZZ51VO4bZ8kjntSvcUDZwf4VJ1AjljIH
         6Ieb6/oHGc0xSzt7IIGyltrjsEm+2fFPKF8FztKlhY1HMJ5LecC0LjLu6oF55J0Y6cGl
         CpLrqNnNCP42w15eccTT2By6mRLGlbw3TluHlZ+BokkMlOimT75IaulwOBF0MH/TTWD3
         RhjQ==
X-Forwarded-Encrypted: i=1; AFNElJ/MQTHy1v17eLxRzppxhzFQ3sw2nWhLfqwty3dcFX0zy35yQxp56eAX5k1T+TAPj1qGlTkMjfc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzPgijIhClzoYaJBNrLiLdObSdpSbM4khkr8Dju59cCb6yUK0nX
	au6cy5e/I4uGlW5XtBFCdJbSb7lNzkatz0vzKwpoEuJIF/4BJ1F8eKZM1D8aTvBvc7TSRCdgCP4
	I78Z31TJqUr+0Qq1kmQPHGEkZXJVV9Q==
X-Received: from wmbjp19.prod.google.com ([2002:a05:600c:5593:b0:493:c562:3fc6])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1594:b0:493:bcba:46a4 with SMTP id 5b1f17b1804b1-493c2b7dc45mr45687565e9.20.1782988760577;
 Thu, 02 Jul 2026 03:39:20 -0700 (PDT)
Date: Thu,  2 Jul 2026 10:38:43 +0000
In-Reply-To: <20260702103848.1647249-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260702103848.1647249-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260702103848.1647249-7-sebastianene@google.com>
Subject: [PATCH v9 6/6] KVM: arm64: Zero out the stack initialized data in the
 FFA handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, oupton@kernel.org, sudeep.holla@kernel.org, 
	will@kernel.org
Cc: jens.wiklander@linaro.org, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, maz@kernel.org, mrigendra.chaubey@gmail.com, 
	op-tee@lists.trustedfirmware.org, perlarsen@google.com, 
	sebastianene@google.com, seiden@linux.ibm.com, smostafa@google.com, 
	sumit.garg@kernel.org, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com, Sashiko AI <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Don't leak hypervisor stack data when using the FFA_VERSION call.
When the compiler doesn't support -ftrivial-auto-var-init=zero option
we need to zero out the stack initialized variable before returning data
to the host caller.

Closes:
https://lore.kernel.org/all/20260616160016.C62C81F000E9@smtp.kernel.org/

Reported-by: Sashiko AI <sashiko-bot@kernel.org>
Fixes: c9c012625e12 ("KVM: arm64: Trap FFA_VERSION host call in pKVM")
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Link: https://lore.kernel.org/all/20260616160016.C62C81F000E9@smtp.kernel.org/
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 9c96e72e522e..a327c2bbb6b6 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -880,7 +880,7 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
-	struct arm_smccc_1_2_regs res;
+	struct arm_smccc_1_2_regs res = {0};
 
 	/*
 	 * There's no way we can tell what a non-standard SMC call might
-- 
2.55.0.rc0.799.gd6f94ed593-goog

