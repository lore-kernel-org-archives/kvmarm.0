Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E869428489
	for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 12:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779108366; cv=none; b=B7HZbmpKLf4VqaV0bAmUqLd5VEnc8Eq0ckg4ROlcIUpjKbgJlgfvIIMnaC+5zyVy9uSqAI+RcvjY/s3Lwd0IViUE0XRqzqoYVWo6NM0drATUMm0YGV9w+k3XYbCgWvzujqmF0evivFD8cqclUw9ppnXvScWjqufTwM7BftcPwfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779108366; c=relaxed/simple;
	bh=0uX82p3HpCKzEATDyp5DMlAlwbChM0f7v01WPAKXV5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2somDHoZ4zBoj5XhDjgI3oZLQx2X0YktsUnp67XYdvq5fLeuCRH7xCptvlff+DCSQgzdgQK4yLwiO7mlT3Vy2+jVk7NYGv9M4qet4I3pWhZ23tIsSvigBw15Hr/Av2Jh+GdLTEkLmfXOhkjeArMUZGQQ2A/1luqQudFunjmxcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FsenynUL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FsenynUL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 910574617;
	Mon, 18 May 2026 05:45:59 -0700 (PDT)
Received: from e142021.fritz.box (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 694533F632;
	Mon, 18 May 2026 05:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779108364; bh=0uX82p3HpCKzEATDyp5DMlAlwbChM0f7v01WPAKXV5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FsenynULo4BXxe2VMDpACo61wxlLe7hq8mhi4w4rNdw887+QBIwFWFr3GTUBIZ6nB
	 bAWtMwsffbC2HCrLGulwkYBfXn43//nHUNV+8mH8w6zPZG2Kxvl0bbiJbfBc5nAjCu
	 fLxtCkBPRyQpoHItkd2U/UgKe+SOGqBvmMhLsQlw=
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v8 1/6] arm64: Initial nested virt support
Date: Mon, 18 May 2026 14:45:51 +0200
Message-ID: <20260518124556.164739-2-andre.przywara@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260518124556.164739-1-andre.przywara@arm.com>
References: <20260518124556.164739-1-andre.przywara@arm.com>
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
index f8dd088d..ff78d539 100644
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
@@ -61,6 +62,8 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 		"Address where firmware should be loaded"),			\
 	OPT_BOOLEAN('\0', "psci", &(cfg)->psci,					\
 			"Request userspace handling of PSCI, instead of"	\
-			" relying on the in-kernel implementation"),
+			" relying on the in-kernel implementation"),		\
+	OPT_BOOLEAN('\0', "nested", &(cfg)->nested_virt,			\
+		    "Start VCPUs in EL2 (for nested virt)"),
 
 #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index 6cd058fa..18f8e12e 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -72,6 +72,12 @@ static void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init
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
@@ -299,7 +305,11 @@ static void reset_vcpu_aarch64(struct kvm_cpu *vcpu)
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

