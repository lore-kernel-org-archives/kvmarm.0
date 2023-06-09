Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC12200BC
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 16:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89229C433A7;
	Fri,  9 Jun 2023 16:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686327731;
	bh=RKBJeUiRouPE1bzbetDl/6+P89/xc2hCkSFuNbmCwpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8Iojz4jV/DrNY8CAI/yU3Yps/VZMr4WfDP6cNSx6UgR2UB61JXqEdnezQ0HxvstN
	 pnrkQQ4G0GVJLPV0BPpGQcedbxU6bPkIzdiLuJ2GA+OQF6d7N2Vbyp0DdzosepzvAW
	 KERB/oL1Ap20cTzQ/B+tuXLEI5BY2BK+YzxSPaD6JgTp+wQ7pB5Vi7cz6xRB6UNoV0
	 RpV+CqJFiPUiSi5KpJ9VEU+9TQUBEKgviWkTO0PCdRwqwuQ2wYqp1xOh/FOxAYFHNR
	 rAVrLsVA8wZcTMvncGHjlF/bh47e2tZbNR5iLfheklRtX5xEQnn30WL80v9fNVe1kM
	 Go1PsDTOxxPMg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1q7esL-0048L7-Mx;
	Fri, 09 Jun 2023 17:22:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v3 06/17] arm64: Allow EL1 physical timer access when running VHE
Date: Fri,  9 Jun 2023 17:21:49 +0100
Message-Id: <20230609162200.2024064-7-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609162200.2024064-1-maz@kernel.org>
References: <20230609162200.2024064-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

To initialise the timer access from EL2 when HCR_EL2.E2H is set,
we must make use the CNTHCTL_EL2 formap used is appropriate.

This amounts to shifting the timer/counter enable bits by 10
to the left.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h | 5 +++++
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 037724b19c5c..225bf1f2514d 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -34,6 +34,11 @@
  */
 .macro __init_el2_timers
 	mov	x0, #3				// Enable EL1 physical timers
+	mrs	x1, hcr_el2
+	and	x1, x1, #HCR_E2H
+	cbz	x1, .LnVHE_\@
+	lsl	x0, x0, #10
+.LnVHE_\@:
 	msr	cnthctl_el2, x0
 	msr	cntvoff_el2, xzr		// Clear virtual offset
 .endm
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index a6d67c2bb5ae..f9ee10e29497 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -95,6 +95,15 @@ SYM_CODE_START_LOCAL(___kvm_hyp_init)
 	ldr	x1, [x0, #NVHE_INIT_HCR_EL2]
 	msr	hcr_el2, x1
 
+	mov	x2, #HCR_E2H
+	and	x2, x1, x2
+	cbz	x2, 1f
+
+	mrs	x1, cnthctl_el2
+	and	x1, x1, #~(BIT(0) | BIT(1))
+	orr	x1, x1, #(BIT(10) | BIT(11))
+	msr	cnthctl_el2, x1
+1:
 	ldr	x1, [x0, #NVHE_INIT_VTTBR]
 	msr	vttbr_el2, x1
 
-- 
2.34.1

