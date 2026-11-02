Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655351;
	b=XOnRyGs3DO80XStGycmJD5XuuAJyu8jpAOB6wagPgxxczXcY/2MDeQo0/CdwesO48gWT
	 15VSOsjqXMVjm9SPusxdeBpzwCETECtwORKyqON9ZVTTE1ROEtNNp2HCe/nPV+DmPgXQc
	 S1V4WUF/flMW1UcJ5zf0IzjM9+rVKPdznKIBS7+Xt+l59Fm0eRjnUcgdoRZYlAyvJpgMK
	 o1uR3sgPX5l2NK3MGkcp66Fghp34fIl7g6ky91NPqja20b2tIe7qToQDkxZkT9ZeWfjdx
	 xjfC5558298aPzN4xTywrhoeuPLGXvnhZiJlCt/M189ZujaX7VmLBETvHlzHfJgP09Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655351;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uZKA8UQ0egCwTG0Pbf7HGPsCZE+fVlPugWNeO8Z8L7Q=;
	b=QgeOHLoT+oFm6joyRkKKFK6Yca/YhZdLslU8RI8Tg0l3Ib4zugipIg8AmUHLP0wKStAV
	 Y74w1hUdv5wBCjFGwneVmm42bNq0tFiktq8tlCYVJ9VjhIOgefkfR4JmI0T3dGTQmQdL1
	 G3rew7sIfVidk2VOn+pbJT7dKY4YG6x3yH9F89zOZCdyn+6/EYPnmxEWFn9JNzJcHY8q9
	 HTKVix66cgyIQ3UtojzOVHKayqXaQcz+wJmEfkWkBejlye/UYB8rbWJV2cITNBYsL7Cti
	 MN7lTTRnz1bFLuZ3wrNsAFZ8QYJpHY8JtGMAs3au0FyOZfYGMPZxBM1R6gtkEC1kw4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=tcoPrTJU;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEF26606D83B
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:35:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEF26606D83B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=tcoPrTJU
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6210A1595;
	Mon,  2 Nov 2026 13:35:47 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DE693F673;
	Mon,  2 Nov 2026 13:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793655350; bh=DcTBj20jF/GriOlk4lrWt+XS7AlXM10Ugx3/zSWmme4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tcoPrTJUjaNn3iJ1kcXuhEuhkk8+QLMRqpbdybtVhi2uWUi6haQbRKEzgOiYEYnyZ
	 w2rqHZ0p2EGNF11HbMkJnFobH9Uqwcl2Kat1vnUdGzuMV6YtVmO02CBu8boSTpRfVX
	 kE4jybswSdbLEFhcHWLR0/8l4xolmfJ/bUoUe1Hs=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v4 22/23] arm64: Map PCI MSI requester IDs to the GICv5 ITS
Date: Mon,  2 Nov 2026 21:34:12 +0000
Message-Id: <20261102213413.4136118-23-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261102213413.4136118-1-sascha.bischoff@arm.com>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
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
 arm64/pci.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arm64/pci.c b/arm64/pci.c
index 91265f67..69aca4d0 100644
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
@@ -70,7 +76,9 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 	_FDT(fdt_property(fdt, "reg", &cfg_reg_prop, sizeof(cfg_reg_prop)));
 	_FDT(fdt_property(fdt, "ranges", ranges, sizeof(ranges)));
 
-	if (irqchip == IRQCHIP_GICV2M || irqchip == IRQCHIP_GICV3_ITS)
+	if (irqchip == IRQCHIP_GICV5_ITS)
+		_FDT(fdt_property(fdt, "msi-map", msi_map, sizeof(msi_map)));
+	else if (irqchip == IRQCHIP_GICV2M || irqchip == IRQCHIP_GICV3_ITS)
 		_FDT(fdt_property_cell(fdt, "msi-parent", PHANDLE_MSI));
 
 	generate_dma_region_prop(fdt);
-- 
2.34.1

