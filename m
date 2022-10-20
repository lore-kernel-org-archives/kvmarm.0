Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB4F7E
	for <kvmarm@lists.linux.dev>; Thu, 20 Oct 2022 09:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E184C433C1;
	Thu, 20 Oct 2022 09:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666257403;
	bh=aLcbmyX/kgZvgaopcNcriA4ZyIsxFlgipcGUgzsXUfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTCKgkNEk8Z0FKLsnxSj5WaHmv+AE3/EupRmztvJQZ71/vwlS/sa9xRqp/hC683WI
	 jJ0+QXBbIpHBn1q86vDT4v0HV9syQkYELj0anKweTu3B4NMjtWdZMSjB/xBkpbkAKT
	 jyLCAjgJLX0zHPHz+9eE/zQ9jxmu7wJEEXUBAL44JdmEN8CAAsur8HF8KQSf/HdMvb
	 wudtP9RWwbloSoKM+8DC1MKpKdSJ0hEiKKvj8AjOcakt4Pke10sMTU1W74yftEO2Fb
	 Jk9m4gAJBDfyyuOixv33//Dv243NrT3jtt+viwm2djhnXskIkgHGQs9tuVVOC9UiId
	 gYQK+Zr0GTXEg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1olRWb-000Buf-Bg;
	Thu, 20 Oct 2022 10:07:37 +0100
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
Subject: [PATCH 11/17] KVM: arm64: Disable TTBR1_EL2 when using ARM64_KVM_HVHE
Date: Thu, 20 Oct 2022 10:07:21 +0100
Message-ID: <20221020090727.3669908-12-maz@kernel.org>
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
Message-ID: <20221020090721.jXyRl4BqtPpzqiQ8xbhgGhz-cbDnjqTWFpTBzezMt5A@z>

When using hVHE, we end-up with two TTBRs at EL2. That's great,
but we're not quite ready for this just yet.

Disable TTBR1_EL2 by setting TCR_EL2.EPD1 so that we only
translate via TTBR0_EL2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 85df7ce0b051..cf0f15f4d69a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1548,7 +1548,13 @@ static void cpu_prepare_hyp_mode(int cpu)
 	 *
 	 * So use the same T0SZ value we use for the ID map.
 	 */
-	tcr = (read_sysreg(tcr_el1) & TCR_EL2_MASK) | TCR_EL2_RES1;
+	tcr = read_sysreg(tcr_el1);
+	if (cpus_have_final_cap(ARM64_KVM_HVHE)) {
+		tcr |= TCR_EPD1_MASK;
+	} else {
+		tcr &= TCR_EL2_MASK;
+		tcr |= TCR_EL2_RES1;
+	}
 	tcr &= ~TCR_T0SZ_MASK;
 	tcr |= (idmap_t0sz & GENMASK(TCR_TxSZ_WIDTH - 1, 0)) << TCR_T0SZ_OFFSET;
 	params->tcr_el2 = tcr;
-- 
2.34.1

