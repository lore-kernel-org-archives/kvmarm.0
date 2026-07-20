Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E495A42643F
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 13:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784553761; cv=none; b=VfKOaRNfdul8XT/WtPZBucTFC8X6OkKYWdC8xxisp5EmSL/lDMbE5dzN2ycgbJ9z+r9UgKB13vsYeZnfvwrfOVQRDvqikG7Li7D3zx4gXiTlt1/ZbPPNxb2iLz221EWVukm1L1uq2o+9YCAiacZ70tmO4d323Dh2X4XrEks4eXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784553761; c=relaxed/simple;
	bh=eYcIF21J+K5SbsOaXx1CrPyDv5Zop5SlLfsKYNv6pRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOXNWYQqyYL9qIddVrRNLx9ESPaksab7yaxuymw7HCny1eCfmYGkjCcBI10eJ0vOtLIkjDQF839suEE3q4K+hClPq9jPeyQzgb05+yDP29uHJop74pFrxkixJxREpG3FZcR4INNsc0qE69opdX+6lxbITMhNOsIvtdwG6/fnrXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XVnf0cyg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XVnf0cyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4E51F00A3A;
	Mon, 20 Jul 2026 13:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784553760;
	bh=hQNMJbiWYGixZ4+KVfGNBt46fUl3S7AjtHgErLnAUdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XVnf0cyg+hYKUTj2sszHBsxX/lXtrPV/+1GFW11N6hwXu35zduAYufbqJa+zbpSja
	 wHGss1vWCHEdJSAlsA6pdp6io0OsDseeDbBvVA21Voyf6qUC2bfUPwTY1+8YNbhvmv
	 bWzanGUWSxUQZWyjwlGT6NA4KHZd6FdUWQ9CHBU4+0Jqzg238/rigl68aiGrbwaTBB
	 gW1A42RmIi7LlxSs3nUu+BXFhgB2y506scZ/NENj2LlSv/bcSIMHbpPQRu4tM0DA7P
	 gV+C8l74/DlIJ/A/Mz0XT3EU5JNyInCpR/jlnHSo6TePo9olNSTCVnBdFXXhvxRzlF
	 SU3l5eteph8IQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wlnx8-00000006oKK-2vCP;
	Mon, 20 Jul 2026 13:22:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/5] KVM: arm64: vgic-v3: Make vtr_to_* helpers use architectural field symbols
Date: Mon, 20 Jul 2026 14:22:15 +0100
Message-ID: <20260720132220.2143486-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260720132220.2143486-1-maz@kernel.org>
References: <20260720132220.2143486-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

vgic-v3-sr.c still contains some hardcoded constants for some of
the ICH)VTR_EL2 fields. Bring them into the modern world by using
the named symbols from the sysreg file.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index c4d2f1feea8b6..8da7a40ced58a 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -16,9 +16,9 @@
 
 #include "../../vgic/vgic.h"
 
-#define vtr_to_max_lr_idx(v)		((v) & 0xf)
-#define vtr_to_nr_pre_bits(v)		((((u32)(v) >> 26) & 7) + 1)
-#define vtr_to_nr_apr_regs(v)		(1 << (vtr_to_nr_pre_bits(v) - 5))
+#define vtr_to_max_lr_idx(v)		FIELD_GET(ICH_VTR_EL2_ListRegs, (v))
+#define vtr_to_nr_pre_bits(v)		(FIELD_GET(ICH_VTR_EL2_PREbits, (v)) + 1)
+#define vtr_to_nr_apr_regs(v)		BIT(vtr_to_nr_pre_bits(v) - 5)
 
 u64 __gic_v3_get_lr(unsigned int lr)
 {
-- 
2.47.3

