Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619725;
	b=Hx5qtXEFziXp9inFFs/zwNDkUcZoJKgg3tVFpwvDY3nyXUjRu187DYV+JmHjyvYHFwuc
	 SsJpcVR8BnXRCFPcK6idCi/0hZJJoW2qQjamLxbcDgGHXD1pE5HlS5kX8TmcVdc8Qkl//
	 4KRFhC6c7sANYoVg1qPka/BNndoi6ythWQVnFvPg9ta4dRmoKazC2VQsoNu/FwdlAtKm6
	 h31yJ+qu9j3FHmhJZOXoJQ2FrrYcZB2qYHXC7TqfmtbJp27GDf7TFcEIO/2kL29nc42kK
	 SfEXYHM0FK/RNgKm0cBZGgSa2ZwCW2oGawsKW9+srpp1HQEfNBvTzS0p7O9a87xvUNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619725;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sVeUM7PYjoZl0XexUgZOyRY3GGL7HkpyTBaRmjJcIqY=;
	b=U1G3TuZgPcWObWrqAqIFp6gPQFinqQ+OjTbjooRLRP52RfelX+AIqRyyfFGoMy5xBhhS
	 wm0xJb1q67dBlOQY7TRNV3Gxz/sMzIMviurfOzsQtxK94K33GstjuXiigNn1bz9ujB8or
	 rBM6UuEbs3DGvRNL/vdgQpzKdCzrL8rd8ZDsK38BchHH+3wXp8clUsVYNK5BXP8lguQiE
	 COZteeAPsCOpGVB2RV+Y8LFerGmhmvA/s0zUc+kydC/21tDD/xujewKLpGJX3zDg6I3Vv
	 36zfoQYqpNZJ08PD9TKPol7PzctrR02v4e+8dg/erx/QoMR9TUmsf7V50c9mLKAGFnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=f8eucpjV;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB06B606A339
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:15:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB06B606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=f8eucpjV
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71BA9339;
	Wed, 25 Nov 2026 07:15:21 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3342E3F86F;
	Wed, 25 Nov 2026 07:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795619724; bh=m7u3BfYAAC+NVRHgaVf9lgplxLQ94nx3BowthsLdVUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8eucpjVs0B6IHxNhmb2LkOwsLGsGKfddcoKfAnCFyMVDv7VHnv0zAg+5aiUKxw+W
	 AF88XXe7pc5pMgQmfRfTVmixEwFKxmVFDemETogJuVWKFF8immGggl/hCYEqJZmEGs
	 dOP51lvwsU5Wuu48+WtDIoPAkOYz7FtPuYm53e84=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v6 21/23] arm64: Describe the GICv5 ITS in the DT
Date: Wed, 25 Nov 2026 15:13:54 +0000
Message-Id: <20261125151356.2875108-22-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261125151356.2875108-1-sascha.bischoff@arm.com>
References: <20261125151356.2875108-1-sascha.bischoff@arm.com>
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
index 2a59ca2e..2b24f5b6 100644
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
@@ -611,6 +612,16 @@ static void gic__generate_gicv5_fdt_nodes(void *fdt, struct kvm *kvm)
 		cpu_to_fdt64(ARM_GICV5_IRS_CONFIG_SIZE),
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
@@ -644,6 +655,36 @@ static void gic__generate_gicv5_fdt_nodes(void *fdt, struct kvm *kvm)
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

