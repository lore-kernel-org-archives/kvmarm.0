Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F0D30CD80
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 00:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980335; cv=none; b=Aoy5rXUIx9OW3yvcxZ2i56Z+1JOA9nR9rUdHyu84mzOPXS0vPfq15WPRJH1RDKKy+y7UGKN2mxziBvjqHcIrNDPcsdPLpYrTfX4IMrkBNd1gkkqiwf/Rof4XEaKL6Z1g8H8S5rHQ8IH2lNXkCaGmhlBji0SVbuVGXKN/0Ex/isY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980335; c=relaxed/simple;
	bh=EbuHjkM11wJSgkGWY2aSFlMpNr7gwy2PyHzdmFLt294=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VnwAatQuyQeVQmweDllR/sUoxVYY0rP1xt183kmOdY+hn4gOCbXbK2vQAx4O0DGIsvILseRctO7SlvZdeMLQE7T1zDGw/363ByyHyQsqCZGo4zNmiCCsTV73TlMSO2MjvZIGU0tXAXjwUwRIgTOPPj+/xCU+TpyM8hAtW7IEHto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s1/ntO2o; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s1/ntO2o"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7bb2303fe94so2996952b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 16:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980333; x=1765585133; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=n8V9DDSigR69uE32CWTID9idTpYitJ2rw2w6q4YtJdw=;
        b=s1/ntO2oqKSUVbGBkY8iosgJjQYP8tydlgm1scI8xq8UP9LEKBsuOuPBrYSkjwLZSN
         s9/4iMyHcEd4zLU3E3saYQatFal6730gqqO/g4rKOkX7ETDtBWBWDfArEnGePbx1yWk4
         WuL+D4J1E3idg/5EW0nF4MYNIuQOdGxBOTePRHFcBJPw7Wcq2fgxOnDOwTr2XHv7Kxg3
         BaV2+AOw3PgJaBah/+MVxyT0u2syYGVaVCrJ5XuqnPhKqjlTp0CO2xTKZgMPd/M06xFI
         kbAJx9pyg40Gu0WEB6OfH+ajT9Q/F3frLPka25P49/cj/lxUrNBR90n6d/jIyzdxKP3B
         zgHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980333; x=1765585133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n8V9DDSigR69uE32CWTID9idTpYitJ2rw2w6q4YtJdw=;
        b=CpZWmSt2OkTCK6BZHREyGV2kK/+uxLeJ4HSVFAXVposTfZMYwfrmrrcuooxxxj07Oe
         cbj0tXKexp2itwI7tTyiBGSuvBhlAjg+d5xv+eUBhhrWzl+FltILTjG+e2E7h2S8UjVS
         ZChGyCfIU1QxCUMc/CxCGoK9koOsxfAGTsliR1AIQYuNaFcdIKJsRqcmE7IS6iU1v5PM
         NSoMX1nsi0Ws/iUJawJ9p1KnkaBCVguJ9EUsbeDKNOxuis+m25KKspSwJzuWWEYQIOuC
         hqK8g8AJu4W9sb2WfeIJ4sBGAKdzLMysAB2/Gk1r4szrQN87t+7hrf/I77Gc1KEFMFpk
         rncQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPe7DFWfuuxdaydrPE1HzLet1Rn0yNOquQlFq9HFc8pxouFxCj02EIFUoYS5k2NFdRPMivvXY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwTPjH5iQXZWYbK5HNqP9juLTjOQTH/+uMZzAEAapZQGPN5jNQo
	wnTrM9GAUv8NuDuUfbfcUqfy8qNF7s2hRn2daI7/wS/jpcsfq9wtJCTC7bkLT0JeyOIAP4rXxjf
	+gd+ixw==
X-Google-Smtp-Source: AGHT+IFvgfK2a2snqIy1Rm8aE6qptyZkQEpan42/+C7VOcIZpnFc5T7dKOJ6QhHIoZwkwV6ZMBDtCsCouY0=
X-Received: from pfbim5.prod.google.com ([2002:a05:6a00:8d85:b0:7b0:e3d3:f042])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:888d:0:b0:7e1:89ad:991
 with SMTP id d2e1a72fcca58-7e8c6da8d28mr855283b3a.32.1764980332931; Fri, 05
 Dec 2025 16:18:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:19 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-44-seanjc@google.com>
Subject: [PATCH v6 43/44] KVM: VMX: Initialize vmcs01.VM_EXIT_MSR_STORE_ADDR
 with list address
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

Initialize vmcs01.VM_EXIT_MSR_STORE_ADDR to point at the vCPU's
msr_autostore list in anticipation of utilizing the auto-store
functionality, and to harden KVM against stray reads to pfn 0 (or, in
theory, a random pfn if the underlying CPU uses a complex scheme for
encoding VMCS data).  The MSR auto lists are supposed to be ignored if the
associated COUNT VMCS field is '0', but leaving the ADDR field
zero-initialized in memory is an unnecessary risk (albeit a minuscule risk)
given that the cost is a single VMWRITE during vCPU creation.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3f64d4b1b19c..6a17cb90eaf4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4933,6 +4933,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write64(VM_FUNCTION_CONTROL, 0);
 
 	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
+	vmcs_write64(VM_EXIT_MSR_STORE_ADDR, __pa(vmx->msr_autostore.val));
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, 0);
 	vmcs_write64(VM_EXIT_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.host.val));
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, 0);
-- 
2.52.0.223.gf5cc29aaa4-goog

