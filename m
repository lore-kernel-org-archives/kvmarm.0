Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECD028E613
	for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 11:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748518393; cv=none; b=mS/07DY38SSSHFqsn/cy0mBOnQ2okbkTk4lm8piulyZRsLjNEBLLKhgGLhFCX5PTW9+o2z5FIFJ97qYIaVX3Rk8CCLdizyplls8y+xuSfiZrDiAvLSnP9OagOewHzaF77Y5uF3AigEHsN71tPsnl3eZszytudyJIhsdMXvKMhCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748518393; c=relaxed/simple;
	bh=0kXgfqs3fyfI9WK4w4EvE8F1GbYyXHS3q4H/r0Lm5Zo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dhb2FeUUzQanKTHxt1Qpx6IGBrXNnq4eQXxp870oiR+JybUxIB9b7RXWNMspkX7Qm2bqE25kweCzElIDYXVs3ak0E5iFB/oGx41pIeeGBCQXsGsE9tyMPLRdhCc3FWR+M6ERmIB68Zs9SQuzl1k83quVeqXeW8C64PO/41AFO84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HL3yWx53; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HL3yWx53"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3a366843fa6so426764f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 04:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748518390; x=1749123190; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ENKrydK9y6Ncy6QzWlN/lVHecxyLZuFBTl1oby0dHM=;
        b=HL3yWx53m1ms4TeiE+UPfk49Ed5T2E3DM7uH4STplcFBYzt4BtmizZ4aNavhFNExpq
         68x4aZfE0KkPQx7k1rHeoKKeI0ZAuNfA0ITZVVsmru0blfi1lLEltNqzpo33maTXlH3a
         UOsPoRWIJzYRYJiGtzKvIs7GoeuQ9s7H20WsS6HBxn5TgaAo1D0qbbIjsGQEfAXuddDz
         bYUffT7u+S5P8qU5krv0B0xc8dTBHkJ2dkhlQRJJ2Fjx8HGUFbq2O3uu0OGKUmpf/Tm2
         +m25Yhl+MkVrrz5070j0IcnklVbk6wC2So3QgaMLR6g6mUg/lC1ZQ8C1GwJ+t/08hX37
         ZmwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748518390; x=1749123190;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ENKrydK9y6Ncy6QzWlN/lVHecxyLZuFBTl1oby0dHM=;
        b=nqUDL6mSXc4eXF+gNK6dKKxTI5beCLnyqOOffBuL5ve2oL6zbvNegh4Iju20nununv
         8ZYajkGU0jZQ1YD86zcUpu6HKqdiD6Z1ltHQ7FfJo2Un3r7A3IgtPW1uNUaVCIkd4q3w
         ldb8/MPNURG/S93+8GF6YOv8oz+32/y9fIjU3TlIjvzu7ee8NDSfXGmhRt2QY0boReVV
         3Nx6kkcVUvyR0byBAunEvZ1Zh49GA8d8WS9Ftmvz/4Ytms+smPWkuXxcxSlNp1GIyO7u
         uCmN/O2I/sij5X6wl7/xvI0xcSE5ODmq+FGwZ12V/Z199kNsFXT2tyN6zxXmRtGCPXn4
         6M3A==
X-Forwarded-Encrypted: i=1; AJvYcCUuePaDC2N2j6tdWFw335dBamVr6B6LtZ7VW0L4KNUFr4cdv5s0b2KjlFhDpSubMAfZipR6fic=@lists.linux.dev
X-Gm-Message-State: AOJu0YzWM3sQ4aW19qpNrOhc0DsHjSnLzFnZVOsRqxquU8mv7MDEGDRP
	5LQhIyCEfVrBRU5AK1ELJUHgt3xOYYvbZEP92tcpRD1Da2+X9cZLd2utzC792eExzYk=
X-Gm-Gg: ASbGncu6g6z3EZNAfPdrqNIHUhQbZZk3UGzBS0DGyGKyxEAWJ3hnTmEkdZMiEMIR7V2
	FhNzfDa7zQSsaLIlMCm2KtdbrkRWxhZoNWWzWyezAyY87PVU/LN/KZFkaxyPDpLFwcxJEexgvpb
	BvMXp1+oqniNoWfTNie5mVQb/HEUZ9ushD/bBpMfYe7vv6359qzqwVf8Dvgd3yhasP1ryqWt/oW
	BiK9kls1XgpkY6j4z8f7FNO6DckLW21/Hkhu02VXw4+wf310yieujJkYVFecibjGa/bskIhhWV2
	zEV4mHtcT0oMDmmba2kUyB+UiANRA0g7EUq2CDMXh2rYuCr3G1sr2mlwI8Gu
X-Google-Smtp-Source: AGHT+IGzW6H/JY6okGMYKiGy1G81BD38MaxIg1/bSFnC+yh1zhWoHrWS5IoXHEN57n42Gztkjj9u+w==
X-Received: by 2002:a05:6000:2011:b0:3a4:eb92:b5eb with SMTP id ffacd0b85a97d-3a4eb92b7damr3548709f8f.50.1748518389701;
        Thu, 29 May 2025 04:33:09 -0700 (PDT)
Received: from ho-tower-lan.lan ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450cfc3785bsm17443945e9.40.2025.05.29.04.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 May 2025 04:33:09 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 29 May 2025 12:30:22 +0100
Subject: [PATCH v2 01/11] arm64: sysreg: Update PMSIDR_EL1 description
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250529-james-perf-feat_spe_eft-v2-1-a01a9baad06a@linaro.org>
References: <20250529-james-perf-feat_spe_eft-v2-0-a01a9baad06a@linaro.org>
In-Reply-To: <20250529-james-perf-feat_spe_eft-v2-0-a01a9baad06a@linaro.org>
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
 Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev
X-Mailer: b4 0.14.0

From: Marc Zyngier <maz@kernel.org>

Add the missing SME, ALTCLK, FPF, EFT. CRR and FDS fields.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index bdf044c5d11b..e7a8423500f7 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2226,7 +2226,28 @@ Field	15:0	MINLAT
 EndSysreg
 
 Sysreg	PMSIDR_EL1	3	0	9	9	7
-Res0	63:25
+Res0	63:33
+UnsignedEnum	32	SME
+	0b0	NI
+	0b1	IMP
+EndEnum
+UnsignedEnum	31:28	ALTCLK
+	0b0000	NI
+	0b0001	IMP
+	0b1111	IMPDEF
+EndEnum
+UnsignedEnum	27	FPF
+	0b0	NI
+	0b1	IMP
+EndEnum
+UnsignedEnum	26	EFT
+	0b0	NI
+	0b1	IMP
+EndEnum
+UnsignedEnum	25	CRR
+	0b0	NI
+	0b1	IMP
+EndEnum
 Field	24	PBT
 Field	23:20	FORMAT
 Enum	19:16	COUNTSIZE
@@ -2244,7 +2265,10 @@ Enum	11:8	INTERVAL
 	0b0111	3072
 	0b1000	4096
 EndEnum
-Res0	7
+UnsignedEnum	7	FDS
+	0b0	NI
+	0b1	IMP
+EndEnum
 Field	6	FnE
 Field	5	ERND
 Field	4	LDS

-- 
2.34.1

