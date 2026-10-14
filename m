Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDE353D0C7;
	Wed, 14 Oct 2026 16:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791994898; cv=none; b=Tu084CRT13a/3KOEhYNbJcYIVPECWgT+xRefA03qRjvHhhorIkS17rPqIeap5a5N0B9QMTCFBhp1PmEieiinuPR5koXscNV2TlnG5ADuO02CZL2j/C7+HNH5G40PtwpVReilwaxapagMXsXvoZU8GhlY0GtKsAvlcWOUgPG7AeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791994898; c=relaxed/simple;
	bh=WCTqIIj3HTvyLhnJaNWftXMntJhicSnAgh1JSraZ47k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YWz50fC5ZeVZKbRwIfCWgDHj9K6+F5WWT9ifM0BdOr4xbmxgZthY8ED9GTV+HLx86SPNAeZqJq/Cl1gTIx8h4g3VCPtowOon+cDIqNNbHQSBHCWMVVNk5Cy1TlI0PynOa1KTfRNahsVVbYQHQTE4HCwLO/EO4Y6VK65SCTKpTS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vk+ylb2h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vk+ylb2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF88F1F000C4;
	Wed, 14 Oct 2026 16:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791994894;
	bh=+C/kqJGc5WkyRdJdLyLDTw+mr9QEPFZMGl3SqlU8rh0=;
	h=From:To:Cc:Subject:Date;
	b=Vk+ylb2hNRcKxB1lSYBnwhf4O2qQipYDW5bFEtIdRlKdPRZHj1P7rfuQvBlXAAtYD
	 Nv0NbaUKAIKZC5y4HVmAFztbBufzBK4Zgm/EMycARhRCq2Ecwjxoonmil3lxgHnaNi
	 pZ3BwTYaqgyhKQCxbRnpUby9e7AtDfZhmcwgarAMK+0fKzbc5GaBhFkgorM6hKMckC
	 096Tv/rRsk1503Q29Eq7KPuIW+IxAjAumlj0AR+Y7tWboRAk7a7HTi13r4NGXyKd5Q
	 E7o+M83XCk6NTL0o3xMq8KVz31AngxPvsaH3tySSbhtwNhv0HcfStY+rt3IVjrRQgq
	 F8LTD2YTF3FQA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xH1jP-00000002wt7-0tln;
	Wed, 14 Oct 2026 16:21:31 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Amit Machhiwal <amachhiw@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Colton Lewis <coltonlewis@google.com>,
	Eric Auger <eauger@redhat.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Gautam Menghani <gautam@linux.ibm.com>,
	Gavin Shan <gshan@redhat.com>,
	Gokul K <gokul02k@gmail.com>,
	Hemanth Selam <hemanth.selam@gmail.com>,
	Hiroyuki Katsura <hk590@cam.ac.uk>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Jack Thomson <jackabt@amazon.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Jonathan Davies <jonathan.davies@nutanix.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Like Xu <likexu@tencent.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Sebastian Ott <sebott@redhat.com>,
	Shen Yongchao <grayhat@foxmail.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Stefan Teodorescu <fane@google.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Steven Price <steven.price@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tharit Tangkijwanichakul <tharitt97@gmail.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wang Han <wanghan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Will Deacon <will@kernel.org>,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 updates for Linux 7.4
Date: Wed, 14 Oct 2026 17:21:26 +0100
Message-ID: <20261014162126.964330-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, amachhiw@linux.ibm.com, catalin.marinas@arm.com, coltonlewis@google.com, eauger@redhat.com, fuad.tabba@linux.dev, gautam@linux.ibm.com, gshan@redhat.com, gokul02k@gmail.com, hemanth.selam@gmail.com, hk590@cam.ac.uk, itaru.kitayama@fujitsu.com, jackabt@amazon.com, jiaqiyan@google.com, joey.gouly@arm.com, jonathan.cameron@oss.qualcomm.com, jonathan.davies@nutanix.com, kmehltretter@gmail.com, leo.bras@arm.com, likexu@tencent.com, ljs@kernel.org, broonie@kernel.org, nsg@linux.ibm.com, oupton@kernel.org, rdunlap@infradead.org, sascha.bischoff@arm.com, seanjc@google.com, sebastianene@google.com, sebott@redhat.com, grayhat@foxmail.com, xueshuai@linux.alibaba.com, fane@google.com, seiden@linux.ibm.com, steven.price@arm.com, rostedt@goodmis.org, suzuki.poulose@arm.com, tharitt97@gmail.com, vdonnefort@google.com, wanghan@linux.alibaba.com, weilin.chang@arm.com, will@kernel.org, yaoyuan@linux.alibaba.com, zenghui.yu@linux.dev, yuzenghui@huawei.com, kvmarm
 @lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's the set of KVM/arm64 updates for 7.4. After a couple of
releases mostly focused on mopping the AI wave, we're back to merging
new code, and there is a lot of it. Given the size and the conflicts
that this generates (see below), I've decided to send the pull request
early.

Details are as usual in the tag below, but there is a few things to
call out:

- a lot of pKVM updates, finally delivering on the isolation promises,
  thanks to Fuad's work on upstreaming this stuff.

- the first stab at sharing code with s390... More fun to come, but
  that's a start

- More GICv5 code. As always with the GIC, it is huge... But for once,
  the code is much simpler than the previous iterations, and also
  comes with a bunch of selftests from the beginning.

As a consequence, the diffstat is a gold-plated pig.

Things to note:

- this drags the kvmarm-fixes-7.3-1 tag as a way to resolve bad
  conflicts with some of the patches

- there is some additional conflicts with 7.3-rc6, due to
  kvmarm-fixes-7.3-2 landing a bit late. I have stashed a resolution
  here [1], which you can either apply if you're basing the merge on
  -rc6, or mention to Linus as you send your own PR. For everybody to
  enjoy, I also add the resolution at the end of this email.

Please pull,

	M.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/log/?h=next-7.4%2bfixes-7.3-2


The following changes since commit fd73f4a6659897191fa0d40695fe370925dd3780:

  Linux 7.3-rc3 (2026-09-13 14:38:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvmarm-7.4

for you to fetch changes up to dd0bc00e3e9201fd49b62ff9cc07890c89003afe:

  Merge branch kvm-arm64/cca-7.4 into kvmarm-master/next (2026-10-11 11:03:27 +0100)

----------------------------------------------------------------
KVM/arm64 updates for 7.4

* New features

  - pKVM state isolation: years after pKVM started being enabled
    upstream, we finally get the basics in the form of state
    isolation. The vcpu state is now off-limit for the host for
    protected VMs.

  - pKVM also grows a hypervisor-private memory allocator, allowing it
    to deal with sub-page allocation, much like everywhere else.

  - pKVM also lands a trace_printk() equivalent, which hopefully will
    make debugging a bit easier.

  - First shot at annotating portions of the KVM/arm64 code to be
    extracted and built on s390. The real fun is yet to come.

  - Allow pre-faulting of stage-2 canonical mappings from userspace,
    joining x86 and s390 in implementing this feature.

  - Add a reverse mapping infrastructure for shadow stage-2,
    significantly improving performance when MMU notifiers kick in,
    and avoiding full unmap of all shadow tables for this VM.

  - Next step of GICv5 enablement, adding support for the IRS block,
    and providing both SPI and LPI support.  This is the first point
    where KVM/arm64 can support an SMP GICv5 guest.

* Improvements

  - As a preliminary to eventually enabling CCA, add a bunch of
    infrastructure to KVM/arm64, splitting some of the basic
    operations into individual backends (normal VM, normal pKVM VM,
    protected pKVM VM). This allows CCA to later slot in without
    polluting the rest of KVM with its firmware-driven nonsense.

  - Make ID registers immutable from the point where a vcpu is able
    to run, even if it fails to run. This prevents KVM from sampling
    untrusted values.

  - Restore some type checking to the EL2 object. KVM/arm64 originally
    had some strong type checking between the kernel and the EL2
    object, but lost it along the way when the private hypercall
    interface was (somewhat pointlessly) converted to SMCCC. Type
    checking is back, syscall style, and with added sparse goodies.

  - Expand the FFA support to FFA_NOTIFICATION_*, and add some
    sanitisation of the protocol that pKVM relays to the "trusted"
    runtime.

* Fixes

  - Make GICv3 RD assignment more robust to userspace nonsense

  - Convert the remaining MMU fault handler backends to
    kvm_s2_fault_vma_info and co, fixing a number of bugs in the
    process.

  - Fix the SError/SEA selftests to be both more robust and less
    braindead.

  - Fix a smattering of documentation bugs, some of them as a result
    of our AI friends spitting out credible assertions based on
    non-existing symbols.

  - The usual collection of low impact bug fixes (SMCCC, timers, PMU).

----------------------------------------------------------------
Colton Lewis (2):
      KVM: arm64: Handle ID_AA64DFR0_EL1.PMUVer == NI in __kvm_pmu_event_mask()
      KVM: arm64: Check ID_AA64DFR0_EL1.PMUVer in pmu_visibility()

Fuad Tabba (54):
      KVM: arm64: Fix the KVM_ARM_PREFERRED_TARGET documentation
      KVM: arm64: vgic-its: Reword the comment on a collection-less ITE
      tracing: Include linux/types.h in trace_remote_event.h
      KVM: arm64: nVHE: Share the stacktrace per-CPU declarations with EL2
      KVM: arm64: nVHE: Declare the hyp event IDs before defining them
      KVM: arm64: nVHE: Use NULL to reset the trace buffer backing pointer
      KVM: arm64: nVHE: Run the source checker under C=2
      arm64: pi: Run the source checker on the libfdt objects under C=2
      KVM: arm64: nVHE: Pass host VA arguments as pointers
      KVM: arm64: Move the host hypercall interface to its own header
      KVM: arm64: Type-check hypercall arguments at the caller
      KVM: arm64: nVHE: Check hypercall handlers against the declared ABI
      KVM: arm64: Tag host-VA hypercall parameters __kern
      KVM: arm64: vgic-its: Free the caches when GITS_BASER changes
      Revert "KVM: arm64: vgic-its: Don't save collections the table cannot hold"
      KVM: arm64: vgic-its: Skip unreachable devices instead of failing the save
      KVM: arm64: selftests: Add ITS table save tests
      KVM: arm64: Validate the SVE vector length in pkvm_vcpu_init_sve()
      KVM: arm64: Do not clear VM-wide SVE feature on vCPU init failure
      KVM: arm64: Key unpin_host_sve_state() on the state it unpins
      KVM: arm64: Derive GUEST_HAS_SVE from the SVE feature bit at EL2
      KVM: arm64: Transfer the hyp stack pages out of the host stage-2
      KVM: arm64: Match hyp text by physical address in fix_host_ownership()
      KVM: arm64: Move the private VA allocation cursor to __io_map_next
      KVM: arm64: Check every private mapping is hyp-owned at pKVM init
      KVM: arm64: Don't WARN on an unknown VM ioctl in protected mode
      KVM: arm64: Report SMCCC_VERSION and SMCCC_ARCH_FEATURES as implemented
      KVM: arm64: selftests: Check the mandatory SMCCC_ARCH_FEATURES queries
      KVM: arm64: selftests: Check ID regs are immutable after a failed run
      KVM: arm64: Use kvm_s2_fault_vma_info in gmem_abort()
      KVM: arm64: Sync HCR_EL2.VSE back to the host vCPU under pKVM
      KVM: arm64: Validate the host vCPU's VM before reading it under pKVM
      KVM: arm64: Pin the host vCPU before adjusting its PC under pKVM
      KVM: arm64: Disable steal time for protected VMs
      KVM: arm64: Skip fixed-feature state flush for protected vCPUs
      KVM: arm64: Add system register reset framework for protected VMs
      KVM: arm64: Implement HVC handling for protected guests at EL2
      KVM: arm64: Handle PSCI calls for protected VMs at EL2
      KVM: arm64: Restrict KVM_ARM_VCPU_INIT and PSCI version for protected VMs
      KVM: arm64: Prevent host PC adjustments for protected vCPUs
      KVM: arm64: Inject an UNDEF at EL2 for unhandled protected guest exits
      KVM: arm64: Add per-EC entry/exit state marshalling for protected guests
      KVM: arm64: Reject host access to protected VM private state
      KVM: arm64: Reject host power-on of a vCPU that EL2 holds powered off
      KVM: arm64: Advertise the capabilities that protected VMs support
      KVM: arm64: Document the protected VM userspace API
      KVM: Fix comments that refer to the non-existent VCPU_RUN ioctl
      KVM: arm64: Fix references to the non-existent VCPU_RUN ioctl
      KVM: PPC: Book3S HV: Fix comment naming a non-existent KVM_VCPU_RUN ioctl
      KVM: arm64: timers: Compute an offset-applied CVAL from the current count
      KVM: arm64: nv: Read a guest hypervisor's CNTV_CVAL_EL0 from memory on x1e
      KVM: arm64: selftests: Test a timer set past the counter's wrap
      KVM: arm64: Only emulate an SError's entry for vCPUs with NV
      KVM: arm64: selftests: Check the pending SError state in external_aborts

Hemanth Selam (3):
      KVM: arm64: Fix typo "synchonized" in comment
      KVM: arm64: selftests: Fix typos in comments
      KVM: arm64: Fix typo in pauth.c comment

Jack Thomson (3):
      KVM: arm64: Pass walk flags to kvm_pgtable_get_leaf()
      KVM: selftests: Enable pre_fault_memory_test for arm64
      KVM: selftests: Add option for different backing in pre-fault tests

Karl Mehltretter (10):
      KVM: arm64: Fix kvm_get_vtcr() kernel-doc
      Documentation: KVM: Fix the event_source sysfs path in the PMU attribute description
      Documentation: KVM: Fix the struct kvm_arm_device_addr name
      KVM: arm64: Return -EINVAL for an empty SMCCC filter range at base 0
      KVM: arm64: selftests: Test empty SMCCC filter range at base 0
      KVM: arm64: Fix AArch32 DBGBXVR<n> handling
      KVM: arm64: vgic-v3: Undo assignment on iodev registration failure
      KVM: arm64: vgic-v3: Roll back assignments from the new region
      KVM: arm64: selftests: Pass guest code to vm_gic_create_with_vcpus()
      KVM: arm64: selftests: Test VGICv3 redistributor region retry

Like Xu (3):
      KVM: arm64: selftests: Fix EINJ handling in sea_to_user
      KVM: arm64: selftests: Skip sea_to_user without 1GB hugepages
      KVM: arm64: selftests: Skip sea_to_user when EINJ places no poison

Lorenzo Stoakes (ARM) (13):
      KVM: arm64: Fix spurious warning for benign stage 2 teardown race
      KVM: arm64: nv: Fix null ptr deref on nested wp/unmap, teardown race
      KVM: Allow architectures to disallow pre-fault
      arm64: Add ESR fault helpers
      KVM: arm64: Use ESR helpers in guest abort handling
      KVM: arm64: Propagate and use esr in s2fd when handling guest aborts
      KVM: arm64: Propagate and use mmu in s2fd when handling guest aborts
      KVM: arm64: Propagate and use kvm_s2_fault_result on S2 fault
      KVM: arm64: Size the stage-2 memcache from the fault MMU
      KVM: arm64: Propagate EHWPOISON in kvm_s2_fault_pin_pfn()
      KVM: arm64: Implement KVM_PRE_FAULT_MEMORY
      Documentation: KVM: document arm64 KVM_PRE_FAULT_MEMORY
      KVM: selftests: Add nested pre-fault test for arm64

Marc Zyngier (26):
      KVM: arm64: nv: Fix life cycle of the nested_mmus array
      KVM: arm64: nv: Delay freeing of shadow S2 structures until VM destruction
      KVM: arm64: vgic-v5: Drop __iomem attribute from {vmd,vpet}_base
      KVM: arm64: vgic-v5: Correctly reset h_lpi_ist to NULL
      KVM: arm64: vgic-v5: Tidy-up programming of vpe descriptor address
      Merge branch kvm-arm64/ffa-7.4 into kvmarm-master/next
      Merge tag 'kvmarm-fixes-7.3-1' into kvm-arm64/s2-rmap
      KVM: arm64: nv: Drop kvm_s2_mmu pointer from kvm_guest_s2_mapping
      KVM: arm64: vgic-v5: Correctly handle host ISTE __le32 conversion
      KVM: arm64: Introduce per-EC entry handlers for pKVM
      KVM: arm64: Add {flush,sync}_hyp_timer_state() primitives
      Merge branch kvm-arm64/doc-7.4 into kvmarm-master/next
      Merge branch kvm-arm64/selftests-7.4 into kvmarm-master/next
      Merge branch kvm-arm64/hyp-type-checking-7.4 into kvmarm-master/next
      Merge branch kvm-arm64/gicv5-7.4 into kvmarm-master/next
      Merge branch kvm-arm64/s2-rmap into kvmarm-master/next
      Merge branch kvm-arm64/pre-faulting into kvmarm-master/next
      Merge branch kvm-arm64/misc-7.4 into kvmarm-master/next
      Merge branch kvm-arm64/immutable-idregs-7.4 into kvmarm-master/next
      Merge branch kvm-arm64/s390-7.4 into kvmarm-master/next
      Merge branch kvm-arm64/mmu-fixes-7.4 into kvmarm-master/next
      Merge branch kvm-arm64/pkvm-state-7.4 into kvmarm-master/next
      Merge branch kvm-arm64/pkvm-allocator-7.4 into kvmarm-master/next
      Merge branch kvm-arm64/pkvm-tracing-7.4 into kvmarm-master/next
      Merge branch kvm-arm64/rd-assignment-fixes into kvmarm-master/next
      Merge branch kvm-arm64/cca-7.4 into kvmarm-master/next

Mark Brown (3):
      KVM: arm64: Fix FGT mapping for HFGITR_EL2.nGCSEPP
      KVM: arm64: Finalize guest-wide sysregs prior to per-vCPU sysregs
      KVM: arm64: Block ID register changes after we rely on the values

Sascha Bischoff (48):
      irqchip/gic-v5: Allow KVM setup without a maintenance IRQ
      irqchip/gic-v5: Provide OF IRS config frame attrs to KVM
      irqchip/gic-v5: Set up gic_kvm_info on ACPI hosts
      KVM: arm64: gic-v5: Define remaining IRS MMIO registers
      arm64/sysreg: Add GICv5 GIC VDPEND encoding
      KVM: arm64: gic-v5: Cache host IRS ID registers
      KVM: arm64: gic-v5: Add VPE doorbell domain
      KVM: arm64: gic-v5: Create and manage VM and VPE tables
      KVM: arm64: gic-v5: Introduce guest IST alloc and management
      KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops
      KVM: arm64: vgic: Enforce model-specific vCPU limits
      KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
      KVM: arm64: gic-v5: Set up VMTEs and VPE doorbells
      KVM: arm64: gic-v5: Add resident/non-resident hyp calls
      KVM: arm64: gic-v5: Request doorbells when VPEs enter WFI
      KVM: arm64: gic-v5: Introduce struct vgic_v5_irs and IRS base address
      KVM: arm64: gic-v5: Add IRS IODEV support to MMIO handlers
      KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
      KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO emulation
      KVM: arm64: gic-v5: Initialise per-VM IRS state
      KVM: arm64: gic-v5: Register the IRS IODEV
      KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS enable state
      KVM: arm64: selftests: Update vGICv5 selftest to set IRS address
      KVM: arm64: gic-v5: Add GIC VDPEND hyp call
      KVM: arm64: gic: Introduce set_pending_state() to irq_ops
      KVM: arm64: gic-v5: Support SPI injection
      Documentation: KVM: Extend VGICv5 device attribute docs
      KVM: arm64: gic-v5: Add GICv5 SPI injection to irqfd
      KVM: arm64: gic-v5: Mask per-vCPU PPI state in vgic_v5_finalize_ppi_state()
      KVM: arm64: gic-v5: Add GICv5 EL1 sysreg userspace accessors
      KVM: arm64: gic-v5: Handle userspace accesses to IRS MMIO region
      KVM: arm64: gic-v5: Add CoreSight MMIO regs to IRS
      KVM: arm64: gic-v5: Add VGICv5 IST save/restore UAPI
      KVM: arm64: gic-v5: Implement save/restore mechanisms for ISTs
      Documentation: KVM: Document KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
      Documentation: KVM: Add KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
      Documentation: KVM: Add docs for KVM_DEV_ARM_VGIC_GRP_IST
      Documentation: KVM: Add the VGICv5 IRS save/restore sequences
      KVM: selftests: Add VGICv5 IRS address attribute tests
      KVM: selftests: Add VGICv5 NR_IRQS attribute tests
      KVM: selftests: Add VGICv5 IRS_REGS attribute tests
      KVM: selftests: Add VGICv5 IST attribute tests
      KVM: selftests: Add VGICv5 USERSPACE_PPIS tests
      KVM: selftests: Add VGICv5 CPU sysreg attribute tests
      KVM: selftests: Add VGICv5 SPI injection tests
      KVM: selftests: Add VGICv5 LPI delivery tests
      KVM: selftests: Add VGICv5 IST save/restore coverage
      KVM: selftests: Add VGICv5 sparse vCPU IDs test

Sebastian Ene (7):
      KVM: arm64: Forward FFA_NOTIFICATION_BITMAP calls to Trustzone
      KVM: arm64: Support FFA_NOTIFICATION_BIND in host handler
      KVM: arm64: Support FFA_NOTIFICATION_UNBIND in host handler
      KVM: arm64: Support FFA_NOTIFICATION_SET in host handler
      KVM: arm64: Support FFA_NOTIFICATION_GET in host handler
      KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in host handler
      KVM: arm64: Enforce strict SBZ checks in the FF-A proxy

Sebastian Ott (1):
      KVM: selftests: fix steal_time for arm64 with host page size > 4K

Steffen Eiden (7):
      arm64: ptrace: Use constants for compat register numbers
      arm64: sysreg: Convert SPSR_ELx to automatic register generation
      KVM: arm64: Access elements of vcpu_gp_regs individually
      KVM: arm64: Use accessor functions for core regs
      arm64: Prepare sharing arm64 headers with s390
      arm64: Share arm64 headers with s390
      KVM: arm64: Share arm64 code with s390

Steven Price (1):
      KVM: arm64: Avoid including linux/kvm_host.h in kvm_pgtable.h

Suzuki K Poulose (12):
      KVM: arm64: protected VM: Handle user writes to CNTVCT_EL0/CNTPCT_EL0
      KVM: arm64: Include kvm_emulate.h in kvm/arm_psci.h
      KVM: arm64: Track the type of VM in kvm_arch
      KVM: arm64: Don't call vcpu_set_pauth_traps for pKVM host
      KVM: arm64: Refactor the vcpu_load to allow for VM specific callbacks
      KVM: arm64: Add vcpu load/put call backs for flavors
      KVM: arm64: Consolidate stage2 unmap range into kvm_stage2_unmap_range
      KVM: arm64: Add VM specific callback for S2 MMU operations
      KVM: arm64: Use a local kvm pointer in kvm_handle_guest_abort()
      KVM: arm64: Abstract out memory abort handling
      KVM: arm64: Mandate VGIC v3 for pKVM VMs and Realms
      KVM: arm64: Prevent unsupported vcpu features for VM types

Tharit Tangkijwanichakul (1):
      KVM: arm64: selftests: Fix VM leak in early return

Vincent Donnefort (30):
      KVM: arm64: Disable stage-2 ptdump of pKVM
      KVM: arm64: Remove PAGE_SIZE alignment for hyp event ELF sections
      KVM: arm64: Fix MMFR0 TGRAN advertisement for pVMs
      KVM: arm64: Pass kvm_s2_fault_desc to fault_supports_stage2_huge_mapping()
      KVM: arm64: Use kvm_s2_fault_vma_info in pkvm_mem_abort()
      KVM: arm64: Add pkvm_private_va_range_pa
      KVM: arm64: Add pkvm_remove_mappings
      KVM: arm64: Add pkvm_map_private_va_range
      KVM: arm64: Add a heap allocator for the pKVM hyp
      KVM: arm64: Allow kvm_hyp_memcache usage outside of stage-2
      KVM: arm64: Add pkvm_hyp_req infrastructure
      KVM: arm64: Add PKVM_HYP_REQ_HYP_ALLOC request
      KVM: arm64: Add reclaim interface for the pKVM heap alloc
      KVM: arm64: Add selftests for the pKVM heap allocator
      KVM: arm64: Add a shrinker for pKVM
      KVM: arm64: Filter out non-kernel addresses in kern_hyp_va
      KVM: arm64: Move hyp_vm refcount into the structure
      KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator
      KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM heap allocator
      KVM: arm64: Rename vCPU pkvm_memcache to stage2_mc
      KVM: arm64: Reject hyp trace descriptors with fewer CPUs than hyp_nr_cpus
      KVM: arm64: Reject hyp trace descriptors with fewer than 3 pages
      KVM: arm64: Alloc simple_buffer_page using pKVM hyp allocator
      KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp
      KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/
      tracing/remotes: Add REMOTE_EVENT_CUSTOM_PRINTK() helper
      KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp
      KVM: arm64: pkvm: Drop keneldoc markers for the allocator structs
      KVM: arm64: Prevent 64-bit overflow when computing hyp clock rate
      KVM: arm64: Fix bpages backing allocation size in hyp_trace

Wei-Lin Chang (8):
      KVM: arm64: Use a variable for the canonical IPA in kvm_s2_fault_map()
      KVM: arm64: nv: Introduce guest stage-2 tracking structures
      KVM: arm64: nv: Track guest stage-2 mapping removal
      KVM: arm64: nv: Track guest stage-2 mapping creation
      KVM: arm64: nv: Avoid full shadow stage-2 unmap
      KVM: arm64: Refactor kvm_unmap_gfn_range() with common variables
      KVM: arm64: ptdump: Check the page tables aren't freed when accessing
      KVM: arm64: ptdump: Fix shadow ptdump sleep-in-atomic-context problem

 Documentation/virt/kvm/api.rst                     |   67 +-
 Documentation/virt/kvm/arm/fw-pseudo-registers.rst |    2 +
 Documentation/virt/kvm/arm/pkvm.rst                |  164 +-
 Documentation/virt/kvm/devices/arm-vgic-v5.rst     |  271 ++-
 Documentation/virt/kvm/devices/vcpu.rst            |    5 +-
 arch/arm64/Makefile                                |    3 +
 arch/arm64/include/asm/brk-imm.h                   |    1 +
 arch/arm64/include/asm/esr.h                       |   34 +-
 arch/arm64/include/asm/kvm_arm.h                   |    6 +-
 arch/arm64/include/asm/kvm_asm.h                   |   11 +-
 arch/arm64/include/asm/kvm_emulate.h               |  124 +-
 arch/arm64/include/asm/kvm_hcall.h                 |  258 +++
 arch/arm64/include/asm/kvm_host.h                  |  300 ++--
 arch/arm64/include/asm/kvm_hyp.h                   |    7 +
 arch/arm64/include/asm/kvm_hypevents.h             |   14 +
 arch/arm64/include/asm/kvm_hyptrace.h              |    9 +
 arch/arm64/include/asm/kvm_mmu.h                   |   19 +-
 arch/arm64/include/asm/kvm_nested.h                |   10 +-
 arch/arm64/include/asm/kvm_pgtable.h               |   17 +-
 arch/arm64/include/asm/kvm_pkvm.h                  |  155 +-
 arch/arm64/include/asm/ptrace.h                    |   64 +-
 arch/arm64/include/asm/stacktrace/nvhe.h           |   10 +-
 arch/arm64/include/asm/sysreg.h                    |   33 +-
 arch/arm64/include/uapi/asm/kvm.h                  |   15 +
 arch/arm64/kernel/image-vars.h                     |    1 +
 arch/arm64/kernel/pi/Makefile                      |    1 +
 arch/arm64/kernel/vmlinux.lds.S                    |   10 +-
 arch/arm64/kvm/Kconfig                             |    1 +
 arch/arm64/kvm/Makefile                            |    3 +-
 arch/arm64/kvm/arch_timer.c                        |   39 +-
 arch/arm64/kvm/arm.c                               |  365 +++-
 .../define_hypevents.h}                            |    0
 arch/arm64/kvm/emulate-nested.c                    |    2 +-
 arch/arm64/kvm/guest.c                             |   33 +-
 arch/arm64/kvm/hyp/entry.S                         |    2 +-
 arch/arm64/kvm/hyp/exception.c                     |   30 +-
 arch/arm64/kvm/hyp/hyp-constants.c                 |    2 -
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h         |   52 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |    4 +-
 arch/arm64/kvm/hyp/include/nvhe/alloc.h            |   28 +
 arch/arm64/kvm/hyp/include/nvhe/define_events.h    |    2 -
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h      |    2 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h               |    4 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h             |   40 +-
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h         |    4 +
 arch/arm64/kvm/hyp/include/nvhe/trace.h            |   71 +-
 arch/arm64/kvm/hyp/nvhe/Makefile                   |    3 +-
 arch/arm64/kvm/hyp/nvhe/alloc.c                    | 1212 +++++++++++++
 arch/arm64/kvm/hyp/nvhe/events.c                   |    8 +
 arch/arm64/kvm/hyp/nvhe/ffa.c                      |  220 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 | 1182 +++++++++---
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S                  |    1 -
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   40 +-
 arch/arm64/kvm/hyp/nvhe/mm.c                       |  156 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  534 +++++-
 arch/arm64/kvm/hyp/nvhe/setup.c                    |   22 +-
 arch/arm64/kvm/hyp/nvhe/stacktrace.c               |    3 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |   29 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |   63 +
 arch/arm64/kvm/hyp/nvhe/trace.c                    |   76 +-
 arch/arm64/kvm/hyp/pgtable.c                       |    6 +-
 arch/arm64/kvm/hyp/vgic-v5-sr.c                    |   45 +
 arch/arm64/kvm/hyp/vhe/switch.c                    |   21 +-
 arch/arm64/kvm/hyp_trace.c                         |   90 +-
 arch/arm64/kvm/hypercalls.c                        |   14 +-
 arch/arm64/kvm/inject_fault.c                      |   10 +-
 arch/arm64/kvm/mmio.c                              |    3 +
 arch/arm64/kvm/mmu.c                               |  799 +++++++--
 arch/arm64/kvm/nested.c                            |  262 ++-
 arch/arm64/kvm/pauth.c                             |    2 +-
 arch/arm64/kvm/pkvm.c                              |  226 ++-
 arch/arm64/kvm/pmu-emul.c                          |    5 +-
 arch/arm64/kvm/psci.c                              |   11 +-
 arch/arm64/kvm/ptdump.c                            |   79 +-
 arch/arm64/kvm/pvtime.c                            |   10 +-
 arch/arm64/kvm/stacktrace.c                        |    3 -
 arch/arm64/kvm/sys_regs.c                          |   70 +-
 arch/arm64/kvm/sys_regs.h                          |    2 +-
 arch/arm64/kvm/trace_pkvm.h                        |   45 +
 arch/arm64/kvm/vgic-sys-reg-v5.c                   |  519 ++++++
 arch/arm64/kvm/vgic/vgic-init.c                    |  162 +-
 arch/arm64/kvm/vgic/vgic-irqfd.c                   |   18 +-
 arch/arm64/kvm/vgic/vgic-irs-v5.c                  | 1217 +++++++++++++
 arch/arm64/kvm/vgic/vgic-its.c                     |   52 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c              |  272 ++-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   33 +-
 arch/arm64/kvm/vgic/vgic-mmio.c                    |    6 +
 arch/arm64/kvm/vgic/vgic-mmio.h                    |    2 +
 arch/arm64/kvm/vgic/vgic-v5-tables.c               | 1872 ++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h               |  140 ++
 arch/arm64/kvm/vgic/vgic-v5.c                      | 1152 +++++++++++-
 arch/arm64/kvm/vgic/vgic.c                         |   39 +-
 arch/arm64/kvm/vgic/vgic.h                         |   21 +
 arch/arm64/tools/sysreg                            |   51 +
 arch/powerpc/kvm/book3s_hv.c                       |    2 +-
 arch/s390/kvm/s390/s390.c                          |   11 +-
 arch/x86/kvm/mmu/mmu.c                             |   11 +-
 arch/x86/kvm/vmx/tdx.c                             |    2 +-
 drivers/irqchip/irq-gic-v5-irs.c                   |   19 +-
 drivers/irqchip/irq-gic-v5.c                       |  111 +-
 include/kvm/arm_arch_timer.h                       |   15 +
 include/kvm/arm_psci.h                             |    2 +
 include/kvm/arm_vgic.h                             |  213 ++-
 include/linux/irqchip/arm-gic-v5.h                 |  254 ++-
 include/linux/irqchip/arm-vgic-info.h              |    5 +
 include/linux/kvm_host.h                           |    3 +-
 include/linux/trace_remote_event.h                 |    2 +
 include/trace/define_remote_events.h               |   19 +-
 tools/arch/arm64/include/uapi/asm/kvm.h            |   15 +
 tools/testing/selftests/kvm/Makefile.kvm           |    3 +
 .../selftests/kvm/arm64/arch_timer_edge_cases.c    |   25 +
 .../testing/selftests/kvm/arm64/debug-exceptions.c |    2 +-
 .../testing/selftests/kvm/arm64/external_aborts.c  |   23 +-
 tools/testing/selftests/kvm/arm64/hypercalls.c     |   31 +-
 .../selftests/kvm/arm64/nv_pre_fault_memory_test.c |  158 ++
 tools/testing/selftests/kvm/arm64/sea_to_user.c    |   75 +-
 tools/testing/selftests/kvm/arm64/set_id_regs.c    |  106 +-
 tools/testing/selftests/kvm/arm64/smccc_filter.c   |    4 +
 tools/testing/selftests/kvm/arm64/vgic_init.c      |  116 +-
 tools/testing/selftests/kvm/arm64/vgic_its_save.c  |  441 +++++
 tools/testing/selftests/kvm/arm64/vgic_v5.c        | 1849 ++++++++++++++++++-
 tools/testing/selftests/kvm/include/arm64/gic_v5.h |  105 ++
 tools/testing/selftests/kvm/include/test_util.h    |    1 +
 tools/testing/selftests/kvm/lib/test_util.c        |   15 +
 .../testing/selftests/kvm/pre_fault_memory_test.c  |  150 +-
 tools/testing/selftests/kvm/steal_time.c           |   30 +-
 virt/kvm/kvm_main.c                                |   12 +-
 127 files changed, 15492 insertions(+), 1441 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_hcall.h
 rename arch/arm64/{include/asm/kvm_define_hypevents.h => kvm/define_hypevents.h} (100%)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/alloc.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/alloc.c
 create mode 100644 arch/arm64/kvm/trace_pkvm.h
 create mode 100644 arch/arm64/kvm/vgic-sys-reg-v5.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-irs-v5.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.h
 create mode 100644 tools/testing/selftests/kvm/arm64/nv_pre_fault_memory_test.c
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_its_save.c


commit 678f16b6e4767096aa3e3e6eef60e981b3f61e12
Merge: dd0bc00e3e920 bc502b86a3cfd
Author: Marc Zyngier <maz@kernel.org>
Date:   Sun Oct 11 16:40:16 2026 +0100

    Merge branch kvmarm-fixes-7.3-2 into kvmarm-master/next-7.4+fixes-7.3-2
    
    KVM/arm64 fixes for 7.3, round #2
    
     - Take a reference on the last IRQ loaded into an LR to prevent it
       from being freed while running the guest (Marc Zyngier)
    
     - Ensure that the ITS MOVALL command only affects LPIs that were
       previously affined to the source redistributor (Marc Zyngier)
    
     - Fix + test for honoring the host's trap configuration when running
       non-protected VMs while KVM is in protected mode (Fuad Tabba)
    
     - Use the host stage-1 mapping granularity for VM_PFNMAP mappings at
       stage-2 (Mostafa Saleh)
    
    * tag 'kvmarm-fixes-7.3-2':
      KVM: arm64: Use stage-1 leaf size for VM_PFNMAP
      KVM: arm64: selftests: Check a feature hidden in an ID register is UNDEF
      KVM: arm64: Use the host's HCR_EL2 for non-protected VMs in pKVM
      KVM: arm64: Clear HCR_EL2.RW for 32-bit non-protected vCPUs
      KVM: arm64: Apply the fine-grained UNDEFs without FEAT_FGT
      KVM: arm64: vgic-its: Fix MOVALL handling of source redistributor
      KVM: arm64: vgic: Take a refcount on IRQs referenced by last_lr_irq
      KVM: arm64: vgic: Allow last_lr_irq to be NULL when LRs are not overflowing
    
    Signed-off-by: Marc Zyngier <maz@kernel.org>

diff --cc arch/arm64/kvm/hyp/nvhe/hyp-main.c
index d715aa942577e,ac64a036b0a95..137a8144d09e8
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@@ -693,8 -216,7 +693,9 @@@ static void sync_debug_state(struct pkv
  static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
  {
  	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+ 	u64 host_hcr_mask = PKVM_HCR_EL2_HOST_PVM;
 +	hyp_entry_exit_handler_fn ec_handler;
 +	u8 esr_ec;
  
  	fpsimd_sve_flush();
  	flush_debug_state(hyp_vcpu);
@@@ -707,60 -229,35 +708,57 @@@
  	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
  		if (vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY))
  			flush_hyp_vcpu_state(hyp_vcpu);
 +
- 		hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
- 		hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
- 							 (HCR_TWI | HCR_TWE);
- 
 +		hyp_vcpu->vcpu.arch.mdcr_el2 = host_vcpu->arch.mdcr_el2;
 +		hyp_vcpu->vcpu.arch.iflags = host_vcpu->arch.iflags;
+ 		host_hcr_mask = PKVM_HCR_EL2_HOST_NPVM;
 -	} else {
 -		hyp_vcpu->vcpu.arch.ctxt = host_vcpu->arch.ctxt;
  	}
  
  	/* __hyp_running_vcpu must be NULL in a guest context. */
  	hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu = NULL;
  
 -	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
  	/*
 -	 * HCR_EL2.VSE is host-owned (a pending virtual SError to inject), not a
 -	 * trap-control bit, so it must flow to the hyp vCPU alongside TWI/TWE
 -	 * for the vSError to be delivered. sync_hyp_vcpu() reflects it back.
 +	 * A host-injected vSError is masked by the guest's own PSTATE.A, so it
 +	 * applies to protected guests too.
  	 */
- 	hyp_vcpu->vcpu.arch.hcr_el2 &= ~HCR_VSE;
- 	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) & HCR_VSE;
+ 	hyp_vcpu->vcpu.arch.hcr_el2 &= ~host_hcr_mask;
+ 	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) & host_hcr_mask;
 -
 -	hyp_vcpu->vcpu.arch.iflags	= host_vcpu->arch.iflags;
 -
 -	hyp_vcpu->vcpu.arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
 +	hyp_vcpu->vcpu.arch.vsesr_el2 = host_vcpu->arch.vsesr_el2;
  
  	flush_hyp_vgic_state(hyp_vcpu);
 +	flush_hyp_timer_state(hyp_vcpu);
  
  	hyp_vcpu->vcpu.arch.pid = host_vcpu->arch.pid;
 +
 +	switch (ARM_EXCEPTION_CODE(hyp_vcpu->exit_code)) {
 +	case ARM_EXCEPTION_IRQ:
 +	case ARM_EXCEPTION_EL1_SERROR:
 +	case ARM_EXCEPTION_IL:
 +		break;
 +	case ARM_EXCEPTION_TRAP:
 +		/* Nothing was marshalled for this trap, see sync_hyp_vcpu(). */
 +		if (ARM_SERROR_PENDING(hyp_vcpu->exit_code))
 +			break;
 +
 +		if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
 +			esr_ec = ESR_ELx_EC(kvm_vcpu_get_esr(&hyp_vcpu->vcpu));
 +			ec_handler = entry_hyp_pvm_handlers[esr_ec];
 +			if (ec_handler)
 +				ec_handler(hyp_vcpu);
 +		}
 +		break;
 +	default:
 +		BUG();
 +	}
 +
 +	hyp_vcpu->exit_code = 0;
  }
  
 -static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 +static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu, u32 exit_reason)
  {
  	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
 +	hyp_entry_exit_handler_fn ec_handler;
 +	u8 esr_ec;
  
  	fpsimd_sve_sync(&hyp_vcpu->vcpu);
  	sync_debug_state(hyp_vcpu);
diff --cc arch/arm64/kvm/mmu.c
index a48f3f531e827,bf6d6526639fa..605a9b25f62b1
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@@ -2307,18 -2104,7 +2276,14 @@@ static int user_mem_abort(const struct 
  			return ret;
  	}
  
- 	/*
- 	 * Let's check if we will get back a huge page backed by hugetlbfs, or
- 	 * get block mapping for device MMIO region.
- 	 */
  	ret = kvm_s2_fault_pin_pfn(s2fd, &s2vi);
 +	if (ret == -EHWPOISON) {
 +		/* If result is specified, let the caller handle this. */
 +		if (result)
 +			return -EHWPOISON;
 +		kvm_send_hwpoison_signal(s2fd->hva, __ffs(s2vi.vma_pagesize));
 +		return 0;
 +	}
  	if (ret != 1)
  		return ret;
  
