Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AB728D830
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 00:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980283; cv=none; b=X70mveYYXpPoiWznjKKjgk1/vurmYKAUAayP/GtkKUhJ4lI2lDPRDyBN56n4H9k4SeCu7e9vUxWTIcWkoLyDio0ghAW7BpiVfYkbmxy5DOTRmRKMyBLsjbYtax6GIuKZywKgn9OQXyybsFSgxYCc/Ju17QzWPplg0uLYfQeG1uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980283; c=relaxed/simple;
	bh=nvjn8cBbINNrlqqH1bX/64Jkc6rJ3drKKXADKrppk08=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MRt2LJzSfHC6sYNqpOwAX/IXOxGO0XB7a7+mxS3wNAaGnEhu76HSy4GpflqjnEz3ijPCfWxJwGGxTND6a5UEXiEWH6y2iYjyTcDy27vEUUMV+flMmCHazT4HF2YZdJy/FUmB8YZvzwdiWOCbPYIX3Wbf6IO0YIoMeYws9+LpmYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r8b9rCYb; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r8b9rCYb"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-341aec498fdso3397568a91.2
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 16:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980280; x=1765585080; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hhYBOxKMeDA97YbyTKBhQywJKJiMZ56sAPho58tY+oI=;
        b=r8b9rCYbupNDy44gO3WHBjw9OHFcDsarPuT/QOBnpVh27oxt8JbFoXJk6hePL5bmhb
         hk5xFPbQrfQjAY9FnxnofqAT7HH+wSRXpFNEGZpzvzN+feUVHJyWZc7S5wrbnqWHutSC
         tyL8ZtqHuh5wA/OjBMCMQ6IZcBaxj9hZFtLNwuSGqGhSBGrANnhcUpRn7sPtmGdl3FGI
         a9ym/CqYXXNVQMeutci30xCFfSfqY9l2y7pTSchN5gh4oWvnt10wRtm0tADXKCm1Qdmv
         mTm6vG/Hh3zGRli0ZzKsPOHtLcKJRrajabLuELpmBMmYhFYzxTucnVNL1pyi2LSkyhrm
         hQnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980280; x=1765585080;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hhYBOxKMeDA97YbyTKBhQywJKJiMZ56sAPho58tY+oI=;
        b=gDMUQGMs3NZAZjK9Tw7Bxm+qRztvTmjKLPRl9vZm1mhoaZ6TpZRbQFPDyfQjGM8yYj
         nh2FmIMmLuSbwwP6g6V1R6DqTJQ8lFRplL126UoZvbdszQWtU3Y2KtMm0zxayaCuB/og
         KAcEpH2x2VbBednSeUxgyD0kJ6iEk9Hny3s4eLtKErAI5+lbNkneNYPyTGO5ePU+5A2M
         dF7iODg23xgvGQO+PJg8vxlOUOFQ0ZtD1gHdacAupIVaARUSzZzK7dvbSgIO1B1l8vph
         ticjaTgjyXAzb+j4FiQQlwEw9Q+T/as8XHj9gYjrqxivyO5dkB7SyDp5U49OBL3j34qp
         pP5w==
X-Forwarded-Encrypted: i=1; AJvYcCVueGL2gb8lvTn4LWhALhv9T9MonKSDv5NU1/RzyW7Etswccc25AID3pO1RLvdtYAvXw3a2wZM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwUfGZ+UTK6p/NrhozZxJ9iSNNnEzj8zMCE5ja3STpVUUX9f969
	1HvRicQWyNgfDfoUVRlSj8ZXdTHkZE8V3YLEvschp+3fl8jsrqhI7Uz8VQI0J73++XxX/eXJRcl
	QVXSnsQ==
X-Google-Smtp-Source: AGHT+IFFMAhL4pZP/9HCypRtffNLi9XXG9wzK7MTQvl2xq8p68VDBLvLazIKhLosMJgd33GPPNkDHe8jMow=
X-Received: from pjbbo18.prod.google.com ([2002:a17:90b:912:b0:33b:c211:1fa9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ce07:b0:32d:d5f1:fe7f
 with SMTP id 98e67ed59e1d1-349a24f3283mr493681a91.15.1764980280055; Fri, 05
 Dec 2025 16:18:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:16:53 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-18-seanjc@google.com>
Subject: [PATCH v6 17/44] KVM: x86/pmu: Implement Intel mediated PMU
 requirements and constraints
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

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Implement Intel PMU requirements and constraints for mediated PMU support.
Require host PMU version 4+ so that PERF_GLOBAL_STATUS_SET can be used to
precisely load the guest's status value into hardware, and require full-
width writes so that KVM can precisely load guest counter values.

Disable PEBS and LBRs if mediated PMU support is enabled, as they won't be
supported in the initial implementation.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Co-developed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
[sean: split to separate patch, add full-width writes dependency]
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/capabilities.h |  3 ++-
 arch/x86/kvm/vmx/pmu_intel.c    | 17 +++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  3 ++-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 02aadb9d730e..26302fd6dd9c 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -395,7 +395,8 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 
 static inline bool vmx_pebs_supported(void)
 {
-	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
+	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept &&
+	       !enable_mediated_pmu;
 }
 
 static inline bool cpu_has_notify_vmexit(void)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index de1d9785c01f..050c21298213 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -767,6 +767,20 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 	}
 }
 
+static bool intel_pmu_is_mediated_pmu_supported(struct x86_pmu_capability *host_pmu)
+{
+	u64 host_perf_cap = 0;
+
+	if (boot_cpu_has(X86_FEATURE_PDCM))
+		rdmsrq(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
+
+	/*
+	 * Require v4+ for MSR_CORE_PERF_GLOBAL_STATUS_SET, and full-width
+	 * writes so that KVM can precisely load guest counter values.
+	 */
+	return host_pmu->version >= 4 && host_perf_cap & PERF_CAP_FW_WRITES;
+}
+
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
@@ -778,6 +792,9 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.reset = intel_pmu_reset,
 	.deliver_pmi = intel_pmu_deliver_pmi,
 	.cleanup = intel_pmu_cleanup,
+
+	.is_mediated_pmu_supported = intel_pmu_is_mediated_pmu_supported,
+
 	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_MAX_NR_INTEL_GP_COUNTERS,
 	.MIN_NR_GP_COUNTERS = 1,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4cbe8c84b636..fdd18ad1ede3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7958,7 +7958,8 @@ static __init u64 vmx_get_perf_capabilities(void)
 	if (boot_cpu_has(X86_FEATURE_PDCM))
 		rdmsrq(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
 
-	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR)) {
+	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR) &&
+	    !enable_mediated_pmu) {
 		x86_perf_get_lbr(&vmx_lbr_caps);
 
 		/*
-- 
2.52.0.223.gf5cc29aaa4-goog

