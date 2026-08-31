Received: from mta1.migadu.com (out-41.mta1.migadu.com [95.215.58.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607284A0F08
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 16:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194124; cv=none; b=U/Z2ZgHYO1d7M0U5bDjDnmk7BoimKBsNTVUfBlJbWNZDWtGF8Vz2+bi2fcG+sqV7LKBLdsYtUoiejKtQsUaB1GanJH2KukFcnhjRokHPF/VGQBnJgENuNxjHo27f/cOsfwDbMRv8C+FciDpE9/RF00/n7JZ9efkERX7cp8QQGv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194124; c=relaxed/simple;
	bh=cANDNO2tv54Yz7hlZgxlcIbNF8NJMg7aOsYvgLITD0E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kO4CgWtnYbq9iWWZI2AkcJIHaXriIDM/Olr3/6xm/zt6GbounJKrhSO3xugX1XCa4xd9Sc30xuoNAlUWvUNpuGerpzLDqco2d5ZweIMqGr9M1XbfpnHaY310tXi01FESRerv4qIDszLJ8mp2rpzR0Wpm5QdOMDT+DhJ2qdvHMU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m0S5Xv9s; arc=none smtp.client-ip=95.215.58.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m0S5Xv9s"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=cANDNO2tv54Yz7hlZgxlcIbNF8NJMg7aOsYvgLITD0E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788194118; v=1; x=1788798918;
 b=m0S5Xv9sS8l1MAYCE5+BuJGNUw9NxcmBYch3u2fcZWBsXTW3xo/UfySFUZYczK3shndU4iaY
 wqMZgjavCvVAusRgbe+pazdkl2IaBr2+Rf0CIPaRFBwXlemfPKIP+5UwrsWJ5KugquK9KePBQCI
 DZt4GCfp+OD+T6ujUhtWPO/Q=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 8a9deb6fc4739e5d;
	Mon, 31 Aug 2026 16:35:18 +0000
X-Mizu-Trace-ID: 8a9deb6fc4739e5d
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
Subject: [PATCH 17/17] KVM: arm64: Document the protected VM userspace API
Date: Mon, 31 Aug 2026 17:34:21 +0100
Message-Id: <20260831163421.272420-18-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260831163421.272420-1-fuad.tabba@linux.dev>
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EL2 owns a protected vCPU's state once it has run, and the ioctls that
would access it fail rather than silently operate on a copy that is not
the guest's. Describe the resulting API in pkvm.rst, point api.rst at
it from each ioctl that behaves differently, and note the errnos beside
the PVTIME attribute in devices/vcpu.rst and the PSCI version register
in fw-pseudo-registers.rst.

No functional change intended.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 Documentation/virt/kvm/api.rst                |  22 ++-
 .../virt/kvm/arm/fw-pseudo-registers.rst      |   2 +
 Documentation/virt/kvm/arm/pkvm.rst           | 141 +++++++++++++++++-
 Documentation/virt/kvm/devices/vcpu.rst       |   4 +-
 4 files changed, 161 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e0430cc750c9e..212ac2aa5c6bd 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1322,6 +1322,9 @@ guests, across different userspace implementations. Nevertheless, userspace
 can still emulate all Arm exceptions by manipulating individual registers
 using the KVM_SET_ONE_REG API.
 
+For a protected VM, setting ext_dabt_pending returns -EPERM; see
+Documentation/virt/kvm/arm/pkvm.rst. Injecting an SError is unaffected.
+
 See KVM_GET_VCPU_EVENTS for the data structure.
 
 Calling this ioctl on a vCPU that hasn't been initialized will return
@@ -1624,6 +1627,11 @@ For arm64/riscv:
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or not.
 
+On arm64, once a protected VM's vcpu has run, KVM_MP_STATE_RUNNABLE and
+KVM_MP_STATE_SUSPENDED return -EPERM if the guest has powered it off with
+CPU_OFF or has not yet brought it online with CPU_ON: only the guest can
+power it on. See Documentation/virt/kvm/arm/pkvm.rst.
+
 On LoongArch, only the KVM_MP_STATE_RUNNABLE state is used to reflect
 whether the vcpu is runnable.
 
@@ -2324,7 +2332,8 @@ Errors:
   ENOENT   no such register
   EINVAL   invalid register ID, or no such register or used with VMs in
            protected virtualization mode on s390
-  EPERM    (arm64) register access not allowed before vcpu finalization
+  EPERM    (arm64) register access not allowed before vcpu
+           finalization, or after a protected VM's vcpu has run
   EBUSY    (riscv) changing register value not allowed after the vcpu
            has run at least once
   ======   ============================================================
@@ -2949,7 +2958,8 @@ Errors include:
   ENOENT   no such register
   EINVAL   invalid register ID, or no such register or used with VMs in
            protected virtualization mode on s390
-  EPERM    (arm64) register access not allowed before vcpu finalization
+  EPERM    (arm64) register access not allowed before vcpu
+           finalization, or after a protected VM's vcpu has run
   ======== ============================================================
 
 (These error codes are indicative only: do not rely on a specific error
@@ -3484,6 +3494,7 @@ Errors:
   ======     =================================================================
   EINVAL     the target is unknown, or the combination of features is invalid.
   ENOENT     a features bit specified is unknown.
+  EPERM      the vcpu belongs to a protected VM and has already run.
   ======     =================================================================
 
 This tells KVM what type of CPU to present to the guest, and what
@@ -3512,6 +3523,10 @@ after the vcpu has been run. This will reset the vcpu to its initial
 state. All calls to this function after the initial call must use the same
 target and same set of feature flags, otherwise EINVAL will be returned.
 
+For a protected VM this ioctl returns EPERM once the vcpu has run, and the
+features it accepts are restricted: KVM_ARM_VCPU_PSCI_0_2 is required. See
+Documentation/virt/kvm/arm/pkvm.rst.
+
 Possible features:
 
 	- KVM_ARM_VCPU_POWER_OFF: Starts the CPU in a power-off state.
@@ -3790,6 +3805,9 @@ can be determined by querying the KVM_CAP_GUEST_DEBUG_HW_BPS and
 KVM_CAP_GUEST_DEBUG_HW_WPS capabilities which return a positive number
 indicating the number of supported registers.
 
+On arm64, this ioctl returns -EPERM for a protected VM: debugging a
+protected guest is not supported. See Documentation/virt/kvm/arm/pkvm.rst.
+
 For ppc, the KVM_CAP_PPC_GUEST_DEBUG_SSTEP capability indicates whether
 the single-step debug event (KVM_GUESTDBG_SINGLESTEP) is supported.
 
diff --git a/Documentation/virt/kvm/arm/fw-pseudo-registers.rst b/Documentation/virt/kvm/arm/fw-pseudo-registers.rst
index d78b53b05dfcf..c07471e258ea2 100644
--- a/Documentation/virt/kvm/arm/fw-pseudo-registers.rst
+++ b/Documentation/virt/kvm/arm/fw-pseudo-registers.rst
@@ -33,6 +33,8 @@ The following registers are defined:
     highest PSCI version implemented by KVM and compatible with v0.2)
   - Allows any PSCI version implemented by KVM and compatible with
     v0.2 to be set with SET_ONE_REG
+  - Returns -EINVAL for a version below v1.1 on a protected VM (see
+    Documentation/virt/kvm/arm/pkvm.rst)
   - Affects the whole VM (even if the register view is per-vcpu)
 
 * KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
diff --git a/Documentation/virt/kvm/arm/pkvm.rst b/Documentation/virt/kvm/arm/pkvm.rst
index 514992a79a833..4411599fd508f 100644
--- a/Documentation/virt/kvm/arm/pkvm.rst
+++ b/Documentation/virt/kvm/arm/pkvm.rst
@@ -15,7 +15,8 @@ Overview
 Booting a host kernel with '``kvm-arm.mode=protected``' enables
 "Protected KVM" (pKVM). During boot, pKVM installs a stage-2 identity
 map page-table for the host and uses it to isolate the hypervisor
-running at EL2 from the rest of the host running at EL1/0.
+running at EL2 from the rest of the host running at EL1/0. pKVM requires
+a GICv3 interrupt controller.
 
 pKVM permits creation of protected virtual machines (pVMs) by passing
 the ``KVM_VM_TYPE_ARM_PROTECTED`` machine type identifier to the
@@ -31,7 +32,7 @@ See hypercalls.rst for more details.
 Isolation mechanisms
 ====================
 
-pKVM relies on a number of mechanisms to isolate PVMs from the host:
+pKVM relies on a number of mechanisms to isolate pVMs from the host:
 
 CPU memory isolation
 --------------------
@@ -67,12 +68,20 @@ largely due to the lack of MMU notifiers:
   then it will either return ``-EFAULT`` or forcefully reclaim the
   memory pages. Reclaimed memory is zeroed by the hypervisor and a
   subsequent attempt to access it in the pVM will return ``-EFAULT``
-  from the ``VCPU_RUN`` ioctl().
+  from the ``KVM_RUN`` ioctl().
 
 CPU state isolation
 -------------------
 
-Status: **Unimplemented.**
+Status: CPU register state of protected vCPUs is managed entirely at EL2.
+
+pKVM performs the complete context switch for protected vCPUs within the
+hypervisor. Protected vCPU state is initialised by the hypervisor to
+architecturally defined reset values, and only what each exit needs is
+synchronised back to the host.
+
+The user-visible consequences are described under `API behaviour for
+protected VMs`_.
 
 DMA isolation using an IOMMU
 ----------------------------
@@ -89,13 +98,135 @@ The FF-A proxy ensures that the host cannot share pVM or hypervisor
 memory with Trustzone as part of a "confused deputy" attack.
 
 The PSCI proxy ensures that CPUs always have the stage-2 identity map
-installed when they are executing in the host.
+installed when they are executing in the host. This proxy is distinct
+from the PSCI handling provided to protected guests, which is described
+under `API behaviour for protected VMs`_.
 
 Protected VM firmware (pvmfw)
 -----------------------------
 
 Status: **Unimplemented.**
 
+API behaviour for protected VMs
+===============================
+
+Protected vCPU state is owned by EL2 (see `CPU state isolation`_). The VMM
+configures a vCPU before its first ``KVM_RUN``; afterwards the state is
+private to the guest and the ioctls that access it return ``-EPERM``. The
+errors follow one rule: ``-EPERM`` means the host asked for state that the
+guest owns, and ``-EINVAL`` means the request is not valid for a protected
+VM. The ioctls themselves are described in Documentation/virt/kvm/api.rst.
+
+Boot
+----
+
+A protected VM boots from a single primary vCPU. Before the first
+``KVM_RUN``, the VMM prepares the boot state:
+
+* Set ``KVM_MP_STATE_RUNNABLE`` on the primary vCPU and
+  ``KVM_MP_STATE_STOPPED`` on every other vCPU. EL2 allows only one
+  RUNNABLE primary per protected VM. A second RUNNABLE vCPU fails at its
+  first ``KVM_RUN``.
+* Set the primary vCPU's boot state with ``KVM_SET_ONE_REG``: the kernel
+  entry address in ``PC`` and the DTB pointer in ``x0``.
+
+``PC`` and ``x0`` are the only registers EL2 takes from the host. Other
+pre-run writes are accepted, but the guest starts from the architectural
+reset values.
+
+Secondary vCPUs are started by the guest itself through PSCI ``CPU_ON``
+(see `Power state`_), which supplies their entry point and context ID.
+The VMM cannot choose where they boot.
+
+vCPU state
+----------
+
+* ``KVM_GET_ONE_REG`` and ``KVM_SET_ONE_REG`` return ``-EPERM`` once the
+  vCPU has run. Before that, they access the host-side copy from which
+  EL2 builds the guest's boot state (see `Boot`_).
+* ``KVM_ARM_VCPU_INIT`` accepts only the vCPU features that a protected
+  guest supports and returns ``-EINVAL`` otherwise.
+  ``KVM_ARM_VCPU_PSCI_0_2`` is required, as EL2 implements PSCI 1.1 for
+  the guest (see `Power state`_). ``KVM_ARM_VCPU_EL1_32BIT`` is not
+  supported: protected guests run in AArch64 only and see no AArch32
+  support in ``ID_AA64PFR0_EL1``. Once the vCPU has run,
+  ``KVM_ARM_VCPU_INIT`` returns ``-EPERM``, as re-initialising it would
+  reset the host-side copy alone.
+* ``KVM_SET_VCPU_EVENTS`` returns ``-EPERM`` for external-abort injection
+  (``ext_dabt_pending``). SError injection is unaffected.
+* ``KVM_SET_GUEST_DEBUG`` returns ``-EPERM`` (see `Debug`_).
+
+Power state
+-----------
+
+EL2 implements PSCI 1.1 for a protected guest. The calls that move a
+vCPU's power state, ``CPU_ON``, ``CPU_OFF`` and ``AFFINITY_INFO``, are
+handled at EL2, and the host cannot change the outcome: for ``CPU_ON``
+the host only schedules the target, which EL2 has already reset to the
+entry point the guest chose, and for ``CPU_OFF`` it only stops
+scheduling it. A vCPU becomes a valid ``CPU_ON`` target at its first
+``KVM_RUN``, and before that EL2 returns ``INVALID_PARAMETERS``. The
+platform calls, ``CPU_SUSPEND``, ``SYSTEM_OFF``, ``SYSTEM_RESET`` and
+``SYSTEM_RESET2``, are forwarded to the host and behave as for a
+non-protected VM, with the ``SYSTEM_*`` calls exiting to the VMM as
+``KVM_EXIT_SYSTEM_EVENT``; the ``SYSTEM_RESET2`` reset type and cookie
+are in the guest's registers, which ``KVM_GET_ONE_REG`` rejects once
+the vCPU has run. Any other function returns ``NOT_SUPPORTED``, and
+``PSCI_FEATURES`` reports the same set. Because the host handles those
+forwarded calls, ``KVM_SET_ONE_REG`` on ``KVM_REG_ARM_PSCI_VERSION``
+returns ``-EINVAL`` for a version below 1.1.
+
+Once a vCPU has run, its power state follows the guest's PSCI calls, not
+the VMM's. ``KVM_SET_MP_STATE`` with ``KVM_MP_STATE_STOPPED`` still stops
+the vCPU, so the VMM can pause it. ``KVM_MP_STATE_RUNNABLE`` and
+``KVM_MP_STATE_SUSPENDED`` return ``-EPERM`` for a vCPU that the guest has
+powered off with ``CPU_OFF``, or has not yet brought online with ``CPU_ON``:
+only an in-guest ``CPU_ON`` can power it on.
+
+Other interface differences
+---------------------------
+
+* ``KVM_CHECK_EXTENSION`` reports only the capabilities that pKVM supports
+  for protected guests, and ``KVM_ENABLE_CAP`` accepts only those. Query
+  them on the VM file descriptor: the system file descriptor has no VM to
+  filter against. The filter does not cover every interface either:
+  device-fd configuration (for example the VGIC after
+  ``KVM_CREATE_DEVICE``) and vCPU attributes are unfiltered, and can refuse
+  what a capability reported as available. ``KVM_ARM_VCPU_PVTIME_CTRL``
+  returns ``-EPERM``, for example, since steal time cannot work for a
+  protected guest.
+* The vGIC of a protected VM remains host-managed: device creation,
+  configuration and interrupt injection all work as they do for a
+  non-protected VM.
+* ``KVM_ARM_SET_COUNTER_OFFSET`` and ``KVM_ARM_GET_REG_WRITABLE_MASKS``
+  return ``-EINVAL``: their capabilities are not offered to a protected
+  VM, whose counter offset and ID registers are set by EL2. A protected
+  guest sees the physical timebase.
+* A protected guest's first access to each page of memory exits to the
+  host, since the hypervisor cannot tell memory from a device before the
+  page is mapped. For a store, the host sees the value of the register
+  the syndrome names, clamped to the access width, and nothing else from
+  the register file.
+* A protected guest that uses a feature it was not given, or executes an
+  ``SMC``, takes an undefined instruction exception from the hypervisor;
+  the host is not involved.
+* The hypervisor handles a protected guest's SMCCC calls itself and does
+  not involve the host. A function it does not implement returns
+  ``NOT_SUPPORTED``.
+* The hypervisor can decode a trapped guest access only from the CPU's
+  instruction syndrome, which is provided only for a load or store of a
+  single general-purpose register. An access without one (for example a
+  load/store pair or a SIMD/FP access) cannot be decoded. For a
+  non-protected VM it can exit to the VMM as ``KVM_EXIT_ARM_NISV``. For a
+  protected VM it cannot be emulated by the VMM, so the guest takes a
+  synchronous external abort instead.
+
+Debug
+-----
+
+Hardware-assisted debugging is not available to protected guests: their
+debug registers are RAZ/WI.
+
 Resources
 =========
 
diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index deb5c51bc00c8..5e571d43e54ca 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -226,12 +226,14 @@ Returns:
 	 -ENXIO   Stolen time not implemented
 	 -EEXIST  Base address already set for this VCPU
 	 -EINVAL  Base address not 64 byte aligned
+	 -EPERM   The VCPU belongs to a protected VM
 	 =======  ======================================
 
 Specifies the base address of the stolen time structure for this VCPU. The
 base address must be 64 byte aligned and exist within a valid guest memory
 region. See Documentation/virt/kvm/arm/pvtime.rst for more information
-including the layout of the stolen time structure.
+including the layout of the stolen time structure. Stolen time is not
+supported for protected VMs (see Documentation/virt/kvm/arm/pkvm.rst).
 
 4. GROUP: KVM_VCPU_TSC_CTRL
 ===========================
-- 
2.39.5

