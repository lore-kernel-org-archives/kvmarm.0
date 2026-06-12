Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FD4314B95
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 06:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781247569; cv=none; b=KQQ+IcRL+TfgIjTsgIey5sytkZlGlDUAMSs+jNA/BBcHteCopJtKAHgKcAFXm7s50dv4NV8FU64wEm4wng/xnov5tuCYtlE/O3MyiDwEr+Os3nE8vFg5H8OjBlRewI2Zxw2BTeisob2X35H87/Kc5AKqoFgpZ+YBFYIIVlCcATE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781247569; c=relaxed/simple;
	bh=2NWQv9gpSA5WmDYPM1gJ/c2gsARVXvjNHnCAwfJpAhY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=PtwLZ4E/diCjDG4gcNp82YGulAO/nY731pzIcqwwqgbD10ei8J5YvR5juIKjtDIFGd6jloVEF2gnWrQXV+wzWsfpqUwg1Ne7Fo3vnLr5dh9r6kMpw0mcrJLjXFdgquVHV5pqrobkyiG1dbo2cfuqxI4/DTkiRuSzjn6s7jWDmIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E9BtSLZy; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E9BtSLZy"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490b79e6b94so4624425e9.2
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 23:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781247566; x=1781852366; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3/A8TfYJZJXuz9sD68tmOmSoDXJZKG01yZuG4gQpAiw=;
        b=E9BtSLZyybOCacqnuaGX+lb95TXsMD5cEa6OZVODAmXcjw8Xr6Xp6jdigKnIIlHX3y
         foVGSAel27tXaKwjU9ODT+XdYS9FW2sY1CvxBO64lj3qBkcJnACWpNLGW70h590mJkuG
         IZ/+gwck7O+tf5p+sid0vswx8dxC9zKRoppS5tNCQY1h7a4CJ+H7zl+doPinnbGZRurc
         bOdMB5eojt3bvvnqW/eP5zNvGTDJ11Gl8l1SMlt7L6Vw2njBmXuivlwB9CeLqFcUuOus
         U9XJXsQlugaK9yeceXB1ecA2guBmgfSen56bJd2leccOjCHFseAoUHpkzKK6S9TEQX5y
         xV+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781247566; x=1781852366;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3/A8TfYJZJXuz9sD68tmOmSoDXJZKG01yZuG4gQpAiw=;
        b=Igd85nOQQ0tWBBJ8OuGX2yIZoodjPH14LiJYPi6HeZMQy6JVpkU6wKtEMgek2bY6AO
         NR2anERTPLFjuy0nGBQV98nCKU3KbLuhz/opCYEfChBUz5VE1FdJFVtW7Hvlv1vijb2d
         6eE4gxZcJXU6JQ0MdIBSe9y96Fazq0Y515tDTh1iuuAcTXCfG25J6WiBwJ7CWni6hWAH
         C7mTYfDtzbT0S9fR1GPO27LmP0uIIASRDXkmsZVcTjKXajTsYL9YqWgWD3oLdl70o8oa
         5U/9Yr7OH9f39em0xhVP2w5SMIx2oQAxiIyFIxCnLaT6Bx8M/xvKR/DU1FpijR5A5wt1
         qiww==
X-Forwarded-Encrypted: i=1; AFNElJ/DYMNIjFHwEAq2qWINsAtNM8elVnIrqXCYAnMAMp0vfca93bjlhqarvsf1y5QjYkyHmkGfRc0=@lists.linux.dev
X-Gm-Message-State: AOJu0YydDSGkAhEEvHl/e8lIH4rt0hNSvTO5593q4DmP9qg0Kla4tIbn
	9dNOlbWWmHePSN/U5dSkChEpm6oYR6OH/ietVerY5a6nSm17+/o85DbmVZhDXxGVwKRLJTaPLUX
	39Q==
X-Received: from wmbg25.prod.google.com ([2002:a05:600c:a419:b0:490:b2b0:c4aa])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600d:6447:10b0:490:e18f:d108
 with SMTP id 5b1f17b1804b1-490ec501b2cmr10440745e9.19.1781247566496; Thu, 11
 Jun 2026 23:59:26 -0700 (PDT)
Date: Fri, 12 Jun 2026 07:59:14 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612065925.755562-1-tabba@google.com>
Subject: [PATCH v1 00/11] KVM: arm64: Rework pKVM vCPU state synchronisation
From: tabba@google.com
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sebastian Ene <sebastianene@google.com>, 
	Per Larsen <perlarsen@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi folks,

Building on Will's pKVM infrastructure series [1], this series reworks
how pKVM moves vCPU state between the host and EL2, and stops copying a
non-protected guest's state on every world switch.

EL2 gains proper primitives for the state it transfers: vCPU lookup
helpers, and VGIC flush/sync that reduces how much host state EL2
dereferences. The series also moves some preparatory code (such as sys
reg access and PSCI helpers) to shared headers and HYP, and implements
lazy copying of a non-protected guest's register state back to the host
until the host actually needs it, instead of on every exit.

This is the first of two series moving pKVM vCPU state management to
EL2. The follow-up completes the job for protected VMs: state
isolation, PSCI handling at EL2, and the resulting API behaviour.

The series is structured as follows:

  01-03:  Guard/scoped-resource support for hyp_spinlock and KVM locking
          (Marc asked for this to land as a prequel to a series that uses it).
  04-07:  Preparatory refactoring (MPIDR, sys reg access, vCPU reset, PSCI
          helpers) to shared headers and HYP.
  08:     Host and hypervisor vCPU lookup primitives.
  09-10:  VGIC: reduce EL2's exposure to host state, add flush/sync primitives.
  11:     Lazy state sync for non-protected guests.

Based on v7.1-rc7.

[1] https://lore.kernel.org/all/20260105154939.11041-1-will@kernel.org/

Cheers,
/fuad

Fuad Tabba (8):
  KVM: arm64: Add scoped resource management (guard) for hyp_spinlock
  KVM: arm64: Use guard(hyp_spinlock) in pKVM hypervisor code
  KVM: arm64: Use guard()/scoped_guard() in arm64 KVM EL1 code
  KVM: arm64: Extract MPIDR computation into a shared header
  KVM: arm64: Make vcpu_{read,write}_sys_reg available to HYP code
  KVM: arm64: Factor out reusable vCPU reset helpers
  KVM: arm64: Move PSCI helper functions to a shared header
  KVM: arm64: Implement lazy vCPU state sync for non-protected guests

Marc Zyngier (3):
  KVM: arm64: Add host and hypervisor vCPU lookup primitives
  KVM: arm64: Minimise EL2's exposure of host VGIC state during world
    switch
  KVM: arm64: Add primitives to flush/sync the VGIC state at EL2

 arch/arm64/include/asm/kvm_arm.h           |  12 +
 arch/arm64/include/asm/kvm_asm.h           |   1 +
 arch/arm64/include/asm/kvm_emulate.h       |  80 ++++++-
 arch/arm64/include/asm/kvm_host.h          |   2 +
 arch/arm64/kvm/arm.c                       |  21 +-
 arch/arm64/kvm/handle_exit.c               |  22 ++
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h |   6 +
 arch/arm64/kvm/hyp/nvhe/ffa.c              | 154 +++++--------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         | 255 ++++++++++++++++++---
 arch/arm64/kvm/hyp/nvhe/mm.c               |  37 +--
 arch/arm64/kvm/hyp/nvhe/page_alloc.c       |  13 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c             |  86 +++----
 arch/arm64/kvm/mmu.c                       |  80 +++----
 arch/arm64/kvm/pkvm.c                      |  26 +--
 arch/arm64/kvm/psci.c                      |  47 +---
 arch/arm64/kvm/reset.c                     |  68 +-----
 arch/arm64/kvm/sys_regs.c                  |  14 +-
 arch/arm64/kvm/sys_regs.h                  |  19 ++
 include/kvm/arm_psci.h                     |  28 +++
 19 files changed, 562 insertions(+), 409 deletions(-)


base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48
-- 
2.54.0.1136.gdb2ca164c4-goog

