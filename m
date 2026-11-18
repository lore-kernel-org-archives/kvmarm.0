Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024732;
	b=OwCGb7PkixMksp3ZqLCPhrRTQAXPBs/JNgC/cgdxnOsR8vB1JqTt8XMAxB5VU63YrrKc
	 cdht+IpXSA5VQDXorS/WPWXLUoj4ee9asDV3YqUHW2A1d/5lXwW+piIM26tNCCDUGMV7r
	 QhFBTcjkhYkYpriER8kM2Ea20/IsbU/bt4w4zlxje5/kLQKEtxTag3aeyCvf0KB5DT5bd
	 /QRytgEcTeylpoRK6jQAzieUv8UlAIeUOYTxpa0bXL8xnHLja+7Xf7AQR0lNyFYeQ9p+U
	 +4RBEo9BLBmu5Y5283/f8XdETtRD4cch3qK7yFbSTuVGk6ofCkJGjFfhiobDHSWWRKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024732;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Uv+QrL1hb3E8q8qlaPr/w05HjKdbUi66ksFf6isyfiE=;
	b=bXtcnl38DKJHV5B6aTtneHKxSIAH76kuTY3KEID+SypmFDyC14xvPi7AVjB4ZwLRmnYq
	 kW6yhrdVMQov3Q2bLkwyCfCsFw79a1cZdr3w8VkK/eL4EzfqgoLdy1RQB79PCTKwxoNKc
	 hPHaNT2upokyY6/vMQanfwkK2w1nAF6xRDDq1Vq1Pwcha3V/cNO4cUpIo8+w7gUWdpi9/
	 5+BXHp8vCx2APTzRJNOY+bV94SjOVW3tsBpZcERSdrlxd+hT0eSOsMOrPAYCmtx9RfYA3
	 7lT8yAy1dvyv9N7FhCl3HNohATxFtiAYvXMNgMu9vd2GmjVKL35wvfjM+RPXSyj0hdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="I/BMLlTo";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9955606A320
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 17:58:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9955606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=I/BMLlTo
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F2AE1596;
	Wed, 18 Nov 2026 09:58:48 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0BA0E3F632;
	Wed, 18 Nov 2026 09:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795024731; bh=rbFPjXaJgnyTNgicAecmcozOK/secmLDCqj3ux6hUws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/BMLlToC2DRRylvYIpi+Oy9PvGE6Wjwmd/ibLCmBSRJBEtwweyYpVpwzPZD4GXqT
	 xq0ti8lk/7S9w8u4LNiktF2rcld7+KGcj4F+p7+CPzSLaGM/9wFu3VnzNVKR43CJkb
	 9o9lE+J/oBJrUdXQ7LCefNrnQCLCQ7x7kkjIS1Y4=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v5 11/23] arm64: Describe the PMU interrupt for GICv5
Date: Wed, 18 Nov 2026 17:57:43 +0000
Message-Id: <20261118175755.1946977-12-sascha.bischoff@arm.com>
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

Use the GICv5 PPI specifier in the DT. KVM also expects the PMU IRQ
attribute to contain the GICv5 interrupt type in the upper bits, so
encode it before setting KVM_ARM_VCPU_PMU_V3_IRQ.

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/pmu.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arm64/pmu.c b/arm64/pmu.c
index ef7faca1..b3026d50 100644
--- a/arm64/pmu.c
+++ b/arm64/pmu.c
@@ -214,16 +214,17 @@ static int find_pmu(struct kvm *kvm)
 void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	const char compatible[] = "arm,armv8-pmuv3";
+	int irq = KVM_ARM_PMUv3_PPI;
+	u32 irq_prop[3];
 	u32 cpu_mask = gic__get_fdt_irq_cpumask(kvm);
-	u32 irq_prop[] = {
-		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
-		cpu_to_fdt32(KVM_ARM_PMUv3_PPI - 16),
-		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_HIGH),
-	};
 
 	if (!kvm->cfg.arch.has_pmuv3)
 		return;
 
+	irq_prop[0] = cpu_to_fdt32(gic__get_ppi_fdt_type());
+	irq_prop[1] = cpu_to_fdt32(irq - gic__get_ppi_base());
+	irq_prop[2] = cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_HIGH);
+
 	_FDT(fdt_begin_node(fdt, "pmu"));
 	_FDT(fdt_property(fdt, "compatible", compatible, sizeof(compatible)));
 	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
@@ -248,6 +249,8 @@ int pmu__init(struct kvm *kvm)
 		}
 	}
 
+	irq = gic__encode_ppi_irq(kvm->cfg.arch.irqchip, irq);
+
 	for (i = 0; i < kvm->nrcpus; i++) {
 		vcpu = kvm->cpus[i];
 		set_pmu_attr(vcpu, &irq, KVM_ARM_VCPU_PMU_V3_IRQ);
-- 
2.34.1

