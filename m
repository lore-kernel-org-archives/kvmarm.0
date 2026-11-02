Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655311;
	b=vedmuHlXMo+Qomrtr70VwQWgwd/4ILjmV788H0VyAJ8UxBpPUEb+DXEesDd3cJK6O62E
	 C3HDzNpOm+CdgZQNha/ZBvEJVO+fdAFg/KRLixWuPx84ROYcw5Z0oFWgthH3fN9i/Rn+l
	 nFW6xRJpEyxwDmtfQOEYm870zCEj5Z4ftsYwvyAqPECflEDIpLpuBvvlkBAE+yuviP0Je
	 BD2w5z9rwXiZ1Vi1HPFDHZknuWC8US6ASgiSfiNHCn246WjPN5XE4rFPCobGFXe4kfofv
	 dcYMb+i6IZzgCQWD4lT8g/T2O+kzAg2GV7VjeG/isrGqG1EZNtDmHf+NcjOgpGEx4cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655311;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YTdHceFIHuX2hn25hTLrg/0uXYJWfR396YcPpUWiUT0=;
	b=g/MSQTl3z+D0+ZUNzLc6cLAszgSN5gU3OE2pXeWTp+0nHXQ+xocOYRCgMlUV0xuWISls
	 H5SwV6RI08+I+BFVlcO6E1Mvhvd/Tpp0doI4XdPS387ZJ2+vpkF/CHALZYnqDYZupmxQL
	 SUO2MW9+4rGMISE/X8Na5YIUF5YYtKJyrSz6xyzWfhjbPpfM/wfQAYYifk3nwlRM7HJ7F
	 l8qExOQY0XLGMJvfmodMqbIjaT6mql7iVPwVpyp5mpRW7y/O/yKaScW/O9zWZ5n97bgvo
	 +awz9ku5AZeQN5RUIfOI0cVHnRpDAJbNEKbKajaeQborYoJzUvXaBmfM0hvNiEUh8Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="iMq/+Shb";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B78B1606A326
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:35:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B78B1606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=iMq/+Shb
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E25D1595;
	Mon,  2 Nov 2026 13:35:07 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 38CFD3F673;
	Mon,  2 Nov 2026 13:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793655310; bh=8C9yB5pmXzwd06VKtkpuJOCFLJcSxezaZOYd3a+Syi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMq/+Shb7TJSwGxwdj3ICOAAqXqEa1SXonURkhisYrY17r0jG7xj1usiUfg+k3fOD
	 e89klJLdRaeiSwTdZfAoySfCpZxCzj5kea8QW+h1b6PCSPZHjskuUjqXQ+EiuXCXjf
	 ojxFgG0ec9ZLGSSCuVIFITvgLKss0lMYJvD0xSvM=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v4 12/23] arm64: Describe timer PPIs for GICv5
Date: Mon,  2 Nov 2026 21:34:02 +0000
Message-Id: <20261102213413.4136118-13-sascha.bischoff@arm.com>
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

GICv5 DT specifiers use absolute PPI numbers due to having separate
namespaces for the different interrupt types. Keep the existing
GICv2/v3 specifiers by subtracting the legacy PPI base for those
irqchips.

Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/timer.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arm64/timer.c b/arm64/timer.c
index 2ac6144f..01b9875c 100644
--- a/arm64/timer.c
+++ b/arm64/timer.c
@@ -9,16 +9,18 @@ void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	const char compatible[] = "arm,armv8-timer\0arm,armv7-timer";
 	u32 cpu_mask = gic__get_fdt_irq_cpumask(kvm);
-	int irqs[5] = {13, 14, 11, 10, 12};
+	const int irqs[5] = { 29, 30, 27, 26, 28 };
 	int nr = ARRAY_SIZE(irqs);
 	u32 irq_prop[nr * 3];
+	u32 type = gic__get_ppi_fdt_type();
+	int ppi_base = gic__get_ppi_base();
 
 	if (!kvm->cfg.arch.nested_virt)
 		nr--;
 
 	for (int i = 0; i < nr; i++) {
-		irq_prop[i * 3 + 0] = cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI);
-		irq_prop[i * 3 + 1] = cpu_to_fdt32(irqs[i]);
+		irq_prop[i * 3 + 0] = cpu_to_fdt32(type);
+		irq_prop[i * 3 + 1] = cpu_to_fdt32(irqs[i] - ppi_base);
 		irq_prop[i * 3 + 2] = cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW);
 	}
 
@@ -30,4 +32,3 @@ void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 		_FDT(fdt_property_cell(fdt, "clock-frequency", kvm->cfg.arch.force_cntfrq));
 	_FDT(fdt_end_node(fdt));
 }
-
-- 
2.34.1

