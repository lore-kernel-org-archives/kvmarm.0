Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CE42572
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 12:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661D9C4339E;
	Mon, 13 Mar 2023 12:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678711734;
	bh=O2WPspldQrJBBhNXy/zGx8BChFev5Z7rrE0fXvOAdGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enbPvjSV2q/ABLo2NkWdjhnPAbUlvhARqn+2EZCA5iYJQVuYnlLFnSj7ua6X7QeJS
	 fqpT5CLLxCrhCyQ686quThUHJ4TxC15qH6hVO8wWF9A5esRViXuHLHaVXZa4E64Mmw
	 xquAeniivqgdKSMnamkB8sHOP5FoOIQSTuwNB0fBxXT/gdHdFC3XON3ZOB2+Km9f9s
	 lszKQqhbMxeZiQ7x/f68IlHr5rB8iD70icFAX4QbAq8Fle7MJKJjWcQVPhFgufv3zb
	 lCJeDTkPHU1TV08aaSBSZa42pZEdvevmJfgYXPJgf78TRcbZRSHiQE2qK5Uid36mk+
	 QhiI5+w/b+2pQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pbhbg-00HEdE-FI;
	Mon, 13 Mar 2023 12:48:52 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ricardo Koller <ricarkol@google.com>,
	Simon Veith <sveith@amazon.de>,
	Reiji Watanabe <reijiw@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	dwmw2@infradead.org
Subject: [PATCH v2 04/19] arm64: Add HAS_ECV_CNTPOFF capability
Date: Mon, 13 Mar 2023 12:48:22 +0000
Message-Id: <20230313124837.2264882-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230313124837.2264882-1-maz@kernel.org>
References: <20230313124837.2264882-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the probing code for the FEAT_ECV variant that implements CNTPOFF_EL2.
Why it is optional is a mystery, but let's try and detect it.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 11 +++++++++++
 arch/arm64/tools/cpucaps       |  1 +
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 2e3e55139777..c331c49a7d19 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2223,6 +2223,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.sign = FTR_UNSIGNED,
 		.min_field_value = 1,
 	},
+	{
+		.desc = "Enhanced Counter Virtualization (CNTPOFF)",
+		.capability = ARM64_HAS_ECV_CNTPOFF,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		.sys_reg = SYS_ID_AA64MMFR0_EL1,
+		.field_pos = ID_AA64MMFR0_EL1_ECV_SHIFT,
+		.field_width = 4,
+		.sign = FTR_UNSIGNED,
+		.min_field_value = ID_AA64MMFR0_EL1_ECV_CNTPOFF,
+	},
 #ifdef CONFIG_ARM64_PAN
 	{
 		.desc = "Privileged Access Never",
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 37b1340e9646..40ba95472594 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -23,6 +23,7 @@ HAS_DCPOP
 HAS_DIT
 HAS_E0PD
 HAS_ECV
+HAS_ECV_CNTPOFF
 HAS_EPAN
 HAS_GENERIC_AUTH
 HAS_GENERIC_AUTH_ARCH_QARMA3
-- 
2.34.1

