Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4289B673
	for <kvmarm@lists.linux.dev>; Thu, 21 Mar 2024 16:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711040266; cv=none; b=UISNkkbyY2O/SfNrMODWNZIquVLJiVWLjBHhlyjJkg4eQPEbodS7kLanUURF3ecTjAOLBTuKiSBrKs5uZdAuBbadgmy4bQCnj3Tu8hpM2PCDnqt5rYRuI3cci84UMM37V4tqlxdNARMQZxNZRX4sFy9PCksxHIKLL/AM9j8xLnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711040266; c=relaxed/simple;
	bh=7/M1U7HIhSqSZiNSk95t3uWlAWU6EyJPYbvRFRZUS7c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rKg2PYiMP2Rfi9eudwLGounI/cD9K6pJXyf7CaOvpv4bJ3qWCFPI1r1x1zIb27g4j1JwGY3wujw1sTKQ8yQlEL4Z8rm/q2pmlBOfEeJg+c+TjFM6ZhTf5vr5j77WLKdkNqfV5EdjwNvjIYficB7pkDQi632O9qQop95MQ3fBM6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD19D1063;
	Thu, 21 Mar 2024 09:58:18 -0700 (PDT)
Received: from merodach.members.linode.com (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3BBF13F67D;
	Thu, 21 Mar 2024 09:57:43 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jing Zhang <jingzhangos@google.com>,
	James Morse <james.morse@arm.com>
Subject: [PATCH v3 1/6] arm64: head.S: Initialise MPAM EL2 registers and disable traps
Date: Thu, 21 Mar 2024 16:57:23 +0000
Message-Id: <20240321165728.31907-2-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240321165728.31907-1-james.morse@arm.com>
References: <20240321165728.31907-1-james.morse@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add code to head.S's el2_setup to detect MPAM and disable any EL2 traps.
This register resets to an unknown value, setting it to the default
parititons/pmg before we enable the MMU is the best thing to do.

Kexec/kdump will depend on this if the previous kernel left the CPU
configured with a restrictive configuration.

If linux is booted at the highest implemented exception level el2_setup
will clear the enable bit, disabling MPAM.

This code can't be enabled until a subsequent patch adds the Kconfig
and cpufeature boiler plate.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/el2_setup.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index b7afaa026842..1e2181820a0a 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -208,6 +208,21 @@
 	msr	spsr_el2, x0
 .endm
 
+.macro __init_el2_mpam
+#ifdef CONFIG_ARM64_MPAM
+	/* Memory Partioning And Monitoring: disable EL2 traps */
+	mrs	x1, id_aa64pfr0_el1
+	ubfx	x0, x1, #ID_AA64PFR0_EL1_MPAM_SHIFT, #4
+	cbz	x0, .Lskip_mpam_\@		// skip if no MPAM
+	msr_s	SYS_MPAM2_EL2, xzr		// use the default partition
+						// and disable lower traps
+	mrs_s	x0, SYS_MPAMIDR_EL1
+	tbz	x0, #17, .Lskip_mpam_\@		// skip if no MPAMHCR reg
+	msr_s	SYS_MPAMHCR_EL2, xzr		// clear TRAP_MPAMIDR_EL1 -> EL2
+.Lskip_mpam_\@:
+#endif /* CONFIG_ARM64_MPAM */
+.endm
+
 /**
  * Initialize EL2 registers to sane values. This should be called early on all
  * cores that were booted in EL2. Note that everything gets initialised as
@@ -225,6 +240,7 @@
 	__init_el2_stage2
 	__init_el2_gicv3
 	__init_el2_hstr
+	__init_el2_mpam
 	__init_el2_nvhe_idregs
 	__init_el2_cptr
 	__init_el2_fgt
-- 
2.39.2

