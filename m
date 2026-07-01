Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92E0395ADB
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 20:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782938625; cv=none; b=F43kjsQe/BcOHOlItEEUlSwtzddMqSaDdxDijR2fACGEB2gsrh8yASrzaV1lBAJGs/pMwgp8hzNN5Gflxp+/OszNgDg/b2+SZMp/QXHWuGxqRAb2apYUOwJHDIeQddoRFue+l81PIdCZLwBwRdQSMj4HESPEcz7cViTSoLj7gBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782938625; c=relaxed/simple;
	bh=60S4kFwxnDVBWFD5Z3yw/BFmHxkCUVWvN3+3KkqvXoY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=a5smNILBG5NPTx2wkkSlkWWnUVfuTn1MQuRtnOMjA7XrxR1RpPQaS1/mhPFl8iH56T4Yg2Dx4oC6m4L+bF790UONKJFwTi3AzUV0m0yDB7PhVwuCH6B+j1ie3JCyEAuJfWL1MG7UBsde+d8/OzCt19S+ZLtDU9WwoEsQ20tu2os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UyE7SpzP; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UyE7SpzP"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-48e5de5a23cso1202820b6e.0
        for <kvmarm@lists.linux.dev>; Wed, 01 Jul 2026 13:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782938624; x=1783543424; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LgbAV7Db884sdO2wBFSay1l144nmKC6A4dcsE5Jnxg8=;
        b=UyE7SpzPrF6zD6qhG4CDjPnguaNw4YBLvVS3Z98d4zvhvoSqaoxLM3+ZkoxS2NPKpL
         nO4hRz5AL07W3LHEedgg8OMDptPV0yjtjC+zAzy4qm5N7HbP5Joj+fb237F6QUwcckWW
         YT2R6nAT9lQ1ncXb0nN+NIPP6w/Ofvd+zOT0ddR+87AnkTrKcjFgpWoh7FQ5txt5tMzA
         GXsuAdIGDLOOM7dSEPgAhhkahQhPq49fhNYiGQrQYv7ihw+TgZBIMkbF5ZQTVTXRNT7G
         gy/bk1TZINAZJGnPtO5bEHB5giwmKFZCnP9cE68+jyruFuUXcVE+rh6DN7SYtAp4d1LY
         OXFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782938624; x=1783543424;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LgbAV7Db884sdO2wBFSay1l144nmKC6A4dcsE5Jnxg8=;
        b=hHnG/sOpHjwvrxBVHTJ2fioqh6KRPK5c+gC/mvRaGEWmaewWmKB7LPIhGjlFCYRjBj
         Y/gNDvf/UexfHJLKuu/hylhEs83sXMd5q7z32tzjIyXvHuct26t1xOQ5e6g1Z7OGrm76
         0KEVeYOxHk76Pp60n0LjWBPtaqsOAFwumag/hL5h8B/28CfVEqRbDiV4dnxfr7O4soxI
         OGiCbA+OCjoXJ/vmx3JfQoZbskOv77GWt0hr2ZDRQFzetMn/bBX8g6jogxMXlSM08CWf
         v4V+9wRFggZPDFBoHWvvkA5la4h02IKN8KnUNc/VMlpgikp579F12Hp1k9c9v1Qtyaiw
         f2zQ==
X-Forwarded-Encrypted: i=1; AFNElJ+SA9+hmvnhPFDWP8ooJDW7i+U0OMW9zOwQzhmG3acfGLzpDl4na4gzpuAossq7jaxLsfOC+4U=@lists.linux.dev
X-Gm-Message-State: AOJu0YyOTWHAOUbmcOeLkyNNlLVQj8O7QnwsMG4LQrc5du5hjqse+7sa
	SDde+nF90/9P6wJI8gWFl3tv6EmSlsHleUfH18Upa0aZIol2UVCg0g9sh6VvAprYYuMPBuPlDJV
	HbgUQrtdniD0rNBOKwZKi2KJhYQ==
X-Received: from jablt3.prod.google.com ([2002:a05:6638:ac03:b0:5e7:3fde:8787])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:10d2:b0:496:b7c:274b with SMTP id 5614622812f47-4960edef744mr2368951b6e.19.1782938623414;
 Wed, 01 Jul 2026 13:43:43 -0700 (PDT)
Date: Wed,  1 Jul 2026 20:43:37 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260701204342.2654385-1-coltonlewis@google.com>
Subject: [PATCH 0/5] Backport ARM64 VHE boot fixes to 6.6.y
From: Colton Lewis <coltonlewis@google.com>
To: stable@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

This series backports VHE CPU boot fixes to the 6.6.y stable branch.

These fixes are already present in the 6.12.y stable branch (and
newer), but are missing in 6.6.y. They are required to enable booting
L1 guests with nested virtualization enabled (kvm-arm.mode=nested).

Without these patches, a 6.6.y guest boots with HCR_EL2.E2H
incorrectly configured (because it misses VHE-only detection or early
initialization), causing early boot hangs/trap loops.

Conflict resolutions:
- Patch 4 (KVM: arm64: Initialize HCR_EL2.E2H early) had conflicts in
  arch/arm64/kvm/hyp/nvhe/hyp-init.S due to differences in state
  initialization. Resolved by extracting EL2 state initialization into
  __kvm_init_el2_state.
- Patch 5 (arm64: Revamp HCR_EL2.E2H RES1 detection) had conflicts in
  arch/arm64/include/asm/el2_setup.h. Resolved by using raw msr hcr_el2
  instead of the missing msr_hcr_el2 macro.


Marc Zyngier (4):
  arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
  arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is
    negative
  arm64: Fix early handling of FEAT_E2H0 not being implemented
  arm64: Revamp HCR_EL2.E2H RES1 detection

Mark Rutland (1):
  KVM: arm64: Initialize HCR_EL2.E2H early

 arch/arm64/include/asm/el2_setup.h | 52 ++++++++++++++++++++++++++++++
 arch/arm64/kernel/head.S           | 17 +++-------
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 16 +++++++--
 arch/arm64/tools/sysreg            | 37 +++++++++++++++++++++
 4 files changed, 107 insertions(+), 15 deletions(-)


base-commit: d1cfde2d5d15be14123bdd1689162bd27f995a90
--
2.55.0.rc2.803.g1fd1e6609c-goog
