Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5232264B0
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 00:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980273; cv=none; b=uyiFLjSG6yVRw+eUz0c9ve/afY7BSTV5TAYpUu0UvZTSqhDgOkgMFFsTOOI7zk/NWTr/nc2OvIA68kZ38kjUbg61smuhxfj7REs5lJ/SUpQE2OXBQp/53K4nSo7JZV+9s46BiwRcS1ftY8GkPEWjUONFdFZ6fZYfcAeFik8i/gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980273; c=relaxed/simple;
	bh=o32NYSL5oP89MnyU43/Lrt7hcO0vsyjmOnag53iPYE8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MljQS0Yzx/P1nrHLMHBYoI0u7NzTX78Wot21wgcqoS8zz4F4tkZEXSvQIpaaKquABKtl7E3qKAn8RE53e6XLHkY2UfdZ8t3sTWVkNrvLH370VlPOQQeq7/E5G2gLQSxF9hytsfkmLumgBBLCBL9DdPJmWdjVRDo7wZjbX/CyWzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4ExcDrhb; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4ExcDrhb"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b8ed43cd00so3148741b3a.2
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 16:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980271; x=1765585071; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=704FSrHxrLR1ctx2c3pAZj/r3vJEFglglFSFFl0Rh7E=;
        b=4ExcDrhbJhCIT7Pcwr3DRKcfTReggBkvfcR5e6Amzr4XGbVWlrE6jNdTcC4uknk3xW
         xKLgvaP4chznucOXLRkJV9+jBYqa8kXpDCdVuJ6nSmM1a/5H9s+bhAmfTqt2W4Zj56bv
         /I0rq1fwMVvuKd/VndIcHPJ5kYszzDYGrRICH1j4e+EOdC1ZWhTtWsw51c0atD0AcDq1
         i7udCCzfRE/OOhmaDrPZmRAgf5Xl1VIseD5nWEKzzt0MDa8f2sZDI2U5xAfl6ht4i/Yz
         tgiuNuyZnP4idXdnulWYEMn7KBIkkZ2P4ugtBFZklc7dFFp9dQ9H9dT88cVPoDzrXDhn
         ho/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980271; x=1765585071;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=704FSrHxrLR1ctx2c3pAZj/r3vJEFglglFSFFl0Rh7E=;
        b=eZkxyAfp9F/k59hWtP+wDUT1BhzXXk1sklla5V9j7i2U8IL2+Z/1qQZhEtljxHv5ae
         QOMUiHOmTlk467oOu/LsMjcMftMc71ql67JPrScBvzhL8eDiXlYIKvgf8K/H6k1yO3yK
         8F0+pNB2+qLOaPN//uBKboxxILwegG7wTXqhmijtVEsUR9ONoyBRyTypSqpa6eQYKVtl
         xNQbysLlBFsI90xtNArE0nIvOybLD1Kgj8OLW5UzjTAtp/4RetRoxZiUCgP+YkIYecdH
         kBnAHuhEki5YzIx82yYXrxDheSGnkBET+UeAnAZRVyxfZm/jv+NwEDinDIVYwPOgLUGo
         YQVg==
X-Forwarded-Encrypted: i=1; AJvYcCUykRqrfs4LWBpK/xn35CWUOpyPhuaGkcYFSvPGKzfkoKCJd5Ms4redmL8iz1UdcbJIlaN8LEY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxpg2OwzDXV6VenieDzW2Zq0NvuTR2ZS6U/JhYEn6NS9ETkTQUR
	OQLhGlM5t9gUlHlZLMRhhECPnfsKXS4+qfhUvGCRgggcRLMGB0doatygWl87W5Qdf2G0vSM1fEI
	ADdib2Q==
X-Google-Smtp-Source: AGHT+IH7A1gUOgKFKJnzRngtLUVtNHZRNw8i6EgWRT3b89IXq+CAXu6n1GyBnJNQ7qWDwlQy81DLJeMmjzQ=
X-Received: from pfnr5.prod.google.com ([2002:aa7:8445:0:b0:7dd:8bba:639e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2347:b0:7e8:4471:8da
 with SMTP id d2e1a72fcca58-7e8c8924252mr849439b3a.59.1764980270980; Fri, 05
 Dec 2025 16:17:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:16:48 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-13-seanjc@google.com>
Subject: [PATCH v6 12/44] perf/x86/intel: Support PERF_PMU_CAP_MEDIATED_VPMU
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Kan Liang <kan.liang@linux.intel.com>

Apply the PERF_PMU_CAP_MEDIATED_VPMU for Intel core PMU. It only indicates
that the perf side of core PMU is ready to support the mediated vPMU.
Besides the capability, the hypervisor, a.k.a. KVM, still needs to check
the PMU version and other PMU features/capabilities to decide whether to
enable support mediated vPMUs.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
[sean: massage changelog]
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/events/intel/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index fe65be0b9d9c..5d53da858714 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5319,6 +5319,8 @@ static void intel_pmu_check_hybrid_pmus(struct x86_hybrid_pmu *pmu)
 	else
 		pmu->intel_ctrl &= ~GLOBAL_CTRL_EN_PERF_METRICS;
 
+	pmu->pmu.capabilities |= PERF_PMU_CAP_MEDIATED_VPMU;
+
 	intel_pmu_check_event_constraints(pmu->event_constraints,
 					  pmu->cntr_mask64,
 					  pmu->fixed_cntr_mask64,
@@ -6936,6 +6938,9 @@ __init int intel_pmu_init(void)
 			pr_cont(" AnyThread deprecated, ");
 	}
 
+	/* The perf side of core PMU is ready to support the mediated vPMU. */
+	x86_get_pmu(smp_processor_id())->capabilities |= PERF_PMU_CAP_MEDIATED_VPMU;
+
 	/*
 	 * Many features on and after V6 require dynamic constraint,
 	 * e.g., Arch PEBS, ACR.
-- 
2.52.0.223.gf5cc29aaa4-goog

