Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EBC17AC2
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 16:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AED1C4339C;
	Fri,  9 Jun 2023 16:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686329231;
	bh=XkWyzW+sSMEWSg65caOPf/zhuNHxIwdjYYA7HpLQriM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wi0yJCh1JNMzkI2EZVWEC7w6mOyvB8mtUmtueCaBbF1qwmoK2hgxNQRobsuhE2Ppn
	 rgCwB04pzTmN/Ip0Gv+K9CABH0Yb02qikj97+sPplninGfN+vGKoFMTCXhZTQdqcQx
	 chTtaTR1tnTjqYlfP0ElCpN/gc69KbKT5lkViXuzEXxg1p5VWefOggD0iggNoJAw/a
	 J20mMIfGANa7gM6pHBVbSwzuRl9dKZPknNBiHXP2HxlLJZqC3/71buDXMY5xe2aer8
	 ExDW/g342lUHONopvc9P8k06/gpVMQJPG15npLU4wqCnO6wPHwBSaWVeOtAyaK9nOD
	 cECaTrbud+SMg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1q7esM-0048L7-Ov;
	Fri, 09 Jun 2023 17:22:10 +0100
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
Subject: [PATCH v3 11/17] KVM: arm64: Disable TTBR1_EL2 when using ARM64_KVM_HVHE
Date: Fri,  9 Jun 2023 17:21:54 +0100
Message-Id: <20230609162200.2024064-12-maz@kernel.org>
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

When using hVHE, we end-up with two TTBRs at EL2. That's great,
but we're not quite ready for this just yet.

Disable TTBR1_EL2 by setting TCR_EL2.EPD1 so that we only
translate via TTBR0_EL2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c12276dd2cf4..35b32cb6faa5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1666,7 +1666,13 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 
 	params->mair_el2 = read_sysreg(mair_el1);
 
-	tcr = (read_sysreg(tcr_el1) & TCR_EL2_MASK) | TCR_EL2_RES1;
+	tcr = read_sysreg(tcr_el1);
+	if (cpus_have_final_cap(ARM64_KVM_HVHE)) {
+		tcr |= TCR_EPD1_MASK;
+	} else {
+		tcr &= TCR_EL2_MASK;
+		tcr |= TCR_EL2_RES1;
+	}
 	tcr &= ~TCR_T0SZ_MASK;
 	tcr |= TCR_T0SZ(hyp_va_bits);
 	params->tcr_el2 = tcr;
-- 
2.34.1

