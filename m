Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC1AC348453
	for <kvmarm@lists.linux.dev>; Wed, 11 Feb 2026 13:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770815583; cv=none; b=Eoj6Kkcg0QR1cjgkm+TAdaCD9NVFXs6nkEXW9hsZpd8TQcFt7dpG/m43pOExYV0KXDbGAw5cSXQDoeM8gt7xFcfj3+lPGBk9ybOQFFdWqEtfW7xBcU+VL53wMc9sE54IS+6mzMPK6QfHHOLpLRuw3geXVjX+fuC6qfRoKRSUvVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770815583; c=relaxed/simple;
	bh=bhGiGjfunfh7hwqLuwxU/TuGZpTJCbJtZgImSWXw2j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WY+xVSQDT1J3acgs2TMBpxhQd6YDF/Yd8jGXQ0oE7t02Cs5HjW+7Xzod8awir1Fu+ct6sm13aCU2o551u9AusMZj6qRjkG/398LGQl7b86LwGJwo49RSKPEhf5pfvDqKPVlG0KP/22PqdvlR6mFcokEA0I04r8eurbmCQZ9+/HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EEC77497;
	Wed, 11 Feb 2026 05:12:55 -0800 (PST)
Received: from orionap.fritz.box (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B19E3F63F;
	Wed, 11 Feb 2026 05:13:00 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v6 3/6] arm64: Add counter offset control
Date: Wed, 11 Feb 2026 13:12:46 +0000
Message-ID: <20260211131249.399019-4-andre.przywara@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260211131249.399019-1-andre.przywara@arm.com>
References: <20260211131249.399019-1-andre.przywara@arm.com>
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
index a1dac28..44c4336 100644
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
index 23b4dab..6e971dd 100644
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
2.47.3

