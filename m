Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798981;
	b=MmbRycpwZddyIvI2dZ7YuiS998PNzRI18qyky5p2VKoz5u/pM5y54jc8w/doLY2Ins+v
	 NU9VAk7xr6qaU+z6Q4QFHcZy420ULPSuPOABHzi7r0FAJekQE1L2ZPvwbMkObxgS+Jt5g
	 eKKYJ9thHLvgo4QsXg55DkJSxDdJnUUqyr+OVu8SA8eP/5AR/EWNsw/FgNa1g6OakMp4n
	 B4fNU1PSyvISQSkhECKXT0UtYdXUpu+GfmwWCCUyc3xNvCoB8DRxePponlIUVwJDXrqUH
	 DXEceVxGDBJ9VrkBJo3wWE2a31+ovhojrAuzVuV3sfKj1mc7Eyvjw4s46x2ntCJcezw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798981;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tVFHv5fcDxduoe5rLK81/cHawUIwJ7k88sNX30nlvJU=;
	b=vTNQ78lvV/k7xhXCMF94ac5njfZ4FeEMslEypaGoN8iIOwVkuBdyuT3wlD+2FzOQohzX
	 VWEwFwTgqyErLgdyg/z4BjbojR4hHNfdlfiXAdlhMWgvDqNGlSu5RTSgxFagBLC5xjy/f
	 pAv9GQTuy+c29YUQ2z+DKsVUoxWXz4ncAGKi+Z1MfTHbASj3jDZMjaqSgvjYMrbyoEuHB
	 9mNXUgVC7Gn1jOf1f4ComkaTz5aWw5bAK3tVHtUIbOk94OfrRNpP3GCOvgizhWVgI8nwq
	 I41qd1mL3w33O/EQXdJrkG4yBtatRafKBNz9iOeoYZhpBPOpeRmUgar3hGcy1MXLtig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dYvoilDT;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA0AB606A31F
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 17:03:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA0AB606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dYvoilDT
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B2D5169E;
	Fri, 27 Nov 2026 09:02:57 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF13E3F632;
	Fri, 27 Nov 2026 09:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795798980; bh=CZm0vDwtQsuU0m2+h4bJjr5Hus88SeA5JbAb2h2Ly1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYvoilDTdRCe2wA9z9acC5aahCeC/z3tulviwL+4i+xAQKTeZgA0EqCNk47A6D6ke
	 zdClWNzbvLjIC4aFE2dNVrwX4oEZG4rek/RU4opEUb1Yr9OW4QP8BB3fzxuu47eWMv
	 GFbBB8Rm1twXn74IsC4PnNrKWQeHWLe9kfdYkJ0Y=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v7 17/23] arm64: Generate GICv5 PCI INTx specifiers
Date: Fri, 27 Nov 2026 17:01:39 +0000
Message-Id: <20261127170145.4138182-18-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261127170145.4138182-1-sascha.bischoff@arm.com>
References: <20261127170145.4138182-1-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PCI interrupt-map entries currently use the GICv2/v3 SPI type and an
IRQ number with the SPI base subtracted. GICv5 uses a different SPI
type (matching the hardware) and zero-based SPI numbers. Use the GICv5
encoding for its INTx entries while retaining the existing encoding
for other GICs.

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/pci.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arm64/pci.c b/arm64/pci.c
index db87db8b..91265f67 100644
--- a/arm64/pci.c
+++ b/arm64/pci.c
@@ -84,6 +84,8 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 		u8 pin = pci_hdr->irq_pin;
 		u8 irq = pci_hdr->irq_line;
 		u32 irq_flags = pci_hdr->irq_type;
+		u32 int_type = gic__get_spi_fdt_type();
+		u32 int_id = irq - gic__get_spi_base();
 
 		/*
 		 * Avoid adding entries in "interrupt-map" for devices that
@@ -108,8 +110,8 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
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

