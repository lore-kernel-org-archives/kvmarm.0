Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B41232C300
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 12:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756730521; cv=none; b=hXUEVYMPo3UK1+iGxsub2MaLxkHMXps4K+0T2xWVfi63q824XM8f2LoMDsx2Wkq8dvks3kz1Q/vNG5lRI23fIaNeJXyE5u8jj6YtccblelNmes/ilCtCszgB/hyht0CZX3oOTNZb+iZZaPkeJTTrNEfwhC0Egkqyr136lmqti/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756730521; c=relaxed/simple;
	bh=oruhsQ/XnkBWLsHo0pDjGsCJg2Naa/yFYEoihUsJuQY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=b0ccBqUOqPkQ+1x5adiQ4okWBHpGD1sahUR+ilCDPf78MouFveI4fYN5b0tVpM0BeBpTCgcNnnH+Lw6atzgGIYAGsw5KJJhFhsASLTZh9nJsebNZXDDyx5Dk2m63XiLki5YXHCWnMWEzj0ZwU5Bua+IQDdQs9s3quzjNc06B8p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IR5R8crs; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IR5R8crs"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45b84c9775cso10735275e9.0
        for <kvmarm@lists.linux.dev>; Mon, 01 Sep 2025 05:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756730516; x=1757335316; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IH4IhsI7u0PxrBs1+bnHSTEJenEfrd4F7dzjVPqlBZM=;
        b=IR5R8crspD9YMg0sEglBl9YWOXWSrhxY36BYGbpX2zSwjzeXVNABfWWzx3uGyoAnN1
         ukhCJrzItcS7r84w2Eo7WyL2XP6e+FVkPGW9BsGc35DrJTv8XFLUWjE6TJVXdrbKY+aS
         9vmdZyKeYVywtYhe43LiN4kieTvqdK2sdNChPI5rSdAOF1ZCaXIMEp9tad6uHXsdDbKa
         YM3I7YgnBTr6Wkaa8Y5hB3+ElQCN6/tMXNeQZOQiUeYwgVmjxxbG7nVu/xsjiUrlqDOc
         hH5Z45MGbisUvXQhH2PwThdvbCu4JbIDK/xUvY9iZGAS+SVjPL/OAjYXDqR+rMS5Gjp3
         rXmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756730516; x=1757335316;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IH4IhsI7u0PxrBs1+bnHSTEJenEfrd4F7dzjVPqlBZM=;
        b=dpd+aFG8iI/ar2SbuhMCid5K8KVhMgQ2xkyUqNW5K7fSdlpjrnWsKPpM1yCtDGd7sy
         ywRUjNEumSE+8S/EyXFNUO9Xiq4/ESdmzT+Ld0rNlnd4EJa9AObHIpaV6HHOfNVIn77I
         TGIoqmP4eeN0vJx3tVbxcO2hXq+fIPlmuc5Ap5tRli8n8mI5W3wYNEaKNICv6ENcWmw0
         uQpTxNRDK1MkP/+echieXaVSlZjf0DgMM/1E+Th45b3tQWrB+fTPlLu7XpfSptvgiKBN
         9myRvPHNaWqXchfBzvV4IM+n8s9D7JijLUV5lkVGcns4cAeZYxdIFHkBC+r/UkMkPX35
         835A==
X-Forwarded-Encrypted: i=1; AJvYcCUtLXoyoIyaY7vjcpe8vpEZqENCBu8kpSH0MWh5StY+H0ffLFBpJoraePN/1KmHmwxgiNmgPxU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyJS+bSN4ISCHXY77VEHsFnwEWhkglaO9KJYbtyYoG8flZS/bt8
	Qxvc+18NIkGotA8uTiyWX3UTyqsS+XZbPEqukYYYu01OBFNisHIbu1BiKvJArFk4i+M=
X-Gm-Gg: ASbGnctkxmGGuM8f0a9HslChOSAKV7/UXep6FqqwCAhYT1y7sjnsULkgz/6a7zDbLUR
	cVwIHtiGAE6ZHit57uPb6wu2dNAJ0pzHRLTd7lQ6cGNVpt588Ags8MMjSBFAO0ZTymkJXUzfFCq
	PF03fy3Lyz2QY4g+BSxW+VEKHml5iuSWHPjMTxvVpsJsjASpVuHwenxBDOkU//ZX3ofuGb5tb5E
	fkInKLXujLZtYg5Zli+4z5xja+pqmes81vFTnomxtYRRYq70ymODEpDIF9XpAlfFGvtfe4gytmy
	XnuHhj0y/zqf/0j0DRGu02uk8+JbIPfb1ZXV/nibqo6dUorMPul//xNKATPhMHPwmh+KlBxaCBJ
	Rz9Kyt6za36pufVjTk+U2FUXAOjsfH0Q2HQHEIwTAGQ==
X-Google-Smtp-Source: AGHT+IHhau7EY0MQDlSyqPT+GtgoSvzp5Mp3oC9O8x1gCNdLj74/uD4J58UjK1u3FTzG5sPU+DMpPg==
X-Received: by 2002:a05:600c:3b10:b0:45b:8f38:8d36 with SMTP id 5b1f17b1804b1-45b8f388f6bmr19047285e9.30.1756730515555;
        Mon, 01 Sep 2025 05:41:55 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e898b99sm154946315e9.19.2025.09.01.05.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:41:55 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 01 Sep 2025 13:40:34 +0100
Subject: [PATCH v8 05/12] arm64/boot: Factor out a macro to check SPE
 version
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-james-perf-feat_spe_eft-v8-5-2e2738f24559@linaro.org>
References: <20250901-james-perf-feat_spe_eft-v8-0-2e2738f24559@linaro.org>
In-Reply-To: <20250901-james-perf-feat_spe_eft-v8-0-2e2738f24559@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, Leo Yan <leo.yan@arm.com>, 
 Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, James Clark <james.clark@linaro.org>
X-Mailer: b4 0.14.0

We check the version of SPE twice, and we'll add one more check in the
next commit so factor out a macro to do this. Change the #3 magic number
to the actual SPE version define (V1p2) to make it more readable.

No functional changes intended.

Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/el2_setup.h | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 46033027510c..a305386eb2e3 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -91,6 +91,14 @@
 	msr	cntvoff_el2, xzr		// Clear virtual offset
 .endm
 
+/* Branch to skip_label if SPE version is less than given version */
+.macro __spe_vers_imp skip_label, version, tmp
+    mrs    \tmp, id_aa64dfr0_el1
+    ubfx   \tmp, \tmp, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
+    cmp    \tmp, \version
+    b.lt   \skip_label
+.endm
+
 .macro __init_el2_debug
 	mrs	x1, id_aa64dfr0_el1
 	ubfx	x0, x1, #ID_AA64DFR0_EL1_PMUVer_SHIFT, #4
@@ -103,8 +111,7 @@
 	csel	x2, xzr, x0, eq			// all PMU counters from EL1
 
 	/* Statistical profiling */
-	ubfx	x0, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
-	cbz	x0, .Lskip_spe_\@		// Skip if SPE not present
+	__spe_vers_imp .Lskip_spe_\@, ID_AA64DFR0_EL1_PMSVer_IMP, x0 // Skip if SPE not present
 
 	mrs_s	x0, SYS_PMBIDR_EL1              // If SPE available at EL2,
 	and	x0, x0, #(1 << PMBIDR_EL1_P_SHIFT)
@@ -263,10 +270,8 @@
 
 	mov	x0, xzr
 	mov	x2, xzr
-	mrs	x1, id_aa64dfr0_el1
-	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
-	cmp	x1, #3
-	b.lt	.Lskip_spe_fgt_\@
+	/* If SPEv1p2 is implemented, */
+	__spe_vers_imp .Lskip_spe_fgt_\@, #ID_AA64DFR0_EL1_PMSVer_V1P2, x1
 	/* Disable PMSNEVFR_EL1 read and write traps */
 	orr	x0, x0, #HDFGRTR_EL2_nPMSNEVFR_EL1_MASK
 	orr	x2, x2, #HDFGWTR_EL2_nPMSNEVFR_EL1_MASK

-- 
2.34.1

