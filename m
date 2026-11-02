Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793624518;
	b=Gztlhkk0SjV6qjMAlTC9vXQHg4o4UGL2Jx69BQdA89SGElRsEutCVlQ1OQPg+3ySfXsG
	 EIIriekrXjFb17fQYiA3YzNyTdzx1dIf47jhD9vn78a/Ue1iVeHBEmcdltSi+cMg+c+13
	 EfUw+X+FCbFh6Pfqc/Ku7Cf46Xb7tCZhXYfQwlZFWyuUO+vtwhH0aNqBAQHgXb/cYvk8P
	 cI4OMn9kf23OTy6RZ/Kz2Bx/ZZjatWpTPTWGTlaxKoI4sJTMkXzYaNilAUftA6+mGwmG1
	 WNeUQCM1cMDSthtNpowJotpsplnWVYEiIQVIoPb5ocRifdxvgfgkhJ2btZwXgb6qDQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793624518;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=+XGY/v6BR2NT4up8v10Wc/v7759RgeWyYpEIAPxEWSM=;
	b=06s+6FIBjFpRrqF9WxdqgAV9eQT1DDglS4NwXBnztcLn2c7lL2muN0V6tTQW4D1hosnn
	 YPS2FfH6pUGQfh4OelhLKCG9zFeJukePTsIGZLZK8A5ttTpkeofo77RalhcfBb47k71Lz
	 0hnIe/AVIFRYXyzx9OeY6K0WQVUeMvLDIRvM0f/+WdoEIB7YNAPRPZhFC2ffJA53+USeW
	 mXg3zkY299oLfytx2g4ZWSRG699v+GKhFSlKX33QiTe72jfnBahvF7uSQhWQl2Wn3ZqyH
	 jmPhgi/az8HGJptxhsnbhiK3ddjkMBx6WsDicjIaY9TrEgkcHYHyYqxPu5TgxAKCw5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aCND+gBl;
	arc=none smtp.remote-ip=91.218.175.251
Received: from mta0.migadu.com (out-251.mta0.migadu.com [91.218.175.251])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068AE606A338
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 13:01:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 068AE606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aCND+gBl
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=dmrpggB/4/cFopVedznZGtlVQgchY7JNs1MqKk3Qx8M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793624516; v=1; x=1794229316;
 b=aCND+gBl3SUE60WcspNfHq8tJmFeC/B+m3MDHA6phWZWDOTkKVMbFFDey5uu2Yuicl2uz/U5
 /xwp2bYU/EBRY+qmmSU6plv06GwHGgKIh4RkFDLDKtKvzmFRC3z6t2dbLTy7+640d/mSNOe9gI6
 gw7uI7bxUs7NTlr7IcIf5JyI=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9efc73450d7a3700;
	Mon, 02 Nov 2026 13:01:55 +0000
X-Mizu-Trace-ID: 9efc73450d7a3700
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
Subject: [PATCH v3 03/13] irqchip/gic-v3: Disable GICv4 features in protected KVM mode
Date: Mon,  2 Nov 2026 13:01:23 +0000
Message-ID: <20261102130133.3684226-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102130133.3684226-1-fuad.tabba@linux.dev>
References: <20261102130133.3684226-1-fuad.tabba@linux.dev>
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

Later patches have the protected KVM hypervisor take the ITS from the
host and check each command the host queues. They don't emulate the
vLPI commands, as VMAPP's VPT_base, for one, is a host-chosen address
the ITS and the redistributors write to.

Clear has_vlpis and has_rvpeid at redistributor probe in protected mode,
so the host never issues a vLPI command, and print that GICv4 is off.
The host loses GICv4 direct injection for its non-protected guests,
which is off unless kvm-arm.vgic_v4_enable is set, and can't restore a
guest saved with GICD_TYPER2.nASSGIcap set.

The test is kvm_get_mode(), as the redistributors are probed before the
cpucaps are final. It lives in irq-gic-common.h as
gic_is_protected_kvm(), so that the ITS driver can use it too and
linux/kvm_host.h stays out of the rest of irqchip.

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
index 710cab61d9195..87b5c57dec0f1 100644
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
+/* Not is_protected_kvm_enabled(): the GIC probes before the cpucaps are final. */
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
index 94873646d46fb..30ed17f26a208 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1123,6 +1123,14 @@ static void gic_update_rdist_properties(void)
 	gic_iterate_rdists(__gic_update_rdist_properties);
 	if (WARN_ON(gic_data.ppi_nr == UINT_MAX))
 		gic_data.ppi_nr = 0;
+
+	/* Protected KVM doesn't emulate the vLPI commands. */
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

