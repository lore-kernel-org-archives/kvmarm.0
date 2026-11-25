Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619702;
	b=QBt6MrjSdiK3/1atwkH6xPomCHOHp/uMYLVIKNIx0TUCugjfCxVfjc3hMhLfTp8WE49u
	 cGPsvM9VLOt+vSa4CsfNODtHLaV4WnO+zKcg1KJAvPSpdnGeG8rcHy5U16/GsQBavcCMF
	 eiox3458qTs2/fpJ81yy8ta+mWVG/clHZNo065iQa0DjJsSmvu1v0Cozch02ItI3lXpOa
	 JbICpWXbv5OE12iYYgZ8mFapnoN7dHI7QatJ3ybM0qUtq/09D9bl8/0Q65x5dXRQP5d7n
	 F7AExUprVC8+VlKUwYSWOZKjsMfJFWHpZSKPWXJAc4yQgC6fknhflORiNwE5RNO9Xkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619702;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7IjkaBGmYu85g24uQenlccDZhi7fu0Y7Y254ywFpT6E=;
	b=x/EMtGdH/7qWKOBCZ2hOQBeaK30mit6T2HYvy75Lq+3mY69WERHH8c7hEVqQiE6HTRSJ
	 MrkwvM0nFxAfYomDO56feiJvGPVujdT232vZlZzPdB+Qt1z72/yByh9HOYfV3egmXNiGt
	 lgri/93y/fI///HFJTM0e+bVCwl4YUi4eEVKqdeKiL6SteNZ9vccEooUVLzj0hqOTnTVt
	 fJnwLKpOjp4h+lpGL1YGIPuFy0iagP2PkUx5w5eg7NZlacJZM7uksii5iyM38Rr+r9tsa
	 8umNvckHcY64pEsx2a5+Jjy4ykto2bMTxmKRl+6rfu9a6RheKoshRlPy40N8O6iAIAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="N2rr1i5/";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC7B6606A331
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:15:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC7B6606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=N2rr1i5/
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4835C1596;
	Wed, 25 Nov 2026 07:14:58 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B6343F86F;
	Wed, 25 Nov 2026 07:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795619701; bh=J0TQJvWtX9geqJfP7DW01jkzi/iokZhh74xeAdUCbqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2rr1i5/uXw4L7s9iYGSBNH1h96AjQx6paHiwocpvlkxlZ9P6MP5PXdOdGICqW6RS
	 C5xCyoqeEJuPaIJLI3kjgyuIhAsGteb1kgF2SMmN1mBjzusS5RsbPV+06pdJEsY+2t
	 Ib6y1am6fcElDEd6rTpLd4KM0PsvwGnsnDuUHweg=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v6 15/23] arm64: Describe the GICv5 IRS in the DT
Date: Wed, 25 Nov 2026 15:13:48 +0000
Message-Id: <20261125151356.2875108-16-sascha.bischoff@arm.com>
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

Describe the IRS CONFIG frame and associate each CPU phandle with its
IAFFID. This lets the guest discover and configure the IRS for shared
interrupts.

KVM reserves address space for the adjacent SETLPI frame but does not
currently emulate it, so leave it out of the guest DT.

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arm64/gic.c b/arm64/gic.c
index 9a8f9916..955eeb5f 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -588,6 +588,15 @@ void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 
 static void gic__generate_gicv5_fdt_nodes(void *fdt, struct kvm *kvm)
 {
+	char node_at_addr[64];
+	u32 cpus[kvm->nrcpus];
+	u16 iaffids[kvm->nrcpus];
+	/* KVM reserves the SETLPI frame but does not emulate it. */
+	u64 irs_reg_prop[] = {
+		cpu_to_fdt64(ARM_GICV5_IRS_CONFIG_BASE),
+		cpu_to_fdt64(ARM_GICV5_IRS_CONFIG_SIZE),
+	};
+
 	_FDT(fdt_begin_node(fdt, "gicv5-cpuif"));
 	_FDT(fdt_property_string(fdt, "compatible", "arm,gic-v5"));
 	_FDT(fdt_property_cell(fdt, "#interrupt-cells", GIC_FDT_IRQ_NUM_CELLS));
@@ -599,6 +608,30 @@ static void gic__generate_gicv5_fdt_nodes(void *fdt, struct kvm *kvm)
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
+	_FDT(fdt_property_string(fdt, "reg-names", "ns-config"));
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

