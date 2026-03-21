Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB3C341077;
	Sat, 21 Mar 2026 21:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774128278; cv=none; b=QSJLIfhepUWXJPQY4H16JZu+n2PzafjxWoV+IB0eGgRwScxZbSH/60mqCeOCm/6LlHkjdCYEc5hdQgypspNco+KSvtvkMznxUDACNjOyUxCB4UCA/4V6r4QUn/14e3vUEjlAOXar0esfoE5qJvN+G2xIVkshHwRTJLNUH3UD/qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774128278; c=relaxed/simple;
	bh=8bzD2dk+uDzAASOAfcr9mx9j08i2ZacZn3lcDkDtgcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiw2Mm2Jt4BBPm2RDBJMiamC57FMR2VRsw7UfgsqtmN8ft7xgmtJigYFphmvlF/DwX/IFGXZgOwzgPSZ90MAkAvxqPW/M9SjoTpxY49sihqRvXs5cLWhOdaDJ719yWgzpVCXQTNy7INwbY/8Z8lmE8J07s+IQfxLKL3HxDu3oRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J/qjAeiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J/qjAeiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1ABC19421;
	Sat, 21 Mar 2026 21:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774128278;
	bh=8bzD2dk+uDzAASOAfcr9mx9j08i2ZacZn3lcDkDtgcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/qjAeiUXbzQ6Ihtts0wvJIaBxgcU8nZ1ymWN86N26Su5HuC8vECXupgUP9rcd8Rk
	 2dDTrcI6HCMEm6NUXDvmIHm9HODPslNfrn8QvW58L/uYxYJkVW6XeUwhDPtczhgDP0
	 edE9qpPx8me7UNYUIHQy7XPXKX27QNSTYDOn9WaM8gDx1k2hpzV7vZu6rTjgDysXLX
	 FwmyJSkBZEwIik/BDgAkvY8xogXgGkeZLofyW6yWueST51BCfldeho3pd9i/VKw8su
	 LNUNxwvO0cAQlL5FY82/eyvJsx3u3rW5jAMBAeyyb+lUDSTa8ghA/htXohtvByrD5J
	 ATRYhxH5p9G9g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w43oD-00000004NPB-00TM;
	Sat, 21 Mar 2026 21:24:37 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH 5/5] KVM: arm64: Remove extra ISBs when using msr_hcr_el2
Date: Sat, 21 Mar 2026 21:24:19 +0000
Message-ID: <20260321212419.2803972-6-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321212419.2803972-1-maz@kernel.org>
References: <20260321212419.2803972-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, smostafa@google.com, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The msr_hcr_el2 macro is slightly awkward, as it provides an ISB
when CONFIG_AMPERE_ERRATUM_AC04_CPU_23 is present, and none
otherwise. Note that this this option is 'default y', meaning that
it is likely to be selected.

Most instances of msr_hcr_el2 are also immediately followed by an ISB,
meaning that in most cases, you end-up with two back-to-back ISBs.
This isn't a big deal, but once you have seen that, you can't unsee it.

Rework the msr_hcr_el2 macro to always provide the ISB, and drop
the superfluous ISBs everywhere else.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h | 2 --
 arch/arm64/include/asm/sysreg.h    | 6 ++----
 arch/arm64/kernel/hyp-stub.S       | 1 -
 arch/arm64/kvm/hyp/nvhe/host.S     | 1 -
 4 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 85f4c1615472d..3e58d6264581e 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -50,7 +50,6 @@
 	 * effectively VHE-only or not.
 	 */
 	msr_hcr_el2 x0		// Setup HCR_EL2 as nVHE
-	isb
 	mov	x1, #1		// Write something to FAR_EL1
 	msr	far_el1, x1
 	isb
@@ -64,7 +63,6 @@
 .LnE2H0_\@:
 	orr	x0, x0, #HCR_E2H
 	msr_hcr_el2 x0
-	isb
 .LnVHE_\@:
 .endm
 
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index f4436ecc630cd..ca66b8017fa87 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1114,11 +1114,9 @@
 	.macro	msr_hcr_el2, reg
 #if IS_ENABLED(CONFIG_AMPERE_ERRATUM_AC04_CPU_23)
 	dsb	nsh
-	msr	hcr_el2, \reg
-	isb
-#else
-	msr	hcr_el2, \reg
 #endif
+	msr	hcr_el2, \reg
+	isb			// Required by AMPERE_ERRATUM_AC04_CPU_23
 	.endm
 #else
 
diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 085bc9972f6bb..634ddc9042444 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -103,7 +103,6 @@ SYM_CODE_START_LOCAL(__finalise_el2)
 	// Engage the VHE magic!
 	mov_q	x0, HCR_HOST_VHE_FLAGS
 	msr_hcr_el2 x0
-	isb
 
 	// Use the EL1 allocated stack, per-cpu offset
 	mrs	x0, sp_el1
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 465f6f1dd6414..ff10cafa0ca81 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -125,7 +125,6 @@ SYM_FUNC_START(__hyp_do_panic)
 	mrs	x0, hcr_el2
 	bic	x0, x0, #HCR_VM
 	msr_hcr_el2 x0
-	isb
 	tlbi	vmalls12e1
 	dsb	nsh
 #endif
-- 
2.47.3

