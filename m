Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E5B86250
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261452; cv=none; b=bCRXSJzGesA+vyr8YGyIEmygvsLBJ006+80fGzu7E9/u+Av7lJ6juqog9bLd/BDeqMzLhiVztU7FoPbjLqYqQQsZeVsIdGIbDmjsvLuTqG52FhEeZ6+Ik3o5MaraWulHbrLA66I4ZItU9n3WzWnN55SNBC2jEJ3mO0nV5yRKGoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261452; c=relaxed/simple;
	bh=MaW7/tIV6be41ykMCQfTvfybTOJAVY0/U5lglhmoBq4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V9PUjR2BeTEc8GuV4ZyPMPGXSAPlgDPavKTY7zXhcTV1ifzDr9RM45Ud52uC2HR9+RrREmYZuQHRZr1talZHCrb0xUDVI+bWbLB+jRwsixbpUXCyvHswLn7j6fw+XCiqXvU0FA10qIHXw5rFwdtPuf9hkFm2r88AQ8WbJ8HqSE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q77sKW57; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q77sKW57"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-347ddb973dcso1149356f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261449; x=1713866249; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gFMLIKGgvklMLYRC+7Hle1b8n32RFPEycLsP5Iq22Sk=;
        b=q77sKW57mkxeViIYAGldAgCd5fQBAHyMIizooB6n/jZjIEtAfhuvq70rb9cyNLcunU
         qvdO+kq1Op75d9Bz/0laAEq9xK3kdkHlk+EqfOaakt2dRiMDwt6iYRxCh7TSfKoG6PZ/
         Y+V+Fkgq/qSP95iXMm1NGdFYBUB2rFfBEH21U6JKSgOoCxFFijo9XZD9glLUJ/SNQRiv
         mD2wJMW/7lRT6jAJOZEgWpVb6QS+dC/EfBQan0Q2+TlIL4DWHk7xmna1MiWQYrhjPv7O
         ++jI1VDEt1vrq93MHk9xvWURM1e5/CgmlMlP0jMOnqLSDvzXvdKGtZIq7c8Hj/98GR0x
         UGSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261449; x=1713866249;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gFMLIKGgvklMLYRC+7Hle1b8n32RFPEycLsP5Iq22Sk=;
        b=OonTHhH16mR6hpSXuWWiDZyepQNj2m5RgbXY3oAwV7VVjMmgZvoTVq5K1qUorlR8lk
         FrHqxW8bbb/D6Dt7ENyPuoxj30znJN6+eLkeM0pvHGvb4C8OvD0puucAzH7J4fvSswjx
         GgHi1cjL6kFQQtwdRgrkUF2tmiP5jR5GVTl6sTalJJq1jcFCXREI6TVT3Vat4ygGLHtD
         4NlHuCLWXZlf2910wjOBElhMA+qpJsvDjZpz8m2cis4d+FwqPoXx3RSuTs2OZUyaG/0P
         atbDK2qFfL5GcnjdoOyYB7eOTj/+AWFxHH7BBGSeD2kCXWVMWLuB6qQ5UZYylPZWJzxt
         oWfw==
X-Gm-Message-State: AOJu0YzHUGRkn7+3vLBLIbCVlz4vLdaE5il2mAjTTiCRkHx0toWqkOBn
	J0uIVMG0nAat0mzSX9h6cf4rhCnxVOuv5hr9OR+22Mkcc4V9yozn6mc3MVQeFKFtvEz428gIXC6
	C7mtbOzV+vSrZdwgRb1RGdpFfropAJMiHR8CSjghdXRrwvILIrnDuOR7KyrzVuUS+RI6/W86M6o
	QcRfZJld9bTq+HaYdwqvGxK6S6+TE=
X-Google-Smtp-Source: AGHT+IEZx35612HQNp5u/EEhzOI2/Q7388pk9uAitek3VIQJXQs8nKkT2+QqkRymQK8dG96fVE3ggXo5Sw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:e2c8:0:b0:343:c35d:13f6 with SMTP id
 d8-20020adfe2c8000000b00343c35d13f6mr21629wrj.10.1713261448750; Tue, 16 Apr
 2024 02:57:28 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:12 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-22-tabba@google.com>
Subject: [PATCH v2 21/47] KVM: arm64: Refactor kvm_vcpu_enable_ptrauth() for
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
index 3d65d9413608..7ad5fdc34ec1 100644
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
2.44.0.683.g7961c838ac-goog

