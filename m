Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015152;
	b=Odd0qDYlSdV+XEnUY76UMF+cZRrT/9Z1xiaAetZLe2abDVaPxEjz/59D/mnKAAK+SO/x
	 5hIMhCqTJ8BV61Xtfs7phY2/3cfuDB4Ll80ShZSHm0A/EPSrapfup9HnggZS+yqX6WBu3
	 4OCU9Hpd1DKOc3HnEDD7mGRxoJgU1/52Z+a0BI9bMxR7dzf2RSRMmSdBgIa1pMwPceJQA
	 wURf3RSbE5+5rcC0EOkozg0lff+MG5A+gi2DXFkTEbeFurek2BY8JEQiV3afp50fF+uo8
	 vTKjuAGjj6ewj6c4h5qu7phEQNBbQDOdPfOsMB4rR5Oe1vBwRzeV/9aqhN87lZggBOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015152;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=b/gQvZdYuSoNjfsyaYYmldiSRT42v5KIS64hwTIF/F4=;
	b=eAyOHN744M47TUZKPmQHQ5n48IUIARuOEcABWSn7Tk90QPnVfCsLZJvHYFF5Aumk/4pN
	 EsvhDVRWi6qNgTpH8RPIO8ZzujsLqAUjarHoyPlZHGPneO6TTvMa05QxmTMi+RsQrf4Vn
	 3nX7TQdHXSbfderFMHAtJM/B5yVUlu2ZGAcrXJ47Janui7q/kEO2ly6Jr/stM0ZTtJZOS
	 1CcrrsYKkJlxhqp40CPieCsCnaSNTvEXFOsy0HU2H3JIYgh0ZCZElRrLOpuwuN7s97BvI
	 Mz8RKBZzSu0B9LcNWtHUOcOvoWkaKVxDigP1n1Egp0F1ytGUIrUIaL0VmF4+CUXG3Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UsL5AlUb;
	arc=none smtp.remote-ip=91.218.175.5
Received: from mta0.migadu.com (out-5.mta0.migadu.com [91.218.175.5])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6815B606A33D
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 15:19:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6815B606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UsL5AlUb
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=F6dPWpezD5NGe7tsKY5+ATADI9q8qmfifryfnNwOJDg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795015149; v=1; x=1795619949;
 b=UsL5AlUbDWh/19p50gzzwLphRnCXfGIgAskWlrfYE/PSZWxCUhQCZttGoQORTH59g8tuRyCo
 LkNMO7ED3p28DAGdsdrl+UrWSXjPxjxGcFBe5IDwbtjnZ7pQyNO6dth5P+BAgWFYbeUAsyjKqhr
 4Md6J/rEPVUWIhc+X17kIwwQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 57c5a3e7a529813e;
	Wed, 18 Nov 2026 15:19:09 +0000
X-Mizu-Trace-ID: 57c5a3e7a529813e
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sebastian Ene <sebastianene@google.com>,
	=?UTF-8?q?Bart=C5=82omiej=20Grzesik?= <bgrzesik@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Radu Rendec <radu@rendec.net>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 00/13] KVM: ITS hardening for pKVM
Date: Wed, 18 Nov 2026 15:18:51 +0000
Message-ID: <20261118151904.4099560-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi folks,

Changes since v3 [1]:
  - The hypervisor never gives an ITT back to the host (patch 11).
  - The limit on devices per ITS now counts every DeviceID mapped since
    boot (patch 11).
  - A host read of an ITS register now aborts, unless the driver reads
    that register (patch 9).
  - Rebased on 7.4-rc3.
  - Various cleanups and wording fixes.

The ITS writes to the memory that its command queue and tables point
to, and the host programs both, so a host that controls the ITS can
write to hypervisor and protected-VM memory. With this series the
hypervisor owns the command queue, the tables and the ITTs, traps every
host access to the ITS control frame, and checks each command before
forwarding it to the ITS. The cover letter for v3 [1] describes the
design in more detail.

This series covers the ITS. The redistributors will follow in a series
of their own.

Jinjie's series [2] lets the collection table have two levels, which
this series doesn't handle. Once it's merged, I'll send patches that
make the hypervisor handle that table the way it handles the device
table.

Tested on QEMU with a program that writes forged commands, table
entries and register values to the ITS through /dev/mem from the host's
userspace. Also tested on FVP, where the ITS uses physical redistributor
addresses (GITS_TYPER.PTA). There, every secondary CPU was hotplugged
after the takeover, so that the driver maps each returning CPU's
collection through the hypervisor with a MAPC that carries a physical
address.

The series is structured as follows:

  01:     MMIO donation.
  02:     Taking host-registered MMIO regions at finalisation.
  03-06:  Driver preparation: GICv4 off, page-aligned ITTs, computing
          the wait target under the ITS lock, the shared command
          accessors.
  07:     Deprivileging the host under stop_machine().
  08-09:  The takeover: the driver's entry points, then the hypervisor
          trapping the control frame, taking the command queue and
          emulating GITS_CTLR and GITS_CBASER.
  10-11:  The tables and GITS_BASER<n>, then the ITTs.
  12:     Rejecting commands whose IDs are out of range.
  13:     Documentation.

Based on Linux 7.4-rc3 (aebb727447640).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261102130133.3684226-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/20261117123116.591621-1-ruanjinjie@huawei.com/

Bartłomiej Grzesik (2):
  irqchip/gic-v3: Disable GICv4 features in pKVM
  irqchip/gic-v3-its: Page-align ITT allocations in pKVM

Fuad Tabba (7):
  irqchip/gic-v3-its: Compute the wait target under the ITS lock
  KVM: arm64: Share the ITS command field accessors with the hypervisor
  KVM: arm64: Deprivilege the host under stop_machine()
  KVM: arm64: Take the ITS tables and restrict GITS_BASER<n>
  KVM: arm64: Take the ITT of every device the host maps
  KVM: arm64: Reject ITS commands whose IDs are out of range
  Documentation: KVM: arm64: Describe the ITS hardening

Mostafa Saleh (1):
  KVM: arm64: Donate MMIO to the hypervisor

Sebastian Ene (3):
  KVM: arm64: Take host-registered MMIO regions at pKVM finalisation
  irqchip/gic-v3-its: Add the pKVM takeover entry points
  KVM: arm64: Emulate the ITS command queue

 .../admin-guide/kernel-parameters.txt         |   8 +-
 Documentation/virt/kvm/arm/pkvm.rst           |  34 +
 arch/arm64/include/asm/kvm_asm.h              |   2 +
 arch/arm64/include/asm/kvm_hcall.h            |   2 +
 arch/arm64/include/asm/kvm_pgtable.h          |   2 +
 arch/arm64/include/asm/kvm_pkvm.h             |  16 +
 arch/arm64/kvm/arm.c                          |   4 +
 arch/arm64/kvm/hyp/include/nvhe/its_emulate.h |  16 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   5 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   3 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   8 +
 arch/arm64/kvm/hyp/nvhe/its_emulate.c         | 765 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 130 ++-
 arch/arm64/kvm/hyp/nvhe/setup.c               |  22 +
 arch/arm64/kvm/hyp/pgtable.c                  |   8 +-
 arch/arm64/kvm/pkvm.c                         | 105 ++-
 arch/arm64/kvm/vgic/vgic-its.c                |  15 -
 drivers/irqchip/irq-gic-common.h              |  13 +
 drivers/irqchip/irq-gic-v3-its.c              | 301 ++++++-
 drivers/irqchip/irq-gic-v3.c                  |   8 +
 include/linux/irqchip/arm-gic-v3.h            |  65 ++
 21 files changed, 1475 insertions(+), 57 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/its_emulate.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/its_emulate.c


base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.47.3

