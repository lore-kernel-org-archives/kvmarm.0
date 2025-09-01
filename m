Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B4A2E0907
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 12:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756730513; cv=none; b=BDp6keWB6uJJ8nvXssVPj4BzAsIsGprJomy2TPypKA0JLNoWnmDBXNZfLeiZ9qqIuZwT7Olaz8rfPSevCCGeVUNYyDfFr2qBlk9gQapcmMm3wHoU8Qyt+3RrkWiy86h/iRKSis6P7rYfA/0e5AYn2QscCfxZjlZm3qEbsvbCAZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756730513; c=relaxed/simple;
	bh=51vdVVrDG2YLBYS3Pf8NCD6LBuxxPOs+8V116Ol8P34=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VjCTEbWMEglMFaMU4a4bzoXErqcnloJbQ7ueLgxzVhAQpKbdoWvS38DULuUEj+oooIJW3/H0NGL/DMmylZHgju+FxsMUl+nc78YWYiStfaFiSEA0+XrP5J56Dvlnp7l2ovfI5CyLYCMWUSU5V4HjZ6O/FZCkCvZZRBbFotOcFeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hbggBYmS; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hbggBYmS"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45b8b02dd14so6792865e9.1
        for <kvmarm@lists.linux.dev>; Mon, 01 Sep 2025 05:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756730510; x=1757335310; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CE9jiANI0cz/l/cDSr25IEHnZ3OQaeUcRCYLlwFZaDU=;
        b=hbggBYmSFumNbuOpaxGIOyCSjG1ELaSpPtmfNtRDDuPrkps/MJWPyGVotZu6PymXRB
         e6gkpx3Xi87d1y/6/k6WxqeRgxQdajGB8BeqhmW27K4QP4peetrtAiJPBHAv7Sz50JwW
         AhOA6F/PRygZUzLODiimHOGwhmccm9lmon3ICqR6Y1mma3MIJLPM9XpRNBzbYN8BW4eb
         jysW2u8Q5hb/GBo7ntFgoIsV1D6SRhmA9SjdvGHQV7qq6/CXyOnOhWg6C3V6SvFaWer6
         /Ckmo5IjJ5dEzD4GULajgnU0HgJjDfa6DVK3mXyQzffTu+ER2FMAjdhAHZyXkH9g1HC/
         nBIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756730510; x=1757335310;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CE9jiANI0cz/l/cDSr25IEHnZ3OQaeUcRCYLlwFZaDU=;
        b=jqwT2WrW+BTdh+Bd7KFl5n83/vcDVLk7ArtSM6RJGaIAvNqcpTncQrRJiCSIxCfPQ7
         /cYnM1p2VOceVwhAW5/d2yzNxQL/8lq6H7k39yCRmkrR1+A5lCRuxbg6WRasr23n6u0i
         Q3FP9dFqT4Q0/fZ6/R0x4zz6kM/AkLbhfsh5kEB/zJg++bqocG8lFvO0QRpxKcGvRxko
         Hv+U1Kc19i3AcfkvYncLBJnvr7fT3Wba0PU5avRGT+epOKaqujFOp5cIzVaJx1ZnUq9C
         AJPuMMmh6O2k55RqrGXK09yQqCngiWx+aeutqebbNtVW1KjyBoU/icndjL/Vny8TyuQu
         JtbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXg9dOvIYgTqLqgWWP8o8TYrRmHgcW06KJLw28RiS+WKvoygEetPF/nIt3hPH43W6mAWoxAxpA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwQnY9ltcoVQMs9GPs91v2bv9xxqABU38SiHx8Qe5CBLqfIEmz+
	ze0yGCg5BuuWBBJxDBsjYV79ui71cI1wIKG+xLzFJEwj4vgFvwrx5AG9W6RMVtR87AY=
X-Gm-Gg: ASbGncuXx3rgq8v9QaRAsk9N6loI0zSjC00VqV6av4/shTpFQeqPGOjl1A6afPrSBZ9
	jdJ0cVK9URskz5LGCW9ciLECqg3IEREalUTPW7BY/xleH8rXXCIAElzxikZRl3FL3IiYhJKC9xB
	298vPpBhWtr1xfdb52f5LC7zu22pyjvIb80RkvbWCl/9ilOm4JAkpj4dIfb5QNZn+C5XNcTrW37
	TV/tcsWaluwDUyLaPV7RtJd6FYBWMj/XNp6GudBrH3jQj14w9cKgd8lYi8mt4c8Vkx8Aq3rwY9Y
	H1SIs6CswFBKDapxogoq+aFLE7ETJSBIcKxKJlcQoY/yzOMUlE4+NOzYNAwxkx6W9sBGYAXC7Kp
	or02eQDTZpPVbtJkR6LvvxiYhvq0VhOAgwXlYGZDGJg==
X-Google-Smtp-Source: AGHT+IEpKxBP9k/vYtw8Ht1MbnsTYjDO7wEj/uW0QbGaAjhmSNIBbT3ZI/wMtrWxLNIo5Z9MYwmVUA==
X-Received: by 2002:a05:600c:1e89:b0:45b:88c6:70a2 with SMTP id 5b1f17b1804b1-45b88c67360mr50627485e9.1.1756730509844;
        Mon, 01 Sep 2025 05:41:49 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e898b99sm154946315e9.19.2025.09.01.05.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:41:49 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 01 Sep 2025 13:40:30 +0100
Subject: [PATCH v8 01/12] arm64: sysreg: Add new PMSFCR_EL1 fields and
 PMSDSFR_EL1 register
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-james-perf-feat_spe_eft-v8-1-2e2738f24559@linaro.org>
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

