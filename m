Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655347;
	b=wR/PrZ0CiHeYOmc//sb9Or4lq6+gA7F+wIVa/j/LGrj870uMyAPcyElKzD/WaUZTgn+j
	 km+uNvxmhN2C8H0BievMSv08lsfotBJ4pgQ25b8NDtSLorMqput5yCHhO20IZPr6wRhRA
	 mtje7lbQcyIccEyBA+Oji5wKAnL5inH0PIZBKMl670q0okOoodh7Tfhm5467Wz4i4zzyx
	 zXm3//EjjPcFZJxntnF7/O/yiPEFBRXah/n8pcTArtbjGQR2NZMFvsCrNnn2ie7k0u0OE
	 q6BP+eA5G0kl8IdJunhDiLK4F394ciIl5ZhAOKqEXNvBPJtFgPE8NIOD0DxNi4B+V3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655347;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dnGiv57fSB8tRBhHO4hTxTN8Igh7JurugZ2Ga57Y1Oc=;
	b=j8SZ5QwTZ4rlAZlw4fvbiX8UdqFwgC0c3yLiDOoqnTB/ON2MEqJOKTbu/81QorzEMFJj
	 DJFGg05G8kaOYVNkmQjAfkQuVDjz8V7TdOTRRj6tzW6xQPhIgQjjRFTQKYdQ1+H61NkAb
	 z+nV2mXh3t2DVWt5S1RVlDwfLdTOJ9yMum/BjaosKo2zhy/LdRc9yHXnDtWT3/xJ1dTHH
	 ieWk5eqSmT4BWwjwkw4zm+d+AevgjLBE98hx5jMeqVakWFttQd2A/QdTF47BzuIex2+AZ
	 o+ISjwEjegDsCAniHc/1swQkc+rP6+XnDiQgh7Ff/sha+W8WsHFXmGgblBKFUX1wOzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=HlJDW6u8;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534C8606A33D
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:35:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 534C8606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=HlJDW6u8
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A51941595;
	Mon,  2 Nov 2026 13:35:43 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9E8A83F673;
	Mon,  2 Nov 2026 13:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793655346; bh=a0AmMyXowohuDt4LPdeW03BlhZ/e81olal2W92DqvQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HlJDW6u8WHgis9UUZ6I21UhiZT8ikTYoNOnvaTgEMhHCN7zdmdi6MHarYMDFwbsgo
	 5SXKx5Yyx/WqgIb55tPwFF7JGJxYFRJa9fRqm3CGL+XEV0pNBSm5wAtPf6q8LV/tHb
	 v8zlYS1wuNdjR77Q0yGGbffDaIpz5TwHQs5MpT98=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v4 21/23] arm64: Describe the GICv5 ITS in the DT
Date: Mon,  2 Nov 2026 21:34:11 +0000
Message-Id: <20261102213413.4136118-22-sascha.bischoff@arm.com>
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

Add an ITS node below the GICv5 IRS node with the CONFIG frame as its
register region. Add an MSI controller child node for the TRANSLATE
frame, with a phandle and one MSI cell carrying the DeviceID.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arm64/gic.c b/arm64/gic.c
index fca99aef..9a928e23 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -565,6 +565,7 @@ void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 		reg_prop[2] = cpu_to_fdt64(gic_redists_base);
 		reg_prop[3] = cpu_to_fdt64(gic_redists_size);
 		break;
+	case IRQCHIP_GICV5_ITS:
 	case IRQCHIP_GICV5:
 		return gic__generate_gicv5_fdt_nodes(fdt, kvm);
 	default:
@@ -612,6 +613,16 @@ static void gic__generate_gicv5_fdt_nodes(void *fdt, struct kvm *kvm)
 		cpu_to_fdt64(ARM_GICV5_IRS_SETLPI_SIZE)
 	};
 
+	u64 its_config_reg_prop[] = {
+		cpu_to_fdt64(ARM_GICV5_ITS_CONFIG_BASE),
+		cpu_to_fdt64(ARM_GICV5_ITS_CONFIG_SIZE),
+	};
+
+	u64 its_trans_reg_prop[] = {
+		cpu_to_fdt64(ARM_GICV5_ITS_TRANSL_BASE),
+		cpu_to_fdt64(ARM_GICV5_ITS_TRANSL_SIZE)
+	};
+
 	_FDT(fdt_begin_node(fdt, "gicv5-cpuif"));
 	_FDT(fdt_property_string(fdt, "compatible", "arm,gic-v5"));
 	_FDT(fdt_property_cell(fdt, "#interrupt-cells", GIC_FDT_IRQ_NUM_CELLS));
@@ -646,6 +657,36 @@ static void gic__generate_gicv5_fdt_nodes(void *fdt, struct kvm *kvm)
 	_FDT(fdt_property(fdt, "cpus", cpus, sizeof(u32) * kvm->nrcpus));
 	_FDT(fdt_property(fdt, "arm,iaffids", iaffids, sizeof(u16) * kvm->nrcpus));
 
+	if (kvm->cfg.arch.irqchip == IRQCHIP_GICV5_ITS) {
+		/*
+		 * GICv5 ITS node
+		 */
+		snprintf(node_at_addr, sizeof(node_at_addr), "its@%llx",
+			 (unsigned long long)ARM_GICV5_ITS_CONFIG_BASE);
+		_FDT(fdt_begin_node(fdt, node_at_addr));
+		_FDT(fdt_property_string(fdt, "compatible", "arm,gic-v5-its"));
+		_FDT(fdt_property_cell(fdt, "#address-cells", 2));
+		_FDT(fdt_property_cell(fdt, "#size-cells", 2));
+		_FDT(fdt_property(fdt, "ranges", NULL, 0));
+
+		_FDT(fdt_property(fdt, "reg", its_config_reg_prop, sizeof(its_config_reg_prop)));
+		_FDT(fdt_property_string(fdt, "reg-names", "ns-config"));
+
+		snprintf(node_at_addr, sizeof(node_at_addr), "msi-controller@%llx",
+			 (unsigned long long)ARM_GICV5_ITS_TRANSL_BASE);
+		_FDT(fdt_begin_node(fdt, node_at_addr));
+		_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_MSI));
+		_FDT(fdt_property(fdt, "msi-controller", NULL, 0));
+		_FDT(fdt_property_cell(fdt, "#msi-cells", 1));
+
+		_FDT(fdt_property(fdt, "reg", its_trans_reg_prop, sizeof(its_trans_reg_prop)));
+		_FDT(fdt_property_string(fdt, "reg-names", "ns-translate"));
+
+		_FDT(fdt_end_node(fdt));
+
+		_FDT(fdt_end_node(fdt));
+	}
+
 	_FDT(fdt_end_node(fdt));
 
 	_FDT(fdt_end_node(fdt));
-- 
2.34.1

