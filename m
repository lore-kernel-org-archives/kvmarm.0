Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436DF2D29A9
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510281; cv=none; b=Y2IBdla6WWCOzgmNfLjkZThcHn6qlDiG4z01ONFX9kBde6wlO2O4/lN+rbVG2mtYbN2z6iQm4Olhkw3Gobn+IWsehA7I5v4D3OmeDZvOFtGmMrJLKm3MKWR1yNHAgJCfZ8PY1rrC1NtMvwvj5Eo45BSJjNkNz3WBqrbytgdfiv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510281; c=relaxed/simple;
	bh=Wn/70g/zhO0dUDFH5wZEa7RcDliEFiv6OnJtKAjielc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GiIrT8es0EUPoIJSsEFUsnxupghVFgw8nw5NPwKBw2J8eF855WMaFT1ju8wAgBekd+YqHCYQ72Q0ImDjJZanhxPBZB6qVZBTpaeUPQcUsxSLdMxm1lO3xhjvBwv1SS/2VoF1VLcIrStosobtHeIR6JG6QTDLuJWoVpF2LYAZHOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=35rxhghr; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="35rxhghr"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-240b9c0bddcso1712265ad.2
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510276; x=1755115076; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kcswufqwZeiVbOah5oR7VRWteUmksZlp7f05xG34s+k=;
        b=35rxhghrLqkafPNX5TVnpKo+37Zsd4sHTNvCOB0Pndu2e+d+BzdTnMUjRe/wALTk3w
         qZnkw9Jl7msP7Yw3L8YnuAleOwOaKaRjVwMKkDUFlZrh21kk80fP3jtRfNYIDcZhASQQ
         NAzZBOemgUO9lAI0p1Y6msRGzDLXr0pPEGrtzm/HfrZFrdG1KQoZWCaOBL2o7MzbM+PT
         6rgv1FwQXFYMTROeu1kF85/KG6DkR+CnIIE9jrJZwtftwDA8PTvF3VXBAmqo7dhQe3Z2
         L2bSfaRs1HGHIYHQmrDRdAOemoIVsRum5qHAJsAKzc7xB6xVSX0SCVZZqNiFjlxl4owM
         0v3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510276; x=1755115076;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kcswufqwZeiVbOah5oR7VRWteUmksZlp7f05xG34s+k=;
        b=SeSa0/1vrv27FbPSzUX+f+KuQCRgdH13gYoaybfxeGeSZpqUYRuzOKj4ogFOsrUOVj
         C2WPZIF48gNmrOqP1qCcAvAdT//cSGpdTriijCje6ePmvi91OBLG89SfuxSMI1Qqpub7
         KNEf6haoZwDtpgx/sF6a2rbHDq/OzD8iZpntFwTsTiDVAHIA5L2gU43qTZ3OLqHUr4Ir
         cC//lAmh1UJpRnjG/DQjKBMmcpfUwvIXrgEyenZXc1YyYE24/llG7NGFySSngYywe251
         NZMQhnh/OUqXvIuBiKtrcU49vDq+3hg/NUhnoVvqI35nshcn76aQkLXgp9B3FH1yDQgS
         /4Ww==
X-Forwarded-Encrypted: i=1; AJvYcCUkJ8ZOCliPZgMdDwKQzDerk9cbhvuv2XLUB26W7+cBgvU4QAU5xMO3LT7d4xFex1kInHekTC0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbGqciqq6hkEL1Sk9OyqKDI/Jr5IgMyeA8KOADil1mN/bLGI2X
	fgNunTAk5qDwCnKtHPQjbB055td6JgK/KREKRZ1ZYmVcSPt29jizm6t63CRINO7snT9Z/oswi+h
	hltzGhg==
X-Google-Smtp-Source: AGHT+IE/UqkBVmIsYHo+3//+Db76eNFThoPapPb1lJatPNoq0GTt8I/qj7Zd+31YDzfBkj++w1pCOc8gls4=
X-Received: from pjbnd14.prod.google.com ([2002:a17:90b:4cce:b0:31f:2a78:943])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec8e:b0:235:ef67:b5a0
 with SMTP id d9443c01a7336-242a0b3e6f7mr55163055ad.36.1754510276193; Wed, 06
 Aug 2025 12:57:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:37 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-16-seanjc@google.com>
Subject: [PATCH v5 15/44] KVM: SVM: Check pmu->version, not enable_pmu, when
 getting PMC MSRs
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

Gate access to PMC MSRs based on pmu->version, not on kvm->arch.enable_pmu,
to more accurately reflect KVM's behavior.  This is a glorified nop, as
pmu->version and pmu->nr_arch_gp_counters can only be non-zero if
amd_pmu_refresh() is reached, kvm_pmu_refresh() invokes amd_pmu_refresh()
if and only if kvm->arch.enable_pmu is true, and amd_pmu_refresh() forces
pmu->version to be 1 or 2.

I.e. the following holds true:

  !pmu->nr_arch_gp_counters || kvm->arch.enable_pmu == (pmu->version > 0)

and so the only way for amd_pmu_get_pmc() to return a non-NULL value is if
both kvm->arch.enable_pmu and pmu->version evaluate to true.

No real functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 288f7f2a46f2..7b8577f3c57a 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -41,7 +41,7 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
 	unsigned int idx;
 
-	if (!vcpu->kvm->arch.enable_pmu)
+	if (!pmu->version)
 		return NULL;
 
 	switch (msr) {
-- 
2.50.1.565.gc32cd1483b-goog

