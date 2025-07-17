Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E724503B
	for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 23:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752796076; cv=none; b=jyQLC1fWZz6VjVTPtbwsQ1zUJpt7vjBo+s34vfzoAgivHTQNofCva1Liiyl97ggzuFCstngZdejXG4rir+IARIsUOPElYvagiYhrM5Pmeukm1BDJS2d/5jtvVoASG7OCf21JJ1kO3RoZTSqMCu0rhICbUO0zZgCqbZzp5uaegEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752796076; c=relaxed/simple;
	bh=YfBJwVkYLvQOLueRsR/wcaFjpSy+ELcV2uV+QwS3pJw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=lfHVd2U7nRQCclQOOcMzeV/LFp6Nbazys2YI//Y2Y63cXdBQgHngjY7v5BD8bow6+k150bgsKLxtgIfM28NgjcYne/l5C0XSIA1+jXRel+fnUfk3dig6WhcIQny1Vn2+POZ302M3l3uzw+OqWEX4fomfj4xnzCvU4yxtpYiHKEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RNKBOMAz; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RNKBOMAz"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a5058f9ef4so620521f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 16:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752796073; x=1753400873; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bmzLbnF2j6dVJaKPwtlQ/Mp9hl4jymVmhheF/GFsdMM=;
        b=RNKBOMAzhcDYSG5vlDJUIajwOSr7SPdzikEFK9RWOCKDUAT7vL/KV4IrXiULoN2GMY
         Sva4hym2uhK0evF+ZFWWKO0U0EmaI2+8jY3jUrH70dOwaZriFYG4zyxmuFt+xEKFK18e
         Nbwkb47NvQrh11CzE7FI6IUIxgZt6YqPzDKEsTCjgNJFlT6iVuP5/vFHLvTomwvo2h31
         4BY857Am4D2HTPoo3DLeb1CAyn8/PCyGLY7Lw8UANWAgqEjNU9+0M5vNkSGy18rzpIuT
         qox7BPjD7VXARtWegjfCBrP/tO5aM3xMY/K4jsVk7N4V40N4Z64GH70qvlYXc/QP7lGP
         Zopg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752796073; x=1753400873;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bmzLbnF2j6dVJaKPwtlQ/Mp9hl4jymVmhheF/GFsdMM=;
        b=dTJglSywucjudyucRe7i1lvStXAClAG1pXN7lr36f9gUxXHmM/ZWvVnve1MWhied0z
         Q3DgOP8P7FVaiZnGuEZvSLupbxEazeF8/9BRw8BVgSgPS9+vcHRdh64iQbeON3nAsTwk
         aVldsHcTqExfHl/WJnOknOCVMfEaT10H9UPB50Wa3dygkIxMau1KkmaDZ1y8xwOm5x9A
         uX+AZb2nHSJLGUTxmzE6x5XoEhPV11aMAdWpX14lQLhY3bVeYrmG5LyIT5i1/wqG+Eiq
         YE1Mg8PT9SGeAyzhv85ie0mS3izZpMeoO8Ybum8JnP3XkvzakcnMKK4KuCMAWPSmyV3q
         4B3g==
X-Forwarded-Encrypted: i=1; AJvYcCVXP2413Ofnnwj09F1vk3mH6MOWBCFse95DxZMb8mbpHWwKz82klKgIDomLmYsWdN+7cRbn6us=@lists.linux.dev
X-Gm-Message-State: AOJu0YxOOpJRbCY6oCz0ftGmeJBl88bXIU14ne7qipylqJrF/uEt0AYr
	Lm/3jZULFEiPzI0tvjuPCFA26oKVsitUvmcWA5j0Sbrk5w4gBiAs0xH2XFeVD1q2mNcx/w984I+
	pmA4CZX9luBpfqQ==
X-Google-Smtp-Source: AGHT+IGZHRkGEI95lbs1FRrqgy+02r8k4XIFuVIZqzJTu8682nwwu/iFMxnvp6lbNsckQkII7hCCWDNCPJ+Z8w==
X-Received: from wmbhc26.prod.google.com ([2002:a05:600c:871a:b0:456:245b:44bf])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:64e8:0:b0:3a0:7d27:f076 with SMTP id ffacd0b85a97d-3b60dd651d2mr6895573f8f.2.1752796072756;
 Thu, 17 Jul 2025 16:47:52 -0700 (PDT)
Date: Thu, 17 Jul 2025 23:47:42 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717234744.2254371-1-smostafa@google.com>
Subject: [PATCH 0/2] Dump instructions on panic for pKVM/nvhe
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, qperret@google.com, keirf@google.com, 
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


Mostafa Saleh (2):
  KVM: arm64: Dump instruction on hyp panic
  KVM: arm64: Map hyp text as RO and dump instr on panic

 arch/arm64/include/asm/traps.h  |  1 +
 arch/arm64/kernel/traps.c       | 20 +++++++++++++-------
 arch/arm64/kvm/handle_exit.c    |  3 +++
 arch/arm64/kvm/hyp/nvhe/setup.c | 12 ++++++++++--
 4 files changed, 27 insertions(+), 9 deletions(-)

-- 
2.50.0.727.gbf7dc18ff4-goog

