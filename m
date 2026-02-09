Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6AF3176EF
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 22:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676846; cv=none; b=NNmxhId4W5UUtUjiXVu0pWwPzR2DpKRNMzIDjm1CRFZJDhDwkCcA21aWP5vVY9o19iTVpttzribdMBwCe2ASim+hlIQOPSEoQ9vuvaYsRKHamNYav2PuJrPE3opUX/6UsXeEwz5DLHS0uXxDRCR2cQZPFzWg0zowAT4qC7tXbYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676846; c=relaxed/simple;
	bh=6+/AAsrIcJ/tlip7YRHDsjoPFsDxdedlbrM0lqMPkcI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m2Zj413a+ZHCAX/WvnDX6ZYCRCgMyFUd8h3RU6D2OZborhDHxsQKK9X+xJQEQ37UpmCjiJ2nkNVpdeBQuDKD3wr4MYOLS2hBru2+E8ZFajqBfLEyPMcysgv8nMpnRoGu2dZ7/KBxLEmlDTQE64pG7dPgPVxkywEI9SDjIzJNZp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RlmhZ2jz; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RlmhZ2jz"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-45e94165d64so841072b6e.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Feb 2026 14:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770676845; x=1771281645; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iRE+uiZ0XUNzFGmxnXVrfreBhjJPUlvjb1s52PGeIK4=;
        b=RlmhZ2jzOCS09okqzQ8jfdywV894etWsBqJF3cCaGKe9ORsU1T3AsDIag+N7E0GBaT
         /IPOW9/ESZZs4HMN532EPa6RGW5UHHhipcUZelXKtBcZcTxx5EtrYLEQCPg7wZM0X5wh
         pUowF/vfb6dUsNah55fg6NMwwk13qfzR6oyqNFjg0bFxF+/fuZo49LYeFRkCSUQWg0Zd
         RO/3j6OtAD1b9tuHHe8Tx2G/coxozRaj3xjaZPahA0RIChTG+udlwqQvZUY7hosdH3pt
         IUUn6uF8PjB6eMcK/iG4SqTAgCGIBdU96702ghCxw9CXeQ0v37r3/O4PsOkuGW9Ab/iH
         JJ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770676845; x=1771281645;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iRE+uiZ0XUNzFGmxnXVrfreBhjJPUlvjb1s52PGeIK4=;
        b=LQZgwBZ+xAZuvgJ8+gjrT4NOVZO/WSZnVemSAq6VHG/FFjF4F/JueyDU2I1zlh1q8f
         xF9w9oZRQwC/dyxbCJo3rUsxLgdkdzloInLu9vEZ6a06Ea9ffiGbfXmyUqSy2CwT2N36
         9d2CLllKfdS73BkH2WYMvSrxmbXszQMXpzKPFhD4+x+5ggjndC2WNClhCDWdBYd+pLQN
         o8jDFl6YZJ70bwLOP0J7WhSI7BfcC/mv/utQOgGSW6DccD8jvUfJF+KFwjfJu7BLLESN
         9V8MlUfzYa1xesWLWmqOWCcUQRhwkftISwQrBPdXQ3v5BZcMtLz4VyAyBychrJ6qFNFv
         PKyw==
X-Forwarded-Encrypted: i=1; AJvYcCWqCSpglfQ3ecUaWMldyTbiuoppZWhLukmy1LkEU/UIm0I2sPq1BtkXl1AIsIlCttD5mlUR+10=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0HHu3kfb3QnjjUEKa4BoJYqVcW6RxJEKaffPlx9oDBN0bBQ5/
	JLKIGGStGUfSe/i3rszfUndk3liZBypibgqUC7jDj1GktGnbLSXIxf0VAayc12qcdRkOsompToW
	A7KqVtzRrkFWH1G3OnxU3wZQjmw==
X-Received: from jamu20.prod.google.com ([2002:a02:c054:0:b0:5ca:f895:d041])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:4b17:b0:663:93:5146 with SMTP id 006d021491bc7-66d0bdae77emr5791796eaf.43.1770676844869;
 Mon, 09 Feb 2026 14:40:44 -0800 (PST)
Date: Mon,  9 Feb 2026 22:13:56 +0000
In-Reply-To: <20260209221414.2169465-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260209221414.2169465-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209221414.2169465-2-coltonlewis@google.com>
Subject: [PATCH v6 01/19] arm64: cpufeature: Add cpucap for HPMN0
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
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
index c840a93b9ef95..e6a8373d8625b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -555,6 +555,7 @@ static const struct arm64_ftr_bits ftr_id_mmfr0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_HPMN0_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_DoubleLock_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_PMSVer_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, 4, 0),
@@ -2950,6 +2951,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
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
index 88a57ca36d96c..a460e93b1ad0a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3229,7 +3229,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
index 0fac75f015343..1e3f6e9cc2c86 100644
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
index 8921b51866d64..c9cf3d139c2da 100644
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
2.53.0.rc2.204.g2597b5adb4-goog

