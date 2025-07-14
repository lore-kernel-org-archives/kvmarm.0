Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2662F278E6A
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 22:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752533973; cv=none; b=dDOeGY4juN1wfLD6p2gu/vfNix4LC4wTpKw3eewzTZdrb26rnOemBWtlCnNjAZqNWHdscsTRHDomSY0fuB2hu78vzS4ZpGJRK2Hrv2vVGvG+9ihQjjWLrA5XzpVAzzGgNy5xBIt8vIjQuMZirmjKAQJWV6JE103zq2uIxFcZYP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752533973; c=relaxed/simple;
	bh=9pirQkb0m7N/ZSHonJo+EvQ3meYt9RuTsLbJDifQha4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UcPtUSdYccYPGm9EYCjOFhGNBI+O+32ijyv7SWA934AHaE47gXI+XzJmlJyW3ruhXgwNGICLfpOMzRzhqonOs8wlkgJIf1YCWJeyegdIVGIm9Ig6sJ5AUWSzfF/62NoecW52XW8SZb2RtezHiHj5sW5byNZuWJdrot2Dd1q6F/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GHsGPP79; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GHsGPP79"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-40d04995b67so1198231b6e.3
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 15:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752533971; x=1753138771; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KJXmYeKTGnjqKEud4aRiMq2ofHrNWARe73nlzic5/G8=;
        b=GHsGPP79pXS/MDKafg0ZYdRWzstMsnHjyN8odiBuAddiByW7KR/132D2INgV5YN+pC
         tp+CRnVwpyv9CErJaYCAhyIRFG6oN3JxcdvGPSEgwjE0rQoufgeBFBViHP1WHqHF2FOo
         sFNdIgJZpSI1ImHtjKk32UDr811AuYF7JgB0EF2Xh+DdXvTyEueCCiXAhZZ7tItxT1mm
         cYfjkuTs56Ybznon3tqGKgL4H/o8gKMgPspEFbwDseBK3esgTV++1Y2xycyImPWGkCL/
         yMU3LoDYrf50/mxKueoCJWQd9cLLz7qvcFjir1rLQtHKXZWeFiU/kuPD7ONXGXbikCVU
         bOsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752533971; x=1753138771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KJXmYeKTGnjqKEud4aRiMq2ofHrNWARe73nlzic5/G8=;
        b=TsBr4GWq23enmIUzfX5LNegl4gsmES6nC1gu7sZEKYLV9K8IppjJwGNp5ymzu+FIGS
         AtPpu4AWFPcCthcOjFa8TaZ0A5Sp9Rt6zN41FH9eFHk1QO0qFVduw687B/zE4gJX6snh
         O9Iy6iiRgNaKb1rcQCxMst/pk2kY1eNatn3fZ+kdbhlMd/JWHjusIcK2g80MzuSEPZfs
         CcqJmDYe3lJLskI2LnfHFj76/uhBtKO5VNlgDKrjDZbTscAEqj9JMTdt3wXiyQjNTt3W
         NAc10t8PxwfxsSdUTA4ywPqqm+1t9J06E5OwaEjjaf9bHyO9+mu7+eo4NNcWXLE12cOV
         QDNg==
X-Forwarded-Encrypted: i=1; AJvYcCWG48bjfjxzxRkONbsjoBG0ZV30gfQk5fsjf7m8hEQkgePtmTSVQNpV3Y5rajl9XHyppSHKU8E=@lists.linux.dev
X-Gm-Message-State: AOJu0YxnsVU1IkKTfj9xc21ODMuW6cYysblb6ugAWhFs7MFhCV+7LwBa
	kkUGE/aTmkRzjyfGLHmMjUpNHbCHE+qDM7VlFgirGymsVFdqnr8DR0E1GJHKQVHkeqd4c+fjTPv
	nC4VzbFFXCfdg+qOPZQIGKKBO0Q==
X-Google-Smtp-Source: AGHT+IFJZaaG0NKL8tBBBDgd5PVrD7hPJMlHTf5CXiCJq4KOEoeUsMaOm4Ndc7OfFJp7bHopehW6o7GpIil6kUfASA==
X-Received: from oibir14.prod.google.com ([2002:a05:6808:6f8e:b0:40c:a463:99a7])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:8859:10b0:415:9306:2e3b with SMTP id 5614622812f47-41593063055mr7134275b6e.23.1752533971422;
 Mon, 14 Jul 2025 15:59:31 -0700 (PDT)
Date: Mon, 14 Jul 2025 22:58:55 +0000
In-Reply-To: <20250714225917.1396543-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250714225917.1396543-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250714225917.1396543-2-coltonlewis@google.com>
Subject: [PATCH v4 01/23] arm64: cpufeature: Add cpucap for HPMN0
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
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
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kernel/cpufeature.c | 8 ++++++++
 arch/arm64/tools/cpucaps       | 1 +
 arch/arm64/tools/sysreg        | 6 +++---
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index b34044e20128..f38d7b5294ec 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -548,6 +548,7 @@ static const struct arm64_ftr_bits ftr_id_mmfr0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_HPMN0_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_DoubleLock_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_PMSVer_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, 4, 0),
@@ -2896,6 +2897,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
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
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 10effd4cff6b..5b196ba21629 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -39,6 +39,7 @@ HAS_GIC_CPUIF_SYSREGS
 HAS_GIC_PRIO_MASKING
 HAS_GIC_PRIO_RELAXED_SYNC
 HAS_HCR_NV1
+HAS_HPMN0
 HAS_HCX
 HAS_LDAPR
 HAS_LPA2
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 8a8cf6874298..d29742481754 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1531,9 +1531,9 @@ EndEnum
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
2.50.0.727.gbf7dc18ff4-goog

