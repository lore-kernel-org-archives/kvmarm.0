Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A82126982F
	for <kvmarm@lists.linux.dev>; Fri, 18 Apr 2025 09:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744968698; cv=none; b=f28dCm0YY2YyiC2oJK1Ux/2OvO5PE8Tfo5Gb1x+C9Lt5XDHCifPQJeJMsOcfLFsOk+mbFskIQ4RzZXBvHASm2rWhnZ2YljH6Hz8qt5nOmi76eskzJkWtWLW/T3ocFfR0fUDHlSaKswjyAwQbscl/92zoCmRIuV5oHHf+IixMmWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744968698; c=relaxed/simple;
	bh=KwKJT0QenQUFkeleW/MiGC4rJ4im/9mwtPiqGi+3gY8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=XmQuVjerkVwHeIqDZQP8jmKHrCgTwiXDcldVFUKR9V4rPcvS824TNnxzH8XmNtzJpBnG8R4KkbJypCPB3gSIFJILP+tUTRLX0hnZmzo/WNRebBtATf9OsEdgmYhqAJJFbPqcnuhXGnYxWg3Daph7Q6paDg8koAvLfdOXT8XT70k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qlk7io6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qlk7io6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889AFC4CEEC;
	Fri, 18 Apr 2025 09:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744968697;
	bh=KwKJT0QenQUFkeleW/MiGC4rJ4im/9mwtPiqGi+3gY8=;
	h=From:To:Cc:Subject:Date:From;
	b=qlk7io6cXQ8WjMOVsZGAH3rS6rArErdHvf/8VE00Alam7tlIH2S61jJ9tRJjVLbdS
	 iRP+kSegfaGnytfkbODfkVddBdObQQGViOFm7X1s0cgejzbKGmCyLaPGjV8T3Ggq8V
	 2pivjsVl0OdFBPPPO/aND0id7oxtJcACAPQj9SwYvKI5qKNZg5MRyiCtYG6wRrF3Mm
	 dgXQmCtMcV42oL09WOwkHeKt4AODxUIOZjiYtH/ZvTtxnVE0RADeVDn1R0NxciEUN3
	 NabH4kZotOolWNmotU6kq829yJQyfwp/0Fs0o7qUQ95gTrcWGEIaNxvtD2mXwjJlyh
	 j8y+DEObIAwRQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u5i4N-006gU6-3W;
	Fri, 18 Apr 2025 10:31:35 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2] arm64: Rework checks for broken Cavium HW in the PI code
Date: Fri, 18 Apr 2025 10:31:29 +0100
Message-Id: <20250418093129.1755739-1-maz@kernel.org>
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

Duplicate the check for the erratum in the PI code, removing the
dependency on the bulk of the MIDR checking framework. This allows
dropping that same check from kaslr_requires_kpti(), as the KPTI code
already relies on the ARM64_WORKAROUND_CAVIUM_27456 cap.

Fixes: c8c2647e69bed ("arm64: Make  _midr_in_range_list() an exported function")
Reported-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/3d97e45a-23cf-419b-9b6f-140b4d88de7b@arm.com
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
---

Notes:
    * From v1 [1]:
    
      - Preserved KASLR functionnality by duplicating the MIDR checks
        in the PI code. While this is a bit ugly, it keeps everything
        working for another day, and removes a duplicate check in the
        KPTI code.
    
      - Tested in a VM to check that KASLR was still up and running. Yay!
    
    [1] https://lore.kernel.org/r/20250416123534.1108220-1-maz@kernel.org

 arch/arm64/include/asm/mmu.h      | 11 -----------
 arch/arm64/kernel/cpu_errata.c    |  2 +-
 arch/arm64/kernel/image-vars.h    |  4 ----
 arch/arm64/kernel/pi/map_kernel.c | 25 ++++++++++++++++++++++++-
 4 files changed, 25 insertions(+), 17 deletions(-)

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
 
diff --git a/arch/arm64/kernel/pi/map_kernel.c b/arch/arm64/kernel/pi/map_kernel.c
index e57b043f324b5..c6650cfe706c3 100644
--- a/arch/arm64/kernel/pi/map_kernel.c
+++ b/arch/arm64/kernel/pi/map_kernel.c
@@ -207,6 +207,29 @@ static void __init map_fdt(u64 fdt)
 	dsb(ishst);
 }
 
+/*
+ * PI version of the Cavium Eratum 27456 detection, which makes it
+ * impossible to use non-global mappings.
+ */
+static bool __init ng_mappings_allowed(void)
+{
+	static const struct midr_range cavium_erratum_27456_cpus[] __initconst = {
+		/* Cavium ThunderX, T88 pass 1.x - 2.1 */
+		MIDR_RANGE(MIDR_THUNDERX, 0, 0, 1, 1),
+		/* Cavium ThunderX, T81 pass 1.0 */
+		MIDR_REV(MIDR_THUNDERX_81XX, 0, 0),
+		{},
+	};
+
+	for (const struct midr_range *r = cavium_erratum_27456_cpus; r->model; r++) {
+		if (midr_is_cpu_model_range(read_cpuid_id(), r->model,
+					    r->rv_min, r->rv_max))
+			return false;
+	}
+
+	return true;
+}
+
 asmlinkage void __init early_map_kernel(u64 boot_status, void *fdt)
 {
 	static char const chosen_str[] __initconst = "/chosen";
@@ -246,7 +269,7 @@ asmlinkage void __init early_map_kernel(u64 boot_status, void *fdt)
 		u64 kaslr_seed = kaslr_early_init(fdt, chosen);
 
 		if (kaslr_seed && kaslr_requires_kpti())
-			arm64_use_ng_mappings = true;
+			arm64_use_ng_mappings = ng_mappings_allowed();
 
 		kaslr_offset |= kaslr_seed & ~(MIN_KIMG_ALIGN - 1);
 	}
-- 
2.39.2

