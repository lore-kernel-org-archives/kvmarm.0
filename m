Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5728A21B185
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 00:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980275; cv=none; b=K7zeJbZzFWq+OmHlArmEU2yqJ2NuwAkmrJ7rCwq0mxmwB8WQ4QM572yxLQBnNIVIXTn7Pdiqy2ZxCEE5G0mJoI7R9lNFldGXD6gs1F2IKX/Wxv86gIXcFRAJmlm8Xy/Waud80W2AI3QK/U1ePtVVSpcNY1OLW+3CSuwtEIG4HUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980275; c=relaxed/simple;
	bh=kd7T73ar6I8NiXQe7LuWrPEA21EYkgr8AnFeISoZufY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uicNBlr7bqtVi0ABR/kSXPilF16kIO6xOJDJL25iRzyR6baHyqjnqbSJOmjeI8wV4bz7YY0Z1nMesvGBtfjpsRdBLbQNNgxcUkVyHEEf8TQNA7HIbipnwK7d8HAaFW8r6r1gCMOgAhDfvvzP9fk2QrsTd6cGLptCWM8mthF6HVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v3KH8PJd; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v3KH8PJd"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2955f0b8895so32756625ad.0
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 16:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980273; x=1765585073; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Xvhz9N1L4N+mDurmwM1rhQiV/PP6RHnJJPdqNYMoi5g=;
        b=v3KH8PJd6SYkPLpFo6JX/vNOlV4FX5S9fj8lXHfmAH07WoRa9CFQuG8DuvGWzqugd5
         U5jI1hIgqsIJ55KdXOyWaw6Feqq7dtZqf/rNN56bf59tQOuYWzZl+OBOXBxwYmsIoAeP
         j0KMyMvC3pgc5PAYhyt/yLownkVZXBGYFtUSzkMIbMA5Y+Q8AIgU2mliuOW/z5nSjhj0
         ocgCbYgQVGsVaO5E2m0hO7vpnpPQo0jnZCD91fIM6atlhS/MSfvlOZUc9v1rCdcUZtUG
         FIzDuYmQoysaYXIhC3E1yWOznd9qzjBPHfYEf31mTa9eg2WqfahQ4KmbQx+OwF7kvo9S
         Ei7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980273; x=1765585073;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xvhz9N1L4N+mDurmwM1rhQiV/PP6RHnJJPdqNYMoi5g=;
        b=s5HubJkD8IAPIWc10Kvpqza1ft+ORZeDZAEqg308W+55T8ODmKwxUZbVKGCMmcdvDa
         myeQEoSe88/T+RUtIRtHK1Lx9Vnw5gYFE6lb5rVd1doAHIJRkLs1RwL2jg6837+OZWis
         KfngCsCMBysjilZ0t4Py/cfAzyZ4ZxskLgto0JRqkkM4FRgpNsZ3I6GsyXzQdy5tcN4o
         S9XTHIERE2UelGk4ty3EYzqDCNKO9KLrM7Ycl3rMS43zkwvWyYm9sKJZsQh/k4PmZMo6
         OdAjIROz+V3O/pCEkVa67EoRoDs47j2smQGMp9NcIec8pL2PK2V9rpWkGnxjhOlsC/Tq
         F+8Q==
X-Forwarded-Encrypted: i=1; AJvYcCX2fA1wu5teRpktaYpRqH7ukHhMb3g/uoNz5PwwbU2bwl+xOFnKlS7ZX/nkSooRiMYd3/OZ1PU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwndUrouiCm6+NI9FbH2qyB0jxKvf0EL10ybPMhuZXLKOYIF0+O
	2Y+a1MksW4fiSTM+6FFCTfXzKKJc6B/CNOBTNB0XJOoSp6k+lOQvQBJuZCQbU7blyhLNCrvxRlW
	K46JmHQ==
X-Google-Smtp-Source: AGHT+IFWUJIU/8E8cWwKD1KvVXfXTPgHtbYSY08/FWGA961BLSrK8ZlXaCtvUM6dR/7cetdvhZaXTRiVhyQ=
X-Received: from pfdc17.prod.google.com ([2002:aa7:8c11:0:b0:7dd:1a70:fbc1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:5605:b0:366:14b0:4b19
 with SMTP id adf61e73a8af0-366180292f3mr728551637.36.1764980272562; Fri, 05
 Dec 2025 16:17:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:16:49 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-14-seanjc@google.com>
Subject: [PATCH v6 13/44] perf/x86/amd: Support PERF_PMU_CAP_MEDIATED_VPMU for
 AMD host
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

From: Sandipan Das <sandipan.das@amd.com>

Apply the PERF_PMU_CAP_MEDIATED_VPMU flag for version 2 and later
implementations of the core PMU. Aside from having Global Control and
Status registers, virtualizing the PMU using the mediated model requires
an interface to set or clear the overflow bits in the Global Status MSRs
while restoring or saving the PMU context of a vCPU.

PerfMonV2-capable hardware has additional MSRs for this purpose, namely
PerfCntrGlobalStatusSet and PerfCntrGlobalStatusClr, thereby making it
suitable for use with mediated vPMU.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/events/amd/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index b20661b8621d..8179fb5f1ee3 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -1433,6 +1433,8 @@ static int __init amd_core_pmu_init(void)
 
 		amd_pmu_global_cntr_mask = x86_pmu.cntr_mask64;
 
+		x86_get_pmu(smp_processor_id())->capabilities |= PERF_PMU_CAP_MEDIATED_VPMU;
+
 		/* Update PMC handling functions */
 		x86_pmu.enable_all = amd_pmu_v2_enable_all;
 		x86_pmu.disable_all = amd_pmu_v2_disable_all;
-- 
2.52.0.223.gf5cc29aaa4-goog

