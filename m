Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB70131C58A
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 12:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764246134; cv=none; b=XC3yt4PpPGffLQ83AwQxhMK8VH7pi7Cr0hC1sEh8ixtaHROr+Fib4FcMMpSSlqroRzR58meFvBmFcBbrjiWQBNrp3VUt8QmH0gVTxJ1/n5AJvlCCN5TgniytOY/WCtSCkwN0xK9TZ0dx8379nPVUpeCr06OdP/5KNKQLkxCFlSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764246134; c=relaxed/simple;
	bh=I+XyZrDML5GYyRBQ+9H0cPwa/UYQ11eKVhIpq8ixLAI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Ni221nOuYTBpnsJ5kyp6hcGppkfXEJrmdACIuJGS0w9HCWQYckSR+9l6n/E3GhDkoyNW8pCr04AGs25ER3doFxofvNoRlA5Tq8GsoXK6YJcfrtZgM5AgVK9qXLHWhQVSGRIfIEqJZumAB9OkfyoxxsjmkWi1SbrlQ3h0gXlLFfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uyRf9gS8; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uyRf9gS8"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b3339cab7so651871f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 04:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764246131; x=1764850931; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GVwrAr1o2bOF3/BWCpSgvLRZ2BQlyKlslZCDEV//lbY=;
        b=uyRf9gS8HTpSzKCuHKrB2fPbgXPx199oChwCnTL91qR7TUGLEOlm7ZjjltJPSTj4yo
         20AfKe+I9i5czYC2aukHYc9/DvKs8aM6MrpUJp5Zg47SLwVCdIrFfFwZ8uXGRxfjUrOJ
         y7uVMcsQsLc4HvhQm24l8k89iu8eEVawPVqCtKq5+xroOTxJjlX8cOEtAk/WWOCqcGU7
         2ob4sCrIhlUDw5k3irqhNcfN03L3Ph2OVBDvd0Vhcb4ARSPLKGKcJ2wrZWywoftOP6mn
         BlH+Z9g4idJjU7mcHd5oIUrhAqfnNqwmdoE9i37wdWsNZ71MmabbSaw2N+rwe05thdem
         mJcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764246131; x=1764850931;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GVwrAr1o2bOF3/BWCpSgvLRZ2BQlyKlslZCDEV//lbY=;
        b=Pzh7DqrJ1aC9asHDivGxjyDEdghOw5ro70Othenm60i4Q96g7gzVvnRjFZL/B2EDPS
         KDrQwTL2NYAGmIwsa3yku3CEkJBKfLN9lLmpQuj05snrpd2xBsQNw5/oWkZPxcvLL5Ea
         w0u/wQw+NOaIObJDBHboRDT6u8CBiodkEqAThCGXCbUROvsI0f+gg8hc3ebgVDzayXQG
         Smeerj8E0spqN7PHpSiiz1o7eCDdF3KYStfI2O9s07u7NMkqHI0zdGf/7KJ8V/SvryZ3
         YhDr2WxECBWONd9rlqTvwteCCQ3s4v+mjFn0LeUnVkhxf7IwWHlI013l0C5/mZ79Axaj
         p3fQ==
X-Gm-Message-State: AOJu0YxaRbPZhw6YFx+WHLaum/3tSBeyqpnFgq+9G8aH3b6vr2p5Z2fU
	77rfVrZZqs/AZaQYvZ0IB68oHH8gi7fBz5ThcaXgNyrFsvQ8UAmqchRUiHr6Bl54cDSo14RljPt
	cC40pb/rmuZRU6X8EJ2CF603RlgtcJumTzYAjloSNi2asXFl3QzhKgZji9MzOtGx5YoujgEtetp
	t/LLwneX1oh/GsAdanWHs1h0ozleEUX6k=
X-Google-Smtp-Source: AGHT+IGc06Ksqz3q4KmChSDnqiNh6zGUCebNu9RwNyylVq1cMFdJSKjWUp6H3EkpXI5zoXsi+pYNq3SHSQ==
X-Received: from wmlm20.prod.google.com ([2002:a7b:ca54:0:b0:477:9aa2:7d50])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b96:b0:477:5c58:3d42
 with SMTP id 5b1f17b1804b1-47904ad907amr115795665e9.10.1764246131094; Thu, 27
 Nov 2025 04:22:11 -0800 (PST)
Date: Thu, 27 Nov 2025 12:22:05 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251127122210.4111702-1-tabba@google.com>
Subject: [PATCH v1 0/5] KVM: arm64: Enforce MTE disablement at EL2
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

pKVM never exposes MTE to protected guests (pVM), but we must also
ensure a malicious host cannot use MTE to attack the hypervisor or a
pVM.

If MTE is supported by the hardware (and is enabled at EL3), it remains
available to lower exception levels by default. Disabling it in the host
kernel (e.g., via 'arm64.nomte') only stops the kernel from advertising
the feature; it does not physically disable MTE in the hardware.

In this scenario, a malicious host could still access tags in pages
donated to a guest using MTE instructions (e.g., STG and LDG), bypassing
the kernel's configuration.

To prevent this, explicitly disable MTE at EL2 (by clearing HCR_EL2.ATA)
when the host has MTE disabled. This causes any MTE instruction usage to
generate a Data Abort (trap) to the hypervisor.

Additionally, to faithfully mimic hardware that does not support MTE,
trap accesses to MTE system registers (e.g., GCR_EL1) and inject an
Undefined Instruction exception back to the host.

This logic is applied in all non-VHE modes. For non-protected modes,
this remains beneficial as it prevents unpredictable behavior caused by
accessing allocation tags when the system considers them disabled.

Note that this ties into my other outgoing patch series [1], which also
has some MTE-related fixes, but is not dependent on it.

Based on Linux 6.18-rc7

Cheers,
/fuad

[1] https://lore.kernel.org/all/20251118103807.707500-1-tabba@google.com/

Fuad Tabba (4):
  arm64: Remove dead code resetting HCR_EL2 for pKVM
  arm64: Clear HCR_EL2.ATA when MTE is not supported or disabled
  arm64: Inject UNDEF when accessing MTE sysregs with MTE disabled
  KVM: arm64: Use kvm_has_mte() in pKVM trap initialization

Quentin Perret (1):
  KVM: arm64: Refactor enter_exception64()

 arch/arm64/include/asm/kvm_arm.h     |   2 +-
 arch/arm64/include/asm/kvm_emulate.h |   5 ++
 arch/arm64/kernel/head.S             |   2 +-
 arch/arm64/kvm/arm.c                 |   4 ++
 arch/arm64/kvm/hyp/exception.c       | 100 ++++++++++++++++-----------
 arch/arm64/kvm/hyp/nvhe/hyp-init.S   |   5 --
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   |  44 ++++++++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c       |   2 +-
 8 files changed, 114 insertions(+), 50 deletions(-)


base-commit: ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d
-- 
2.52.0.487.g5c8c507ade-goog

