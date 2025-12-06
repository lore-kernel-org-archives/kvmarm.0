Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A02C2765F5
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 00:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980279; cv=none; b=j8YT/vorPyvSTQBnBW4l2ee6fHDiPx90jodGLAohAEtYybJaYC3U7cq0nxdZZPxg6D6U7WNEoa82i2Pp5LzpkMaq/HIJaf8Y2d9wWjG6P3De1UxC7kytD4hKSEzFbt4Md61FKGxbRQA1kA3qTd9N85lmOMUPSzI+ztif9jAXz0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980279; c=relaxed/simple;
	bh=tj6t2t4Ed4eDjoeIXxejgP4HqHkh0nNCA/O27IqihCM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rQTJg3dB37Inpb+Xyx3+KpunhJcalYzKWAIqaTFEYKfRuhrvbc2Ge/yjIsAoIEsezNML9n0a+txKcd5WefphqpcyXE6ZPf5RtABBLHKHJCtBxCA6RJN26bgAgyn2wryT0DJ3+SSQdphjx5mPBv3qW0QNCL8OHQ4VfWFg/LYlL70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dfF8ZNE9; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dfF8ZNE9"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29da1ea0b97so53766015ad.3
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 16:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980276; x=1765585076; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RvT5QOLTrPlZDM6KRmJviB3G20BHxxiuQcblXVA4XhQ=;
        b=dfF8ZNE9XfEy4ZJ/Fm9oph5O8L0VBifDlWo98n18kZBCLbpUmQPJXn3xxoUbmVop4n
         UVRJCJY8enUhmGQ9YSvwnqIBGo0h5v9iWlC6ggP9gUgGrQhSqRoH1bfSMjBo2M5o0W16
         9XpVRUK1hI7Mbf0rTJ7N7FSqtQLJ6epqW22xA50l3XVtAwOJKTmBnxmv13y9pd4LY/JL
         On/srZjeuzaqJzKkiqCHlUvGJ/5tiVIACJvtpTzuH4PagX9G/5q6Ryk5N/+2qbYGXVQs
         ZTfFSRt4FfED74mwwhTYHS5qeCb3Bx+MUmzUfTZhn3vi02YTP1hVGzDptdrL8Hlqv2KQ
         x2vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980276; x=1765585076;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RvT5QOLTrPlZDM6KRmJviB3G20BHxxiuQcblXVA4XhQ=;
        b=oNYtpkhK1TC7pMpvpEKI17eujMBJo6Rqwy33JVTvrQ56mWkM7vYnCd0iRbOOjnDxQU
         lRTGb1WbEr4zdA3nrQBWlWCgHhNPjQ3uheEGHB7z/zM5+V/fOsjNBr4UYezgqFN8/Hwb
         LFxLfwkPSi/38UKqknQUpatyCDW4CSf5muffqkOcpWN4KUgupa3Azm0XXHtChwLHvIfa
         QdmBmh9ZlMXBpPRkx1SojpvaEZRz0n6/8oAfqTivZ9DOIZv26b5IaC6L7i2YJF+2q0xX
         0eteGM+wiFimuFBHluYa3Iz0hYaVBSnjOXDT2ZuAPnMV53MCxovXeVB4DTU/sNxOG1+/
         ibcw==
X-Forwarded-Encrypted: i=1; AJvYcCUhaDclhT9/RZPxyqnNyXGaXDfz1Nt7GwYvLJqDkqc74U9JyVt5EP91wBDbF14PhQ+LwfDYXt4=@lists.linux.dev
X-Gm-Message-State: AOJu0YypNQfyWYAuLi6o62ApOxqEESNGGJ8lP97c6AfQDw2mQG+PdhSO
	qLsyeXtH6M8e3tXq8GMv7gmkYvcyeJ0MGs84WMKNj+80SQn7Mjn0/VvF0RtqNZih4XHD9C2wtBo
	vByCubw==
X-Google-Smtp-Source: AGHT+IGYBlCmb/gXYXB/w+eLYeN/6lSsoZJHvJE9tm9YKGnjFm45dzt4nCYHuTcqC75ktumYKLC92IIPc9g=
X-Received: from plbko16.prod.google.com ([2002:a17:903:7d0:b0:29d:5afa:2c1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d488:b0:295:5668:2f2e
 with SMTP id d9443c01a7336-29df880d025mr4171385ad.37.1764980276326; Fri, 05
 Dec 2025 16:17:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:16:51 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-16-seanjc@google.com>
Subject: [PATCH v6 15/44] KVM: x86/pmu: Snapshot host (i.e. perf's) reported
 PMU capabilities
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

Take a snapshot of the unadulterated PMU capabilities provided by perf so
that KVM can compare guest vPMU capabilities against hardware capabilities
when determining whether or not to intercept PMU MSRs (and RDPMC).

Reviewed-by: Sandipan Das <sandipan.das@amd.com>
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 487ad19a236e..7c219305b61d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -108,6 +108,8 @@ void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
 	int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;
 
+	perf_get_x86_pmu_capability(&kvm_host_pmu);
+
 	/*
 	 * Hybrid PMUs don't play nice with virtualization without careful
 	 * configuration by userspace, and KVM's APIs for reporting supported
-- 
2.52.0.223.gf5cc29aaa4-goog

