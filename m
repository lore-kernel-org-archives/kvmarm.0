Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D199C428482
	for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 12:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779108370; cv=none; b=KTR6L4XAR/AQ2nlKBnZULe7Pf/W01BwmaPvuWC0K7yYm1wkXOrE5tY9Lz12KgCSt2YcalP0FTJI8PEDGZfYUoarIoLSQur61RV2+jsY0eICpl/INBCO+/YK0OfogZAMFUB4MPv+5DGBZuweL9YSKPU0m+k0zxnV25o8WzmiloJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779108370; c=relaxed/simple;
	bh=b4+NV6vTh1gEhqympMV6tS0C8lKKHhHLEfJZnFACIDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWdX39ckFmW3ctYJe4irPBLwoO10XckThWesseCINZy7jxvfCRVNV0JNar1w93t72SwkcpwQWOKf5OiGhFh3JKlB+kJwrwVm3GhZTGxk8y5AVKdn7rE1dXp3m5QpOwGYwLFvfYCs4DeQGhgVj4tjNZiLOFRcsafTRmzxxvu7Kyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=txiJ9OTm; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="txiJ9OTm"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0FB574668;
	Mon, 18 May 2026 05:46:03 -0700 (PDT)
Received: from e142021.fritz.box (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D13593F632;
	Mon, 18 May 2026 05:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779108368; bh=b4+NV6vTh1gEhqympMV6tS0C8lKKHhHLEfJZnFACIDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txiJ9OTmbNVD1rBv7INJopYD807Yuid2212qOamXwIw+j7GmvPxs46PK091ogCGjN
	 YC87C8c0kdybDjYB/spx7Tm+ebAiQujaAPkHkGl97b9Xl71aowFMhGTmw8khPulQl5
	 565YwYTYrYbkdJIeHNyJhIzlqqlD8Jy4oq/Yux9Q=
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v8 3/6] arm64: Add counter offset control
Date: Mon, 18 May 2026 14:45:53 +0200
Message-ID: <20260518124556.164739-4-andre.przywara@arm.com>
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
index ff78d539..7398bf67 100644
--- a/arm64/include/kvm/kvm-config-arch.h
+++ b/arm64/include/kvm/kvm-config-arch.h
@@ -14,6 +14,7 @@ struct kvm_config_arch {
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 	u64		fw_addr;
+	u64		counter_offset;
 	unsigned int	sve_max_vq;
 	bool		no_pvtime;
 	bool		psci;
@@ -63,6 +64,8 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 	OPT_BOOLEAN('\0', "psci", &(cfg)->psci,					\
 			"Request userspace handling of PSCI, instead of"	\
 			" relying on the in-kernel implementation"),		\
+	OPT_U64('\0', "counter-offset", &(cfg)->counter_offset,			\
+		"Specify the counter offset, defaulting to 0"),			\
 	OPT_BOOLEAN('\0', "nested", &(cfg)->nested_virt,			\
 		    "Start VCPUs in EL2 (for nested virt)"),
 
diff --git a/arm64/kvm.c b/arm64/kvm.c
index 56e4f149..d0dfa74a 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -122,6 +122,22 @@ static void kvm__arch_enable_mte(struct kvm *kvm)
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
@@ -130,6 +146,7 @@ void kvm__arch_init(struct kvm *kvm)
 
 	kvm__arch_enable_mte(kvm);
 	kvm__setup_smccc(kvm);
+	kvm__arch_set_counter_offset(kvm);
 }
 
 
-- 
2.43.0

