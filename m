Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6A7134EF06
	for <kvmarm@lists.linux.dev>; Wed, 11 Feb 2026 13:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770815585; cv=none; b=KLR4cY3Ttb0TuqIjH6XpimI9BdGBMBCZXU+VzKsApYiTqYVzAfZfQpstFuqGnrdxd3ywMgXT7AHtxqnj/9b/OZvizaetj3NpvyOYuxJH3pJqwUG0YNepxkL0AgSlOtXUFXyi1NdWxjWWyGDFhtwb326j6j8+yXGNeTGM2i91nSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770815585; c=relaxed/simple;
	bh=uBBgMAh3fTNtPJTdSyzd9xz5hgiv5fOpaeT/FyDwg3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szyoEQqP5jER0uFS+mf/FG5Qp+ztAnwx20Y1lgHUfIAEFChtYyID4uRyi9bi2dXoIqeHMEFyUKjRkkxReiNHy8BFiqvaiwUUbJWmqklVA61HLe3y/ZvCPRAqkt0vsE5PPL78r6MLBJ9AbvlmfVSX8IWK3aPQTniqo7Lx4SBF68s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09E03339;
	Wed, 11 Feb 2026 05:12:58 -0800 (PST)
Received: from orionap.fritz.box (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AA6533F63F;
	Wed, 11 Feb 2026 05:13:02 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v6 4/6] arm64: Add FEAT_E2H0 support
Date: Wed, 11 Feb 2026 13:12:47 +0000
Message-ID: <20260211131249.399019-5-andre.przywara@arm.com>
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

The --nested option allows a guest to boot at EL2 without FEAT_E2H0
(i.e. mandating VHE support). While this is great for "modern" operating
systems and hypervisors, a few legacy guests are stuck in a distant past.

To support those, add the --e2h0 command line option, that exposes
FEAT_E2H0 to the guest, at the expense of a number of other features, such
as FEAT_NV2. This is conditioned on the host itself supporting FEAT_E2H0.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/include/kvm/kvm-config-arch.h | 5 ++++-
 arm64/kvm-cpu.c                     | 5 +++++
 arm64/kvm.c                         | 3 +++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
index 44c4336..73bf421 100644
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
index 42dc11d..5e4f3a7 100644
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
 
diff --git a/arm64/kvm.c b/arm64/kvm.c
index 6e971dd..4ce2493 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -440,6 +440,9 @@ void kvm__arch_validate_cfg(struct kvm *kvm)
 	    kvm->cfg.ram_addr + kvm->cfg.ram_size > SZ_4G) {
 		die("RAM extends above 4GB");
 	}
+
+	if (kvm->cfg.arch.e2h0 && !kvm->cfg.arch.nested_virt)
+		pr_warning("--e2h0 requires --nested, ignoring");
 }
 
 u64 kvm__arch_default_ram_address(void)
-- 
2.47.3

