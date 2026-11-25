Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619709;
	b=d5TN8EiwNJp31HZ8s/TlLiRIC5Zpdq/AVnHl9+gAZf/gHnWCcfC9uPMubKqXDPdon/K0
	 nepRRD5kH2Sdwe5CK2lN/g9/2jmRSsLt0vEXpESjkiSat1yRKD8ZfAQxf2Co2jig+FeBy
	 bt/ycARCQmxF1vMoDQ8rDiSjRBAd1yXaD7AAZd6Y/iGdwL7D/HYHLDo4jpTOCCsSq2plp
	 jokQJ6Eu3y5EhjYcWS78pK2bW+fcONQ2zeBhQdKSrSi1uzoKgHPwqJYWnWwP1SeF5Yl2e
	 3g8MlMhCOMtWSGScRN283ODyti2j1sOqxAmz37pcw1iMkL/IIwFFeHHk671sLMxcU7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619709;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tVFHv5fcDxduoe5rLK81/cHawUIwJ7k88sNX30nlvJU=;
	b=ottMLFkaiq3FYpfdx5aBDE6nvHQP1BqUeQP2oIf3s2kmLbwN0Gj+/MuA+kRk6Ts14+FM
	 S6iQGiHLKeOTwzbgsszbRDcMb5wGX/xLLr9ZeydjBqVEGdMAOlIB5tRLergXJzJcWftos
	 jYlWqf9t3jTER4EPGFhokB6DK6GXKGTS+2aeZeVmEHPe+NOHwrF8Rrtbsx9yJmcfmJSkp
	 VOD1ijkLTKCz8tfQD7NAPG+YUs4GUJLFba9LTTrFWNNjzEYMkE3GtWtMFA7Pfwx4lgezy
	 53wmBoY42H7lNZ1pnhAdHH7mJPm0CFEcCCPg6HiW9jbmiDe7IOfb1ffaZLJIFgWmFDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=joJn8FvZ;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36B82606A335
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:15:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36B82606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=joJn8FvZ
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D9A65339;
	Wed, 25 Nov 2026 07:15:05 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A502C3F86F;
	Wed, 25 Nov 2026 07:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795619708; bh=CZm0vDwtQsuU0m2+h4bJjr5Hus88SeA5JbAb2h2Ly1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=joJn8FvZnLesfT79467O1JLNBWqB1UzjW/diGXXRSIohd8eH934M40ug9nqN1ZIsL
	 9SlgwESeOK4KmC9FrH0SO3qqLHs9JkFWVMnauCf2OgJsO0AIJ/Wx0KBaKwDU93N1yK
	 d7pyh5UFg/Khpx1rsWYM/ZK507BGFA2MuUYHlYDc=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v6 17/23] arm64: Generate GICv5 PCI INTx specifiers
Date: Wed, 25 Nov 2026 15:13:50 +0000
Message-Id: <20261125151356.2875108-18-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261125151356.2875108-1-sascha.bischoff@arm.com>
References: <20261125151356.2875108-1-sascha.bischoff@arm.com>
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

