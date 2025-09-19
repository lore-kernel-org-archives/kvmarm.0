Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EBB42AA9
	for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 00:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758240699; cv=none; b=ugvWCumvt4r52dj68igzSd0UY36b+m82dxk31Qo+lgNyCv2pmWpEfn7D+vyBZd9zcJodLlWxTU0f386Dc9LeYcxIiA9ZiKddjKR7wUKBP27d/XPvbr8ADT3VBjM9WttSHnIC7MXl+lozej3TtyiyJA2A3O4PNjVpFLWDxvS1+S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758240699; c=relaxed/simple;
	bh=9ggq31TuElkvdeTP2ZjS79K/WX3d9QrheK9IIUaFVzY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FxaehBHNPxXAplWnED6Iz3S+mKE5gXC+8tx89UcVksvcK/3Giy//1dDRnmcBQAqHFopigAuS+U+RmO/YcdqeSSxSqpmBSn0YewP7PeeY6uz2XnmWeFeXz5LZg4awOEGWH5mGJWJfUarECN/pIIPBgMeTyL8GVuYOtVAAVIScSaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VHoIuLai; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VHoIuLai"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77283b2b5f7so2271102b3a.0
        for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 17:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758240697; x=1758845497; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5pHZG9bcElhtMtIe02tLqtkF2uGVTgQcC3bk12Urlxs=;
        b=VHoIuLaisdxbEEZKFcCPxYQssVXLupsv64xvWUgdBT45fxeO0oVerHDf7sFmuTI12W
         dcGZ/0osP3AbaNUWpfv0oVtqnF0cii8E6Uop2QFKRFw9KS3J4y/j5cbCY8fc1ejeriAV
         5QTccxvtm9vMiBtGbaaULeuQM5sEm4rspShKGP21TDeUyKAo92zHXNs2aCa61Vw1NxIN
         CPNOCQbS+sve/khsa0I8PDy9uClopS1ejoW9qTBAJxrkZK2ns5c1bT/qbN3oseVvfZwT
         n4Ue1MAAvoAJfgw7nSgyhAKnsrh87x8Rg+DBjXI+mNIpiIeherQUfvmrWav6WjKVkWOx
         0iog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758240697; x=1758845497;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5pHZG9bcElhtMtIe02tLqtkF2uGVTgQcC3bk12Urlxs=;
        b=EBrZ7kQBYgksssAyJ17d+16VjA5NuSthR0B18rCE5GwHWI4pnecG/PTIkMPa64ZmJ8
         Z2YNs32Q/H6eB1y7fS4ds3/8jO/fwbTx8BCRP2QWU+PDNwfVJxe6U66A4O5ezvrWfExy
         d1R2AItm9N13oI4eZgLWWpnRyxaPCkRoYmuh2V46ajqmjG+5ZPhovo/hRVoaaVr26Pw7
         Ur5/lihZwOdbCrZkjZrB8AcwoONqAffsZdpFHOPQIWcgO09cycEq22pVYoD1tXCkt95v
         LYyIgD6d19VnhaNYqBgNKLvZan/0/6oUCWYF4SOAWyEjgeJICNOiKHRwJ3Ax8aju0P93
         8FLA==
X-Forwarded-Encrypted: i=1; AJvYcCVi3VL30URRWvBI1s2fLZjm+H5l/olYQVdzff0+XcsnkD7A2WzPVFYvZNuxlzi0ZPnw4SuqMz0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwzD1gge280f/1PBtGZXhhE+7s0M+himIsMCBh6hD2u4c2dKkCs
	9NOC8gouOULJuwatQxaxJoeIdd1mQYKvENTt75papF5IrxOMceJCD4TDFbalUWA3/uRUp5ACPzn
	XJG9pHw==
X-Google-Smtp-Source: AGHT+IHL6wVIYMVXo/qF+C7m2xAthhi9wrZHJ6iKg3qq/wSUNMfIVTHCzCbvYXSzkHH/AND/3vPqEr/ALak=
X-Received: from pjyf16.prod.google.com ([2002:a17:90a:ec90:b0:330:75c7:341c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:99a8:b0:252:3c5e:45cc
 with SMTP id adf61e73a8af0-2925d5abc4cmr2117916637.19.1758240696687; Thu, 18
 Sep 2025 17:11:36 -0700 (PDT)
Date: Thu, 18 Sep 2025 17:10:50 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <175824021167.1343722.9290387002572827825.b4-ty@google.com>
Subject: Re: [PATCH v5 00/44] KVM: x86: Add support for mediated vPMUs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 06 Aug 2025 12:56:22 -0700, Sean Christopherson wrote:
> This series is based on the fastpath+PMU cleanups series[*] (which is based on
> kvm/queue), but the non-KVM changes apply cleanly on v6.16 or Linus' tree.
> I.e. if you only care about the perf changes, I would just apply on whatever
> branch is convenient and stop when you hit the KVM changes.
> 
> My hope/plan is that the perf changes will go through the tip tree with a
> stable tag/branch, and the KVM changes will go the kvm-x86 tree.
> 
> [...]

Applied a subset (roughtly 1/4) of the KVM patches to kvm-x86 misc, as the full
thing is far too late for 6.18.  In a nutshell, all of the random prep work and
cleanups that aren't directly related to mediated PMU support.

I want to get "setup VMCS prior to kvm_x86_vendor_init()" in particular landed
to establish the order of setup operations.  The in-progress CET series moves
the _nested_ VMCS setup later, and I had a moment of panic that I was creating
incompatible patches.

[14/44] KVM: VMX: Setup canonical VMCS config prior to kvm_x86_vendor_init()
        https://github.com/kvm-x86/linux/commit/4687a2c4e6a6
[15/44] KVM: SVM: Check pmu->version, not enable_pmu, when getting PMC MSRs
        https://github.com/kvm-x86/linux/commit/e3d1f2826da6

[17/44] KVM: x86/pmu: Snapshot host (i.e. perf's) reported PMU capabilities
        https://github.com/kvm-x86/linux/commit/51f34b1e650f

[22/44] KVM: x86: Rename vmx_vmentry/vmexit_ctrl() helpers
        https://github.com/kvm-x86/linux/commit/1e24bece2681
[23/44] KVM: x86/pmu: Move PMU_CAP_{FW_WRITES,LBR_FMT} into msr-index.h header
        https://github.com/kvm-x86/linux/commit/cdfed9370b96
[24/44] KVM: x86: Rework KVM_REQ_MSR_FILTER_CHANGED into a generic RECALC_INTERCEPTS
        https://github.com/kvm-x86/linux/commit/6057497336bb
[25/44] KVM: x86: Use KVM_REQ_RECALC_INTERCEPTS to react to CPUID updates
        https://github.com/kvm-x86/linux/commit/5a1a726e68ff
[26/44] KVM: VMX: Add helpers to toggle/change a bit in VMCS execution controls
        https://github.com/kvm-x86/linux/commit/2bff2edf69ed

[29/44] KVM: x86/pmu: Use BIT_ULL() instead of open coded equivalents
        https://github.com/kvm-x86/linux/commit/30c0267f1581
[30/44] KVM: x86/pmu: Move initialization of valid PMCs bitmask to common x86
        https://github.com/kvm-x86/linux/commit/9bae7a086394
[31/44] KVM: x86/pmu: Restrict GLOBAL_{CTRL,STATUS}, fixed PMCs, and PEBS to PMU v2+
        https://github.com/kvm-x86/linux/commit/c49aa9837686

--
https://github.com/kvm-x86/linux/tree/next
