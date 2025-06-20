Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675D823ED63
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 22:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750457921; cv=none; b=mN0khL/BOvoNGGnkvM0312geBohHglYFVro1tVFWe39sUmkfomaeqPUm3OREUXB8U5GDiK2bZfJ5pSMbNCqKRLQ7f59KtAluxcBiG1SJ6K7yH2d7c53T3yYLbqWk6hOSjN5j1cLVCeVTzeGOmYM9gRvGpuXBOI7Om+zgL5xokps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750457921; c=relaxed/simple;
	bh=YIYZtYXjjIDG79viwi+LeCOmjCYAMmr9a5RXDPHvUQE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DYThnqHNDxT74+vbj7t6eBNafBm5yfgFyUpsMFIgbQc9MuhsXvRD4VqVP87Qlj+2pG6mFCj60XmWJqpJ9J1YQMK4N8um+kllQJZ++qSbnCSqjvtAKG5jZOTZuttyhZd2rp9mruMQQNiBNLjQw6QvUEA9bRG7NgsN3ULe3e+ZE1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OHvad3k3; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OHvad3k3"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3ddd90ca184so18052905ab.0
        for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 15:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750457919; x=1751062719; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fp13SX1Zh+VZLmNtKrEzp/HCcjo4sCQKHBsJF62MnBU=;
        b=OHvad3k3ruUIzJLy20mfco5YWaxH1qaZhFp+0Lc1v+wWsu59bSDOvKvbbh1wdsOHyV
         3gjRfB7Htwxx6l5JxaegIo5HBqHAqFRZEv4rsP5qnpVQzyIUQWoWG+G8INkyKWap6vDw
         7EPgjqm1dFxgPJw0MGO38v48kUB29TVz9BNWse3aosS4Zhnb++PqIoZ/rClOA09y0JT+
         nH1b5OfSLE8biwP08MggdlNpiN/RRUkQ9JIJqEEXzVBQsY2JJoKKRfrMbZbws7PNWrpn
         CzV+yNKn1b1AyI83Rpu74hsLzt9ySDsZvMfo4sRC+NLJw2MhMQ5CBZmRad6yfJ8rz3V9
         ufBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750457919; x=1751062719;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fp13SX1Zh+VZLmNtKrEzp/HCcjo4sCQKHBsJF62MnBU=;
        b=rsnsDFxaCV6p5v9BbUB8yKRIBqzWlURDf4BqPzXWus9maz05Ft55Jc/9YuLeaWAc42
         RsA+wMK0xEmEZ8yaMkD1aDvJ10wLY2malUW4DUczx/g94icaPltDtB4u+MSArNNuLr4r
         4wqJCRdazL6wJltPf5rRaro0cBPEfJvTUhTKstfCn2/ZdJwt1YYiSVSew0NOm6XX5KDn
         CkGOCDgxLxypqrSeZinhELy5jc9FGQ83xPD6OMz53x5p0WTDXMrSv/66JbApq1P1dNXW
         PR0/bg3VB0qL8iHyfX8/GcHVY8qmXCx+C44sPKYzQOWy7yicj5+gyU2WZKTyu7izbCu5
         4e5w==
X-Forwarded-Encrypted: i=1; AJvYcCVncpc7UZrkkmbWHI0TSzgadbWm6HqRXWqOEUBGicwYM5/BziHjRIeVmSVzW1ieofFKhv/QP4A=@lists.linux.dev
X-Gm-Message-State: AOJu0YxcVPBU+QMUBTo0YTQuKdGsFn0NlJmbVyWJvnWbl/cbxgTuWINi
	LyuAL17yD8qTSJc3XSLNCYnsFI7ob86gk5p0fEoA9oDE2a3fFOp79cIXi2rqLONiycOfQWqil7l
	xU7yq6MM+U65IyYTXa73I9uGSSw==
X-Google-Smtp-Source: AGHT+IFEidHFMEbKk2OynEjRQvMLrVqFymZV1Kh1vRLY6IT0l2lygB4TWhQMZfNIZL6xIAJ9fHhQZ3Bjc4iSkEbXjw==
X-Received: from ilbcp10.prod.google.com ([2002:a05:6e02:398a:b0:3dc:756a:e520])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:3782:b0:3dc:7fa4:834 with SMTP id e9e14a558f8ab-3de38cb06a0mr47968995ab.15.1750457918713;
 Fri, 20 Jun 2025 15:18:38 -0700 (PDT)
Date: Fri, 20 Jun 2025 22:13:03 +0000
In-Reply-To: <20250620221326.1261128-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250620221326.1261128-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <20250620221326.1261128-4-coltonlewis@google.com>
Subject: [PATCH v2 03/23] arm64: cpufeature: Add cpucap for PMICNTR
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a cpucap for FEAT_PMUv3_PMICNTR, meaning there is a dedicated
instruction counter as well as the cycle counter.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kernel/cpufeature.c | 7 +++++++
 arch/arm64/tools/cpucaps       | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 278294fdc97d..85dea9714928 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2904,6 +2904,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64DFR0_EL1, HPMN0, IMP)
 	},
+	{
+		.desc = "PMU Dedicated Instruction Counter",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_PMICNTR,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64DFR1_EL1, PMICNTR, IMP)
+	},
 #ifdef CONFIG_ARM64_SME
 	{
 		.desc = "Scalable Matrix Extension",
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 5b196ba21629..6dd72fcdd612 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -47,6 +47,7 @@ HAS_LSE_ATOMICS
 HAS_MOPS
 HAS_NESTED_VIRT
 HAS_PAN
+HAS_PMICNTR
 HAS_PMUV3
 HAS_S1PIE
 HAS_S1POE
-- 
2.50.0.714.g196bf9f422-goog

