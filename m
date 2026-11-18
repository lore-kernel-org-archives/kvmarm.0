Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024756;
	b=xy+XH+BnW9Bm6e1jYfJdhQmYcBRLkTeXPQhrgsT3EzEN6Bv5qOa11CKAF6J+0HN84INm
	 rV7Oe1ZoX3EWvIBc+L7QjZlg+5ve4EL7x+D+L3fNMzwb0sm9bQgnTak82i6FKQF4kG4lq
	 SQpOv1fXMhQES+w4XTHAH7ZuTLIzgd4jWWXfZ+D0Cc8vmJZAkcfaUzXOUP86BzoxaMhjJ
	 8PAnA0oZ4vPcg5kqud5LcoIk7A2HsyhA3h7n8fPjWUPSnUwXiZLe3f5hKtuuwIL2PfiSG
	 bpeHqRO8MM42E6TdnibvS/l8RGa9QU5M2jXobLBf8merhU8PbFP/IbgCWBVi7Zqs0BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024756;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tVFHv5fcDxduoe5rLK81/cHawUIwJ7k88sNX30nlvJU=;
	b=eU2PS4wJyyHKEGX021gkfAQSeplmzYrIgySXHOOkZsl+3oFjJTpFuknnkpswmCUpsRCF
	 W9aAlug8BTCqGCptY5lnKq14cMxg8PVed6GQXRat/tGFtjctyrdSzRAHU7Rr4neeTdWH1
	 4dXZLlK9Lh64U/t7hQc0KsKtBH0ZjS6Z81egSInNk9/Xn3Yc2RUIQS42ELGLf8g0w6muQ
	 u+YBy7Rw1QC7f2Hk1N5mzJb5M8ksoXvMBpwqWLw8wHpV6cFnyLXk8yQlA88UMHfm8/cOx
	 7EHhuknfwtXEXvnSYBQwVhEsWbEbobch8lsQrgH7D6BoD1WQ/39aroOqtvSyrqeDzYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=P1WN7ju6;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FD97606A320
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 17:59:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FD97606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=P1WN7ju6
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC0011477;
	Wed, 18 Nov 2026 09:59:11 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 92E6B3F632;
	Wed, 18 Nov 2026 09:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795024754; bh=CZm0vDwtQsuU0m2+h4bJjr5Hus88SeA5JbAb2h2Ly1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1WN7ju6kntX13Jsli1uoKVk7b/dEgLStYYHuPhp+/lraSafvYoitcSutbDjp+dal
	 Yd2DG/uyGm+nt3M8qohxs8q12rx141NY7wgUIsNpUlh40zimBsjXBDUO02nc4Vldob
	 pyL1s8gftWkZ+aHmOYInjtVAT0OmxYHsfggivtE4=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v5 17/23] arm64: Generate GICv5 PCI INTx specifiers
Date: Wed, 18 Nov 2026 17:57:49 +0000
Message-Id: <20261118175755.1946977-18-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261118175755.1946977-1-sascha.bischoff@arm.com>
References: <20261118175755.1946977-1-sascha.bischoff@arm.com>
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

