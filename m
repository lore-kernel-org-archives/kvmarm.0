Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918D72F3B
	for <kvmarm@lists.linux.dev>; Thu, 20 Oct 2022 09:07:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462D4C4347C;
	Thu, 20 Oct 2022 09:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666256857;
	bh=k/BVWO+txsJJRgTuCWcujYRETMFLEr9Wr1aMiW9873k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1NMwwusqA1GZUZ9BgUEEg3ztXFZDCF53kp0yQoFR5liV+dsp1ucPlHBT6so+T6Hy
	 x4iOoqYgypmxAWduEHhZNh+ecyWHwp2t9fVBDzQh9gNgm7lDrm0MG2shnaLkITiZOk
	 mT3vJ3huN9ldEKxqCchGad2vfmN2oar4Nd1l9U6swQkiji1w96QnfxFO+Ra3T81isf
	 7n1a/pYyVQuobINrYVYVCBit/9TVMJDBid7+tPPbLvPTc5p1f7sou29C4G8HoFlqKr
	 ac077ZiRiZu+UMvGq0X/iQ9L8yqswcGhK2N5U+6m0tktcQ6fdFdJ7EJbokAkFCIc98
	 pHPYLfrdHLITQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1olRWZ-000Buf-1N;
	Thu, 20 Oct 2022 10:07:35 +0100
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>,
	<kvmarm@lists.linux.dev>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 02/17] arm64: Add KVM_HVHE capability and has_hvhe() predicate
Date: Thu, 20 Oct 2022 10:07:12 +0100
Message-ID: <20221020090727.3669908-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090727.3669908-1-maz@kernel.org>
References: <20221020090727.3669908-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20221020090712.isNqNYCIfszTX2fENXchGpRE_7kpQ7LWYIuln_pXCzk@z>

Expose a capability keying the hVHE feature as well as a new
predicate testing it. Nothing is so far using it, and nothing
is enabling it yet.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h |  1 +
 arch/arm64/include/asm/virt.h       |  8 ++++++++
 arch/arm64/kernel/cpufeature.c      | 15 +++++++++++++++
 arch/arm64/tools/cpucaps            |  1 +
 4 files changed, 25 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index f44a7860636f..2d41015429b3 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -16,6 +16,7 @@
 #define cpu_feature(x)		KERNEL_HWCAP_ ## x
 
 #define ARM64_SW_FEATURE_OVERRIDE_NOKASLR	0
+#define ARM64_SW_FEATURE_OVERRIDE_HVHE		4
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 4eb601e7de50..b11a1c8c8b36 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -140,6 +140,14 @@ static __always_inline bool is_protected_kvm_enabled(void)
 		return cpus_have_final_cap(ARM64_KVM_PROTECTED_MODE);
 }
 
+static __always_inline bool has_hvhe(void)
+{
+	if (is_vhe_hyp_code())
+		return false;
+
+	return cpus_have_final_cap(ARM64_KVM_HVHE);
+}
+
 static inline bool is_hyp_nvhe(void)
 {
 	return is_hyp_mode_available() && !is_kernel_in_hyp_mode();
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index a3959e9f7d55..efac89c4c548 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1932,6 +1932,15 @@ static void cpu_copy_el2regs(const struct arm64_cpu_capabilities *__unused)
 		write_sysreg(read_sysreg(tpidr_el1), tpidr_el2);
 }
 
+static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
+			  int __unused)
+{
+	u64 val;
+
+	val = arm64_sw_feature_override.val & arm64_sw_feature_override.mask;
+	return cpuid_feature_extract_unsigned_field(val, ARM64_SW_FEATURE_OVERRIDE_HVHE);
+}
+
 #ifdef CONFIG_ARM64_PAN
 static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
 {
@@ -2642,6 +2651,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		.cpu_enable = cpu_trap_el0_impdef,
 	},
+	{
+		.desc = "VHE for hypervisor only",
+		.capability = ARM64_KVM_HVHE,
+		.type = ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE,
+		.matches = hvhe_possible,
+	},
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index f1c0347ec31a..cee2be85b89b 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -43,6 +43,7 @@ HAS_TLB_RANGE
 HAS_VIRT_HOST_EXTN
 HAS_WFXT
 HW_DBM
+KVM_HVHE
 KVM_PROTECTED_MODE
 MISMATCHED_CACHE_TYPE
 MTE
-- 
2.34.1

