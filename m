Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655319;
	b=sKq9mzr8QjV8MiNzXIG3cj0/9hIkocuEsK2YBz4nwQ9dLJJIdc6ymbAc71DKpLDz3Y37
	 JfB2JMHZr439nxtdwzEYagFAgKu2/Hh2mocJ52m76Et9zD8GMOdMRdIipSSipp2LVc4vt
	 GsTIyDqRZbOm0KmnQuB6USm4EnXUT1rx/+WqJjfGiHSDAK2zU7W+LfdUyCzt33f0Ha7rO
	 HIlCL95tPV5gu9WLg1dM1/MZlcsm1RWEFeujCKxPN567GG5npUFBGkspWe3YQyjoIw8g6
	 0nov1fsTg4WTqbu7nlvMhvvxtknA8vtC+ovFkiwbKUIssHaSbV2UFsprIL/PGDxlBRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655319;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VWYChX7kVt/Ar56jjF+RKO7ELBcmjLBSAMNrkQ/Jaus=;
	b=UHfsZrXT9F3RDv+d78OeESUZktAAM9sjozZqJEdNvyryXOTmCXym9JrUE21ZNN5Ql8Tm
	 DAhfDeClXBC/KqVxVk5WzWQwaF1pUhccRIcaxJzatRDOgUZKRafZ6mMieqK/6muNFSmfP
	 zqe7kUKZaArAujeIRoXT5avty6kCLVDyWzXGvdb10z7hfZbFqVeph/YJslPoyB8yzJmJm
	 5lcNv/g951Jja/eEqlsEawuPWGNMgqcR+xFnBrsOzVr80uzz8/KaFVywLBFGi3+3ZpMpe
	 CmYn0T1JracXLu3bQQnKsyDi9EYPLPv9LGZSvzrFddfNnLYRCVhr+UzfoAh+tsqByAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=tGjTpjVH;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27868606A332
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:35:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27868606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=tGjTpjVH
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96BD6175D;
	Mon,  2 Nov 2026 13:35:15 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6046A3F673;
	Mon,  2 Nov 2026 13:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793655318; bh=23FGpU3RZnZT1Fk+XNyEo0eetgU0rZWJJZKZU7OHS7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGjTpjVHwzxNCXaCHp7hcgK3PPtZJEk2PP9Twrhx7ut3GIG3FjzfGkMtY9EBnCN4V
	 XeOKcTbyGI0OV7yGi0S2BwC1uoQw0nFaDUhNijo1JVsIQV+Ys8bQpWKHpYFJ8umH8+
	 5lq2XVP9gASb3RLfIgDbwdCZ5KL4iPGzyC6JfUCM=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v4 14/23] arm64: Describe the GICv5 CPU interface in the DT
Date: Mon,  2 Nov 2026 21:34:04 +0000
Message-Id: <20261102213413.4136118-15-sascha.bischoff@arm.com>
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

Emit an interrupt-controller node for the GICv5 CPU interface. This
provides the interrupt parent and allows guests to use PPIs.

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arm64/gic.c b/arm64/gic.c
index a025464d..e69f2742 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -518,6 +518,8 @@ static int gic__init_gic(struct kvm *kvm)
 }
 late_init(gic__init_gic)
 
+static void gic__generate_gicv5_fdt_nodes(void *fdt, struct kvm *kvm);
+
 void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	const char *compatible, *msi_compatible = NULL;
@@ -548,6 +550,8 @@ void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 		reg_prop[2] = cpu_to_fdt64(gic_redists_base);
 		reg_prop[3] = cpu_to_fdt64(gic_redists_size);
 		break;
+	case IRQCHIP_GICV5:
+		return gic__generate_gicv5_fdt_nodes(fdt, kvm);
 	default:
 		return;
 	}
@@ -581,6 +585,22 @@ void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
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

