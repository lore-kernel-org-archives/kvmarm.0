Received: from mta1.migadu.com (out-226.mta1.migadu.com [95.215.58.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE3543F4B8
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 16:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194067; cv=none; b=MBdUmzpUZMy7wad+LUCME8qN80D8FJjkFIPt1Um0LVFsXA1zXIl0M2Pn7ENxLpT3fCOVOTELKrDmTlakoUcUPhMbUrh5b8nw+IkL5tX+W8Lax7MOiG4SiiKPlc8OAXKXmVQbzCsMArGkgS8yfAigQOnjsSvzGaN+a70clHAa4Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194067; c=relaxed/simple;
	bh=OjiJw5Ri2IswQ+qol6VPVua602xfpaWaBjwzNZYz7DM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=udAIDZ/UqshlCq9ANb8HhSqrXlpmEnF/K9V+iIobRJuf/Se3Ch1CaMOE6ixXAPYGWTP3NEc4biRD40JehNUcQxv27fZd75OgXmgCM4iHCeH0tvdBulgn54xvAWW7YhT0PdjT8fJN7UaEMfk5aRu9gT+DpzKiWzmjrRozqdhb1jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rJfoQeQR; arc=none smtp.client-ip=95.215.58.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rJfoQeQR"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=OjiJw5Ri2IswQ+qol6VPVua602xfpaWaBjwzNZYz7DM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788194061; v=1; x=1788798861;
 b=rJfoQeQRLdlGVj9cSzkmTvBH/zQMq+cuvzECjblJCohcDcML/7A/q5irTTuWFVyhlnvg/pW5
 93N90ipwg3FCV18/21T6VS7GF+gmviEi0sZbDrTvGWbqJ3CZxzoPeYq8+2UGXUtZxDm9Zh5aY+L
 DCmdkfqg09rEZScnkwegxrL8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id da6ff5917ccc6f32;
	Mon, 31 Aug 2026 16:34:21 +0000
X-Mizu-Trace-ID: da6ff5917ccc6f32
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 00/17] KVM: arm64: Confine protected VM vCPU state to EL2
Date: Mon, 31 Aug 2026 17:34:04 +0100
Message-Id: <20260831163421.272420-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Following the vCPU state-sync series [1], this series completes the
job for protected VMs: a protected guest's register state stays at
EL2, and the host sees only what handling each exit needs.

EL2 marshals a protected vCPU's state per exception class instead of
copying the whole context both ways. It owns the vCPU's trap
configuration, system register reset and HVC handling, and implements
PSCI itself: AFFINITY_INFO never reaches the host, and CPU_ON and
CPU_OFF are decided at EL2 with the host only scheduling or parking
the target. Host ioctls that would reach the state EL2 owns fail with
a clean errno, so a protected VM's state is not save/restorable. All
of this is scoped to KVM_VM_TYPE_ARM_PROTECTED, and pkvm.rst describes
the resulting API.

The kvmtool changes that go with this will be posted separately, and I
will reply here with a link.

Patch 1 is the HCR_EL2.VSE fix posted separately [2]. It is not part
of this series; it is carried so the series applies as is and Sashiko
can run on it.

The KVM_ARM_PREFERRED_TARGET documentation fix [3] went out just ahead
of this series. Nothing here needs it to apply, but patch 17 documents
vCPU feature availability as something the capabilities report, while
api.rst 4.83 still points userspace at a bitmap that has always been
empty.

The series is structured as follows:

  01:     The HCR_EL2.VSE fix, posted separately.
  02-03:  Capability allowlist and the PVTIME rejection.
  04-05:  Per-exception-class entry handlers; EL2 owns a protected
          vCPU's trap configuration.
  06-08:  Timer state, system register reset and HVC handling at EL2.
  09-10:  PSCI at EL2, and the KVM_ARM_VCPU_INIT and PSCI version
          restrictions.
  11-14:  Host PC adjustments blocked; an UNDEF at EL2 for exit
          classes the host does not emulate; per-class state
          marshalling; a protected guest's SError pended with
          HCR_EL2.VSE.
  15-16:  Host access to private state, and host power-on of a vCPU
          EL2 holds powered off, rejected.
  17:     Documentation.

Still to come: selftests, self-hosted debug, SVE for protected guests,
and much more, as separate series.

Based on v7.3-rc1 (cee9395acd804).

Cheers,
/fuad

P.S. Sashiko, bring it on!

[1] https://lore.kernel.org/all/20260729131823.2021516-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/20260829071120.2522788-1-fuad.tabba@linux.dev/
[3] https://lore.kernel.org/all/20260831162815.269851-1-fuad.tabba@linux.dev/

Fuad Tabba (15):
  KVM: arm64: Sync HCR_EL2.VSE back to the host vCPU under pKVM
  KVM: arm64: Advertise the capabilities that protected VMs support
  KVM: arm64: Reject the PVTIME vCPU attribute for protected VMs
  KVM: arm64: Skip fixed-feature state flush for protected vCPUs
  KVM: arm64: Add system register reset framework for protected VMs
  KVM: arm64: Implement HVC handling for protected guests at EL2
  KVM: arm64: Handle PSCI calls for protected VMs at EL2
  KVM: arm64: Restrict KVM_ARM_VCPU_INIT and PSCI version for protected
    VMs
  KVM: arm64: Prevent host PC adjustments for protected vCPUs
  KVM: arm64: Inject an UNDEF at EL2 for unhandled protected guest exits
  KVM: arm64: Add per-EC entry/exit state marshalling for protected
    guests
  KVM: arm64: Pend a protected guest's SError with HCR_EL2.VSE only
  KVM: arm64: Reject host access to protected VM private state
  KVM: arm64: Reject host power-on of a vCPU that EL2 holds powered off
  KVM: arm64: Document the protected VM userspace API

Marc Zyngier (2):
  KVM: arm64: Introduce per-EC entry handlers for pKVM
  KVM: arm64: Add {flush,sync}_hyp_timer_state() primitives

 Documentation/virt/kvm/api.rst                |  22 +-
 .../virt/kvm/arm/fw-pseudo-registers.rst      |   2 +
 Documentation/virt/kvm/arm/pkvm.rst           | 141 ++++-
 Documentation/virt/kvm/devices/vcpu.rst       |   4 +-
 arch/arm64/include/asm/kvm_asm.h              |   1 +
 arch/arm64/include/asm/kvm_host.h             |  21 +
 arch/arm64/include/asm/kvm_pkvm.h             |  34 +-
 arch/arm64/kvm/arm.c                          |  40 ++
 arch/arm64/kvm/guest.c                        |  29 +
 arch/arm64/kvm/hyp/exception.c                |  27 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  18 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 564 +++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 401 ++++++++++++-
 arch/arm64/kvm/hyp/nvhe/switch.c              |  29 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |  91 ++-
 arch/arm64/kvm/hypercalls.c                   |   7 +
 arch/arm64/kvm/inject_fault.c                 |   5 +-
 arch/arm64/kvm/pkvm.c                         |  21 +-
 arch/arm64/kvm/psci.c                         |   3 +
 19 files changed, 1378 insertions(+), 82 deletions(-)


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.39.5

