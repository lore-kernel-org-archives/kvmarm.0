Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795799001;
	b=c/xBCG5N/T58JySg+xkKC5HY7SLq5vxKwGUBhBPdK7V4rZtQ2xVxccYbMslYkc1OQrFM
	 nstSzshC36RTOd7uVl45xuraZSSYkZcTt8RsgrNAEd9iaYWFLW3gFlbuUvtu7sTqHTCkp
	 IM17GHtLoGLEb3TNXiGrQs7B0H8cW/T2plvq0IHV9Wta62so+NSQOl3gEKJVb3JZ1hdfG
	 EHlDzLBML6xGL8MYQxb0A+lQbVolgsOFHVR77TlgXHk5APljIB8WhJ+5O8ysPkPScluoV
	 +6JIU7o9d0hiqaOgIPY/nxGRiqa/Y+6kss3E/TTJZSItEUTbcQyUUxVtc9o3C9WzDUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795799001;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dhzjtWTxxx9gvHbB3whTNi+6jXCnSVNDnthokQ96IA0=;
	b=yOHXPY+B9cFuZJhWOgVjPUkm9EYeG6G6Gam5Lf6wjcNnnPkdS5EhmYeABDcHKUIOxUHV
	 7gPjme9Pb511s+ebu63l26zx+WgxukbsauymXpVqjE+C1f9bhUt2k/rXIfvkeDZ4yfbkS
	 gJdYO7ndiIzgTLeLLuEo4xB7Z0Ha9xksOu7bhijh/5dF36zRgzqcbB0yv0Wj6nLhrDGqS
	 FwmBNiLbfhYNUmak+lb31g0G02O8bzrkoQ/MrGNylshn/BLdUj+F1+PIqSpyVFxthTeai
	 Ywn+teb8UMQ81pgzKFm8czZnSpJHBinlTqQyEc5G/VszlVC1ARt1vcuazXNcl5tySQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=n971RfQx;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2D30606A31F
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 17:03:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2D30606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=n971RfQx
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C75C169E;
	Fri, 27 Nov 2026 09:03:17 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2D6403F632;
	Fri, 27 Nov 2026 09:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795799000; bh=OLvCS+iyUFh+thOl0UyrUKBrAlAejhgQMAiPWRtb0fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n971RfQx3/4Tr4LEeEiWEl2phc7BVKapk9W3/p4W0vO4w0a73CMoS8fbJwfxU5mjo
	 Z3mOAMDoLoLGKB9P7K/XuiqXlE81F84McXClLfIOSIcbroDsE2FJfCAL8WLpS3s41z
	 CdrG10Bdn5xjyrvQJd7YYA0XTGMFRfXBxyXT8Nmc=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v7 22/23] arm64: Map PCI MSI requester IDs to the GICv5 ITS
Date: Fri, 27 Nov 2026 17:01:44 +0000
Message-Id: <20261127170145.4138182-23-sascha.bischoff@arm.com>
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

The GICv5 ITS MSI controller requires one MSI cell carrying the
DeviceID. Describe an identity mapping from the 16-bit PCI requester
ID to the ITS DeviceID with msi-map. Keep the existing msi-parent
property for GICv2m and GICv3 ITS.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/pci.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arm64/pci.c b/arm64/pci.c
index 91265f67..69e180b5 100644
--- a/arm64/pci.c
+++ b/arm64/pci.c
@@ -32,6 +32,12 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 	unsigned nentries = 0;
 	/* Bus range */
 	u32 bus_range[] = { cpu_to_fdt32(0), cpu_to_fdt32(0), };
+	u32 msi_map[] = {
+		cpu_to_fdt32(0),
+		cpu_to_fdt32(PHANDLE_MSI),
+		cpu_to_fdt32(0),
+		cpu_to_fdt32(0x10000),
+	};
 	/* Configuration Space */
 	u64 cfg_reg_prop[] = { cpu_to_fdt64(KVM_PCI_CFG_AREA),
 			       cpu_to_fdt64(ARM_PCI_CFG_SIZE), };
@@ -70,8 +76,18 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 	_FDT(fdt_property(fdt, "reg", &cfg_reg_prop, sizeof(cfg_reg_prop)));
 	_FDT(fdt_property(fdt, "ranges", ranges, sizeof(ranges)));
 
-	if (irqchip == IRQCHIP_GICV2M || irqchip == IRQCHIP_GICV3_ITS)
+	switch (irqchip) {
+	case IRQCHIP_GICV2M:
+	case IRQCHIP_GICV3_ITS:
 		_FDT(fdt_property_cell(fdt, "msi-parent", PHANDLE_MSI));
+		break;
+	case IRQCHIP_GICV5_ITS:
+		_FDT(fdt_property(fdt, "msi-map", msi_map, sizeof(msi_map)));
+		break;
+	default:
+		/* No MSI */
+		break;
+	}
 
 	generate_dma_region_prop(fdt);
 
-- 
2.34.1

