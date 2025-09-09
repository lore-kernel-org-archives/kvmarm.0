Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB9F345731
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 13:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757425004; cv=none; b=N+uSCsK1hodok+pd0O+aLNZHBsvcQtGJQrNWCqRUc1L8EufONtydbCtSKnymVL/9ZUnl8+9/nWeuzOJd++qPhPsnWhan7wN6J1I/2wA92zoBAUVeSICGydzBRpQvb+BqnAO5ITY8v3h1aWqBSQCexk7TdIytXH0pL/oDwy7B1/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757425004; c=relaxed/simple;
	bh=Sd1/eFtlqfVnGDzrsFftGX6iSgfIswDupnKqB8D3kFE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=VhQ+WQrBWvhDem3zw+R0LED5hIR8uS4/6s/ZSCEKg55JTjv1VdakyvVb/8GuXMXuNjzhXTp6BhCkkwQ0wMe1Ioj+I9jPfQFeg+xoUuE6lSCflFcvk+l1wMlQfMaYWwuBG+qgV+1GA1nbbKFRO23nwh+ex+V9V7WkQvZJ8rwBSAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ibOCoNPE; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ibOCoNPE"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-afe81959e5cso515498666b.1
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 06:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757425001; x=1758029801; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KajtByV00Jiv7Lq5klOsW6LBWHVxcYTPd9aKtLeCCjQ=;
        b=ibOCoNPEl7f6C1V5X6VRuWUETA4p8NWc3KaPtW+cmz1UdVh2XlWBLf4PU2zYCDrOlk
         dweJ0a/Rs2e6OuKbY6/eAwBQCkzPHW9pwRwEedPze+Xzk2KtF35VaDDhiEWBpFnEwlYw
         JmTlH/oWY5muuxmIuCQGyHlQRFR/ug/ydVya9GlA3onoG4iDpinLfA5wx2ftC4O7UaVf
         vtCC9d3fNRJvbmNA7mDwYO4sUAFpIqgTA1KA5a2yURTAnZCTx3voMUiHY2o6Agkimgfd
         tm+XzxhjyJP27kgeBBOuwqE74YVXK2rY8SoEP7Gss2avadlbLvL9NjgKaCpoh3yQnLYD
         3o0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757425001; x=1758029801;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KajtByV00Jiv7Lq5klOsW6LBWHVxcYTPd9aKtLeCCjQ=;
        b=svvV8p1WNi3ylbRE1JBtaF/i5dMzS/nsqQ46x0H9nfJb4HO+B13s2CG47l4YaIxFum
         tHD0bHN8UDfsdfCYEj453V79UEzJKX7QTAL4I70/U0TCKW14QhdaBcTYbkcqyut4Kfnc
         yQdcOEqC10xIsRfp3titRodTGCd1KvrBSUoPLwA2n16z2mM/0sGgzMb+Xi9EN5qhg7N1
         Ohfj8fVBnUmxIMykyojAHIfAS2zhDUWceck283dSdxePsOHadpVFLnINaGXYyw4uzUTV
         /QsEtTSfV+0HCd07mBSMbvWa6+O2PUENrvUCoMUZ7Y8N6tfonqMNf+QnAcCU69ZB7eBC
         shpg==
X-Forwarded-Encrypted: i=1; AJvYcCW46brn3JxDtP/I545p7A86tozFVKCFPrionn35QjxqqsKKUVb+R9yXzhAkGPVBni30MXO0G0s=@lists.linux.dev
X-Gm-Message-State: AOJu0Yymn9i1AK4UybCcSknrPno2KSPKPpIRJfHHoKcCtchQrOTVTjv5
	YXFaFXd+f/Qkr6HGDGhnSUUJrRtBNLU9IIJWOMWAaPXZmm7cmjg3spTwgACw+ylYNqUJYBVqja5
	gRFHSW1N2Fw73+g==
X-Google-Smtp-Source: AGHT+IFqVLQR77jh2DKFIMEQIj5PFCy5tufvnMQYcv7fwo55KdSMKKQJ2x/wsNJRgC3/doxiiHv5VPKIl04qJA==
X-Received: from ejctk11.prod.google.com ([2002:a17:907:c28b:b0:b04:770f:8673])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:fd17:b0:af9:414d:9c2 with SMTP id a640c23a62f3a-b04b1403616mr1087102366b.3.1757425001267;
 Tue, 09 Sep 2025 06:36:41 -0700 (PDT)
Date: Tue,  9 Sep 2025 13:36:29 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909133631.3844423-1-smostafa@google.com>
Subject: [PATCH v2 0/2] Dump instructions on panic for pKVM/nvhe
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, perret@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

This small series, adds support for dumping the faulting instructions on
panic in pKVM and nvhe, similarly to what the kernel does as follow:
[   12.012126] kvm [190]: nVHE hyp BUG at: [<ffff8000811c5f64>] __kvm_nvhe_handle___kvm_vcpu_run+0x4/0x8!
[   12.015747] kvm [190]: Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTECTED_NVHE_STACKTRACE
[   12.016044] Code: a8c17bfd d50323bf d65f03c0 d503245f (d4210000)
[   12.016082] kvm [190]: Hyp Offset: 0xffeff6887fe00000
[   12.016325] Kernel panic - not syncing: HYP panic:
[   12.016325] PS:204023c9 PC:000f8978013c5f64 ESR:00000000f2000800
[   12.016325] FAR:fff00000c016e01c HPFAR:00000000010016e0 PAR:0000000000000000

This can be useful in debugging cases of memory corruption.

The first patch adds this for nvhe and CONFIG_NVHE_EL2_DEBUG which is
straightforward as at the point of panic there is no stage-2 for the
host CPU, so it can re-use the kernel code to read and dump the faulting
instructions.

The second patch adds this support for pKVM, I splitted that into patches
as the pKVM changes are more fundamental, as now the hypervisor text would
be mapped in the host stage-2 as RO all the time.
An alternative is to make the hypervisor read its instructions on panic and
passes it to the kernel panic handler, but as we are out of registers
(X0-X7 used) for the arguments we would have to move that code to assembly.

Changes in v2:
- Harden instr dumping based on Will's feedback.
- Collected tags

Mostafa Saleh (2):
  KVM: arm64: Dump instruction on hyp panic
  KVM: arm64: Map hyp text as RO and dump instr on panic

 arch/arm64/include/asm/traps.h  |  1 +
 arch/arm64/kernel/traps.c       | 15 +++++++++------
 arch/arm64/kvm/handle_exit.c    |  3 +++
 arch/arm64/kvm/hyp/nvhe/setup.c | 12 ++++++++++--
 4 files changed, 23 insertions(+), 8 deletions(-)

-- 
2.51.0.384.g4c02a37b29-goog

