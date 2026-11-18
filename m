Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015160;
	b=MXepOSlMd/T2KuOcD6bo3fpohGeKPOJC3vZUbdjaIU68cu0QqOxB20v1k/6G2Ic582or
	 mBCB6kZHjtmDNFUV4817c+hq0/zxNrXPpVRrigalEe+reJU534w1KD/8CjBBnBvbg3m8M
	 cMT8dTc3eYNQYe4EEZS64/qDzIkGRVdd0eYhJOf2Ntj8hpSHk7E+NwyigyNfpkN0+PXfT
	 6LU0CZxoQLDG14UdaOj8TYlh+jytBnZphZOUSvTdvVAGydiajRJIVBdUmWKwHJL9q5DSD
	 FQInLUPebnWPEN2FmPHXKKBzHyAp3vT4Dy+yQA7R62qd45tGsfVQS2JtH7ABbYBabpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015160;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=yuXnA40b2u+Mi2FzfkpuShKnyxfnwry4FJFmbbBdxUg=;
	b=5Fe7K0y1KyK/SbpZrXu/rd9l8xy0Ay6GmQ9fHxuWuO9SnYx+KR3Bw7MsbniOHF42TmMP
	 vpfKLLb7XAHGVBCBA2BLpLq28qOutw7btBqjzjRRCkKPDYEH5kMhQvHDyqaR8APvOa2WL
	 h7T8GqnNQrpviNhwMKAOE+W50CGaavwul/YTEJqQF8CwFxxs+rvmY0Ve73eeKSNhau18E
	 G0l3t80em5URwUOFIdF7q+5ipoE7Ms14+ergVqWajp0VbCuEAdHcTJ0GQA8EvHGED0Zlw
	 rDGRI5pROsMmtLLqdh0Nqg2O++ECW0zs4R72sb3Osm3oZIDRlX2S4D7j3oeNACq1UUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Np15XjIh;
	arc=none smtp.remote-ip=95.215.58.195
Received: from mta1.migadu.com (out-195.mta1.migadu.com [95.215.58.195])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD03260A2612
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 15:19:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD03260A2612
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Np15XjIh
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Pp1GfdczrRGPwsK1fk1F5//bwoV0T9EmPdenf1KqcJ4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795015158; v=1; x=1795619958;
 b=Np15XjIhSULCAgrWxl0i8TAV0k8wHgKKcfiG4D7/Iz6wsLAe71TrDxpWYfmrypUd+Rx/8UsE
 yugWieuAQux5T2QhWr1yry/+iDpamQz0bg4WqWmvpZ7plD5XpzQimEXazi/zOo0UDnVY2PXxxMS
 gyY5slccec7uArkFWiBRfpA8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c7201d5f7500edcc;
	Wed, 18 Nov 2026 15:19:17 +0000
X-Mizu-Trace-ID: c7201d5f7500edcc
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sebastian Ene <sebastianene@google.com>,
	=?UTF-8?q?Bart=C5=82omiej=20Grzesik?= <bgrzesik@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Radu Rendec <radu@rendec.net>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 03/13] irqchip/gic-v3: Disable GICv4 features in pKVM
Date: Wed, 18 Nov 2026 15:18:54 +0000
Message-ID: <20261118151904.4099560-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118151904.4099560-1-fuad.tabba@linux.dev>
References: <20261118151904.4099560-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bartłomiej Grzesik <bgrzesik@google.com>

In subsequent patches the hypervisor takes the ITS from the host and
checks each command the host queues. Those patches don't emulate the
vLPI commands, as VMAPP's VPT_base, for one, is a host-chosen address
the ITS and the redistributors write to.

Clear has_vlpis and has_rvpeid at redistributor probe in protected mode,
so the host never issues a vLPI command, and print that GICv4 is off.
The host loses GICv4 direct injection for its non-protected guests, a
feature that's off unless kvm-arm.vgic_v4_enable is set. A guest
migrated from a host with GICD_TYPER2.nASSGIcap set can't be restored
either, as KVM rejects that GICD_TYPER2 value without GICv4.1. Document
the loss of direct injection in kernel-parameters.txt.

Add gic_is_protected_kvm() to irq-gic-common.h to test for protected
mode, as the ITS driver uses it too from the next patch on. It calls
kvm_get_mode(), so the header now includes linux/kvm_host.h.

Signed-off-by: Bartłomiej Grzesik <bgrzesik@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 Documentation/admin-guide/kernel-parameters.txt |  8 +++++---
 drivers/irqchip/irq-gic-common.h                | 13 +++++++++++++
 drivers/irqchip/irq-gic-v3.c                    |  8 ++++++++
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd94..3e63e44609522 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3275,8 +3275,9 @@ Kernel parameters
 				hardware (with FEAT_NV2).
 
 			Defaults to VHE/nVHE based on hardware support. Setting
-			mode to "protected" will disable kexec and hibernation
-			for the host. To force nVHE on VHE hardware, add
+			mode to "protected" will disable kexec, hibernation and
+			GICv4 direct LPI injection for the host. To force nVHE
+			on VHE hardware, add
 			"arm64_sw.hvhe=0 id_aa64mmfr1.vh=0" to the
 			command-line.
 			"nested" and "protected" are experimental and should be
@@ -3296,7 +3297,8 @@ Kernel parameters
 
 	kvm-arm.vgic_v4_enable=
 			[KVM,ARM,EARLY] Allow use of GICv4 for direct
-			injection of LPIs.
+			injection of LPIs. Has no effect when
+			kvm-arm.mode=protected.
 
 	kvm-arm.wfe_trap_policy=
 			[KVM,ARM] Control when to set WFE instruction trap for
diff --git a/drivers/irqchip/irq-gic-common.h b/drivers/irqchip/irq-gic-common.h
index 710cab61d9195..3ce1dc7abf648 100644
--- a/drivers/irqchip/irq-gic-common.h
+++ b/drivers/irqchip/irq-gic-common.h
@@ -10,6 +10,9 @@
 #include <linux/irqdomain.h>
 #include <linux/msi.h>
 #include <linux/irqchip/arm-gic-common.h>
+#ifdef CONFIG_ARM64
+#include <linux/kvm_host.h>
+#endif
 
 struct gic_quirk {
 	const char *desc;
@@ -29,6 +32,16 @@ void gic_enable_quirks(u32 iidr, const struct gic_quirk *quirks,
 void gic_enable_of_quirks(const struct device_node *np,
 			  const struct gic_quirk *quirks, void *data);
 
+#ifdef CONFIG_ARM64
+/* is_protected_kvm_enabled() can't be used, as the GIC probes before the cpucaps are final. */
+static inline bool gic_is_protected_kvm(void)
+{
+	return kvm_get_mode() == KVM_MODE_PROTECTED;
+}
+#else
+static inline bool gic_is_protected_kvm(void) { return false; }
+#endif
+
 #define RDIST_FLAGS_PROPBASE_NEEDS_FLUSHING    (1 << 0)
 #define RDIST_FLAGS_RD_TABLES_PREALLOCATED     (1 << 1)
 #define RDIST_FLAGS_FORCE_NON_SHAREABLE        (1 << 2)
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 94873646d46fb..f02c568d95653 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1123,6 +1123,14 @@ static void gic_update_rdist_properties(void)
 	gic_iterate_rdists(__gic_update_rdist_properties);
 	if (WARN_ON(gic_data.ppi_nr == UINT_MAX))
 		gic_data.ppi_nr = 0;
+
+	/* pKVM doesn't emulate the vLPI commands. */
+	if (gic_is_protected_kvm() && gic_data.rdists.has_vlpis) {
+		pr_info("GICv4 features disabled in protected KVM mode\n");
+		gic_data.rdists.has_vlpis = false;
+		gic_data.rdists.has_rvpeid = false;
+	}
+
 	pr_info("GICv3 features: %d PPIs%s%s\n",
 		gic_data.ppi_nr,
 		gic_data.has_rss ? ", RSS" : "",
-- 
2.47.3

