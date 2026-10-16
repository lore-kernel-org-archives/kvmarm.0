Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F309A4DB547
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 16:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792166421; cv=none; b=hjDLoC2xGmjgbolDmqPr4SYATLgdER9tFmKc0w2xB1d4XZmw7VVvL2DWKbmHNHtTIfgFk5DRiDz2UO+M/x9ZyL/LyAlpZXZtCPvngx3eWYXVkolVMNRrkvc4F+xtf+YPmxgtGfT/axMc0UtjgN1G0jVFdrybfBoSmKADqUGMZYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792166421; c=relaxed/simple;
	bh=oo1ODDdkU0C7BmGW2+rzO0urjKyPCv5+n0gJX9i22no=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bGmCV7M8K73tFqFpzaPyqlIsW4Sr52o4a84acA/MnPBLoQmJLKTEzsvMlKAsXsk9MqpQdggUoh0VecN6raA2P05P/6hqwMVoTYcx05ag1Yu+XXrANZqwO26r1Dk7H86TuvMHEVyyXVFOlRHagWjnyexE4nM6jNdVofS69btSNxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Iz2CfjQ2; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Iz2CfjQ2"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 213B01516;
	Fri, 16 Oct 2026 09:00:16 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BAF3E3F673;
	Fri, 16 Oct 2026 09:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792166419; bh=oo1ODDdkU0C7BmGW2+rzO0urjKyPCv5+n0gJX9i22no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iz2CfjQ2vcO+GNeMLCkHKFEWjrQB4a2hGNBIIb3x07/vOZXVZHTjEGTmGoEBs5rfl
	 IVFS1UyE/WfIefZ57d0eIhrnKmYB7qKAUBZtDhQyO9jzy2hHZ1Y0jMTrn1yQ+6em+S
	 ixm5Rp0ivP1voYWClA87AvNgbJr+3oTicAAzo9jA=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	peter.maydell@linaro.org,
	lpieralisi@kernel.org,
	timothy.hayes@arm.com,
	fuad.tabba@linux.dev
Subject: [PATCH 16/16] KVM: arm64: gic-v5: Document ITS userspace ABI
Date: Fri, 16 Oct 2026 16:57:41 +0100
Message-Id: <20261016155741.979985-17-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016155741.979985-1-sascha.bischoff@arm.com>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document the GICv5 ITS device and its userspace ABI, including the
MMIO address, reset control, register attributes, and MSI requirements.
State that software should target ITS_TRANSLATER, while KVM uses the
MSI address to identify the virtual ITS.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5-its.rst      | 102 ++++++++++++++++++
 Documentation/virt/kvm/devices/index.rst      |   1 +
 2 files changed, 103 insertions(+)
 create mode 100644 Documentation/virt/kvm/devices/arm-vgic-v5-its.rst

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5-its.rst b/Documentation/virt/kvm/devices/arm-vgic-v5-its.rst
new file mode 100644
index 0000000000000..250057e4445d7
--- /dev/null
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5-its.rst
@@ -0,0 +1,102 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+============================================================
+ARM Virtual Generic Interrupt Controller v5 ITS (VGICv5 ITS)
+============================================================
+
+Device types supported:
+  KVM_DEV_TYPE_ARM_VGIC_V5_ITS    ARM GICv5 Interrupt Translation Service
+
+The GICv5 ITS translates MSI(-X) interrupts into LPIs. It is optional and
+requires a GICv5 host and a KVM_DEV_TYPE_ARM_VGIC_V5 device for the VM. The
+ITS and VGIC devices may be created in either order, but their models must
+match. Userspace should assign each ITS a separate, non-overlapping MMIO
+region.
+
+MSIs injected through KVM_SIGNAL_MSI must provide a DeviceID using
+KVM_MSI_VALID_DEVID. The MSI address should target ITS_TRANSLATER in the
+ITS_TRANSLATE_FRAME. KVM uses the address to identify the virtual ITS, and
+the MSI data supplies the EventID. The virtual ITS supports 16-bit EventIDs;
+the upper 16 bits of the MSI data must be zero.
+
+
+Groups
+======
+
+KVM_DEV_ARM_VGIC_GRP_ADDR
+-------------------------
+
+  Attributes:
+    KVM_VGIC_V5_ADDR_TYPE_ITS (rw, 64-bit)
+      Base address of the ITS in the guest physical address space. The address
+      must be 64K aligned. The region covers 128K: a 64K control frame and a
+      64K translation frame. The address must be set before accessing ITS
+      registers through KVM_DEV_ARM_VGIC_GRP_ITS_REGS. It can only be set once.
+
+  Errors:
+
+    =======  =========================================================
+    -E2BIG   Address outside the guest's addressable IPA range
+    -EINVAL  Address is not 64K aligned, or the 128K range wraps
+    -EEXIST  Address has already been configured
+    -EFAULT  Invalid user pointer for kvm_device_attr.addr
+    -ENODEV  Unsupported address attribute for GET or SET
+    -ENXIO   Unsupported address attribute for HAS
+    -EBUSY   Concurrent address configuration has already set the base
+    -ENOMEM  Unable to allocate space for the MMIO bus entry
+    -ENOSPC  MMIO bus device limit reached
+    =======  =========================================================
+
+
+KVM_DEV_ARM_VGIC_GRP_CTRL
+-------------------------
+
+  Attributes:
+    KVM_DEV_ARM_VGIC_CTRL_INIT
+      Accepted for consistency with other VGIC devices; no additional ITS
+      initialization is required.
+
+    KVM_DEV_ARM_ITS_CTRL_RESET
+      Reset the emulated ITS registers and discard cached translations. The
+      configured MMIO base address is retained. Guest memory containing the
+      device and interrupt translation tables is not modified.
+
+  Errors:
+
+    =======  =========================================================
+    -EBUSY   A vCPU could not be locked for reset
+    -ENXIO   Unsupported control attribute for SET, or any GET
+    =======  =========================================================
+
+
+KVM_DEV_ARM_VGIC_GRP_ITS_REGS
+-----------------------------
+
+  Attributes:
+    The attr field of kvm_device_attr contains the ITS register offset from
+    the control frame base address. kvm_device_attr.addr points to a __u64,
+    regardless of whether the register is 32 or 64 bits wide. A 64-bit
+    register must be addressed at its base offset; userspace cannot access
+    its upper or lower half separately. Guest MMIO may use aligned 32-bit
+    accesses to DT_BASER, DIDR, READ_EVENT_DATAR, and GEN_EVENT_DIDR.
+
+    The ITS base address must be configured before this group can be used.
+    Writes to read-only registers are ignored. Writes to DT_CFGR and DT_BASER
+    through this interface update their values even when the ITS is enabled;
+    guest MMIO writes to those registers are ignored while it is enabled.
+
+    The registers with readable, writable state are CR0, CR1, DT_CFGR,
+    DT_BASER, DIDR, EIDR, GEN_EVENT_DIDR, and GEN_EVENT_EIDR.
+
+    Some registers initiate guest-visible operations when written, including
+    INV_EVENTR, INV_DEVICER, READ_EVENTR, and GEN_EVENTR. READ_EVENT_DATAR is
+    a read-only result register.
+
+  Errors:
+
+    =======  =========================================================
+    -ENXIO   ITS base address is unset, or offset is unsupported
+    -EINVAL  Offset is not aligned to the register width
+    -EFAULT  Invalid user pointer for kvm_device_attr.addr
+    -EBUSY   A vCPU could not be locked
+    =======  =========================================================
diff --git a/Documentation/virt/kvm/devices/index.rst b/Documentation/virt/kvm/devices/index.rst
index 70845aba38f45..d6d64b7266e83 100644
--- a/Documentation/virt/kvm/devices/index.rst
+++ b/Documentation/virt/kvm/devices/index.rst
@@ -11,6 +11,7 @@ Devices
    arm-vgic
    arm-vgic-v3
    arm-vgic-v5
+   arm-vgic-v5-its
    mpic
    s390_flic
    vcpu
-- 
2.34.1

