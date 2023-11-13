Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B34422EE4
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 17:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dUBzUWj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57605C43391;
	Mon, 13 Nov 2023 17:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699897425;
	bh=J11CtFVHtqBhTKJa3YGjPeX49bSAPr/MKFFq1o+SJc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUBzUWj6PNHQLepm3Kj8ZrAfsYX9fHaT6fVjmIQB0wmAhnrfEgwRK8pHIHreX4ZDM
	 rI+QgmvKCL/5cpu8ghGYpv8RguiqxsG00StCNiZVUfq33T0aGEGPXqxq763q6UP5bp
	 sIuPVdFZA7N8wcAsgY61+9H92qWGZu3xHxYjRLIUlz6BKaEqNrHda9jR6O7SD178Mz
	 ZLY+E4CqH+qUlj8J2+EoT1K4UTutxn18XEQWwVvrAGwhj+rVA5a0d3oZOU9R3ls+92
	 VHKZTNkyEg6y8jEbShQIAqv304VleFqKvMu0y5wPBDVI2C9fX7agEGpzqONxz5M4MP
	 ZPoysUTfYxhlQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r2ayN-00CkQ4-I4;
	Mon, 13 Nov 2023 17:43:43 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 09/12] arm64: Add MIDR-based override infrastructure
Date: Mon, 13 Nov 2023 17:42:41 +0000
Message-Id: <20231113174244.3026520-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231113174244.3026520-1-maz@kernel.org>
References: <20231113174244.3026520-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

