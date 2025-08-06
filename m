Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8005B2BE632
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510312; cv=none; b=R467Jjbnhz6ZtwRO3siNa4izKVC/poRonoyVcWTQa6mXB0L3Pq1jFe0w+B/lOeWRLRfIwAi4P0sYcsZCr/FoEiI3wzh2eNdKt8w7ZgMRAAOVC2vd7v6HRu46TEll3LARlf+qFspODNMgsySOYYYLt/23PPXhFY2F+j+FZIwnnZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510312; c=relaxed/simple;
	bh=bLdrcgmYm6mqxmhXKdA5ykWfWtLQ9xTXCUeboAWobh8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L47k+GZ+AkYtTaL33Dgc1/Zsdc8cZFR00UcLRHUQbJ7bPyh3VQaCm/uMCo2e8MckZ2mjJ+heSMbjK7vH5bTMCpAyMk5j80aTbyldLoaEgsIFZk9SNUDjxC6l6opcyLYySkdd/mv3p5ZwSW/F/tI/BwnGcl/6qDKZUbl8M9y64C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vVUc3j7d; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vVUc3j7d"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2403c86ff97so2463975ad.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510309; x=1755115109; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=h+R0RK6o+FBkoODCsg4/sPruy7k1VkLsFBuytBNeaEE=;
        b=vVUc3j7dddctLZ/SfrtgmgWpLf0lkygDwfJBhg25X+mfBK2+WWjY3I+uF2LLb9Ly2u
         DWJLJbeUAq8EaAtTf67qVwFsRBKtQJ4XrY0ogvrMWpjOcfhD0XTGBhTfqJ7JsXhqmAfl
         dnpBrVD+VixFYcmkk7qyCjBoohAQRHrGxEgluo6YXlWkEPkrgOEQsRPoTr1zjLRycIU6
         ggRRX0ORp5E0hwB1QM/dP7KhglKeGEcKIRtwGoA/UBkkaHrn95UJtjgY3pLYC8RhC/GG
         a5P2zwI9QCdIJVAqTJiv0PD325CsV9fDHcyckfXt86ZCA3Xl5u2Fb820+KUCSJQYWwaZ
         gNyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510309; x=1755115109;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h+R0RK6o+FBkoODCsg4/sPruy7k1VkLsFBuytBNeaEE=;
        b=sFiCrIiGggU7aaz8erROn/DhqujEEbqGRJTUD4Fh8vpwBcwhdZpseMz08FChQxw4X/
         TvqocrKXCFUizw5mG2hRzoavbjvKqFK3VaghtIXLcgpM7TWSyemmZo/YmxrHJzzeDBhO
         94zR8klU7VNlHMzBQTSzuShs0ZggHQv3UDUvYYCNOFekv12A2x7XMYqj0nm5TfEABC0f
         PCJBZO+CEwN1N+ggknJ3XAmfAC+rRZ3Ll++b6tsnrSNt1oaHDUm0cjolarlE31OZXYYA
         G3dpM0ZpkbgPQ8RIegtxMT9tqyUGP34tojGc+XHASsXNm0O3oa+VleML+nFp4YGgfGWM
         geZg==
X-Forwarded-Encrypted: i=1; AJvYcCW0ZAyAZ3u2iEhW6N1Wy9j0/cjorGWKMjV3md1K7V4TheqgkcEYsUMMi1DAmKXeGoRKf2CI3LE=@lists.linux.dev
X-Gm-Message-State: AOJu0YylA+k4ftAAtCKkPpTbveNbpY5VUTNtnGDN2alUz+tRlRi269Oi
	NHS6m3ZHJzOs/SQsbq3/lef9JXjiJ6pm5VshzN4ZP/jlJMvA4pdPd84lt8yL5z00XbrmJK03qtC
	B8laElQ==
X-Google-Smtp-Source: AGHT+IEfUJQHCKm2Ka63Vh1rz9TId3URvafpVHxlHcjND/kCO75vRaPMhhxSn7fVXTy0Nxb/+lRjTxRhOaU=
X-Received: from pgbcz12.prod.google.com ([2002:a05:6a02:230c:b0:b42:1518:df18])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d510:b0:240:763d:e9a6
 with SMTP id d9443c01a7336-242a0ae9d65mr50650645ad.25.1754510308841; Wed, 06
 Aug 2025 12:58:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:55 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-34-seanjc@google.com>
Subject: [PATCH v5 33/44] KVM: x86/pmu: Bypass perf checks when emulating
 mediated PMU counter accesses
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

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

When emulating a PMC counter read or write for a mediated PMU, bypass the
perf checks and emulated_counter logic as the counters aren't proxied
through perf, i.e. pmc->counter always holds the guest's up-to-date value,
and thus there's no need to defer emulated overflow checks.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Co-developed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
[sean: split from event filtering change, write shortlog+changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 5 +++++
 arch/x86/kvm/pmu.h | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 817ef852bdf9..082d2905882b 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -377,6 +377,11 @@ static void pmc_update_sample_period(struct kvm_pmc *pmc)
 
 void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
 {
+	if (kvm_vcpu_has_mediated_pmu(pmc->vcpu)) {
+		pmc->counter = val & pmc_bitmask(pmc);
+		return;
+	}
+
 	/*
 	 * Drop any unconsumed accumulated counts, the WRMSR is a write, not a
 	 * read-modify-write.  Adjust the counter value so that its value is
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 51963a3a167a..1c9d26d60a60 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -111,6 +111,9 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
 {
 	u64 counter, enabled, running;
 
+	if (kvm_vcpu_has_mediated_pmu(pmc->vcpu))
+		return pmc->counter & pmc_bitmask(pmc);
+
 	counter = pmc->counter + pmc->emulated_counter;
 
 	if (pmc->perf_event && !pmc->is_paused)
-- 
2.50.1.565.gc32cd1483b-goog

