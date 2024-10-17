Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F73F1DE2A3;
	Thu, 17 Oct 2024 13:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729170934; cv=none; b=YsMgibFr6h4EEseQiC0IBbmzso66M6eAShXkXuDzqia0sfuviuxwKeSwjxVQTw4Ay6dOWAyG7jevK7WxTI0GSleSBzZamtmHE2mLSBt5auDfUVaHHPgzEiMkdFFHrC37eA9vksTqNZ+JoDDPgXnhxNtIFroRYHj86DEoV+effVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729170934; c=relaxed/simple;
	bh=3wJdoA5dNS1r3ppezqAL/BFb4BKcXFOJCt4L4sf/Qt4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SyWj/79HyRIkk1H+JuofpEgVjeQvuZGCLKIVEA5oeTPEMlt6mOOhx3WpEuM+P7SPbYsF2Nilk5v9GsWs5Sgy8K9bLlhJjhNMTFkYC0/5g1yOkOc4J37XUQzkzSC56W+5+ps3YcZxzNh0tQqptL6TdU8uMO0qdo41AWBVuOT7iD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8652DA7;
	Thu, 17 Oct 2024 06:16:00 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 705B53F71E;
	Thu, 17 Oct 2024 06:15:27 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: [PATCH v7 11/11] arm64: Document Arm Confidential Compute
Date: Thu, 17 Oct 2024 14:14:34 +0100
Message-Id: <20241017131434.40935-12-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241017131434.40935-1-steven.price@arm.com>
References: <20241017131434.40935-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add some documentation on Arm CCA and the requirements for running Linux
as a Realm guest. Also update booting.rst to describe the requirement
for RIPAS RAM.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v6:
 * Mention "Realm Services Interface (RSI)" by name.
 * Add a brief explanation of the example earlycon line.
---
 Documentation/arch/arm64/arm-cca.rst | 69 ++++++++++++++++++++++++++++
 Documentation/arch/arm64/booting.rst |  3 ++
 Documentation/arch/arm64/index.rst   |  1 +
 3 files changed, 73 insertions(+)
 create mode 100644 Documentation/arch/arm64/arm-cca.rst

diff --git a/Documentation/arch/arm64/arm-cca.rst b/Documentation/arch/arm64/arm-cca.rst
new file mode 100644
index 000000000000..c48b7d4ab6bd
--- /dev/null
+++ b/Documentation/arch/arm64/arm-cca.rst
@@ -0,0 +1,69 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================================
+Arm Confidential Compute Architecture
+=====================================
+
+Arm systems that support the Realm Management Extension (RME) contain
+hardware to allow a VM guest to be run in a way which protects the code
+and data of the guest from the hypervisor. It extends the older "two
+world" model (Normal and Secure World) into four worlds: Normal, Secure,
+Root and Realm. Linux can then also be run as a guest to a monitor
+running in the Realm world.
+
+The monitor running in the Realm world is known as the Realm Management
+Monitor (RMM) and implements the Realm Management Monitor
+specification[1]. The monitor acts a bit like a hypervisor (e.g. it runs
+in EL2 and manages the stage 2 page tables etc of the guests running in
+Realm world), however much of the control is handled by a hypervisor
+running in the Normal World. The Normal World hypervisor uses the Realm
+Management Interface (RMI) defined by the RMM specification to request
+the RMM to perform operations (e.g. mapping memory or executing a vCPU).
+
+The RMM defines an environment for guests where the address space (IPA)
+is split into two. The lower half is protected - any memory that is
+mapped in this half cannot be seen by the Normal World and the RMM
+restricts what operations the Normal World can perform on this memory
+(e.g. the Normal World cannot replace pages in this region without the
+guest's cooperation). The upper half is shared, the Normal World is free
+to make changes to the pages in this region, and is able to emulate MMIO
+devices in this region too.
+
+A guest running in a Realm may also communicate with the RMM using the
+Realm Services Interface (RSI) to request changes in its environment or
+to perform attestation about its environment. In particular it may
+request that areas of the protected address space are transitioned
+between 'RAM' and 'EMPTY' (in either direction). This allows a Realm
+guest to give up memory to be returned to the Normal World, or to
+request new memory from the Normal World.  Without an explicit request
+from the Realm guest the RMM will otherwise prevent the Normal World
+from making these changes.
+
+Linux as a Realm Guest
+----------------------
+
+To run Linux as a guest within a Realm, the following must be provided
+either by the VMM or by a `boot loader` run in the Realm before Linux:
+
+ * All protected RAM described to Linux (by DT or ACPI) must be marked
+   RIPAS RAM before handing control over to Linux.
+
+ * MMIO devices must be either unprotected (e.g. emulated by the Normal
+   World) or marked RIPAS DEV.
+
+ * MMIO devices emulated by the Normal World and used very early in boot
+   (specifically earlycon) must be specified in the upper half of IPA.
+   For earlycon this can be done by specifying the address on the
+   command line, e.g. with an IPA size of 33 bits and the base address
+   of the emulated UART at 0x1000000: ``earlycon=uart,mmio,0x101000000``
+
+ * Linux will use bounce buffers for communicating with unprotected
+   devices. It will transition some protected memory to RIPAS EMPTY and
+   expect to be able to access unprotected pages at the same IPA address
+   but with the highest valid IPA bit set. The expectation is that the
+   VMM will remove the physical pages from the protected mapping and
+   provide those pages as unprotected pages.
+
+References
+----------
+[1] https://developer.arm.com/documentation/den0137/
diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
index b57776a68f15..30164fb24a24 100644
--- a/Documentation/arch/arm64/booting.rst
+++ b/Documentation/arch/arm64/booting.rst
@@ -41,6 +41,9 @@ to automatically locate and size all RAM, or it may use knowledge of
 the RAM in the machine, or any other method the boot loader designer
 sees fit.)
 
+For Arm Confidential Compute Realms this includes ensuring that all
+protected RAM has a Realm IPA state (RIPAS) of "RAM".
+
 
 2. Setup the device tree
 -------------------------
diff --git a/Documentation/arch/arm64/index.rst b/Documentation/arch/arm64/index.rst
index 78544de0a8a9..12c243c3af20 100644
--- a/Documentation/arch/arm64/index.rst
+++ b/Documentation/arch/arm64/index.rst
@@ -10,6 +10,7 @@ ARM64 Architecture
     acpi_object_usage
     amu
     arm-acpi
+    arm-cca
     asymmetric-32bit
     booting
     cpu-feature-registers
-- 
2.34.1

