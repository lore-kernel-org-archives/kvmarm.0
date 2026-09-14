Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F1B44A3F2
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 11:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385776; cv=none; b=Q6uF2GO6EY7vYan2uwij3waX3FD/6Toa15XX7Ot7P7csLMJYNVfz1xxS6WGwq3REAhBB+NJ3cCvqYrtSDdHjG6vCLOvIluFjbTq+yCnT7KQn2Wlk+vVLiUa04D+BGnKFd7MHSplTI/MYSj7ut4FQP80ptopNJyOk7X1k+PIttew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385776; c=relaxed/simple;
	bh=APUhLVxvZ4NjL2wmNvl5uhZlYEFkp8uJNzHvlx4Qlgg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dGf/mHZLWI4xsmu1hWvJVj9o7j5RZODJAJ+eZP4WL16T74dSR7ptzYK9iVV2L0rLxCYdq41xTFkiDqjHpe73CKPUq3FhH/mFtjWmctdYSDD4ZpuK8jlD8I7ZzFXOwkJlMNCBScvGNvagV6KToewENPlLzZQxzJSyxeZgfPU4Y58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SVZx1tEz; arc=none smtp.client-ip=91.218.175.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SVZx1tEz"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=APUhLVxvZ4NjL2wmNvl5uhZlYEFkp8uJNzHvlx4Qlgg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789385771; v=1; x=1789990571;
 b=SVZx1tEzgDK/wk+IAjJJbULl05UQ2MX+TPssWmT7off1yY05AwterVU/+DtW8cgeZba5pibE
 geQua2kXpY4DC3yrpu8K6ahlLpxGThhXv1eG925Y78JELg/N+D2sl6Mu4rLkcelmfky04iekCWG
 3JmDB5YsUFKSv9LH0NKVKiP8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b272b8d6da14a8ba;
	Mon, 14 Sep 2026 11:36:11 +0000
X-Mizu-Trace-ID: b272b8d6da14a8ba
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	steven.price@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	tabba@google.com
Subject: [PATCH v3 18/18] KVM: arm64: Document the protected VM userspace API
Date: Mon, 14 Sep 2026 12:33:38 +0100
Message-Id: <20260914113338.159227-19-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260914113338.159227-1-fuad.tabba@linux.dev>
References: <20260914113338.159227-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EL2 owns a protected vCPU's state once it has run, and the ioctls that
would access it fail rather than silently operate on a copy that isn't
the guest's. Describe the resulting API in pkvm.rst, point api.rst at
it from each ioctl that behaves differently, and say beside the PVTIME
attribute in devices/vcpu.rst and the PSCI version register in
fw-pseudo-registers.rst how protected VMs differ. The overview also
states the GIC support pKVM enforces: GICv2 is not supported in
protected mode (vgic-v2.c) and GICv5-based guests aren't registered
under pKVM (vgic-v5.c).

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 Documentation/virt/kvm/api.rst                |  22 ++-
 .../virt/kvm/arm/fw-pseudo-registers.rst      |   2 +
 Documentation/virt/kvm/arm/pkvm.rst           | 161 +++++++++++++++++-
 Documentation/virt/kvm/devices/vcpu.rst       |   3 +-
 4 files changed, 178 insertions(+), 10 deletions(-)

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
index 514992a79a833..44f7c2126b787 100644
--- a/Documentation/virt/kvm/arm/pkvm.rst
+++ b/Documentation/virt/kvm/arm/pkvm.rst
@@ -15,7 +15,9 @@ Overview
 Booting a host kernel with '``kvm-arm.mode=protected``' enables
 "Protected KVM" (pKVM). During boot, pKVM installs a stage-2 identity
 map page-table for the host and uses it to isolate the hypervisor
-running at EL2 from the rest of the host running at EL1/0.
+running at EL2 from the rest of the host running at EL1/0. pKVM supports
+GICv3 only: GICv2 is not supported in protected mode, and neither are
+GICv5-based guests.
 
 pKVM permits creation of protected virtual machines (pVMs) by passing
 the ``KVM_VM_TYPE_ARM_PROTECTED`` machine type identifier to the
@@ -31,7 +33,7 @@ See hypercalls.rst for more details.
 Isolation mechanisms
 ====================
 
-pKVM relies on a number of mechanisms to isolate PVMs from the host:
+pKVM relies on a number of mechanisms to isolate pVMs from the host:
 
 CPU memory isolation
 --------------------
@@ -50,8 +52,9 @@ stage-2 identity map as part of the donation procedure. This gives rise
 to some user-visible differences when compared to non-protected VMs,
 largely due to the lack of MMU notifiers:
 
-* Memslots cannot be moved or deleted once the pVM has started running.
-* Read-only memslots and dirty logging are not supported.
+* Memslots cannot be moved or deleted once the pVM has started running
+  (``-EPERM``).
+* Read-only memslots and dirty logging are not supported (``-EPERM``).
 * With the exception of swap, file-backed pages cannot be mapped into a
   pVM.
 * Donated pages are accounted against ``RLIMIT_MLOCK`` and so the VMM
@@ -67,12 +70,19 @@ largely due to the lack of MMU notifiers:
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
+hypervisor. The hypervisor sets a protected vCPU's initial state, not the
+host, and only what each exit needs is synchronised back.
+
+The user-visible consequences are described under `API behaviour for
+protected VMs`_.
 
 DMA isolation using an IOMMU
 ----------------------------
@@ -89,13 +99,150 @@ The FF-A proxy ensures that the host cannot share pVM or hypervisor
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
+vCPU ioctls' errors follow one rule: ``-EPERM`` means the host asked for
+state that the guest owns, ``-EINVAL`` means the request is not valid for a
+protected VM, and a feature pKVM doesn't support for protected VMs is
+rejected the way KVM rejects one that isn't implemented (``-ENXIO`` from
+``KVM_ARM_VCPU_PVTIME_CTRL``, for example). The ioctls themselves are
+described in Documentation/virt/kvm/api.rst.
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
+pre-run writes are accepted, but the guest starts from the state the
+hypervisor resets it to.
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
+  (``ext_dabt_pending``), and ``KVM_CAP_ARM_INJECT_EXT_DABT`` is not
+  advertised to a protected VM. SError injection is unaffected.
+* ``KVM_SET_GUEST_DEBUG`` returns ``-EPERM``, and ``KVM_CAP_SET_GUEST_DEBUG``
+  is not advertised to a protected VM (see `Debug`_).
+
+Power state
+-----------
+
+EL2 implements PSCI 1.1 for a protected guest. The calls that move a
+vCPU's power state, ``CPU_ON`` and ``CPU_OFF``, are handled at EL2, and
+the host cannot change the outcome: for ``CPU_ON`` the host only
+schedules the target, which EL2 has already reset to the entry point
+the guest chose, and for ``CPU_OFF`` it only stops scheduling it.
+``AFFINITY_INFO`` is handled by the host, which returns ``OFF`` once
+it has stopped scheduling every vCPU the query covers, as for a
+non-protected VM. A vCPU becomes a valid ``CPU_ON`` target at its first
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
+* ``KVM_CHECK_EXTENSION`` reports only the arm64 capabilities that pKVM
+  supports for protected guests, and ``KVM_ENABLE_CAP`` accepts only
+  those. Query them on the VM file descriptor: the system file descriptor
+  has no VM to filter against. The capabilities the generic KVM code
+  answers itself (``KVM_CAP_SYNC_MMU`` or ``KVM_CAP_DEVICE_CTRL``, for
+  example) are reported as for any VM, and don't mean the feature works
+  for a protected one. The filter does not cover every interface either:
+  device-fd configuration (for example the VGIC after
+  ``KVM_CREATE_DEVICE``) and vCPU attributes are unfiltered, so a feature
+  the filter excludes is rejected by the attribute itself.
+  ``KVM_ARM_VCPU_PVTIME_CTRL`` returns ``-ENXIO``, for example, as it does
+  where steal time isn't implemented.
+* The vGIC of a protected VM remains host-managed: device creation,
+  configuration and interrupt injection all work as they do for a
+  non-protected VM.
+* ``KVM_ARM_SET_COUNTER_OFFSET`` and ``KVM_ARM_GET_REG_WRITABLE_MASKS``
+  return ``-EINVAL``: their capabilities are not advertised to a protected
+  VM, whose counter offset and ID registers are set by EL2. A protected
+  guest sees the physical timebase.
+* A protected guest's first access to each page of memory exits to the
+  host, since the hypervisor cannot tell memory from a device before the
+  page is mapped. For a store, the host sees the value of the register
+  the syndrome names, clamped to the access width, and nothing else from
+  the register file. For a load, the register the syndrome names takes
+  the value the host returns, as for any emulated access.
+* A protected guest that uses a feature it was not given, or executes an
+  ``SMC``, takes an undefined instruction exception from the hypervisor;
+  the host is not involved.
+* Apart from PSCI, the hypervisor handles a protected guest's SMCCC
+  calls itself and does not involve the host. A function it does not
+  implement returns ``NOT_SUPPORTED``, and the host's SMCCC filter does
+  not apply: the VM device attribute ioctls (``KVM_ARM_VM_SMCCC_CTRL``)
+  return ``-EINVAL`` for a protected VM.
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
+Hardware-assisted debugging is not available to protected guests.
+``MDSCR_EL1``, ``OSLAR_EL1``, ``OSLSR_EL1``, ``OSDLR_EL1``, and breakpoint
+and watchpoint 0 are RAZ/WI; any other debug register access takes an
+undefined instruction exception.
+
 Resources
 =========
 
diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index deb5c51bc00c8..916407835acdf 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -231,7 +231,8 @@ Returns:
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

