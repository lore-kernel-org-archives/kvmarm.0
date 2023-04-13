Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18537E
	for <kvmarm@lists.linux.dev>; Thu, 13 Apr 2023 08:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C273C4339B;
	Thu, 13 Apr 2023 08:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681373690;
	bh=qk94MloBoHcKpco7/ng1uMPscdfXbQSqaF+NP7aMdF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WH+AyyeZa34g+wKSR6jaoKTa5ny4b6PVAHgmhPes7z8r8G2x+4yPJtn83Q2PVJWzm
	 gWGiC3QbZLubaWOzpnSS0rnmO1HlaG5b81vuZLWd4TtKJMBwBbZkGowP7AikxPLkt7
	 akMAyZB/52hzfr4APounc1WeygssrMSJ2qKHWFRtYrQgSOgALPJuLoB97xbPCaDpcL
	 oqMMhh5zG0c704A6zzDF5cCuyNnQLXHxIyOrp77IeAI40dTCH3GPANiuGdsdlJwnn/
	 gKyoClA1X4LUBiDeBaom1O2tT0FYRpcvmSYmsv2ZB4qgB1w3Fy4dDUlzYFnanTG3AQ
	 CQpkw/FKC6JKg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pms6S-0082qd-Fn;
	Thu, 13 Apr 2023 09:14:48 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Ricardo Koller <ricarkol@google.com>
Subject: [PATCH v3 1/5] KVM: arm64: nvhe: Synchronise with page table walker on vcpu run
Date: Thu, 13 Apr 2023 09:14:37 +0100
Message-Id: <20230413081441.165134-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230413081441.165134-1-maz@kernel.org>
References: <20230413081441.165134-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, ricarkol@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When taking an exception between the EL1&0 translation regime and
the EL2 translation regime, the page table walker is allowed to
complete the walks started from EL0 or EL1 while running at EL2.

It means that altering the system registers that define the EL1&0
translation regime is fraught with danger *unless* we wait for
the completion of such walk with a DSB (R_LFHQG and subsequent
statements in the ARM ARM). We already did the right thing for
other external agents (SPE, TRBE), but not the PTW.

Rework the existing SPE/TRBE synchronisation to include the PTW,
and add the missing DSB on guest exit.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/debug-sr.c |  2 --
 arch/arm64/kvm/hyp/nvhe/switch.c   | 18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 2673bde62fad..d756b939f296 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -37,7 +37,6 @@ static void __debug_save_spe(u64 *pmscr_el1)
 
 	/* Now drain all buffered data to memory */
 	psb_csync();
-	dsb(nsh);
 }
 
 static void __debug_restore_spe(u64 pmscr_el1)
@@ -69,7 +68,6 @@ static void __debug_save_trace(u64 *trfcr_el1)
 	isb();
 	/* Drain the trace buffer to memory */
 	tsb_csync();
-	dsb(nsh);
 }
 
 static void __debug_restore_trace(u64 trfcr_el1)
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index c2cb46ca4fb6..71fa16a0dc77 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -272,6 +272,17 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	__debug_save_host_buffers_nvhe(vcpu);
 
+	/*
+	 * We're about to restore some new MMU state. Make sure
+	 * ongoing page-table walks that have started before we
+	 * trapped to EL2 have completed. This also synchronises the
+	 * above disabling of SPE and TRBE.
+	 *
+	 * See DDI0487I.a D8.1.5 "Out-of-context translation regimes",
+	 * rule R_LFHQG and subsequent information statements.
+	 */
+	dsb(nsh);
+
 	__kvm_adjust_pc(vcpu);
 
 	/*
@@ -306,6 +317,13 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__timer_disable_traps(vcpu);
 	__hyp_vgic_save_state(vcpu);
 
+	/*
+	 * Same thing as before the guest run: we're about to switch
+	 * the MMU context, so let's make sure we don't have any
+	 * ongoing EL1&0 translations.
+	 */
+	dsb(nsh);
+
 	__deactivate_traps(vcpu);
 	__load_host_stage2();
 
-- 
2.34.1

