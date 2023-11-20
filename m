Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471EB1A73B
	for <kvmarm@lists.linux.dev>; Mon, 20 Nov 2023 12:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KdkvXORB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B982CC433CC;
	Mon, 20 Nov 2023 12:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700483867;
	bh=J11CtFVHtqBhTKJa3YGjPeX49bSAPr/MKFFq1o+SJc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KdkvXORB6GX0oMhAbwziRyLprTu3HSP5BlVEy+t4jcBGouRRAjGYWvWdPPKGj1XcT
	 TZfRI6KWQDZEbETCGu3EdJ2W80ejyHCFetWhV/P9fAI4+3Btob5aeL7qX/vzksZr8J
	 AHFtEvMqAUHmtQxTqh054dZO+QBjAEDI/wR+lY9uJmZJ9i5E1Ab2EqYvirTtEwyO31
	 mS2yzwL/jJeX/3quTKXkY404juCUULmCue2w1NmQgDO/wYribUiymx5rRS6jbdSNQ8
	 j2GrZejq2oZZTqgkKqsjCnvwsimha+pjsB/4mebGVdwZNpaxaP78Qr1b8EAxL2Zs1Z
	 DcBKkua4rAGdg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r53X7-00EjJv-QZ;
	Mon, 20 Nov 2023 12:37:45 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 10/13] arm64: Add MIDR-based override infrastructure
Date: Mon, 20 Nov 2023 12:37:18 +0000
Message-Id: <20231120123721.851738-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120123721.851738-1-maz@kernel.org>
References: <20231120123721.851738-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, ardb@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order to be able to use the override infrastructure to "fix"
CPUs that have deviated from teh architecture spec, add a new
pile of hacks on top of the existing one, allowing a feature
to be overriden based on matching a MIDR list.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/idreg-override.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
index 7b5b9dc20e6b..57c145bf50b7 100644
--- a/arch/arm64/kernel/idreg-override.c
+++ b/arch/arm64/kernel/idreg-override.c
@@ -321,6 +321,23 @@ static __init void parse_cmdline(void)
 		__parse_cmdline(prop, true);
 }
 
+struct midr_override_data {
+	const char		feature[FTR_ALIAS_OPTION_LEN];
+	const struct midr_range	ranges[];
+};
+
+static const struct midr_override_data * const midr_ovr_data[] __initconst = {
+};
+
+static void __init apply_midr_overrides(void)
+{
+	const u64 midr = read_cpuid_id();
+
+	for (int i = 0; i < ARRAY_SIZE(midr_ovr_data); i++)
+		if (is_midr_in_range_list(midr, midr_ovr_data[i]->ranges))
+			__parse_cmdline(midr_ovr_data[i]->feature, false);
+}
+
 /* Keep checkers quiet */
 void init_feature_override(u64 boot_status);
 
@@ -337,6 +354,8 @@ asmlinkage void __init init_feature_override(u64 boot_status)
 
 	__boot_status = boot_status;
 
+	apply_midr_overrides();
+
 	parse_cmdline();
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++) {
-- 
2.39.2

