Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9A2C4DEC24
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165286; cv=none; b=kH5sHXKomlENI8vw8y01oDLvaSyo3yfO7CBMS6hKAUKJuvSMVCjemUFip8kq5cL3jQ/A6HZPop0omzwK/nw27azq8Fw/R6QkP8WtAeUhBEZrt4TMKy006pnz137IPiyWtvjTk09r31389NJNnsODRt2hpfg5gLV9/x4Q4X0HLsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165286; c=relaxed/simple;
	bh=xumoI2VoQAeFDCZMZdsm/aKP4VknflJuzL4Vuq1tpYM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uuO7w6y45dNJ3zmNxeethKxaUH7RPqJPWeDDx3E/1D7fVkCLbb70DTDPyKKanB3ZUlIOdUeIHBguoNqsLVRlhRkBTgcYVtj/b2yvu6sjmDd4sc57kXTz2ci6UI4FvM5KWWpGuYLtWPVschckClPsoanfjXvTkGKDzfLtyQQ+MB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gOE4p22G; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gOE4p22G"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3A757143D;
	Fri, 16 Oct 2026 08:41:21 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E0A23F673;
	Fri, 16 Oct 2026 08:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792165284; bh=xumoI2VoQAeFDCZMZdsm/aKP4VknflJuzL4Vuq1tpYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOE4p22Grnzpu/Hlwu+GOKCjXgKT47Cvb8+f9GQcFqqMwo6zQnFa1CqD96wu07Z9s
	 tzfXqHHKESqjAhtjEU5Fx+dAVs6tMWVhpCan5FxZZWOOmAP1WwIvoDMleuic6RB5zx
	 alQw+3c6GRMbRdAiDAYru2lvfs5qstAgebXKPLEo=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v3 12/21] arm64: Describe the GICv5 CPU interface in the DT
Date: Fri, 16 Oct 2026 16:39:30 +0100
Message-Id: <20261016153939.913764-13-sascha.bischoff@arm.com>
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

Emit an interrupt-controller node for the GICv5 CPU interface. This
provides the interrupt parent and allows guests to use PPIs.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arm64/gic.c b/arm64/gic.c
index 5be71ba1..f4d446da 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -408,6 +408,8 @@ static int gic__init_gic(struct kvm *kvm)
 }
 late_init(gic__init_gic)
 
+static void gic__generate_gicv5_fdt_nodes(void *fdt, struct kvm *kvm);
+
 void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	const char *compatible, *msi_compatible = NULL;
@@ -438,6 +440,8 @@ void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 		reg_prop[2] = cpu_to_fdt64(gic_redists_base);
 		reg_prop[3] = cpu_to_fdt64(gic_redists_size);
 		break;
+	case IRQCHIP_GICV5:
+		return gic__generate_gicv5_fdt_nodes(fdt, kvm);
 	default:
 		return;
 	}
@@ -471,6 +475,22 @@ void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 	_FDT(fdt_end_node(fdt));
 }
 
+static void gic__generate_gicv5_fdt_nodes(void *fdt, struct kvm *kvm)
+{
+	_FDT(fdt_begin_node(fdt, "gicv5-cpuif"));
+	_FDT(fdt_property_string(fdt, "compatible", "arm,gic-v5"));
+	_FDT(fdt_property_cell(fdt, "#interrupt-cells", GIC_FDT_IRQ_NUM_CELLS));
+	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
+	_FDT(fdt_property_cell(fdt, "#address-cells", 2));
+	_FDT(fdt_property_cell(fdt, "#size-cells", 2));
+	_FDT(fdt_property(fdt, "ranges", NULL, 0));
+
+	/* Use a hard-coded phandle for the GIC to help wire things up */
+	_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_GIC));
+
+	_FDT(fdt_end_node(fdt));
+}
+
 u32 gic__get_fdt_irq_cpumask(struct kvm *kvm)
 {
 	/* Only for GICv2 */
-- 
2.34.1

