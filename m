Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB02033859A;
	Thu,  2 Jul 2026 16:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008187; cv=none; b=blmu+mPA7RqUjETv1/qHp0gSM/21XoXwAIPAT2jM4UpprwhHraG5/hIjtiK822K3wOBh4DwvbWd6yiVeJb9ewoqpIGktgmW/OwVjwjBZ1XiB2yPxvLsZeRP2hvcxH24Wa24VoMtmySp85IGgNhFLPiAeqipJh6qSSaSh7fuV9ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008187; c=relaxed/simple;
	bh=TI6EYGOCRgNk/ucDoE12A0BQnvQn+jC2XBs9+FkWCJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9KfeHSzNgRjCgHFzC6hC7p16VHOY9YqZNpMD6f35uGh7JsPB5ENu6SyeRTZ/R4TDZ3e/wyyokNY4KUm1dHHBcgpWRd/oRvruhmmRMJ5gATBjbhFTS/lLhp52pJd2VRuRgYX05RQ7tZl72IT1uMmaxdh/khPzIxGdNOJNGGK0qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y3XgsiaF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3XgsiaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B771F0155D;
	Thu,  2 Jul 2026 16:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008185;
	bh=jlKRqeuAHeiHYifY33jkifn9qRcM+UmxYlbf8Yr05cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y3XgsiaF+BDaDucvqw2+1J6+OQI+cApN0VtERQJv7UQOsnO5EZCUMm3uhMMY++0Iv
	 A94XfxWMl1WQzXRsAH2L0u8V/+2iTumSNkzDFaG2E2pfAiBFHX19Bao7FAs7+CPjzw
	 YJS2bdWlRZ4oe7eYshByzqdQRgkc88acihLsY51cwlzjQYg1wK8xCILP8xaF55sWoj
	 83GLaPyS7z9nz8FGXtBZBMudAFD7vY6vE4vIOHD1D+D058JQowq6wrWqjm/8PsxApe
	 CCJ1E6sN2uvmKhNt0gwRhdS3LvimRMYn4hz0Fbucfsub3WMtyl9rXRerkF2ctnZPGn
	 CG4NVRqvqP8Og==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsV-00000000ojd-3SJC;
	Thu, 02 Jul 2026 16:03:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 28/28] arm64: Add override for ID_AA64MMFR4_EL1.NV_frac
Date: Thu,  2 Jul 2026 17:02:48 +0100
Message-ID: <20260702160248.1377250-29-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702160248.1377250-1-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In a very unsurprising turn of events, there is a large class of
firmware that is totally unable to deal with FEAT_NV3, and doesn't
set the required SCR2_EL3.NV3En bit, leading to an UNDEF exception
or an unhandled trap to EL3, depending on the implementation.

Allow the unfortunate user to override ID_AA64MMFR4_EL1.NV_frac
and get a working system. Hopefully firmware will be fixed before
actually HW ships, but I have been there before... :-/

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h   |  1 +
 arch/arm64/kernel/cpufeature.c        |  4 +++-
 arch/arm64/kernel/image-vars.h        |  1 +
 arch/arm64/kernel/pi/idreg-override.c | 10 ++++++++++
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index a57870fa96db5..a42683af79fb5 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -968,6 +968,7 @@ struct arm64_ftr_reg *get_arm64_ftr_reg(u32 sys_id);
 extern struct arm64_ftr_override id_aa64mmfr0_override;
 extern struct arm64_ftr_override id_aa64mmfr1_override;
 extern struct arm64_ftr_override id_aa64mmfr2_override;
+extern struct arm64_ftr_override id_aa64mmfr4_override;
 extern struct arm64_ftr_override id_aa64pfr0_override;
 extern struct arm64_ftr_override id_aa64pfr1_override;
 extern struct arm64_ftr_override id_aa64zfr0_override;
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6ae1c816e2010..14fbfa8e6b7b5 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -785,6 +785,7 @@ static const struct arm64_ftr_bits ftr_raz[] = {
 struct arm64_ftr_override __read_mostly id_aa64mmfr0_override;
 struct arm64_ftr_override __read_mostly id_aa64mmfr1_override;
 struct arm64_ftr_override __read_mostly id_aa64mmfr2_override;
+struct arm64_ftr_override __read_mostly id_aa64mmfr4_override;
 struct arm64_ftr_override __read_mostly id_aa64pfr0_override;
 struct arm64_ftr_override __read_mostly id_aa64pfr1_override;
 struct arm64_ftr_override __read_mostly id_aa64zfr0_override;
@@ -858,7 +859,8 @@ static const struct __ftr_reg_entry {
 	ARM64_FTR_REG_OVERRIDE(SYS_ID_AA64MMFR2_EL1, ftr_id_aa64mmfr2,
 			       &id_aa64mmfr2_override),
 	ARM64_FTR_REG(SYS_ID_AA64MMFR3_EL1, ftr_id_aa64mmfr3),
-	ARM64_FTR_REG(SYS_ID_AA64MMFR4_EL1, ftr_id_aa64mmfr4),
+	ARM64_FTR_REG_OVERRIDE(SYS_ID_AA64MMFR4_EL1, ftr_id_aa64mmfr4,
+			       &id_aa64mmfr4_override),
 
 	/* Op1 = 0, CRn = 10, CRm = 4 */
 	ARM64_FTR_REG(SYS_MPAMIDR_EL1, ftr_mpamidr),
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index d4c7d45ae6bc8..d15c2cb1b0f28 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -51,6 +51,7 @@ PI_EXPORT_SYM(id_aa64isar2_override);
 PI_EXPORT_SYM(id_aa64mmfr0_override);
 PI_EXPORT_SYM(id_aa64mmfr1_override);
 PI_EXPORT_SYM(id_aa64mmfr2_override);
+PI_EXPORT_SYM(id_aa64mmfr4_override);
 PI_EXPORT_SYM(id_aa64pfr0_override);
 PI_EXPORT_SYM(id_aa64pfr1_override);
 PI_EXPORT_SYM(id_aa64smfr0_override);
diff --git a/arch/arm64/kernel/pi/idreg-override.c b/arch/arm64/kernel/pi/idreg-override.c
index bc57b290e5e7b..4e47616bcac23 100644
--- a/arch/arm64/kernel/pi/idreg-override.c
+++ b/arch/arm64/kernel/pi/idreg-override.c
@@ -106,6 +106,15 @@ static const struct ftr_set_desc mmfr2 __prel64_initconst = {
 	},
 };
 
+static const struct ftr_set_desc mmfr4 __prel64_initconst = {
+	.name		= "id_aa64mmfr4",
+	.override	= &id_aa64mmfr4_override,
+	.fields		= {
+		FIELD("nv_frac", ID_AA64MMFR4_EL1_NV_frac_SHIFT, NULL),
+		{}
+	},
+};
+
 static bool __init pfr0_sve_filter(u64 val)
 {
 	/*
@@ -220,6 +229,7 @@ PREL64(const struct ftr_set_desc, reg) regs[] __prel64_initconst = {
 	{ &mmfr0	},
 	{ &mmfr1	},
 	{ &mmfr2	},
+	{ &mmfr4	},
 	{ &pfr0 	},
 	{ &pfr1 	},
 	{ &isar1	},
-- 
2.47.3

