Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AABF3469F5
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 21:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777929512; cv=none; b=rtv3oWoI4gIAu2LdnrexJWzYJIj2Ct2XJWYHOtKwXdu9jzuFFlJ+3sCUhI3X+6et40ZcUd4xPRu/8MAXSl65CRdcyd25Hzn6Oob+QsPb7p6+HBTJpfZn1FxxmPDPXpKxbfKMUpRPi2SFjKwXcgNF80af8P2Z7oRkVcNXIqAvwKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777929512; c=relaxed/simple;
	bh=ISoaF2E6143lYgjhjbBXLJa7G7p7bKVjvejJ6oYVasg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MNZWe/PdHKPLzCruyevLWT0oSo8JG2qPF0rqvaPTwBVmZvO8HaDktvlDkdhS6ESLx0Ra2VP6ub55jBkVbjBUBigqLAnDH21rm2Ze0cVPG9Sih+2cLq43fjOyKqHFbKR/6AXqPT5YRFWnZJDdh1lnZwuEfO+hZz1qeGaKWkwSS38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bawFmO4G; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bawFmO4G"
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-698229e6b62so1474024eaf.3
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 14:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777929509; x=1778534309; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2uiiVseT2qkhFwzL7iHG6lxFCIgHI+i9LhCSR+WQs4k=;
        b=bawFmO4GmNcR2jRb8fBo+FCYigo3LOJZzwX5IkfVcG3Z6mWQrNjvZxGMHM/G5aakDG
         Ktl9VeHTbmqz/b31ztBod+lM8ZU5GemATRr130G8HLOKlge8idMQnOq0HVjaah9A1Lke
         +xCPElrZjdZkb3wZxdcO9UlH5mnHN/9su9g1LOfIzZ9XBVBnA8AeVN7fvbt/c+yVbDVP
         nimMgRkJxsHmW81UxSm/Ii2yKxqKpbwo/8COFKXm7/LhkfuI2tFf1mOUyIKhegyVh5We
         5fbgQavyOTGgfWIRQIcU/1X1NuwdYz9S5HK/Ris/3xQAqxlFiGPLJ3pgAw1xsZXL/cFf
         ibhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777929509; x=1778534309;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2uiiVseT2qkhFwzL7iHG6lxFCIgHI+i9LhCSR+WQs4k=;
        b=WYro9c1LMOfOZjxbis3f0PeFDr/G4OxNtrNjQh9mpXUvAjTtJmYGO8tyQQoJNrMVZl
         yJHOhl4mL2vHYBqNiYCGTkYPuhzUDdp8tcernIjS5Szv73Glf2oSfIpjSp4OYUDOO6qB
         qSosTtM34KuTODeW7eidSYGIg4lvHgkj35Pny4OeDwOGAXGyWQkBb+dtmLjW/R6UJ1p3
         ZiNG61rVK/o5+YJuLfMNXLfr/XUr7brz/GLkjpKFtNQUVYWEiu3iDKtynP94LPmnSCSn
         +XBq1fRYFPb17c+1Cysm7OfdzqkVKgMU0U8NDFWazoaWayAvU2qAbluop0aRRXBRsIbV
         bUfQ==
X-Forwarded-Encrypted: i=1; AFNElJ/UJnlp+q3f6//e6sx8EEeyTy6KpaOEMRvDAtIX4+RVVkWYPHvJTudfIkNzipyUqrqIorSgOEo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6LqqFHcCdmUeb9MtHZ15cu6UWWDVhAkr1er9yXUpp1uT/Umec
	vKEIBaQc8i6oMDbN2Y+drEpJ2ckSaNtYlpBGreXVtkBk/cT2aZAISpOEOzkDcrafV9W7HH5nyAu
	raYtO4sJ0739yVoH0QBsTV1AeOw==
X-Received: from oalw10.prod.google.com ([2002:a05:6870:948a:b0:41c:55f7:96a3])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:2223:b0:694:8d83:a344 with SMTP id 006d021491bc7-696979f0660mr6109852eaf.16.1777929509296;
 Mon, 04 May 2026 14:18:29 -0700 (PDT)
Date: Mon,  4 May 2026 21:17:54 +0000
In-Reply-To: <20260504211813.1804997-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260504211813.1804997-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260504211813.1804997-2-coltonlewis@google.com>
Subject: [PATCH v7 01/20] arm64: cpufeature: Add cpucap for HPMN0
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	James Clark <james.clark@linaro.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a capability for FEAT_HPMN0, whether MDCR_EL2.HPMN can specify 0
counters reserved for the guest.

This required changing HPMN0 to an UnsignedEnum in tools/sysreg
because otherwise not all the appropriate macros are generated to add
it to arm64_cpu_capabilities_arm64_features.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kernel/cpufeature.c | 8 ++++++++
 arch/arm64/kvm/sys_regs.c      | 3 ++-
 arch/arm64/tools/cpucaps       | 1 +
 arch/arm64/tools/sysreg        | 6 +++---
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 32c2dbcc0c641..5c6c76a9696cc 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -556,6 +556,7 @@ static const struct arm64_ftr_bits ftr_id_mmfr0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_HPMN0_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_DoubleLock_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_PMSVer_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, 4, 0),
@@ -2964,6 +2965,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, FGT, FGT2)
 	},
+	{
+		.desc = "HPMN0",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_HPMN0,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64DFR0_EL1, HPMN0, IMP)
+	},
 #ifdef CONFIG_ARM64_SME
 	{
 		.desc = "Scalable Matrix Extension",
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1b4cacb6e918a..0a8e8ee69cd00 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3232,7 +3232,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		    ID_AA64DFR0_EL1_DoubleLock_MASK |
 		    ID_AA64DFR0_EL1_WRPs_MASK |
 		    ID_AA64DFR0_EL1_PMUVer_MASK |
-		    ID_AA64DFR0_EL1_DebugVer_MASK),
+		    ID_AA64DFR0_EL1_DebugVer_MASK |
+		    ID_AA64DFR0_EL1_HPMN0_MASK),
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 7261553b644b2..654b165781854 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -42,6 +42,7 @@ HAS_GIC_PRIO_MASKING
 HAS_GIC_PRIO_RELAXED_SYNC
 HAS_ICH_HCR_EL2_TDIR
 HAS_HCR_NV1
+HAS_HPMN0
 HAS_HCX
 HAS_LDAPR
 HAS_LPA2
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 9d1c211080571..92135f8834be0 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1666,9 +1666,9 @@ EndEnum
 EndSysreg
 
 Sysreg	ID_AA64DFR0_EL1	3	0	0	5	0
-Enum	63:60	HPMN0
-	0b0000	UNPREDICTABLE
-	0b0001	DEF
+UnsignedEnum	63:60	HPMN0
+	0b0000	NI
+	0b0001	IMP
 EndEnum
 UnsignedEnum	59:56	ExtTrcBuff
 	0b0000	NI
-- 
2.54.0.545.g6539524ca2-goog

