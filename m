Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1852F8EA3
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781852713; cv=none; b=sL+V+IfLFOlxoa1eOGAVVStEvc4E4CFo3flfQe0RgCA0fc1B421qWumyElnCEq3sIjdIimWlbuBG36myJokvR0VBpXPKO+efLL3hXHuYmDRS0vTSyqlnkAGoagV0NwfxDNA/FAy9Eix2exLc9oMHQiX47mZlyCF/Qtbw63Auvko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781852713; c=relaxed/simple;
	bh=vmVLbKC5hr2bvTnRY+33FRlAabR9MaR638SdlHcGoNM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qphHFJB4zCV22TtvcQ9Tf9bSQ3QbgZHh3iYUNETfDGCK4N2NUBkPTGxgU/+6d/lTeO2zlqxGE0ETEOH0evdv1+hFRSZv3YGAoAsL3TCJXZ4SrwPR/hhhT43ukNMQp8Lz1G2QoQStMgMmtR96unrJ6gSLk4eJ/HqiIy+0xmJQq1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tYILfW67; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tYILfW67"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490c840efe6so23903485e9.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781852710; x=1782457510; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PGcRBYs3Z9Uumpf23hDhMQDIQ6d9ZOsDwaNEYfVocws=;
        b=tYILfW6736OG/hikrmt6em5MxdiqTNWJ9jkPx3J/s7opNrosQxftrcYh5EsrAcBNtt
         W87OnDIeaQrIy31UKkzWHjGpzHLkLnasAvsPBQolODa0WekAFzE0UNuvartsU19EZljf
         7fW7NgeFxCQpIANNRLAIaP+kA/yMwZLI3q2JkckNeU0mQZdCUKbeRRql3WGHo9GhLu6l
         Yhbe88EFCIyJB6ZpomL5VFoviJYy2T2//kmgWtD67lGJRz3tJlTdS8D430fLzYJSNb0b
         shcN1PH59Ny/n1na+Bq44MPdlwE1FRpMP+p3lc5qyb2rtYUrZNpv5VSpOo69KkeiiE4c
         ZA4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781852710; x=1782457510;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PGcRBYs3Z9Uumpf23hDhMQDIQ6d9ZOsDwaNEYfVocws=;
        b=bnlfbajCODwdVIlw7kJIRKwonn71Tub40Ezh0LDhWBk3dQ2rz5XpT1LREu21O1xK9v
         4mGYynWxp1R0WXixa/uNR+Il0rSE/OYP8msoW1DIVBVErvtev7xSkt15MjA1oIIKGLb+
         cg74CjmYkTiTv4MEUxm0JRxGsrSeiFYcp8W8I8ituKQPbH3rRPHgQ3V1KzdrDn/97xVk
         kSFLqzglsuHuF8F+wCebBAguvJqPpJgg9nwOwa5sEJkyyXTkbfQa8le6xFbFoytDHX/e
         f97IzLuy25pCMhj/rgxUo7n86e3FlPQ0oyuCOQf7tBOgW4PsMw08AshhW9uoki/dXu7/
         klsA==
X-Forwarded-Encrypted: i=1; AFNElJ+KG/EL3guwRY+zodnyLqOLTR9M2ng+SCy3suwSOqNOdN/isxlYpH0U5bkdZ71qOQex5kvnGqE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyXs4jEdmADvMFqbIqdVm5SaUrrJwRSv6ygrQDS3BVLlKEj75/r
	PV2vbq+EnEuGaW+PjVudLIzg9dLYmSuboPZsHJrTiSuHTPkcaG7X4up9v6bwD4bzC12nro6IcmX
	PSA==
X-Received: from wmpu38.prod.google.com ([2002:a05:600c:4d26:b0:492:4314:560e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600d:15a:20b0:490:5000:917
 with SMTP id 5b1f17b1804b1-492409fbfc4mr20439135e9.1.1781852709851; Fri, 19
 Jun 2026 00:05:09 -0700 (PDT)
Date: Fri, 19 Jun 2026 08:05:00 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <20260619070508.802802-1-tabba@google.com>
Subject: [PATCH 0/8] KVM: arm64: Rework pKVM vCPU state synchronisation
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi folks,

Changes since v1 [2]:
  - Dropped the guard()/scoped_guard() conversion patches: standalone churn
    on code this series does not otherwise rework. (Marc)
  - Rebased onto kvmarm/next. The VGIC flush primitive now bounds used_lrs
    using the cached hyp_gicv3_nr_lr instead of reading ICH_VTR_EL2 on every
    entry. (Marc)
  - Grouped the PKVM_HOST_STATE_DIRTY flag with the other iflags and
    clarified its comment. (Marc)
  - Sync PSTATE alongside PC on every non-protected exit, and sync+dirty
    before host-side SError injection so the syndrome is not dropped. (sashiko)
  - Various cleanups and tidying up. (Vincent)

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

  01-04:  Preparatory refactoring (MPIDR, sys reg access, vCPU reset, PSCI
          helpers) to shared headers and HYP.
  05:     Host and hypervisor vCPU lookup primitives.
  06-07:  VGIC: reduce EL2's exposure to host state, add flush/sync primitives.
  08:     Lazy state sync for non-protected guests.

Based on kvmarm/next.

[1] https://lore.kernel.org/all/20260105154939.11041-1-will@kernel.org/
[2] https://lore.kernel.org/all/20260612065925.755562-1-tabba@google.com/

Cheers,
/fuad

Fuad Tabba (5):
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

 arch/arm64/include/asm/kvm_arm.h     |  12 ++
 arch/arm64/include/asm/kvm_asm.h     |   1 +
 arch/arm64/include/asm/kvm_emulate.h |  79 +++++++-
 arch/arm64/include/asm/kvm_host.h    |   2 +
 arch/arm64/kvm/arm.c                 |   7 +
 arch/arm64/kvm/handle_exit.c         |  30 ++++
 arch/arm64/kvm/hyp/exception.c       |  34 +---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   | 258 +++++++++++++++++++++++----
 arch/arm64/kvm/psci.c                |  30 +---
 arch/arm64/kvm/reset.c               |  60 +------
 arch/arm64/kvm/sys_regs.c            |  14 +-
 arch/arm64/kvm/sys_regs.h            |  19 ++
 include/kvm/arm_psci.h               |  27 +++
 13 files changed, 410 insertions(+), 163 deletions(-)

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog

