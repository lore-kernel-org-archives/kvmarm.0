Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EC52192E4
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 10:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749120607; cv=none; b=lZq/5QCEsp2IBye3vGuY4sSxhNCjJQJPVR4ehF22XXJ9Ndh0bEMVcaGPaTGhioFyyfCVlkihZq3jemKS/k3PaNuuIpqAYmyTguEsiDLB4QuQwKkhXWzaZ+smXYQXCF1n3uHtyJJWyaGWf/MQNK34Zelgo6oADaPfbpfPHxvYFjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749120607; c=relaxed/simple;
	bh=isf38v+uTebHr/0KouGZLHu/zXcyClycP3zhjgiVfZI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mHLoEVcFRP8H6fs6TiqVfdns+QAzOS6AxoZHYVaWokyljlBRdJyab/geGOkghZDnGTfKZRPtkzSYVqbkrQ1GYaqPv6ym+YNLXeAkvcmwZjRLG+v04rD6Q22vQM825WMt7OApt4uHOga0egF7pgQ8sf9Inlp7mvurIg4WGaPZuHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Di20sIaJ; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Di20sIaJ"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-451e24dfe1aso6773405e9.3
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 03:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749120604; x=1749725404; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BpkxTGRvQkor5ThWfPSfZfarMFvM1/zI/E944bIEcHE=;
        b=Di20sIaJe91ZVUicClZ92wT8RFS6outy4tVykCcSOfx5DEjpbvbVeY0EtE/2na+8oF
         pz+fu/6WyPKW52S+6JJFN47aSc3X9+uVDgJc//rGyv7okubRsXWJaxakJ1FKINeWRrJM
         MSmTuuEOGjhuHSjL4N6zeCOgeLyRN8axwbwmcFdfCs9D4Gl4JDkCGdmCWY5QYMjIeZfO
         XB6nIdyKl/ULxMXGXqB9HGdpsLKalWR+NgxqXon+CPjUKa10RjZ7rA4mhfnTS82HM6hr
         TKRU1whHz+NTw7Yl0J0gk4xdw88F0OMi0o3uzqtKygusa5jQARNlIjVLA4kBLZF6hyTV
         GLSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749120604; x=1749725404;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BpkxTGRvQkor5ThWfPSfZfarMFvM1/zI/E944bIEcHE=;
        b=nhJaG5e+A3AM6N6UwwTXw/2rGxD1+SgKd+c9nijtoI7WyF+djWET95PxXIvKyCirTh
         aM79ELfs0OcfO9AGLwzvR2nV+dgCLJqq2LQ6wiekYEQr6OcTyU73dsx0IukEvZIBlNdY
         hTGUIQmaQ6UMrTGqe+fVCBRIQ6gNzRbM/cCPCHwj49Un6gIYUkBbxQ5++wV3Ji0hzxJ4
         VX36aA0NPtWm9U8xS3vcZx7+xqqkmyJnrwzf7KGwPwG/MwKxuSIUSZ3aFIWMb/mxcHo2
         VbbzUwYf7c/S8555a1lpjAki3MKhH+wfK5S9p2iKTmUPx/Xxz6rUoXtu/uSrzoDaS8ya
         trmA==
X-Forwarded-Encrypted: i=1; AJvYcCWDdJUyq9gYXA3ABIT5p+O5iIzaRY+lU9Iiv5ucQ0/VBMjPfOilw6iCHjsbVDX6L3BJTnumtVU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNBOeVMQEhklQkNWivj8GV/GyqoHjZhOhTs1v4Jsb1YoMAzFYg
	lR5cAZwRW9Whl2ubejmQDwjqhoKVKz1VjpwyUtAzwpN/Zc9joXWzFjNhri8I7DRWlq0bU6I+Xy1
	ylZtyNNA=
X-Gm-Gg: ASbGnctbS6xj1om/7EaoSSiVgfKpgHPnjhYd4RUCT6lf/2dTkE8jlgUA9lYpTPLtXdh
	rS7yKDSsNkBCNfOvGSLXnUvpYIP//RBvyOg/W3+JhD7Hb+d2xCrzGIm8ns5tfbwbOHHo1RbBnVo
	AFoL/BhMkjYI2qHI6vxZPuhf2yCf8S5MPTxPA+tBEFt8hoxL7Zm+RySrseNk1y0vJD/oLV6iG0l
	3v9fc2YHu+N0N+dGD8lbtNG+waOb4cv49EirqqAt3MQ45B2cPsPHNiCW9/XbkVRjatrZ0IEYyKe
	tmowLLDccolYfi2Y0HmF+CmwPcvbX96K3wGcWTIUTIG6zceLuUF36BOgL3MF
X-Google-Smtp-Source: AGHT+IGzwrshaRz6RzNc0J7tOxVdD9PJSTMnVH2Zjax7vPL/2HgFnaNJ3JtdmLcA1rgDpG5sbM8aDQ==
X-Received: by 2002:a05:600c:8b27:b0:450:d37d:3584 with SMTP id 5b1f17b1804b1-451f0f31013mr62452085e9.13.1749120603619;
        Thu, 05 Jun 2025 03:50:03 -0700 (PDT)
Received: from ho-tower-lan.lan ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-451f990cfe3sm20629965e9.23.2025.06.05.03.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 03:50:03 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 05 Jun 2025 11:48:59 +0100
Subject: [PATCH v3 01/10] arm64: sysreg: Add new PMSFCR_EL1 fields and
 PMSDSFR_EL1 register
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250605-james-perf-feat_spe_eft-v3-1-71b0c9f98093@linaro.org>
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
In-Reply-To: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
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
 Adrian Hunter <adrian.hunter@intel.com>, leo.yan@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, James Clark <james.clark@linaro.org>
X-Mailer: b4 0.14.0

Add new fields and register that are introduced for the features
FEAT_SPE_EFT (extended filtering) and FEAT_SPE_FDS (data source
filtering).

Tested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/tools/sysreg | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 8a8cf6874298..2e897d8a4040 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2859,11 +2859,20 @@ Field	0	RND
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

