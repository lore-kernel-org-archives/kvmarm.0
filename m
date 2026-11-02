Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655328;
	b=5d11lETwdjcAs6pOnfme0xJmKR+V4u2W4du7vnTQUPUsj90pnr61YqB5qqQpukbcLqfK
	 ZUfVBnCs20HluiVjdhS87EEwJG+fS9V466H34kxB4OgM1KW1ZGculzOK2rgPT1pJHT0Yg
	 3kgqpgFRlEKsXVFzrIEDlvBTn8EbCLhV/3ho+UjUFTwofnNywzqdPhNbeAJ+XiGwctmzo
	 m/4+0aTKv5JsupDSgShfgM5cjdxrUnhAYsYL8bZtMstgfiJd5SFY5+KJa5rysEbiINi0r
	 MM8BKrYbQ7/OfLSsMZowuXzrnzib8Tlkiv1RE+LGLFoYD1SceZEUnDkaQEFiPdRPQcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655328;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=foE+8Kof6LbdOYig+diwcHlzAv8+58dS/mpVZgTxm2I=;
	b=MyJGyC7+rRpXJA6OkoByOynohe1f+onv8K3WQqUNEKejegzx4yHcSyi9y94yE4H224n4
	 cSPRUaA1oVGaDJXWUUO/Or8KY6EyXEDa6Cz6xaeAUlHMe6fmaLhE2Je1/GkTQ7UftHvrW
	 j6KJYuyApJFHO5Ud6AZloGnDbPkS3d7KWI+/euF92LHSY12nn/xlxk0+ps1JYj/N1+Amr
	 MFb3Q6BNCVkTd52IHhv7Ee8NGlw5gOqr0BMdEyoVPpYRGA/YiFxUSwygIneDjRp+ZjKCU
	 j111RsWX60C6BAG58Ky8bRypbMvlU3d63BeafM5mPvmtLmSsmbIpL+a+xXwM3OTK4BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=RBkRfBHs;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F9E606EE85
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:35:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6F9E606EE85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=RBkRfBHs
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 060241595;
	Mon,  2 Nov 2026 13:35:24 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C486D3F673;
	Mon,  2 Nov 2026 13:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793655327; bh=Iv/VwfIyikLXQy5eCHqhGt1VBnwP/NThFwcmk19S6/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBkRfBHsKw2CwQGDZ3qlAHYwapQ6FRrlinZmK31EVDlVCXmiHlZXbn3QjPb4DkThJ
	 O6SSsIzhDK80+ergehFfHuvAHgUAP2POCuKpAyNzy1AqFIF+siCcKJbZjIVYiZzC7d
	 lGAPDYroPBQHVISS7PnXMPN/scAA57H+nnN2ToNk=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v4 16/23] arm64: Generate GICv5 SPI specifiers for platform devices
Date: Mon,  2 Nov 2026 21:34:06 +0000
Message-Id: <20261102213413.4136118-17-sascha.bischoff@arm.com>
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

Use the GICv5 interrupt type and absolute SPI number for platform
devices. Preserve the legacy GICv2/v3 DT encoding for other VMs.

Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/fdt.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arm64/fdt.c b/arm64/fdt.c
index 5413956d..e92ae044 100644
--- a/arm64/fdt.c
+++ b/arm64/fdt.c
@@ -63,11 +63,13 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 
 static void generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type)
 {
-	u32 irq_prop[] = {
-		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_SPI),
-		cpu_to_fdt32(irq - GIC_SPI_IRQ_BASE),
-		cpu_to_fdt32(irq_type)
-	};
+	u32 irq_prop[3];
+	u32 type = gic__get_spi_fdt_type();
+	u32 intid = irq - gic__get_spi_base();
+
+	irq_prop[0] = cpu_to_fdt32(type);
+	irq_prop[1] = cpu_to_fdt32(intid);
+	irq_prop[2] = cpu_to_fdt32(irq_type);
 
 	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
 }
-- 
2.34.1

