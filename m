Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EE151EDFA
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 21:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790803120; cv=none; b=laHPMV3MnjLCig4zuPEP++IBg/+rHQEQZ24WRLzzETyo5xvcjyyQ74HE5voBH9QutN4rMNBHb/uI4CtwcykFNY7z/e5w4xPYeB6pEbW9L1m1bZRq1s1J2vti5FG+z3k4aIhLaCSPsH/RYipeExtg3b8K4UyJPcr4JK9hxFYupd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790803120; c=relaxed/simple;
	bh=D4RW4eqr7X/vrgI4ObQ8n39ajzCRfOk16wd5+OQqtL0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WxU8rGJStroIFhHUFvGnw6zxmXt9OChaDRA1L47bM9OdG7hpBnYwH77qjMXTgUcNi/NqHpWKtpCEiOkPOEW1Etymz3w64w8W735ryuFl6uSRVdX+yRM1ucP+WuBt4pssIESqaYDRqrw1uooAz6Q98Ty9VMhjHAX4nYkRZHTbMWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K2aPwz1x; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K2aPwz1x"
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4b37620eb73so10537023b6e.1
        for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 14:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790803117; x=1791407917; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o3da3ndZkq5JxsBN5E/e/pVYoGrUCtX487+oH/FKdMc=;
        b=K2aPwz1xddiq/D1+JhbWvBxSfLPomt/opWPA5/KPYFUQjAkvaQXodoF9LR9nXwSuR2
         7GUXL4uhmQyvuw6eJEYagT40vOEFwa2mFqz9vjLAYB4DHOUVFS80kS0K2TYsRis6QvDD
         mAwwKJPU/bWSiJjgFWjlSTqzsYCqw9gebX9KLC7dZ5LNO/BnBMHSN8+zNX1nGpbxAQr1
         p4rE92dUdNq2MH7l0DLEZYH2AslJd790cUk+3aChRazqZxLmJn+n7jgzpkKk/BY1VnWn
         U67ErfnUKRJNutu+sS1qKloAEGqvr7Xt/9I3aLxpoTI3xDaRVWNXc7B5d0IfbycCjOBr
         JxlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790803117; x=1791407917;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o3da3ndZkq5JxsBN5E/e/pVYoGrUCtX487+oH/FKdMc=;
        b=dmyslKm+zKTEXUkSXgHN9Kwf90mRq9WFS9Ze5jHG6IphIk6bC5ROyYZEBY8XEO4znP
         vKnRo33HVjqSqPdhbVsPrmzOIkUOUMZe+c/fPGvrq1q601sfLXqehgZAv7asPdDyqZs+
         AUYx1gWq38ViCef4sEJM8p3MVxKvmRti0WLTsjJyU/yUgS7cuWv5qXucTSex5KhGZVt9
         WA4kqPpNz+sG4IW655b5OKQpCDu8pirYy3Q3vqee7rCd9PtPfWDuzSQloGb9QUSAQe6v
         U30VI2R0BMy3PXIkiFUbFTFRxkcy+nSZ1OKvkgquckS7j01YtQmo13H1nzBxnqN66wYJ
         d7VA==
X-Gm-Message-State: AFuF++nUmKrAhqrtUdgYhRtkCPXAm04STXypXsN66geQjE76WDDx6Ycs
	a2iDAvb7TF5//cOe4vI/9azeZ97H0CKQVxcZeYahJlqfO1w/J1Be6kjLlKCl/JfyotbjhI94rBa
	Rs7hK7j7sNpZF3qDmySUh1M30K2CHzuYRf3qzkUsgjLd8nf3+HGKg9kF0Og2wElQHGpKxkGdJyH
	uwg6TRc8Zd0OMxireXy+pQXOGuwGDfvM3waL2znzsTOzLgwK/3TaLfeUgK6hWRG2M=
X-Received: from iobir24.prod.google.com ([2002:a05:6602:7158:b0:9c3:8b15:2c82])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:138b:b0:4e8:d530:daf6 with SMTP id 5614622812f47-4f1b6c6e13fmr3792236b6e.26.1790803116491;
 Wed, 30 Sep 2026 14:18:36 -0700 (PDT)
Date: Wed, 30 Sep 2026 21:18:34 +0000
In-Reply-To: <20260930211834.2773546-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260930211834.2773546-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260930211834.2773546-3-coltonlewis@google.com>
Subject: [PATCH v2 2/2] KVM: arm64: Check ID_AA64DFR0_EL1.PMUVer in pmu_visibility()
From: Colton Lewis <coltonlewis@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

pmu_visibility() currently checks kvm_vcpu_has_pmu(), which only tests
whether the vCPU was initialized with KVM_ARM_VCPU_PMU_V3. If userspace
initializes a vCPU with KVM_ARM_VCPU_PMU_V3 and subsequently hides
FEAT_PMUv3 via ID_AA64DFR0_EL1.PMUVer, KVM continues to expose the PMU
system registers instead of emulating guest accesses as UNDEF.

Check ID_AA64DFR0_EL1.PMUVer directly via kvm_has_feat() in
pmu_visibility() so that PMU system registers are marked REG_HIDDEN
whenever FEAT_PMUv3 is not advertised in the ID registers.

Suggested-by: Oliver Upton <oupton@kernel.org>
Assisted-by: LLM
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e4ad9c171c7ca..46dd6e16de28e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1029,7 +1029,7 @@ static unsigned int hidden_visibility(const struct kvm_vcpu *vcpu,
 static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *r)
 {
-	if (kvm_vcpu_has_pmu(vcpu))
+	if (kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
 		return 0;
 
 	return REG_HIDDEN;
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

