Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C41A394794
	for <kvmarm@lists.linux.dev>; Wed,  3 Jun 2026 11:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780484597; cv=none; b=g5nEDPl1dPIYVCrazXcx6GioWph/3RsRelPZwXmv1+n0DVQu2YtmoTcSmZyj2gOwXDRIApjkwF6l3EQwO+CrtCFFCNTJEQlUq5dO535g6SvbJANg9U/G5eL/5o29S3KT7wLTn5G38S/+VtXX2779pvPOMQ9bVEsACNoce7vAOY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780484597; c=relaxed/simple;
	bh=/xleFPE3+Whb53woPB/pF/seqNXUuBFwmf6d4ZwXmbk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=MyfvnAXVuV7KU/mfdJe+xJvkMMAonMssBObtduq2AMWC1Dt6wO/X2WkSRXCGkuqiNN/UOr5A09tSq3osTpF/Aa0Qlni6UnFlnq8X4ZjZeJQFsMsYLkZd7OVS+yKK+VROpbxBhRMiIR1jIPcnHHv+3/Mn0O6tjaMSnmPi4ClXPr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YKVxmxIi; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YKVxmxIi"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-45ef616db45so3172294f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 03 Jun 2026 04:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780484595; x=1781089395; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YM3OgQYUM4wpN2ATYj7S7HcuVfmqgGkKpiwqvbUC2NY=;
        b=YKVxmxIi8soQYVHNr12c+qTq99d4uSHdAQJ+fiL4TUhEpaXOXruzDm3G9YuqSGEmiS
         cwVk+ga11ljvw/nUmT4RtVlGrEXRFihkpV5bh6QOn33PEDw2VtpnSCwHCKM6ydynWQqp
         INX5yCNGr/nR7O2RUufomL3osk5t7R5Yl641mgYXFdoz0xTwQZLmNnrKbA7/g5b7JE3e
         d6ZetoZqQVHSKCUqaee1spgLqZdpCTHd0AoqwnQcq/GjKnmku2DvGlAlxrtEXoy7pZWx
         Q1z7T7ASDjPbaFfw0VGxvbKvvfWadqgjHLWuvCJqLhumcmDl7oOLKV8cF9oBVQPAlrL3
         Yokg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780484595; x=1781089395;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YM3OgQYUM4wpN2ATYj7S7HcuVfmqgGkKpiwqvbUC2NY=;
        b=Jria1gPT77s7Gw37ts5mhW1/S9M91K2ddT3ZW8+D9fqSCeD49i3yT3VOhAD+2R2xXi
         bJfOyl4UEFJCljLpmBYN+g/+Gfg6YF6uN6WragF+wt1s7hi4Xl0cjixKnyYx34lrJDki
         09T/YHSI+2twKWOsx0nnlFOiWIL0EjJe9BHYb30dSphUBF8Q3WLWa4V7LMSHq/LcR6bq
         mMa5nuihHY0tEtRbLul8F6X3IarjvUA84XyE7OZBh8I2vdMdyfrgpVuSyU9eII9Zl7kZ
         NNFqobmRf8z4zX7pb2eNaKOXLO7J06Y4w8TK+7zcuBlJtVbK3bLqSQOe5gQiKfvjs4dF
         ni7w==
X-Forwarded-Encrypted: i=1; AFNElJ/xM17C76X6Di1scESe8SAzvhMU7h+ZjdNtE0Amjd25adm4smlJQasI/2vcupC3uHhBcxOWkcQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxMR7TenB0s5kxrrORpEw/DmrV/dYkoD3Zg1D3oXgZt/7dHqkJY
	7OZKPOVx3so3HVdd/fqvwj4FMXjemnU4vYLPJ9uQUnujzrw0VPRKstPyPMAzztXCRqHR0fNTu/R
	DNvEEJC4C/CSW2g3DopVtxA==
X-Received: from wryf10.prod.google.com ([2002:a05:6000:1a8a:b0:449:a64d:86c9])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:4bc7:0:b0:45e:f266:f4c4 with SMTP id ffacd0b85a97d-460218433c0mr3010157f8f.29.1780484594559;
 Wed, 03 Jun 2026 04:03:14 -0700 (PDT)
Date: Wed,  3 Jun 2026 12:03:12 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <20260603110312.2909844-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: Set a linux errno on SMCCC error in kvm_call_hyp_nvhe()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

If the HVC called in kvm_call_hyp_nvhe() fails with an SMCCC error code,
we WARN. However, the returned value isn't initialized and the caller
might get garbage or 0 which is likely to be interpreted as success.

Set a default -EPERM error value, ensuring all callers get the message
when SMCCC calls fail.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

---

I have encountered this issue while working on a follow-up contribution to the
hypervisor tracing. In that case it completely crashed the kernel because
IS_ERR() failed on that res.a1 value.

Now, if it makes that function more robust, I do not believe it is fixing any
existing bug which is why I haven't added a "Fixes:" tag. 

In case we want to stick one, here it is:

Fixes: 054698316d87 ("KVM: arm64: nVHE: Migrate hyp interface to SMCCC")

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a49042bfa801..6b8fd494792c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1273,13 +1273,14 @@ void kvm_arm_resume_guest(struct kvm *kvm);
 #define vcpu_has_run_once(vcpu)	(!!READ_ONCE((vcpu)->pid))
 
 #ifndef __KVM_NVHE_HYPERVISOR__
-#define kvm_call_hyp_nvhe(f, ...)						\
+#define kvm_call_hyp_nvhe(f, ...)					\
 	({								\
 		struct arm_smccc_res res;				\
 									\
 		arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(f),		\
 				  ##__VA_ARGS__, &res);			\
-		WARN_ON(res.a0 != SMCCC_RET_SUCCESS);			\
+		if (WARN_ON(res.a0 != SMCCC_RET_SUCCESS))		\
+			res.a1 = -EPERM;				\
 									\
 		res.a1;							\
 	})

base-commit: e43ffb69e0438cddd72aaa30898b4dc446f664f8
-- 
2.54.0.1032.g2f8565e1d1-goog

