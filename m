Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 597F54266B0
	for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 12:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779108372; cv=none; b=eshoR+L+koKSf4IkHZyAY7+UY9UW0vIf9W6VyyfGM5c1h6KmFe3ZraLJoPtf8YFGl4q7kBMlhzISjsonFmRV5TEEfw/5sigO8zDdvzbFw2F6apBKaNfUfSsPuGCQy7kXfycW8vFocT+rZvBWgpwp4kpPJhGPF1thj1Mqi3uE9HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779108372; c=relaxed/simple;
	bh=v6alsw5G4nEeZcs0un3GghTCdnG3VBGGhp0ZZh3MD1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezZY+sXdBHag9L5ZOVxZrV+A/MkfFHv6FLe9VzmqiA0TqkHVbeby2IKz1riEiVBOnB6zTeFhgDXsXYcIrWpRFkZfC5q+1tphIIEPLURBKsoTp471FYVe2GTymPH/S1SugQzM/HRQW42QXVdH2AWEblf+oKVHQUSlW/G7es7Gns8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jVEVgCZm; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jVEVgCZm"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDA5B45BF;
	Mon, 18 May 2026 05:46:04 -0700 (PDT)
Received: from e142021.fritz.box (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D37A3F632;
	Mon, 18 May 2026 05:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779108370; bh=v6alsw5G4nEeZcs0un3GghTCdnG3VBGGhp0ZZh3MD1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVEVgCZmorbuccMcnN5ORfwGWbkafvTHXGjsL/TcUKMYWdw97xw//R6xgjXwdEUPs
	 kza416gaZtE/5QUsnUg2lAy0TBzSUGYlVKUawibrHFFYUc4gxP1disLdaswoVKOFRs
	 Hzt6aAqRW7nvnAUZT46Vcozv2IlS1fZblPnITZG8=
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v8 4/6] arm64: Add FEAT_E2H0 support
Date: Mon, 18 May 2026 14:45:54 +0200
Message-ID: <20260518124556.164739-5-andre.przywara@arm.com>
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
index 7398bf67..d321b77e 100644
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
@@ -67,6 +68,8 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 	OPT_U64('\0', "counter-offset", &(cfg)->counter_offset,			\
 		"Specify the counter offset, defaulting to 0"),			\
 	OPT_BOOLEAN('\0', "nested", &(cfg)->nested_virt,			\
-		    "Start VCPUs in EL2 (for nested virt)"),
+		    "Start VCPUs in EL2 (for nested virt)"),			\
+	OPT_BOOLEAN('\0', "e2h0", &(cfg)->e2h0,					\
+		    "Create guest without VHE support"),
 
 #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index 18f8e12e..204a80d0 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -77,6 +77,11 @@ static void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init
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
index d0dfa74a..c8570cec 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -460,6 +460,9 @@ void kvm__arch_validate_cfg(struct kvm *kvm)
 	    kvm->cfg.ram_addr + kvm->cfg.ram_size > SZ_4G) {
 		die("RAM extends above 4GB");
 	}
+
+	if (kvm->cfg.arch.e2h0 && !kvm->cfg.arch.nested_virt)
+		pr_warning("--e2h0 requires --nested, ignoring");
 }
 
 u64 kvm__arch_default_ram_address(void)
-- 
2.43.0

