Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF01305E3E
	for <kvmarm@lists.linux.dev>; Wed, 24 Sep 2025 13:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758721530; cv=none; b=PzD6dtxP+WK/ruEsphjaoQRvcp2E4AdEvdikQmSb0kWUvx5Lt9V8Sok3R1+mvYBFG6yRXe1tkQ+6LXiYdz3TGGZup/HSo/W+EPrB+V+CMTeSx1vuOFF+NjiTrhs4mQoYjJeD6WBqDTRNv9fHZLwiG5Aq6NqvEAHKYggjX+Lw1wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758721530; c=relaxed/simple;
	bh=Bfz3nltGgSOdWEwaV5RL1qE6Mh1cTW89qZ+FnPkbCSs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Sj60imP/NrjvMoDfUr3ythTwXMPJTdU2bvvk9jMY5ABff9IBJ7w59Q72xkoNiwGZ+3iDeG1Y4aSDU9/giM7Yft/h/YogwGvV5tTYRXz+jWuswhBmUo5+FDdYWVxXIwXgyHjS3AKaSEqh0RzBwtE2zUxhITmqXk8A/cqh4+A/Orc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E7C81713;
	Wed, 24 Sep 2025 06:45:19 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.manchester.arm.com [10.33.8.67])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 57E593F5A1;
	Wed, 24 Sep 2025 06:45:26 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v4 5/7] arm64: Add FEAT_E2H0 support
Date: Wed, 24 Sep 2025 14:45:09 +0100
Message-Id: <20250924134511.4109935-6-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250924134511.4109935-1-andre.przywara@arm.com>
References: <20250924134511.4109935-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

The --nested option allows a guest to boot at EL2 without FEAT_E2H0
(i.e. mandating VHE support). While this is great for "modern" operating
systems and hypervisors, a few legacy guests are stuck in a distant past.

To support those, add the --e2h0 command line option, that exposes
FEAT_E2H0 to the guest, at the expense of a number of other features, such
as FEAT_NV2. This is conditioned on the host itself supporting FEAT_E2H0.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm64/include/kvm/kvm-config-arch.h | 5 ++++-
 arm64/kvm-cpu.c                     | 5 +++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
index 44c43367b..73bf4211a 100644
--- a/arm64/include/kvm/kvm-config-arch.h
+++ b/arm64/include/kvm/kvm-config-arch.h
@@ -11,6 +11,7 @@ struct kvm_config_arch {
 	bool		has_pmuv3;
 	bool		mte_disabled;
 	bool		nested_virt;
+	bool		e2h0;
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 	u64		fw_addr;
@@ -63,6 +64,8 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 	OPT_U64('\0', "counter-offset", &(cfg)->counter_offset,			\
 		"Specify the counter offset, defaulting to 0"),			\
 	OPT_BOOLEAN('\0', "nested", &(cfg)->nested_virt,			\
-		    "Start VCPUs in EL2 (for nested virt)"),
+		    "Start VCPUs in EL2 (for nested virt)"),			\
+	OPT_BOOLEAN('\0', "e2h0", &(cfg)->e2h0,					\
+		    "Create guest without VHE support"),
 
 #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index 42dc11dad..5e4f3a7dd 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -76,6 +76,11 @@ static void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init
 		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL2))
 			die("EL2 (nested virt) is not supported");
 		init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2;
+		if (kvm->cfg.arch.e2h0) {
+			if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL2_E2H0))
+				die("FEAT_E2H0 is not supported");
+			init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2_E2H0;
+		}
 	}
 }
 
-- 
2.25.1

