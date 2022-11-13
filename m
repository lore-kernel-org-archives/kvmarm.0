Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1AD320C
	for <kvmarm@lists.linux.dev>; Sun, 13 Nov 2022 16:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C9DC433D6;
	Sun, 13 Nov 2022 16:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668357530;
	bh=uaCgmifIBreXTDUwTirUoI4xpqLPVdzhNNhrEj8Q19k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPwBQ4001rAEaZ18/JxctwXqxfuPJT1Zv9dkjEytDu4tLM2cnjHgqMSOe6TroqiwH
	 xZ/vfQfk+DDV3MJnFWnzy4HxRrHEA5H7u8g1OjooDl4HvBDHaVwWRVip2qt+gCX0CC
	 cTzXX3X+BWyK2toowjqDmRjt2dz2ITX8CFEYfY1LZzOwY4N7kuYTtOnYFlvUmVX0GI
	 yL5TQT3YI/GGXQuhwgKWu6i6sXjBahH6pEFhPPHT45fh7t4a51fiTirYR5ltUPvK+4
	 f0ysEzdj26RwqGTUoB9gD6eyOdDZo5aEsrL0he5dHrrlGN92l+DMV9sOKAAut5kIDo
	 xQ3OymB6y4qRQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ouG0O-005oYZ-CT;
	Sun, 13 Nov 2022 16:38:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	<kvmarm@lists.cs.columbia.edu>,
	<kvmarm@lists.linux.dev>,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Ricardo Koller <ricarkol@google.com>,
	Reiji Watanabe <reijiw@google.com>
Subject: [PATCH v4 03/16] KVM: arm64: PMU: Always advertise the CHAIN event
Date: Sun, 13 Nov 2022 16:38:19 +0000
Message-ID: <20221113163832.3154370-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221113163832.3154370-1-maz@kernel.org>
References: <20221113163832.3154370-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20221113163819.jwuVUjTPoLa2De2pS15yWAkwof5K1Zvj9z6E2NPqs3c@z>

Even when the underlying HW doesn't offer the CHAIN event
(which happens with QEMU), we can always support it as we're
in control of the counter overflow.

Always advertise the event via PMCEID0_EL0.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 57765be69bea..69b67ab3c4bf 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -701,6 +701,8 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 
 	if (!pmceid1) {
 		val = read_sysreg(pmceid0_el0);
+		/* always support CHAIN */
+		val |= BIT(ARMV8_PMUV3_PERFCTR_CHAIN);
 		base = 0;
 	} else {
 		val = read_sysreg(pmceid1_el0);
-- 
2.34.1

