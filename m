Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798976;
	b=5tjuFuD8Zqt3mZOLD1EClduCUHVCOrjOb4iLAqnH9tEAgdAWyU6937KxfgP1KPLD1wrL
	 Qj9zosuNmxx+QqpeslN5gzWTh4jjcMxmh1hbAH0RVR0A6zmeUCfdWEeTPX5qQSw8bffdd
	 jxw/p7cJOSq0/S3+v40QaBY9DcIeTqcU5806YbzNQnFdbdhAoBWTxEPbQHmWUMCSvTrec
	 MGv7B2fXpWWje7tEiu2AJQxT5k4BblVwoKigsm50XgtLLKodINa1H0WgQwa+pVkh3UMFr
	 OgPdw6EVFpg0jAFvvs0cMYE35fryw6scmKNcN6/wA4kk6JlA+9WCje+qIv9jD0woaeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798976;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1CDcARMABjSy8wBRDAxeUfNt9pwXWP3pgN8SPO0L7hs=;
	b=W6XLXM4beeZ6cuJzKH+NmsM2aFs7jnAFCjFiH+vDVMcxIX+Y6vOriyeaNiIhMbgBRtwj
	 mcKRgG/9qxMvxHMEUGH9VkAxUNfZfKKdYIgGmsN9prTwZ2Uu2srqAhKxpJDcMDQsKqDQZ
	 b7nr57Wv2pll1LMUcVWYXoqEP+GLpi63MKcAjOquuO8K6RVNUaS73YXeblGFldVfBt5Gn
	 8gua2Z9Z4Ry9CyGXCdLwfMJX70mil2ome3OmeClhC+fOwGtN1DHHu9p8guJ9OxGEaQmqY
	 V9WK8uKVI3KxTfmV8ir53C9FcP5NHgH6LjpxzAVrhAYfJD1TbsTW3ZN9zMjgXD2miow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=h1obFyq6;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F716606A31F
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 17:02:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F716606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=h1obFyq6
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 32AD91E5E;
	Fri, 27 Nov 2026 09:02:53 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE7DF3F632;
	Fri, 27 Nov 2026 09:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795798976; bh=7YJ+Bc5IuE6NLDnB1G1TVkKbj+QVpiEFyKhvJKpIERo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1obFyq6ARqAe9I+LV8xqLja3EvDF4cJNfuXkew1z4YOxh/e347p2XVYbjdd5vuCW
	 94KA7XG4jT4MfePTEASOb739w+EXkbAVz/udj3nG3uRaFXT5IIpDKmhWXP8stGd4+i
	 htt9u+kyumZOpKYcZ8djrdTDNDDrHTj+KffiKCjc=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v7 16/23] arm64: Generate GICv5 SPI specifiers for platform devices
Date: Fri, 27 Nov 2026 17:01:38 +0000
Message-Id: <20261127170145.4138182-17-sascha.bischoff@arm.com>
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

Use the GICv5 interrupt type and absolute SPI number for platform
devices. Preserve the legacy GICv2/v3 DT encoding for other VMs.

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/fdt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arm64/fdt.c b/arm64/fdt.c
index 363b3ace..b6f268a5 100644
--- a/arm64/fdt.c
+++ b/arm64/fdt.c
@@ -67,6 +67,8 @@ static void generate_irq_prop(void *fdt, const u8 *irqs,
 {
 	unsigned int i;
 	u32 *irq_prop;
+	u32 type = gic__get_spi_fdt_type();
+	int spi_base = gic__get_spi_base();
 
 	if (!num_irqs)
 		return;
@@ -76,8 +78,8 @@ static void generate_irq_prop(void *fdt, const u8 *irqs,
 		die("Failed to allocate the interrupts property");
 
 	for (i = 0; i < num_irqs; i++) {
-		irq_prop[3 * i] = cpu_to_fdt32(GIC_FDT_IRQ_TYPE_SPI);
-		irq_prop[3 * i + 1] = cpu_to_fdt32(irqs[i] - GIC_SPI_IRQ_BASE);
+		irq_prop[3 * i] = cpu_to_fdt32(type);
+		irq_prop[3 * i + 1] = cpu_to_fdt32(irqs[i] - spi_base);
 		irq_prop[3 * i + 2] = cpu_to_fdt32(irq_types[i]);
 	}
 
-- 
2.34.1

