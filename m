Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DDF2F0C62
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 20:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968355; cv=none; b=LO4tlapYepw1O0v8DJOMVNAiIqxivmksbJ9SVNxk8HRwRHAM1GJDI+Yoc5rHCF4VSSCh4pANizN4I28lQPfG6k3/+AzEMiCt6Lu/d4t1pPlIdde+X+SOCSpyAqkqTOT9pYQx3wS57PXEIJvVRh0D3rkgeD/BqvBWKyI6tpFkrAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968355; c=relaxed/simple;
	bh=9apEKUIdLeyPsikl7KFCLmT2RywguEX6MjbxXJr0f/0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TqWUdrttjZItN4g21n7L0uuyA1C8v0nphaAMQtWAmTn4zN1K1Lo8FqmOnap3gmWYiRBuCLofRljPKdXhtu4FLpNJ71DknQCftmqteObKqGGmGOA+/JDYQ2WUkn/Fmc//jh9OtKt7RTmMpj7HAaBZadcAafiFqAIBfBVIUTBPnLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=stWvOUxO; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="stWvOUxO"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3df2e9e6146so8781485ab.3
        for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 13:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968352; x=1751573152; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iaFai0kpA9G7yidHpU/KUU/hEAHmvPP5GvS91zDpLpc=;
        b=stWvOUxOZEFwEzFQsHvDbHkgovFERERE3jGqJJFqvRTXLqwm+7VGsghTRtDUwhX1ld
         /bwj+wQBZfkbhbi7XUW2B+zCMqDEGMJVBc46rk7wetiFIzmRx/CiBYSYbitDM5phVPNd
         wIGQFHEuxQwuQDTq+8EIkxsww4U0n9UYfPaMFaKuUxL2Igz+UhwsOr69et8rOykuW7j7
         9WJZAwD/DsDXKoKdEwEGojs5cL5L0mmMa6Dg2X9IUtuviS+9Hgf1B5NiJKesdWIreEEh
         uah/9tq1yQbpLbSaeyhmmKJ5pzTmk9VDmLWu28ou5R70cG2zJTLhXiSwZyriFTA8nkJf
         d0LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968352; x=1751573152;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iaFai0kpA9G7yidHpU/KUU/hEAHmvPP5GvS91zDpLpc=;
        b=dTZeO4/PBOZNZsrghM4CRIL8izaId+rZDXSUYAqOrvz6dzv4jIC9Y7udkEdIwv5feY
         cgm5aaEsTYhFqndodHvvv0Y2s4I9bks72t1w3S4zj+hc4M4SCLeGVQyWChsbVzx0xt3g
         5Rxnq/hu43R02V1Px7sfAGMxBhGzksnpfisHwAcf2dAIX7UNVb/pgWu3EKMrxz51UT4K
         yBE4nDF5xcYmX57A0DkO2JMalbU5boT5BPBaOM6NGV8bl02idPqbaLxdhrUB3gcsg/EV
         YuUycKRBCTR+PVy7zCoxRRLbZuYmCNCsRvXn4evVVb8By6wgkbwxpcPkwkzoj1ZPbAqy
         f72Q==
X-Forwarded-Encrypted: i=1; AJvYcCUQBTs1oz/NLFP1ur+p/ccqUvwOZdRat+v55LgfTOVP2BkOZW9zBSUqlRZ+dloGqRVL5tz7rYE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9qLjjZToEbdDuzxJRgU+WPGpklrHT4ILNd1376o02VDSrM81w
	83WQ9SuY3gWpgn9PEGVJcTkb8WMBqslQ7bOVvlxMsifdKPtLHR54hiHnSiapDprbXPCOTYL41CT
	ozKN8d72U33zwMlbfOgbfd3NHQg==
X-Google-Smtp-Source: AGHT+IH29/gNXm3nZ2B2ojHCYilqtMfkqWLjy1qqrKLeh9n7wKnCz/XYXSUrRH/F4j6Tl4Qhzhb+cR95L/p7I4Y1iQ==
X-Received: from ilbdh3.prod.google.com ([2002:a05:6e02:1f03:b0:3dd:b580:4100])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a92:c245:0:b0:3df:4159:8fe5 with SMTP id e9e14a558f8ab-3df4ab55b4bmr13423615ab.4.1750968352377;
 Thu, 26 Jun 2025 13:05:52 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:37 +0000
In-Reply-To: <20250626200459.1153955-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250626200459.1153955-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-2-coltonlewis@google.com>
Subject: [PATCH v3 01/22] arm64: cpufeature: Add cpucap for HPMN0
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

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kernel/cpufeature.c | 8 ++++++++
 arch/arm64/tools/cpucaps       | 1 +
 arch/arm64/tools/sysreg        | 6 +++---
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index b34044e20128..73a7dac4b6f6 100644
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
+		.desc = "FEAT_HPMN0",
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

