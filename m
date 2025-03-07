Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B29F8258CEB
	for <kvmarm@lists.linux.dev>; Fri,  7 Mar 2025 22:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741384991; cv=none; b=UUWRazbYrGFNDZgseG9Wmdf2nIvfAUzn5kx/Ef9Wq5UVH2u+r99MtLiGbI+pyvwLhIkighIxVAX7xWsRaQeuBsuSpRCZfu8b5E50/CNJVRJv4rt4eiU6y7k+s6ayDcAR6ciuO//nRKZ5mHkEbOthG/yrvdN65Tv1bfCdhLA5ZIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741384991; c=relaxed/simple;
	bh=OcRFfxdTjWsf6DOk0cwFXdBVoN5459lRKzBvVynoTQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfrwDci1+0zqlgCKMbSTiuRN5VaHfCNShOcePl2xxsawB/UTvknJJ1c7ECojG2FPwzSO8tfZjiQEmYuci/R7HxkMrN8TBGDMfbCeA45wEyTIxtWRWBZobeQSdiwUsZDIEp2P109WwQV09I40IumpEaori4P6gM2mNVEgPohrPDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=dP08kpaQ; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="dP08kpaQ"
Received: from romank-3650.corp.microsoft.com (unknown [131.107.160.188])
	by linux.microsoft.com (Postfix) with ESMTPSA id 2CDDA2038F47;
	Fri,  7 Mar 2025 14:03:08 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2CDDA2038F47
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1741384988;
	bh=iGuHmE2gbtDvOko+hzXt49EHmrzYrq8xqM8VYRFGXqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dP08kpaQ0+FluYjvhFx+l39uxftz+ykdKaCySFFfbst7F4t8LYKRKXhmhyDLM9c4U
	 vV69jsYfc36IetKlG21KRoK0S4xRD3I8jHvNPPosiJqdz4TfyBbfcfZ+4dreINnf5C
	 SS1ztKs4C+kM3RlAitAn+HrbVOiWFbr3tPjumNf4=
From: Roman Kisel <romank@linux.microsoft.com>
To: arnd@arndb.de,
	bhelgaas@google.com,
	bp@alien8.de,
	catalin.marinas@arm.com,
	conor+dt@kernel.org,
	dave.hansen@linux.intel.com,
	decui@microsoft.com,
	haiyangz@microsoft.com,
	hpa@zytor.com,
	joey.gouly@arm.com,
	krzk+dt@kernel.org,
	kw@linux.com,
	kys@microsoft.com,
	lenb@kernel.org,
	lpieralisi@kernel.org,
	manivannan.sadhasivam@linaro.org,
	mark.rutland@arm.com,
	maz@kernel.org,
	mingo@redhat.com,
	oliver.upton@linux.dev,
	rafael@kernel.org,
	robh@kernel.org,
	ssengar@linux.microsoft.com,
	sudeep.holla@arm.com,
	suzuki.poulose@arm.com,
	tglx@linutronix.de,
	wei.liu@kernel.org,
	will@kernel.org,
	yuzenghui@huawei.com,
	devicetree@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org,
	x86@kernel.org
Cc: apais@microsoft.com,
	benhill@microsoft.com,
	bperkins@microsoft.com,
	sunilmut@microsoft.com
Subject: [PATCH hyperv-next v5 07/11] dt-bindings: microsoft,vmbus: Add interrupts and DMA coherence
Date: Fri,  7 Mar 2025 14:02:59 -0800
Message-ID: <20250307220304.247725-8-romank@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250307220304.247725-1-romank@linux.microsoft.com>
References: <20250307220304.247725-1-romank@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To boot on ARM64, VMBus requires configuring interrupts. Missing
DMA coherence property is sub-optimal as the VMBus transations are
cache-coherent.

Add interrupts to be able to boot on ARM64. Add DMA coherence to
avoid doing extra work on maintaining caches on ARM64.

Signed-off-by: Roman Kisel <romank@linux.microsoft.com>
---
 .../devicetree/bindings/bus/microsoft,vmbus.yaml          | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/bus/microsoft,vmbus.yaml b/Documentation/devicetree/bindings/bus/microsoft,vmbus.yaml
index a8d40c766dcd..3ab7d0116626 100644
--- a/Documentation/devicetree/bindings/bus/microsoft,vmbus.yaml
+++ b/Documentation/devicetree/bindings/bus/microsoft,vmbus.yaml
@@ -28,13 +28,16 @@ properties:
 required:
   - compatible
   - ranges
+  - interrupts
   - '#address-cells'
   - '#size-cells'
 
-additionalProperties: false
+additionalProperties: true
 
 examples:
   - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
     soc {
         #address-cells = <2>;
         #size-cells = <1>;
@@ -49,6 +52,9 @@ examples:
                 #address-cells = <2>;
                 #size-cells = <1>;
                 ranges = <0x0f 0xf0000000 0x0f 0xf0000000 0x10000000>;
+                dma-coherent;
+                interrupt-parent = <&gic>;
+                interrupts = <GIC_PPI 2 IRQ_TYPE_EDGE_RISING>;
             };
         };
     };
-- 
2.43.0

