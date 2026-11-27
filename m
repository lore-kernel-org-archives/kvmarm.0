Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798961;
	b=pBn49OCTJWmD0uNIGn6Am3Xky5e6sNA7HQ44Jq3kaS7lgS7mVzZYB2b2UE4y7cNrzT31
	 YwvlmKY5M0fkZfXsNufmhXVLyWJDrp8XO/32+GsLoZ/tZQrwaFNKPrMhTktBV5DzYsM92
	 pFJfOEQY/9eXY6F+zRQ2hzHZlGNobrFg/i4/ot2rvT6aXJ8MbAdtK7ZGveO8jr2Vv62Xb
	 /GXjDg/6v/3ddL/OOeIJBoqNTrHNxhqT2+YSPIRO3fQHo8KCxN9vgvNsdiUIVX+oy4HWb
	 9KHIRfQEZSQuxJTMrkkcCv7KvkFHqjT02B31tLHTg8MFIFYsEnMpTXpwJy8xzxUa+Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798961;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=EcPbxzCRQBLYlwvvdDDDLNfLsZvtpyH5dCphexphWKc=;
	b=0+MfIU8p7+6d8aWyIPKl7QFS6WkWDDENdF2HS2Z2/P3ilT5/iov1NusQSgJ1lp/WGuqJ
	 bKqW4chefi8nEQ6/qZzcXF95kBeNKH4GEEd6p9Q4vPaBEGD3AZt2rnwl6R/F6/yeGevPi
	 Qf+f0FLST46SjD2OXVb3DZrKvowqMLf1JdzlFLLis8BTwBvR6XA0/EAcBhIRbxIC6HxqG
	 QQDk3Jt9nkPFiGrqIony4MpsylTeSVrKoi8Kgny293es28X9q+/VKbWLLCeH5+ga4ergd
	 bUscL5wyuU78+nkoFgqvJr4d2w/ghWzaGYXXykk9rNqMflZQmRRtKG7FZ775JV5O1Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=K88uX7bF;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12238606A31C
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 17:02:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12238606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=K88uX7bF
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A799D1575;
	Fri, 27 Nov 2026 09:02:37 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 677A33F632;
	Fri, 27 Nov 2026 09:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795798960; bh=Gy5nVQb/XOWmKP1w3nbVDaP9uLNjDefeN9gWl8BMlBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K88uX7bFqaQChNPcIRvXo2fstNk0Fnc+8PKrgFbe14JT+jJNyH2/tbK91AMHZe+iS
	 nV0hy6MnT6C6sNT2ZCfAOggfQYM0s4tOm1d2UpC3uZLBuPUka0F6ZyeUWhUfLK96YU
	 kNtAdnjqCw0+1J2dmUhd2NMaegBReiyjfzRLdJoQ=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v7 12/23] arm64: Describe timer PPIs for GICv5
Date: Fri, 27 Nov 2026 17:01:34 +0000
Message-Id: <20261127170145.4138182-13-sascha.bischoff@arm.com>
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

