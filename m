Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655307;
	b=VHeU/AbfJEyBAKXnFWjJVg2+muRXOMBa3ID2WfIqnsM+yuFjL9DrTN3yTV+zg7L9fw03
	 EhNgol2T3jPxpVh35jFJQ8md9tOm6o2z7D3YuDq9Qi2KjtNIIwU4HTlNieNtEaVTYyDmF
	 3j295BuQMOcR5Aro7g+zF+zpIHqLogMRVTkBzvKvZ4/Oqs98wJcbNCruAmkcbZiMlXlRS
	 lAnaAz6bYh3/gm/hJEr+ElW5iimielZ7foRI1eiJuJ8RWQ0BFVtNdbNHe9b8VQRPNQwz2
	 O4xjmMf4nBkBbDUcAD+Q4+mrZdtxTnLoc9AberE4YpMfcqGJqiRRFTyCqMzTKCtf9Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655307;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dFb7iUfCIvZEd9GBgZXqiz2YQwlJPnqCRUU9ZuRiB/E=;
	b=5itiH2o9YibxO//MO6SSftCyl92XeCZS1nLtoOR7UXAsEx2LEwSd/Pi0UbHxVG6tW9YO
	 NGcTrvly/Ct2xlx4tUHAW24qP6eWmdGApB9Nq6vBE8MZVagDlUrT+S6iuNXu5GmYud33n
	 rgcSbNn9RcBtG40C7Gk5VjxYtL+cyNkbWGSvlTyke+096ERN40Hnk552OnNP78A0pkYlx
	 0YajL1GRn/rLuk9bvvd9zLtKuRbskBYMowtwjPaCPDAlBKBaFnLYoILo4zUfWOw0uYAsS
	 jnjcW6kQhTQzP7bYT8gb2NaF6OK6QG7GWSq5Gs7iovpBepfJuXcO60L0xExCcylW55Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=TcLq00jr;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17077606A329
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:35:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17077606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=TcLq00jr
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E4A21595;
	Mon,  2 Nov 2026 13:35:03 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C7213F673;
	Mon,  2 Nov 2026 13:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793655306; bh=2BXXxQwwdafYo44AKHXg+KQXDQYb+Ts+VimWwopDPBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcLq00jrjQ4TAh4RcuKdvPRqK1flEIn/BDMVJJShEBEO0wlO9qjr8YD15WkkRH1p8
	 dVPBYk5iZuqwqrW1Nh5MZQxWR1AgDaHLg6MF2vzVhX2KtSFHD+8nAzhgNMDPvf3xXd
	 9f8zEgqZEju8CNgoTpSDG8qeKp6nwPaD0iW0jq30=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v4 11/23] arm64: Describe the PMU interrupt for GICv5
Date: Mon,  2 Nov 2026 21:34:01 +0000
Message-Id: <20261102213413.4136118-12-sascha.bischoff@arm.com>
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

Use the GICv5 PPI specifier in the DT. KVM also expects the PMU IRQ
attribute to contain the GICv5 interrupt type in the upper bits, so
encode it before setting KVM_ARM_VCPU_PMU_V3_IRQ.

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

