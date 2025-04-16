Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AD38F6E
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 12:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744806946; cv=none; b=IFwDOjNG4vY+FjbbX4xqJaX2M3TXuiXbicXsI9oe9keLpkhjggSTJ55DaJZw6cWvOaNS/UtWGQ8sQBnfG1hTWgYa45qOUQB1KMPgLwLrPL2hCBgcfaygdKD9Zjj+/Fv8sg9YXZlUv6rnKS8Tvzkcxrpmv4fuUu8dF/vYz5Pk35c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744806946; c=relaxed/simple;
	bh=TaSTqmfUWdAWMCyCDuaW1LXUde2ewk+gb8KOAkYw6WY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=PYvhr6mBmEhw2INsSNQ2gFwczzH0F5piVaNNs+dFfrMmWmUfOb7oQ3eAUzhSRDk8Yp742c1761wT779Naw51phIrLIGQ55gRkCTzy4m5wqn6oOYSpdXENABFaUvgt95hSu9ozjct93s3sQ8yhX4wr8a/FEil1jDBFJkFjpyWF+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cLTgulfo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cLTgulfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728C2C4CEEA;
	Wed, 16 Apr 2025 12:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744806946;
	bh=TaSTqmfUWdAWMCyCDuaW1LXUde2ewk+gb8KOAkYw6WY=;
	h=From:To:Cc:Subject:Date:From;
	b=cLTgulfogp2VrnwUMNRZB2EWHhXgTDNoWo9e3XjOE2b0kxWIIdcGcQZ9u0cQ+8dm4
	 E8odt1SXTW+ZebbQQZdBZfn2a+7zlN4LfaVeqTjt6khmfWrAmqwUpKB87BCUinEMe3
	 ixyKHDsYDPfyls2I/sIZ84TwEFH/4RY80QEJ0sYiXudyKanuBQoXu6E1SB6YNA1UYX
	 IfHmFRW0w0yxTHixEWSHk6QE7X7Zn1wNV8RkQ6cH9KENz2R3ouyn7pVsL5sQbDDkgv
	 +lIKIbG4U06Z5I/RN0ambB4x4jljwCZqTqiYmYR6tF5XL13Gxf1aQ4x2SAdpwt6N5a
	 DFWFolhRXyvyw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u51zU-0063Mi-AR;
	Wed, 16 Apr 2025 13:35:44 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] arm64: Remove checks for broken Cavium HW from the PI code
Date: Wed, 16 Apr 2025 13:35:34 +0100
Message-Id: <20250416123534.1108220-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, ada.coupriediaz@arm.com, catalin.marinas@arm.com, will@kernel.org, shameerali.kolothum.thodi@huawei.com, oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Calling into the MIDR checking framework from the PI code has recently
become much harder, due to the new fancy "multi-MIDR" support that
relies on tables being populated at boot time, but not that early that
they are available to the PI code. There are additional issues with
this framework, as the code really isn't position independend *at all*.

This leads to some ugly breakages, as reported by Ada.

It so appears that the only reason for the PI code to call into the
MIDR checking code is to cope with The Most Broken ARM64 System Ever,
aka Cavium ThunderX, which cannot deal with nG attributes that result
of the combination of KASLR and KPTI as a consequence of Erratum 27456.

Rather than adding extra complexity for something that is actually
a very dead horse, let's simply drop that check. On my own machine,
the firmware doesn't provide a KASLR seed, preventing the pathological
case to show up.

And if someone does have a broken box that passes a seed to the kernel,
"nokaslr" on the command-line is an easy enough workaround.

Fixes: c8c2647e69bed ("arm64: Make  _midr_in_range_list() an exported function")
Reported-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/3d97e45a-23cf-419b-9b6f-140b4d88de7b@arm.com
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/mmu.h   | 11 -----------
 arch/arm64/kernel/cpu_errata.c |  2 +-
 arch/arm64/kernel/image-vars.h |  4 ----
 3 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 30a29e88994ba..6e8aa8e726015 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -94,17 +94,6 @@ static inline bool kaslr_requires_kpti(void)
 			return false;
 	}
 
-	/*
-	 * Systems affected by Cavium erratum 24756 are incompatible
-	 * with KPTI.
-	 */
-	if (IS_ENABLED(CONFIG_CAVIUM_ERRATUM_27456)) {
-		extern const struct midr_range cavium_erratum_27456_cpus[];
-
-		if (is_midr_in_range_list(cavium_erratum_27456_cpus))
-			return false;
-	}
-
 	return true;
 }
 
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index b55f5f7057502..6b0ad5070d3e0 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -335,7 +335,7 @@ static const struct midr_range cavium_erratum_23154_cpus[] = {
 #endif
 
 #ifdef CONFIG_CAVIUM_ERRATUM_27456
-const struct midr_range cavium_erratum_27456_cpus[] = {
+static const struct midr_range cavium_erratum_27456_cpus[] = {
 	/* Cavium ThunderX, T88 pass 1.x - 2.1 */
 	MIDR_RANGE(MIDR_THUNDERX, 0, 0, 1, 1),
 	/* Cavium ThunderX, T81 pass 1.0 */
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 5e3c4b58f2790..2004b4f41ade6 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -47,10 +47,6 @@ PROVIDE(__pi_id_aa64smfr0_override	= id_aa64smfr0_override);
 PROVIDE(__pi_id_aa64zfr0_override	= id_aa64zfr0_override);
 PROVIDE(__pi_arm64_sw_feature_override	= arm64_sw_feature_override);
 PROVIDE(__pi_arm64_use_ng_mappings	= arm64_use_ng_mappings);
-#ifdef CONFIG_CAVIUM_ERRATUM_27456
-PROVIDE(__pi_cavium_erratum_27456_cpus	= cavium_erratum_27456_cpus);
-PROVIDE(__pi_is_midr_in_range_list	= is_midr_in_range_list);
-#endif
 PROVIDE(__pi__ctype			= _ctype);
 PROVIDE(__pi_memstart_offset_seed	= memstart_offset_seed);
 
-- 
2.39.2

