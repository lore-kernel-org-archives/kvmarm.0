Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798957;
	b=dXpNGsz/1+zb5VJyjwseXij7XjME1vLIeiBKuS+8eVf8kT3gxlbgXj0YqNOopZUq0GD+
	 gQF6qDNU4B/dvzQ/3VpAhkne4WptBBQwbii6HQxg+ghdXjP2UlprO84DqQBk2M6EUr8Ju
	 bCdVzU2MrvTkQYv1dcKHpM/C4NbLk3wdQOVCz7aqlCh0UzeC3fc23c2Vef/RPsO2+bbR3
	 apJT4g9n4YE+SrhMYmpqDNNgZrBbORoWqz8dfpGQlPTEmnIQAIwmxNQuO1KmNtxQWDa9X
	 jC1Susd8A7uXjd7q1brNkGSBDGFqyhi+O1eaEO9KeWA0/6lIEV6d2GuAnzbIqEtL7dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798957;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=B7RnrqqF9Du8U6ZfwvJsyNIhW5NqHKFpAjMf8jd9V7M=;
	b=18zzRYk8kKBCPRjta1xiUfcJ7HBqXnJiu0qQ3Ihx7HCxQEaUDd1I4yMgrISQuRPd+AEE
	 2Snjw5S/CcOTU3lnRsZOcVpS2YbxaaBFvTnXvxAevDSarA0IpYGBlsYCJYTVPy/uXWD9m
	 x5Fgp1LMgiTGZd385F9zQpr8/D8yPJlcyy7a1RbyQDBkQ4LuXj6aemdKt4M6ZFAzj4N2a
	 TRIEnVqxaoUMx37DNkFnRkjCSzLYHB7Pu80CHQDWUuyj+gleH1g5qCvlQ90kRe2KurAeB
	 rUPmNVIwKHdoGZt3VMBUikx1LLSNl0JZBbi4e9cj1AnnGvvpprlrxyroNMcQXiYLbAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=jLJuk41+;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 611CC606A334
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 17:02:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 611CC606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=jLJuk41+
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC71C1758;
	Fri, 27 Nov 2026 09:02:33 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 742863F632;
	Fri, 27 Nov 2026 09:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795798956; bh=WPgR10sFBLoPOaY3x4JtRv71idWIoCgdk/brn9QSVxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLJuk41+5E+v4/i18KpuuAnzPyNYdBi8ost0hKmxlw6y1G7EbyZ73tL2ZIlTxkzc7
	 aORxGYmU/igEBkB/ACEcbq/zF3mRRLZABW2IpRdJb3EHVY4/wp/+0pgwOLoITHemt7
	 tNEH4kVZpm6SZ9GCoLMG1pyQC50ZxRGlrFtFHkyw=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v7 11/23] arm64: Describe the PMU interrupt for GICv5
Date: Fri, 27 Nov 2026 17:01:33 +0000
Message-Id: <20261127170145.4138182-12-sascha.bischoff@arm.com>
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
index bd3f2258..a190652a 100644
--- a/arm64/pmu.c
+++ b/arm64/pmu.c
@@ -232,16 +232,17 @@ out_free:
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
@@ -266,6 +267,8 @@ int pmu__init(struct kvm *kvm)
 		}
 	}
 
+	irq = gic__encode_ppi_irq(kvm->cfg.arch.irqchip, irq);
+
 	for (i = 0; i < kvm->nrcpus; i++) {
 		vcpu = kvm->cpus[i];
 		set_pmu_attr(vcpu, &irq, KVM_ARM_VCPU_PMU_V3_IRQ);
-- 
2.34.1

