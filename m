Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7B014E2EE
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560981; cv=none; b=bub5MqNEI3sFsOMKJvcwQE6IH3AHS+v8naVNzfMeO98pbxDiOsNIKTfmeDvRkAO13feVueC1POIpgr/SvKXHheKT2liev+L128CuPOUZkF3q/qKIAQj9q8r4t1AMtkk4h1HrZ8a+ebLLagwRWeOp6UjkqJwcfsf42+4TR2+u0HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560981; c=relaxed/simple;
	bh=QeqjSAFagjGSr3PZfhkZ/L5fgvVHkkFIzHrXShef5Hw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VuqJRxi+VPCOlygts4FOXrbr369Zc207GmBX7r7aQOFc1EWEXxPIuz2GAelP1orGSwvOViDDfyoETK7TfgOEwzgRkz5SD/2ckjIvwQKwJ93UnsyvYCNlPb1iAlBOEqHCywymNIdUuJr3S+QAp8kjieQEcWBCRq6Mf7QhPIlVIxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T7ZL2PX6; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T7ZL2PX6"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3417fa3f143so1858381f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560978; x=1712165778; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KRV/GT352cFBxZqta3oYEnAYe4JW9m0h9LPYASc46BE=;
        b=T7ZL2PX6lnQb+tvTwhfg+3+dqB2W1G5hGVnM3nsQFoklc05BFLFt4AA4B0QJF1psE/
         Y6u3PSMyGDMYtJnAj2mFzwHOJcKvgxuVuHjjLXtGqfmTg7c2DTPgWdioBBkMouTGvLYy
         s1odju/n+Nq8WLH0G/mD0zuxyyw+yQYj1+UEw3+a5C1goFh0vh+Fvwc+v9WGsuAKBAr6
         cMy4U35vOUPnOC5hiCEADWzHHUV+3BHhzOVryCYAduO5KWknx0Pp+tOSinldBX2CBa+U
         IDIKiI2r3TZeSuKqcfK1sI1+0t+l4OGG8w24dTZZbbDNdQiMDupYxuxqyJF3BopQV4sc
         P47Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560978; x=1712165778;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KRV/GT352cFBxZqta3oYEnAYe4JW9m0h9LPYASc46BE=;
        b=vJ605LFfXZ2OPyFkyV/gGeUltc3Sw766oG+YnXmFi2DquqXyd//UccQNiXbBHfyEYs
         skNsfAUOx+XaFujXaVXB7dkYcRBebZw4WGq+V24S+X3OQmXvLIgHAGEB5LfTZPFEhDPO
         t/V5XzoWGixQf/iXbb7TNZwuL7OJsf/DLC5AFpkiwh4Qy/PJFCNARaEVy/wJg0k6eNzR
         o2PTjYPgSvNfAwTNIdnm92sG2r4lE8VfrvXDx9g783zbcQsco/ZDMQMKEIS0lz/4uj9v
         0j9Xat4d1blKTltyvgJjJV0MzNxWD2o5rq9WasLpIbxNlwrAMkWhlitgo0xhFJlaLVo2
         GBHw==
X-Gm-Message-State: AOJu0Yy9G9Ba9AfxUR2BHFER4XZYKfkTxYyBVklA6/LYWukIN2SY0xUu
	fnDUe7v+BdP2SroCRmEj0KX4zDIqnSxfQkq17i1crC5yPzCp1XDfMf+cqbnVxA1Bznog4APIUnz
	jhQztPF4UZAJWF59j8UqVkKlzTutGQtB+4zlGhnbRIEDH7VOaHBZF12sD6sUAvX291QQ338E9F6
	q9gJ8IpcbwmhEuSa8L8ihrlmmgzA0=
X-Google-Smtp-Source: AGHT+IG4hVDYG6x+oDVW38NMzBhZnMY1ImI0ErW42drIEghxAE7s2Bo8SLfV7FTgbqWovErMcqTmPBF/Bg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:9c91:0:b0:33d:fec5:2fa8 with SMTP id
 d17-20020adf9c91000000b0033dfec52fa8mr120wre.0.1711560977829; Wed, 27 Mar
 2024 10:36:17 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:06 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-20-tabba@google.com>
Subject: [PATCH v1 19/44] KVM: arm64: Refactor kvm_vcpu_enable_ptrauth() for
 hyp use
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
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
index 975af30af31f..dcb2aaf10d8c 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -611,4 +611,9 @@ static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
 
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
2.44.0.478.gd926399ef9-goog

