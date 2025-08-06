Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFD62D12E2
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510271; cv=none; b=ZDmBF0jpanOtNxr4UfYXltr30oxx143sKqbFVQruQkR5QZQkgv+ZoNkGfKkOgxmWlEJawpy5EgBMy7SuVx5fbi39AKm+kco5Fft+Or9gOGa84Zj7ejcB9K3yaMxrYeu4+5/ZIg3smYT/CdK5oAJPZjPOUx4vSZO+vZmZn0YQo7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510271; c=relaxed/simple;
	bh=5aUcvaWHp6TRUDOiSNC6KCm1Cyy80ztm2LX/UEyRYFs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z7sc1kV/FVQq5VTNJ0b7lddJBM+SPE6bbgTy9vKFr4mZjbSlqu6isXKLDYkU2zq7BufJlsZPc4JQHspc++HgYeDNOHfrSxzrsBGwK8VULY/LNDTmGuPahZXy5BBXlUAb3qyacOPaDYJxYHiqvkrFFHLAPVZuTVLVxGTwAVGOZBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G1O7+JWu; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G1O7+JWu"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31ecb3a3d0aso274398a91.3
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510267; x=1755115067; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=V6GitVs58LgSs5T9j7jt8hclUfm0doY6DCHFmJ55L1k=;
        b=G1O7+JWuL5lDnoobF3ssj2zw8mZSTBk3YqiScJPzYx/C5CZLM+cv/AQJDWcBkPIc3p
         LVWVpsCPB1xy9bPUSDBa5abRBBCaJoqsY7PQh3SzSue9aHme9NRyYAVre8cZe6pzz0vu
         N/jpL2RNcXrbpGsIElGXa9yWSgNbitPIXYM0FTG/EVzuLsariSUivhfYFdgXpxCDati0
         GrsdcX6VvyY9+Cd7GWNNcPFTOYQyQ4Z52GgbQl7rxmAK00iJBDro9DNmei6+Egy+yx+i
         ipJhA5UwBm7qBNGuyi03KNt3KrDzB/qhT9P6onUObrlh8iqCwfqX5CBKEp3T82VNkYOa
         fauw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510267; x=1755115067;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V6GitVs58LgSs5T9j7jt8hclUfm0doY6DCHFmJ55L1k=;
        b=RO8/Kdkdk1UY2gnMUS1oKDHiyZAgQ8+GI/I49mc1gmQAu3/tRqt60msqJfUoe1g/Gx
         QvemWZGZB1ubAi/RPfsgbwiUzvxNX43UPUUOIMwsaPa8qE+0mbkjRFkaXQPbGyZh87jc
         msTDqeCueMDa6yqhr7EM0YzNYHLfaZohKFzrUIs4RlBapvuw0drxdE5bc1p44ir9G4Jn
         K583YnB/bMA8blpQiNqHkpmeO2Pls/L2d8sWL0kP8QOdx/dPFJ/UnItya7MMYgM6yyRO
         1V+CVoi7xkDnHYrRJQgMmD87RwhaYiTSh6uewoMGlIglsdAEgBY/FNyRIe93aXfwE9F2
         rGbA==
X-Forwarded-Encrypted: i=1; AJvYcCW2P2XrC30vOR+yuooTyFAA2LmhBIf29eMZH0iQy7jKXA1BsfOyRi5732EzzrP/NeqHtW+HtHw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1B0m2RRNjGUKK5K4Em/fB1Qhth5X7CwxMFiBUIU3RbrQ1yqkn
	hRFQ5YcjU7puS2LAGnt0hdCnVlPlLz0yy7fJNBCwgTMhHMkBNM2kpmyzjDbBax8Ahrsq0CsA3V4
	mXgeGtQ==
X-Google-Smtp-Source: AGHT+IEe9aouosNHmFsjzcywZl+bDxrMa7gzbIrywT1O9OJ/U5YazLpsqSIEAJkZctqsm307cXJuaDMPuPY=
X-Received: from pjbee13.prod.google.com ([2002:a17:90a:fc4d:b0:311:462d:cb60])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2743:b0:311:fde5:c4be
 with SMTP id 98e67ed59e1d1-32166d06ed8mr5169966a91.35.1754510266366; Wed, 06
 Aug 2025 12:57:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:32 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-11-seanjc@google.com>
Subject: [PATCH v5 10/44] perf/x86/core: Do not set bit width for unavailable counters
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Sandipan Das <sandipan.das@amd.com>

Not all x86 processors have fixed counters. It may also be the case that
a processor has only fixed counters and no general-purpose counters. Set
the bit widths corresponding to each counter type only if such counters
are available.

Fixes: b3d9468a8bd2 ("perf, x86: Expose perf capability to other modules")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 9b0525b252f1..b8583a6962f1 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -3125,8 +3125,8 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	cap->version		= x86_pmu.version;
 	cap->num_counters_gp	= x86_pmu_num_counters(NULL);
 	cap->num_counters_fixed	= x86_pmu_num_counters_fixed(NULL);
-	cap->bit_width_gp	= x86_pmu.cntval_bits;
-	cap->bit_width_fixed	= x86_pmu.cntval_bits;
+	cap->bit_width_gp	= cap->num_counters_gp ? x86_pmu.cntval_bits : 0;
+	cap->bit_width_fixed	= cap->num_counters_fixed ? x86_pmu.cntval_bits : 0;
 	cap->events_mask	= (unsigned int)x86_pmu.events_maskl;
 	cap->events_mask_len	= x86_pmu.events_mask_len;
 	cap->pebs_ept		= x86_pmu.pebs_ept;
-- 
2.50.1.565.gc32cd1483b-goog

