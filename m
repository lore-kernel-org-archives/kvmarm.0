Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AFDE4E06E4
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165294; cv=none; b=lFEOZoGFBdxTpxExg4FMOLDV1PcDIMGMUk+fW28SSN6aL17IthVZSWZVUIycqRWoiAio7XfdOBAsHvIO1ae4FRAXSdd7YBYWiAj7nMP2N4jSPDz5Zme0KNFFH7xbofTCrRyZE+D98kiXtu+eth7jbh6vQsyxnoJTWITKH+ATJTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165294; c=relaxed/simple;
	bh=41CmV4dI+JrCBGuXB6/Xi9pioTziN0pvtJqieZ2SNIQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=liiPNhrHtrKl2H62522cgOpc68iXMv5dsh2lhf6MLReNLn+2xOC+hoyKD0Oxn3dDwICm3j0WLt0SZux8tfkD7oaGSIt8qSjaLtuQ8GlBSSgBygipbamIUAXG9IUtZlard08i5HWoEeL9WfCnwttfrZ0Uz8RC7Devk2CpTwHJeqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jxbapuhb; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jxbapuhb"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54F98143D;
	Fri, 16 Oct 2026 08:41:29 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 674D93F673;
	Fri, 16 Oct 2026 08:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792165292; bh=41CmV4dI+JrCBGuXB6/Xi9pioTziN0pvtJqieZ2SNIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxbapuhb6cA2Vt0qxbdReZe+81jGxWFXuCwm1QU5h0sNtA9h7549CvsOuWZLSEoSA
	 T9Q9YEze0lWSSXENNiLZkwxRa/GQz9kZvRMGgCPjpV0kidVDeLcbSWZ6oLiffYLInq
	 7MxkPCA0HkYZIsRVcR5rhWUIL9rCP+fztEpghNTU=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v3 13/21] arm64: Describe the GICv5 IRS in the DT
Date: Fri, 16 Oct 2026 16:39:31 +0100
Message-Id: <20261016153939.913764-14-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016153939.913764-1-sascha.bischoff@arm.com>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Describe the IRS CONFIG and SETLPI frames and associate each CPU
phandle with its IAFFID. This lets the guest discover and configure
the IRS for shared interrupts.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arm64/gic.c b/arm64/gic.c
index f4d446da..fe6c2059 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -477,6 +477,16 @@ void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 
 static void gic__generate_gicv5_fdt_nodes(void *fdt, struct kvm *kvm)
 {
+	char node_at_addr[64];
+	u32 cpus[kvm->nrcpus];
+	u16 iaffids[kvm->nrcpus];
+	u64 irs_reg_prop[] = {
+		cpu_to_fdt64(ARM_GICV5_IRS_CONFIG_BASE),
+		cpu_to_fdt64(ARM_GICV5_IRS_CONFIG_SIZE),
+		cpu_to_fdt64(ARM_GICV5_IRS_SETLPI_BASE),
+		cpu_to_fdt64(ARM_GICV5_IRS_SETLPI_SIZE)
+	};
+
 	_FDT(fdt_begin_node(fdt, "gicv5-cpuif"));
 	_FDT(fdt_property_string(fdt, "compatible", "arm,gic-v5"));
 	_FDT(fdt_property_cell(fdt, "#interrupt-cells", GIC_FDT_IRQ_NUM_CELLS));
@@ -488,6 +498,31 @@ static void gic__generate_gicv5_fdt_nodes(void *fdt, struct kvm *kvm)
 	/* Use a hard-coded phandle for the GIC to help wire things up */
 	_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_GIC));
 
+	/*
+	 * GICv5 IRS node
+	 */
+	snprintf(node_at_addr, sizeof(node_at_addr), "irs@%llx",
+		 (unsigned long long)ARM_GICV5_IRS_CONFIG_BASE);
+	_FDT(fdt_begin_node(fdt, node_at_addr));
+	_FDT(fdt_property_string(fdt, "compatible", "arm,gic-v5-irs"));
+	_FDT(fdt_property_cell(fdt, "#address-cells", 2));
+	_FDT(fdt_property_cell(fdt, "#size-cells", 2));
+	_FDT(fdt_property(fdt, "ranges", NULL, 0));
+
+	_FDT(fdt_property(fdt, "reg", irs_reg_prop, sizeof(irs_reg_prop)));
+	_FDT(fdt_property(fdt, "reg-names", "ns-config\0ns-setlpi",
+			  sizeof("ns-config\0ns-setlpi")));
+
+	for (int cpu = 0; cpu < kvm->nrcpus; cpu++) {
+		cpus[cpu] = cpu_to_fdt32(PHANDLE_CPU_BASE + cpu);
+		iaffids[cpu] = cpu_to_fdt16(cpu);
+	}
+
+	_FDT(fdt_property(fdt, "cpus", cpus, sizeof(u32) * kvm->nrcpus));
+	_FDT(fdt_property(fdt, "arm,iaffids", iaffids, sizeof(u16) * kvm->nrcpus));
+
+	_FDT(fdt_end_node(fdt));
+
 	_FDT(fdt_end_node(fdt));
 }
 
-- 
2.34.1

