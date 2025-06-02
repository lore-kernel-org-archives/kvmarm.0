Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281D0221FD6
	for <kvmarm@lists.linux.dev>; Mon,  2 Jun 2025 19:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748892540; cv=none; b=d5GDDFJJwmwiWK8KFVbPP9PnvWG7ZMscqe1f3PQCVUBmurjsB8x2O/+o/F8x79HtppcxEiXi94GdlfzbEw1r3cAAJp045jocL3DGyyWZh0TsFihQn5nytEDlnkx0YpfMo4STt5S5BkNK8TyRYkyT9JKfAhGYr73e7BCaXO+Z26g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748892540; c=relaxed/simple;
	bh=UpyLhDgeST+9yjPTPNbtC0GB4N1QHxuH3tcvChyIfWE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ty45AWYjTrgRC3PfbeyIztjjkChMokXhDh9YfeLN8cOveSlIZdavppgRJr3KHB1Pbi5/c2j/c/w+rquyOfcHnJtLheHteXjqE/oNSidYo1T5DDGCABKME6u+RjlcdObYOaf1NdYIqZHo7VaLHWdxKf3gZV0Nj+EP8vryV/sp+OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V2KH8yJS; arc=none smtp.client-ip=209.85.160.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V2KH8yJS"
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-2e990e17650so526796fac.3
        for <kvmarm@lists.linux.dev>; Mon, 02 Jun 2025 12:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748892538; x=1749497338; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zgwK7stiipaBbElK9ZH8eFt+KmwsSimSmMPY4y4bpeQ=;
        b=V2KH8yJSWM2YR8YINRVwZGlR8jp3xDU8OcKEskBx2LzHvdBEi1O6rKOZJAGDCkfv9h
         GD+T7k/9lLOLKyu30tfOpiTC0Du33Hnxt61kQ1pfydbQX6cgGQ8LTC/wKn/NISEoMOnY
         kRVCKlCeQO7f18crvEJstWMV4LuIf8fQqMyEvLw8J856iP+HNc524kE4/RZca7QHIsSH
         pi5mMHLDylU93tmEwfGt17BX76Z4NDgKGND2OK3BT95/vuB5UBE6CgZqQoAN589vRqzr
         1Ldi8A2vspbKODmbpw1NWcsvRrSY+i86ftRL6fpIwHnlQP9OsSoWVCLx09PgRrQQcSew
         wmeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748892538; x=1749497338;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zgwK7stiipaBbElK9ZH8eFt+KmwsSimSmMPY4y4bpeQ=;
        b=aez/Try/fLdArFAt+7CWHmYBJsgVfTSCE3RLodVoxN8ixRF6IOPAeXMgcrJV0+M1/P
         PwepHaYdr+rZh2GxmaQS7cLUPkYEP/H031I6Rr8vHztXGfdgzkWmNL91Jpt2RXxqZJf/
         Wr0wsJO8f0P67dOkHmxg+TdzvWDoJ/M5bmZB5FXEtVHdWw8r8gLlRgXJN0IenVbn8xE5
         cHPyoGGXs6w3kmnA3iNG8KMTvZXfx8OemEhT+61UA4mL4YcbGkq5n0qQLXRt7TCUJ8ix
         RDPdFhJY4pKANjqO6MrCSVqYmxrTgM3ZQeIXGQbUM004I1uMlDx9MEhieRbp6t7rwVCh
         TxGg==
X-Forwarded-Encrypted: i=1; AJvYcCVQYvFlUmcdiiEQHNmpSXMZJU3P5uOZyOS+U/xEIxe67TzEMO+86qI4f3b9fyHmeSBVZU58QB0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxLe+MBrPNTaTae/Adqb3+10jzCR9bW10fQ7XnEDaKHyFEVkNvb
	xE8sQx20UVxjH6KVawL6LquAdC7u6LvXORwVuR3IDtbOlOuVlsi2Fa1TGaquNdWN/8Q6YyTLIbW
	TzWQwGY/TPpG+ztBzKGemvFppVw==
X-Google-Smtp-Source: AGHT+IHY5orLOMss72/ttOtRz18RgR7Q6GomVkN3UzZeAOQY/fszGrZVl+8B2BDQNOJ4jWTDkgrOBQQZ8Rc/ZsDHgg==
X-Received: from oabgs11.prod.google.com ([2002:a05:6870:ab8b:b0:2c1:5c70:acac])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6870:b1cc:b0:2d8:5015:1a8f with SMTP id 586e51a60fabf-2e94881808fmr4931862fac.7.1748892538177;
 Mon, 02 Jun 2025 12:28:58 -0700 (PDT)
Date: Mon,  2 Jun 2025 19:26:46 +0000
In-Reply-To: <20250602192702.2125115-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250602192702.2125115-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250602192702.2125115-2-coltonlewis@google.com>
Subject: [PATCH 01/17] arm64: cpufeature: Add cpucap for HPMN0
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
index a3da020f1d1c..578eea321a60 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -541,6 +541,7 @@ static const struct arm64_ftr_bits ftr_id_mmfr0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_HPMN0_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_DoubleLock_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_PMSVer_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, 4, 0),
@@ -2884,6 +2885,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, FGT, FGT2)
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
2.49.0.1204.g71687c7c1d-goog

