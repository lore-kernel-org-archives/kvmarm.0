Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7189D1E98EF
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781852843; cv=none; b=uXvxc+n3GdqcKQjfL/+kWFh14RwfcIVY6JmFmNOpoyG6hPbQBgnudfTIh1Hk7HwxMxA5LUtGywcIMp2m8lDN5jIKDd1VBzCWfcqMMbgELSesPxsTMMIXfsjbHJGiKt1hCPOqSLNg2Y62/lXEHL9Ea+sG/dHpNjVwn0X+d4My740=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781852843; c=relaxed/simple;
	bh=vmVLbKC5hr2bvTnRY+33FRlAabR9MaR638SdlHcGoNM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=PwgcJZZK9dA6kGMSQz/GFG0fgLpoYCouLlMeG6JESMEq+Tx3YVIxvp0xIjQkuFMEPIll6xnLlyrYJOK91Xv0b9qo7tMgMfPIZrhVlpXjMQ0ZFYdwkWsTJrv5kL5Mka2b74ZsYgyjwUid/V4p3yJDBdp90rxhwsuGLhSVpKlg+iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uDhJ2nQl; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uDhJ2nQl"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-697560b83f4so374928a12.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781852841; x=1782457641; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PGcRBYs3Z9Uumpf23hDhMQDIQ6d9ZOsDwaNEYfVocws=;
        b=uDhJ2nQlBpgyIvKhOsSOQUhAFWVbsBm2v4uqq2/c6RBy4x5CRHJIrdHX4N9KeORIHE
         V+LwG3QCaeBCsmf+mWFtjUvIm8+ui586BSmVNB05EtJPTxw8mEFzbUGOzsTvzm0CWj1p
         wVmkcv1S4pSl9C75tR7i0a0VQ+m0Z1K20UlNv+P9bIyESe2+ezN7r9voMYnG4xctI0QZ
         ZYz6hfzjO9oJoSvTZ9js+kxUFBnGLPJLYl13HA7LwZH0Rt/P1QvWByunobgsR9h2uVQ2
         dXdHDhsWi2o7d/gEett56uQONtJ7YvdefD2+y7NKzYcAyVwq3JKaxSjX4aS8Ev90m8ik
         XRfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781852841; x=1782457641;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PGcRBYs3Z9Uumpf23hDhMQDIQ6d9ZOsDwaNEYfVocws=;
        b=PRsJjjKDhmYL54/tLFyfulSjsDL5stnvCRqkLRmB6+Btmasd96HxQdAWSGaJyOjE9q
         yJYo/vh7yovHZ59olcoOv8g9GrYjcW4CzI7l/ucayBjJHQFAmjmulKeyWjsySxGLj1Zg
         rSPbiNHRE86qyaOwtAvsXwf1eiNzbgfF2b8an5jFSE0aptTWd8uDWwbHG5iwbCWnQqjW
         n1W8ucUPkVUASikutgA3Kp4L2Jv9oqjFTxh6peng3jpubax7I2YK3te80BVmDypEj7c2
         X0iXJsCtdrraBiEaAkYqNcoKHa1k0Bf1wvyO5otSWW8fSH6w+kac108ptZ3bST1xT9yR
         8x6A==
X-Forwarded-Encrypted: i=1; AFNElJ+ravpNDBpa8Ub7dUYoxT5dg0LDKPFRm39YcW+T7YQiUZWu8g+WFflMVeFRCy9mWFqY0WCIdo4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDydNpbEuD8525JTihTAadHoZ2svjRsbV26JE2/eo0f57WZPoy
	FxfRfWIrOO5+Ij16oZOXlC/CiHagsVP4wqPJe7UJrD6/ZUJUcf6ON4Gk47I9Zz+UP+P20g8wMQq
	ZTw==
X-Received: from edf28.prod.google.com ([2002:a05:6402:21dc:b0:692:3d87:5b0d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:5288:b0:68b:ca3c:6bbb
 with SMTP id 4fb4d7f45d1cf-6973bcaa247mr932499a12.11.1781852840465; Fri, 19
 Jun 2026 00:07:20 -0700 (PDT)
Date: Fri, 19 Jun 2026 08:07:11 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <20260619070719.812227-1-tabba@google.com>
Subject: [PATCH v2 0/8] KVM: arm64: Rework pKVM vCPU state synchronisation
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

