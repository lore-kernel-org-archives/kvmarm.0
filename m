Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527EE23BF80
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 22:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750457919; cv=none; b=W4XWlSL6SizuRVCZapAXskKJ8uM3ElvJstEE+CYNM8p/iuWXQtbYw8a7nKya5pVTtWGPIAtyrQ0P0eUDY2utT9n5ShYAzHE6Ac28K2yrcc1LnRYG/+dnCQrq5V6UaNXygReqzNknSjpAIOCaOyv+1CNtUSq2/Pk8ZlU8h/rrPPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750457919; c=relaxed/simple;
	bh=/MLHiy+d8eVTeEEbOWcTciIGqCC3NZq1YQ/d7snJV4A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MYECYovgsFVDwFvnY1nHgwXii8TIJ0F1nrfseZWoVnOt+U1p9Bb4bfiMeJ8MUCBaftSLOEsFKl0oi24eIYY5MAyhZPWcCtq4087D1P1rfSpu7fwVWsO6bBSDbOFhy3Fu9pW0MS1zFL02AcF/CnT8HgOnuP+6D19MeSUMjbR87Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tx+LGeDe; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tx+LGeDe"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-875b6256041so170098639f.2
        for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 15:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750457916; x=1751062716; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ycwbhAp7Zd2F37ixHvuXJ2dafaPBGypIo/idKjOgZXE=;
        b=Tx+LGeDeAz7L2ia3iMKLyzgZwc4i3MU9jPQLX36RkUSGc5SxY1HmLCxq0gB4ph3O/w
         LS4rAJMjV3KhcsA0XmqMEso/HYcqpqEv/2BCLnrSH7NCWkfFJErXHade/nG+EPd7Zkkd
         AGHSom2yqho3I3VIkvJY7VMXu6ocU/0ejaBiNgqHMz9pGlmRmY6uisEwVqb+6PCMsGBc
         HiOuw72MBYyTsXbywEE31Ngzh1CYwopZlJhEuLu0V3hvIxZbkZD2cvWzww7+wi/+Jm5g
         VbbS8NKcL7EjkFlBjGS3juE5SB4Ywe/zyC8SSaZ2UXKPoAxVBJhFOww/tB6oMzYgBe+S
         XwVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750457916; x=1751062716;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ycwbhAp7Zd2F37ixHvuXJ2dafaPBGypIo/idKjOgZXE=;
        b=dtLgY3nhFQTyTUBqEJRNBEq66w4Ly8OBCKXgca+V7BYYEFCmuh0G47spxxKwhE+z1N
         skMLCmjkhfx0iTgUFz7/mm6RiLnCTAz9bqoxcOAqdLopV2Ih1E3JmgITugLwNjfUqgNS
         TE+koa8ZvRTrzChYh0OCUzn6oDKCWL8eDObV7ddpfOYotL3Z1SXcel6uaSEcAak/BX9Y
         /MIMwTPRz/J/fgkeqXtkDDW80vLG1IFl7QwW3k0bA6Uhwz24K7qkF4K7e5PyQ5qXJ34B
         TuRRMNSG56CK4YvuQEVscUL8IkHpew1cIOKAVLki9f46JS7fsohcOKGvTiSpsZknrzEm
         w1MQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2OBIFcRU4rPUtHoTaC8NB+SCUkxWryjOms3JjX1lM6nkdgNybD+1982BLKBByRWaul9mYkCE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzIMjy00iZ9EXWzp6JB6vURkvbcqaHYkt+c8ix8tNHD3iSzinyZ
	2WCjkxYdlw44q1ppGKGnZTjPGJVvjYEIn7PmXPtqSYt8oJbQUQemcXBiiiDZcz4swQ3BchsDouY
	uC7ro91xZnf9OCJ06OBs9EFFlNw==
X-Google-Smtp-Source: AGHT+IHdG4exJg/OMLEag+SmUtZLjuBoL7XDzzcwpjklziK4h+sFdGNrbUVUxPa6LEbWOqyaRb+b3/J1oVJBEuicPg==
X-Received: from ilbcp2.prod.google.com ([2002:a05:6e02:3982:b0:3dd:c6fb:13fb])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a92:c26c:0:b0:3dd:c18b:c03e with SMTP id e9e14a558f8ab-3de38c21fe9mr52496035ab.5.1750457916490;
 Fri, 20 Jun 2025 15:18:36 -0700 (PDT)
Date: Fri, 20 Jun 2025 22:13:01 +0000
In-Reply-To: <20250620221326.1261128-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250620221326.1261128-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <20250620221326.1261128-2-coltonlewis@google.com>
Subject: [PATCH v2 01/23] arm64: cpufeature: Add cpucap for HPMN0
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
index b34044e20128..278294fdc97d 100644
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
+		.desc = "Allow MDCR_EL2.HPMN = 0",
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
2.50.0.714.g196bf9f422-goog

