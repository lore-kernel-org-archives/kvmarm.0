Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECBE3E485
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513625; cv=none; b=j7E8aJg5+ZY8RvWDE4o2rA6AMPjIhZkRiyG836tiyRfyzNjapwHcIVhBHBhTjHufgyXD9Tqel1zWFdhSwMCDKdsdO/tLYBb4RhZGTPqJvuXQh+38Btck8Tjty8fcv8cRT4w0xU8hnHE9igSR3J7WCzt3cic5egHW5nxSP9M3b60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513625; c=relaxed/simple;
	bh=Gxr8b/0ifmxOOLSmLMlwN+FmH3Wa6cC5DT0CyrUoERM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a/NAdUGYJNmNW1VpImFrzWf6pdxINffAApuNEtXS/KozU8JQ1X8PCpc0VRcnAoyMJ2CR4TL1JUAvmqdO041/+5D0eh2xptZs7wW5Nf7Wc8jtPgRQBTJFTySf2wCqGU1WHb2h0xGQb5H99jvSVlYgT08xs6N9+fZwg38uPU2L81g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LqOr4IES; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LqOr4IES"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-416ac21981dso8592175e9.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513622; x=1714118422; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=spVyBK1DenNowX84dGQKXXu4QL2Afz95gZfImVRze/s=;
        b=LqOr4IEStAzxIjetpRoRDS5pzvDKc9QKKqrpOmVnASbH6T+9JGLcmuQKurOiLgD6yI
         7a7Ow2mbmSyM9jpFPQdUbI0mc0rdn7bENmNmItNgDTyQP1rrp8iQcrS3cUtmsktT/dJP
         KYbDff3JTOTaxkdvYVbTjG6zANJeXFwlFITdRq+vYf+2fFdKlvErok5hDeLy/QcMd/ua
         VM89jPpXw787khtxKdM98Fx7rWvg/0iu613WgVRNuAnVZfsdrmLxrsKEbN0s34+RVhiq
         3xWAuk8KdIWssPBbSN1p6xeZfAFGYTY4xxYwUrUAzrmL9WzjX47RX/lLgtpwJPNe2xEu
         MF6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513622; x=1714118422;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=spVyBK1DenNowX84dGQKXXu4QL2Afz95gZfImVRze/s=;
        b=QG0sr2KgjqYegNf5VzT5+w+V4Us6+MfbcxzGtwn8b8ZIldYa7DjHvzaALolbOe+u98
         sqFM3pklMsF7IpUX+glX3avj7lMgdLrut2ro6iJ/MQQvMTowRuEl3MWhIDrGTkpcS2PP
         v59jd5zQqExJle/kZc1Tc5CSpnmNZmmMOYxm1Vvb+YrlGBTlr+Hk/pkKjTxZOaOR4L8C
         zuFBhsJ+L/p3Iu7dds0L2HqGj8VCwvTbxgUJYaak7n5R4VZjNxCoRO4eqNDupN6Gakj7
         2TIo5ftST59QpMgNqht9UEqIn1/KpryWWiiXUn/HdV01J6bhM8OBDmErDDr6iCjzUevG
         FCnA==
X-Gm-Message-State: AOJu0Yxrp1GxbWF1rO+rsPLM+eC4y9kVCi9Ck/CmgAIbPevYKaWIZARM
	84PPV8/f2Js2BiCSQgHkfdM6FoYc9vC5vqBAKGa77dcV5RD5pm4Ys7lvYTjxHeI1ZGMLd7vwObz
	pfrAFXP1TSTACvV5ZI8I/g0Q+aM/nMik3usesbH5H5wYMXlVh3GiM0ibpypoOfzBWjJl8MqP8l3
	eiHQS1PC937VCjSWTRTin1YilmWJc=
X-Google-Smtp-Source: AGHT+IHsy38Kcf6HzYcX5lhDdSl7k65t0oYj5AU5BsaK/pSK90N+REHWG7W+pCJP8O8veEY9IDUGe/ryeQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:5644:b0:418:9a5b:d68 with SMTP id
 js4-20020a05600c564400b004189a5b0d68mr19798wmb.2.1713513622193; Fri, 19 Apr
 2024 01:00:22 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:27 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-18-tabba@google.com>
Subject: [PATCH v3 17/31] KVM: arm64: Add is_pkvm_initialized() helper
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Quentin Perret <qperret@google.com>

Add a helper allowing to check when the pkvm static key is enabled to
ease the introduction of pkvm hooks in other parts of the code.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/virt.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 261d6e9df2e1..ebf4a9f943ed 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -82,6 +82,12 @@ bool is_kvm_arm_initialised(void);
 
 DECLARE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 
+static inline bool is_pkvm_initialized(void)
+{
+	return IS_ENABLED(CONFIG_KVM) &&
+	       static_branch_likely(&kvm_protected_mode_initialized);
+}
+
 /* Reports the availability of HYP mode */
 static inline bool is_hyp_mode_available(void)
 {
@@ -89,8 +95,7 @@ static inline bool is_hyp_mode_available(void)
 	 * If KVM protected mode is initialized, all CPUs must have been booted
 	 * in EL2. Avoid checking __boot_cpu_mode as CPUs now come up in EL1.
 	 */
-	if (IS_ENABLED(CONFIG_KVM) &&
-	    static_branch_likely(&kvm_protected_mode_initialized))
+	if (is_pkvm_initialized())
 		return true;
 
 	return (__boot_cpu_mode[0] == BOOT_CPU_MODE_EL2 &&
@@ -104,8 +109,7 @@ static inline bool is_hyp_mode_mismatched(void)
 	 * If KVM protected mode is initialized, all CPUs must have been booted
 	 * in EL2. Avoid checking __boot_cpu_mode as CPUs now come up in EL1.
 	 */
-	if (IS_ENABLED(CONFIG_KVM) &&
-	    static_branch_likely(&kvm_protected_mode_initialized))
+	if (is_pkvm_initialized())
 		return false;
 
 	return __boot_cpu_mode[0] != __boot_cpu_mode[1];
-- 
2.44.0.769.g3c40516874-goog

