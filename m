Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CCC26D4F9
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 00:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980272; cv=none; b=kA+TSGRfECnVAvGewIhSimh7RXamzykrGSs1bGqodorxzOJOjH9HwkaKQQNUbhoZ+kgwtfOjNK742eAlXHbh2mTntw5M/OxI2lF/HcHz0U+xIeCzXebfRj4Ep4VMfhsY2gsna+p5DN5qJAyZAc4SqpY3diyu39ntU6Q005pQJjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980272; c=relaxed/simple;
	bh=1cCrG4DCg3nVbAW9oH4QXbYa70u3YhFDXh9Xhmff200=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jpq5q/jS4Oz1zK7/u873qssmL2FPw2kMNMh/JE3gcWP+9pWJFPl0jjwOxjCi4SyVmUfnCL3uDo4gco/Ehon5ZacV96uZJfiLRY8dZEZ4yYAczo6dDWTv04LLtKjniqvGxxzvBG7/HTK9j1y4HIFXqdzdLqeWCwTsSkyuCGBFI0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ixXGh+W4; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ixXGh+W4"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7d5564057d0so7138143b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 16:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980269; x=1765585069; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OFskCraMCAt1o1jXv8Q2cmHJ2OyK2yl9CAVs1/Lc01w=;
        b=ixXGh+W4mycQsBB6inR/uNZj6TNGJr5RqmC8ET5XhQWRGDyz+eCdvu+ca8xxakFZzl
         a7Ceggzk/oOy8LRYWZqRcwGNcj539g5xrlZQXZFfpRBJ/uXbOfQ10x7OctW1Ft9BvxnG
         euOanRjDadkzIi+wKh9bp/U0GmrKRLWPZyKkS2pjtFWybwzauOwj1XTq4BM7X/FS+iPe
         7XHDGnA8P9IdGUhJKMJtGIfC/dUJVn0ba4Q3nYhxnwkDlhdBM8/zPuwWB8rSHX5tjipF
         GWOANNTlcYiFAA4aNvZYcUnyJFIxR9vacCjCZRDxysUKPsb6EVaisPkayWU7VZ+981W8
         7wJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980269; x=1765585069;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OFskCraMCAt1o1jXv8Q2cmHJ2OyK2yl9CAVs1/Lc01w=;
        b=lJgUOjKZJt2VTi/JmmV48Jvp8GByqYAVYBCQuBIYpvxch+Ak0rlc4arqvc2YTuJm0q
         rk11Laka0WESnwZndnwb1DpXa1i7Hq8+IrPgOZRsvCzYzZooYgptySXNfQy6HVwFWree
         H0IyvNrvT6GCsJmnI8kH0h6lTPH2NVr0reBr4RFDGP7/FkGnxH9Q4Wn246pPY8RUdg4M
         H/My8aarR8ppkRwEIEKwZNTa+50gHWtDPXzERD5pljb7x4e8ntsNkN5UT21zxjPk5PId
         tW8Dha6icHzAvAExZ7WDCvwVveQbEVKsbW4aWz9Xt2T5nMkuBN0u+TA1qOVmuJ41rXCB
         nAiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmwdfMbtdVXbH60urArLn0ULMDZbkK//WZzNuyM+x0HELGHTmrpNq8nWJL0dn5jQwsQTiDOV8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxybbkp0dwkiH6aTmRaGfncnSE2vGUaxqP+/UFjvq6IwIq+2sJf
	FoPwUl244rXsPvWf018XMCFHsMFwY0hi7KPozVCjnBgPGHaiGePxBWXgRiVI54mCZMgrcijN1JF
	zbs1BwA==
X-Google-Smtp-Source: AGHT+IFfI+s5eY5Nrz61icCfCwYv8IGUZBRQf6oh7KDogWUJprIuAF6nUR9g3xDsrE/LDxUvXG6Y79XK/ls=
X-Received: from pfuf34.prod.google.com ([2002:a05:6a00:b22:b0:781:26f4:7855])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:234c:b0:7e8:450c:6195
 with SMTP id d2e1a72fcca58-7e8c6dac143mr767576b3a.44.1764980268965; Fri, 05
 Dec 2025 16:17:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:16:47 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-12-seanjc@google.com>
Subject: [PATCH v6 11/44] perf/x86/core: Plumb mediated PMU capability from
 x86_pmu to x86_pmu_cap
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

From: Mingwei Zhang <mizhang@google.com>

Plumb mediated PMU capability to x86_pmu_cap in order to let any kernel
entity such as KVM know that host PMU support mediated PMU mode and has
the implementation.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/events/core.c            | 1 +
 arch/x86/include/asm/perf_event.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index bd9abe298469..1b50f0117876 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -3137,6 +3137,7 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	cap->events_mask	= (unsigned int)x86_pmu.events_maskl;
 	cap->events_mask_len	= x86_pmu.events_mask_len;
 	cap->pebs_ept		= x86_pmu.pebs_ept;
+	cap->mediated		= !!(pmu.capabilities & PERF_PMU_CAP_MEDIATED_VPMU);
 }
 EXPORT_SYMBOL_GPL(perf_get_x86_pmu_capability);
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 4cd38b9da0ba..4714bdee17b2 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -296,6 +296,7 @@ struct x86_pmu_capability {
 	unsigned int	events_mask;
 	int		events_mask_len;
 	unsigned int	pebs_ept	:1;
+	unsigned int	mediated	:1;
 };
 
 /*
-- 
2.52.0.223.gf5cc29aaa4-goog

