Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C682C3756
	for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 14:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753454501; cv=none; b=hCoYY4tXs2UCocgyLGuJndX3Ehxce+IhezCQH3MAu/Hq/Wrw8qV4PdKKOez7CXa8mRzhQ8NFxXsJ+Yu139yVBwJXLjrXfyyIVrnmzRxxDGJ3ZqrHMl1lsu0Wkx3XlC9XtDKswK0kG+JWz6MWtt9NHW2Sbmhx3UTD+rAe8QvLR8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753454501; c=relaxed/simple;
	bh=Cm7AodLQjCqZQEuBntxRevi25kytNFL96ocuwxQHjRc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bVgJxDSrZfjTI3//vc2YjDA29G3RqNIrqTBbBg3vnmEG7Pt0ZbRgalJIHzTZBUFJgiFXL6scBdno0BJ0dxpt91gL0MvEPhslhn2DMcoBmEexub+pq3j62rKDkz0VARkO/G6WEo7VjZpcLxIieYpF7A1V8IYruW9xFJa8Jqb9xAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 809621A00;
	Fri, 25 Jul 2025 07:41:30 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.manchester.arm.com [10.32.101.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A1E13F6A8;
	Fri, 25 Jul 2025 07:41:35 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v2 4/6] arm64: Add counter offset control
Date: Fri, 25 Jul 2025 15:40:58 +0100
Message-Id: <20250725144100.2944226-5-andre.przywara@arm.com>
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

From: Marc Zyngier <maz@kernel.org>

KVM now allows to offset the arch timer counter values reported to a
guest, via a per-VM ioctl. This is conceptually similar to the effects
of CNTVOFF_EL2, but applies to both the emulated physical and virtual
counter, and also to all VCPUs.

Add a command line option to allow setting this value when creating a VM.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm64/include/kvm/kvm-config-arch.h |  3 +++
 arm64/kvm.c                         | 17 +++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
index a1dac28e6..44c43367b 100644
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
index 23b4dab1f..6e971dd78 100644
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
2.25.1

