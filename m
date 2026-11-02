Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655323;
	b=BXWafopzmKJI7phbY/j081zSB6CCy0OpMD3mAkPBR71DhaAh3lc5m3URZ53fQiHqudqQ
	 J3TfBsBXg/9QW84ujxISbCZzsIMZ/tbm3MrquRc/SKpRDaOQufs4KjGCxsqAAPr13825L
	 gApL9zVLK6GvsYMCSGpGxtYnNMf7Zqr2eQ2UKyXqEh3wgJXrjYngTipi1wb3IqAfqERoN
	 +dNQBTW7WugZX9CPXn8x4In1Qsk/g7PQuaLMXkorjryfr+CZpyGiA8KCaqVmR3mNFUXrg
	 b38yNlg0JR35Kh1mfw+HIhXDWl9NMDYOuKfHuaYKn5XrJmbNUamgijE0KcKTC8h+lVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655323;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=AN4a81Z9UJtQPnLgJ+RkAktom/qeg65wVEkaF18Qw/Y=;
	b=JbX4EjnBJ2FrxnNbNQOwtBgIqgMcK3DAT2ftVcWk+xIaOkpNeCISd1xjd8tThmJ75FDL
	 7+U9txK8tfmAuVZnBDtRY/LnMR6YTtKZeFoaUIXFybK55RMi6ETSgzHgsXOolTBo2IzQD
	 skIwT7BrI8bRTTWYK4mn+V/5A6hsQchojJawchJgGP0Dz/dDqDcctiBGCbXyhXar5wfoQ
	 pNNCO02WdWTEzR+Upnk+0Knc84nIlb4l83QXTwYq0MPg+xLDNnK7oXxpOKn1hmjkmwrCw
	 Vb6j1AGuOZREPfC6rq+24lLseBfH8lzABQb5SL2Rmhl4+lPvIrrpa83xOjoGz/tTzCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Fif+52Ya;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C953606D810
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:35:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C953606D810
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Fif+52Ya
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8AE31595;
	Mon,  2 Nov 2026 13:35:19 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 926303F673;
	Mon,  2 Nov 2026 13:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793655322; bh=43k+9jU20ktuHYEgwEIXmQdpwB5aJB3Ksk7i8S+YwmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fif+52Ya8ozE6ScJ3kHscKufOpKyFMwCnKn2Km2ASS+YsbNsasnWM6Ip0Uvza1+av
	 aQFXBY9WAIwuQKAstE8tvdLtJq8OD+A7dr84DYcMBLgcKM5qid8++nGwy9Ha7BpyjK
	 RpufmR7O09Ck9YJuw70C8BAnlSxehcIPsc4ApSiM=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v4 15/23] arm64: Describe the GICv5 IRS in the DT
Date: Mon,  2 Nov 2026 21:34:05 +0000
Message-Id: <20261102213413.4136118-16-sascha.bischoff@arm.com>
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

Describe the IRS CONFIG and SETLPI frames and associate each CPU
phandle with its IAFFID. This lets the guest discover and configure
the IRS for shared interrupts.

Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arm64/gic.c b/arm64/gic.c
index e69f2742..91447703 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -587,6 +587,16 @@ void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 
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
@@ -598,6 +608,31 @@ static void gic__generate_gicv5_fdt_nodes(void *fdt, struct kvm *kvm)
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

