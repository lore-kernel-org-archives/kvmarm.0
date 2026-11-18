Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024751;
	b=lUYjKZ9qKBboKbPjVPd1GKc0IMyB1Ah3Kx77LGx7eeBEG4Yi1KRHTRKQl8Sm4HM6aJe8
	 84t3TUYH8DRJfMrdlXKGogL9StLC2IUtKV5YLCIQueeK9AJr9s5zuBE28sxX02J3zvgvM
	 oeujqy45jHyuLY2AqNJZmXdKqLILcMOXVUuLneAXxwhf47yLWq75/B5u2v2DoEyj39JTx
	 HI6oYx5rG4Y0Kg5j4ZEJDT1Dkb/Top2BVvdPyr331UaZK7g85GjWxal1Bdhyf2QXeZGSN
	 hwAa0MiUv4pC71AHmqvCQzcxGfd9hPpfXHVJ4UvMXsXzf9ToBrEdmDJ8hal4lbBC+LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024751;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=HTo05RBj3y4hvuDtxye5VcS0OpIbiG4DQPfPMCmpV9A=;
	b=G62ip3cDtPbIJFSbTfQYu7gykiAetvAvHqWDxjsbE7JsWqPpSCIAgEbqGbH8PuaQUbbl
	 uMHRXCzi5VuvZxMbiY/aiX2zc0mWAPPgvH1yAC2DYZkqmcHS0VL8r1Ww6oSvoNvbUpY8K
	 fu7WBYX5AhyOk31m0QmU0/2H02KQv0PAD7AT846ilFfJSZiqhAab6M/9AnNbeQvF7uSO5
	 hUeCxuvfER4KB6GXaUA1A7iFaZ2/GpkRTRKeGD2af8NaDgZj2XzjG5CIGMrLRroSbJBJe
	 CMTkYruwc6mD67MpXM+DY0vHGpMXd3AQ6GJ+RDMw/HaTkA41cYx9ojMKk/hAqKVeGfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=N9o4qiCG;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42743606A331
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 17:59:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42743606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=N9o4qiCG
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B5A861596;
	Wed, 18 Nov 2026 09:59:07 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5E6373F632;
	Wed, 18 Nov 2026 09:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795024750; bh=8yrs4gsSwEcKjiP13a3N4elKx2UY7onTNUl8hLFf1nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9o4qiCGcrnXNFcqlv9uI+yAreICU2rIQKtP1fJKVXbic3h89BnGWbbH+eaooqTTM
	 bf4RThnnWCOG2djsPcGTMEsS3tSjDGJhcFEZrk6mQVaDc++RchWRIzQtMiIfqEYcqw
	 aYEZ9JHZEJ+eAEO5iTF7v1hs+HFvhPgiVYZA3A0k=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v5 16/23] arm64: Generate GICv5 SPI specifiers for platform devices
Date: Wed, 18 Nov 2026 17:57:48 +0000
Message-Id: <20261118175755.1946977-17-sascha.bischoff@arm.com>
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

Use the GICv5 interrupt type and absolute SPI number for platform
devices. Preserve the legacy GICv2/v3 DT encoding for other VMs.

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
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

