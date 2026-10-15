Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0650B30C632
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074373; cv=none; b=Hiu2GSPBBEzbteQldonkDG49T8F1rT781RD18GZICFEDeQsmwWRXTb2UssGNDQjmZNS4BMmruGd9uz+De6RbArzsEZ8f1Zs+leYuhbILxPImIX8lnRJknJA4wReHC6X4wZLlOAdIEof3IbhJDUm3kfPIzCCrzHB0cHYaU63GpuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074373; c=relaxed/simple;
	bh=MpuS/BwPiNK55oYEFP61hWmcWy5L/vVAO3EXCeEkIZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=amWm7bQcxHpV8P6xFk0UbFT92GVpbVkAvKoo7Tf2UxpozHf9yGPEW1G4DMYcPXyvjeOtJ9R09vV4kE+JKWrmjd0NplyD4WI9L+Pxs3siqdcK5ah4HpER7D5+8yIJeqDbenvjT5KSJwyPeFPuYXkxYqdrcLUcCk7Ct6WzVHIc40w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PSY9qW5R; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PSY9qW5R"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 090661516;
	Thu, 15 Oct 2026 07:26:04 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.2.198.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F05063F871;
	Thu, 15 Oct 2026 07:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792074367; bh=MpuS/BwPiNK55oYEFP61hWmcWy5L/vVAO3EXCeEkIZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSY9qW5RiUU+ApXlD3jFgFIBn/MPTF+jym82EGjdwW4SEfZ4+EDaoSBzTU4fs3uRA
	 oiygjuHXApwuXNMwLFtTN74x1y6rVztOikfbfbX3C8AfguwI6OUV+cJTE6Lt33VdxT
	 sTldaWQSeLttsh4+RxilBcG4QDUUOeKlCfLyayNg=
From: Ryan Roberts <ryan.roberts@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Alex Williamson <alex@shazbot.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	Oded Gabbay <ogabbay@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-doc@vger.kernel.org
Subject: [RFC PATCH v2 01/15] misc/arm-cla: Add driver skeleton and documentation
Date: Thu, 15 Oct 2026 15:25:35 +0100
Message-ID: <20261015142552.4128028-2-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015142552.4128028-1-ryan.roberts@arm.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jean-Philippe Brucker <jpb@kernel.org>

Add the initial Kconfig and build-system plumbing for the Arm Core Local
Accelerator driver.

Introduce the common driver header and register definitions used by
later CLA support. The definitions cover the CLA MMIO frame, launch
response and status fields, standard accelerator registers, launch
opcodes, error codes and memory translation context state.

Add documentation describing the CLA programming model, its CPU-local
MMIO access rules, userspace assignment model, domain grouping and
expected boot state.

Co-developed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Jean-Philippe Brucker <jpb@kernel.org>
---
 Documentation/misc-devices/arm-cla.rst | 217 +++++++++++++++++++++++++
 Documentation/misc-devices/index.rst   |   1 +
 MAINTAINERS                            |   7 +
 drivers/misc/Kconfig                   |   1 +
 drivers/misc/Makefile                  |   1 +
 drivers/misc/arm-cla/Kconfig           |  10 ++
 drivers/misc/arm-cla/Makefile          |   1 +
 drivers/misc/arm-cla/arm-cla-regs.h    | 178 ++++++++++++++++++++
 drivers/misc/arm-cla/arm-cla.h         |  36 ++++
 9 files changed, 452 insertions(+)
 create mode 100644 Documentation/misc-devices/arm-cla.rst
 create mode 100644 drivers/misc/arm-cla/Kconfig
 create mode 100644 drivers/misc/arm-cla/Makefile
 create mode 100644 drivers/misc/arm-cla/arm-cla-regs.h
 create mode 100644 drivers/misc/arm-cla/arm-cla.h

diff --git a/Documentation/misc-devices/arm-cla.rst b/Documentation/misc-devices/arm-cla.rst
new file mode 100644
index 000000000000..6ce38b9b7e61
--- /dev/null
+++ b/Documentation/misc-devices/arm-cla.rst
@@ -0,0 +1,217 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+================================
+Arm Core Local Accelerator (CLA)
+================================
+
+Arm CLA is an interface local to a CPU for programming accelerators that access
+memory via the CPU's MMU::
+
+              ┌───────┬───────┬───────┐  ┌───────┐
+              │  CPU  │  MMU  │  CLA  │  │ Accel │─┐
+              │       │       │       │  │       │ │
+              │      ---MMIO-->       <-->       │ │
+              │       │       │       │  │       │ │
+              │       │    ,-----DMA----->       │ │
+              └───────┴────|──┴───────┘  └───────┘ │
+                ┌──────────v────────┐      └───────┘
+                │ Caches and memory │
+                └───────────────────┘
+
+
+Hardware
+========
+
+The CLA supports up to 8 attached accelerators, which are accessed by
+programming the CLA's MMIO registers. Operations are launched to an accelerator
+and are polled for completion. CLA does not raise interrupts.
+
+::
+
+            CPU                     CLA              Accel
+             |--- write DATA[7:0] -->|                 |
+             |--- write LAUNCH ----->|---- launch ---->|
+             |<--- poll LRESP -------|                 |
+             |                       |                 |
+             |<--- poll STATUS ------|<--- complete ---|
+
+Each operation can take a 512-bit payload in the DATA registers. After handling
+a LAUNCH write, CLA indicates the launch status in the LRESP register. A further
+operation can only be launched after LRESP indicates completion of the previous
+launch.
+
+Some operations continue to run asynchronously on the accelerator after launch
+completion. In this case progress is tracked by polling the STATUS register.
+When the CLA updates the STATUS register, it also raises an event which will
+wake an in-progress WFE (wait for event) instruction on the local CPU.
+
+The CLA's MMIO registers are not accessible from remote CPUs. Although each CLA
+has a unique physical address, accesses from remote CPUs are read as zero and
+write ignored.
+
+The CLA registers are accessible from four different Privilege Level (PL)
+frames, with usage inteded to map to EL0 - EL3. The PLxCTRL registers may be
+written via a higher PL frame to suppress access to accelerators via a lower PL
+frame.
+
+The CPU and CLA share an MMU, although FEAT_TTCNP (common not private) is
+implemented, allowing both CPU and CLA to independently opt into and out of
+sharing TLB entries at runtime. TLB invalidation is performed via the CPU TLBI
+instructions; any TLBI instruction that targets the CLA's local CPU will also
+implicitly target the CLA.
+
+CLA has its own set of Memory Translation Context (MTC) registers, distinct from
+the CPU. A PL can set the MTC registers corresponding to an equivalent CPU
+Exception Level (EL) (eg. TCR_EL2 configurable only from the PL2 and PL3 MMIO
+frame).
+
+Faults during address translation are reported by the accelerator in its
+registers and in STATUS. While polling for work completion, software fixes up
+the faults and notifies the accelerator with RESOLVE operations.
+
+Accesses to the MMIO registers must be aligned 64-bit loads and stores, and the
+registers are mapped with Device-nGnRE attribute. Invalid accesses (unaligned,
+atomic, badly sized, etc) to the MMIO frame are either read as zero and write
+ignored, or cause a data abort, depending on the platform. Invalid access will
+never cause an SError.
+
+
+Inter-Accelerator Communication
+-------------------------------
+
+On some platforms, multiple accelerators, each attached to a separate CLA within
+a cluster, are also directly connected to each other via a shared bus to
+accelerate cooperation between accelerators. The accelerators sharing a bus
+cannot be isolated from each other. When collaborative operations are launched
+on each of the participating accelerators, they synchronize over the bus,
+stalling until all are ready.
+
+
+Intended SW Usage Model
+=======================
+
+CLA is designed for its PL0 MMIO frame to be mapped into user space and for user
+space to directly launch accelerator operations and poll for completion. It has
+been observed that for some use cases, the operation execution time is small and
+a trip through the kernel would consume a significant amount of the CPU budget
+for preparing the next operation leading to a significant reduction in bandwidth
+through the accelerator.
+
+User space software is expected to create a thread to drive each CLA it is
+using, and for each thread to be pinned to the CLA's local CPU.
+
+Software should rely on WFE (wait for event) to reduce power consumption when
+polling STATUS.
+
+The CLA is intended to be configured, by privileged software via PL1 and/or PL2,
+so that it shares virtual addresses with the process to which it is assigned
+(SVA). In practice this means configuring the CLA's MTC to point to the same
+page tables and use the same ASID (and VMID if relevant) as the process to which
+it is assigned. This ensures the architectural TLB invalidations also correctly
+target the CLA's TLB entries.
+
+We investigated the possibility of having the CLA driver allocate private page
+tables, private ASIDs/VMIDs and implement an MMU notifier for invalidation, but
+that suffers from 2 issues; there is a possibility of over-invalidation since
+the ASID and VMID spaces overlap with the CPU's (minor), and when issuing a
+TLBI, VMID is implicitly taken from CPU's VTTBR_EL2.VMID, which won't match the
+CLA's private VMID - therefore, for a virtualization scenario, TLB invalidation
+becomes impossible (major).
+
+Because the CLA has its own MTC registers, it is correct and safe for it to be
+executing an operation on behalf of user process A, while its local CPU is
+executing a thread from user process B.
+
+
+Difficulties for software to deal with
+--------------------------------------
+
+Although each CLA is attached to a single CPU, not all CPUs have a CLA, and CLAs
+may have a different set of accelerators attached. Users need to probe around to
+find a suitable accelerator and bind their process to it.
+
+Since remote CPUs can't access the CLA, dealing with CPU hotplug migrating tasks
+is challenging. And virtualization breaks down if the hypervisor cannot
+guarantee that a vCPU is pinned to a CPU.
+
+Saving and restoring the internal state of the accelerator is an optional
+feature. If an accelerator cannot preserve in-flight work, preempting it cancels
+that work. Software must carefully consider how to balance forward-progress
+guarantees with preemption latency.
+
+
+Driver
+======
+
+Booting
+-------
+
+A host expects to be booted with CLAs in the following state:
+
+- All attached accelerators have STATUS_IDLE set.
+- PL2CTRL: AVAIL all enabled for attached accelerators.
+  DBG at the firmware's discretion, preferably all enabled.
+- TSCTRLOWNER.PL, TSOFFOWNER.PL, PMUOWNER.PL all EL2.
+
+A guest expects to be booted with CLAs in the following state:
+
+- All attached accelerators have STATUS_IDLE set.
+- PL1CTRL: AVAIL all enabled for attached accelerators.
+  DBG at the hypervisor's discretion, preferably all enabled.
+
+Linux discovers the base address of each CLA device in the firmware tables and
+creates platform devices. cla_dev behaves mostly like a regular platform device,
+but it can only be accessed from one specific CPU. CPU hotplug notifiers probe
+and teardown the CLA device.
+
+CLAs may be grouped into domains. The topology is described in the firmware
+tables, and the driver creates cla_domain objects containing one or more
+cla_dev.
+
+
+Assignment to userspace
+-----------------------
+
+One char device per accelerator class provides enumeration and mmap abilities
+through ``/dev/cla/<class-id>``. Accelerators belong to the same class when
+their IIDR.IMPLEMENTER and IIDR.PRODUCTID register values match. ``<class-id>``
+is encoded as ``<IIDR.IMPLEMENTER:IIDR.PRODUCTID>``, each part using 3 hex
+digits. All class files enumerate all physical CLAs, with the same device IDs,
+domain IDs and mmap offsets. ``ARM_CLA_PARAM_DEV_ACCELS`` reports only the
+accelerator slots belonging to the opened class, and may be zero.
+
+The user task queries the driver to find a suitable set of CLAs, and mmaps their
+registers. For each mapped domain, the driver creates a cla_ctx context. When
+the user accesses the registers, the driver's fault handler queues the cla_ctx
+and waits for assignment. A context reassignment switches the whole cla_domain,
+by calling each CPU in the domain to switch the CLA context. A time slice is
+given to each context before being deassigned.
+
+In order to access the registers, the task must be bound to the CLA's CPU with
+sched_setaffinity(). Accesses from remote CPUs are ignored. If the CPU gets
+offlined, the task is migrated to an online CPU, and the driver disables the
+offlined CLA. User space may choose to use a mechanism such as restartable
+sequences to be notified when its task has been migrated away from its intended
+CLA.
+
+The accelerators access memory using the CPU's MMU. When assigning a context,
+the driver sets up the CLA's Memory Translation Context (MTC) with the page
+directory (TTBR), address space ID (ASID) and configuration (TCR) of the
+context's mm. When receiving translation faults from the accelerator, the user
+space task accesses the faulting address from the CPU to trigger the fault to be
+fixed up by the kernel before launching a RESOLVE operation to the accelerator.
+
+
+Power management
+----------------
+
+When a CPU enters a deep low-power state, then depending on the platform, the
+attached CLA and accelerators might not retain their state. In that case the
+firmware is expected to save the CLA and accelerator states before entering CPU
+low-power state, and restore them after exiting. The CLA driver does not expect
+to notice a CPU deep idle. However, if an accelerator does not support context
+saving, userspace will notice from the STATUS register that its work was
+canceled during deep idle. Given that userspace would be polling STATUS, the CPU
+is unlikely to enter deep idle while the CLA is running. To ensure
+forward-progress the admin can disable deep idle states (see
+Documentation/admin-guide/pm/cpuidle.rst).
diff --git a/Documentation/misc-devices/index.rst b/Documentation/misc-devices/index.rst
index f911edaecbfa..419c8f5c04ef 100644
--- a/Documentation/misc-devices/index.rst
+++ b/Documentation/misc-devices/index.rst
@@ -13,6 +13,7 @@ fit into other categories.
 
    ad525x_dpot
    amd-sbi
+   arm-cla
    bh1770glc
    c2port
    dw-xdata-pcie
diff --git a/MAINTAINERS b/MAINTAINERS
index 72294ddfa5b7..735f6527f920 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2209,6 +2209,13 @@ F:	arch/arm64/include/asm/arch_timer.h
 F:	drivers/clocksource/arm_arch_timer.c
 F:	drivers/clocksource/arm_arch_timer_mmio.c
 
+ARM CORE LOCAL ACCELERATOR (CLA) DRIVER
+M:	Ryan Roberts <ryan.roberts@arm.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Supported
+F:	Documentation/misc-devices/arm-cla.rst
+F:	drivers/misc/arm-cla/
+
 ARM ETHOS-U NPU DRIVER
 M:	Rob Herring (Arm) <robh@kernel.org>
 M:	Tomeu Vizoso <tomeu@tomeuvizoso.net>
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 7364931dad3a..1f50c9d39b4c 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -586,4 +586,5 @@ source "drivers/misc/keba/Kconfig"
 source "drivers/misc/amd-sbi/Kconfig"
 source "drivers/misc/rp1/Kconfig"
 source "drivers/misc/issei/Kconfig"
+source "drivers/misc/arm-cla/Kconfig"
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index e8d8d5d88c0d..2615190fee17 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -71,3 +71,4 @@ obj-y				+= keba/
 obj-y				+= amd-sbi/
 obj-$(CONFIG_MISC_RP1)		+= rp1/
 obj-$(CONFIG_INTEL_SSEI)	+= issei/
+obj-$(CONFIG_ARM_CLA)		+= arm-cla/
diff --git a/drivers/misc/arm-cla/Kconfig b/drivers/misc/arm-cla/Kconfig
new file mode 100644
index 000000000000..f8436a12c1e6
--- /dev/null
+++ b/drivers/misc/arm-cla/Kconfig
@@ -0,0 +1,10 @@
+config ARM_CLA
+	tristate "Arm Core Local Accelerator"
+	default n
+	depends on ARM64
+	help
+	  Arm Core Local Accelerator (CLA) is coupled with a specific CPU and
+	  provides an interface to enumerate and access attached hardware
+	  accelerators. It is only accessible from its associated CPU.
+
+	  If unsure, say N.
diff --git a/drivers/misc/arm-cla/Makefile b/drivers/misc/arm-cla/Makefile
new file mode 100644
index 000000000000..a4e40e534e6a
--- /dev/null
+++ b/drivers/misc/arm-cla/Makefile
@@ -0,0 +1 @@
+# SPDX-License-Identifier: GPL-2.0-only
diff --git a/drivers/misc/arm-cla/arm-cla-regs.h b/drivers/misc/arm-cla/arm-cla-regs.h
new file mode 100644
index 000000000000..d20a88780032
--- /dev/null
+++ b/drivers/misc/arm-cla/arm-cla-regs.h
@@ -0,0 +1,178 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Arm CLA driver - register definitions
+ *
+ * Copyright 2026 Arm Limited.
+ */
+#ifndef _ARM_CLA_REGS_H_
+#define _ARM_CLA_REGS_H_
+
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+#include <linux/types.h>
+
+/* Registers */
+#define CLA_REG_DATA(i)			(0x00 + (8 * (i)))
+#define CLA_REG_LAUNCH			0x40
+#define CLA_REG_LRESP			0x48
+#define CLA_REG_PL0CTRL			0x60
+#define CLA_REG_PL1CTRL			0x68
+#define CLA_REG_PL2CTRL			0x70
+#define CLA_REG_EVENT			0x78
+#define CLA_REG_STATUS(i)		(0x80 + (8 * (i)))
+#define CLA_REG_CLAAIDR			0xC0
+
+#define CLA_LAUNCH_OP			GENMASK(3, 0)
+#define CLA_LAUNCH_NDATA_M1		GENMASK(6, 4)
+#define CLA_LAUNCH_SEQ			BIT(7)
+#define CLA_LAUNCH_ACCID		GENMASK(10, 8)
+#define CLA_LAUNCH_REGIDX		GENMASK(63, 32)
+
+#define CLA_LRESP_PENDING		BIT(0)
+#define CLA_LRESP_CODE			GENMASK(2, 1)
+#define CLA_LRESP_ERRCODE		GENMASK(7, 3)
+#define CLA_LRESP_DATANZ		BIT(15)
+
+#define CLA_PLxCTRL_AVAIL		BIT(0)
+#define CLA_PLxCTRL_DBGPERM		GENMASK(3, 1)
+#define CLA_PLxCTRL_PREP(accid, v)	((u64)(v) << (8 * (accid)))
+
+#define CLA_STATUS_AVAIL		BIT(0)
+#define CLA_STATUS_DMB			BIT(1)
+#define CLA_STATUS_EABORT		BIT(2)
+#define CLA_STATUS_IDLE			BIT(4)
+#define CLA_STATUS_READY		BIT(5)
+#define CLA_STATUS_FAULT		BIT(6)
+#define CLA_STATUS_EXCEPT		BIT(7)
+#define CLA_STATUS_SRMODE		BIT(8)
+#define CLA_STATUS_USER			GENMASK(63, 16)
+
+/* Some useful values for sanity checks */
+#define CLA_STATUS_STATE_IDLE		(CLA_STATUS_AVAIL | \
+					 CLA_STATUS_IDLE | \
+					 CLA_STATUS_READY)
+#define CLA_STATUS_STATE_SRMODE		(CLA_STATUS_AVAIL | \
+					 CLA_STATUS_IDLE | \
+					 CLA_STATUS_READY | \
+					 CLA_STATUS_SRMODE)
+/* Bits we care about when checking the state */
+#define CLA_STATUS_STATE_MASK		(CLA_STATUS_AVAIL | \
+					 CLA_STATUS_EABORT | \
+					 CLA_STATUS_IDLE | \
+					 CLA_STATUS_READY | \
+					 CLA_STATUS_FAULT | \
+					 CLA_STATUS_EXCEPT | \
+					 CLA_STATUS_SRMODE)
+
+/* Standard accelerator registers */
+#define CLA_REG_IIDR			0x0000
+#define CLA_REG_DEVARCH			0x0001
+#define CLA_REG_REVIDR			0x0002
+#define CLA_REG_IASSIZE			0x0003
+#define CLA_REG_ACAP			0x0004
+#define CLA_REG_FSARV			0x001f
+#define CLA_REG_FSAR(n)			(0x0020 + (n))
+#define CLA_REG_TSCTRLOWNER		0x00c0
+#define CLA_REG_TSCTRL			0x00c8
+#define CLA_REG_TSOFFOWNER		0x00d0
+#define CLA_REG_TSVOFF			0x00d8
+#define CLA_REG_TSPOFF			0x00d9
+#define CLA_REG_PMUOWNER		0x0100
+#define CLA_REG_PMURESET		0x0108
+#define CLA_REG_PMUCTRL			0x0110
+#define CLA_REG_PMUSNAP			0x0111
+#define CLA_REG_PMUEVT(n)		(0x0120 + (n))
+#define CLA_REG_PMUCNT(n)		(0x0140 + (n))
+#define CLA_REG_PMUSCNT(n)		(0x0160 + (n))
+#define CLA_REG_IASn			0x8000
+
+#define CLA_IIDR_PRODUCTID		GENMASK(31, 20)
+#define CLA_IIDR_VARIANT		GENMASK(19, 16)
+#define CLA_IIDR_REVISION		GENMASK(15, 12)
+#define CLA_IIDR_IMPLEMENTER		GENMASK(11, 0)
+
+#define CLA_DEVARCH_ARCHITECT		GENMASK(31, 21)
+#define CLA_DEVARCH_PRESENT		BIT(20)
+#define CLA_DEVARCH_REVISION		GENMASK(19, 16)
+#define CLA_DEVARCH_ARCHID		GENMASK(15, 0)
+
+#define CLA_REVIDR_REVISION		GENMASK(31, 0)
+
+#define CLA_ACAP_SROP			BIT(0)
+#define CLA_ACAP_REGSTATE		BIT(1)
+#define CLA_ACAP_PMUCNTS		GENMASK(4, 2)
+#define CLA_ACAP_TS			BIT(5)
+
+#define CLA_FSAR_READ			BIT(0)
+#define CLA_FSAR_WRITE			BIT(1)
+#define CLA_FSAR_ADDR			GENMASK(63, 6)
+
+#define CLA_TSCTRLOWNER_PL		GENMASK(1, 0)
+#define CLA_TSCTRL_TS			GENMASK(1, 0)
+#define CLA_TSOFFOWNER_PL		GENMASK(1, 0)
+
+#define CLA_TSCTRL_ZERO			0
+#define CLA_TSCTRL_VIRTUAL		1
+#define CLA_TSCTRL_GUESTPHYSICAL	2
+#define CLA_TSCTRL_PHYSICAL		3
+
+#define CLA_PMUCTRL_EN			BIT(0)
+#define CLA_PMUOWNER_PL			GENMASK(1, 0)
+
+/* LAUNCH operations */
+#define CLA_LAUNCH_OP_RESET		0
+#define CLA_LAUNCH_OP_CMD		1
+#define CLA_LAUNCH_OP_CMDNR		2
+#define CLA_LAUNCH_OP_ENTERSR		4
+#define CLA_LAUNCH_OP_EXITSR		5
+#define CLA_LAUNCH_OP_SAVE		6
+#define CLA_LAUNCH_OP_RESTORE		7
+#define CLA_LAUNCH_OP_RESOLVE		9
+#define CLA_LAUNCH_OP_REGREAD		10
+#define CLA_LAUNCH_OP_REGWRITE		11
+#define CLA_LAUNCH_OP_SETCTX		12
+#define CLA_LAUNCH_OP_GETCTX		13
+
+/* Return codes */
+#define CLA_LRESP_OK			0
+#define CLA_LRESP_UNAVAIL		1
+#define CLA_LRESP_BUSY			2
+#define CLA_LRESP_ERROR			3
+
+#define CLA_ERRCODE_CSINT		0
+#define CLA_ERRCODE_CSOF		1
+#define CLA_ERRCODE_NOTIDLE		2
+#define CLA_ERRCODE_PERM		3
+#define CLA_ERRCODE_NOACC		4
+#define CLA_ERRCODE_INVAL		5
+#define CLA_ERRCODE_RESET		6
+
+/* Memory translation context */
+#define CLA_MTC_REGIDX_PL1		0
+#define CLA_MTC_REGIDX_PL2		64
+#define CLA_MTC_PL_SIZE			64
+
+/* Common register offsets */
+#define CLA_MTC_PSTATE			0
+#define CLA_MTC_TTBR0			1
+#define CLA_MTC_TTBR1			2
+#define CLA_MTC_TCR			3
+#define CLA_MTC_SCTLR			4
+#define CLA_MTC_MAIR			5
+#define CLA_MTC_TCR2			8
+
+/* EL2 specific register offsets */
+#define CLA_MTC_HCR_EL2			80
+#define CLA_MTC_VTTBR_EL2		81
+#define CLA_MTC_VTCR_EL2		82
+
+#define CLA_MTC_PSTATE_EL		GENMASK(1, 0)
+#define CLA_MTC_PSTATE_PAN		BIT(2)
+
+#define CLA_SRSTATE_0_SROP		BIT(0)
+#define CLA_SRSTATE_0_REGSTATE		GENMASK(15, 1)
+#define CLA_SRSTATE_1_STATUS		GENMASK(63, 0)
+#define CLA_SRSTATE_2_SRACTIVE		GENMASK(1, 0)
+#define CLA_SRSTATE_2_ADDR_MASK		GENMASK(63, 6)
+
+#endif /* _ARM_CLA_REGS_H_ */
diff --git a/drivers/misc/arm-cla/arm-cla.h b/drivers/misc/arm-cla/arm-cla.h
new file mode 100644
index 000000000000..1e8ffca28bc6
--- /dev/null
+++ b/drivers/misc/arm-cla/arm-cla.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Arm CLA driver - internal definitions
+ *
+ * Copyright 2026 Arm Limited.
+ */
+#ifndef _ARM_CLA_H_
+#define _ARM_CLA_H_
+
+#include "arm-cla-regs.h"
+
+/* Number of accelerators per CLA */
+#define CLA_NUM_ACC		8
+#define CLA_NUM_DATA_REGS	8
+#define CLA_SRSTATE_LEN		8
+
+/**
+ * struct cla_dev - CLA device
+ *
+ * Immutable state:
+ * @cpu:		The CPU this CLA is attached to.
+ * @dev:		The platform device.
+ */
+struct cla_dev {
+	unsigned int cpu;
+	struct device *dev;
+};
+
+#define cla_dbg(_dev, fmt, ...) \
+	dev_dbg((_dev)->dev, "[%u] " fmt, (_dev)->cpu, ##__VA_ARGS__)
+#define cla_info(_dev, fmt, ...) \
+	dev_info((_dev)->dev, "[%u] " fmt, (_dev)->cpu, ##__VA_ARGS__)
+#define cla_err(_dev, fmt, ...) \
+	dev_err((_dev)->dev, "[%u] " fmt, (_dev)->cpu, ##__VA_ARGS__)
+
+#endif /* _ARM_CLA_H_ */
-- 
2.43.0

