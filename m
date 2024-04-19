Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A58D46453
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513641; cv=none; b=ob78UwGpwzlHFmh4rr4Bg4M3KLPUBqZtNUF36qWBLecz4ss9wWSLGOmQwMxo/vtKo+3F2vdfZ7extFHgVzTlf0VzcVyqpWz6prZXUFQInqEg/GWAlwJRQGrnMnKjAwu3hvYSyP0YMAOlvytJ14ePIbBRykx7HnWgLeW3upF5GQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513641; c=relaxed/simple;
	bh=WG6TFudIAby3QFM0aSRpFJl+RV1IxOjDrIfmazYiYic=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K+YBVkIAfUl8RPesNcFLL0A8P6cY+B7RIGGRthVXOdTH66/vATEwpNIhTyGVxZSedSLoN1fU3MYP1tGn57rw2FqNJlayvaaX3bKF99G0WeVBeSkvgaYXwnfwXWFmvfYwAkgHJbColwM1ajo2Xq2AsjxNCKHu4I/zlAEPP5N5GIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lmj/BcpN; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lmj/BcpN"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4155db7b58cso10018135e9.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513638; x=1714118438; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=taYDVzz9jxXC9Xsj6PRdWdCDDhB4WpzBTdPaVZili14=;
        b=lmj/BcpNjyyIyiJnApGtpsh/Uvpxe5Y8NAdXZSDDLfyv0v0mWOC7AnODSdxjVzTGCv
         81VwnN7Fg8QazMK5ybKFrNFnDcUK8LIFORR2NQghGPkQ/3tYGuQHxkH5+2p2UqLshPTI
         M+2MSldtxrgQCkpHfXf9Ug/BHkTev9MAKHk58TmOFpqumyAhKm5TwsGlYIcVz6F6ThQS
         sm9Oj/L8hfJjOZ/lE+JzJn9e5VA1e6gV4N/fJhUfQP4ZVILQH7m9/Ezti94WFxfmChcZ
         R3vHpAg2wWNFyS51YNhgtb4yWm0yAfwz5AoZEOJlcHjvoPKuNWPk2kDLuu+jgMRIDu7M
         qcmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513638; x=1714118438;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=taYDVzz9jxXC9Xsj6PRdWdCDDhB4WpzBTdPaVZili14=;
        b=irmZkQA+uHYgomOO8aMbo66stOpFKreASXxSzWzjKQrW5KM/cwrHQLK1rQ14CcvNOt
         ZPLEwIWQt8eIGBIDLxrioOhkkkiWMPDQwmCOKVbyYpLvIZUamE59AG4gkVrXU+6Pxeqn
         ZnUONntBfcIrMpVSiCfA3HirT0C0WSr/SrDyo8vOeKZOaDaTp9mC/CpgdAWSeY9f0zZj
         y++kfnrvUrLFsX/NnYq9oH9TkWJ66SMV5BlN+wX3RXdD9xXc8atv6W38uLK9umGp7SO4
         D9LXrC7PUMHzVEfY1N+TcrCLKq6RXn3iSkdTyGAWCjuslcNv1nXD2fRp6EsbokBVR8sr
         aAZA==
X-Gm-Message-State: AOJu0YzniugVHjCKQgMzWVcXdXAlIfRSCH60NgR0fzPfhC8EKXc6v9pe
	6RAizZtITk/38TLYMAZ94YdkdPIfWIe9H8Y7WwCZHBKFbh9EEcUpExb1Xy7T/hXmb0YKk1cEdyL
	TstGWT970laLAGfjMlqQjOk57ncfQsPlcFLJVfhXddAFbXqs0uhs1Vcw7sDJIKGk1++42tAgqOv
	Fqqv/2Rm8T7LNSywe61TNxT26SsNk=
X-Google-Smtp-Source: AGHT+IHVBLzrSLFb+8bm+s4LekZ285NsjuPBfu9CfFewL0zGaCwHBjy/Z9a2YmCcdV0/CxieoEtttL/Tiw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1d26:b0:418:ee2f:cb8d with SMTP id
 l38-20020a05600c1d2600b00418ee2fcb8dmr4598wms.1.1713513638398; Fri, 19 Apr
 2024 01:00:38 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:34 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-25-tabba@google.com>
Subject: [PATCH v3 24/31] KVM: arm64: Refactor kvm_vcpu_enable_ptrauth() for
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
index deaa88b972ec..43b5d51981f9 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -609,4 +609,9 @@ static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
 
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

