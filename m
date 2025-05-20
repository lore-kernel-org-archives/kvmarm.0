Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30392609D4;
	Tue, 20 May 2025 22:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747780089; cv=none; b=aYwk6f+GIgo/ocVP171D4v3CAFSILJjLjoQKt/IB6tk/ubugbqqFAO84ZjcxZByJih/FRdaWHFw/S5LBfifiLOht1WJNtv6pw0zhWR4CCOavgd3NTQrEwU9TN7v23sN4c3BjoWj7icNsTjdvaYaDVRcepwKbw0R/fi4henV3sEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747780089; c=relaxed/simple;
	bh=sapP8zwnsHAl+yrvVOTVkr/ymaBjo6P/Ih3XmnjzUZA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=L1ASf6RoVENgn4ZLuI6OL683G9udmftN02cPDa4VPeofLlry5TI4gVyiJjGVYU9idC6AEelOVIVGYaxlw8OKu/+R7Qd40xWznF4wjJvvsb8axglnT7exGvkoqVq/W34ki/4UEo+i0eXSzC0Xmh5abNO/sq/q+7vgWgAMqF1TEII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mvj5Az2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mvj5Az2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C535C4CEED;
	Tue, 20 May 2025 22:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747780088;
	bh=sapP8zwnsHAl+yrvVOTVkr/ymaBjo6P/Ih3XmnjzUZA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mvj5Az2uEfcrN0TbruQ8OhG3cOD7Ky3+Rt5D4YRizZyhQ++WzQK2I+A0pOi+MsWpA
	 o/3uK4zrfVR1wRaLYXsMdC03qulEH+X+xiYRV532pDjQ/+A41TRk2SwIsxLl8GDdYY
	 XT7qA7V0vqS+0/z+3kJg6WJG8QcPZTDeL7u4+CjZFeYS8SPK1vHAhygwNK9OziYMnp
	 Y09R/4/63iGdp5JT8jS6SUn+chgOHFV54LxTfC16IIcAWu6dDgVLz9XBcXo8cmaxYn
	 fkSxN6TletwhcU+GQKE693Pjxx5X3nP09b+V2f+21ZsJsHbGkJ1EvcHW5C61l9uiAb
	 JLkblgdwat6fw==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Tue, 20 May 2025 17:27:37 -0500
Subject: [PATCH v22 2/5] arm64: el2_setup.h: Make __init_el2_fgt labels
 consistent, again
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250520-arm-brbe-v19-v22-2-c1ddde38e7f8@kernel.org>
References: <20250520-arm-brbe-v19-v22-0-c1ddde38e7f8@kernel.org>
In-Reply-To: <20250520-arm-brbe-v19-v22-0-c1ddde38e7f8@kernel.org>
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, Leo Yan <leo.yan@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, Dave Martin <Dave.Martin@arm.com>
X-Mailer: b4 0.15-dev

From: Anshuman Khandual <anshuman.khandual@arm.com>

Commit 5b39db6037e7 ("arm64: el2_setup.h: Rename some labels to be more
diff-friendly") reworked the labels in __init_el2_fgt to say what's
skipped rather than what the target location is. The exception was
"set_fgt_" which is where registers are written. In reviewing the BRBE
additions, Will suggested "set_debug_fgt_" where HDFGxTR_EL2 are
written. Doing that would partially revert commit 5b39db6037e7 undoing
the goal of minimizing additions here, but it would follow the
convention for labels where registers are written.

So let's do both. Branches that skip something go to a "skip" label and
places that set registers have a "set" label. This results in some
double labels, but it makes things entirely consistent.

While we're here, the SME skip label was incorrectly named, so fix it.

Reported-by: Will Deacon <will@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
This one can be applied even if the rest of the series is not.

v22:
 - New patch
---
 arch/arm64/include/asm/el2_setup.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index ebceaae3c749..30f57b0334a3 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -204,19 +204,21 @@
 	orr	x0, x0, #(1 << 62)
 
 .Lskip_spe_fgt_\@:
+
+.Lset_debug_fgt_\@:
 	msr_s	SYS_HDFGRTR_EL2, x0
 	msr_s	SYS_HDFGWTR_EL2, x0
 
 	mov	x0, xzr
 	mrs	x1, id_aa64pfr1_el1
 	ubfx	x1, x1, #ID_AA64PFR1_EL1_SME_SHIFT, #4
-	cbz	x1, .Lskip_debug_fgt_\@
+	cbz	x1, .Lskip_sme_fgt_\@
 
 	/* Disable nVHE traps of TPIDR2 and SMPRI */
 	orr	x0, x0, #HFGxTR_EL2_nSMPRI_EL1_MASK
 	orr	x0, x0, #HFGxTR_EL2_nTPIDR2_EL0_MASK
 
-.Lskip_debug_fgt_\@:
+.Lskip_sme_fgt_\@:
 	mrs_s	x1, SYS_ID_AA64MMFR3_EL1
 	ubfx	x1, x1, #ID_AA64MMFR3_EL1_S1PIE_SHIFT, #4
 	cbz	x1, .Lskip_pie_fgt_\@
@@ -237,12 +239,14 @@
 	/* GCS depends on PIE so we don't check it if PIE is absent */
 	mrs_s	x1, SYS_ID_AA64PFR1_EL1
 	ubfx	x1, x1, #ID_AA64PFR1_EL1_GCS_SHIFT, #4
-	cbz	x1, .Lset_fgt_\@
+	cbz	x1, .Lskip_gce_fgt_\@
 
 	/* Disable traps of access to GCS registers at EL0 and EL1 */
 	orr	x0, x0, #HFGxTR_EL2_nGCS_EL1_MASK
 	orr	x0, x0, #HFGxTR_EL2_nGCS_EL0_MASK
 
+.Lskip_gce_fgt_\@:
+
 .Lset_fgt_\@:
 	msr_s	SYS_HFGRTR_EL2, x0
 	msr_s	SYS_HFGWTR_EL2, x0

-- 
2.47.2

