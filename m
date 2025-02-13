Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1957B24292C
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 18:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739469919; cv=none; b=PYujjtBtFnSruhH9YjTEyNpPdcm/tLH4sPJ3Gh/mHxssLIy3su0PTcAwSINJ1Ikla7qw8IufOMoqdqKN/xnRISzPUfsAq0pBw01eTQ/qvH+s90Xmo9UWOTBj7tYZMsuSR7nOk0rzVaVLJN1kFXPbdr34XefeDtaXDwjFITgUgVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739469919; c=relaxed/simple;
	bh=IZJEQPIvxuEa7fZk8fmidmjIbRTcRKfHPrJ03u35OxA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F34Ab4FIN3L/wA5qr0PvixV2tCMNnxPTPtQO83tgNwBFeo+4L8TcIEEGL6WzhX0Tt89bThpAUv05U6k2w8EVf/PO3VWv6+PULAJnZ+XR5aS3bZvkwowH1FRAeRM0OdVn4+X2ALpRXAW2ob+G2eN5ynVgOrv5TXInWCbJGmD1Q38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iGqFgfuP; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iGqFgfuP"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-3f3a3c63929so381420b6e.2
        for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 10:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739469916; x=1740074716; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8diYz1cAxVXL8ty4tojeoCAMG1b3MlycRIC3CE5RSGw=;
        b=iGqFgfuPlfaIHkxwUcReCvoHEmXZ3T2mKOj2JYyfk8ast1KUhV/5wP/6VuBMXC1t+F
         yYePui3HdKvOw7dK5sp3Mx53r+zvdynJ6GXqcZIy1oFhUAWh0+xdkXPdwrfxYQU7DdG7
         5zuNHVKtKV5q06AtXKNNysgnc6GxF7HcwbtKRMPeSnCvwWcsRBOvAywn/MxwozUc/rZg
         65GsOVQg7GI2AJUswdSB8cadTD9oTIZAnmC0dwtsMRVwdcX4Mt2eytz7bufttbDn63w1
         FpnpqogkXZWSx9qwrIvOiDAEoz9Rxnfo4aeQJS5uL91qzVyol2ZxtpEuKeNMYpG4kP1I
         aP3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739469916; x=1740074716;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8diYz1cAxVXL8ty4tojeoCAMG1b3MlycRIC3CE5RSGw=;
        b=DvtrTTE5ZV+C7LbouZBJI63DbOjsRgeSuXt/1+rr9WTKdqEQmSR7CyT19HQpQKCCIf
         YsDh9dPT5Ue1zx5menGdmCj/q6dhospHED/DjSI4qUtINAaWcpu4cRe9UY1TFuSyNQGa
         TK/Yi7OsO9m/4mbY/v4DwfXbpve71p/Sw7Gx1dQSEvhXlU2Wb4KmDxWxiQi06ttP/wOn
         XjrSThwtmVFVDk5UUUetZJIybVVnLGmw+YdilNFAAReEVEbaRuyLDSsNBRJn3yew8a/E
         f3n8iivGp1Z5wxNGee3ehsZNVkQrlsZcbIx/l+lfPNak+vgyQnCj8JMZdA30Zxu8Tr/o
         CxZA==
X-Forwarded-Encrypted: i=1; AJvYcCUdbJYTG1rCU6VXz2KZXgy1IU4V+9i2wykmj5t2gtIYnmes03O1u5hmoCE7srHM6X74aFvlaNE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwXPQzk/WDzX79SMKstSNHiIxQt+3xZjyZ2/WCnBbSqrpIh9sKn
	TY3ITzLhxwyzqkRK0PpRdMUowh3qy2D9ndEqvHoouY7KTmSAGNtunp5AQApflOgkyXTM8OWAOuE
	RVQC9nCwsQwukHzRf6HSuVg==
X-Google-Smtp-Source: AGHT+IFtzf5pcp5r1tyE0JHhxeZ0XLYC1m++VuQDuMxIrOxQ8Q/cXtGme3LXnvndLb3NfHZ76eNG2gQDi5BgD5rSnQ==
X-Received: from oibel5.prod.google.com ([2002:a05:6808:38c5:b0:3f3:c8e8:d97e])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:23c3:b0:3e9:2090:c030 with SMTP id 5614622812f47-3f3cd9df52amr5725988b6e.25.1739469916055;
 Thu, 13 Feb 2025 10:05:16 -0800 (PST)
Date: Thu, 13 Feb 2025 18:03:10 +0000
In-Reply-To: <20250213180317.3205285-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250213180317.3205285-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250213180317.3205285-2-coltonlewis@google.com>
Subject: [RFC PATCH v3 1/8] arm64: cpufeature: Add cap for HPMN0
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a capability for HPMN0, whether MDCR_EL2.HPMN can specify 0
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
index 4eb7c6698ae4..396327b4da7d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -538,6 +538,7 @@ static const struct arm64_ftr_bits ftr_id_mmfr0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_HPMN0_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_DoubleLock_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_PMSVer_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, 4, 0),
@@ -2842,6 +2843,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, FGT, IMP)
 	},
+	{
+		.desc = "Hypervisor PMU Partitioning 0 Guest Counters",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_HPMN0,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64DFR0_EL1, HPMN0, IMP)
+	},
 #ifdef CONFIG_ARM64_SME
 	{
 		.desc = "Scalable Matrix Extension",
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 1e65f2fb45bd..9242e460ebe6 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -38,6 +38,7 @@ HAS_GIC_CPUIF_SYSREGS
 HAS_GIC_PRIO_MASKING
 HAS_GIC_PRIO_RELAXED_SYNC
 HAS_HCR_NV1
+HAS_HPMN0
 HAS_HCX
 HAS_LDAPR
 HAS_LPA2
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 762ee084b37c..35aa5f6476b9 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1240,9 +1240,9 @@ EndEnum
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
2.48.1.601.g30ceb7b040-goog

