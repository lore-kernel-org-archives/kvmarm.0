Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9A9C519E02
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165310; cv=none; b=idyaoNFJMHKqYja2I1zcOQYPWUTUpQfMJ/lHmxkKw/N2afoOgfCMmjS9m7B650QubJWrLlbre+uyCDYC9TxSyzvUQ6ZQXChkG6r1IYh5yjVxhncP5SEGrKeXrgyHFUrL3gIXmJwKN61wZD15mw4y/4+pd8tclJKy+O48tOz7VUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165310; c=relaxed/simple;
	bh=B1TsIa8ZBm5/aeOAXbJRZxpXsHgksywkL/U2HQnR0AQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nkXF7zK/AUWjhlM5pUl4okr0J6iXfyonwiVsx+Ap7M18HnBZRK3CXbapoIyOOP2UTGSrJpWS8bhD3yg/SaGe7tElCPd8zBflOCvPzah+gJgaCxE/8LkUn1hNqPjQ8RWoA82UxyZZ1Rw4ydRASAHr+mYVakRFEeOvA6Ikehvtdlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=t2QZoXjU; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="t2QZoXjU"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C1A41691;
	Fri, 16 Oct 2026 08:41:45 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 70CE33F673;
	Fri, 16 Oct 2026 08:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792165308; bh=B1TsIa8ZBm5/aeOAXbJRZxpXsHgksywkL/U2HQnR0AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2QZoXjU1hqCnoJnaw+8ggj+LE3qth3ZbGdHLa291x6Zzy27PfNrCsmAb3jMfWCj2
	 ecQSHUsRtmO2/emkAuwZR/+jl3S0zD2AqxxiUGbajDxfYIf//H546T9O86ccwUeMfD
	 6LGICGXWvCglao9as6Qsu03ZXQ93BKD4+V1DECS4=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v3 15/21] arm64: Generate GICv5 PCI INTx specifiers
Date: Fri, 16 Oct 2026 16:39:33 +0100
Message-Id: <20261016153939.913764-16-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016153939.913764-1-sascha.bischoff@arm.com>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PCI interrupt-map entries currently use the GICv2/v3 SPI type and an
IRQ number with the SPI base subtracted. GICv5 uses a different SPI
type (matching the hardware) and zero-based SPI numbers. Use the GICv5
encoding for its INTx entries while retaining the existing encoding
for other GICs.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/pci.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arm64/pci.c b/arm64/pci.c
index db87db8b..0ba2f9c9 100644
--- a/arm64/pci.c
+++ b/arm64/pci.c
@@ -84,6 +84,7 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 		u8 pin = pci_hdr->irq_pin;
 		u8 irq = pci_hdr->irq_line;
 		u32 irq_flags = pci_hdr->irq_type;
+		u32 int_type, int_id;
 
 		/*
 		 * Avoid adding entries in "interrupt-map" for devices that
@@ -95,6 +96,14 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 			continue;
 		}
 
+		if (!gic__is_v5()) {
+			int_type = GIC_FDT_IRQ_TYPE_SPI;
+			int_id = irq - GIC_SPI_IRQ_BASE;
+		} else {
+			int_type = GICV5_IRQ_TYPE_SPI;
+			int_id = irq;
+		}
+
 		*entry = (struct of_interrupt_map_entry) {
 			.pci_irq_mask = {
 				.pci_addr = {
@@ -108,8 +117,8 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 			.gic_addr_hi	= 0,
 			.gic_addr_lo	= 0,
 			.gic_irq = {
-				.type	= cpu_to_fdt32(GIC_FDT_IRQ_TYPE_SPI),
-				.num	= cpu_to_fdt32(irq - GIC_SPI_IRQ_BASE),
+				.type	= cpu_to_fdt32(int_type),
+				.num	= cpu_to_fdt32(int_id),
 				.flags	= cpu_to_fdt32(irq_flags),
 			},
 		};
-- 
2.34.1

