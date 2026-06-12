Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B0632D7F8;
	Fri, 12 Jun 2026 08:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781254127; cv=none; b=izAMLcmUNEf4+3+Bwx6SLOzEfXdM6IzOk4KVQEtnyTW1H42xTcR96+w3ai4rlpMF1G69tEOFd1swzUVyD6RUkuGdRyEv0v4SwGoSTiEej+q4mA2eCfmrapI/F/7vihCSd8z8KAGY17F+gUjmUN/HxwktWX5nyTP3/B02/PftXZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781254127; c=relaxed/simple;
	bh=cjR4EyPEfOz2CmnN4l/86a3GsA3wPz3n5vXwoWtYfuk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cqdARs6e0zz1OWd17RBIrCHk8XYAWpv6G25Wn0AQ9A/TvuBmx2m2At9GD/3pHO0/iPx6HNBjnm5cnS4JUtWwMPS+oJ/Pm6roc8CoKEc3jkTqYQMh6UXLe3eD65fD/nG4LIcs2uO/wn/hcorR19eOfta2LUeheIb3QJqjH4cfHNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lbOgfhSj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lbOgfhSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC3E1F00A3A;
	Fri, 12 Jun 2026 08:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781254126;
	bh=ETzuSmY4AxCD7NaZlXpVC91d9g+bYgzEWeu45BfNrAw=;
	h=From:To:Cc:Subject:Date;
	b=lbOgfhSjB0KYpRn7xAseCv5yVhfc+KVFIYDxFDtVEPzG6uSvQX9qMXrsHGjKiU0Rs
	 LmD5dEVtuehjMgEByzgSAMu85Op8YOU/I4/vz6VdN7FrlMhiAFfvd2WOzX7TehnqMW
	 xjXt0pA+IrO9JNzIXAnTV1xSduOntTeU45ujkk6+t+G1AOVNSdZ3XkUw1jrZseYpEv
	 mv5s5ZNTBHbAyo+81K3Q2+7AaNM9DK6n1w0P6tbe6f2el7EZQqj7l6ycEujmBwWQu3
	 0RBPwyHAzpsxNjphxkADl48/0hucOgr9lW1+cY3U3eQSaXx+HHfOfGnOVhl5OC9L22
	 L6wjl8qjp8D9g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wXxZD-0000000C47z-28xi;
	Fri, 12 Jun 2026 08:48:43 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Fuad Tabba <tabba@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Jackie Liu <liuyun01@kylinos.cn>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 updates for 7.2
Date: Fri, 12 Jun 2026 09:48:35 +0100
Message-ID: <20260612084835.2992552-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com, eric.auger@redhat.com, tabba@google.com, imv4bel@gmail.com, liuyun01@kylinos.cn, joey.gouly@arm.com, mark.rutland@arm.com, oupton@kernel.org, sascha.bischoff@arm.com, vdonnefort@google.com, weilin.chang@arm.com, will@kernel.org, zenghui.yu@linux.dev, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

This is a bit of an odd merge window on the KVM/arm64 front. There is
absolutely no new feature in the pull request. It is purely fixes,
because it is simply becoming too hard to review new stuff when so
many AI-fuelled fixes hit the list. And even then, I've arbitrarily
tagged the branch today, knowing that there is quite a backlog of
fixes that I will send very shortly, probably before -rc1.

So here it is: only fixes and very minor improvements, all over the
place. Details in the tag below.

Please pull,

	M.

The following changes since commit 5200f5f493f79f14bbdc349e402a40dfb32f23c8:

  Linux 7.1-rc4 (2026-05-17 13:59:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-7.2

for you to fetch changes up to 1ee27dacbe5dc4def481794d899d67b0d4570094:

  Merge branch kvm-arm64/nv-mmu-7.2 into kvmarm-master/next (2026-06-12 09:29:34 +0100)

----------------------------------------------------------------
KVM/arm64 updates for 7.2

* New features:

  - None. Zilch. Nada. Que dalle.

* Fixes and other improvements:

  - Significant cleanup of the vgic-v5 PPI support which was merged in
    7.1. This makes the code more maintainable, and squashes a couple
    of bugs in the meantime.

  - Set of fixes for the handling of the MMU in an NV context,
    particularly VNCR-triggered faults. S1POE support is fixed
    as well.

  - Large set of pKVM fixes, mostly addressing recurring issues
    around hypervisor tracking of donated pages in obscure cases
    where the donation could fail and leave things in a bizarre
    state.

  - Fixes for the so-called "lazy vgic init", which resulted in
    sleeping operations in non-preemptible sections. This turned
    out to be far more invasive than initially expected...

  - Reduce the overhead of L1/L2 context switch by not touching
    the FP registers.

  - Fix the way non-implemented page sizes are dealt with when
    a guest insist on using them for S2 translation.

  - The usual set of low-impact fixes and cleanups all over the map.

----------------------------------------------------------------
Fuad Tabba (5):
      KVM: arm64: Guard against NULL vcpu on VHE hyp panic path
      KVM: arm64: Fix __deactivate_fgt macro parameter typo
      KVM: arm64: Seed pkvm_ownership_selftest vcpu memcache
      KVM: arm64: Pre-check vcpu memcache for host->guest share
      KVM: arm64: Pre-check vcpu memcache for host->guest donate

Hyunwoo Kim (2):
      KVM: arm64: Clear __hyp_running_vcpu when flushing the pKVM hyp vCPU
      KVM: arm64: Bound used_lrs when flushing the pKVM hyp vCPU

Jackie Liu (1):
      KVM: arm64: vgic-its: Make ABI commit helpers return void

Marc Zyngier (29):
      KVM: arm64: nv: Track L2 to L1 exception emulation
      KVM: arm64: nv: Don't save/restore FP register during a nested ERET or exception
      KVM: arm64: timer: Repaint kvm_timer_{should,irq_can}_fire() to kvm_timer_{pending,enabled}()
      KVM: arm64: Simplify userspace notification of interrupt state
      KVM: arm64: timer: Kill the per-timer irq level cache
      KVM: arm64: pmu: Kill the PMU interrupt level cache
      KVM: arm64: vgic-v2: Force vgic init on injection outside the run loop
      KVM: arm64: vgic-v2: Don't init the vgic on in-kernel interrupt injection
      KVM: arm64: vgic-v5: Add for_each_visible_v5_ppi() iterator
      KVM: arm64: vgic-v5: Move PPI caps into kvm_vgic_global_state
      KVM: arm64: vgic-v5: Remove use of __assign_bit() with a constant
      KVM: arm64: vgic-v5: Drop pointless ARM64_HAS_GICV5_CPUIF check
      KVM: arm64: vgic: Constify struct irq_ops usage
      KVM: arm64: vgic: Consolidate vgic_allocate_private_irqs_locked()
      KVM: arm64: vgic-v5: Drop defensive checks from vgic_v5_ppi_queue_irq_unlock()
      KVM: arm64: vgic: Rationalise per-CPU irq accessor
      KVM: arm64: vgic-v5: Limit support to 64 PPIs
      KVM: arm64: Key CPTR_EL2.E0POE propagation on FEAT_S1POE
      KVM: arm64: Wire AT S1E1A in the system instruction handling table
      arm64: cpufeature: Expose ID_AA64ISAR2_EL1.ATS1A to KVM
      KVM: arm64: nv: Avoid dereferencing NULL VNCR pseudo-TLB
      KVM: arm64: nv: Hold kvm->mmu_lock while initialising vcpu->arch.vncr_tlb
      Merge branch kvm-arm64/no-lazy-vgic-init into kvmarm-master/next
      Merge branch kvm-arm64/nv-fp-elision into kvmarm-master/next
      Merge branch kvm-arm64/nv-granule-sizes into kvmarm-master/next
      Merge branch kvm-arm64/pkvm-fixes-7.2 into kvmarm-master/next
      Merge branch kvm-arm64/vgic-v5-PPI-fixes into kvmarm-master/next
      Merge branch kvm-arm64/misc-7.2 into kvmarm-master/next
      Merge branch kvm-arm64/nv-mmu-7.2 into kvmarm-master/next

Oliver Upton (5):
      KVM: arm64: Don't leak PFN when kvm_translate_vncr() races MMU notifier
      KVM: arm64: nv: Fully update VNCR fixmap state in kvm_translate_vncr()
      KVM: arm64: nv: Inject SEA TTW when desc update can't write to GPA
      KVM: arm64: Restart instruction upon race in __kvm_at_s12()
      KVM: arm64: nv: Restart stage-1 walk if stage-2 desc update fails

Sascha Bischoff (9):
      KVM: arm64: vgic-v5: Add missing trap handing for NV triage
      KVM: arm64: vgic-v5: Atomically assign bits to PPI DVI bitmap
      KVM: arm64: selftests: Add missing GIC CDEN to no-vgic-v5 selftest
      KVM: arm64: selftests: Cleanup unused vars in GICv5 PPI selftest
      KVM: arm64: selftests: Improve error handling for GICv5 PPI selftest
      Documentation: KVM: Fix typos in VGICv5 documentation
      Documentation: KVM: Clarify that PMU_V3_IRQ IntID requirements for GICv5
      irqchip/gic-v5: Immediately exec priority drop following activate
      KVM: arm64: Fix arch timer interrupts for GICv3-on-GICv5 guests

Vincent Donnefort (4):
      KVM: arm64: Reset page order in pKVM hyp_pool
      KVM: arm64: Fix __pkvm_init_vm error path
      KVM: arm64: Add fail-safe for refcounted pages in __pkvm_hyp_donate_host
      KVM: arm64: Set a Linux errno on SMCCC error in kvm_call_hyp_nvhe()

Wei-Lin Chang (5):
      KVM: arm64: nv: Rename vtcr_to_walk_info() to setup_s2_walk()
      KVM: arm64: Factor out TG0/1 decoding of VTCR and TCR
      KVM: arm64: nv: Use literal granule size in TLBI range calculation
      KVM: arm64: Fallback to a supported value for unsupported guest TGx
      KVM: arm64: Fix block mapping validity check in stage-1 walker

Will Deacon (1):
      KVM: arm64: Don't populate TPIDR_EL2 in finalise_el2()

Zenghui Yu (Huawei) (1):
      KVM: arm64: Remove @arch from __load_stage2()

tabba@google.com (4):
      KVM: arm64: Flush HCR_EL2.VSE to deliver SErrors to pKVM guests
      KVM: arm64: Free hyp-share tracking node when share hypercall fails
      KVM: arm64: Avoid host/hyp share desync on unshare hypercall failure
      KVM: arm64: Roll back partial shares on kvm_share_hyp() failure

 Documentation/virt/kvm/devices/arm-vgic-v5.rst |   6 +-
 Documentation/virt/kvm/devices/vcpu.rst        |   7 +-
 arch/arm64/include/asm/kvm_host.h              |   8 +-
 arch/arm64/include/asm/kvm_hyp.h               |   1 +
 arch/arm64/include/asm/kvm_mmu.h               |   3 +-
 arch/arm64/kernel/cpufeature.c                 |   1 +
 arch/arm64/kernel/hyp-stub.S                   |   4 +-
 arch/arm64/kvm/arch_timer.c                    | 137 +++++++--------
 arch/arm64/kvm/arm.c                           |  41 +++--
 arch/arm64/kvm/at.c                            | 146 +++++++++++----
 arch/arm64/kvm/emulate-nested.c                |  12 ++
 arch/arm64/kvm/fpsimd.c                        |  26 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h        |   2 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h  |   3 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c             |  21 ++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c          |  37 ++--
 arch/arm64/kvm/hyp/nvhe/page_alloc.c           |  21 ++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                 |   4 +-
 arch/arm64/kvm/hyp/nvhe/switch.c               |   2 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                  |   4 +-
 arch/arm64/kvm/hyp/vgic-v5-sr.c                |  82 ++-------
 arch/arm64/kvm/hyp/vhe/switch.c                |   2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                   |   4 +-
 arch/arm64/kvm/mmu.c                           |  39 ++++-
 arch/arm64/kvm/nested.c                        | 234 ++++++++++++++++---------
 arch/arm64/kvm/pmu-emul.c                      |  31 +---
 arch/arm64/kvm/sys_regs.c                      |  20 +--
 arch/arm64/kvm/vgic/vgic-init.c                |  45 ++---
 arch/arm64/kvm/vgic/vgic-irqfd.c               |   6 +
 arch/arm64/kvm/vgic/vgic-its.c                 |  21 +--
 arch/arm64/kvm/vgic/vgic-kvm-device.c          |   9 +-
 arch/arm64/kvm/vgic/vgic-v5.c                  |  51 ++----
 arch/arm64/kvm/vgic/vgic.c                     |  33 ++--
 arch/arm64/kvm/vgic/vgic.h                     |   3 +
 drivers/irqchip/irq-gic-v5.c                   |  13 +-
 include/kvm/arm_arch_timer.h                   |   7 +-
 include/kvm/arm_pmu.h                          |   5 +-
 include/kvm/arm_vgic.h                         |  19 +-
 tools/testing/selftests/kvm/arm64/no-vgic.c    |   1 +
 tools/testing/selftests/kvm/arm64/vgic_v5.c    |  10 +-
 40 files changed, 651 insertions(+), 470 deletions(-)
