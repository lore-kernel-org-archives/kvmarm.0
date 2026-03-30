Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF223E1D17
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774880686; cv=none; b=VuTXhyqdDNXhtWXF1nHE7yDsjPuYnqVrKtj5R4XyVbkS4y3Gt5g2JhN7hlqit2/PeoXgwUkEHsIjGncqUaHQAMjYve+ylY9WCfI3OchbZeXXstMEUm1ifVzNeCOuV3VpzrZ+SMbS00xoh/qrWg11aVX5mApFF7I56PCjdIucTAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774880686; c=relaxed/simple;
	bh=1qd9jKKkciPMBnCtIYoZky5yLvK/08oE+llkGM6J0zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGrc3ZlT03e1BGUx/RAn80x7bksfNqWixLE614aIT1RvfjqQ5yaWYXE2byoeOFe8J9Wp/hYCtqgZDS9vc8kRrSzuOEce+ipg0y80mLzIoVTZzoiePEcHpVzQ/JwYrhuwnLATW10gnr0QlRJTatYPSaT2X5gcCL6xgLnjoiX1pak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=r0j5P5cT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="r0j5P5cT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D1294515;
	Mon, 30 Mar 2026 07:24:38 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5A9B03F915;
	Mon, 30 Mar 2026 07:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774880684; bh=1qd9jKKkciPMBnCtIYoZky5yLvK/08oE+llkGM6J0zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0j5P5cTyW50r4Nyj0vMQBx88DHP0/h9N3CMNXSA8MeZkZc8pZUiw5Xr79SKEscIZ
	 heig4GEMRnwktBh7VEJ8Wu13D1nmIRKnf6iNKywdzzHn2BxceidRai2A4YK7wsI3y4
	 NF3A1Oh62g4dcJxZokoUJsZiuEu9a/Y1CWIPWN6A=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev,
	will@kernel.org
Cc: kvm@vger.kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	aneesh.kumar@kernel.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v7 17/17] arm64: smccc: Start sending PSCI to userspace
Date: Mon, 30 Mar 2026 15:23:34 +0100
Message-ID: <20260330142334.3309961-18-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260330142334.3309961-1-suzuki.poulose@arm.com>
References: <20260330142334.3309961-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

kvmtool now has a PSCI implementation that complies with v1.0 of the
specification. Use the SMCCC filter to start sending these calls out to
userspace for further handling. While at it, shut the door on the
legacy, KVM-specific v0.1 functions.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v4:
 - Switch to default in-kernel PSCI
---
 arm64/include/kvm/kvm-config-arch.h |  8 +++++--
 arm64/smccc.c                       | 37 +++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
index ee031f01..f8dd088d 100644
--- a/arm64/include/kvm/kvm-config-arch.h
+++ b/arm64/include/kvm/kvm-config-arch.h
@@ -15,6 +15,7 @@ struct kvm_config_arch {
 	u64		fw_addr;
 	unsigned int	sve_max_vq;
 	bool		no_pvtime;
+	bool		psci;
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
@@ -52,11 +53,14 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 			   "Force virtio devices to use PCI as their default "	\
 			   "transport (Deprecated: Use --virtio-transport "	\
 			   "option instead)", virtio_transport_parser, kvm),	\
-        OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
+	OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
 		     "[gicv2|gicv2m|gicv3|gicv3-its]",				\
 		     "Type of interrupt controller to emulate in the guest",	\
 		     irqchip_parser, NULL),					\
 	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
-		"Address where firmware should be loaded"),
+		"Address where firmware should be loaded"),			\
+	OPT_BOOLEAN('\0', "psci", &(cfg)->psci,					\
+			"Request userspace handling of PSCI, instead of"	\
+			" relying on the in-kernel implementation"),
 
 #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
diff --git a/arm64/smccc.c b/arm64/smccc.c
index ef986d8c..47310a04 100644
--- a/arm64/smccc.c
+++ b/arm64/smccc.c
@@ -38,7 +38,44 @@ out:
 	return true;
 }
 
+static struct kvm_smccc_filter filter_ranges[] = {
+	{
+		.base		= KVM_PSCI_FN_BASE,
+		.nr_functions	= 4,
+		.action		= KVM_SMCCC_FILTER_DENY,
+	},
+	{
+		.base		= PSCI_0_2_FN_BASE,
+		.nr_functions	= 0x20,
+		.action		= KVM_SMCCC_FILTER_FWD_TO_USER,
+	},
+	{
+		.base		= PSCI_0_2_FN64_BASE,
+		.nr_functions	= 0x20,
+		.action		= KVM_SMCCC_FILTER_FWD_TO_USER,
+	},
+};
+
 void kvm__setup_smccc(struct kvm *kvm)
 {
+	struct kvm_device_attr attr = {
+		.group	= KVM_ARM_VM_SMCCC_CTRL,
+		.attr	= KVM_ARM_VM_SMCCC_FILTER,
+	};
+	unsigned int i;
 
+	if (!kvm->cfg.arch.psci)
+		return;
+
+	if (ioctl(kvm->vm_fd, KVM_HAS_DEVICE_ATTR, &attr)) {
+		pr_debug("KVM SMCCC filter not supported");
+		return;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(filter_ranges); i++) {
+		attr.addr = (u64)&filter_ranges[i];
+
+		if (ioctl(kvm->vm_fd, KVM_SET_DEVICE_ATTR, &attr))
+			die_perror("KVM_SET_DEVICE_ATTR failed");
+	}
 }
-- 
2.43.0

