Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C6A0531B0F
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074383; cv=none; b=SDppLx0gsu9BmM2C9uA9QKpZX9XXtqTkAkzz29SEwAyVDpGnWfEAdzMU0uf34JSTdflfxBL7cDvKQRyVe+8ATSkEzghQZRWWJVMpObKBJDFWVH3jS+Qveu6iw/gpj+OLaeTWxE75aZkLTX1ZZuiYiOQxq34jP5u0EHR69vbGfBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074383; c=relaxed/simple;
	bh=G36qdmTqm2rO4jOwRCiQ4XYdFKdwxjAn5cYS9ovRP7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWj0w+ty3adITOUFnJbi9QthgEqzQgeeGLa3h4cR+U3X1qN7mSwJksjzXvpcjuBCJ5BSOj84rqD0L1LF3tpQlJY/KxOuwshwkmq15unKKnlgbnRjkMktPrjSf0zsFbDbQzq9qZiyHSh9tCdFU6ZTLfZtk4W8z+kUibW6aFFTroo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qgIDJeAA; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qgIDJeAA"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 338861477;
	Thu, 15 Oct 2026 07:26:11 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.2.198.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 768E33F871;
	Thu, 15 Oct 2026 07:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792074374; bh=G36qdmTqm2rO4jOwRCiQ4XYdFKdwxjAn5cYS9ovRP7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgIDJeAA47kbre4VMzYXSsz/jRNOmr+Uidx7bY/PipDt4zyVp+pZA20LZyfXfcJkx
	 F94C+169GFWu5+v0tJ09/nbM5ONBNiUi9S89P6lLbYHJjxwTT4u2XVBNDaies8/3//
	 WJ9pQiFVVXSGlz8owk+LSRbBu9aNNelQ4Y2oomY0=
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
Subject: [RFC PATCH v2 03/15] dt-bindings: misc: Add Arm Core Local Accelerator
Date: Thu, 15 Oct 2026 15:25:37 +0100
Message-ID: <20261015142552.4128028-4-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015142552.4128028-1-ryan.roberts@arm.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Arm Core Local Accelerator (CLA) provides a CPU-local interface to
accelerators that access memory through the local CPU's MMU. CLAs whose
accelerators cannot be isolated from each other form an isolation
domain.

Add a binding for arm,cla describing the register range, CPU
association, DMA coherency and isolation domain. Document the
privilege-level register frames, including reduced ranges exposed to
virtual machines, and provide an example of two CLAs sharing a domain.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 .../devicetree/bindings/misc/arm,cla.yaml     | 77 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 78 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/misc/arm,cla.yaml

diff --git a/Documentation/devicetree/bindings/misc/arm,cla.yaml b/Documentation/devicetree/bindings/misc/arm,cla.yaml
new file mode 100644
index 000000000000..b86a2befd09a
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/arm,cla.yaml
@@ -0,0 +1,77 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/misc/arm,cla.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Arm Core Local Accelerator (CLA)
+
+maintainers:
+  - Ryan Roberts <ryan.roberts@arm.com>
+
+description:
+  A Core Local Accelerator (CLA) provides a CPU-local interface to up to eight
+  accelerators. The accelerators access memory through the local CPU's MMU. Each
+  CLA has its own register range, which can only be accessed by its local CPU.
+  Completion is polled through the registers; CLA does not generate interrupts.
+
+properties:
+  compatible:
+    const: arm,cla
+
+  reg:
+    maxItems: 1
+    description:
+      A single contiguous register range starting at the PL0 frame, aligned to
+      256 KiB. Each privilege-level frame occupies 64 KiB, with PL0, PL1, PL2
+      and PL3 at offsets 0, 0x10000, 0x20000 and 0x30000 respectively. The
+      complete range is 256 KiB. Higher-privilege frames may be omitted when
+      unavailable, for example in a virtual machine. The range must include at
+      least PL0 and PL1 when running at EL1 and additionally PL2 when running at
+      EL2.
+
+  cpu:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      Phandle to the CPU for which this CLA is local. Only that CPU can access
+      the CLA's registers.
+
+  dma-coherent: true
+
+  arm,domain:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      Identifier of the CLA isolation domain. CLAs whose attached accelerators
+      cannot be isolated from each other, for example because they share an
+      inter-accelerator communication bus, must have the same domain ID.
+      Different isolation domains must have different IDs. IDs need not be
+      consecutive. A CLA that can be isolated from all other CLAs has its own
+      domain ID.
+
+required:
+  - compatible
+  - reg
+  - cpu
+  - dma-coherent
+  - arm,domain
+
+additionalProperties: false
+
+examples:
+  - |
+    /* Two CPU-local CLAs in the same isolation domain. */
+    cla@10000000 {
+        compatible = "arm,cla";
+        reg = <0x10000000 0x40000>;
+        cpu = <&cpu0>;
+        dma-coherent;
+        arm,domain = <0>;
+    };
+
+    cla@10040000 {
+        compatible = "arm,cla";
+        reg = <0x10040000 0x40000>;
+        cpu = <&cpu1>;
+        dma-coherent;
+        arm,domain = <0>;
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 735f6527f920..98a25b3de9b4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2213,6 +2213,7 @@ ARM CORE LOCAL ACCELERATOR (CLA) DRIVER
 M:	Ryan Roberts <ryan.roberts@arm.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
+F:	Documentation/devicetree/bindings/misc/arm,cla.yaml
 F:	Documentation/misc-devices/arm-cla.rst
 F:	drivers/misc/arm-cla/
 
-- 
2.43.0

