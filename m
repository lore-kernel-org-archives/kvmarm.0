Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EEF14C5AF
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560976; cv=none; b=kDUQU6Pq7r1qLQIbUmiBtzhGZmu3a/CnLBOzIrddMwjAxMKyOD3XZA3CWaLQ4Mih0LK/e3Wi2LM08GiBJ69Fx6Y4/NApnaPaNmbNv3wGAMlAheDVGpD/WwHYb0Xj0VueHoXf72cyrH6yXkLoCTBr8JGGXfpZ0zrNmh6tgq4XtJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560976; c=relaxed/simple;
	bh=Ehw0Tp17m5M2PPjEkmL0ZW66P/N/ZC9AJQumTBbTU2A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jdOdsY0aEO4QvHMTEBF87G9k0BCCRGLmW3k94P0yaHtNr/Cs7dsJ8/AMb9A+jYPORjY55kS9DLzN4wQdl7pqJaZwKDt6JYw37eV6fHKd2J021Yw3UGVU5v2fyG9cYN3L+BGmwUsoIRKPpkdgqkWiabMhFlo6Dka/HRpVSb742yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mbUxfEux; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mbUxfEux"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-33ed8677d16so1580f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560973; x=1712165773; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cV2tiNaNebfczNXZYLxmKmBOqX7qxHeVMnCHhPtYPqs=;
        b=mbUxfEuxpuiORwIx1ixb9US9MZI/13406cDOfjzZYC6BWBOWPsMgpbyuXtcj5twGJW
         fWAwmcOIFjtb3VvxyRKFuhaMFmD0vEF1RZBDafGcgQVGEuDSkRaBMNQXXrG87/jjoops
         jdt7mzcI9XarLaEEf0n8zl9QSlEGyjRc/BvKFy4RvC6QfWzMA9wOQiCVJjIEgaKUvoGF
         SNhDqveEm6m3Hjzzh7gD7NFYlXs8nf93dvvEYLKVpBRpKcAtOPo0gVOPowWuemCGz2TX
         AIPHCITmwAOA0Ajp+Rd4phH3dyWy9MiRdPzUD8Qusnn3nLorPbY321MGwRijTK/JKGXc
         2QVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560973; x=1712165773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cV2tiNaNebfczNXZYLxmKmBOqX7qxHeVMnCHhPtYPqs=;
        b=rNhyTAQolJTeVh15d4TwXxPSyXjopz+/RfAHdSamibApBLi8KEDTvadhmEdHpq1ZdS
         /wVK6czkfYb7KQwzD6r98xRHR2++Ehy4FrMV4eBHasYeUTCx9wE4tjo2xxMnVZvPVm29
         O9fVnXCLoUwyCIBDl4U77T+1wEl18ubOixypENPZ190s4mG4X7uHqMkX8Mq/rBexuxyT
         bhz4IKNrKbRhlIbsuR6k9r1PDgrf+oSPU3wxCkoi+79NgAjVr3gsTd75bhiMtDzWLE0D
         O/rRSviRVpuVWKSwTCj6LjuK6CzshvdM26tchNvwuhuhTchHvZ7+t0YY4xeOox9ZT00u
         GUqA==
X-Gm-Message-State: AOJu0YwUcjggERXTKOCs2eKEVS3jxmZdYRs+RgqWeOIphAOcj3o6mZ4V
	FX2Mz5JYhAp6HMEy6Q2oWzc0z73zHJ+LxtMkVGZZ/kTsv9a77idcug1KqbckeJ07x+4PIsdoH85
	QRYmeBsZoQ0u5BJ30Y6kp8k4t0AQYJZwF7d7POHd3+CuJnOdu4rAzcqiLA7IaHCii7f7fXo5nh3
	yPDn9pHy91De3whX01hz0/rI2gyPo=
X-Google-Smtp-Source: AGHT+IHKiTD6F6rpbQdQgzAI4NanDD7A/F65L8d0SlZ+KDswF1lZb+Bq6f22eoGqzHDUgDYzDwfQieFwng==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:a447:0:b0:33d:fe8f:8c46 with SMTP id
 e7-20020adfa447000000b0033dfe8f8c46mr74wra.3.1711560973345; Wed, 27 Mar 2024
 10:36:13 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:04 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-18-tabba@google.com>
Subject: [PATCH v1 17/44] KVM: arm64: Move some kvm_psci functions to a shared header
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Move some PSCI functions and macros to a shared header to be used
by hyp in protected mode.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/psci.c  | 28 ----------------------------
 include/kvm/arm_psci.h | 29 +++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 1f69b667332b..43458949d955 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -21,16 +21,6 @@
  * as described in ARM document number ARM DEN 0022A.
  */
 
-#define AFFINITY_MASK(level)	~((0x1UL << ((level) * MPIDR_LEVEL_BITS)) - 1)
-
-static unsigned long psci_affinity_mask(unsigned long affinity_level)
-{
-	if (affinity_level <= 3)
-		return MPIDR_HWID_BITMASK & AFFINITY_MASK(affinity_level);
-
-	return 0;
-}
-
 static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -51,12 +41,6 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 	return PSCI_RET_SUCCESS;
 }
 
-static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
-					   unsigned long affinity)
-{
-	return !(affinity & ~MPIDR_HWID_BITMASK);
-}
-
 static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 {
 	struct vcpu_reset_state *reset_state;
@@ -214,18 +198,6 @@ static void kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
 	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
 }
 
-static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
-{
-	int i;
-
-	/*
-	 * Zero the input registers' upper 32 bits. They will be fully
-	 * zeroed on exit, so we're fine changing them in place.
-	 */
-	for (i = 1; i < 4; i++)
-		vcpu_set_reg(vcpu, i, lower_32_bits(vcpu_get_reg(vcpu, i)));
-}
-
 static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32 fn)
 {
 	/*
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index e8fb624013d1..c86f228efae1 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -36,6 +36,35 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
 	return KVM_ARM_PSCI_0_1;
 }
 
+/* Narrow the PSCI register arguments (r1 to r3) to 32 bits. */
+static inline void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	/*
+	 * Zero the input registers' upper 32 bits. They will be fully
+	 * zeroed on exit, so we're fine changing them in place.
+	 */
+	for (i = 1; i < 4; i++)
+		vcpu_set_reg(vcpu, i, lower_32_bits(vcpu_get_reg(vcpu, i)));
+}
+
+static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
+					   unsigned long affinity)
+{
+	return !(affinity & ~MPIDR_HWID_BITMASK);
+}
+
+
+#define AFFINITY_MASK(level)	~((0x1UL << ((level) * MPIDR_LEVEL_BITS)) - 1)
+
+static inline unsigned long psci_affinity_mask(unsigned long affinity_level)
+{
+	if (affinity_level <= 3)
+		return MPIDR_HWID_BITMASK & AFFINITY_MASK(affinity_level);
+
+	return 0;
+}
 
 int kvm_psci_call(struct kvm_vcpu *vcpu);
 
-- 
2.44.0.478.gd926399ef9-goog

