Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B34E2C1583
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510284; cv=none; b=jAMJkHn56bY4OChDAK0WAkMEIAUCSMbSTi5onvJz7XBr3B9B+VPR9Rs8ZL0RrycIpbiJ5tPlls/PVQ4xGU9hKumkxx7S6wTXwBKVSK9itAJw+9y48yCRwidR9HURXacqPYQea1ItrhMboD4C1AWgGA7skfcxqkr1W1DkudReKNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510284; c=relaxed/simple;
	bh=9XrrLDv04mrzfeSThdad7tM9DkVcx6lRnARpaMqcOYI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sCNW6xhywMVEmeEUsJy09cVEoZGoQPURwKiaSbxKrgfgAZIb3dVE09RpAG+JMaCxgC3XIY1Ie6g+htaj+MTPNWW8bYC8stKvvlyWfY5JnPJCgBHWNO2FWpQ/lXnb47fu10JxGtVXdf1kl+36GPyDCgJHerynjoMS1f3QMfe58G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=olCFDjqk; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="olCFDjqk"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76bef13c254so291143b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510280; x=1755115080; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1JVfLN/93q2WYEPFa3NA5hoBJW9RWjYsNWhQaVXoFO0=;
        b=olCFDjqkDt9ERW9WfBlFNRpYdc9oxwpoDNjnnQc29lDDMUo2wxpIzlWaIE3M08wpmw
         lpK2IDVWJb7nMSf39KMVFqeXOGDa3EmRB5TnluiuI/7iBGDw90qSn56LUlWd2/Bal9Ox
         /LaKBSvC9t7BuZh/LAyvb9eBlMHF+4qOJIrgXnqyM5wfJYnLKapMdjvNa9DN0dRFdeFp
         FtkZGTBNTw0MlchQz9rVwdqUnYlPaDplc7aeDhDv9OY/a7Y2wLGJIkFUk0L/QogVnaL3
         NhU2R6nhQ0AXtPTiGkI4E0su2y12NKVdZ4huI1Sss9F3PiBTIixIkQ5AZi9O6rrhsuIC
         idcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510280; x=1755115080;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1JVfLN/93q2WYEPFa3NA5hoBJW9RWjYsNWhQaVXoFO0=;
        b=joDA++sj5dzG2K4wTR/I/KnitIoPR3edDZhoUucQPVe15S4Sk1Xkakp3dTh22rJpVI
         XDJvInhaz0hJu4L98Y+OmvSBQzDFsJ1tnJi2AwYlo6w9vnRcfnpA5ASsUo0Sjkng+xED
         xD6eohFWrv2XKIV+W1Xx6y5sAP8F7nz/K7OcKKXvwgOiPtJcz6fdEI60csrMM4tszV7w
         WMeIIWrx1qRPOe3G+edtTcwzHLh6YQGoekewyOLwt0svzSrRfzc7Z3NwE9cgpvdax/uG
         XFyu43qgqvoqjb0tLwjLgaPEt7uUt+8/yH5hFV7m3qVvwyWFrjKOPMJYxJ9U0Z6L4Q4r
         GrdA==
X-Forwarded-Encrypted: i=1; AJvYcCVkbgrzOYdzFusk4nlHsMm//ALoFpozhJweLjyT+x1DlmwBeid3uCWU3sBI6F/i69t/Dy8IZlU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwjbvvSrrUcR8l8DYTpuHPMAPnoiYmmCX9TrukLeUHDpgHYakTC
	RK6aZe2wwWC3lB/x8g7X24VPvMHLcIAr8noTtvIE8YL0NxdS3FkcSPAV/KjMuL3/h41BMIqTgfx
	XYRpAfQ==
X-Google-Smtp-Source: AGHT+IGEqoS6XNELOGxlbJeBvkZJOh3lrJxf4kRuSXEbOp8u6GEP+lPQ4e26oXCRK4Rwc//kWZSE9nj7nV8=
X-Received: from pgbcr1.prod.google.com ([2002:a05:6a02:4101:b0:b42:25bb:216b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7d9d:b0:240:1d69:9cc9
 with SMTP id adf61e73a8af0-24041326731mr1241511637.16.1754510279868; Wed, 06
 Aug 2025 12:57:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:39 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-18-seanjc@google.com>
Subject: [PATCH v5 17/44] KVM: x86/pmu: Snapshot host (i.e. perf's) reported
 PMU capabilities
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

Take a snapshot of the unadulterated PMU capabilities provided by perf so
that KVM can compare guest vPMU capabilities against hardware capabilities
when determining whether or not to intercept PMU MSRs (and RDPMC).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 3206412a35a1..0f3e011824ed 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -26,6 +26,10 @@
 /* This is enough to filter the vast majority of currently defined events. */
 #define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300
 
+/* Unadultered PMU capabilities of the host, i.e. of hardware. */
+static struct x86_pmu_capability __read_mostly kvm_host_pmu;
+
+/* KVM's PMU capabilities, i.e. the intersection of KVM and hardware support. */
 struct x86_pmu_capability __read_mostly kvm_pmu_cap;
 EXPORT_SYMBOL_GPL(kvm_pmu_cap);
 
@@ -104,6 +108,8 @@ void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
 	int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;
 
+	perf_get_x86_pmu_capability(&kvm_host_pmu);
+
 	/*
 	 * Hybrid PMUs don't play nice with virtualization without careful
 	 * configuration by userspace, and KVM's APIs for reporting supported
@@ -114,18 +120,16 @@ void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 		enable_pmu = false;
 
 	if (enable_pmu) {
-		perf_get_x86_pmu_capability(&kvm_pmu_cap);
-
 		/*
 		 * WARN if perf did NOT disable hardware PMU if the number of
 		 * architecturally required GP counters aren't present, i.e. if
 		 * there are a non-zero number of counters, but fewer than what
 		 * is architecturally required.
 		 */
-		if (!kvm_pmu_cap.num_counters_gp ||
-		    WARN_ON_ONCE(kvm_pmu_cap.num_counters_gp < min_nr_gp_ctrs))
+		if (!kvm_host_pmu.num_counters_gp ||
+		    WARN_ON_ONCE(kvm_host_pmu.num_counters_gp < min_nr_gp_ctrs))
 			enable_pmu = false;
-		else if (is_intel && !kvm_pmu_cap.version)
+		else if (is_intel && !kvm_host_pmu.version)
 			enable_pmu = false;
 	}
 
@@ -134,6 +138,7 @@ void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 		return;
 	}
 
+	memcpy(&kvm_pmu_cap, &kvm_host_pmu, sizeof(kvm_host_pmu));
 	kvm_pmu_cap.version = min(kvm_pmu_cap.version, 2);
 	kvm_pmu_cap.num_counters_gp = min(kvm_pmu_cap.num_counters_gp,
 					  pmu_ops->MAX_NR_GP_COUNTERS);
-- 
2.50.1.565.gc32cd1483b-goog

