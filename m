Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C4F22ABC4
	for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 10:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407901; cv=none; b=Ty6M1pqJOJrcXNoyk7Gqt9HpmJdhFYK6gUKMWnnKnMl1iptMn5nW+8BifhDE0YGjOAxfWTfHZ+VvdDSc6fwIDTKslQEoyCk3QZXWTSGgEJGpIbpirtlTvCWrPJxq9mGVmUn/cFJe/R5prF4ICF+/pVxEBtSZfCx/MObwVTxyH9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407901; c=relaxed/simple;
	bh=z2j2I0Qm2rkQ7y5e1vIEopVvmmPdhbqBCsJHGjoqZU4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T242Z+M2wydj0gEImTIWX2qdtV69roWJ0ASpfL7JguniP3uh5uo/Jwt5WnUWdjb1Bc8Ls0vkcAe7hLMkhVuxxSpLmma3+m1pdfMXtj7R1BRFhL7DnsQDAzEiuU55m9E4yCYdyn6Im3pUgvGXdeDNnOfSdPo0c1HOK337rDaxUyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VxsFOnB3; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VxsFOnB3"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-431481433bdso48156655e9.3
        for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 02:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731407898; x=1732012698; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UdrH76534AdnOkkz/8MUO16ELoaDJWuaGxP7kufZ9lk=;
        b=VxsFOnB38TwFq/B9UztMEp2zMb2OQ1OftK/264/7GrQ68sM7ZRFAsrGCQgFDTnkBL9
         cRCgPt+wWK0qreXFH4rGinNVV9m5C7HULGD1yr0U3ApGnhbJ43yzKg4G4pmv4Jkym7Ap
         Ruf2YBZEHpzbv8+nrHlAWZ2MkCi3QDqeTpgPRe0EvRLg8z5yJeEvIkW4p9z1hfzm3OQr
         4j8Rd32yXPqih58lFiGqqzpHH/9LvbLwhA1nZJRaAnItgI3ZNIrGnkrsFzpoXJ5JbMGd
         DOiqR6tMohOCuriX98WqspqkK4Yc/xhAh8GI2AglvqF3cRayK5G2LPiJ1dLpo4XgUTDl
         xrXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731407898; x=1732012698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UdrH76534AdnOkkz/8MUO16ELoaDJWuaGxP7kufZ9lk=;
        b=uyK4k1YBV8WDKu8FJ0epg0YeFuO8wvc6MdmRJdHZWf0Q0fn032R6NifZP8tgzs9NKP
         aWhRfDPFLxGaWjhpdu907k+YonjI+wASA4EqG/0CsZYtjBg/gvozvu7q9sxAL1dTQfOU
         aarjoKh+2q3FvNHft5/m4JJoFzzaKRwDb7o2VkdfPruE8mfm43kj5GBj9M33B9ZyCNRK
         UnWlaB3aWmq8SNxY9swPfAVC6t9l5MmHtfvJPf8Qq6bs7OwMEfS+atCfZfA44dRm3aTh
         VabyEnE7VjJ08d1g3Vqpd5tEx+6XfvOgcQbr0gMg8+KvAsVqafFFnmLaKUghbEq/mmD3
         N1SA==
X-Forwarded-Encrypted: i=1; AJvYcCVkxeMW32N3GuvvHuARayAd3gnxW1PM1K6YqnUfhCkBATOUcNN0hBXJayXoL0yXr0N10iHjIXc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxkieKBlajlIhHeaXpvV62PTW2RSFmpoXyYuMFAtg8JBTCtq3yo
	eAn1X2VUA8MogsrCj4xv19ASehxzRWmfpUuCyEiWouvNA+c+d6xpxcp6TZc+Bv0=
X-Google-Smtp-Source: AGHT+IF1FS9ufu9o4Y4stQLYGJvoNNDm9mRT+SEMwJRqakkQKPd/4nKseuKIJE+lWn0kSfJLNtfHQw==
X-Received: by 2002:a05:600c:3b22:b0:431:52da:9d67 with SMTP id 5b1f17b1804b1-432b74fdaf9mr140208015e9.3.1731407898314;
        Tue, 12 Nov 2024 02:38:18 -0800 (PST)
Received: from pop-os.. ([145.224.90.214])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432bbf436ffsm142270955e9.44.2024.11.12.02.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 02:38:17 -0800 (PST)
From: James Clark <james.clark@linaro.org>
To: suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	coresight@lists.linaro.org,
	kvmarm@lists.linux.dev
Cc: James Clark <james.clark@arm.com>,
	James Clark <james.clark@linaro.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	James Morse <james.morse@arm.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 06/12] KVM: arm64: Add flag for FEAT_TRF
Date: Tue, 12 Nov 2024 10:37:05 +0000
Message-Id: <20241112103717.589952-7-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241112103717.589952-1-james.clark@linaro.org>
References: <20241112103717.589952-1-james.clark@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Clark <james.clark@arm.com>

FEAT_TRF can control trace generation at different ELs so this will
enable support of exclude/include guest rules when it's present without
TRBE. With TRBE we'll have to continue to always disable guest trace.

Signed-off-by: James Clark <james.clark@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/debug.c            | 14 ++++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 61ff34e1ffef..5dfc3f4f74b2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -939,6 +939,8 @@ struct kvm_vcpu_arch {
 #define HOST_FEAT_HAS_SPE	__kvm_single_flag(feats, BIT(0))
 /* Save TRBE context if active  */
 #define HOST_FEAT_HAS_TRBE	__kvm_single_flag(feats, BIT(1))
+/* CPU has Feat_TRF */
+#define HOST_FEAT_HAS_TRF	__kvm_single_flag(feats, BIT(2))
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index cf5558806687..fb41ef5d9db9 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -89,10 +89,16 @@ void kvm_arm_init_debug(void)
 	    !(read_sysreg_s(SYS_PMBIDR_EL1) & BIT(PMBIDR_EL1_P_SHIFT)))
 		host_data_set_flag(HOST_FEAT_HAS_SPE);
 
-	/* Check if we have TRBE implemented and available at the host */
-	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_TraceBuffer_SHIFT) &&
-	    !(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_P))
-		host_data_set_flag(HOST_FEAT_HAS_TRBE);
+	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_TraceFilt_SHIFT)) {
+		host_data_set_flag(HOST_FEAT_HAS_TRF);
+		/*
+		 * The architecture mandates FEAT_TRF with TRBE, so only need to check
+		 * for TRBE if TRF exists.
+		 */
+		if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_TraceBuffer_SHIFT) &&
+		    !(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_P))
+			host_data_set_flag(HOST_FEAT_HAS_TRBE);
+	}
 }
 
 /**
-- 
2.34.1

