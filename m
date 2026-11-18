Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024735;
	b=UkFX2x7m+80c00hlLeWU/wMzXMdw3aOGVohVq0+FpTSlzVIu0AHPYZk0SChFtEEuU4D5
	 IELFx862dJjvj4K6y4VATMEP2QjWeTR31npTFk45YcmTHDNH46rQHO+ddSRog6TE4pfrw
	 U4IiGADgk5SvVWKDwestlgoipQzAjV7IzOOxm0FeUR6+euSUKpmmhAfQpjrsDvGRK5Aav
	 eps1XkIEdCgXg09I8+9gdM/XU+vzBNqQ8ScC6WIZGLHbOp/TCPtD0MROyIFznCv7gwL8b
	 XW77XWaw6ffmDdSEEm7wLezkucNFqCxBG9dvLWIlESx9JZE37L7NMCjb7l63ecYjWsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024735;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=EcPbxzCRQBLYlwvvdDDDLNfLsZvtpyH5dCphexphWKc=;
	b=JLqTR0tlKS6tPb9BWe1pwQFIFZwOF7DMrgFggZ8dReBKtsAs9os8WE9ywGviFHarCEQz
	 TXf9u/ktryx6ZVF4QvCZ/YXFCpnQ4wbwAMCIwAdM3W/sIas8Zjn74sva6ID7FcdL8KRkH
	 SdDP6kN6RD1IYLMx0MqM7Vg57NBVJd+dJY8GAKCplEHmyBW+cDXgbt3kwX8LwObI5URrf
	 7butiZuFR4noeANp61eaWl7O4I2qm/ID1Z6HBUpPNaO9ePCc1QWMqfxzmj5zwLgr/PPD5
	 9+IfNcPcwADSx7ejqzotndh/7nTwFQFshTfI2RIeXETswGm1sSJK5vIJN3fau7nEhXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=luCg4emK;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55C4B606A33A
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 17:58:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55C4B606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=luCg4emK
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E0A561596;
	Wed, 18 Nov 2026 09:58:51 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD5AF3F632;
	Wed, 18 Nov 2026 09:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795024734; bh=Gy5nVQb/XOWmKP1w3nbVDaP9uLNjDefeN9gWl8BMlBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luCg4emKDVxQ1/I1hY2AUWL35T3SuAIXMxJOr4p7iaqlYOy/EPPeinfk5Ol+MqqIo
	 /8V3HVoEC9ikUrHvXcjg6Ps2kinzV6rETlrsNYs4G1+90ireirb8joHfAIRtvD6wJ1
	 zFkhoQk1q4opZxHN94+9FmfCQh1QUGqnibGt9AjY=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v5 12/23] arm64: Describe timer PPIs for GICv5
Date: Wed, 18 Nov 2026 17:57:44 +0000
Message-Id: <20261118175755.1946977-13-sascha.bischoff@arm.com>
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

GICv5 DT specifiers use absolute PPI numbers due to having separate
namespaces for the different interrupt types. Keep the existing
GICv2/v3 specifiers by subtracting the legacy PPI base for those
irqchips.

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/timer.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arm64/timer.c b/arm64/timer.c
index 2ac6144f..5eff1e48 100644
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
 
-- 
2.34.1

