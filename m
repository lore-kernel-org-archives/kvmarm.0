Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172132D5C8A
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510289; cv=none; b=BGGsoM8KZmqQGaTL97dDrVZRmjAGdmZOgO1x4oe8KdEpNbj2wEsoUaXg/4WlO9PW9fHbPCpdwQ6zngsWgAk7t3PbRfH/vU7apAEIU/C8u0mXa2bUXVmY2xcsbPjaxSYjBAuNonpvuZksStKsx7Ix2jbUd6TLWUEuhxwu7uDBFm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510289; c=relaxed/simple;
	bh=JJbKDILTxe6TmmJfqZTBwaNtNaEK5gYeJU99RMfSqbk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VHITAwI55voaD6QXbSsd5EigVBkoj8oZ5d7UGLRNKcZVMzexXbgE1vdiN1MWKv7BTlXlQBLDuvXrbbmdV9zr0wSiqXMAd5IMMbmMjj009/HvHzY6Xlz39R4OdGxB36kOhgLGpx+ZR+mRIyljRksgVlsQYOnzOTdeVfyYf+qOFT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fzdxg5Xd; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fzdxg5Xd"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2425e41424cso2205205ad.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510286; x=1755115086; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UYs6XLsbq3wmUfEBezJ9021CIzqcfmK4yWnl0Vk41Lo=;
        b=Fzdxg5Xdu3hXguhcAF5g3bGmudWRr6Zy0mX+vc9kWZ0bkACFaBm6xutsXCWzqlhHnQ
         j5qOO6QY0E37u+PCT3/NILzxQ4KedyMawoBx+V02lSTDOec4zuybYTXXw7Lw9le+vKHL
         L3xjeQ1gbOwtApqjY6pxyHG2ocxNOM7LC5ezAkZefBOl9cHDYQWXCJJW/mazhWc0YxNg
         wcbWLI3Pb2EC6GGVSR3S/XnAtjCotdxfLsZxQW6TKoGW6eWofwb/QgbqOXGnc8G8wRC3
         2Tf3G4xKclUZJcvrf4oau1dMTK75NDuvBXaFkdeTjMeJ8tCK5ghesoeltxd8dMbqj94q
         jeEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510286; x=1755115086;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UYs6XLsbq3wmUfEBezJ9021CIzqcfmK4yWnl0Vk41Lo=;
        b=d+ALwXO5f99fItpiRE6cdvwJk518X0qJzbFAjWYrDXAkSr0e1Y+0hox1uxPnqh22TB
         zB6uDlL/sYdgHfJoaBJFKSEgezv4vU/TgnG7UPP0e1zrMKtNXDN0xkNz2EpHcliWb3bM
         aQC45uGb3ULe4jsHVsCaUuM4FdKdQVCHaXEoSbVlxNUxu0TNeqEwZNNm3Gm/v1lYXfY0
         bno0YCgyqF32NR9wkCpBUA5ZPVGG+XOvO/GPLVxB7RfuHdiZuaqCEPwRmp4vVWgdg2ot
         dD5S8MIiF7/Zb0MtnxYeNoJC3iRHeX+9us64JAzYMqtzPA854/bmJmHgOgrwnHtIcW1U
         qRKg==
X-Forwarded-Encrypted: i=1; AJvYcCVkoVx6cnx2qEIVi0lyHW0m78vBnR8i8/BhlX4dY4OwcvbdACRQKrsfKy0Vk991kdiVWvsLzDM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyhToyBJiqDGac8sdxB+N/y5xqnj5rK4NLW+uXCFwmRCWj3Zw8L
	/xq50DscO8gB2V6AMI1jA5b4vVU+j3HlS/PQSWw8S++3lwYLwiGukQ9JH618SihoAHGLb5/rIiR
	1naBw7A==
X-Google-Smtp-Source: AGHT+IEjtNNsSzvoH0/VB3MvaueTobKjhNGxenKGyVkg+/CWGpyESmYfNsRK9kQsugEnvTMUeRjISaSTO8s=
X-Received: from pjov3.prod.google.com ([2002:a17:90a:9603:b0:31c:2fe4:33b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b44:b0:240:b28:22a3
 with SMTP id d9443c01a7336-242b1a687dfmr5147985ad.29.1754510285965; Wed, 06
 Aug 2025 12:58:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:42 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-21-seanjc@google.com>
Subject: [PATCH v5 20/44] KVM: x86/pmu: Implement AMD mediated PMU requirements
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

Require host PMU version 2+ for AMD mediated PMU support, as
PERF_GLOBAL_CTRL and friends are hard requirements for the mediated PMU.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Co-developed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
[sean: extract to separate patch, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/pmu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 7b8577f3c57a..96be2c3e0d65 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -227,6 +227,11 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
 	}
 }
 
+static bool amd_pmu_is_mediated_pmu_supported(struct x86_pmu_capability *host_pmu)
+{
+	return host_pmu->version >= 2;
+}
+
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
@@ -236,6 +241,9 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.set_msr = amd_pmu_set_msr,
 	.refresh = amd_pmu_refresh,
 	.init = amd_pmu_init,
+
+	.is_mediated_pmu_supported = amd_pmu_is_mediated_pmu_supported,
+
 	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_MAX_NR_AMD_GP_COUNTERS,
 	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
-- 
2.50.1.565.gc32cd1483b-goog

