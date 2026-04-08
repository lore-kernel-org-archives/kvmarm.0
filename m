Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30812F5487;
	Wed,  8 Apr 2026 15:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775663734; cv=none; b=cgBT02WAn8UvJ1GFkHzerfw2nAQu1izHUe2E+CqeefqN7BFzWAW1eM078PrkiGEjaYJLOzP1wsCIToaGrblObrMP1V6CBR/s0vdI5NABhJ0jlsOdRrzHUXJfEthvoWf12lormeIiLT+T7agIZtj4QUeUzhONjkeY5RzpN5+O2+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775663734; c=relaxed/simple;
	bh=Kp3w3o5nxgWi4NC+Tw2hZegA80ySf51A5OA4FzvWIqw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O4ATs7bC7q6r+8VqxMYm9Quv5z7tdeck17/yan9vPhTO7qK4bMsLO048FsWjUvmIQx4pE/wJMsSOUIMVL6l32Hfk7pYvjThws15ta58BqyrkCjrdPXeM48q479JUJt/KB/dy0clQwFemXxINHttKkPZwSxf1v3CmB95zDm5Bq/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LoseWjJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LoseWjJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56793C19421;
	Wed,  8 Apr 2026 15:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775663733;
	bh=Kp3w3o5nxgWi4NC+Tw2hZegA80ySf51A5OA4FzvWIqw=;
	h=From:To:Cc:Subject:Date:From;
	b=LoseWjJ69m5EyrO5MhbJght93gFPqR5QcBUo/7J4aaRiJ4kKMmuRoy8VKMBv4LA1G
	 WrmF2s1kZUgySdHBqMQzjcFNksQ5tyEXdBe2jFPjl4F3/u0l+PF8/CTSXf/VaK414K
	 iy5eBqBNTm0tLLptblZnxYz6MCCiyaeWCjYOcQW2k7BDhhnlrboIkGjoADgWS6YVdv
	 NYZhBWKwRrJngW1I59mwzTzlBkzeKFwBOuM8iJmUmLbwrkKZuR85D7REH1phnEOdBi
	 n3X5IObBvwQYTBDQhgyOJfuovLlgjaIJPh2MU8q/GSBGIgQ5jSRS31qNzFIGHureZi
	 EcVBf0ovB9Vdw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wAVFa-00000009xvc-2WC2;
	Wed, 08 Apr 2026 15:55:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	James Clark <james.clark@linaro.org>,
	Joey Gouly <joey.gouly@arm.com>,
	John Stultz <jstultz@google.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Leo Yan <leo.yan@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 updates for 7.1
Date: Wed,  8 Apr 2026 16:55:09 +0100
Message-ID: <20260408155509.548103-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, arnd@arndb.de, catalin.marinas@arm.com, tabba@google.com, james.clark@linaro.org, joey.gouly@arm.com, jstultz@google.com, jonathan.cameron@huawei.com, kaleshsingh@google.com, leo.yan@arm.com, broonie@kernel.org, smostafa@google.com, nathan@kernel.org, oupton@kernel.org, qperret@google.com, sascha.bischoff@arm.com, sebastianene@google.com, rostedt@goodmis.org, suzuki.poulose@arm.com, vdonnefort@google.com, weilin.chang@arm.com, will@kernel.org, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

7.1 should be a pretty large milestone for KVM/arm64. Of note, we have:

- the hypervisor tracing infrastructure, which is pretty large on its
  own, but also comes with an equally large set of tracing specific
  patches (we share a branch with the tracing tree).

- the first set of patches for native GICv5 support, limited to PPIs
  for the time being. I expect this to take a few kernel revisions
  to reach the feature-complete state.

- some movement on the pKVM front, in the form of protected guest and
  protected memory support.

The rest is a large set of fixes, cleanups and rework in order to make
some of the most hairy code more maintainable (user_mem_abort() being
the most significant example).

Please pull,

        M.

The following changes since commit f338e77383789c0cae23ca3d48adcc5e9e137e3c:

  Linux 7.0-rc4 (2026-03-15 13:52:05 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-7.1

for you to fetch changes up to 94b4ae79ebb42a8a6f2124b4d4b033b15a98e4f9:

  Merge branch kvm-arm64/misc-7.1 into kvmarm-master/next (2026-04-08 12:26:11 +0100)

----------------------------------------------------------------
KVM/arm64 updates for 7.1

* New features:

- Add support for tracing in the standalone EL2 hypervisor code,
  which should help both debugging and performance analysis.
  This comes with a full infrastructure for 'remote' trace buffers
  that can be exposed by non-kernel entities such as firmware.

- Add support for GICv5 Per Processor Interrupts (PPIs), as the
  starting point for supporting the new GIC architecture in KVM.

- Finally add support for pKVM protected guests, with anonymous
  memory being used as a backing store. About time!

* Improvements and bug fixes:

- Rework the dreaded user_mem_abort() function to make it more
  maintainable, reducing the amount of state being exposed to
  the various helpers and rendering a substantial amount of
  state immutable.

- Expand the Stage-2 page table dumper to support NV shadow
  page tables on a per-VM basis.

- Tidy up the pKVM PSCI proxy code to be slightly less hard
  to follow.

- Fix both SPE and TRBE in non-VHE configurations so that they
  do not generate spurious, out of context table walks that
  ultimately lead to very bad HW lockups.

- A small set of patches fixing the Stage-2 MMU freeing in error
  cases.

- Tighten-up accepted SMC immediate value to be only #0 for host
  SMCCC calls.

- The usual cleanups and other selftest churn.

----------------------------------------------------------------
Arnd Bergmann (3):
      tracing: add more symbols to whitelist
      KVM: arm64: tracing: add ftrace dependency
      KVM: arm64: avoid unused-variable warning

Fuad Tabba (14):
      KVM: arm64: Extract VMA size resolution in user_mem_abort()
      KVM: arm64: Introduce struct kvm_s2_fault to user_mem_abort()
      KVM: arm64: Extract PFN resolution in user_mem_abort()
      KVM: arm64: Isolate mmap_read_lock inside new kvm_s2_fault_get_vma_info() helper
      KVM: arm64: Extract stage-2 permission logic in user_mem_abort()
      KVM: arm64: Extract page table mapping in user_mem_abort()
      KVM: arm64: Simplify nested VMA shift calculation
      KVM: arm64: Remove redundant state variables from struct kvm_s2_fault
      KVM: arm64: Simplify return logic in user_mem_abort()
      KVM: arm64: Initialize struct kvm_s2_fault completely at declaration
      KVM: arm64: Optimize early exit checks in kvm_s2_fault_pin_pfn()
      KVM: arm64: Hoist MTE validation check out of MMU lock path
      KVM: arm64: Clean up control flow in kvm_s2_fault_map()
      KVM: arm64: Expose self-hosted debug regs as RAZ/WI for protected guests

Marc Zyngier (49):
      tracing: Restore accidentally removed SPDX tag
      KVM: arm64: pkvm: Move error handling to the end of kvm_hyp_cpu_entry
      KVM: arm64: pkvm: Simplify BTI handling on CPU boot
      KVM: arm64: pkvm: Turn __kvm_hyp_init_cpu into an inner label
      KVM: arm64: pkvm: Use direct function pointers for cpu_{on,resume}
      KVM: arm64: Remove extra ISBs when using msr_hcr_el2
      KVM: arm64: Kill fault->ipa
      KVM: arm64: Make fault_ipa immutable
      KVM: arm64: Move fault context to const structure
      KVM: arm64: Replace fault_is_perm with a helper
      KVM: arm64: Constrain fault_granule to kvm_s2_fault_map()
      KVM: arm64: Kill write_fault from kvm_s2_fault
      KVM: arm64: Kill exec_fault from kvm_s2_fault
      KVM: arm64: Kill topup_memcache from kvm_s2_fault
      KVM: arm64: Move VMA-related information to kvm_s2_fault_vma_info
      KVM: arm64: Kill logging_active from kvm_s2_fault
      KVM: arm64: Restrict the scope of the 'writable' attribute
      KVM: arm64: Move kvm_s2_fault.{pfn,page} to kvm_s2_vma_info
      KVM: arm64: Replace force_pte with a max_map_size attribute
      KVM: arm64: Move device mapping management into kvm_s2_fault_pin_pfn()
      KVM: arm64: Directly expose mapping prot and kill kvm_s2_fault
      KVM: arm64: Simplify integration of adjust_nested_*_perms()
      KVM: arm64: Convert gmem_abort() to struct kvm_s2_fault_desc
      KVM: arm64: vgic: Don't reset cpuif/redist addresses at finalize time
      KVM: arm64: Don't skip per-vcpu NV initialisation
      arm64: Fix field references for ICH_PPI_DVIR[01]_EL2
      KVM: arm64: Fix writeable mask for ID_AA64PFR2_EL1
      KVM: arm64: Account for RESx bits in __compute_fgt()
      KVM: arm64: vgic-v5: Hold config_lock while finalizing GICv5 PPIs
      KVM: arm64: vgic-v5: Transfer edge pending state to ICH_PPI_PENDRx_EL2
      KVM: arm64: vgic-v5: Cast vgic_apr to u32 to avoid undefined behaviours
      KVM: arm64: vgic-v5: Make the effective priority mask a strict limit
      KVM: arm64: vgic-v5: Correctly set dist->ready once initialised
      KVM: arm64: Kill arch_timer_context::direct field
      KVM: arm64: Remove evaluation of timer state in kvm_cpu_has_pending_timer()
      KVM: arm64: Move GICv5 timer PPI validation into timer_irqs_are_valid()
      KVM: arm64: Correctly plumb ID_AA64PFR2_EL1 into pkvm idreg handling
      KVM: arm64: Don't advertises GICv3 in ID_PFR1_EL1 if AArch32 isn't supported
      KVM: arm64: set_id_regs: Allow GICv3 support to be set at runtime
      KVM: arm64: Advertise ID_AA64PFR2_EL1.GCIE
      Merge branch kvm-arm64/hyp-tracing into kvmarm-master/next
      Merge branch kvm-arm64/vgic-v5-ppi into kvmarm-master/next
      Merge branch kvm-arm64/nv-s2-debugfs into kvmarm-master/next
      Merge branch kvm-arm64/pkvm-psci into kvmarm-master/next
      Merge branch kvm-arm64/user_mem_abort-rework into kvmarm-master/next
      Merge branch kvm-arm64/spe-trbe-nvhe into kvmarm-master/next
      Merge branch kvm-arm64/pkvm-protected-guest into kvmarm-master/next
      Merge branch kvm-arm64/vgic-fixes-7.1 into kvmarm-master/next
      Merge branch kvm-arm64/misc-7.1 into kvmarm-master/next

Nathan Chancellor (1):
      tracing: Adjust cmd_check_undefined to show unexpected undefined symbols

Quentin Perret (1):
      KVM: arm64: Inject SIGSEGV on illegal accesses

Sascha Bischoff (41):
      KVM: arm64: vgic-v3: Drop userspace write sanitization for ID_AA64PFR0.GIC on GICv5
      KVM: arm64: vgic: Rework vgic_is_v3() and add vgic_host_has_gicvX()
      KVM: arm64: Return early from kvm_finalize_sys_regs() if guest has run
      KVM: arm64: vgic: Split out mapping IRQs and setting irq_ops
      arm64/sysreg: Add remaining GICv5 ICC_ & ICH_ sysregs for KVM support
      arm64/sysreg: Add GICR CDNMIA encoding
      KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to KVM headers
      KVM: arm64: gic: Introduce interrupt type helpers
      KVM: arm64: gic-v5: Add Arm copyright header
      KVM: arm64: gic-v5: Detect implemented PPIs on boot
      KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE
      KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
      KVM: arm64: gic-v5: Add emulation for ICC_IAFFIDR_EL1 accesses
      KVM: arm64: gic-v5: Trap and emulate ICC_IDR0_EL1 accesses
      KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp interface
      KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore
      KVM: arm64: gic-v5: Finalize GICv5 PPIs and generate mask
      KVM: arm64: gic: Introduce queue_irq_unlock to irq_ops
      KVM: arm64: gic-v5: Implement PPI interrupt injection
      KVM: arm64: gic-v5: Init Private IRQs (PPIs) for GICv5
      KVM: arm64: gic-v5: Clear TWI if single task running
      KVM: arm64: gic-v5: Check for pending PPIs
      KVM: arm64: gic-v5: Trap and mask guest ICC_PPI_ENABLERx_EL1 writes
      KVM: arm64: Introduce set_direct_injection irq_op
      KVM: arm64: gic-v5: Implement direct injection of PPIs
      KVM: arm64: gic-v5: Support GICv5 interrupts with KVM_IRQ_LINE
      KVM: arm64: gic-v5: Create and initialise vgic_v5
      KVM: arm64: gic-v5: Initialise ID and priority bits when resetting vcpu
      irqchip/gic-v5: Introduce minimal irq_set_type() for PPIs
      KVM: arm64: gic-v5: Enlighten arch timer for GICv5
      KVM: arm64: gic-v5: Mandate architected PPI for PMU emulation on GICv5
      KVM: arm64: gic: Hide GICv5 for protected guests
      KVM: arm64: gic-v5: Hide FEAT_GCIE from NV GICv5 guests
      KVM: arm64: gic-v5: Introduce kvm_arm_vgic_v5_ops and register them
      KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on boot
      KVM: arm64: gic-v5: Probe for GICv5 device
      Documentation: KVM: Introduce documentation for VGICv5
      KVM: arm64: gic-v5: Communicate userspace-driveable PPIs via a UAPI
      KVM: arm64: selftests: Introduce a minimal GICv5 PPI selftest
      KVM: arm64: selftests: Add no-vgic-v5 selftest
      KVM: arm64: vgic-v5: Fold PPI state for all exposed PPIs

Sebastian Ene (1):
      KVM: arm64: Prevent the host from using an smc with imm16 != 0

Vincent Donnefort (35):
      ring-buffer: Add page statistics to the meta-page
      ring-buffer: Store bpage pointers into subbuf_ids
      ring-buffer: Introduce ring-buffer remotes
      ring-buffer: Add non-consuming read for ring-buffer remotes
      tracing: Introduce trace remotes
      tracing: Add reset to trace remotes
      tracing: Add non-consuming read to trace remotes
      tracing: Add init callback to trace remotes
      tracing: Add events to trace remotes
      tracing: Add events/ root files to trace remotes
      tracing: Add helpers to create trace remote events
      ring-buffer: Export buffer_data_page and macros
      tracing: Introduce simple_ring_buffer
      tracing: Add a trace remote module for testing
      tracing: selftests: Add trace remote tests
      Documentation: tracing: Add tracing remotes
      tracing: load/unload page callbacks for simple_ring_buffer
      tracing: Check for undefined symbols in simple_ring_buffer
      KVM: arm64: Add PKVM_DISABLE_STAGE2_ON_PANIC
      KVM: arm64: Add clock support to nVHE/pKVM hyp
      KVM: arm64: Initialise hyp_nr_cpus for nVHE hyp
      KVM: arm64: Support unaligned fixmap in the pKVM hyp
      KVM: arm64: Add tracing capability for the nVHE/pKVM hyp
      KVM: arm64: Add trace remote for the nVHE/pKVM hyp
      KVM: arm64: Sync boot clock with the nVHE/pKVM hyp
      KVM: arm64: Add trace reset to the nVHE/pKVM hyp
      KVM: arm64: Add event support to the nVHE/pKVM hyp and trace remote
      KVM: arm64: Add hyp_enter/hyp_exit events to nVHE/pKVM hyp
      KVM: arm64: Add selftest event support to nVHE/pKVM hyp
      tracing: selftests: Add hypervisor trace remote tests
      KVM: arm64: Fix out-of-tree build for nVHE/pKVM tracing
      tracing: Update undefined symbols allow list for simple_ring_buffer
      tracing: Generate undef symbols allowlist for simple_ring_buffer
      tracing: Non-consuming read for trace remotes with an offline CPU
      tracing: selftests: Extend hotplug testing for trace remotes

Wei-Lin Chang (2):
      KVM: arm64: ptdump: Make KVM ptdump code s2 mmu aware
      KVM: arm64: nv: Expose shadow page tables in debugfs

Will Deacon (44):
      KVM: arm64: Disable TRBE Trace Buffer Unit when running in guest context
      KVM: arm64: Disable SPE Profiling Buffer when running in guest context
      KVM: arm64: Don't pass host_debug_state to BRBE world-switch routines
      KVM: arm64: Remove unused PKVM_ID_FFA definition
      KVM: arm64: Don't leak stage-2 page-table if VM fails to init under pKVM
      KVM: arm64: Move handle check into pkvm_pgtable_stage2_destroy_range()
      KVM: arm64: Rename __pkvm_pgtable_stage2_unmap()
      KVM: arm64: Don't advertise unsupported features for protected guests
      KVM: arm64: Remove is_protected_kvm_enabled() checks from hypercalls
      KVM: arm64: Ignore MMU notifier callbacks for protected VMs
      KVM: arm64: Prevent unsupported memslot operations on protected VMs
      KVM: arm64: Ignore -EAGAIN when mapping in pages for the pKVM host
      KVM: arm64: Split teardown hypercall into two phases
      KVM: arm64: Introduce __pkvm_host_donate_guest()
      KVM: arm64: Hook up donation hypercall to pkvm_pgtable_stage2_map()
      KVM: arm64: Handle aborts from protected VMs
      KVM: arm64: Introduce __pkvm_reclaim_dying_guest_page()
      KVM: arm64: Hook up reclaim hypercall to pkvm_pgtable_stage2_destroy()
      KVM: arm64: Factor out pKVM host exception injection logic
      KVM: arm64: Support translation faults in inject_host_exception()
      KVM: arm64: Avoid pointless annotation when mapping host-owned pages
      KVM: arm64: Generalise kvm_pgtable_stage2_set_owner()
      KVM: arm64: Introduce host_stage2_set_owner_metadata_locked()
      KVM: arm64: Change 'pkvm_handle_t' to u16
      KVM: arm64: Annotate guest donations with handle and gfn in host stage-2
      KVM: arm64: Introduce hypercall to force reclaim of a protected page
      KVM: arm64: Reclaim faulting page from pKVM in spurious fault handler
      KVM: arm64: Return -EFAULT from VCPU_RUN on access to a poisoned pte
      KVM: arm64: Add hvc handler at EL2 for hypercalls from protected VMs
      KVM: arm64: Implement the MEM_SHARE hypercall for protected VMs
      KVM: arm64: Implement the MEM_UNSHARE hypercall for protected VMs
      KVM: arm64: Allow userspace to create protected VMs when pKVM is enabled
      KVM: arm64: Add some initial documentation for pKVM
      KVM: arm64: Extend pKVM page ownership selftests to cover guest donation
      KVM: arm64: Register 'selftest_vm' in the VM table
      KVM: arm64: Extend pKVM page ownership selftests to cover forced reclaim
      KVM: arm64: Extend pKVM page ownership selftests to cover guest hvcs
      KVM: arm64: Rename PKVM_PAGE_STATE_MASK
      drivers/virt: pkvm: Add Kconfig dependency on DMA_RESTRICTED_POOL
      KVM: arm64: Prevent teardown finalisation of referenced 'hyp_vm'
      KVM: arm64: Allow get_pkvm_hyp_vm() to take a reference to a dying VM
      KVM: arm64: Don't hold 'vm_table_lock' across guest page reclaim
      KVM: arm64: Don't leave mmu->pgt dangling on kvm_init_stage2_mmu() error
      KVM: arm64: Destroy stage-2 page-table in kvm_arch_destroy_vm()

Zenghui Yu (Huawei) (2):
      KVM: arm64: ptdump: Initialize parser_state before pgtable walk
      KVM: arm64: selftests: Avoid testing the IMPDEF behavior

 Documentation/admin-guide/kernel-parameters.txt    |    4 +-
 Documentation/trace/index.rst                      |   11 +
 Documentation/trace/remotes.rst                    |   66 +
 Documentation/virt/kvm/api.rst                     |    6 +-
 Documentation/virt/kvm/arm/index.rst               |    1 +
 Documentation/virt/kvm/arm/pkvm.rst                |  106 ++
 Documentation/virt/kvm/devices/arm-vgic-v5.rst     |   50 +
 Documentation/virt/kvm/devices/index.rst           |    1 +
 Documentation/virt/kvm/devices/vcpu.rst            |    5 +-
 arch/arm64/include/asm/el2_setup.h                 |    4 +-
 arch/arm64/include/asm/kvm_asm.h                   |   44 +-
 arch/arm64/include/asm/kvm_define_hypevents.h      |   16 +
 arch/arm64/include/asm/kvm_host.h                  |   50 +-
 arch/arm64/include/asm/kvm_hyp.h                   |   14 +-
 arch/arm64/include/asm/kvm_hypevents.h             |   60 +
 arch/arm64/include/asm/kvm_hyptrace.h              |   26 +
 arch/arm64/include/asm/kvm_mmu.h                   |    4 +
 arch/arm64/include/asm/kvm_pgtable.h               |   45 +-
 arch/arm64/include/asm/kvm_pkvm.h                  |    4 +-
 arch/arm64/include/asm/sysreg.h                    |   13 +-
 arch/arm64/include/asm/virt.h                      |    9 +
 arch/arm64/include/asm/vncr_mapping.h              |    3 +
 arch/arm64/include/uapi/asm/kvm.h                  |    1 +
 arch/arm64/kernel/cpufeature.c                     |    1 +
 arch/arm64/kernel/hyp-stub.S                       |    1 -
 arch/arm64/kernel/image-vars.h                     |    4 +
 arch/arm64/kernel/vmlinux.lds.S                    |   18 +
 arch/arm64/kvm/Kconfig                             |   64 +-
 arch/arm64/kvm/Makefile                            |    2 +
 arch/arm64/kvm/arch_timer.c                        |  102 +-
 arch/arm64/kvm/arm.c                               |   69 +-
 arch/arm64/kvm/config.c                            |  127 +-
 arch/arm64/kvm/emulate-nested.c                    |   68 +
 arch/arm64/kvm/handle_exit.c                       |    2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |   27 +
 arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h        |   23 +
 arch/arm64/kvm/hyp/include/nvhe/clock.h            |   16 +
 arch/arm64/kvm/hyp/include/nvhe/define_events.h    |   14 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h      |   12 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h           |   12 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h             |    7 +-
 arch/arm64/kvm/hyp/include/nvhe/trace.h            |   70 +
 arch/arm64/kvm/hyp/include/nvhe/trap_handler.h     |    2 +
 arch/arm64/kvm/hyp/nvhe/Makefile                   |    8 +-
 arch/arm64/kvm/hyp/nvhe/clock.c                    |   65 +
 arch/arm64/kvm/hyp/nvhe/debug-sr.c                 |  116 +-
 arch/arm64/kvm/hyp/nvhe/events.c                   |   25 +
 arch/arm64/kvm/hyp/nvhe/ffa.c                      |   28 +-
 arch/arm64/kvm/hyp/nvhe/host.S                     |   13 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S                 |   41 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  294 +++--
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S                  |    6 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |  587 ++++++++-
 arch/arm64/kvm/hyp/nvhe/mm.c                       |    4 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  239 +++-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c               |   45 +-
 arch/arm64/kvm/hyp/nvhe/setup.c                    |    4 +-
 arch/arm64/kvm/hyp/nvhe/stacktrace.c               |    6 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |   23 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |   18 +-
 arch/arm64/kvm/hyp/nvhe/trace.c                    |  306 +++++
 arch/arm64/kvm/hyp/pgtable.c                       |   33 +-
 arch/arm64/kvm/hyp/vgic-v5-sr.c                    |  166 +++
 arch/arm64/kvm/hyp/vhe/Makefile                    |    2 +-
 arch/arm64/kvm/hyp_trace.c                         |  442 +++++++
 arch/arm64/kvm/hyp_trace.h                         |   11 +
 arch/arm64/kvm/mmu.c                               |  624 +++++----
 arch/arm64/kvm/nested.c                            |   11 +-
 arch/arm64/kvm/pkvm.c                              |  159 ++-
 arch/arm64/kvm/pmu-emul.c                          |   20 +-
 arch/arm64/kvm/ptdump.c                            |   79 +-
 arch/arm64/kvm/stacktrace.c                        |    8 +-
 arch/arm64/kvm/sys_regs.c                          |  188 ++-
 arch/arm64/kvm/vgic/vgic-init.c                    |  228 +++-
 arch/arm64/kvm/vgic/vgic-kvm-device.c              |  107 +-
 arch/arm64/kvm/vgic/vgic-mmio.c                    |   40 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |    2 +-
 arch/arm64/kvm/vgic/vgic-v5.c                      |  499 ++++++-
 arch/arm64/kvm/vgic/vgic.c                         |  173 ++-
 arch/arm64/kvm/vgic/vgic.h                         |   53 +-
 arch/arm64/mm/fault.c                              |   33 +-
 arch/arm64/tools/sysreg                            |  480 +++++++
 drivers/irqchip/irq-gic-v5.c                       |   18 +
 drivers/virt/coco/pkvm-guest/Kconfig               |    2 +-
 fs/tracefs/inode.c                                 |    1 +
 include/kvm/arm_arch_timer.h                       |    8 +-
 include/kvm/arm_pmu.h                              |    5 +-
 include/kvm/arm_vgic.h                             |  191 ++-
 include/linux/irqchip/arm-gic-v5.h                 |   27 +
 include/linux/kvm_host.h                           |    1 +
 include/linux/ring_buffer.h                        |   58 +
 include/linux/ring_buffer_types.h                  |   41 +
 include/linux/simple_ring_buffer.h                 |   65 +
 include/linux/trace_remote.h                       |   48 +
 include/linux/trace_remote_event.h                 |   33 +
 include/trace/define_remote_events.h               |   73 ++
 include/uapi/linux/kvm.h                           |    7 +
 include/uapi/linux/trace_mmap.h                    |    8 +-
 kernel/trace/Kconfig                               |   14 +
 kernel/trace/Makefile                              |   59 +
 kernel/trace/remote_test.c                         |  261 ++++
 kernel/trace/remote_test_events.h                  |   10 +
 kernel/trace/ring_buffer.c                         |  354 ++++-
 kernel/trace/simple_ring_buffer.c                  |  517 ++++++++
 kernel/trace/trace.c                               |    4 +-
 kernel/trace/trace.h                               |    7 +
 kernel/trace/trace_remote.c                        | 1384 ++++++++++++++++++++
 tools/arch/arm64/include/uapi/asm/kvm.h            |    1 +
 tools/include/uapi/linux/kvm.h                     |    2 +
 .../selftests/ftrace/test.d/remotes/buffer_size.tc |   25 +
 .../selftests/ftrace/test.d/remotes/functions      |   99 ++
 .../selftests/ftrace/test.d/remotes/hotplug.tc     |   88 ++
 .../test.d/remotes/hypervisor/buffer_size.tc       |   11 +
 .../ftrace/test.d/remotes/hypervisor/hotplug.tc    |   11 +
 .../ftrace/test.d/remotes/hypervisor/reset.tc      |   11 +
 .../ftrace/test.d/remotes/hypervisor/trace.tc      |   11 +
 .../ftrace/test.d/remotes/hypervisor/trace_pipe.tc |   11 +
 .../ftrace/test.d/remotes/hypervisor/unloading.tc  |   11 +
 .../selftests/ftrace/test.d/remotes/reset.tc       |   90 ++
 .../selftests/ftrace/test.d/remotes/trace.tc       |  102 ++
 .../selftests/ftrace/test.d/remotes/trace_pipe.tc  |  102 ++
 .../selftests/ftrace/test.d/remotes/unloading.tc   |   41 +
 tools/testing/selftests/kvm/Makefile.kvm           |    3 +-
 tools/testing/selftests/kvm/arm64/at.c             |   14 +-
 tools/testing/selftests/kvm/arm64/no-vgic-v3.c     |  177 ---
 tools/testing/selftests/kvm/arm64/no-vgic.c        |  297 +++++
 tools/testing/selftests/kvm/arm64/set_id_regs.c    |   52 +-
 tools/testing/selftests/kvm/arm64/vgic_v5.c        |  228 ++++
 tools/testing/selftests/kvm/include/arm64/gic_v5.h |  150 +++
 129 files changed, 10017 insertions(+), 1086 deletions(-)
 create mode 100644 Documentation/trace/remotes.rst
 create mode 100644 Documentation/virt/kvm/arm/pkvm.rst
 create mode 100644 Documentation/virt/kvm/devices/arm-vgic-v5.rst
 create mode 100644 arch/arm64/include/asm/kvm_define_hypevents.h
 create mode 100644 arch/arm64/include/asm/kvm_hypevents.h
 create mode 100644 arch/arm64/include/asm/kvm_hyptrace.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/clock.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/define_events.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/trace.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/clock.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/events.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/trace.c
 create mode 100644 arch/arm64/kvm/hyp/vgic-v5-sr.c
 create mode 100644 arch/arm64/kvm/hyp_trace.c
 create mode 100644 arch/arm64/kvm/hyp_trace.h
 create mode 100644 include/linux/ring_buffer_types.h
 create mode 100644 include/linux/simple_ring_buffer.h
 create mode 100644 include/linux/trace_remote.h
 create mode 100644 include/linux/trace_remote_event.h
 create mode 100644 include/trace/define_remote_events.h
 create mode 100644 kernel/trace/remote_test.c
 create mode 100644 kernel/trace/remote_test_events.h
 create mode 100644 kernel/trace/simple_ring_buffer.c
 create mode 100644 kernel/trace/trace_remote.c
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/buffer_size.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/functions
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/hotplug.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/hypervisor/buffer_size.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/hypervisor/hotplug.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/hypervisor/reset.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/hypervisor/trace.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/hypervisor/trace_pipe.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/hypervisor/unloading.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/reset.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/trace.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/trace_pipe.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/unloading.tc
 delete mode 100644 tools/testing/selftests/kvm/arm64/no-vgic-v3.c
 create mode 100644 tools/testing/selftests/kvm/arm64/no-vgic.c
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_v5.c
 create mode 100644 tools/testing/selftests/kvm/include/arm64/gic_v5.h
