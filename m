Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6CEC2E540F
	for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 14:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753454497; cv=none; b=jUpxejEM5xNZZjxHHx7AasE5JvSHcTbflcpjeq0GM1ixgsGAO4jG6YhKPhowZWSjK3enC/dOfRDVnIsO7FlJGR423QlYHzL0svp7yUKTRaZNCm2S6vKq4MWptKkntle8fEVNJmVsd7i51a+shAjw7FWtNMLDav9ULoK+BDRaZSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753454497; c=relaxed/simple;
	bh=EUReP6zGcBh/1+5u8pGqpft9EkVMIYZhHgl/IDXhClw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SHBtbMQGC9c8oKRZoSUQoW67mEP04+8NdntvctsfoEjchkuSnKq8b20Ull1hu4E3b7d9jUR3fbyqOIXS4jEygVzeXpFBsD+fAV+E6REC+UZJUzd9fvOZ8pOcdPhAD8vclijuMocLeNAA+2i3GUUmHXsWW/cyJJrFLYa92FSTKvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B5152C27;
	Fri, 25 Jul 2025 07:41:27 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.manchester.arm.com [10.32.101.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 22A053F6A8;
	Fri, 25 Jul 2025 07:41:33 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v2 2/6] arm64: Initial nested virt support
Date: Fri, 25 Jul 2025 15:40:56 +0100
Message-Id: <20250725144100.2944226-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250725144100.2944226-1-andre.przywara@arm.com>
References: <20250725144100.2944226-1-andre.przywara@arm.com>
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
---
 arm64/fdt.c                         |  5 ++++-
 arm64/include/kvm/kvm-config-arch.h |  5 ++++-
 arm64/kvm-cpu.c                     | 12 +++++++++++-
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arm64/fdt.c b/arm64/fdt.c
index df7775876..98f1dd9d4 100644
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
index ee031f010..a1dac28e6 100644
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
index 94c08a4d7..42dc11dad 100644
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
2.25.1

