Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798997;
	b=DF36OB2eGSEHO4huYfAsFqJkl68HtoxMbIAhPP1e+CYlg3J2rlTlC5cXjuJlDDCQw000
	 GeM4xIoa19ZRrnUG6kF1nt9yCN50rn2z7gr+isgrgXxCPoh+5a+/djprLXBJrpbPOIUAM
	 HMWuH644KLSvVCvR2gf6DkVPPavnXvpA3pPht36th9LJzYzmTjXHPUHVfw3/fspy2mSst
	 pfUiIk8j4AccvTDicPtu2DkRktMcg+cIR1WxAyDTVyKKEbK1og/hcJYL9cfy+G9Mh6eSJ
	 Oml60w9VRK+tj3DSk8UgV3Q4+B7tx/BFpfJ9I6suR78mErnzouRn2jfBq7/++qM2BrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798997;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sVeUM7PYjoZl0XexUgZOyRY3GGL7HkpyTBaRmjJcIqY=;
	b=lbSg+KWgS/lzRmJnul0SdKi2wVK+uOnUHEUyLuOEF1znVGVzdzqKOSNoHFmtrmjPPrIx
	 kPyXNjwuzURddW55bhV3NyWqrH8w0x2oPOhFHtCQumsjYVWt801kRn5actQQIJr0Pa/0e
	 1ONO8aGYQbjzlOaCaiEc33ANHy6BjPmpJNUIM9JtlqjscZ7xohZ/nYAt2rbIUgh/w2R6F
	 c9wE7C4YEq8lmgx0rOo8xj15gLNr+kggwpf0QQyOxK019bhAnP2KkVR/hjmP5VDjpl8aE
	 Pj12lahvIv15mP67w7DczzRghinMctylXxFdq2/MufglXBfgFsRSYWzIXznkyJiKUzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="h6/1fm+A";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8180606A31E
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 17:03:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8180606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=h6/1fm+A
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A326D1575;
	Fri, 27 Nov 2026 09:03:13 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 31EBC3F632;
	Fri, 27 Nov 2026 09:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795798996; bh=m7u3BfYAAC+NVRHgaVf9lgplxLQ94nx3BowthsLdVUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6/1fm+A98588obH2Mh2wC9FnnBIJiOEJ/n2J9GQbM9/h/ssMzs2aCsN8oaPtLhjO
	 Zo9/7lg4yE9aDV51ltoaNOGdAzo6Kc2THOaKB0ZwexvdVBCToL1xq3A57lT5irJNWo
	 sNezO7IntY1x/j3yhp2mPEVykeh/tVtM2TjWBPDg=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v7 21/23] arm64: Describe the GICv5 ITS in the DT
Date: Fri, 27 Nov 2026 17:01:43 +0000
Message-Id: <20261127170145.4138182-22-sascha.bischoff@arm.com>
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

