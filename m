Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEE52D836C
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 13:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753103113; cv=none; b=WNXFgH3clHrMybjFSS5krcK0C7FvcVzyb0h7+M8RzPkBSFPT+5RsXi6NmGDINbUO1RZOk6nePu+KqX5L4Nh5pqHuboYEd1p2qRs2f0nnq5adZYPBBNBHNXYWo+ayi8KEHwbhl/fgFluV57j7vKLEEKoETt2XGvms1Lou1uq3V7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753103113; c=relaxed/simple;
	bh=ajsH4sm5qIk98uVqstoVul55QamJ8yj95QFZdJtL4io=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZF99VDrk0bs8kwvW7HlsUEnJLunidN6bfIirR8L9sfsDNvDHmVI2HQETUVHxAjG/j5nXoIGvxAh9Gfpe3M6PcPDEAtoRwpdSaqA02IU3yqLTd/RSrMTyOYtJEUBDvXzkJcF3mDgCWRm1nj0BIVtVJQ6uY/pAnTCfipVKQfSU5UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gvVf5erc; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gvVf5erc"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a522224582so2124515f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 06:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753103110; x=1753707910; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fgBaXSS6eoL+tzDWl4vbvLMipClDtwiPdRYN3wg5eT8=;
        b=gvVf5erc7Df8EuSleWLwbWv/XiuJkfh12UrghLD40U7OXFXJZrX/OOWHhYP08eUc06
         RHjFfYM1VkCmEHv/Mg95L6ugBpq32AuzaBAL55YJIm98jq0Ls8+2+k890PznHUVC+2uh
         Ur91JaFYiAn2wx2hezlPPDLyBsTXWv3N/CIEL8pPiNBrHP0jVkeh4GG+SNNFtc9KkpfO
         TLSUw9PVVCE4ag59LZ0wVfF0SAWG3Viwhy4Gk70rO3QyBwOrYhWCStHu1RxvdsS9LNVu
         yQqywvA4ZiNVJ4KgBlVI4/RonwQidsLi03ZQrnohmrOThcBvSNhNtgmlPMh6UbeyVxbh
         aLhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753103110; x=1753707910;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fgBaXSS6eoL+tzDWl4vbvLMipClDtwiPdRYN3wg5eT8=;
        b=jrpxEMuHXi78QZIGIY4r6XlryaA8UnmtZDp0fTCwrXz+f8nP9HPP6ZccVkmUnVa7sX
         /5KnTIr2DlY1gY8wzbzgcTcVVrj3MTIWhPX+BEhSW6M3/xaJAY+oxyVFfigZ4BQ7Obco
         CNCucXMkqQWEV45MBI+FsCuP2vpzlVGeEISK9XL2sO2o8t4Yt2hsSFyQ1TD2H6r7g6eK
         g/0b2r6tJ1jteXZZPK0k5+w0TxD+uAMwd0fb6/l1cK7LTg/fgYBO1PtY7Hqj+cSqxCXM
         Bro/hMXONksVj00VP27L8TU/VEU4qyIoyKWP0R8rhVSdLEgFl0/xgsHPLPaM51B2nRIL
         TB2A==
X-Forwarded-Encrypted: i=1; AJvYcCVEeuzketBDDOst2cGpagcywBnuKR9Bx4kOm1G6H77XNtr0depJK6BFtnF+jdP6WpXQHg7dgW4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwPypD3wCYdK80K+sIqOGyuW5ZXUejKOgf0gmW1C2pHfC82Vmx5
	OVsl3ICc2gN/QZb2Hw3XrtusalNVTZDKa5tCQ17KDmZGPCnpdTCy0iJBt3cMh+lkv30=
X-Gm-Gg: ASbGncsOKa6/cUZ+BKMLx5JNzzSeJPKmYaurDqS3nhZHgAyyKPIz2Um6UzQuYaSZe8z
	qoLJf8KwkGn35ES9tA5Q6f594/hkKqqA2HMm5ejsGTQfNGKSnAK+k+8BAw4zD44q7pHS2K2Fk5M
	nwMXNCbYIaXHcEzsq3kbinW7js2jHK5DY/wCKv/G5MmfvY1l4ZaddCbhdyZcbHTsGOvD42UUOKF
	hPg+86q7QizuJP0uZsgksp9P6mz+FfztYhj5QBSjfDP3ukuO3T3SzS9wjo+PUuhCYtIV9Qt0cu0
	2E2M2bKsz4luyHV/e0qYp+HvYCddvuk71CqzdaJnUHhpwhWROp7NAsWangS3c2+xEVeKUo8aGuc
	PhJTKGofzugFso5viMWfUxQU2i+XGu2Q=
X-Google-Smtp-Source: AGHT+IHW55CRAG6BTroVDQBsZVUrLOllfWSe7q6H/nJVZXgEqWqhx0CeR+WIH7uAuxzefIuhCImklQ==
X-Received: by 2002:a05:6000:4704:b0:3a6:cfca:efee with SMTP id ffacd0b85a97d-3b60dd6aa5amr15956756f8f.17.1753103110115;
        Mon, 21 Jul 2025 06:05:10 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca5c632sm10485077f8f.80.2025.07.21.06.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 06:05:09 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 21 Jul 2025 14:04:55 +0100
Subject: [PATCH v5 01/12] arm64: sysreg: Add new PMSFCR_EL1 fields and
 PMSDSFR_EL1 register
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-james-perf-feat_spe_eft-v5-1-a7bc533485a1@linaro.org>
References: <20250721-james-perf-feat_spe_eft-v5-0-a7bc533485a1@linaro.org>
In-Reply-To: <20250721-james-perf-feat_spe_eft-v5-0-a7bc533485a1@linaro.org>
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
 kvmarm@lists.linux.dev, Leo Yan <leo.yan@arm.com>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, 
 James Clark <james.clark@linaro.org>
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

