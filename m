Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E81274651
	for <kvmarm@lists.linux.dev>; Fri,  8 Aug 2025 11:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754652228; cv=none; b=jEQWujnCXNFdLyXrI2gw2/hoGqupesf+NURepJ61/vSB84wCEzFHlWX5ixPvI41pYExHSs3tIJJQe9MpRhF3uJFQqCJ4qM9qPS97D1Kjr1rY5gbCt23H796Vi++vQRPNiAOLKTmmTkBzNeR5kODpAlGTYoSpBnkM2l8JC3DDobY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754652228; c=relaxed/simple;
	bh=51vdVVrDG2YLBYS3Pf8NCD6LBuxxPOs+8V116Ol8P34=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MP2Efaf4uIjh5vVB67lvhmb1bK5E0YqaIFuSvokg1Yk44YuOHDM7J0iW2bQEHW+VrcEtABZQQEAMm6Ifc1l7vyMc9hrmOH4GgKmBfwY30f9qEiJ28VQiyi40nLmfKfzGoeFdPmv+44JQKRPC8tLopUWBRblMfqAnX0e0tezYTyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CcwcVlR/; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CcwcVlR/"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3b7910123a0so1778450f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 08 Aug 2025 04:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754652225; x=1755257025; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CE9jiANI0cz/l/cDSr25IEHnZ3OQaeUcRCYLlwFZaDU=;
        b=CcwcVlR/lvCxTxabFyW1vJlmu3Um5oap6Br2cjLRMPpnzhFTK7c+ekR1sDa05BQNYx
         QvHu0lM9hNMAxnwcJ9NUhSBhx8UFUFeygf2aAoisy/RAdfaiNtc5CmaAIOwNl8Jz0MIW
         voY/x+uZjmt3Zyj6iKTWZMbMgNxNZSbp1F10LqP2bC50IW8Wq9P7NTfaBvNq7tPBiC0G
         L0NIHBmh+JzBKRwvlX+44lgy4DJQibKI+JMLkiosIhn9B5vru75M5NQis1aNar7HsFJA
         RbieiO2MA4LXPigoCXS6n1pYkgav5LTnPnWaDILhTRA16Ds1Pr6DRsClTPwkiDrwehWi
         nHew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754652225; x=1755257025;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CE9jiANI0cz/l/cDSr25IEHnZ3OQaeUcRCYLlwFZaDU=;
        b=nhKqnc2uTlTYax2ndk4BBMpjAfZtDvfRalMdd8iQSZPltFeUBK4bHa7JiTkXcbyRnv
         /XP/QRioRAicig7dJSN9r2Uy8WFrL0fKE9wNNg4wJtF2pl0YCLK2bghHBXulS06YM3Jv
         0UZu+yUihuR2is4Qy061XZme/uI6xW+cQKYyA8z2zhqPMBpMi96HVqfxn2xfqiQlgurW
         j22JukX/ZBwZa6fxOwu8oQbHxVrlSGe/B2mAfS1tbrpBuScIICxmvBY1ncBFWOmDbfGa
         1IlviJc3qEWlFotCQikjPxYdAebWBY/Nx/+fsaVYDlQYPtaAMKDAuvNbzN/DYgpduCZJ
         0oyg==
X-Forwarded-Encrypted: i=1; AJvYcCVgd61L/dkkiLihuJ2hym+A01DwM62idwvtZY9TBIw8/hE61YVU/pi75TqP2KZHzx6ruI+Eqr4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzKaXqUO6Hvubq0iCWvMFB+QlyF6VhuOKBC22GZJq2JbMtjr8d5
	LXTrFaz9p+5TYJn8TPE5s51yCMChRMdUe9WscMculYMupscPppHGQg1FYM+I+AKocY0=
X-Gm-Gg: ASbGncud+uElK1ONAk2RE8PUO5GE3kbuPuxkuaIFkCRSN+qEMQFzWCwY/Xfs6SDmH0Y
	3rfFeq9L7gPxsZzudt/27KczoVOe3T39QFs49qGdzG8mUHykuIyR5JdLvPZyuO9mOVxFJDZ8pZE
	pCpyVufC8auUc0ACAq7FRNynyqcRw6WjYFrEpooY1kOUWN8Ya2q722CqK32scxGfM6mJTPZy2qE
	IceYrFJnGDsvwKm0tooAlqqIcENP4MADQasJOo8nJbhALpJbqlQw9JCSf4o+19rAsyDlgiOFWJC
	th93wmPhkiHICMsemrYUqp2Nd5aFzLhPn8Zh2P99VmJrttLIme3CX8vpaFsNZZPYwCK6Q8WLKgJ
	omOSvVV8Bz0wGXEdwEkA8DueF4TSlDAA=
X-Google-Smtp-Source: AGHT+IFB5Rhb7EHeEiI/ams6KhI9UuNHFiZtaUNiO/aRfCno9CNSrWB+oIrGqone/4N7uev3L98hjA==
X-Received: by 2002:a05:6000:2083:b0:3b8:d493:31f4 with SMTP id ffacd0b85a97d-3b900b83c8bmr1969857f8f.48.1754652225356;
        Fri, 08 Aug 2025 04:23:45 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45923c34af8sm233482635e9.24.2025.08.08.04.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 04:23:44 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Fri, 08 Aug 2025 12:22:58 +0100
Subject: [PATCH v6 01/12] arm64: sysreg: Add new PMSFCR_EL1 fields and
 PMSDSFR_EL1 register
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250808-james-perf-feat_spe_eft-v6-1-6daf498578c8@linaro.org>
References: <20250808-james-perf-feat_spe_eft-v6-0-6daf498578c8@linaro.org>
In-Reply-To: <20250808-james-perf-feat_spe_eft-v6-0-6daf498578c8@linaro.org>
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

Add new fields and register that are introduced for the features
FEAT_SPE_EFT (extended filtering) and FEAT_SPE_FDS (data source
filtering).

Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/tools/sysreg | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 696ab1f32a67..b743fc8ffe5d 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2994,11 +2994,20 @@ Field	0	RND
 EndSysreg
 
 Sysreg	PMSFCR_EL1	3	0	9	9	4
-Res0	63:19
+Res0	63:53
+Field	52	SIMDm
+Field	51	FPm
+Field	50	STm
+Field	49	LDm
+Field	48	Bm
+Res0	47:21
+Field	20	SIMD
+Field	19	FP
 Field	18	ST
 Field	17	LD
 Field	16	B
-Res0	15:4
+Res0	15:5
+Field	4	FDS
 Field	3	FnE
 Field	2	FL
 Field	1	FT

-- 
2.34.1

