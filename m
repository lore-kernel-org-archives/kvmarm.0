Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7781D101F2
	for <kvmarm@lists.linux.dev>; Mon, 27 Nov 2023 11:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K16ofiBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC538C433C8;
	Mon, 27 Nov 2023 11:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701085567;
	bh=JfhVXgGa+qpN3Vol8ICPhIgPDpPhDkgYUrHK4QQN2mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K16ofiBrL0ODYGo66FMYBQnbNNFkUQeZrzMFTZkdO33r3kEX/hsrWxHMKaMS+G0jK
	 LYH2URduq4G5pV9Bm9quYnQro7+OKaOR9AjDdSczqG8dwJ81A1+NH7h/EJ5xVR/CQq
	 KYCk7DTwcbaGpIF+12NZqL2uCHs6gQXX23+JVExoYMES/3O6zkV2Zl+/O+iWtjajJs
	 tnQtGq9LcolBqI7NJnTr/O5eHprkpBhqJGHz4O6pFSc8fG+VcZnQ+XNcP3KVGrSb11
	 xjiP18uaxKWLvYRUpFC2vMCmJ368XBs6yD8DY/IzDC8CjnRyBvoxZ1yNiebH4VH7jL
	 fxkxiqJclEOAQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r7a3y-00GleL-0T;
	Mon, 27 Nov 2023 11:46:06 +0000
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
Subject: [PATCH v3 10/13] arm64: Add MIDR-based override infrastructure
Date: Mon, 27 Nov 2023 11:45:56 +0000
Message-Id: <20231127114559.990314-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231127114559.990314-1-maz@kernel.org>
References: <20231127114559.990314-1-maz@kernel.org>
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
CPUs that have deviated from the architecture spec, add a new
pile of hacks on top of the existing one, allowing a feature
to be overriden based on matching a MIDR list.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
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

