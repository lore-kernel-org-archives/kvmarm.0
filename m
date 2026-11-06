Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793985675;
	b=Aw6S5KPQBCLIGT2K/lK8W+RBQ2PRR1eBu4WG5rPYMbQQ8KHbDSqLqTDIy38zB+GZ47Vt
	 A+3qJ0lm/9Ek+mjHh5QATyO5afvMBqSFZJtaPT6ZekfjotaMs2eL51exywzBEJn60E0Eg
	 luJtMxXbHmC9zLc4mPXu8fDMxRjE/HTGdR6AhzSa1S1LGd8/yL7bCKGQE1ob4LepnBSbE
	 cVYm/ZLMEdksYVj9ByyhIg8k5aljyoWvCj+anyFvhm6nv4jlL6C60avMe+If/x0CEeO+H
	 CIMkqGmefFBgJJ30P1e4IFbUxVN7x8rretaElBOdG2f7+i7o613Ywyhfn9vILOJ0qSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793985675;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-SA-Exim-Connect-IP:
	 X-SA-Exim-Rcpt-To:X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=U5sv14dbUY73w+ibVHisrtwJwt6hsu+gob3cdY7WnKw=;
	b=5PezjA/lJnd5MsxfUJEYqLFblrHlCNP6Q2b1EJ2lwJFDIgl/1PloFzOPyijPnJdSGvrR
	 LjXCdSVRdRYxI4mjHccW9jL8gCm7Y3l5hJHp7TlQYXl7UfnRc/K5XVcJrZB6J89bqaRa3
	 rCsyK5kfOaWcfXf2kpdLzVRQZjRLt/NYH6c4+ZjneOMKWqRQhSp3PinCdZBybWDBIS8oA
	 D1pQqEYzBWA2bwNCWiouFYERqMb9NJcrB5rEFtQ+T/PZxcXt1T/X/92Gvwl2zehs1CUZy
	 UUjr5KGJlKygF6ppU1uGWjp6n2yERnt07NwX78UbI/JTWe0xLpLrOEMz4b6+foO8hyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n68mOmrL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98955606D803;
	Fri,  6 Nov 2026 17:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n68mOmrL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5881F0089F;
	Fri,  6 Nov 2026 17:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793985675;
	bh=U5sv14dbUY73w+ibVHisrtwJwt6hsu+gob3cdY7WnKw=;
	h=From:To:Cc:Subject:Date;
	b=n68mOmrLemTKlu37aZroTplBrrMzMJowUSvOCMlXobjKpdxLI6qlb3tPAB6MbuTBd
	 x0g2Sp0npjcaqFUPWfFnPVghBeTXZhB5vybYWurFmsNK5lj6h0OqcUyCEHxrNch7+h
	 0KoJtUidFvyh6/g5ONSFkPKLAfEf2fTK40+b5cIaOfXACkrZy77EmHoP53OLREOSNh
	 i5u/IO8WzThvxWUZtNAQ3XIKD3XNGRI4rH3Fy3J7D2bC8HMWWJDk18Uu73CLjV/+SJ
	 RnHJeCC9CYndiRVN1eMtTQlqy1wj8lOlG+ZWdYO9JPaBLgSVAYWTTgyg8ovk/A2Zoz
	 X+gV3K4muvh2w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xPNcm-0000000CI4M-2k9T;
	Fri, 06 Nov 2026 17:21:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Colton Lewis <coltonlewis@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Gavin Shan <gshan@redhat.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Oculytic <oculytic@gmail.com>,
	Oliver Upton <oupton@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Will Deacon <will@kernel.org>,
	Xuheng Li <xuheng@cs.columbia.edu>,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 7.4, take #2
Date: Fri,  6 Nov 2026 17:21:07 +0000
Message-ID: <20261106172107.3263617-1-maz@kernel.org>
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
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, ardb@kernel.org, catalin.marinas@arm.com, coltonlewis@google.com, fuad.tabba@linux.dev, gshan@redhat.com, imv4bel@gmail.com, joey.gouly@arm.com, leo.bras@arm.com, ljs@kernel.org, broonie@kernel.org, matthias.goergens@gmail.com, oculytic@gmail.com, oupton@kernel.org, sascha.bischoff@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, vdonnefort@google.com, weilin.chang@arm.com, will@kernel.org, xuheng@cs.columbia.edu, yaoyuan@linux.alibaba.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's the second set of KVM/arm64 fixes for 7.4, which is a pretty
large set as Fuad has made his mission to address each and every
Sashiko utterance. This is great work, in all the meanings of the word
Great.

We also have a couple of more "amusing" fixes, such as the livelock
issue that Ard managed to debug and elegantly address.

As usual, details in the tag below. I'll be at KVM Forum next week, so
I'll probably come back with another PR in time for -rc4 (I've already
earmarked a number of patches...).

Please pull,

	M.

The following changes since commit 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4:

  Linux 7.4-rc1 (2026-11-01 13:26:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-7.4-2

for you to fetch changes up to 181a701fc14d3d468c603b5ecfb9f12115c5fb72:

  Merge branch kvm-arm64/misc-7.4-1 into kvmarm-master/fixes (2026-11-03 18:14:37 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 7.4, take #2

* MMU fixes:

  - Correctly sanitise the TCR_EL2 register

  - Stop advertising LPA2 to NV guest when it isn't supported

  - Correctly convert EH2==0's view of TCR_EL2 into the E2H==1 format

  - Make sure an EL2 mapping is immediately visible to the hypervisor
    code, as we don't necessarily require ETS

  - Address a horrible situation where a guest can livelock when
    trying to solve a permission fault whilst the underlying S2 PTs
    have AF=0

  - Correctly wipe MTE tags for large mappings instead of just the
    head page, providing a convenient helper for this

  - Fix dirty logging detection in ring-only mode

  - Use ATS1A whenever FEAT_S1PIE is present

* VGIC fixes:

  - Fix a bunch of low-impact issues with GICv4, avoiding leaks on
    unlikely failure paths

  - Use a separate lockdep class for vPE doorbells, and guarantee that
    they are never threaded

  - Avoid spurious allocation of VPEs when userspace decided not to
    expose nASSGIcap

  - Fix spurious preservation of the pending state after DISCARD
    and CLEAR ITS commands

  - Make sure GITS_CTLR.Enabled is updated under the its_lock

  - Serialise vgic CTRL_INIT against vCPU creation

  - Make the forwarding of LPIs tobust against LPIs being disabled
    on the target redistributor

* pKVM fixes:

   - Fix the reset of GICv3 LRs for pKVM, de-uglifying the PM paths
     whilst at it

   - Fix PMU handling for both protected and non-protected guests,
     fixing the synchronisation of kvm_host_data in the process

   - Correctly invalidate TLBs and I-cache when multiplexing multiple
     vcpus of the same VM on a single physical CPU

* Feature visibility fixes:

  - Correctly handle ACCDATA_EL1 being exposed to guests, plugging a
    potential communication channel between guests.

* Misc fixes:

  - Correctly clear the vcpu feature set on init failure

  - Clear PSTATE.TCO on exit from the guest when MTE is enabled
    for the kernel

  - Let the L0 hypervisor always deal with FEAT_MOPS A/B nonsense when
    taking such exception, instead of potentially forwarding it

  - Add a "maintainer profile" for KVM/arm64

  - Add testing for the MOVI and MOVALL commands

----------------------------------------------------------------
Ard Biesheuvel (1):
      KVM: arm64: Don't livelock when AT can't resolve a fault IPA

Colton Lewis (1):
      irqchip/gic-v4: Use a separate lockdep class for vPE doorbell IRQs

Fuad Tabba (25):
      irqchip/gic-v4: Clear the domain and fwnode pointers after freeing them
      irqchip/gic-v4: Unwind what its_alloc_vcpu_irqs() allocated on failure
      KVM: arm64: vgic: Tear down what vgic_init() created when it fails
      KVM: arm64: vgic-v4: Restore nr_vpes before freeing the vPE resources
      KVM: arm64: vgic-its: Clear an unqueued LPI before dropping its lock
      KVM: arm64: vgic-its: Remove the pending state of a cleared LPI
      KVM: arm64: vgic-its: Update GITS_CTLR.Enabled under its_lock
      KVM: arm64: vgic-v4: Don't allocate vPEs for a GICv2 VM
      KVM: arm64: vgic-v4: Don't allocate vPEs when userspace clears nASSGIcap
      KVM: arm64: vgic: Don't forward LPIs to a redistributor with LPIs disabled
      KVM: arm64: vgic-v3: Don't drop a pending LPI mapped with LPIs disabled
      KVM: arm64: selftests: Add MOVI and MOVALL commands to the ITS library
      KVM: arm64: selftests: Build a VM per test in vgic_lpi_stress
      KVM: arm64: selftests: Test MOVI and MOVALL on a pending LPI
      KVM: arm64: Disable host PMU counters for protected guests
      KVM: arm64: Ensure TLBs and I-cache are private to each vCPU in pKVM
      arm64: Add override for ID_AA64ISAR1_EL1.LS64
      KVM: arm64: Enable ST64BV0 for guests with FEAT_LS64_ACCDATA
      KVM: arm64: selftests: Add ACCDATA_EL1 to get-reg-list
      KVM: arm64: Clear the VM's feature bitmap when kvm_setup_vcpu() fails
      KVM: arm64: Clear the default PMU when kvm_setup_vcpu() fails
      KVM: arm64: Clear the whole hugetlb folio when sanitising MTE tags
      KVM: arm64: Clear the whole hugetlb folio when storing MTE tags
      KVM: arm64: Sanitise MTE tags when a permission fault installs a mapping
      arm64: mte: Add mte_clear_folio_tags()

Marc Zyngier (11):
      Merge branch kvm-arm64/vgic-fixes-7.4-1 into kvmarm-master/fixes
      KVM: arm64: Reset TCR_EL2 according to guest's E2H mode
      KVM: arm64: Add ACCDATA_EL1 to the sysreg array
      KVM: arm64: Add context-switch of ACCDATA_EL1
      arm64: Add return value to mte_disable_tco_entry()
      KVM: arm64: Reenable MTE tag checking on exit from guest when running VHE
      KVM: arm64: Don't let a guest overwrite HCRX_EL2.MCE2
      Merge branch kvm-arm64/mmu-fixes-7.4-1 into kvmarm-master/fixes
      Merge branch kvm-arm64/pkvm-fixes-7.4-1 into kvmarm-master/fixes
      Merge branch kvm-arm64/ls64-accdata into kvmarm-master/fixes
      Merge branch kvm-arm64/misc-7.4-1 into kvmarm-master/fixes

Matthias Goergens (1):
      Documentation/process: Add a maintainer entry profile for KVM/arm64

Oliver Upton (2):
      KVM: arm64: nv: Correctly compute the effective TCR_EL1 for nVHE TCR_EL2
      KVM: arm64: Pass the PMU events to the hyp vCPU of non-protected guests

Sascha Bischoff (1):
      KVM: arm64: vgic: Serialise CTRL_INIT against vCPU creation

Vincent Donnefort (4):
      KVM: arm64: Make __vgic_v3_init_lrs HVC always available
      KVM: arm64: pkvm: Fix missing reset of GICv3 LRs
      KVM: arm64: pkvm: Reset GICv3 LRs in the hypervisor
      KVM: arm64: Synchronise kvm_host_data before host deprivileging

Wei-Lin Chang (5):
      KVM: arm64: nv: Don't advertise FEAT_LPA2 for guest stage-1
      arm64: sysreg: Add TCR_EL2 to sysreg infrastructure
      KVM: arm64: Convert TCR_EL2 to config-driven sanitisation
      KVM: arm64: Fix dirty logging detection in ring-only mode
      KVM: arm64: Remove stale remark on canonical IPA alignment

Will Deacon (1):
      KVM: arm64: Use S1E1A when Stage-1 PIE is supported

Xuheng Li (1):
      KVM: arm64: Add an ISB after mapping a hyp fixmap slot

 Documentation/admin-guide/kernel-parameters.txt    |   3 +
 Documentation/process/maintainer-kvm-arm64.rst     | 181 +++++++++++++++
 MAINTAINERS                                        |   2 +
 arch/arm64/include/asm/cpufeature.h                |   5 +
 arch/arm64/include/asm/kvm_arm.h                   |  13 --
 arch/arm64/include/asm/kvm_asm.h                   |   2 +-
 arch/arm64/include/asm/kvm_emulate.h               |   3 +
 arch/arm64/include/asm/kvm_host.h                  |   5 +-
 arch/arm64/include/asm/kvm_nested.h                |  38 ++-
 arch/arm64/include/asm/mte.h                       |  14 +-
 arch/arm64/include/asm/sysreg.h                    |   1 -
 arch/arm64/include/asm/virt.h                      |   2 +-
 arch/arm64/kernel/cpufeature.c                     |   7 +
 arch/arm64/kernel/mte.c                            |  15 +-
 arch/arm64/kernel/pi/idreg-override.c              |   2 +
 arch/arm64/kvm/arm.c                               |  60 +++--
 arch/arm64/kvm/config.c                            | 112 +++++++++
 arch/arm64/kvm/guest.c                             |  11 +-
 arch/arm64/kvm/hyp/include/hyp/fault.h             |   5 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  24 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |  23 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  16 +-
 arch/arm64/kvm/hyp/nvhe/mm.c                       |   1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  22 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c               |   4 +
 arch/arm64/kvm/hyp/nvhe/switch.c                   |  24 ++
 arch/arm64/kvm/hyp/vhe/switch.c                    |   7 +
 arch/arm64/kvm/mmu.c                               |  21 +-
 arch/arm64/kvm/nested.c                            |  15 ++
 arch/arm64/kvm/pkvm.c                              |   6 +
 arch/arm64/kvm/sys_regs.c                          |  22 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |  21 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |  68 +++---
 arch/arm64/kvm/vgic/vgic-kvm-device.c              |   2 +
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |  40 ++--
 arch/arm64/kvm/vgic/vgic-v3.c                      |   3 +-
 arch/arm64/kvm/vgic/vgic-v4.c                      |   5 +-
 arch/arm64/kvm/vgic/vgic.c                         |  12 +-
 arch/arm64/kvm/vgic/vgic.h                         |   1 +
 arch/arm64/tools/cpucaps                           |   1 +
 arch/arm64/tools/sysreg                            | 125 ++++++++++
 drivers/irqchip/irq-gic-v4.c                       |  39 +++-
 tools/testing/selftests/kvm/arm64/get-reg-list.c   |   2 +
 .../testing/selftests/kvm/arm64/vgic_lpi_stress.c  | 258 +++++++++++++++++++--
 .../selftests/kvm/include/arm64/gic_v3_its.h       |   2 +
 tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c |  28 +++
 46 files changed, 1099 insertions(+), 174 deletions(-)
 create mode 100644 Documentation/process/maintainer-kvm-arm64.rst
