Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 343243C1980
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 16:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774284452; cv=none; b=Q7SdxJ1m3v4iuKnHK2RnCrvTMpxn3gxBTDUPG7+EoJ2bEULgkwoLZVekj5uRo3fjjKOnurRKW64uq2Wlg6rA1mMBEOfByBACw9v4FCe3iWTrS0fc8R8KZ1opuuouKQlNW+TL+niM6bXlYFsG1LhbQefJ87brICOa0jIlh2ch27I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774284452; c=relaxed/simple;
	bh=kPHHTq/UTdDQIbymD9ahuibFuYD6JNpvuFkmMN5sPy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSRmz6IKQsNapKXRX6BMWnyFad7EUOO/9ayO4jAbtt5/coJggIhh/IZTBitg1bhltiIBwDNHByudfgBldjAYZy749Dc9tmDgl71fkqEQrf7YUNsiLIlBWqNYrCZekJaf5cBrVMOFRgiWVA/l13KifWIaEZDrcFhcN3+6H9yjU/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AEB0914BF;
	Mon, 23 Mar 2026 09:47:24 -0700 (PDT)
Received: from e142021.fritz.box (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 10B363F73B;
	Mon, 23 Mar 2026 09:47:28 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: maz@kernel.org,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v7 3/6] arm64: Add counter offset control
Date: Mon, 23 Mar 2026 17:47:14 +0100
Message-ID: <20260323164717.2571585-4-andre.przywara@arm.com>
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

From: Marc Zyngier <maz@kernel.org>

KVM allows the offsetting of the global counter in order to help with
migration of a VM. This offset applies cumulatively with the offsets
provided by the architecture.

Although kvmtool doesn't provide a way to migrate a VM, controlling
this offset is useful to test the timer subsystem.

Add the command line option --counter-offset to allow setting this value
when creating a VM.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/include/kvm/kvm-config-arch.h |  3 +++
 arm64/kvm.c                         | 17 +++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
index a1dac28e..44c43367 100644
--- a/arm64/include/kvm/kvm-config-arch.h
+++ b/arm64/include/kvm/kvm-config-arch.h
@@ -14,6 +14,7 @@ struct kvm_config_arch {
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 	u64		fw_addr;
+	u64		counter_offset;
 	unsigned int	sve_max_vq;
 	bool		no_pvtime;
 };
@@ -59,6 +60,8 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 		     irqchip_parser, NULL),					\
 	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
 		"Address where firmware should be loaded"),			\
+	OPT_U64('\0', "counter-offset", &(cfg)->counter_offset,			\
+		"Specify the counter offset, defaulting to 0"),			\
 	OPT_BOOLEAN('\0', "nested", &(cfg)->nested_virt,			\
 		    "Start VCPUs in EL2 (for nested virt)"),
 
diff --git a/arm64/kvm.c b/arm64/kvm.c
index 23b4dab1..6e971dd7 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -119,6 +119,22 @@ static void kvm__arch_enable_mte(struct kvm *kvm)
 	pr_debug("MTE capability enabled");
 }
 
+static void kvm__arch_set_counter_offset(struct kvm *kvm)
+{
+	struct kvm_arm_counter_offset offset = {
+		.counter_offset = kvm->cfg.arch.counter_offset,
+	};
+
+	if (!kvm->cfg.arch.counter_offset)
+		return;
+
+	if (!kvm__supports_extension(kvm, KVM_CAP_COUNTER_OFFSET))
+		die("No support for global counter offset");
+
+	if (ioctl(kvm->vm_fd, KVM_ARM_SET_COUNTER_OFFSET, &offset))
+		die_perror("KVM_ARM_SET_COUNTER_OFFSET");
+}
+
 void kvm__arch_init(struct kvm *kvm)
 {
 	/* Create the virtual GIC. */
@@ -126,6 +142,7 @@ void kvm__arch_init(struct kvm *kvm)
 		die("Failed to create virtual GIC");
 
 	kvm__arch_enable_mte(kvm);
+	kvm__arch_set_counter_offset(kvm);
 }
 
 static u64 kvm__arch_get_payload_region_size(struct kvm *kvm)
-- 
2.43.0

