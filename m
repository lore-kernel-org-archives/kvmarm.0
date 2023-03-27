Received: from out-43.mta1.migadu.com (out-43.mta1.migadu.com [95.215.58.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A04333E7
	for <kvmarm@lists.linux.dev>; Mon, 27 Mar 2023 16:48:14 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679935692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LqKTO4E6HX4QiDyoWT5sl9XwAA/YwIMfS1uwE5bBi/M=;
	b=YJsgiKrG8o0W3905kwgXWw0NpXm8CQhGKW3hOnljJwhb/y9/5VO7TTApM2BoNfERI9ax1/
	EYzwPJ29Wi516AK16lsrOidUO2yS9tg7Bs46B2psRwh/CEnw5/rxHqzUCS/0NnfA60Vc6b
	DLC2ZdF7qC7dhqTh/VUbgqWkDQ4pskE=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvmarm@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Jeremy Linton <jeremy.linton@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 0/4] KVM: arm64: Fix vcpu->mutex v. kvm->lock inversion
Date: Mon, 27 Mar 2023 16:47:43 +0000
Message-Id: <20230327164747.2466958-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

As it so happens, lock ordering in KVM/arm64 is completely backwards.
There's a significant amount of VM-wide state that needs to be accessed
from the context of a vCPU. Until now, this was accomplished by
acquiring the kvm->lock, but that cannot be nested within vcpu->mutex.

This series fixes the issue with some fine-grained locking for MP state
and a new, dedicated mutex that can nest with both kvm->lock and
vcpu->mutex.

Tested with kvmtool and QEMU scaled up to 64 vCPUs on a kernel w/
lockdep enabled. Applies to kvmarm-fixes-6.3-2.

Please note that these changes will most likely be taken in the 6.4
merge window and not as a fixup during 6.3. After discussing with Marc
we agreed that letting these patches marinade in -next for a while is
probably best as it is quite an overhaul to our locking. Additionally,
there is no evidence of actual deadlocks occurring in the wild, likely
because we _always_ ordered the locks backwards, hence the only breakage
at the moment is lockdep.

Also, Jeremy, I chose to omit your Tested-by tag on the last patch as it
was rather significantly changed from when you last took it for a spin.

v1: http://lore.kernel.org/kvmarm/20230308083947.3760066-1-oliver.upton@linux.dev
v2: https://lore.kernel.org/kvmarm/20230316211412.2651555-1-oliver.upton@linux.dev/

v2 -> v3:
 - Continue to acquire the kvm->lock where we must protect against a
   concurrent vCPU creation (Marc)
 - Plug a few missing WRITE_ONCE() promotions for mp_state (Marc)
 - Hold the mp_state_lock when reading reset_state (Marc)
 - Fix the unguarded write to mp_state in kvm_prepare_system_event()
 - Collect Jeremy's Tested-by tags (thanks!)

v1 -> v2:
 - Add a dedicated lock for serializing writes to MP state
 - Inform lockdep of acquisition order at time of VM/vCPU creation
 - Plug a race with GIC creation (Sean)
 - Use the config_lock in GIC ITS flows as well

Oliver Upton (4):
  KVM: arm64: Avoid vcpu->mutex v. kvm->lock inversion in CPU_ON
  KVM: arm64: Avoid lock inversion when setting the VM register width
  KVM: arm64: Use config_lock to protect data ordered against KVM_RUN
  KVM: arm64: Use config_lock to protect vgic state

 arch/arm64/include/asm/kvm_host.h     |  4 ++
 arch/arm64/kvm/arm.c                  | 53 +++++++++++++++++++++------
 arch/arm64/kvm/guest.c                |  2 +
 arch/arm64/kvm/hypercalls.c           |  4 +-
 arch/arm64/kvm/pmu-emul.c             | 23 +++---------
 arch/arm64/kvm/psci.c                 | 28 ++++++++------
 arch/arm64/kvm/reset.c                | 15 ++++----
 arch/arm64/kvm/vgic/vgic-debug.c      |  8 ++--
 arch/arm64/kvm/vgic/vgic-init.c       | 36 +++++++++++-------
 arch/arm64/kvm/vgic/vgic-its.c        | 18 ++++++---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 47 ++++++++++++++----------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    |  4 +-
 arch/arm64/kvm/vgic/vgic-mmio.c       | 12 +++---
 arch/arm64/kvm/vgic/vgic-v4.c         | 11 +++---
 arch/arm64/kvm/vgic/vgic.c            | 12 +++---
 15 files changed, 168 insertions(+), 109 deletions(-)


base-commit: 8c2e8ac8ad4be68409e806ce1cc78fc7a04539f3
-- 
2.40.0.348.gf938b09366-goog

