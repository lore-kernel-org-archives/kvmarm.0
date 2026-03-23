Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 373A63C1978
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 16:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774284448; cv=none; b=DZlO9TqKqpM79sUnj5Bz0S6R5qqovnB5qF3d4VsbLG5Oq5Yr2M4aS2p2mc7t0YyEFO9LLXPGXKAt1dvPxjLAEEjvI9ez7gHKfz7vYcC+Zxh1eWGhX6h/5auY0/Ho4yVPpJAGYShHnBZoZd5yPaYbfO+DXgQrd4qs6UiHMatgOLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774284448; c=relaxed/simple;
	bh=+RVmRVYl4kI3++rQeV2EFDPMx5C/SqRFt9n33cpNVEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9lDa/Oa9btOL77KcZHn44CX1mA0uT43aojADNnSvS8QnjoszZXD/08Etcyk99G6YoqfKhSQfc1oSznbUvbJpN2ZjU9Ob80q706lfCz9K044mVx98ywf2evlF6SoR5eSo1Z3A4ozgBooRCZvwmQ01R6l3ino/FLtU6g5vfag+sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B1D821516;
	Mon, 23 Mar 2026 09:47:20 -0700 (PDT)
Received: from e142021.fritz.box (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 17DEE3F73B;
	Mon, 23 Mar 2026 09:47:24 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: maz@kernel.org,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v7 1/6] arm64: Initial nested virt support
Date: Mon, 23 Mar 2026 17:47:12 +0100
Message-ID: <20260323164717.2571585-2-andre.przywara@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260323164717.2571585-1-andre.przywara@arm.com>
References: <20260323164717.2571585-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ARMv8.3 architecture update includes support for nested
virtualization. Allow the user to specify "--nested" to start a guest in
(virtual) EL2 instead of EL1.
This will also change the PSCI conduit from HVC to SMC in the device
tree.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/fdt.c                         |  5 ++++-
 arm64/include/kvm/kvm-config-arch.h |  5 ++++-
 arm64/kvm-cpu.c                     | 12 +++++++++++-
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arm64/fdt.c b/arm64/fdt.c
index df777587..98f1dd9d 100644
--- a/arm64/fdt.c
+++ b/arm64/fdt.c
@@ -205,7 +205,10 @@ static int setup_fdt(struct kvm *kvm)
 		_FDT(fdt_property_string(fdt, "compatible", "arm,psci"));
 		fns = &psci_0_1_fns;
 	}
-	_FDT(fdt_property_string(fdt, "method", "hvc"));
+	if (kvm->cfg.arch.nested_virt)
+		_FDT(fdt_property_string(fdt, "method", "smc"));
+	else
+		_FDT(fdt_property_string(fdt, "method", "hvc"));
 	_FDT(fdt_property_cell(fdt, "cpu_suspend", fns->cpu_suspend));
 	_FDT(fdt_property_cell(fdt, "cpu_off", fns->cpu_off));
 	_FDT(fdt_property_cell(fdt, "cpu_on", fns->cpu_on));
diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
index ee031f01..a1dac28e 100644
--- a/arm64/include/kvm/kvm-config-arch.h
+++ b/arm64/include/kvm/kvm-config-arch.h
@@ -10,6 +10,7 @@ struct kvm_config_arch {
 	bool		aarch32_guest;
 	bool		has_pmuv3;
 	bool		mte_disabled;
+	bool		nested_virt;
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 	u64		fw_addr;
@@ -57,6 +58,8 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 		     "Type of interrupt controller to emulate in the guest",	\
 		     irqchip_parser, NULL),					\
 	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
-		"Address where firmware should be loaded"),
+		"Address where firmware should be loaded"),			\
+	OPT_BOOLEAN('\0', "nested", &(cfg)->nested_virt,			\
+		    "Start VCPUs in EL2 (for nested virt)"),
 
 #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index 94c08a4d..42dc11da 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -71,6 +71,12 @@ static void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init
 	/* Enable SVE if available */
 	if (kvm__supports_extension(kvm, KVM_CAP_ARM_SVE))
 		init->features[0] |= 1UL << KVM_ARM_VCPU_SVE;
+
+	if (kvm->cfg.arch.nested_virt) {
+		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL2))
+			die("EL2 (nested virt) is not supported");
+		init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2;
+	}
 }
 
 static int vcpu_configure_sve(struct kvm_cpu *vcpu)
@@ -313,7 +319,11 @@ static void reset_vcpu_aarch64(struct kvm_cpu *vcpu)
 	reg.addr = (u64)&data;
 
 	/* pstate = all interrupts masked */
-	data	= PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT | PSR_MODE_EL1h;
+	data	= PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT;
+	if (vcpu->kvm->cfg.arch.nested_virt)
+		data |= PSR_MODE_EL2h;
+	else
+		data |= PSR_MODE_EL1h;
 	reg.id	= ARM64_CORE_REG(regs.pstate);
 	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
 		die_perror("KVM_SET_ONE_REG failed (spsr[EL1])");
-- 
2.43.0

