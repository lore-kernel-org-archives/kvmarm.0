Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447E628F8
	for <kvmarm@lists.linux.dev>; Mon,  7 Nov 2022 08:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0108DC433D6;
	Mon,  7 Nov 2022 08:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667811298;
	bh=7DPVNhiI7e1H2rXRI4KKeHqneAlTPa1uIRZNpUo176c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XntbvzAdAajcxaf72wgefnCfBuLh11LAXu4AeSKuiiYYNpsPAnIaSGqLNiSpTH8/F
	 toq1XEPrO9W+6x9YPXRB6p8stq+rzwAIQ+YpijCiyzL/fTVLU1XQ49J9zxISNeczhZ
	 23gEQjLvhWI80QUERufiCbdUysDaamOYv1Ul5IZboqbc8SY4K4KVIUwOlVU/FFEKpO
	 G6kNj4ACzXhpQp7qhLOfk+P0iwrtDyTXwwBFroMZrNXDa6Ue2KAwaOghd9ZzUvvErh
	 ycGk/X3sxSD6nbx1ymTGnQ7MQdp0TsKk3viaDx89FYo8ux3L0oOogS2vRUAO0+RRKe
	 eN78PPvzutJyg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1orxuC-004KxX-0f;
	Mon, 07 Nov 2022 08:54:56 +0000
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
Subject: [PATCH v3 03/14] KVM: arm64: PMU: Always advertise the CHAIN event
Date: Mon,  7 Nov 2022 08:54:24 +0000
Message-ID: <20221107085435.2581641-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107085435.2581641-1-maz@kernel.org>
References: <20221107085435.2581641-1-maz@kernel.org>
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
Message-ID: <20221107085424.anYaEWC62FCHoDCWOMEzYBBzjJxnc0gb9HDaEzz3a28@z>

Even when the underlying HW doesn't offer the CHAIN event
(which happens with QEMU), we can always support it as we're
in control of the counter overflow.

Always advertise the event via PMCEID0_EL0.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index a38b3127f649..e63ed0c71a37 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -703,6 +703,8 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 
 	if (!pmceid1) {
 		val = read_sysreg(pmceid0_el0);
+		/* always support CHAIN */
+		val |= BIT(ARMV8_PMUV3_PERFCTR_CHAIN);
 		base = 0;
 	} else {
 		val = read_sysreg(pmceid1_el0);
-- 
2.34.1

